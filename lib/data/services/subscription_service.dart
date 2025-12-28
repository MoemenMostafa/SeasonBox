import '../models/app_user.dart';
import '../models/family.dart';
import 'remote_config_service.dart';

class SubscriptionService {
  static const int freeTierItemLimit = 50;
  static const int freeTierMemberLimit = 4;

  final RemoteConfigService _remoteConfigService;

  SubscriptionService(this._remoteConfigService);

  /// Checks if a user is within their item limit.
  bool canAddItem(AppUser user, Family family) {
    if (isPremium(user)) return true;
    return family.itemCount < freeTierItemLimit;
  }

  /// Checks if a user can add more members.
  bool canAddMember(AppUser user, int currentMemberCount) {
    if (isPremium(user)) return true;
    return currentMemberCount < freeTierMemberLimit;
  }

  /// Gets the photo limit per item based on user tier.
  int getPhotoLimit(AppUser user) {
    return isPremium(user) ? 3 : 1;
  }

  /// Checks if a user is Premium.
  bool isPremium(AppUser user) {
    return user.subscriptionTier == 'paid';
  }

  /// Gets the dynamic price for the paid tier from Remote Config.
  Map<String, String> getPricing() {
    return _remoteConfigService.getSubscriptionPricing();
  }

  /// Checks if a feature is available for the user.
  bool isFeatureAvailable(String featureId, AppUser user) {
    switch (featureId) {
      case 'family_sharing':
      case 'growth_advice':
      case 'seasonal_reminders':
        return isPremium(user);
      default:
        return true;
    }
  }
}
