import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _emailKey = 'biometric_email';
  static const String _passwordKey = 'biometric_password';
  static const String _enabledKey = 'biometric_enabled';

  Future<bool> isBiometricsAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to login',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );
    } on PlatformException {
      return false;
    }
  }

  Future<void> enableBiometricLogin(String email, String password) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
    await _storage.write(key: _enabledKey, value: 'true');
  }

  Future<void> disableBiometricLogin() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
    await _storage.write(key: _enabledKey, value: 'false');
  }

  Future<bool> isBiometricLoginEnabled() async {
    final String? enabled = await _storage.read(key: _enabledKey);
    return enabled == 'true';
  }

  Future<Map<String, String>?> getStoredCredentials() async {
    final String? email = await _storage.read(key: _emailKey);
    final String? password = await _storage.read(key: _passwordKey);

    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }
}
