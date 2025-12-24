const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineJsonSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const gmailConfig = defineJsonSecret("FUNCTIONS_CONFIG_EXPORT");

const APP_NAME = "SeasonBox";

/**
 * Triggered by a write to a family member document.
 * Checks if 'inviteStatus' is 'pending' and sends an invitation email.
 */
exports.sendFamilyInvitation = onDocumentWritten(
  {
    document: "families/{familyId}/members/{memberId}",
    secrets: [gmailConfig],
  },
  async (event) => {
    const newData = event.data && event.data.after ? event.data.after.data() : null;
    const oldData = event.data && event.data.before ? event.data.before.data() : null;

    // Exit if document was deleted
    if (!newData) {
      return null;
    }

    const inviteStatus = newData.inviteStatus;
    const inviteEmail = newData.inviteEmail;

    const wasPending = oldData && oldData.inviteStatus === "pending";
    const isPending = inviteStatus === "pending";
    const emailChanged = oldData && oldData.inviteEmail !== inviteEmail;

    // Check if lastInviteSent changed (indicating a resend request)
    const lastInviteSentChanged = oldData && newData.lastInviteSent &&
      (!oldData.lastInviteSent || newData.lastInviteSent._seconds !== oldData.lastInviteSent._seconds);

    if (isPending && inviteEmail && (!wasPending || emailChanged || lastInviteSentChanged)) {
      const familyId = event.params.familyId;
      const inviterName = newData.inviterName || 'A family member';
      return sendInvitationEmail(inviteEmail, familyId, inviterName);
    }

    return null;
  }
);

/**
 * Sends an invitation email.
 */
async function sendInvitationEmail(email, familyId, inviterName) {
  const gmailEmail = gmailConfig.value().gmail.email;
  const gmailPassword = gmailConfig.value().gmail.password;

  const mailTransport = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: gmailEmail,
      pass: gmailPassword,
    },
  });

  const mailOptions = {
    from: `${APP_NAME} <noreply@firebase.com>`,
    to: email,
    subject: `You have been invited to join ${APP_NAME}!`,
    html: `
      <h2>Welcome to ${APP_NAME}!</h2>
      <p><strong>${inviterName}</strong> has invited you to join their family on ${APP_NAME}.</p>
      <p>To join, please use the following Family ID when signing up or linking your account:</p>
      <h3>${familyId}</h3>
      <br>
      <p>Best regards,<br>The ${APP_NAME} Team</p>
    `,
  };

  try {
    await mailTransport.sendMail(mailOptions);
    console.log("Invitation email sent to:", email);
    // Optional: write back to Firestore that email was sent?
    // return admin.firestore().collection(...).doc(...).update({ inviteStatus: 'sent' }); 
    // keeping it 'pending' until they actually accept is fine.
  } catch (error) {
    console.error("There was an error while sending the email:", error);

    return null;

  }
}

/**
 * Triggered when a member is removed from a family (e.g. by admin).
 * Ensures the user's familyId is reset to their personal family (uid)
 * and they have admin access to it.
 */
exports.onMemberRemoved = onDocumentWritten(
  {
    document: "families/{familyId}/members/{memberId}",
  },
  async (event) => {
    const oldData = event.data && event.data.before ? event.data.before.data() : null;
    const newData = event.data && event.data.after ? event.data.after.data() : null;

    // Only proceed if document was DELETED (oldData exists, newData is null)
    if (!oldData || newData) {
      return null;
    }

    const memberId = event.params.memberId;
    const familyId = event.params.familyId;

    // Don't do anything if they were removed from their own personal family (unlikely but safe check)
    if (memberId === familyId) {
      return null;
    }

    console.log(`Member ${memberId} removed from family ${familyId}. Reverting to personal family.`);

    const firestore = admin.firestore();
    const userRef = firestore.collection('users').doc(memberId);

    // 1. Check if user currently points to this family
    const userSnap = await userRef.get();
    if (!userSnap.exists) return null;

    const userData = userSnap.data();
    if (userData.familyId === familyId) {
      // 2. Reset familyId to their own UID
      await userRef.update({
        familyId: memberId,
        role: 'admin' // Reset role to admin of their own family
      });

      // 3. Ensure personal family exists (or just the member record in it)
      const personalFamilyMemberRef = firestore
        .collection('families')
        .doc(memberId)
        .collection('members')
        .doc(memberId);

      await personalFamilyMemberRef.set({
        id: memberId,
        familyId: memberId,
        name: userData.displayName || 'Me',
        role: 'admin',
        birthdate: admin.firestore.Timestamp.fromDate(new Date()), // Default if missing
        gender: 'Unisex',
        // existing fields that might be useful? 
        // Probably cleaner to just create a new fresh admin record.
      }, { merge: true });

      console.log(`User ${memberId} reverted to personal family ${memberId}`);
    }

    return null;
  }
);

/**
 * Callable function to create user profile and join/create family.
 * This runs with admin privileges, bypassing client-side permission issues.
 */

exports.createUserAndJoinFamily = onCall(async (request) => {
  const { uid, email, displayName, familyCode } = request.data;

  // Verify the caller is authenticated and matches the UID
  if (!request.auth || request.auth.uid !== uid) {
    throw new HttpsError(
      'unauthenticated',
      'User must be authenticated and match the provided UID'
    );
  }

  const firestore = admin.firestore();
  let targetFamilyId = familyCode || uid;

  try {
    // If family code provided, verify it exists
    if (familyCode) {
      const familyDoc = await firestore.collection('families').doc(familyCode).get();
      if (!familyDoc.exists) {
        throw new HttpsError('not-found', 'Invalid Family Code');
      }
    }

    // Create user document
    await firestore.collection('users').doc(uid).set({
      uid,
      email,
      displayName,
      familyId: targetFamilyId,
      role: 'member',
    }, { merge: true });

    if (targetFamilyId === uid) {
      // Creating personal family
      await firestore.collection('families').doc(uid).set({
        id: uid,
        settings: {},
      });

      // Add user as admin of their own family
      await firestore
        .collection('families')
        .doc(uid)
        .collection('members')
        .doc(uid)
        .set({
          id: uid,
          userId: uid,
          familyId: uid,
          name: displayName || 'Admin',
          role: 'admin',
          birthdate: admin.firestore.Timestamp.fromDate(new Date()),
          gender: 'Unisex',
        });

      return { success: true, familyId: uid, role: 'admin' };
    } else {
      // Joining existing family
      // Check for pending invite
      const inviteQuery = await firestore
        .collection('families')
        .doc(targetFamilyId)
        .collection('members')
        .where('inviteEmail', '==', email)
        .where('inviteStatus', '==', 'pending')
        .limit(1)
        .get();

      if (inviteQuery.empty) {
        throw new HttpsError(
          'permission-denied',
          'No active invitation found for this family'
        );
      }

      const batch = firestore.batch();

      // Delete pending invite
      batch.delete(inviteQuery.docs[0].ref);

      // Create member document
      const memberRef = firestore
        .collection('families')
        .doc(targetFamilyId)
        .collection('members')
        .doc(uid);

      batch.set(memberRef, {
        id: uid,
        userId: uid,
        familyId: targetFamilyId,
        name: displayName || 'Member',
        role: 'member',
        birthdate: admin.firestore.Timestamp.fromDate(new Date()),
        gender: 'Unisex',
      });

      await batch.commit();

      return { success: true, familyId: targetFamilyId, role: 'member' };
    }
  } catch (error) {
    console.error('Error in createUserAndJoinFamily:', error);
    if (error.code) {
      throw error; // Re-throw HttpsError
    }
    throw new HttpsError('internal', error.message);
  }
});
