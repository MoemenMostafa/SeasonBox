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

/**
 * Triggered by a write to an item document.
 * Updates the 'itemCount' in the parent family document.
 */
exports.countItems = onDocumentWritten(
  {
    document: "families/{familyId}/items/{itemId}",
  },
  async (event) => {
    const familyId = event.params.familyId;
    const firestore = admin.firestore();
    const familyRef = firestore.collection("families").doc(familyId);

    // Increment if created, decrement if deleted
    let change = 0;
    if (!event.data.before.exists && event.data.after.exists) {
      change = 1;
    } else if (event.data.before.exists && !event.data.after.exists) {
      change = -1;
    }

    if (change !== 0) {
      try {
        await familyRef.update({
          itemCount: admin.firestore.FieldValue.increment(change),
        });
        console.log(`Updated itemCount for family ${familyId} by ${change}`);
      } catch (error) {
        console.error(`Error updating itemCount for family ${familyId}:`, error);
        // If family doc doesn't exist, we might need to create it or ignore
      }
    }

    return null;
  }
);

/**
 * Triggered by a write to a family member document.
 * Updates the 'memberCount' in the parent family document.
 */
exports.countMembers = onDocumentWritten(
  {
    document: "families/{familyId}/members/{memberId}",
  },
  async (event) => {
    const familyId = event.params.familyId;
    const firestore = admin.firestore();
    const familyRef = firestore.collection("families").doc(familyId);

    // Increment if created, decrement if deleted
    let change = 0;
    if (!event.data.before.exists && event.data.after.exists) {
      change = 1;
    } else if (event.data.before.exists && !event.data.after.exists) {
      change = -1;
    }

    if (change !== 0) {
      try {
        await familyRef.update({
          memberCount: admin.firestore.FieldValue.increment(change),
        });
        console.log(`Updated memberCount for family ${familyId} by ${change}`);
      } catch (error) {
        console.error(`Error updating memberCount for family ${familyId}:`, error);
      }
    }

    return null;
  }
);

/**
 * Callable function to update user profile securely.
 */
exports.updateUserProfile = onCall(async (request) => {
  const { uid, displayName, phoneNumber, photoURL, familyName, role, preferences } = request.data;

  // Verify the caller is authenticated and matches the UID
  if (!request.auth || request.auth.uid !== uid) {
    throw new HttpsError(
      'unauthenticated',
      'User must be authenticated and match the provided UID'
    );
  }

  const firestore = admin.firestore();
  const userRef = firestore.collection('users').doc(uid);

  const updateData = {};
  if (displayName !== undefined) updateData.displayName = displayName;
  if (phoneNumber !== undefined) updateData.phoneNumber = phoneNumber;
  if (photoURL !== undefined) updateData.photoURL = photoURL;
  if (familyName !== undefined) updateData.familyName = familyName;
  if (role !== undefined) updateData.role = role;
  if (preferences !== undefined) updateData.preferences = preferences;

  if (Object.keys(updateData).length === 0) {
    return { success: true, message: "No data to update" };
  }

  try {
    await userRef.update(updateData);
    console.log(`User profile updated for UID: ${uid}`);
    return { success: true };
  } catch (error) {
    console.error('Error in updateUserProfile:', error);
    throw new HttpsError('internal', error.message);
  }
});

/**
 * Callable function to join a family securely.
 */
exports.joinFamily = onCall(async (request) => {
  const { uid, email, familyCode } = request.data;

  if (!request.auth || request.auth.uid !== uid) {
    throw new HttpsError('unauthenticated', 'Unauthorized access');
  }

  const firestore = admin.firestore();

  try {
    const familyRef = firestore.collection('families').doc(familyCode);
    const familyDoc = await familyRef.get();
    if (!familyDoc.exists) {
      throw new HttpsError('not-found', 'Invalid Family Code');
    }

    // Verify invitation
    const inviteQuery = await familyRef
      .collection('members')
      .where('inviteEmail', '==', email)
      .where('inviteStatus', '==', 'pending')
      .limit(1)
      .get();

    if (inviteQuery.empty) {
      throw new HttpsError('permission-denied', 'No active invitation found');
    }

    const userRef = firestore.collection('users').doc(uid);
    const userDoc = await userRef.get();
    const displayName = userDoc.data()?.displayName || 'Member';

    const batch = firestore.batch();

    // 1. Delete invite
    batch.delete(inviteQuery.docs[0].ref);

    // 2. Add to Family Members
    batch.set(familyRef.collection('members').doc(uid), {
      id: uid,
      userId: uid,
      familyId: familyCode,
      name: displayName,
      role: 'member',
      birthdate: admin.firestore.Timestamp.fromDate(new Date()),
      gender: 'Unisex',
    });

    // 3. Update User's familyId
    batch.update(userRef, { familyId: familyCode });

    await batch.commit();
    return { success: true };
  } catch (error) {
    console.error('Error in joinFamily:', error);
    if (error.code) throw error;
    throw new HttpsError('internal', error.message);
  }
});

/**
 * Callable function to leave current family and revert to personal family.
 */
exports.leaveFamily = onCall(async (request) => {
  const { uid, currentFamilyId } = request.data;

  if (!request.auth || request.auth.uid !== uid) {
    throw new HttpsError('unauthenticated', 'Unauthorized access');
  }

  const firestore = admin.firestore();

  try {
    const batch = firestore.batch();
    const userRef = firestore.collection('users').doc(uid);

    if (uid === currentFamilyId) {
      // Disband own family
      const membersQuery = await firestore.collection('families').doc(uid).collection('members').get();
      membersQuery.forEach(doc => batch.delete(doc.ref));
    } else {
      // Regular leave
      batch.delete(firestore.collection('families').doc(currentFamilyId).collection('members').doc(uid));
    }

    // Ensure they are admin of personal family
    const userDoc = await userRef.get();
    const displayName = userDoc.data()?.displayName || 'Admin';

    batch.set(firestore.collection('families').doc(uid), { id: uid, settings: {} }, { merge: true });
    batch.set(firestore.collection('families').doc(uid).collection('members').doc(uid), {
      id: uid,
      userId: uid,
      familyId: uid,
      name: displayName,
      role: 'admin',
      birthdate: admin.firestore.Timestamp.fromDate(new Date()),
      gender: 'Unisex',
    });

    // Reset user document
    batch.update(userRef, { familyId: uid });

    await batch.commit();
    return { success: true };
  } catch (error) {
    console.error('Error in leaveFamily:', error);
    throw new HttpsError('internal', error.message);
  }
});
