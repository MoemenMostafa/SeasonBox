import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it')
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'SeasonBox'**
  String get appTitle;

  /// Main tagline on login screen
  ///
  /// In en, this message translates to:
  /// **'Organize seasonal items for your family with ease'**
  String get login_tagline;

  /// No description provided for @login_featureCard_photoInventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Inventory'**
  String get login_featureCard_photoInventoryTitle;

  /// No description provided for @login_featureCard_photoInventorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture and organize with photos'**
  String get login_featureCard_photoInventorySubtitle;

  /// No description provided for @login_featureCard_familySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Sharing'**
  String get login_featureCard_familySharingTitle;

  /// No description provided for @login_featureCard_familySharingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync across all family members'**
  String get login_featureCard_familySharingSubtitle;

  /// No description provided for @login_featureCard_smartRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Reminders'**
  String get login_featureCard_smartRemindersTitle;

  /// No description provided for @login_featureCard_smartRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Never miss seasonal changes'**
  String get login_featureCard_smartRemindersSubtitle;

  /// No description provided for @login_button_email.
  ///
  /// In en, this message translates to:
  /// **'Login with your Email'**
  String get login_button_email;

  /// No description provided for @login_button_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get login_button_google;

  /// No description provided for @login_button_biometric.
  ///
  /// In en, this message translates to:
  /// **'Login with Biometrics'**
  String get login_button_biometric;

  /// No description provided for @login_footer_terms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get login_footer_terms;

  /// No description provided for @login_footer_termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get login_footer_termsOfService;

  /// No description provided for @login_footer_and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get login_footer_and;

  /// No description provided for @login_footer_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get login_footer_privacyPolicy;

  /// No description provided for @login_error_googleCancelled.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In was cancelled or failed. Please try again.'**
  String get login_error_googleCancelled;

  /// Error message when sign-in fails
  ///
  /// In en, this message translates to:
  /// **'Sign-in error: {error}'**
  String login_error_signIn(String error);

  /// No description provided for @login_error_invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again.'**
  String get login_error_invalidCredentials;

  /// No description provided for @emailLogin_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get emailLogin_title;

  /// No description provided for @emailLogin_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get emailLogin_subtitle;

  /// No description provided for @emailLogin_field_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLogin_field_email;

  /// No description provided for @emailLogin_field_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get emailLogin_field_password;

  /// No description provided for @emailLogin_validation_emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailLogin_validation_emailRequired;

  /// No description provided for @emailLogin_validation_passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get emailLogin_validation_passwordRequired;

  /// No description provided for @emailLogin_button_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get emailLogin_button_forgotPassword;

  /// No description provided for @emailLogin_button_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get emailLogin_button_login;

  /// No description provided for @emailLogin_error_emailFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email first'**
  String get emailLogin_error_emailFirst;

  /// No description provided for @emailLogin_success_passwordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get emailLogin_success_passwordReset;

  /// No description provided for @emailLogin_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String emailLogin_error_generic(String error);

  /// No description provided for @home_appBar_subtitle.
  ///
  /// In en, this message translates to:
  /// **'{familyName} Family'**
  String home_appBar_subtitle(String familyName);

  /// No description provided for @home_stats_totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get home_stats_totalItems;

  /// No description provided for @home_stats_members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get home_stats_members;

  /// No description provided for @home_subscription_itemLimit.
  ///
  /// In en, this message translates to:
  /// **'Item Limit: {count} / {limit}'**
  String home_subscription_itemLimit(int count, int limit);

  /// No description provided for @home_subscription_upgradeForUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Upgrade for Unlimited'**
  String get home_subscription_upgradeForUnlimited;

  /// No description provided for @home_subscription_limitReached.
  ///
  /// In en, this message translates to:
  /// **'Item limit reached! Upgrade now.'**
  String get home_subscription_limitReached;

  /// No description provided for @home_premium_banner_title.
  ///
  /// In en, this message translates to:
  /// **'Unlock Unlimited Potential'**
  String get home_premium_banner_title;

  /// No description provided for @home_premium_banner_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage unlimited items and family members with SeasonBox Premium.'**
  String get home_premium_banner_subtitle;

  /// No description provided for @home_premium_banner_button.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get home_premium_banner_button;

  /// No description provided for @home_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search tiles, sizes, or #tag'**
  String get home_search_hint;

  /// No description provided for @home_search_hint_revamped.
  ///
  /// In en, this message translates to:
  /// **'Search by title, size, or #tag'**
  String get home_search_hint_revamped;

  /// No description provided for @home_section_quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get home_section_quickActions;

  /// No description provided for @home_section_familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get home_section_familyMembers;

  /// No description provided for @home_section_recentItems.
  ///
  /// In en, this message translates to:
  /// **'Recent Items'**
  String get home_section_recentItems;

  /// No description provided for @home_section_seasonalReminders.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Reminders'**
  String get home_section_seasonalReminders;

  /// No description provided for @home_section_storageLocations.
  ///
  /// In en, this message translates to:
  /// **'Storage Locations'**
  String get home_section_storageLocations;

  /// No description provided for @home_action_addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get home_action_addItem;

  /// No description provided for @home_action_scanQR.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get home_action_scanQR;

  /// No description provided for @home_action_viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get home_action_viewAll;

  /// No description provided for @home_action_manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get home_action_manage;

  /// No description provided for @home_member_age.
  ///
  /// In en, this message translates to:
  /// **'Age {age}'**
  String home_member_age(int age);

  /// No description provided for @home_member_size.
  ///
  /// In en, this message translates to:
  /// **'Size {size}'**
  String home_member_size(String size);

  /// No description provided for @home_member_items.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String home_member_items(int count);

  /// No description provided for @home_member_status_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get home_member_status_active;

  /// No description provided for @home_item_storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get home_item_storage;

  /// No description provided for @home_reminder_fallTitle.
  ///
  /// In en, this message translates to:
  /// **'Fall Season Approaching'**
  String get home_reminder_fallTitle;

  /// No description provided for @home_reminder_fallMessage.
  ///
  /// In en, this message translates to:
  /// **'Time to check fall clothes for your children. Consider size changes from last year.'**
  String get home_reminder_fallMessage;

  /// No description provided for @home_reminder_reviewItems.
  ///
  /// In en, this message translates to:
  /// **'Review Items'**
  String get home_reminder_reviewItems;

  /// No description provided for @home_error_loadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String home_error_loadingData(String error);

  /// No description provided for @addItem_title_add.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get addItem_title_add;

  /// No description provided for @addItem_title_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get addItem_title_edit;

  /// No description provided for @addItem_section_photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get addItem_section_photos;

  /// No description provided for @addItem_section_itemDetails.
  ///
  /// In en, this message translates to:
  /// **'Item Details'**
  String get addItem_section_itemDetails;

  /// No description provided for @addItem_section_size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get addItem_section_size;

  /// No description provided for @addItem_section_seasonMember.
  ///
  /// In en, this message translates to:
  /// **'Season & Member'**
  String get addItem_section_seasonMember;

  /// No description provided for @addItem_section_storageLocation.
  ///
  /// In en, this message translates to:
  /// **'Storage Location'**
  String get addItem_section_storageLocation;

  /// No description provided for @addItem_button_addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addItem_button_addPhoto;

  /// No description provided for @addItem_button_takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get addItem_button_takePhoto;

  /// No description provided for @addItem_button_chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get addItem_button_chooseGallery;

  /// No description provided for @addItem_button_saveItem.
  ///
  /// In en, this message translates to:
  /// **'Save Item'**
  String get addItem_button_saveItem;

  /// No description provided for @addItem_field_itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get addItem_field_itemName;

  /// No description provided for @addItem_field_itemNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Winter Jacket'**
  String get addItem_field_itemNameHint;

  /// No description provided for @addItem_field_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get addItem_field_category;

  /// No description provided for @addItem_field_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get addItem_field_gender;

  /// No description provided for @addItem_field_size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get addItem_field_size;

  /// No description provided for @addItem_field_customSize.
  ///
  /// In en, this message translates to:
  /// **'Enter Custom Size'**
  String get addItem_field_customSize;

  /// No description provided for @addItem_field_customSizeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 32W, 10.5, etc.'**
  String get addItem_field_customSizeHint;

  /// No description provided for @addItem_field_quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get addItem_field_quantity;

  /// No description provided for @addItem_field_seasons.
  ///
  /// In en, this message translates to:
  /// **'Season(s)'**
  String get addItem_field_seasons;

  /// No description provided for @addItem_field_assignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned To'**
  String get addItem_field_assignedTo;

  /// No description provided for @addItem_field_assignedToHint.
  ///
  /// In en, this message translates to:
  /// **'Select member'**
  String get addItem_field_assignedToHint;

  /// No description provided for @addItem_field_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get addItem_field_none;

  /// No description provided for @addItem_category_clothes.
  ///
  /// In en, this message translates to:
  /// **'Clothes'**
  String get addItem_category_clothes;

  /// No description provided for @addItem_category_shoes.
  ///
  /// In en, this message translates to:
  /// **'Shoes'**
  String get addItem_category_shoes;

  /// No description provided for @addItem_category_accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get addItem_category_accessories;

  /// No description provided for @addItem_category_toys.
  ///
  /// In en, this message translates to:
  /// **'Toys'**
  String get addItem_category_toys;

  /// No description provided for @addItem_category_gear.
  ///
  /// In en, this message translates to:
  /// **'Gear'**
  String get addItem_category_gear;

  /// No description provided for @gender_unisex.
  ///
  /// In en, this message translates to:
  /// **'Unisex'**
  String get gender_unisex;

  /// No description provided for @gender_male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get gender_male;

  /// No description provided for @gender_female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get gender_female;

  /// No description provided for @addItem_season_winter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get addItem_season_winter;

  /// No description provided for @addItem_season_spring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get addItem_season_spring;

  /// No description provided for @addItem_season_summer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get addItem_season_summer;

  /// No description provided for @addItem_season_fall.
  ///
  /// In en, this message translates to:
  /// **'Fall'**
  String get addItem_season_fall;

  /// No description provided for @addItem_size_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get addItem_size_other;

  /// No description provided for @addItem_validation_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get addItem_validation_required;

  /// No description provided for @addItem_validation_selectStorage.
  ///
  /// In en, this message translates to:
  /// **'Please select a storage location'**
  String get addItem_validation_selectStorage;

  /// No description provided for @addItem_validation_selectSize.
  ///
  /// In en, this message translates to:
  /// **'Please select a size'**
  String get addItem_validation_selectSize;

  /// No description provided for @addItem_validation_enterSize.
  ///
  /// In en, this message translates to:
  /// **'Please enter a size'**
  String get addItem_validation_enterSize;

  /// No description provided for @addItem_success_added.
  ///
  /// In en, this message translates to:
  /// **'Item added successfully'**
  String get addItem_success_added;

  /// No description provided for @addItem_success_updated.
  ///
  /// In en, this message translates to:
  /// **'Item updated successfully'**
  String get addItem_success_updated;

  /// No description provided for @addItem_error_saving.
  ///
  /// In en, this message translates to:
  /// **'Error saving item: {error}'**
  String addItem_error_saving(String error);

  /// No description provided for @addItem_error_pickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String addItem_error_pickingImage(String error);

  /// No description provided for @addItem_error_loadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String addItem_error_loadingData(String error);

  /// No description provided for @addItem_location_found.
  ///
  /// In en, this message translates to:
  /// **'Location found: {name}'**
  String addItem_location_found(String name);

  /// No description provided for @addItem_location_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown location code: {code}'**
  String addItem_location_unknown(String code);

  /// No description provided for @addItem_section_tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get addItem_section_tags;

  /// No description provided for @addItem_tags_hint.
  ///
  /// In en, this message translates to:
  /// **'Add tag (color, brand, material...)'**
  String get addItem_tags_hint;

  /// No description provided for @addItem_tags_limitReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum 5 tags allowed'**
  String get addItem_tags_limitReached;

  /// No description provided for @addItem_tags_duplicate.
  ///
  /// In en, this message translates to:
  /// **'Tag already exists'**
  String get addItem_tags_duplicate;

  /// No description provided for @addItem_tags_mostUsed.
  ///
  /// In en, this message translates to:
  /// **'Most Used Tags'**
  String get addItem_tags_mostUsed;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_button_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_button_editProfile;

  /// No description provided for @profile_role_familyAdmin.
  ///
  /// In en, this message translates to:
  /// **'Family Admin'**
  String get profile_role_familyAdmin;

  /// No description provided for @profile_section_familyManagement.
  ///
  /// In en, this message translates to:
  /// **'Family Management'**
  String get profile_section_familyManagement;

  /// No description provided for @profile_setting_subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get profile_setting_subscription;

  /// No description provided for @profile_subscription_statusFree.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get profile_subscription_statusFree;

  /// No description provided for @profile_subscription_statusPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get profile_subscription_statusPremium;

  /// No description provided for @profile_section_appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get profile_section_appSettings;

  /// No description provided for @profile_section_dataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get profile_section_dataPrivacy;

  /// No description provided for @profile_section_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profile_section_support;

  /// No description provided for @profile_section_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_section_language;

  /// No description provided for @profile_family_name.
  ///
  /// In en, this message translates to:
  /// **'{familyName} Family'**
  String profile_family_name(String familyName);

  /// No description provided for @profile_family_members.
  ///
  /// In en, this message translates to:
  /// **'{count} members • You are admin'**
  String profile_family_members(int count);

  /// No description provided for @profile_family_inviteMembers.
  ///
  /// In en, this message translates to:
  /// **'Invite Members'**
  String get profile_family_inviteMembers;

  /// No description provided for @profile_family_inviteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share family access'**
  String get profile_family_inviteSubtitle;

  /// No description provided for @profile_setting_darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get profile_setting_darkMode;

  /// No description provided for @profile_setting_darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Toggle dark theme'**
  String get profile_setting_darkModeSubtitle;

  /// No description provided for @profile_setting_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profile_setting_notifications;

  /// No description provided for @profile_setting_notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders & alerts'**
  String get profile_setting_notificationsSubtitle;

  /// No description provided for @profile_setting_seasonalReminders.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Reminders'**
  String get profile_setting_seasonalReminders;

  /// No description provided for @profile_setting_seasonalRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto season alerts'**
  String get profile_setting_seasonalRemindersSubtitle;

  /// No description provided for @profile_setting_autoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get profile_setting_autoSync;

  /// No description provided for @profile_setting_autoSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud synchronization'**
  String get profile_setting_autoSyncSubtitle;

  /// No description provided for @profile_setting_biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get profile_setting_biometricLogin;

  /// No description provided for @profile_setting_biometricLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Face ID / Touch ID'**
  String get profile_setting_biometricLoginSubtitle;

  /// No description provided for @profile_setting_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_setting_language;

  /// No description provided for @profile_setting_languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get profile_setting_languageSubtitle;

  /// No description provided for @profile_setting_statusTracking.
  ///
  /// In en, this message translates to:
  /// **'Enable Status Tracking'**
  String get profile_setting_statusTracking;

  /// No description provided for @profile_setting_statusTrackingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track if items are in use or stored'**
  String get profile_setting_statusTrackingSubtitle;

  /// No description provided for @profile_setting_quickAddItem.
  ///
  /// In en, this message translates to:
  /// **'Quick Add Item'**
  String get profile_setting_quickAddItem;

  /// No description provided for @profile_setting_quickAddItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically start with camera for new items'**
  String get profile_setting_quickAddItemSubtitle;

  /// No description provided for @profile_data_exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get profile_data_exportData;

  /// No description provided for @profile_data_exportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download your information'**
  String get profile_data_exportDataSubtitle;

  /// No description provided for @profile_data_backupData.
  ///
  /// In en, this message translates to:
  /// **'Backup Data'**
  String get profile_data_backupData;

  /// No description provided for @profile_data_backupDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create backup copy'**
  String get profile_data_backupDataSubtitle;

  /// No description provided for @profile_data_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profile_data_privacyPolicy;

  /// No description provided for @profile_data_privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we protect your data'**
  String get profile_data_privacyPolicySubtitle;

  /// No description provided for @profile_support_helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get profile_support_helpCenter;

  /// No description provided for @profile_support_helpCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs and tutorials'**
  String get profile_support_helpCenterSubtitle;

  /// No description provided for @profile_support_contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get profile_support_contactSupport;

  /// No description provided for @profile_support_contactSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get help from our team'**
  String get profile_support_contactSupportSubtitle;

  /// No description provided for @profile_support_rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get profile_support_rateApp;

  /// No description provided for @profile_support_rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your feedback'**
  String get profile_support_rateAppSubtitle;

  /// No description provided for @profile_dialog_logout_title.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_dialog_logout_title;

  /// No description provided for @profile_dialog_logout_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get profile_dialog_logout_message;

  /// No description provided for @profile_dialog_logout_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profile_dialog_logout_cancel;

  /// No description provided for @profile_dialog_logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_dialog_logout_confirm;

  /// No description provided for @profile_dialog_biometric_title.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometric Login'**
  String get profile_dialog_biometric_title;

  /// No description provided for @profile_dialog_biometric_message.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and password to securely store them.'**
  String get profile_dialog_biometric_message;

  /// No description provided for @profile_dialog_biometric_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profile_dialog_biometric_email;

  /// No description provided for @profile_dialog_biometric_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get profile_dialog_biometric_password;

  /// No description provided for @profile_dialog_biometric_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profile_dialog_biometric_cancel;

  /// No description provided for @profile_dialog_biometric_enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get profile_dialog_biometric_enable;

  /// No description provided for @profile_success_biometricEnabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric login enabled'**
  String get profile_success_biometricEnabled;

  /// No description provided for @profile_error_logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed: {error}'**
  String profile_error_logoutFailed(String error);

  /// No description provided for @language_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_english;

  /// No description provided for @language_spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get language_spanish;

  /// No description provided for @language_french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get language_french;

  /// No description provided for @language_italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get language_italian;

  /// No description provided for @language_german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get language_german;

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get common_add;

  /// No description provided for @common_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get common_search;

  /// No description provided for @common_filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get common_filter;

  /// No description provided for @common_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get common_error;

  /// No description provided for @common_success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get common_success;

  /// No description provided for @common_comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get common_comingSoon;

  /// No description provided for @addMember_title_add.
  ///
  /// In en, this message translates to:
  /// **'Add Family Member'**
  String get addMember_title_add;

  /// No description provided for @addMember_title_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit Family Member'**
  String get addMember_title_edit;

  /// No description provided for @addMember_success_added.
  ///
  /// In en, this message translates to:
  /// **'Family member added successfully'**
  String get addMember_success_added;

  /// No description provided for @addMember_success_updated.
  ///
  /// In en, this message translates to:
  /// **'Family member updated successfully'**
  String get addMember_success_updated;

  /// No description provided for @addMember_success_deleted.
  ///
  /// In en, this message translates to:
  /// **'Family member deleted successfully'**
  String get addMember_success_deleted;

  /// No description provided for @addMember_error_saving.
  ///
  /// In en, this message translates to:
  /// **'Error saving member: {error}'**
  String addMember_error_saving(String error);

  /// No description provided for @addMember_error_deleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting member: {error}'**
  String addMember_error_deleting(String error);

  /// No description provided for @addMember_dialog_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Member'**
  String get addMember_dialog_delete_title;

  /// No description provided for @addMember_dialog_delete_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this family member? This action cannot be undone.'**
  String get addMember_dialog_delete_message;

  /// No description provided for @addMember_section_basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get addMember_section_basicInfo;

  /// No description provided for @addMember_field_name.
  ///
  /// In en, this message translates to:
  /// **'Member\'s Name'**
  String get addMember_field_name;

  /// No description provided for @addMember_field_nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get addMember_field_nameHint;

  /// No description provided for @addMember_field_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get addMember_field_gender;

  /// No description provided for @addMember_field_birthdate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get addMember_field_birthdate;

  /// No description provided for @addMember_field_birthdateHint.
  ///
  /// In en, this message translates to:
  /// **'mm/dd/yyyy'**
  String get addMember_field_birthdateHint;

  /// No description provided for @addMember_field_birthdate_explanation.
  ///
  /// In en, this message translates to:
  /// **'Birthdate is used to calculate age and provide age-specific growth predictions.'**
  String get addMember_field_birthdate_explanation;

  /// No description provided for @addMember_section_sizes.
  ///
  /// In en, this message translates to:
  /// **'Current Sizes'**
  String get addMember_section_sizes;

  /// No description provided for @addMember_section_sizes_explanation.
  ///
  /// In en, this message translates to:
  /// **'Current sizes are used as a baseline to predict future sizes based on growth patterns.'**
  String get addMember_section_sizes_explanation;

  /// No description provided for @addMember_field_clothingSize.
  ///
  /// In en, this message translates to:
  /// **'Clothing Size'**
  String get addMember_field_clothingSize;

  /// No description provided for @addMember_field_clothingSizeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 110 (cm) or 5 (age)'**
  String get addMember_field_clothingSizeHint;

  /// No description provided for @addMember_field_shoeSize.
  ///
  /// In en, this message translates to:
  /// **'Shoe Size'**
  String get addMember_field_shoeSize;

  /// No description provided for @addMember_field_shoeSizeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 28'**
  String get addMember_field_shoeSizeHint;

  /// No description provided for @addMember_section_notes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get addMember_section_notes;

  /// No description provided for @addMember_field_notesHint.
  ///
  /// In en, this message translates to:
  /// **'Any special notes about this child\'s preferences, etc.'**
  String get addMember_field_notesHint;

  /// No description provided for @addMember_button_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get addMember_button_update;

  /// No description provided for @addMember_button_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addMember_button_add;

  /// No description provided for @addMember_button_deleteMember.
  ///
  /// In en, this message translates to:
  /// **'Delete Member'**
  String get addMember_button_deleteMember;

  /// No description provided for @addMember_section_accountAccess.
  ///
  /// In en, this message translates to:
  /// **'Account Access'**
  String get addMember_section_accountAccess;

  /// No description provided for @addMember_field_inviteEmail.
  ///
  /// In en, this message translates to:
  /// **'Invite Email'**
  String get addMember_field_inviteEmail;

  /// No description provided for @addMember_field_inviteEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get addMember_field_inviteEmailHint;

  /// No description provided for @addMember_button_sendInvite.
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get addMember_button_sendInvite;

  /// No description provided for @addMember_button_resendInvite.
  ///
  /// In en, this message translates to:
  /// **'Resend Invite'**
  String get addMember_button_resendInvite;

  /// No description provided for @addMember_status_pending.
  ///
  /// In en, this message translates to:
  /// **'Invitation Pending'**
  String get addMember_status_pending;

  /// No description provided for @addMember_status_accepted.
  ///
  /// In en, this message translates to:
  /// **'Invitation Accepted'**
  String get addMember_status_accepted;

  /// No description provided for @addMember_status_inviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent to {email}'**
  String addMember_status_inviteSent(Object email);

  /// No description provided for @addMember_status_accountLinked.
  ///
  /// In en, this message translates to:
  /// **'Account Linked: {email}'**
  String addMember_status_accountLinked(Object email);

  /// No description provided for @addMember_error_invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get addMember_error_invalidEmail;

  /// No description provided for @addMember_field_role.
  ///
  /// In en, this message translates to:
  /// **'Member Role'**
  String get addMember_field_role;

  /// No description provided for @addMember_role_admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get addMember_role_admin;

  /// No description provided for @addMember_role_coAdmin.
  ///
  /// In en, this message translates to:
  /// **'Co-Admin'**
  String get addMember_role_coAdmin;

  /// No description provided for @addMember_role_member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get addMember_role_member;

  /// No description provided for @addMember_role_child.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get addMember_role_child;

  /// No description provided for @addMember_invite_description.
  ///
  /// In en, this message translates to:
  /// **'Invite family members to join your SeasonBox family. They will be able to view and manage items based on their role.'**
  String get addMember_invite_description;

  /// No description provided for @addMember_validation_nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get addMember_validation_nameRequired;

  /// No description provided for @addMember_dialog_cancelInvite_title.
  ///
  /// In en, this message translates to:
  /// **'Cancel Invitation'**
  String get addMember_dialog_cancelInvite_title;

  /// No description provided for @addMember_dialog_cancelInvite_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this invitation? The user will no longer be able to join using this invite.'**
  String get addMember_dialog_cancelInvite_message;

  /// No description provided for @addMember_button_cancelInvite.
  ///
  /// In en, this message translates to:
  /// **'Cancel Invitation'**
  String get addMember_button_cancelInvite;

  /// No description provided for @addMember_share_message.
  ///
  /// In en, this message translates to:
  /// **'Join my SeasonBox family! Use code: {familyId}'**
  String addMember_share_message(String familyId);

  /// No description provided for @addMember_action_share.
  ///
  /// In en, this message translates to:
  /// **'Share Invite'**
  String get addMember_action_share;

  /// No description provided for @addMember_action_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get addMember_action_copy;

  /// No description provided for @addMember_snack_copied.
  ///
  /// In en, this message translates to:
  /// **'Family ID copied to clipboard'**
  String get addMember_snack_copied;

  /// No description provided for @register_title.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get register_title;

  /// No description provided for @register_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Join SeasonBox family'**
  String get register_subtitle;

  /// No description provided for @register_field_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get register_field_name;

  /// No description provided for @register_field_familyCode.
  ///
  /// In en, this message translates to:
  /// **'Family Code (Optional)'**
  String get register_field_familyCode;

  /// No description provided for @register_button_create.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get register_button_create;

  /// No description provided for @register_link_login.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get register_link_login;

  /// No description provided for @register_text_noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet?'**
  String get register_text_noAccount;

  /// No description provided for @register_link_registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get register_link_registerNow;

  /// No description provided for @register_error_familyNotFound.
  ///
  /// In en, this message translates to:
  /// **'Family not found'**
  String get register_error_familyNotFound;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get register_success;

  /// No description provided for @profile_joinFamily_title.
  ///
  /// In en, this message translates to:
  /// **'Join Family'**
  String get profile_joinFamily_title;

  /// No description provided for @profile_joinFamily_input.
  ///
  /// In en, this message translates to:
  /// **'Enter Family Code'**
  String get profile_joinFamily_input;

  /// No description provided for @profile_leaveFamily_title.
  ///
  /// In en, this message translates to:
  /// **'Leave Family'**
  String get profile_leaveFamily_title;

  /// No description provided for @profile_leaveFamily_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this family? You will be removed from the members list.'**
  String get profile_leaveFamily_confirm;

  /// No description provided for @profile_disbandFamily_confirm.
  ///
  /// In en, this message translates to:
  /// **'Warning: You are the admin. Leaving will remove all members and delete the family group. This action cannot be undone.'**
  String get profile_disbandFamily_confirm;

  /// No description provided for @register_validation_passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get register_validation_passwordLength;

  /// No description provided for @error_no_invitation.
  ///
  /// In en, this message translates to:
  /// **'No active invitation found for this family.'**
  String get error_no_invitation;

  /// No description provided for @profile_joinFamily_success.
  ///
  /// In en, this message translates to:
  /// **'Successfully joined family'**
  String get profile_joinFamily_success;

  /// No description provided for @profile_leaveFamily_success.
  ///
  /// In en, this message translates to:
  /// **'Successfully left family'**
  String get profile_leaveFamily_success;

  /// No description provided for @members_title.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get members_title;

  /// No description provided for @members_label_currentSize.
  ///
  /// In en, this message translates to:
  /// **'Current Size'**
  String get members_label_currentSize;

  /// No description provided for @members_label_items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get members_label_items;

  /// No description provided for @members_button_viewItems.
  ///
  /// In en, this message translates to:
  /// **'View Items'**
  String get members_button_viewItems;

  /// No description provided for @members_empty.
  ///
  /// In en, this message translates to:
  /// **'No members added yet'**
  String get members_empty;

  /// No description provided for @members_error_loading.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String members_error_loading(String error);

  /// No description provided for @addStorage_title_add.
  ///
  /// In en, this message translates to:
  /// **'Add Storage Location'**
  String get addStorage_title_add;

  /// No description provided for @addStorage_title_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit Storage Location'**
  String get addStorage_title_edit;

  /// No description provided for @addStorage_success_added.
  ///
  /// In en, this message translates to:
  /// **'Storage location added successfully'**
  String get addStorage_success_added;

  /// No description provided for @addStorage_success_updated.
  ///
  /// In en, this message translates to:
  /// **'Storage location updated successfully'**
  String get addStorage_success_updated;

  /// No description provided for @addStorage_success_deleted.
  ///
  /// In en, this message translates to:
  /// **'Storage location deleted successfully'**
  String get addStorage_success_deleted;

  /// No description provided for @addStorage_error_saving.
  ///
  /// In en, this message translates to:
  /// **'Error saving location: {error}'**
  String addStorage_error_saving(String error);

  /// No description provided for @addStorage_error_deleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting location: {error}'**
  String addStorage_error_deleting(String error);

  /// No description provided for @addStorage_dialog_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Storage Location'**
  String get addStorage_dialog_delete_title;

  /// No description provided for @addStorage_dialog_delete_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this storage location?'**
  String get addStorage_dialog_delete_message;

  /// No description provided for @addStorage_section_type.
  ///
  /// In en, this message translates to:
  /// **'Storage Type'**
  String get addStorage_section_type;

  /// No description provided for @addStorage_section_basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get addStorage_section_basicInfo;

  /// No description provided for @addStorage_field_name.
  ///
  /// In en, this message translates to:
  /// **'Storage Name'**
  String get addStorage_field_name;

  /// No description provided for @addStorage_field_nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter storage name'**
  String get addStorage_field_nameHint;

  /// No description provided for @addStorage_field_parent.
  ///
  /// In en, this message translates to:
  /// **'Parent Location (Optional)'**
  String get addStorage_field_parent;

  /// No description provided for @addStorage_field_parentNone.
  ///
  /// In en, this message translates to:
  /// **'None (top level)'**
  String get addStorage_field_parentNone;

  /// No description provided for @addStorage_section_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get addStorage_section_description;

  /// No description provided for @addStorage_field_descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional description'**
  String get addStorage_field_descriptionHint;

  /// No description provided for @addStorage_button_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get addStorage_button_update;

  /// No description provided for @addStorage_button_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addStorage_button_add;

  /// No description provided for @addStorage_button_deleteLocation.
  ///
  /// In en, this message translates to:
  /// **'Delete Storage Location'**
  String get addStorage_button_deleteLocation;

  /// No description provided for @storage_title.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage_title;

  /// No description provided for @storage_error_loading.
  ///
  /// In en, this message translates to:
  /// **'Error loading storage locations: {error}'**
  String storage_error_loading(String error);

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get nav_items;

  /// No description provided for @nav_members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get nav_members;

  /// No description provided for @nav_storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get nav_storage;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @storage_subtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} locations • {itemCount} items'**
  String storage_subtitle(int count, int itemCount);

  /// No description provided for @storage_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search locations...'**
  String get storage_searchHint;

  /// No description provided for @storage_filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get storage_filterAll;

  /// No description provided for @storage_filterBasement.
  ///
  /// In en, this message translates to:
  /// **'Basement'**
  String get storage_filterBasement;

  /// No description provided for @storage_filterClosets.
  ///
  /// In en, this message translates to:
  /// **'Closets'**
  String get storage_filterClosets;

  /// No description provided for @storage_filterAttic.
  ///
  /// In en, this message translates to:
  /// **'Attic'**
  String get storage_filterAttic;

  /// No description provided for @storage_sectionBoxes.
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
  String get storage_sectionBoxes;

  /// No description provided for @storage_sectionClosets.
  ///
  /// In en, this message translates to:
  /// **'Closets'**
  String get storage_sectionClosets;

  /// No description provided for @storage_sectionAreas.
  ///
  /// In en, this message translates to:
  /// **'Areas'**
  String get storage_sectionAreas;

  /// No description provided for @storage_sectionOther.
  ///
  /// In en, this message translates to:
  /// **'Other Storage'**
  String get storage_sectionOther;

  /// No description provided for @storage_expandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand All'**
  String get storage_expandAll;

  /// No description provided for @storage_noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get storage_noDescription;

  /// No description provided for @storage_itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String storage_itemsCount(int count);

  /// No description provided for @storage_viewItems.
  ///
  /// In en, this message translates to:
  /// **'View Items'**
  String get storage_viewItems;

  /// No description provided for @storage_quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get storage_quickActions;

  /// No description provided for @storage_scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get storage_scanQrCode;

  /// No description provided for @storage_printLabels.
  ///
  /// In en, this message translates to:
  /// **'Print Labels'**
  String get storage_printLabels;

  /// No description provided for @members_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage family members'**
  String get members_subtitle;

  /// No description provided for @members_summaryMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members_summaryMembers;

  /// No description provided for @members_summaryTotalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get members_summaryTotalItems;

  /// No description provided for @members_summaryNeedCheck.
  ///
  /// In en, this message translates to:
  /// **'Need Check'**
  String get members_summaryNeedCheck;

  /// No description provided for @members_ageYears.
  ///
  /// In en, this message translates to:
  /// **'{age} years'**
  String members_ageYears(int age);

  /// No description provided for @members_birthdate_notSet.
  ///
  /// In en, this message translates to:
  /// **'Birthdate not set'**
  String get members_birthdate_notSet;

  /// No description provided for @members_dialog_birthdateRequired_title.
  ///
  /// In en, this message translates to:
  /// **'Birthdate Required'**
  String get members_dialog_birthdateRequired_title;

  /// No description provided for @members_dialog_birthdateRequired_message.
  ///
  /// In en, this message translates to:
  /// **'A birthdate is needed to calculate the member\'s age and provide accurate growth predictions and milestones on the charts.'**
  String get members_dialog_birthdateRequired_message;

  /// No description provided for @members_dialog_birthdateRequired_button.
  ///
  /// In en, this message translates to:
  /// **'Set Birthdate'**
  String get members_dialog_birthdateRequired_button;

  /// No description provided for @members_dialog_sizeRequired_title.
  ///
  /// In en, this message translates to:
  /// **'Size Information Required'**
  String get members_dialog_sizeRequired_title;

  /// No description provided for @members_dialog_sizeRequired_message.
  ///
  /// In en, this message translates to:
  /// **'Current clothing or shoe sizes are required as a baseline to predict future sizes based on growth patterns.'**
  String get members_dialog_sizeRequired_message;

  /// No description provided for @members_dialog_sizeRequired_button.
  ///
  /// In en, this message translates to:
  /// **'Set Sizes'**
  String get members_dialog_sizeRequired_button;

  /// No description provided for @members_born.
  ///
  /// In en, this message translates to:
  /// **'Born: {date}'**
  String members_born(String date);

  /// No description provided for @members_clothes.
  ///
  /// In en, this message translates to:
  /// **'Clothes: {size}'**
  String members_clothes(String size);

  /// No description provided for @members_shoes.
  ///
  /// In en, this message translates to:
  /// **'Shoes: {size}'**
  String members_shoes(String size);

  /// No description provided for @members_hasItems.
  ///
  /// In en, this message translates to:
  /// **'✓ Has items'**
  String get members_hasItems;

  /// No description provided for @members_noItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No items yet'**
  String get members_noItemsYet;

  /// No description provided for @members_tooltipGrowthChart.
  ///
  /// In en, this message translates to:
  /// **'Growth Chart'**
  String get members_tooltipGrowthChart;

  /// No description provided for @members_growthChart_actual.
  ///
  /// In en, this message translates to:
  /// **'Actual History'**
  String get members_growthChart_actual;

  /// No description provided for @members_growthChart_expectation.
  ///
  /// In en, this message translates to:
  /// **'Expectation'**
  String get members_growthChart_expectation;

  /// No description provided for @members_growthChart_insight.
  ///
  /// In en, this message translates to:
  /// **'Based on current growth, {name} will likely need a new size in about {months} months.'**
  String members_growthChart_insight(String name, int months);

  /// No description provided for @members_growthChart_noGrowth.
  ///
  /// In en, this message translates to:
  /// **'{name} has reached physical maturity. Standard growth generally concludes after age 18.'**
  String members_growthChart_noGrowth(String name);

  /// No description provided for @members_growthChart_reference.
  ///
  /// In en, this message translates to:
  /// **'Growth models are based on the World Health Organization (WHO) Child Growth Standards.'**
  String get members_growthChart_reference;

  /// No description provided for @members_tooltipEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get members_tooltipEdit;

  /// No description provided for @items_title.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items_title;

  /// No description provided for @items_subtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} total items'**
  String items_subtitle(int count);

  /// No description provided for @items_subtitleWithLocation.
  ///
  /// In en, this message translates to:
  /// **'{location} • {count} items'**
  String items_subtitleWithLocation(String location, int count);

  /// No description provided for @items_filterAllItems.
  ///
  /// In en, this message translates to:
  /// **'All Items'**
  String get items_filterAllItems;

  /// No description provided for @items_filterInUse.
  ///
  /// In en, this message translates to:
  /// **'In Use'**
  String get items_filterInUse;

  /// No description provided for @items_filterStored.
  ///
  /// In en, this message translates to:
  /// **'Stored'**
  String get items_filterStored;

  /// No description provided for @items_filterWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get items_filterWinter;

  /// No description provided for @items_filterSummer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get items_filterSummer;

  /// No description provided for @items_quickFilters.
  ///
  /// In en, this message translates to:
  /// **'Quick Filters'**
  String get items_quickFilters;

  /// No description provided for @items_clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get items_clearAll;

  /// No description provided for @items_filterClothes.
  ///
  /// In en, this message translates to:
  /// **'Clothes'**
  String get items_filterClothes;

  /// No description provided for @items_filterShoes.
  ///
  /// In en, this message translates to:
  /// **'Shoes'**
  String get items_filterShoes;

  /// No description provided for @items_filterAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get items_filterAccessories;

  /// No description provided for @items_sizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size {size} • {gender}'**
  String items_sizeLabel(String size, String gender);

  /// No description provided for @items_filter_title.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get items_filter_title;

  /// No description provided for @items_filter_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get items_filter_category;

  /// No description provided for @items_filter_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get items_filter_gender;

  /// No description provided for @items_filter_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get items_filter_status;

  /// No description provided for @items_filter_member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get items_filter_member;

  /// No description provided for @items_filter_active.
  ///
  /// In en, this message translates to:
  /// **'Active Filters'**
  String get items_filter_active;

  /// No description provided for @items_noSeasonTags.
  ///
  /// In en, this message translates to:
  /// **'No season tags'**
  String get items_noSeasonTags;

  /// No description provided for @items_quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity: {count}'**
  String items_quantity(int count);

  /// No description provided for @items_statusInUse.
  ///
  /// In en, this message translates to:
  /// **'In Use'**
  String get items_statusInUse;

  /// No description provided for @items_statusStored.
  ///
  /// In en, this message translates to:
  /// **'Stored'**
  String get items_statusStored;

  /// No description provided for @items_statusOutgrown.
  ///
  /// In en, this message translates to:
  /// **'Outgrown'**
  String get items_statusOutgrown;

  /// No description provided for @editProfile_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile_title;

  /// No description provided for @editProfile_changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get editProfile_changePhoto;

  /// No description provided for @editProfile_section_personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get editProfile_section_personalInfo;

  /// No description provided for @editProfile_field_fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get editProfile_field_fullName;

  /// No description provided for @editProfile_field_email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get editProfile_field_email;

  /// No description provided for @editProfile_hint_emailCannotChanged.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed'**
  String get editProfile_hint_emailCannotChanged;

  /// No description provided for @editProfile_field_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get editProfile_field_phone;

  /// No description provided for @editProfile_field_role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get editProfile_field_role;

  /// No description provided for @editProfile_section_preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get editProfile_section_preferences;

  /// No description provided for @editProfile_pref_emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get editProfile_pref_emailNotifications;

  /// No description provided for @editProfile_pref_emailNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive updates via email'**
  String get editProfile_pref_emailNotificationsSubtitle;

  /// No description provided for @editProfile_pref_pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get editProfile_pref_pushNotifications;

  /// No description provided for @editProfile_pref_pushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get alerts on your device'**
  String get editProfile_pref_pushNotificationsSubtitle;

  /// No description provided for @editProfile_pref_weeklyDigest.
  ///
  /// In en, this message translates to:
  /// **'Weekly Digest'**
  String get editProfile_pref_weeklyDigest;

  /// No description provided for @editProfile_pref_weeklyDigestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Summary of family activity'**
  String get editProfile_pref_weeklyDigestSubtitle;

  /// No description provided for @editProfile_section_unitsDisplay.
  ///
  /// In en, this message translates to:
  /// **'Units & Display'**
  String get editProfile_section_unitsDisplay;

  /// No description provided for @editProfile_field_measurementSystem.
  ///
  /// In en, this message translates to:
  /// **'Measurement System'**
  String get editProfile_field_measurementSystem;

  /// No description provided for @editProfile_option_imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial (US)'**
  String get editProfile_option_imperial;

  /// No description provided for @editProfile_option_metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get editProfile_option_metric;

  /// No description provided for @editProfile_button_saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editProfile_button_saveChanges;

  /// No description provided for @notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// No description provided for @notifications_empty.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get notifications_empty;

  /// No description provided for @notifications_invite_title.
  ///
  /// In en, this message translates to:
  /// **'Invitation to join Family'**
  String get notifications_invite_title;

  /// No description provided for @notifications_invite_message.
  ///
  /// In en, this message translates to:
  /// **'{inviterName} has invited you to join their family.'**
  String notifications_invite_message(String inviterName);

  /// No description provided for @notifications_invite_familyId.
  ///
  /// In en, this message translates to:
  /// **'Family ID: {familyId}'**
  String notifications_invite_familyId(String familyId);

  /// No description provided for @notifications_action_accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get notifications_action_accept;

  /// No description provided for @notifications_action_reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get notifications_action_reject;

  /// No description provided for @notifications_success_joined.
  ///
  /// In en, this message translates to:
  /// **'Joined family successfully!'**
  String get notifications_success_joined;

  /// No description provided for @notifications_success_rejected.
  ///
  /// In en, this message translates to:
  /// **'Invitation rejected.'**
  String get notifications_success_rejected;

  /// No description provided for @notifications_error_joining.
  ///
  /// In en, this message translates to:
  /// **'Error joining family: {error}'**
  String notifications_error_joining(String error);

  /// No description provided for @notifications_error_rejecting.
  ///
  /// In en, this message translates to:
  /// **'Error rejecting invitation: {error}'**
  String notifications_error_rejecting(String error);

  /// No description provided for @subscription_title.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription_title;

  /// No description provided for @subscription_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the best plan for your family'**
  String get subscription_subtitle;

  /// No description provided for @subscription_billing_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get subscription_billing_monthly;

  /// No description provided for @subscription_billing_yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get subscription_billing_yearly;

  /// No description provided for @subscription_tier_freeTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Tier'**
  String get subscription_tier_freeTitle;

  /// No description provided for @subscription_tier_premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Tier'**
  String get subscription_tier_premiumTitle;

  /// No description provided for @subscription_tier_freePrice.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get subscription_tier_freePrice;

  /// No description provided for @subscription_tier_premiumPrice.
  ///
  /// In en, this message translates to:
  /// **'€{price}{period}'**
  String subscription_tier_premiumPrice(String price, String period);

  /// No description provided for @subscription_tier_freeDesc.
  ///
  /// In en, this message translates to:
  /// **'Great for getting started'**
  String get subscription_tier_freeDesc;

  /// No description provided for @subscription_tier_premiumDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlimited access for busy families'**
  String get subscription_tier_premiumDesc;

  /// No description provided for @subscription_feature_items_free.
  ///
  /// In en, this message translates to:
  /// **'Up to 50 items'**
  String get subscription_feature_items_free;

  /// No description provided for @subscription_feature_photos_free.
  ///
  /// In en, this message translates to:
  /// **'3 photos per item'**
  String get subscription_feature_photos_free;

  /// No description provided for @subscription_feature_storage_free.
  ///
  /// In en, this message translates to:
  /// **'Standard storage tracking'**
  String get subscription_feature_storage_free;

  /// No description provided for @subscription_feature_items_premium.
  ///
  /// In en, this message translates to:
  /// **'Unlimited items'**
  String get subscription_feature_items_premium;

  /// No description provided for @subscription_feature_members_premium.
  ///
  /// In en, this message translates to:
  /// **'Unlimited family members'**
  String get subscription_feature_members_premium;

  /// No description provided for @subscription_feature_sharing_premium.
  ///
  /// In en, this message translates to:
  /// **'Full family sharing'**
  String get subscription_feature_sharing_premium;

  /// No description provided for @subscription_feature_growth_premium.
  ///
  /// In en, this message translates to:
  /// **'Growth predictions & advice'**
  String get subscription_feature_growth_premium;

  /// No description provided for @subscription_feature_reminders_premium.
  ///
  /// In en, this message translates to:
  /// **'Seasonal reminders'**
  String get subscription_feature_reminders_premium;

  /// No description provided for @subscription_currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subscription_currentPlan;

  /// No description provided for @subscription_selectPlan.
  ///
  /// In en, this message translates to:
  /// **'Select Plan'**
  String get subscription_selectPlan;

  /// No description provided for @subscription_savingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String subscription_savingsLabel(String percent);

  /// No description provided for @subscription_bestValue.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get subscription_bestValue;

  /// No description provided for @subscription_cancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime. Grandfathered items stay visible even after cancellation.'**
  String get subscription_cancelAnytime;

  /// No description provided for @members_tooltip_editPermission.
  ///
  /// In en, this message translates to:
  /// **'Only admins can edit other members'**
  String get members_tooltip_editPermission;

  /// No description provided for @members_button_filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get members_button_filter;

  /// No description provided for @members_dialog_limitReached_title.
  ///
  /// In en, this message translates to:
  /// **'Limit Reached'**
  String get members_dialog_limitReached_title;

  /// No description provided for @members_dialog_limitReached_message.
  ///
  /// In en, this message translates to:
  /// **'The Free tier is limited to 4 members. Upgrade to Paid for unlimited members and full family sharing!'**
  String get members_dialog_limitReached_message;

  /// No description provided for @members_dialog_limitReached_maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get members_dialog_limitReached_maybeLater;

  /// No description provided for @members_dialog_limitReached_viewPricing.
  ///
  /// In en, this message translates to:
  /// **'View Pricing'**
  String get members_dialog_limitReached_viewPricing;

  /// No description provided for @growthChart_premium_title.
  ///
  /// In en, this message translates to:
  /// **'Growth Predictions are Premium'**
  String get growthChart_premium_title;

  /// No description provided for @growthChart_premium_message.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to the Paid plan to see how your children are growing and get advice on when to buy next sizes.'**
  String get growthChart_premium_message;

  /// No description provided for @growthChart_premium_viewPricing.
  ///
  /// In en, this message translates to:
  /// **'View Pricing'**
  String get growthChart_premium_viewPricing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
