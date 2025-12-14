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
  /// **'Johnson Family'**
  String get home_appBar_subtitle;

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

  /// No description provided for @home_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search items, locations...'**
  String get home_search_hint;

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

  /// No description provided for @addItem_gender_unisex.
  ///
  /// In en, this message translates to:
  /// **'Unisex'**
  String get addItem_gender_unisex;

  /// No description provided for @addItem_gender_boy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get addItem_gender_boy;

  /// No description provided for @addItem_gender_girl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get addItem_gender_girl;

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
  /// **'Johnson Family'**
  String get profile_family_name;

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

  /// No description provided for @addMember_section_sizes.
  ///
  /// In en, this message translates to:
  /// **'Current Sizes'**
  String get addMember_section_sizes;

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

  /// No description provided for @addMember_validation_nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get addMember_validation_nameRequired;

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
