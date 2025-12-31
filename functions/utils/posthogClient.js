const { PostHog } = require("posthog-node");

const POSTHOG_API_KEY = "phc_U0I4o4YSC2QCcOKDp7TCjYpxmixIZc16vLSSwGEQ7m";
const POSTHOG_HOST = "https://eu.i.posthog.com";

let client = null;

/**
 * Returns a initialized PostHog client singleton.
 * @return {PostHog} The PostHog client instance.
 */
function getPostHogClient() {
  if (!client) {
    client = new PostHog(POSTHOG_API_KEY, {
      host: POSTHOG_HOST,
      flushAt: 1, // Flush immediately in serverless environment
      flushInterval: 0,
    });
  }
  return client;
}

/**
 * Flushes pending events. call this before function termination.
 * @return {Promise<void>}
 */
async function flushPostHog() {
  if (client) {
    await client.shutdown(); // This flushes and clears the client
    client = null; // Reset for next execution context if reused
  }
}

module.exports = {
  getPostHogClient,
  flushPostHog,
};
