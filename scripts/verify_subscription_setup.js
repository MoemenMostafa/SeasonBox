/**
 * Verification script for SeasonBox Subscription Setup.
 * This script checks if the necessary Pub/Sub topics and secrets are configured.
 */

const admin = require("firebase-admin");
admin.initializeApp();

async function verifySetup() {
    console.log("--- SeasonBox Subscription Setup Verification ---");

    // 1. Check for Pub/Sub topic
    console.log("\n[1/3] Checking Pub/Sub topic...");
    try {
        const { PubSub } = require("@google-cloud/pubsub");
        const pubsub = new PubSub();
        const topicName = "google-play-subscriptions";
        const [topic] = await pubsub.topic(topicName).get();
        console.log(`✅ Topic '${topic.name}' exists.`);
    } catch (error) {
        console.error(`❌ Error finding Pub/Sub topic: ${error.message}`);
        console.log("Tip: Create the topic named 'google-play-subscriptions' in your Google Cloud Console.");
    }

    // 2. Check for Firebase Secret
    console.log("\n[2/3] Checking Firebase Secret 'GOOGLE_PLAY_CREDENTIALS'...");
    try {
        // Note: We can't easily check secret values from a script without specific IAM permissions
        // but we can check if the Cloud Function mentions it.
        console.log("⚠️ Verification of secret presence must be done via CLI: 'firebase functions:secrets:get GOOGLE_PLAY_CREDENTIALS'");
    } catch (error) {
        console.error(`❌ Error checking secret: ${error.message}`);
    }

    // 3. Verify Package Name consistency
    console.log("\n[3/3] Verifying Package Name...");
    const expectedPackageName = "io.mos.seasonbox";
    console.log(`ℹ️ Your functions are configured for: ${expectedPackageName}`);
    console.log("Ensure this matches your 'namespace' in android/app/build.gradle.kts and your Play Console app.");

    console.log("\n--- Verification Finished ---");
}

verifySetup().catch(console.error);
