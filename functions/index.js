const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

// Configure the email transport using the default SMTP transport and a GMail account.
// For other services (e.g. SendGrid, Mailgun), check their respective documentations.
// You need to enable "Less secure apps" or generate an App Password for Gmail.
// Ideally, use environment variables for sensitive info:
// firebase functions:config:set gmail.email="my-email@gmail.com" gmail.password="generated-app-password"
const gmailEmail = functions.config().gmail?.email;
const gmailPassword = functions.config().gmail?.password;

const mailTransport = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

const APP_NAME = "SeasonBox";

/**
 * Triggered by a write to a family member document.
 * Checks if 'inviteStatus' is 'pending' and sends an invitation email.
 */
exports.sendFamilyInvitation = functions.firestore
    .document("families/{familyId}/members/{memberId}")
    .onWrite(async (change, context) => {
      const newData = change.after.exists ? change.after.data() : null;
      const oldData = change.before.exists ? change.before.data() : null;

      // Exit if document was deleted
      if (!newData) {
        return null;
      }

      const inviteStatus = newData.inviteStatus;
      const inviteEmail = newData.inviteEmail;
      // Check if status changed to pending or if it is a new doc with pending status
      // checking if email is present
      const wasPending = oldData && oldData.inviteStatus === "pending";
      const isPending = inviteStatus === "pending";

      // If strict trigger on status change:
      // if ((!wasPending && isPending) || (isPending && !oldData)) { ... }
      
      // We will trigger if it is pending and we haven't 'processed' it yet?
      // Simpler: if it IS pending, and (wasNOT pending OR didn't exist OR email changed)
      const emailChanged = oldData && oldData.inviteEmail !== inviteEmail;

      if (isPending && inviteEmail && (!wasPending || emailChanged)) {
        const familyId = context.params.familyId;
        
        // Fetch family name/info if needed
        // const familySnapshot = await admin.firestore().collection('families').doc(familyId).get();
        // const familyName = familySnapshot.data().name; 

        return sendInvitationEmail(inviteEmail, familyId);
      }

      return null;
    });

/**
 * Sends an invitation email.
 */
async function sendInvitationEmail(email, familyId) {
  const mailOptions = {
    from: `${APP_NAME} <noreply@firebase.com>`,
    to: email,
    subject: `You have been invited to join ${APP_NAME}!`,
    html: `
      <h2>Welcome to ${APP_NAME}!</h2>
      <p>You have been invited to join a family on ${APP_NAME}.</p>
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
  }
  return null;
}
