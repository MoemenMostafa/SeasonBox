const { getPostHogClient } = require("./posthogClient");

/**
 * Log levels mirroring the mobile app
 */
const LogLevel = {
  DEBUG: "debug",
  INFO: "info",
  WARNING: "warning",
  ERROR: "error",
};

/**
 * Internal log helper that prints to console and optionally captures in PostHog
 * @param {string} level The log level.
 * @param {string} message The log message.
 * @param {Object} [options] Optional parameters.
 * @param {string} [options.uid] The user ID.
 * @param {string} [options.sessionId] The session ID.
 * @param {Object} [options.context] Additional context.
 */
async function logInternal(level, message, { uid, sessionId, context } = {}) {
  const emoji = {
    [LogLevel.DEBUG]: "🔍",
    [LogLevel.INFO]: "ℹ️",
    [LogLevel.WARNING]: "⚠️",
    [LogLevel.ERROR]: "❌",
  }[level] || "📝";

  // 1. Standard Google Cloud Logging
  console.log(`${emoji} [${level.toUpperCase()}] ${message}`, JSON.stringify({ uid, sessionId, ...context }));

  // 2. PostHog Event
  try {
    const posthog = getPostHogClient();
    posthog.capture({
      distinctId: uid || "server_system",
      event: `backend_log_${level}`,
      properties: {
        level,
        message,
        $session_id: sessionId,
        ...context,
      },
    });
  } catch (err) {
    // Don't let logging failures crash the function
    console.error("Failed to push log to PostHog:", err);
  }
}

const logger = {
  debug: (msg, opts) => logInternal(LogLevel.DEBUG, msg, opts),
  info: (msg, opts) => logInternal(LogLevel.INFO, msg, opts),
  warn: (msg, opts) => logInternal(LogLevel.WARNING, msg, opts),
  error: (msg, opts) => logInternal(LogLevel.ERROR, msg, opts),
};

module.exports = { logger, LogLevel };
