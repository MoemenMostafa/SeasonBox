import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/data/services/subscription_service.dart';
import 'package:seasonbox/data/models/app_user.dart';

class UserProfileProvider with ChangeNotifier {
  final UserService _userService;
  final AuthService _authService;
  final SubscriptionService _subscriptionService;

  StreamSubscription<DocumentSnapshot>? _userSubscription;
  Map<String, dynamic>? _userData;

  UserProfileProvider(
      this._userService, this._authService, this._subscriptionService) {
    _init();
  }

  void _init() {
    // Handle already logged in state
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      _startListening(currentUser.uid);
    }

    // Listen to auth state changes for future transitions
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        _startListening(user.uid);
      } else {
        _userSubscription?.cancel();
        _userData = null;
        notifyListeners();
      }
    });
  }

  void _startListening(String uid) {
    _userSubscription?.cancel();
    _userSubscription = _userService.getUserStream(uid).listen((snapshot) {
      _userData = snapshot.data() as Map<String, dynamic>?;
      notifyListeners();
    });
  }

  Map<String, dynamic>? get userData => _userData;

  AppUser? get appUser {
    if (_userData == null) return null;
    return AppUser.fromMap(_userData!, _authService.currentUser?.uid ?? '');
  }

  bool get isPremium {
    final user = appUser;
    if (user == null) return false;
    return _subscriptionService.isPremium(user);
  }

  String get measurementSystem {
    if (_userData == null || _userData!['preferences'] == null) {
      return 'imperial'; // Default
    }
    return _userData!['preferences']['measurementSystem'] ?? 'imperial';
  }

  bool get isMetric => measurementSystem == 'metric';

  bool get statusTrackingEnabled {
    if (_userData == null || _userData!['preferences'] == null) {
      return false; // Default: disabled
    }
    return _userData!['preferences']['statusTrackingEnabled'] ?? false;
  }

  bool get quickAddItemEnabled {
    if (_userData == null || _userData!['preferences'] == null) {
      return false; // Default: disabled
    }
    return _userData!['preferences']['quickAddItemEnabled'] ?? false;
  }

  Future<void> toggleStatusTracking() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return;

    final currentPrefs =
        _userData?['preferences'] as Map<String, dynamic>? ?? {};
    final newPrefs = Map<String, dynamic>.from(currentPrefs);
    newPrefs['statusTrackingEnabled'] = !statusTrackingEnabled;

    await _userService.updateUserProfile(
      uid: currentUser.uid,
      preferences: newPrefs,
    );
  }

  Future<void> toggleQuickAddItem() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return;

    final currentPrefs =
        _userData?['preferences'] as Map<String, dynamic>? ?? {};
    final newPrefs = Map<String, dynamic>.from(currentPrefs);
    newPrefs['quickAddItemEnabled'] = !quickAddItemEnabled;

    await _userService.updateUserProfile(
      uid: currentUser.uid,
      preferences: newPrefs,
    );
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
