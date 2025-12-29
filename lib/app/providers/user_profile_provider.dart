import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/data/services/subscription_service.dart';
import 'package:seasonbox/data/models/app_user.dart';
import 'package:seasonbox/data/services/posthog_service.dart';

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
    // Listen to AuthService changes (includes Demo Mode toggle)
    _authService.addListener(_handleAuthChange);

    // Initial check
    _handleAuthChange();
  }

  void _handleAuthChange() {
    final currentUid = _authService.currentUid;

    if (currentUid == 'demo_user') {
      _userSubscription?.cancel();
      _userData = {
        'uid': 'demo_user',
        'displayName': 'David Miller',
        'email': 'david.miller@example.com',
        'photoURL': 'assets/images/demo/dad.png',
        'familyId': 'demo_family',
        'familyName': 'The Millers',
        'role': 'Parent',
        'preferences': {
          'measurementSystem': 'metric',
          'statusTrackingEnabled': true,
          'quickAddItemEnabled': true,
        }
      };
      notifyListeners();
    } else if (currentUid != null) {
      // Only start listening if uid changed or we weren't listening
      // But currentUid might be same if user didn't change.
      // Ideally we check if we are already listening to this uid.
      // For simplicity, we can just restart listener or checking if it changed.
      // However, since we don't store current listened uid, let's just restart for now.
      // Optimization: store _currentListenedUid.
      _startListening(currentUid);

      final user = _authService.currentUser;
      if (user != null) {
        PostHogService().identify(
          userId: user.uid,
          userProperties: {
            if (user.email != null) 'email': user.email!,
            'sign_in_method': 'auto_login',
          },
        );
      }
    } else {
      _userSubscription?.cancel();
      _userData = null;
      notifyListeners();
    }
  }

  void _startListening(String uid) {
    _userSubscription?.cancel();
    _userSubscription = _userService.getUserStream(uid).listen((snapshot) {
      if (snapshot.exists) {
        _userData = snapshot.data() as Map<String, dynamic>?;
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  Map<String, dynamic>? get userData => _userData;

  AppUser? get appUser {
    if (_userData == null) return null;
    return AppUser.fromMap(_userData!, _authService.currentUid ?? '');
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
