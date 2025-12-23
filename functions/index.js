const { onDocumentWritten } = require("firebase-functions/v2/firestore");
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
  }
  return null;
}
