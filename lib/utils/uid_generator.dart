import 'dart:math';

/// Utility class for generating Firebase-compatible UIDs.
class UidGenerator {
  static const String _chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  static final Random _random = Random.secure();

  /// Generates a Firebase-compatible UID (28 characters).
  /// This format matches Firebase Auth user IDs, allowing family members
  /// to be promoted to full users later.
  static String generate() {
    return List.generate(28, (_) => _chars[_random.nextInt(_chars.length)])
        .join();
  }
}
