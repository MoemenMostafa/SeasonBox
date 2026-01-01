const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onMessagePublished } = require("firebase-functions/v2/pubsub");
const { defineJsonSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const { getPostHogClient, flushPostHog } = require("./utils/posthogClient");
const { logger } = require("./utils/logger");

admin.initializeApp();

const gmailConfig = defineJsonSecret("FUNCTIONS_CONFIG_EXPORT");
const playConfig = defineJsonSecret("GOOGLE_PLAY_CREDENTIALS");

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
      const inviterName = newData.inviterName || "A family member";
      return sendInvitationEmail(inviteEmail, familyId, inviterName);
    }

    return null;
  },
);

/**
 * Sends an invitation email.
 * @param {string} email The destination email address.
 * @param {string} familyId The ID of the family.
 * @param {string} inviterName The name of the inviter.
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
    await logger.info(`Invitation email sent to: ${email}`);
    // Optional: write back to Firestore that email was sent?
    // return admin.firestore().collection(...).doc(...).update({ inviteStatus: 'sent' });
    // keeping it 'pending' until they actually accept is fine.

    const posthog = getPostHogClient();
    posthog.capture({
      distinctId: inviterName, // Using name as ID is not ideal, but we lack UID here. Maybe use familyId temporarily.
      event: "invitation_email_sent",
      properties: {
        recipient_email: email,
        family_id: familyId,
      },
    });
    await flushPostHog();
  } catch (error) {
    await logger.error(`There was an error while sending the email: ${error.message}`, { context: { error } });

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

    await logger.info(`Member ${memberId} removed from family ${familyId}. Reverting to personal family.`);

    const firestore = admin.firestore();
    const userRef = firestore.collection("users").doc(memberId);

    // 1. Check if user currently points to this family
    const userSnap = await userRef.get();
    if (!userSnap.exists) return null;

    const userData = userSnap.data();
    if (userData.familyId === familyId) {
      // 2. Reset familyId to their own UID
      await userRef.update({
        familyId: memberId,
        role: "admin", // Reset role to admin of their own family
      });

      // 3. Ensure personal family exists (or just the member record in it)
      const personalFamilyMemberRef = firestore
        .collection("families")
        .doc(memberId)
        .collection("members")
        .doc(memberId);

      await personalFamilyMemberRef.set({
        id: memberId,
        familyId: memberId,
        name: userData.displayName || "Me",
        role: "admin",
        birthdate: admin.firestore.Timestamp.fromDate(new Date()), // Default if missing
        gender: "Unisex",
        // existing fields that might be useful?
        // Probably cleaner to just create a new fresh admin record.
      }, { merge: true });

      await logger.info(`User ${memberId} reverted to personal family ${memberId}`, { uid: memberId });
    }

    return null;
  },
);

/**
 * Callable function to create user profile and join/create family.
 * This runs with admin privileges, bypassing client-side permission issues.
 */

exports.createUserAndJoinFamily = onCall(async (request) => {
  const { uid, email, displayName, familyCode, sessionId } = request.data;

  // Verify the caller is authenticated and matches the UID
  if (!request.auth || request.auth.uid !== uid) {
    throw new HttpsError(
      "unauthenticated",
      "User must be authenticated and match the provided UID",
    );
  }

  const firestore = admin.firestore();
  const targetFamilyId = familyCode || uid;

  try {
    // If family code provided, verify it exists
    if (familyCode) {
      const familyDoc = await firestore.collection("families").doc(familyCode).get();
      if (!familyDoc.exists) {
        throw new HttpsError("not-found", "Invalid Family Code");
      }
    }

    // Create user document
    await firestore.collection("users").doc(uid).set({
      uid,
      email,
      displayName,
      familyId: targetFamilyId,
      role: "member",
      activeSessionId: sessionId,
    }, { merge: true });

    if (targetFamilyId === uid) {
      // Creating personal family
      await firestore.collection("families").doc(uid).set({
        id: uid,
        settings: {},
      });

      // Add user as admin of their own family
      await firestore
        .collection("families")
        .doc(uid)
        .collection("members")
        .doc(uid)
        .set({
          id: uid,
          userId: uid,
          familyId: uid,
          name: displayName || "Admin",
          role: "admin",
          birthdate: admin.firestore.Timestamp.fromDate(new Date()),
          gender: "Unisex",
        });

      return { success: true, familyId: uid, role: "admin" };
    } else {
      // Joining existing family
      // Check for pending invite
      const inviteQuery = await firestore
        .collection("families")
        .doc(targetFamilyId)
        .collection("members")
        .where("inviteEmail", "==", email)
        .where("inviteStatus", "==", "pending")
        .limit(1)
        .get();

      if (inviteQuery.empty) {
        throw new HttpsError(
          "permission-denied",
          "No active invitation found for this family",
        );
      }

      const batch = firestore.batch();

      // Delete pending invite
      batch.delete(inviteQuery.docs[0].ref);

      // Create member document
      const memberRef = firestore
        .collection("families")
        .doc(targetFamilyId)
        .collection("members")
        .doc(uid);

      batch.set(memberRef, {
        id: uid,
        userId: uid,
        familyId: targetFamilyId,
        name: displayName || "Member",
        role: "member",
        birthdate: admin.firestore.Timestamp.fromDate(new Date()),
        gender: "Unisex",
      });

      await batch.commit();

      const posthog = getPostHogClient();
      posthog.capture({
        distinctId: uid,
        event: "family_joined",
        properties: {
          $session_id: sessionId,
          family_id: targetFamilyId,
          role: "member",
          method: "create_user_flow",
        },
      });
      await flushPostHog();

      return { success: true, familyId: targetFamilyId, role: "member" };
    }
  } catch (error) {
    await logger.error(`Error in createUserAndJoinFamily: ${error.message}`, { context: { error } });
    const posthog = getPostHogClient();
    posthog.capture({
      distinctId: uid || "unknown_uid",
      event: "user_creation_failed",
      properties: {
        $session_id: sessionId,
        error: error.message,
        email: email,
      },
    });
    await flushPostHog();

    if (error.code) {
      throw error; // Re-throw HttpsError
    }
    throw new HttpsError("internal", error.message);
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
        await logger.info(`Updated itemCount for family ${familyId} by ${change}`);
      } catch (error) {
        await logger.error(`Error updating itemCount for family ${familyId}: ${error.message}`, { context: { error } });
        // If family doc doesn't exist, we might need to create it or ignore
      }
    }

    return null;
  },
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
        await logger.info(`Updated memberCount for family ${familyId} by ${change}`);
      } catch (error) {
        await logger.error(`Error updating memberCount for family ${familyId}: ${error.message}`, { context: { error } });
      }
    }

    return null;
  },
);

/**
 * Callable function to update user profile securely.
 */
exports.updateUserProfile = onCall(async (request) => {
  const { uid, displayName, photoURL, familyName, role, preferences, sessionId } = request.data;

  // Verify the caller is authenticated and matches the UID
  if (!request.auth || request.auth.uid !== uid) {
    throw new HttpsError(
      "unauthenticated",
      "User must be authenticated and match the provided UID",
    );
  }

  const firestore = admin.firestore();
  const userRef = firestore.collection("users").doc(uid);

  const updateData = {};
  if (displayName !== undefined) updateData.displayName = displayName;
  if (photoURL !== undefined) updateData.photoURL = photoURL;
  if (familyName !== undefined) updateData.familyName = familyName;
  if (role !== undefined) updateData.role = role;
  if (preferences !== undefined) updateData.preferences = preferences;

  if (Object.keys(updateData).length === 0) {
    return { success: true, message: "No data to update" };
  }

  try {
    await userRef.update(updateData);
    await logger.info(`User profile updated for UID: ${uid}`, { uid });

    const posthog = getPostHogClient();
    posthog.capture({
      distinctId: uid,
      event: "user_profile_updated",
      properties: {
        $session_id: sessionId,
        updated_fields: Object.keys(updateData),
      },
    });

    if (sessionId) {
      await userRef.update({ activeSessionId: sessionId });
    }
    await flushPostHog();

    return { success: true };
  } catch (error) {
    await logger.error(`Error in updateUserProfile: ${error.message}`, { uid, context: { error } });
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Callable function to join a family securely.
 */
exports.joinFamily = onCall(async (request) => {
  const { uid, email, familyCode, sessionId } = request.data;

  if (!request.auth || request.auth.uid !== uid) {
    throw new HttpsError("unauthenticated", "Unauthorized access");
  }

  const firestore = admin.firestore();

  try {
    const familyRef = firestore.collection("families").doc(familyCode);
    const familyDoc = await familyRef.get();
    if (!familyDoc.exists) {
      throw new HttpsError("not-found", "Invalid Family Code");
    }

    // Verify invitation
    const inviteQuery = await familyRef
      .collection("members")
      .where("inviteEmail", "==", email)
      .where("inviteStatus", "==", "pending")
      .limit(1)
      .get();

    if (inviteQuery.empty) {
      throw new HttpsError("permission-denied", "No active invitation found");
    }

    const userRef = firestore.collection("users").doc(uid);
    const userDoc = await userRef.get();
    const displayName = userDoc.data()?.displayName || "Member";

    const batch = firestore.batch();

    // 1. Delete invite
    batch.delete(inviteQuery.docs[0].ref);

    // 2. Add to Family Members
    batch.set(familyRef.collection("members").doc(uid), {
      id: uid,
      userId: uid,
      familyId: familyCode,
      name: displayName,
      role: "member",
      birthdate: admin.firestore.Timestamp.fromDate(new Date()),
      gender: "Unisex",
    });

    // 3. Update User's familyId
    batch.update(userRef, {
      familyId: familyCode,
      activeSessionId: sessionId || admin.firestore.FieldValue.delete(), // update if provided
    });

    await batch.commit();

    const posthog = getPostHogClient();
    posthog.capture({
      distinctId: uid,
      event: "family_joined",
      properties: {
        $session_id: sessionId,
        family_id: familyCode,
        role: "member",
        method: "join_family_flow",
      },
    });
    await flushPostHog();

    return { success: true };
  } catch (error) {
    await logger.error(`Error in joinFamily: ${error.message}`, { context: { error } });
    if (error.code) throw error;
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Callable function to leave current family and revert to personal family.
 */
exports.leaveFamily = onCall(async (request) => {
  const { uid, currentFamilyId, sessionId } = request.data;

  if (!request.auth || request.auth.uid !== uid) {
    throw new HttpsError("unauthenticated", "Unauthorized access");
  }

  const firestore = admin.firestore();

  try {
    const batch = firestore.batch();
    const userRef = firestore.collection("users").doc(uid);

    if (uid === currentFamilyId) {
      // Disband own family
      const membersQuery = await firestore.collection("families").doc(uid).collection("members").get();
      membersQuery.forEach((doc) => batch.delete(doc.ref));
    } else {
      // Regular leave
      batch.delete(firestore.collection("families").doc(currentFamilyId).collection("members").doc(uid));
    }

    // Ensure they are admin of personal family
    const userDoc = await userRef.get();
    const displayName = userDoc.data()?.displayName || "Admin";

    batch.set(firestore.collection("families").doc(uid), { id: uid, settings: {} }, { merge: true });
    batch.set(firestore.collection("families").doc(uid).collection("members").doc(uid), {
      id: uid,
      userId: uid,
      familyId: uid,
      name: displayName,
      role: "admin",
      birthdate: admin.firestore.Timestamp.fromDate(new Date()),
      gender: "Unisex",
    });

    // Reset user document
    batch.update(userRef, { familyId: uid });

    await batch.commit();

    const posthog = getPostHogClient();
    posthog.capture({
      distinctId: uid,
      event: "family_left",
      properties: {
        $session_id: sessionId,
        left_family_id: currentFamilyId,
        new_family_id: uid, // Reverted to personal
      },
    });
    await flushPostHog();

    return { success: true };
  } catch (error) {
    await logger.error(`Error in leaveFamily: ${error.message}`, { context: { error } });
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Helper to collect all valid image storage paths from Firestore.
 */
async function getValidStoragePaths() {
  const firestore = admin.firestore();
  const validPaths = new Set();

  // 1. Collect from users (photoURL)
  const usersSnap = await firestore.collection("users").get();
  for (const doc of usersSnap.docs) {
    const data = doc.data();
    if (data.photoURL) {
      const path = await extractPathFromUrl(data.photoURL);
      if (path) validPaths.add(path);
    }
  }

  // 2. Collect from family members (photoUrl)
  const membersSnap = await firestore.collectionGroup("members").get();
  for (const doc of membersSnap.docs) {
    const data = doc.data();
    if (data.photoUrl) {
      const path = await extractPathFromUrl(data.photoUrl);
      if (path) validPaths.add(path);
    }
  }

  // 3. Collect from items (photos: list of {full, thumb})
  const itemsSnap = await firestore.collectionGroup("items").get();
  for (const doc of itemsSnap.docs) {
    const data = doc.data();
    if (Array.isArray(data.photos)) {
      for (const photo of data.photos) {
        if (photo.full) {
          const path = await extractPathFromUrl(photo.full);
          if (path) validPaths.add(path);
        }
        if (photo.thumb) {
          const path = await extractPathFromUrl(photo.thumb);
          if (path) validPaths.add(path);
        }
      }
    }
  }

  return validPaths;
}

/**
 * Extracts the storage path from a Firebase Storage download URL.
 * @param {string} url The download URL.
 * @return {string|null} The storage path or null if invalid.
 */
async function extractPathFromUrl(url) {
  try {
    if (!url || !url.includes("/o/")) return null;
    const parts = url.split("/o/")[1].split("?")[0];
    return decodeURIComponent(parts);
  } catch (e) {
    await logger.error(`Error extracting path from URL: ${url}`, { context: { error: e } });
    return null;
  }
}

/**
 * Core logic to identify and optionally delete orphaned images.
 * @param {boolean} dryRun Whether to actually delete or just report.
 * @return {Promise<Object>} The cleanup result.
 */
async function performStorageCleanup(dryRun = true) {
  const bucket = admin.storage().bucket();
  const validPaths = await getValidStoragePaths();
  const orphanedFiles = [];
  const now = Date.now();
  const oneDayAgo = now - 24 * 60 * 60 * 1000;

  // List all files in the 'users/' prefix
  const [files] = await bucket.getFiles({ prefix: "users/" });

  for (const file of files) {
    // Skip if file is recently created (less than 24 hours) to avoid race conditions
    const [metadata] = await file.getMetadata();
    const createdAt = new Date(metadata.timeCreated).getTime();
    if (createdAt > oneDayAgo) continue;

    if (!validPaths.has(file.name)) {
      orphanedFiles.push(file.name);
      if (!dryRun) {
        try {
          await file.delete();
          await logger.info(`Deleted orphaned storage image: ${file.name}`);
        } catch (e) {
          await logger.error(`Failed to delete orphaned image: ${file.name}`, { context: { error: e } });
        }
      }
    }
  }

  return {
    orphanedCount: orphanedFiles.length,
    orphanedFiles: orphanedFiles,
    dryRun,
  };
}

/**
 * Scheduled function to clean up orphaned images daily.
 */
const { onSchedule } = require("firebase-functions/v2/scheduler");
exports.cleanupStorage = onSchedule({
  schedule: "0 3 * * *",
  timeZone: "UTC",
}, async (event) => {
  await logger.info("Starting daily storage cleanup...");
  const result = await performStorageCleanup(false);
  await logger.info(`Cleanup finished. Deleted ${result.orphanedCount} orphaned images.`);
  return result;
});

exports.cleanupStorageDryRun = onCall(async (request) => {
  const { sessionId } = request.data;
  // Optional: check for admin role if needed
  await logger.info("Starting storage cleanup dry-run...", { sessionId });
  const result = await performStorageCleanup(true);
  return result;
});

/**
 * Handle Google Play Real-Time Developer Notifications (RTDN).
 * This function is triggered by a Pub/Sub message from Google Play.
 */
exports.googlePlayBillingWebhook = onMessagePublished({
  topic: "play-billing-events",
  secrets: [playConfig],
}, async (event) => {
  const message = event.data.message;
  const data = message.data ? Buffer.from(message.data, "base64").toString() : null;

  if (!data) {
    await logger.error("No data in RTDN message");
    return;
  }

  const notification = JSON.parse(data);
  await logger.info("Received Google Play Notification", { context: { notification } });

  const subNotification = notification.subscriptionNotification;
  if (!subNotification) {
    await logger.info("Not a subscription notification, skipping.");
    return;
  }

  const { subscriptionId, purchaseToken } = subNotification;
  // Note: notificationType 2 = PURCHASED, 3 = RENEWED, 4 = CANCELED, etc.
  // We should fetch the latest status from Google Play API to be sure.

  try {
    const posthog = getPostHogClient();
    posthog.capture({
      distinctId: "server_webhook_handler",
      event: "google_play_webhook_received",
      properties: {
        raw_notification: notification,
        subscription_id: subscriptionId,
        message_id: event.id,
      },
    });

    await logger.info("Processing Google Play Notification", {
      context: { subscriptionId, purchaseToken: purchaseToken.substring(0, 10) }
    });

    await updateSubscriptionStatus(subscriptionId, purchaseToken);
  } catch (error) {
    await logger.error(`Error updating subscription from RTDN: ${error.message}`, { context: { error } });
    const posthog = getPostHogClient();
    posthog.capture({
      distinctId: "server_webhook_handler",
      event: "google_play_webhook_error",
      properties: {
        error: error.message,
        subscription_id: subscriptionId,
      },
    });
  } finally {
    await flushPostHog();
  }
});

/**
 * Helper to update user subscription status in Firestore.
 * Fetches latest info from Google Play Developer API.
 * @param {string} subscriptionId The ID of the subscription.
 * @param {string} purchaseToken The token of the purchase.
 * @param {string} [targetUid] Optional UID to update directly, bypassing token lookup.
 * @param {string} [sessionId] Optional PostHog session ID to correlate events.
 */
async function updateSubscriptionStatus(subscriptionId, purchaseToken, targetUid, sessionId) {
  const { google } = require("googleapis");

  try {
    // 1. Authenticate with Google Play API
    await logger.info(`Authenticating for subscription ${subscriptionId}...`, { uid: targetUid, sessionId });
    const auth = new google.auth.GoogleAuth({
      credentials: playConfig.value(),
      scopes: ["https://www.googleapis.com/auth/androidpublisher"],
    });
    const androidpublisher = google.androidpublisher({ version: "v3", auth });

    // 2. Get Subscription status from Google Play
    await logger.info(`Fetching status for token ${purchaseToken.substring(0, 10)}...`, { uid: targetUid, sessionId });
    const res = await androidpublisher.purchases.subscriptions.get({
      packageName: "io.mos.seasonbox",
      subscriptionId: subscriptionId,
      token: purchaseToken,
    });

    const purchase = res.data;
    await logger.debug("Play Store Purchase Data", { uid: targetUid, sessionId, context: { purchase } });

    // expiryTimeMillis is the source of truth for expiration
    const expiryTimeMillis = parseInt(purchase.expiryTimeMillis);
    const isRevoked = purchase.cancelReason === 1; // 1 = Revoked by Google

    // Check if subscription is still valid
    const isValid = expiryTimeMillis > Date.now() && !isRevoked;

    // 3. Find user
    const firestore = admin.firestore();
    let userRef;

    if (targetUid) {
      userRef = firestore.collection("users").doc(targetUid);
    } else {
      // Fallback to token lookup (for RTDN webhooks)
      const userQuery = await firestore.collection("users")
        .where("activePurchaseToken", "==", purchaseToken)
        .limit(1)
        .get();

      if (userQuery.empty) {
        await logger.warn(`No user found with purchase token: ${purchaseToken.substring(0, 10)}...`);
        return;
      }
      userRef = userQuery.docs[0].ref;
    }

    const userDoc = await userRef.get();
    const userData = userDoc.data();
    const uid = userRef.id;
    const finalSessionId = sessionId || (userData ? userData.activeSessionId : null);

    await userRef.update({
      subscriptionTier: isValid ? "paid" : "free",
      subscriptionId: subscriptionId,
      subscriptionExpiry: admin.firestore.Timestamp.fromMillis(expiryTimeMillis),
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    });

    await logger.info(`Updated subscription for user ${uid} to ${isValid ? "paid" : "free"}`, { uid, sessionId: finalSessionId });

    const posthog = getPostHogClient();
    posthog.capture({
      distinctId: uid, // Correlate with the actual user
      event: "subscription_status_updated",
      properties: {
        $session_id: finalSessionId,
        status: isValid ? "paid" : "free",
        subscription_id: subscriptionId,
        expiry_time: expiryTimeMillis,
        is_revoked: isRevoked,
        cancel_reason: purchase.cancelReason,
        payment_state: purchase.paymentState,
        source: "google_play_rtdn",
      },
    });
  } catch (error) {
    await logger.error(`Error calling Google Play API Details: ${error.message}`, {
      uid: targetUid,
      sessionId,
      context: {
        code: error.code,
        errors: error.errors,
        subscriptionId: subscriptionId,
      },
    });
    throw error;
  }
}

/**
 * Callable function to verify a purchase manually from the app.
 * Used for reactive UI update after purchase.
 */
exports.verifyPurchase = onCall({
  secrets: [playConfig],
}, async (request) => {
  const { uid, subscriptionId, purchaseToken, sessionId } = request.data;

  if (!request.auth || request.auth.uid !== uid) {
    throw new HttpsError("unauthenticated", "Unauthorized");
  }

  // Store the active token and session ID so webhooks can find the user/session later
  const firestore = admin.firestore();
  await firestore.collection("users").doc(uid).update({
    activePurchaseToken: purchaseToken,
    activeSessionId: sessionId,
  });

  try {
    // Pass uid directly to avoid race condition with the update above
    await updateSubscriptionStatus(subscriptionId, purchaseToken, uid, sessionId);
    return { success: true };
  } catch (error) {
    await logger.error(`Error in verifyPurchase: ${error.message}`, { uid, sessionId });
    throw new HttpsError("internal", error.message);
  }
});
