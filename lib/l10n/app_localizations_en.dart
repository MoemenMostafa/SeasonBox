// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SeasonBox';

  @override
  String get login_tagline =>
      'Organize seasonal items for your family with ease';

  @override
  String get login_featureCard_photoInventoryTitle => 'Photo Inventory';

  @override
  String get login_featureCard_photoInventorySubtitle =>
      'Capture and organize with photos';

  @override
  String get login_featureCard_familySharingTitle => 'Family Sharing';

  @override
  String get login_featureCard_familySharingSubtitle =>
      'Sync across all family members';

  @override
  String get login_featureCard_smartRemindersTitle => 'Smart Reminders';

  @override
  String get login_featureCard_smartRemindersSubtitle =>
      'Never miss seasonal changes';

  @override
  String get login_button_email => 'Login with your Email';

  @override
  String get login_button_google => 'Continue with Google';

  @override
  String get login_button_biometric => 'Login with Biometrics';

  @override
  String get login_footer_terms => 'By continuing, you agree to our ';

  @override
  String get login_footer_termsOfService => 'Terms of Service';

  @override
  String get login_footer_and => ' and ';

  @override
  String get login_footer_privacyPolicy => 'Privacy Policy';

  @override
  String get login_error_googleCancelled =>
      'Google Sign-In was cancelled or failed. Please try again.';

  @override
  String login_error_signIn(String error) {
    return 'Sign-in error: $error';
  }

  @override
  String get login_error_invalidCredentials =>
      'Invalid email or password. Please try again.';

  @override
  String get emailLogin_title => 'Welcome Back';

  @override
  String get emailLogin_subtitle => 'Sign in to continue';

  @override
  String get emailLogin_field_email => 'Email';

  @override
  String get emailLogin_field_password => 'Password';

  @override
  String get emailLogin_validation_emailRequired => 'Please enter your email';

  @override
  String get emailLogin_validation_passwordRequired =>
      'Please enter your password';

  @override
  String get emailLogin_button_forgotPassword => 'Forgot Password?';

  @override
  String get emailLogin_button_login => 'Login';

  @override
  String get emailLogin_error_emailFirst => 'Please enter your email first';

  @override
  String get emailLogin_success_passwordReset => 'Password reset email sent';

  @override
  String emailLogin_error_generic(String error) {
    return 'Error: $error';
  }

  @override
  String get home_appBar_subtitle => 'Johnson Family';

  @override
  String get home_stats_totalItems => 'Total Items';

  @override
  String get home_stats_members => 'Members';

  @override
  String get home_search_hint => 'Search items, locations...';

  @override
  String get home_section_quickActions => 'Quick Actions';

  @override
  String get home_section_familyMembers => 'Family Members';

  @override
  String get home_section_recentItems => 'Recent Items';

  @override
  String get home_section_seasonalReminders => 'Seasonal Reminders';

  @override
  String get home_section_storageLocations => 'Storage Locations';

  @override
  String get home_action_addItem => 'Add Item';

  @override
  String get home_action_scanQR => 'Scan QR';

  @override
  String get home_action_viewAll => 'View All';

  @override
  String get home_action_manage => 'Manage';

  @override
  String home_member_age(int age) {
    return 'Age $age';
  }

  @override
  String home_member_size(String size) {
    return 'Size $size';
  }

  @override
  String home_member_items(int count) {
    return '$count items';
  }

  @override
  String get home_member_status_active => 'Active';

  @override
  String get home_item_storage => 'Storage';

  @override
  String get home_reminder_fallTitle => 'Fall Season Approaching';

  @override
  String get home_reminder_fallMessage =>
      'Time to check fall clothes for your children. Consider size changes from last year.';

  @override
  String get home_reminder_reviewItems => 'Review Items';

  @override
  String home_error_loadingData(String error) {
    return 'Error loading data: $error';
  }

  @override
  String get addItem_title_add => 'Add New Item';

  @override
  String get addItem_title_edit => 'Edit Item';

  @override
  String get addItem_section_photos => 'Photos';

  @override
  String get addItem_section_itemDetails => 'Item Details';

  @override
  String get addItem_section_size => 'Size';

  @override
  String get addItem_section_seasonMember => 'Season & Member';

  @override
  String get addItem_section_storageLocation => 'Storage Location';

  @override
  String get addItem_button_addPhoto => 'Add Photo';

  @override
  String get addItem_button_takePhoto => 'Take Photo';

  @override
  String get addItem_button_chooseGallery => 'Choose from Gallery';

  @override
  String get addItem_button_saveItem => 'Save Item';

  @override
  String get addItem_field_itemName => 'Item Name';

  @override
  String get addItem_field_itemNameHint => 'e.g., Winter Jacket';

  @override
  String get addItem_field_category => 'Category';

  @override
  String get addItem_field_gender => 'Gender';

  @override
  String get addItem_field_size => 'Size';

  @override
  String get addItem_field_customSize => 'Enter Custom Size';

  @override
  String get addItem_field_customSizeHint => 'e.g., 32W, 10.5, etc.';

  @override
  String get addItem_field_quantity => 'Quantity';

  @override
  String get addItem_field_seasons => 'Season(s)';

  @override
  String get addItem_field_assignedTo => 'Assigned To';

  @override
  String get addItem_field_assignedToHint => 'Select member';

  @override
  String get addItem_field_none => 'None';

  @override
  String get addItem_category_clothes => 'Clothes';

  @override
  String get addItem_category_shoes => 'Shoes';

  @override
  String get addItem_category_accessories => 'Accessories';

  @override
  String get addItem_category_toys => 'Toys';

  @override
  String get addItem_category_gear => 'Gear';

  @override
  String get addItem_gender_unisex => 'Unisex';

  @override
  String get addItem_gender_boy => 'Boy';

  @override
  String get addItem_gender_girl => 'Girl';

  @override
  String get addItem_season_winter => 'Winter';

  @override
  String get addItem_season_spring => 'Spring';

  @override
  String get addItem_season_summer => 'Summer';

  @override
  String get addItem_season_fall => 'Fall';

  @override
  String get addItem_size_other => 'Other';

  @override
  String get addItem_validation_required => 'Required';

  @override
  String get addItem_validation_selectStorage =>
      'Please select a storage location';

  @override
  String get addItem_validation_selectSize => 'Please select a size';

  @override
  String get addItem_validation_enterSize => 'Please enter a size';

  @override
  String get addItem_success_added => 'Item added successfully';

  @override
  String get addItem_success_updated => 'Item updated successfully';

  @override
  String addItem_error_saving(String error) {
    return 'Error saving item: $error';
  }

  @override
  String addItem_error_pickingImage(String error) {
    return 'Error picking image: $error';
  }

  @override
  String addItem_error_loadingData(String error) {
    return 'Error loading data: $error';
  }

  @override
  String addItem_location_found(String name) {
    return 'Location found: $name';
  }

  @override
  String addItem_location_unknown(String code) {
    return 'Unknown location code: $code';
  }

  @override
  String get profile_title => 'Profile';

  @override
  String get profile_button_editProfile => 'Edit Profile';

  @override
  String get profile_role_familyAdmin => 'Family Admin';

  @override
  String get profile_section_familyManagement => 'Family Management';

  @override
  String get profile_section_appSettings => 'App Settings';

  @override
  String get profile_section_dataPrivacy => 'Data & Privacy';

  @override
  String get profile_section_support => 'Support';

  @override
  String get profile_section_language => 'Language';

  @override
  String get profile_family_name => 'Johnson Family';

  @override
  String profile_family_members(int count) {
    return '$count members • You are admin';
  }

  @override
  String get profile_family_inviteMembers => 'Invite Members';

  @override
  String get profile_family_inviteSubtitle => 'Share family access';

  @override
  String get profile_setting_darkMode => 'Dark Mode';

  @override
  String get profile_setting_darkModeSubtitle => 'Toggle dark theme';

  @override
  String get profile_setting_notifications => 'Notifications';

  @override
  String get profile_setting_notificationsSubtitle => 'Reminders & alerts';

  @override
  String get profile_setting_seasonalReminders => 'Seasonal Reminders';

  @override
  String get profile_setting_seasonalRemindersSubtitle => 'Auto season alerts';

  @override
  String get profile_setting_autoSync => 'Auto Sync';

  @override
  String get profile_setting_autoSyncSubtitle => 'Cloud synchronization';

  @override
  String get profile_setting_biometricLogin => 'Biometric Login';

  @override
  String get profile_setting_biometricLoginSubtitle =>
      'Enable Face ID / Touch ID';

  @override
  String get profile_setting_language => 'Language';

  @override
  String get profile_setting_languageSubtitle => 'Change app language';

  @override
  String get profile_data_exportData => 'Export Data';

  @override
  String get profile_data_exportDataSubtitle => 'Download your information';

  @override
  String get profile_data_backupData => 'Backup Data';

  @override
  String get profile_data_backupDataSubtitle => 'Create backup copy';

  @override
  String get profile_data_privacyPolicy => 'Privacy Policy';

  @override
  String get profile_data_privacyPolicySubtitle => 'How we protect your data';

  @override
  String get profile_support_helpCenter => 'Help Center';

  @override
  String get profile_support_helpCenterSubtitle => 'FAQs and tutorials';

  @override
  String get profile_support_contactSupport => 'Contact Support';

  @override
  String get profile_support_contactSupportSubtitle => 'Get help from our team';

  @override
  String get profile_support_rateApp => 'Rate App';

  @override
  String get profile_support_rateAppSubtitle => 'Share your feedback';

  @override
  String get profile_dialog_logout_title => 'Logout';

  @override
  String get profile_dialog_logout_message =>
      'Are you sure you want to logout?';

  @override
  String get profile_dialog_logout_cancel => 'Cancel';

  @override
  String get profile_dialog_logout_confirm => 'Logout';

  @override
  String get profile_dialog_biometric_title => 'Enable Biometric Login';

  @override
  String get profile_dialog_biometric_message =>
      'Please enter your email and password to securely store them.';

  @override
  String get profile_dialog_biometric_email => 'Email';

  @override
  String get profile_dialog_biometric_password => 'Password';

  @override
  String get profile_dialog_biometric_cancel => 'Cancel';

  @override
  String get profile_dialog_biometric_enable => 'Enable';

  @override
  String get profile_success_biometricEnabled => 'Biometric login enabled';

  @override
  String profile_error_logoutFailed(String error) {
    return 'Logout failed: $error';
  }

  @override
  String get language_english => 'English';

  @override
  String get language_spanish => 'Spanish';

  @override
  String get language_french => 'French';

  @override
  String get language_italian => 'Italian';

  @override
  String get language_german => 'German';

  @override
  String get common_loading => 'Loading...';

  @override
  String get common_save => 'Save';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_add => 'Add';

  @override
  String get common_search => 'Search';

  @override
  String get common_filter => 'Filter';

  @override
  String get common_error => 'Error';

  @override
  String get common_success => 'Success';

  @override
  String get addMember_title_add => 'Add Family Member';

  @override
  String get addMember_title_edit => 'Edit Family Member';

  @override
  String get addMember_success_added => 'Family member added successfully';

  @override
  String get addMember_success_updated => 'Family member updated successfully';

  @override
  String get addMember_success_deleted => 'Family member deleted successfully';

  @override
  String addMember_error_saving(String error) {
    return 'Error saving member: $error';
  }

  @override
  String addMember_error_deleting(String error) {
    return 'Error deleting member: $error';
  }

  @override
  String get addMember_dialog_delete_title => 'Delete Member';

  @override
  String get addMember_dialog_delete_message =>
      'Are you sure you want to delete this family member? This action cannot be undone.';

  @override
  String get addMember_section_basicInfo => 'Basic Information';

  @override
  String get addMember_field_name => 'Member\'s Name';

  @override
  String get addMember_field_nameHint => 'Enter full name';

  @override
  String get addMember_field_gender => 'Gender';

  @override
  String get addMember_field_birthdate => 'Birth Date';

  @override
  String get addMember_field_birthdateHint => 'mm/dd/yyyy';

  @override
  String get addMember_section_sizes => 'Current Sizes';

  @override
  String get addMember_field_clothingSize => 'Clothing Size';

  @override
  String get addMember_field_clothingSizeHint => 'e.g. 110 (cm) or 5 (age)';

  @override
  String get addMember_field_shoeSize => 'Shoe Size';

  @override
  String get addMember_field_shoeSizeHint => 'e.g. 28';

  @override
  String get addMember_section_notes => 'Additional Notes';

  @override
  String get addMember_field_notesHint =>
      'Any special notes about this child\'s preferences, etc.';

  @override
  String get addMember_button_update => 'Update';

  @override
  String get addMember_button_add => 'Add';

  @override
  String get addMember_button_deleteMember => 'Delete Member';

  @override
  String get addMember_validation_nameRequired => 'Please enter a name';

  @override
  String get members_title => 'Family Members';

  @override
  String get members_label_currentSize => 'Current Size';

  @override
  String get members_label_items => 'Items';

  @override
  String get members_button_viewItems => 'View Items';

  @override
  String get members_empty => 'No members added yet';

  @override
  String members_error_loading(String error) {
    return 'Error loading data: $error';
  }

  @override
  String get addStorage_title_add => 'Add Storage Location';

  @override
  String get addStorage_title_edit => 'Edit Storage Location';

  @override
  String get addStorage_success_added => 'Storage location added successfully';

  @override
  String get addStorage_success_updated =>
      'Storage location updated successfully';

  @override
  String get addStorage_success_deleted =>
      'Storage location deleted successfully';

  @override
  String addStorage_error_saving(String error) {
    return 'Error saving location: $error';
  }

  @override
  String addStorage_error_deleting(String error) {
    return 'Error deleting location: $error';
  }

  @override
  String get addStorage_dialog_delete_title => 'Delete Storage Location';

  @override
  String get addStorage_dialog_delete_message =>
      'Are you sure you want to delete this storage location?';

  @override
  String get addStorage_section_type => 'Storage Type';

  @override
  String get addStorage_section_basicInfo => 'Basic Information';

  @override
  String get addStorage_field_name => 'Storage Name';

  @override
  String get addStorage_field_nameHint => 'Enter storage name';

  @override
  String get addStorage_field_parent => 'Parent Location (Optional)';

  @override
  String get addStorage_field_parentNone => 'None (top level)';

  @override
  String get addStorage_section_description => 'Description';

  @override
  String get addStorage_field_descriptionHint => 'Optional description';

  @override
  String get addStorage_button_update => 'Update';

  @override
  String get addStorage_button_add => 'Add';

  @override
  String get addStorage_button_deleteLocation => 'Delete Storage Location';

  @override
  String get storage_title => 'Storage';

  @override
  String storage_error_loading(String error) {
    return 'Error loading storage locations: $error';
  }

  @override
  String get nav_home => 'Home';

  @override
  String get nav_items => 'Items';

  @override
  String get nav_members => 'Members';

  @override
  String get nav_storage => 'Storage';

  @override
  String get nav_profile => 'Profile';

  @override
  String storage_subtitle(int count, int itemCount) {
    return '$count locations • $itemCount items';
  }

  @override
  String get storage_searchHint => 'Search locations...';

  @override
  String get storage_filterAll => 'All';

  @override
  String get storage_filterBasement => 'Basement';

  @override
  String get storage_filterClosets => 'Closets';

  @override
  String get storage_filterAttic => 'Attic';

  @override
  String get storage_sectionBoxes => 'Boxes';

  @override
  String get storage_sectionClosets => 'Closets';

  @override
  String get storage_sectionAreas => 'Areas';

  @override
  String get storage_sectionOther => 'Other Storage';

  @override
  String get storage_expandAll => 'Expand All';

  @override
  String get storage_noDescription => 'No description';

  @override
  String storage_itemsCount(int count) {
    return '$count items';
  }

  @override
  String get storage_viewItems => 'View Items';

  @override
  String get storage_quickActions => 'Quick Actions';

  @override
  String get storage_scanQrCode => 'Scan QR Code';

  @override
  String get storage_printLabels => 'Print Labels';

  @override
  String get members_subtitle => 'Manage family members';

  @override
  String get members_summaryMembers => 'Members';

  @override
  String get members_summaryTotalItems => 'Total Items';

  @override
  String get members_summaryNeedCheck => 'Need Check';

  @override
  String members_ageYears(int age) {
    return '$age years';
  }

  @override
  String members_born(String date) {
    return 'Born: $date';
  }

  @override
  String members_clothes(String size) {
    return 'Clothes: $size';
  }

  @override
  String members_shoes(String size) {
    return 'Shoes: $size';
  }

  @override
  String get members_hasItems => '✓ Has items';

  @override
  String get members_noItemsYet => 'No items yet';

  @override
  String get members_tooltipGrowthChart => 'Growth Chart';

  @override
  String get members_tooltipEdit => 'Edit';

  @override
  String get items_title => 'Items';

  @override
  String items_subtitle(int count) {
    return '$count total items';
  }

  @override
  String items_subtitleWithLocation(String location, int count) {
    return '$location • $count items';
  }

  @override
  String get items_filterAllItems => 'All Items';

  @override
  String get items_filterInUse => 'In Use';

  @override
  String get items_filterStored => 'Stored';

  @override
  String get items_filterWinter => 'Winter';

  @override
  String get items_filterSummer => 'Summer';

  @override
  String get items_quickFilters => 'Quick Filters';

  @override
  String get items_clearAll => 'Clear All';

  @override
  String get items_filterClothes => 'Clothes';

  @override
  String get items_filterShoes => 'Shoes';

  @override
  String get items_filterAccessories => 'Accessories';

  @override
  String items_sizeLabel(String size, String gender) {
    return 'Size $size • $gender';
  }

  @override
  String get items_noSeasonTags => 'No season tags';

  @override
  String items_quantity(int count) {
    return 'Quantity: $count';
  }

  @override
  String get items_statusInUse => 'In Use';

  @override
  String get items_statusStored => 'Stored';

  @override
  String get items_statusOutgrown => 'Outgrown';
}
