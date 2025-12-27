// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'SeasonBox';

  @override
  String get login_tagline =>
      'Organisieren Sie saisonale Artikel für Ihre Familie mit Leichtigkeit';

  @override
  String get login_featureCard_photoInventoryTitle => 'Foto-Inventar';

  @override
  String get login_featureCard_photoInventorySubtitle =>
      'Erfassen und organisieren Sie mit Fotos';

  @override
  String get login_featureCard_familySharingTitle => 'Familienfreigabe';

  @override
  String get login_featureCard_familySharingSubtitle =>
      'Synchronisieren Sie mit allen Mitgliedern';

  @override
  String get login_featureCard_smartRemindersTitle =>
      'Intelligente Erinnerungen';

  @override
  String get login_featureCard_smartRemindersSubtitle =>
      'Verpassen Sie nie Saisonwechsel';

  @override
  String get login_button_email => 'Mit Ihrer E-Mail anmelden';

  @override
  String get login_button_google => 'Mit Google fortfahren';

  @override
  String get login_button_biometric => 'Mit Biometrie anmelden';

  @override
  String get login_footer_terms => 'Indem Sie fortfahren, stimmen Sie unseren ';

  @override
  String get login_footer_termsOfService => 'Nutzungsbedingungen';

  @override
  String get login_footer_and => ' und ';

  @override
  String get login_footer_privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get login_error_googleCancelled =>
      'Die Google-Anmeldung wurde abgebrochen oder ist fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String login_error_signIn(String error) {
    return 'Anmeldefehler: $error';
  }

  @override
  String get login_error_invalidCredentials =>
      'Ungültige E-Mail oder Passwort. Bitte versuchen Sie es erneut.';

  @override
  String get emailLogin_title => 'Willkommen zurück';

  @override
  String get emailLogin_subtitle => 'Melden Sie sich an, um fortzufahren';

  @override
  String get emailLogin_field_email => 'E-Mail';

  @override
  String get emailLogin_field_password => 'Passwort';

  @override
  String get emailLogin_validation_emailRequired =>
      'Bitte geben Sie Ihre E-Mail ein';

  @override
  String get emailLogin_validation_passwordRequired =>
      'Bitte geben Sie Ihr Passwort ein';

  @override
  String get emailLogin_button_forgotPassword => 'Passwort vergessen?';

  @override
  String get emailLogin_button_login => 'Anmelden';

  @override
  String get emailLogin_error_emailFirst =>
      'Bitte geben Sie zuerst Ihre E-Mail ein';

  @override
  String get emailLogin_success_passwordReset =>
      'Passwort-Zurücksetzungs-E-Mail gesendet';

  @override
  String emailLogin_error_generic(String error) {
    return 'Fehler: $error';
  }

  @override
  String home_appBar_subtitle(String familyName) {
    return 'Familie $familyName';
  }

  @override
  String get home_stats_totalItems => 'Gesamtartikel';

  @override
  String get home_stats_members => 'Mitglieder';

  @override
  String home_subscription_itemLimit(int count, int limit) {
    return 'Artikellimit: $count / $limit';
  }

  @override
  String get home_subscription_upgradeForUnlimited => 'Upgrade für Unbegrenzt';

  @override
  String get home_subscription_limitReached =>
      'Artikellimit erreicht! Jetzt upgraden.';

  @override
  String get home_premium_banner_title =>
      'Entfesseln Sie unbegrenztes Potenzial';

  @override
  String get home_premium_banner_subtitle =>
      'Verwalten Sie unbegrenzte Artikel und Familienmitglieder mit SeasonBox Premium.';

  @override
  String get home_premium_banner_button => 'Jetzt Upgrade';

  @override
  String get home_search_hint => 'Artikel, Größen oder #Tag suchen';

  @override
  String get home_search_hint_revamped => 'Nach Titel, Größe oder #Tag suchen';

  @override
  String get home_section_quickActions => 'Schnellaktionen';

  @override
  String get home_section_familyMembers => 'Familienmitglieder';

  @override
  String get home_section_recentItems => 'Neueste Artikel';

  @override
  String get home_section_seasonalReminders => 'Saisonale Erinnerungen';

  @override
  String get home_section_storageLocations => 'Lagerorte';

  @override
  String get home_action_addItem => 'Artikel hinzufügen';

  @override
  String get home_action_scanQR => 'QR scannen';

  @override
  String get home_action_viewAll => 'Alle anzeigen';

  @override
  String get home_action_manage => 'Verwalten';

  @override
  String home_member_age(int age) {
    return 'Alter $age';
  }

  @override
  String home_member_size(String size) {
    return 'Größe $size';
  }

  @override
  String home_member_items(int count) {
    return '$count Artikel';
  }

  @override
  String get home_member_status_active => 'Aktiv';

  @override
  String get home_item_storage => 'Lagerung';

  @override
  String get home_reminder_fallTitle => 'Herbst naht';

  @override
  String get home_reminder_fallMessage =>
      'Zeit, die Herbstkleidung Ihrer Kinder zu überprüfen. Berücksichtigen Sie Größenänderungen vom letzten Jahr.';

  @override
  String get home_reminder_reviewItems => 'Artikel überprüfen';

  @override
  String home_error_loadingData(String error) {
    return 'Fehler beim Laden der Daten: $error';
  }

  @override
  String get addItem_title_add => 'Neuen Artikel hinzufügen';

  @override
  String get addItem_title_edit => 'Artikel bearbeiten';

  @override
  String get addItem_section_photos => 'Fotos';

  @override
  String get addItem_section_itemDetails => 'Artikeldetails';

  @override
  String get addItem_section_size => 'Größe';

  @override
  String get addItem_section_seasonMember => 'Saison & Mitglied';

  @override
  String get addItem_section_storageLocation => 'Lagerort';

  @override
  String get addItem_button_addPhoto => 'Foto hinzufügen';

  @override
  String get addItem_button_takePhoto => 'Foto aufnehmen';

  @override
  String get addItem_button_chooseGallery => 'Aus Galerie wählen';

  @override
  String get addItem_button_saveItem => 'Artikel speichern';

  @override
  String get addItem_field_itemName => 'Artikelname';

  @override
  String get addItem_field_itemNameHint => 'z.B., Winterjacke';

  @override
  String get addItem_field_category => 'Kategorie';

  @override
  String get addItem_field_gender => 'Geschlecht';

  @override
  String get addItem_field_size => 'Größe';

  @override
  String get addItem_field_customSize => 'Benutzerdefinierte Größe eingeben';

  @override
  String get addItem_field_customSizeHint => 'z.B., 32W, 10.5, usw.';

  @override
  String get addItem_field_quantity => 'Menge';

  @override
  String get addItem_field_seasons => 'Saison(en)';

  @override
  String get addItem_field_assignedTo => 'Zugewiesen an';

  @override
  String get addItem_field_assignedToHint => 'Mitglied auswählen';

  @override
  String get addItem_field_none => 'Keine';

  @override
  String get addItem_category_clothes => 'Kleidung';

  @override
  String get addItem_category_shoes => 'Schuhe';

  @override
  String get addItem_category_accessories => 'Accessoires';

  @override
  String get addItem_category_toys => 'Spielzeug';

  @override
  String get addItem_category_gear => 'Ausrüstung';

  @override
  String get gender_unisex => 'Unisex';

  @override
  String get gender_male => 'Männlich';

  @override
  String get gender_female => 'Weiblich';

  @override
  String get addItem_season_winter => 'Winter';

  @override
  String get addItem_season_spring => 'Frühling';

  @override
  String get addItem_season_summer => 'Sommer';

  @override
  String get addItem_season_fall => 'Herbst';

  @override
  String get addItem_size_other => 'Andere';

  @override
  String get addItem_validation_required => 'Erforderlich';

  @override
  String get addItem_validation_selectStorage =>
      'Bitte wählen Sie einen Lagerort';

  @override
  String get addItem_validation_selectSize => 'Bitte wählen Sie eine Größe';

  @override
  String get addItem_validation_enterSize => 'Bitte geben Sie eine Größe ein';

  @override
  String get addItem_success_added => 'Artikel erfolgreich hinzugefügt';

  @override
  String get addItem_success_updated => 'Artikel erfolgreich aktualisiert';

  @override
  String addItem_error_saving(String error) {
    return 'Fehler beim Speichern: $error';
  }

  @override
  String addItem_error_pickingImage(String error) {
    return 'Fehler beim Auswählen des Bildes: $error';
  }

  @override
  String addItem_error_loadingData(String error) {
    return 'Fehler beim Laden der Daten: $error';
  }

  @override
  String addItem_location_found(String name) {
    return 'Standort gefunden: $name';
  }

  @override
  String addItem_location_unknown(String code) {
    return 'Unbekannter Standortcode: $code';
  }

  @override
  String get addItem_section_tags => 'Tags';

  @override
  String get addItem_tags_hint => 'Tag hinzufügen (Farbe, Marke, Material...)';

  @override
  String get addItem_tags_limitReached => 'Maximal 5 Tags erlaubt';

  @override
  String get addItem_tags_duplicate => 'Tag existiert bereits';

  @override
  String get addItem_tags_mostUsed => 'Meistverwendete Tags';

  @override
  String get profile_title => 'Profil';

  @override
  String get profile_button_editProfile => 'Profil bearbeiten';

  @override
  String get profile_role_familyAdmin => 'Familienadministrator';

  @override
  String get profile_section_familyManagement => 'Familienverwaltung';

  @override
  String get profile_setting_subscription => 'Abonnement';

  @override
  String get profile_subscription_statusFree => 'Kostenloser Plan';

  @override
  String get profile_subscription_statusPremium => 'Premium-Plan';

  @override
  String get profile_section_appSettings => 'App-Einstellungen';

  @override
  String get profile_section_dataPrivacy => 'Daten & Datenschutz';

  @override
  String get profile_section_support => 'Support';

  @override
  String get profile_section_language => 'Sprache';

  @override
  String profile_family_name(String familyName) {
    return 'Familie $familyName';
  }

  @override
  String profile_family_members(int count) {
    return '$count Mitglieder • Sie sind Administrator';
  }

  @override
  String get profile_family_inviteMembers => 'Mitglieder einladen';

  @override
  String get profile_family_inviteSubtitle => 'Familienzugang teilen';

  @override
  String get profile_setting_darkMode => 'Dunkler Modus';

  @override
  String get profile_setting_darkModeSubtitle => 'Dunkles Design umschalten';

  @override
  String get profile_setting_notifications => 'Benachrichtigungen';

  @override
  String get profile_setting_notificationsSubtitle =>
      'Erinnerungen & Warnungen';

  @override
  String get profile_setting_seasonalReminders => 'Saisonale Erinnerungen';

  @override
  String get profile_setting_seasonalRemindersSubtitle =>
      'Automatische Saisonwarnungen';

  @override
  String get profile_setting_autoSync => 'Automatische Synchronisierung';

  @override
  String get profile_setting_autoSyncSubtitle => 'Cloud-Synchronisierung';

  @override
  String get profile_setting_biometricLogin => 'Biometrische Anmeldung';

  @override
  String get profile_setting_biometricLoginSubtitle =>
      'Face ID / Touch ID aktivieren';

  @override
  String get profile_setting_language => 'Sprache';

  @override
  String get profile_setting_languageSubtitle => 'App-Sprache ändern';

  @override
  String get profile_setting_statusTracking => 'Status-Tracking aktivieren';

  @override
  String get profile_setting_statusTrackingSubtitle =>
      'Nachverfolgen, ob Artikel in Gebrauch oder gelagert sind';

  @override
  String get profile_setting_quickAddItem =>
      'Schnelles Hinzufügen von Artikeln';

  @override
  String get profile_setting_quickAddItemSubtitle =>
      'Automatisch mit der Kamera für neue Artikel starten';

  @override
  String get profile_data_exportData => 'Daten exportieren';

  @override
  String get profile_data_exportDataSubtitle =>
      'Ihre Informationen herunterladen';

  @override
  String get profile_data_backupData => 'Daten sichern';

  @override
  String get profile_data_backupDataSubtitle => 'Sicherungskopie erstellen';

  @override
  String get profile_data_privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get profile_data_privacyPolicySubtitle =>
      'Wie wir Ihre Daten schützen';

  @override
  String get profile_support_helpCenter => 'Hilfecenter';

  @override
  String get profile_support_helpCenterSubtitle => 'FAQs und Anleitungen';

  @override
  String get profile_support_contactSupport => 'Support kontaktieren';

  @override
  String get profile_support_contactSupportSubtitle =>
      'Hilfe von unserem Team erhalten';

  @override
  String get profile_support_rateApp => 'App bewerten';

  @override
  String get profile_support_rateAppSubtitle => 'Teilen Sie Ihr Feedback';

  @override
  String get profile_dialog_logout_title => 'Abmelden';

  @override
  String get profile_dialog_logout_message =>
      'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get profile_dialog_logout_cancel => 'Abbrechen';

  @override
  String get profile_dialog_logout_confirm => 'Abmelden';

  @override
  String get profile_dialog_biometric_title =>
      'Biometrische Anmeldung aktivieren';

  @override
  String get profile_dialog_biometric_message =>
      'Bitte geben Sie Ihre E-Mail und Ihr Passwort ein, um sie sicher zu speichern.';

  @override
  String get profile_dialog_biometric_email => 'E-Mail';

  @override
  String get profile_dialog_biometric_password => 'Passwort';

  @override
  String get profile_dialog_biometric_cancel => 'Abbrechen';

  @override
  String get profile_dialog_biometric_enable => 'Aktivieren';

  @override
  String get profile_success_biometricEnabled =>
      'Biometrische Anmeldung aktiviert';

  @override
  String profile_error_logoutFailed(String error) {
    return 'Abmeldung fehlgeschlagen: $error';
  }

  @override
  String get language_english => 'Englisch';

  @override
  String get language_spanish => 'Spanisch';

  @override
  String get language_french => 'Französisch';

  @override
  String get language_italian => 'Italienisch';

  @override
  String get language_german => 'Deutsch';

  @override
  String get common_loading => 'Wird geladen...';

  @override
  String get common_save => 'Speichern';

  @override
  String get common_cancel => 'Abbrechen';

  @override
  String get common_delete => 'Löschen';

  @override
  String get common_edit => 'Bearbeiten';

  @override
  String get common_add => 'Hinzufügen';

  @override
  String get common_search => 'Suchen';

  @override
  String get common_filter => 'Filtern';

  @override
  String get common_error => 'Fehler';

  @override
  String get common_success => 'Erfolg';

  @override
  String get common_comingSoon => 'Demnächst verfügbar';

  @override
  String get addMember_title_add => 'Familienmitglied Hinzufügen';

  @override
  String get addMember_title_edit => 'Familienmitglied Bearbeiten';

  @override
  String get addMember_success_added =>
      'Familienmitglied erfolgreich hinzugefügt';

  @override
  String get addMember_success_updated =>
      'Familienmitglied erfolgreich aktualisiert';

  @override
  String get addMember_success_deleted =>
      'Familienmitglied erfolgreich gelöscht';

  @override
  String addMember_error_saving(String error) {
    return 'Fehler beim Speichern des Mitglieds: $error';
  }

  @override
  String addMember_error_deleting(String error) {
    return 'Fehler beim Löschen des Mitglieds: $error';
  }

  @override
  String get addMember_dialog_delete_title => 'Mitglied Löschen';

  @override
  String get addMember_dialog_delete_message =>
      'Sind Sie sicher, dass Sie dieses Familienmitglied löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get addMember_section_basicInfo => 'Grundinformationen';

  @override
  String get addMember_field_name => 'Name des Mitglieds';

  @override
  String get addMember_field_nameHint => 'Vollständigen Namen eingeben';

  @override
  String get addMember_field_gender => 'Geschlecht';

  @override
  String get addMember_field_birthdate => 'Geburtsdatum';

  @override
  String get addMember_field_birthdateHint => 'tt.mm.jjjj';

  @override
  String get addMember_field_birthdate_explanation =>
      'Das Geburtsdatum wird verwendet, um das Alter zu berechnen und alterspezifische Wachstumsprognosen zu erstellen.';

  @override
  String get addMember_section_sizes => 'Aktuelle Größen';

  @override
  String get addMember_section_sizes_explanation =>
      'Aktuelle Größen werden als Basis verwendet, um zukünftige Größen basierend auf Wachstumsmustern vorherzusagen.';

  @override
  String get addMember_field_clothingSize => 'Kleidergröße';

  @override
  String get addMember_field_clothingSizeHint => 'z.B. 110 (cm) oder 5 (Alter)';

  @override
  String get addMember_field_shoeSize => 'Schuhgröße';

  @override
  String get addMember_field_shoeSizeHint => 'z.B. 28';

  @override
  String get addMember_section_notes => 'Zusätzliche Notizen';

  @override
  String get addMember_field_notesHint =>
      'Besondere Notizen über die Vorlieben dieses Kindes, usw.';

  @override
  String get addMember_button_update => 'Aktualisieren';

  @override
  String get addMember_button_add => 'Hinzufügen';

  @override
  String get addMember_button_deleteMember => 'Mitglied Löschen';

  @override
  String get addMember_section_accountAccess => 'Kontozugriff';

  @override
  String get addMember_field_inviteEmail => 'Einladungs-E-Mail';

  @override
  String get addMember_field_inviteEmailHint => 'E-Mail-Adresse eingeben';

  @override
  String get addMember_button_sendInvite => 'Einladung senden';

  @override
  String get addMember_button_resendInvite => 'Einladung erneut senden';

  @override
  String get addMember_status_pending => 'Einladung ausstehend';

  @override
  String get addMember_status_accepted => 'Einladung angenommen';

  @override
  String addMember_status_inviteSent(Object email) {
    return 'Einladung gesendet an $email';
  }

  @override
  String addMember_status_accountLinked(Object email) {
    return 'Konto verknüpft: $email';
  }

  @override
  String get addMember_error_invalidEmail =>
      'Bitte geben Sie eine gültige E-Mail ein';

  @override
  String get addMember_field_role => 'Mitgliedsrolle';

  @override
  String get addMember_role_admin => 'Admin';

  @override
  String get addMember_role_coAdmin => 'Co-Administrator';

  @override
  String get addMember_role_member => 'Mitglied';

  @override
  String get addMember_role_child => 'Kind';

  @override
  String get addMember_invite_description =>
      'Laden Sie Familienmitglieder ein, Ihrer SeasonBox-Familie beizutreten. Sie können Artikel je nach Rolle anzeigen und verwalten.';

  @override
  String get addMember_validation_nameRequired =>
      'Bitte geben Sie einen Namen ein';

  @override
  String get addMember_dialog_cancelInvite_title => 'Einladung stornieren';

  @override
  String get addMember_dialog_cancelInvite_message =>
      'Möchten Sie diese Einladung wirklich stornieren? Der Benutzer kann dieser Einladung nicht mehr beitreten.';

  @override
  String get addMember_button_cancelInvite => 'Einladung stornieren';

  @override
  String addMember_share_message(String familyId) {
    return 'Tritt meiner SeasonBox-Familie bei! Verwende den Code: $familyId';
  }

  @override
  String get addMember_action_share => 'Einladung teilen';

  @override
  String get addMember_action_copy => 'Code kopieren';

  @override
  String get addMember_snack_copied =>
      'Familien-ID in die Zwischenablage kopiert';

  @override
  String get register_title => 'Konto erstellen';

  @override
  String get register_subtitle => 'Der SeasonBox-Familie beitreten';

  @override
  String get register_field_name => 'Vollständiger Name';

  @override
  String get register_field_familyCode => 'Familiencode (Optional)';

  @override
  String get register_button_create => 'Konto erstellen';

  @override
  String get register_link_login => 'Haben Sie bereits ein Konto? Anmelden';

  @override
  String get register_text_noAccount => 'Noch kein Konto?';

  @override
  String get register_link_registerNow => 'Jetzt registrieren';

  @override
  String get register_error_familyNotFound => 'Familie nicht gefunden';

  @override
  String get register_success => 'Konto erfolgreich erstellt';

  @override
  String get profile_joinFamily_title => 'Familie beitreten';

  @override
  String get profile_joinFamily_input => 'Familiencode eingeben';

  @override
  String get profile_leaveFamily_title => 'Familie verlassen';

  @override
  String get profile_leaveFamily_confirm =>
      'Sind Sie sicher, dass Sie diese Familie verlassen möchten? Sie werden aus der Mitgliederliste entfernt.';

  @override
  String get profile_disbandFamily_confirm =>
      'Warnung: Sie sind der Administrator. Wenn Sie gehen, werden alle Mitglieder entfernt und die Familiengruppe gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get register_validation_passwordLength =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get error_no_invitation =>
      'Keine aktive Einladung für diese Familie gefunden.';

  @override
  String get profile_joinFamily_success => 'Familie erfolgreich beigetreten';

  @override
  String get profile_leaveFamily_success => 'Familie erfolgreich verlassen';

  @override
  String get members_title => 'Familienmitglieder';

  @override
  String get members_label_currentSize => 'Aktuelle Größe';

  @override
  String get members_label_items => 'Artikel';

  @override
  String get members_button_viewItems => 'Artikel Anzeigen';

  @override
  String get members_empty => 'Noch keine Mitglieder hinzugefügt';

  @override
  String members_error_loading(String error) {
    return 'Fehler beim Laden der Daten: $error';
  }

  @override
  String get addStorage_title_add => 'Lagerort Hinzufügen';

  @override
  String get addStorage_title_edit => 'Lagerort Bearbeiten';

  @override
  String get addStorage_success_added => 'Lagerort erfolgreich hinzugefügt';

  @override
  String get addStorage_success_updated => 'Lagerort erfolgreich aktualisiert';

  @override
  String get addStorage_success_deleted => 'Lagerort erfolgreich gelöscht';

  @override
  String addStorage_error_saving(String error) {
    return 'Fehler beim Speichern des Standorts: $error';
  }

  @override
  String addStorage_error_deleting(String error) {
    return 'Fehler beim Löschen des Standorts: $error';
  }

  @override
  String get addStorage_dialog_delete_title => 'Lagerort Löschen';

  @override
  String get addStorage_dialog_delete_message =>
      'Sind Sie sicher, dass Sie diesen Lagerort löschen möchten?';

  @override
  String get addStorage_section_type => 'Lagertyp';

  @override
  String get addStorage_section_basicInfo => 'Grundinformationen';

  @override
  String get addStorage_field_name => 'Lagername';

  @override
  String get addStorage_field_nameHint => 'Lagername eingeben';

  @override
  String get addStorage_field_parent => 'Übergeordneter Standort (Optional)';

  @override
  String get addStorage_field_parentNone => 'Keine (oberste Ebene)';

  @override
  String get addStorage_section_description => 'Beschreibung';

  @override
  String get addStorage_field_descriptionHint => 'Optionale Beschreibung';

  @override
  String get addStorage_button_update => 'Aktualisieren';

  @override
  String get addStorage_button_add => 'Hinzufügen';

  @override
  String get addStorage_button_deleteLocation => 'Lagerort Löschen';

  @override
  String get storage_title => 'Lagerung';

  @override
  String storage_error_loading(String error) {
    return 'Fehler beim Laden der Lagerorte: $error';
  }

  @override
  String get nav_home => 'Startseite';

  @override
  String get nav_items => 'Artikel';

  @override
  String get nav_members => 'Mitglieder';

  @override
  String get nav_storage => 'Lagerung';

  @override
  String get nav_profile => 'Profil';

  @override
  String storage_subtitle(int count, int itemCount) {
    return '$count Standorte • $itemCount Artikel';
  }

  @override
  String get storage_searchHint => 'Standorte suchen...';

  @override
  String get storage_filterAll => 'Alle';

  @override
  String get storage_filterBasement => 'Keller';

  @override
  String get storage_filterClosets => 'Schränke';

  @override
  String get storage_filterAttic => 'Dachboden';

  @override
  String get storage_sectionBoxes => 'Kisten';

  @override
  String get storage_sectionClosets => 'Schränke';

  @override
  String get storage_sectionAreas => 'Bereiche';

  @override
  String get storage_sectionOther => 'Anderer Lagerraum';

  @override
  String get storage_expandAll => 'Alle Erweitern';

  @override
  String get storage_noDescription => 'Keine Beschreibung';

  @override
  String storage_itemsCount(int count) {
    return '$count Artikel';
  }

  @override
  String get storage_viewItems => 'Artikel Anzeigen';

  @override
  String get storage_quickActions => 'Schnellaktionen';

  @override
  String get storage_scanQrCode => 'QR-Code Scannen';

  @override
  String get storage_printLabels => 'Etiketten Drucken';

  @override
  String get members_subtitle => 'Familienmitglieder verwalten';

  @override
  String get members_summaryMembers => 'Mitglieder';

  @override
  String get members_summaryTotalItems => 'Gesamt Artikel';

  @override
  String get members_summaryNeedCheck => 'Prüfung Nötig';

  @override
  String members_ageYears(int age) {
    return '$age Jahre';
  }

  @override
  String get members_birthdate_notSet => 'Geburtsdatum nicht festgelegt';

  @override
  String get members_dialog_birthdateRequired_title =>
      'Geburtsdatum erforderlich';

  @override
  String get members_dialog_birthdateRequired_message =>
      'Ein Geburtsdatum wird benötigt, um das Alter des Mitglieds zu berechnen und genaue Wachstumsprognosen und Meilensteine in den Diagrammen anzuzeigen.';

  @override
  String get members_dialog_birthdateRequired_button =>
      'Geburtsdatum festlegen';

  @override
  String get members_dialog_sizeRequired_title =>
      'Größeninformationen erforderlich';

  @override
  String get members_dialog_sizeRequired_message =>
      'Aktuelle Kleidungs- oder Schuhgrößen werden als Basis benötigt, um zukünftige Größen basierend auf Wachstumsmustern vorherzusagen.';

  @override
  String get members_dialog_sizeRequired_button => 'Größen festlegen';

  @override
  String members_born(String date) {
    return 'Geboren: $date';
  }

  @override
  String members_clothes(String size) {
    return 'Kleidung: $size';
  }

  @override
  String members_shoes(String size) {
    return 'Schuhe: $size';
  }

  @override
  String get members_hasItems => '✓ Hat Artikel';

  @override
  String get members_noItemsYet => 'Noch keine Artikel';

  @override
  String get members_tooltipGrowthChart => 'Wachstumstabelle';

  @override
  String get members_growthChart_actual => 'Tatsächlicher Verlauf';

  @override
  String get members_growthChart_expectation => 'Erwartung';

  @override
  String members_growthChart_insight(String name, int months) {
    return 'Basierend auf dem aktuellen Wachstum wird $name voraussichtlich in etwa $months Monaten eine neue Größe benötigen.';
  }

  @override
  String members_growthChart_noGrowth(String name) {
    return '$name hat die körperliche Reife erreicht. Das Standardwachstum endet in der Regel nach dem 18. Lebensjahr.';
  }

  @override
  String get members_growthChart_reference =>
      'Wachstumsmodelle basieren auf den Kinderwachstumsstandards der Weltgesundheitsorganisation (WHO).';

  @override
  String get members_tooltipEdit => 'Bearbeiten';

  @override
  String get items_title => 'Artikel';

  @override
  String items_subtitle(int count) {
    return '$count Artikel insgesamt';
  }

  @override
  String items_subtitleWithLocation(String location, int count) {
    return '$location • $count Artikel';
  }

  @override
  String get items_filterAllItems => 'Alle';

  @override
  String get items_filterInUse => 'In Gebrauch';

  @override
  String get items_filterStored => 'Gelagert';

  @override
  String get items_filterWinter => 'Winter';

  @override
  String get items_filterSummer => 'Sommer';

  @override
  String get items_quickFilters => 'Schnellfilter';

  @override
  String get items_clearAll => 'Alles Löschen';

  @override
  String get items_filterClothes => 'Kleidung';

  @override
  String get items_filterShoes => 'Schuhe';

  @override
  String get items_filterAccessories => 'Zubehör';

  @override
  String items_sizeLabel(String size, String gender) {
    return 'Größe $size • $gender';
  }

  @override
  String get items_filter_title => 'Filter';

  @override
  String get items_filter_category => 'Kategorie';

  @override
  String get items_filter_gender => 'Geschlecht';

  @override
  String get items_filter_status => 'Status';

  @override
  String get items_filter_member => 'Mitglied';

  @override
  String get items_filter_active => 'Aktive Filter';

  @override
  String get items_noSeasonTags => 'Keine Saison-Tags';

  @override
  String items_quantity(int count) {
    return 'Menge: $count';
  }

  @override
  String get items_statusInUse => 'In Gebrauch';

  @override
  String get items_statusStored => 'Gelagert';

  @override
  String get items_statusOutgrown => 'Herausgewachsen';

  @override
  String get editProfile_title => 'Profil bearbeiten';

  @override
  String get editProfile_changePhoto => 'Foto ändern';

  @override
  String get editProfile_section_personalInfo => 'Persönliche Informationen';

  @override
  String get editProfile_field_fullName => 'Vollständiger Name';

  @override
  String get editProfile_field_email => 'E-Mail-Adresse';

  @override
  String get editProfile_hint_emailCannotChanged =>
      'E-Mail kann nicht geändert werden';

  @override
  String get editProfile_field_phone => 'Telefonnummer';

  @override
  String get editProfile_field_role => 'Rolle';

  @override
  String get editProfile_section_preferences => 'Einstellungen';

  @override
  String get editProfile_pref_emailNotifications => 'E-Mail-Benachrichtigungen';

  @override
  String get editProfile_pref_emailNotificationsSubtitle =>
      'Updates per E-Mail erhalten';

  @override
  String get editProfile_pref_pushNotifications => 'Push-Benachrichtigungen';

  @override
  String get editProfile_pref_pushNotificationsSubtitle =>
      'Benachrichtigungen auf dem Gerät erhalten';

  @override
  String get editProfile_pref_weeklyDigest => 'Wöchentliche Zusammenfassung';

  @override
  String get editProfile_pref_weeklyDigestSubtitle =>
      'Zusammenfassung der Familienaktivität';

  @override
  String get editProfile_section_unitsDisplay => 'Einheiten & Anzeige';

  @override
  String get editProfile_field_measurementSystem => 'Maßsystem';

  @override
  String get editProfile_option_imperial => 'Imperial (US)';

  @override
  String get editProfile_option_metric => 'Metrisch';

  @override
  String get editProfile_button_saveChanges => 'Änderungen speichern';

  @override
  String get notifications_title => 'Benachrichtigungen';

  @override
  String get notifications_empty => 'Keine neuen Benachrichtigungen';

  @override
  String get notifications_invite_title => 'Einladung zum Familienbeitritt';

  @override
  String notifications_invite_message(String inviterName) {
    return '$inviterName hat dich eingeladen, der Familie beizutreten.';
  }

  @override
  String notifications_invite_familyId(String familyId) {
    return 'Familien-ID: $familyId';
  }

  @override
  String get notifications_action_accept => 'Annehmen';

  @override
  String get notifications_action_reject => 'Ablehnen';

  @override
  String get notifications_success_joined => 'Familie erfolgreich beigetreten!';

  @override
  String get notifications_success_rejected => 'Einladung abgelehnt.';

  @override
  String notifications_error_joining(String error) {
    return 'Fehler beim Beitreten der Familie: $error';
  }

  @override
  String notifications_error_rejecting(String error) {
    return 'Fehler beim Ablehnen der Einladung: $error';
  }

  @override
  String get subscription_title => 'Abonnement';

  @override
  String get subscription_subtitle =>
      'Wählen Sie den besten Plan für Ihre Familie';

  @override
  String get subscription_billing_monthly => 'Monatlich';

  @override
  String get subscription_billing_yearly => 'Jährlich';

  @override
  String get subscription_tier_freeTitle => 'Kostenlose Stufe';

  @override
  String get subscription_tier_premiumTitle => 'Premium-Stufe';

  @override
  String get subscription_tier_freePrice => 'Kostenlos';

  @override
  String subscription_tier_premiumPrice(String price, String period) {
    return '€$price$period';
  }

  @override
  String get subscription_tier_freeDesc => 'Ideal für den Einstieg';

  @override
  String get subscription_tier_premiumDesc =>
      'Unbegrenzter Zugang für vielbeschäftigte Familien';

  @override
  String get subscription_feature_items_free => 'Bis zu 50 Artikel';

  @override
  String get subscription_feature_photos_free => '3 Fotos pro Artikel';

  @override
  String get subscription_feature_storage_free => 'Standard-Lagerverfolgung';

  @override
  String get subscription_feature_items_premium => 'Unbegrenzte Artikel';

  @override
  String get subscription_feature_members_premium =>
      'Unbegrenzte Familienmitglieder';

  @override
  String get subscription_feature_sharing_premium =>
      'Vollständiges Familien-Sharing';

  @override
  String get subscription_feature_growth_premium =>
      'Wachstumsprognosen & Beratung';

  @override
  String get subscription_feature_reminders_premium => 'Saisonale Erinnerungen';

  @override
  String get subscription_currentPlan => 'Aktueller Plan';

  @override
  String get subscription_selectPlan => 'Plan auswählen';

  @override
  String subscription_savingsLabel(String percent) {
    return 'Sparen Sie $percent%';
  }

  @override
  String get subscription_bestValue => 'BESTES ANGEBOT';

  @override
  String get subscription_cancelAnytime =>
      'Jederzeit kündbar. Bestehende Artikel bleiben auch nach der Kündigung sichtbar.';

  @override
  String get members_tooltip_editPermission =>
      'Nur Administratoren können andere Mitglieder bearbeiten';

  @override
  String get members_button_filter => 'Filtern';

  @override
  String get members_dialog_limitReached_title => 'Limit Erreicht';

  @override
  String get members_dialog_limitReached_message =>
      'Die kostenlose Stufe ist auf 4 Mitglieder begrenzt. Upgraden Sie auf Bezahlt für unbegrenzte Mitglieder und vollständiges Familien-Sharing!';

  @override
  String get members_dialog_limitReached_maybeLater => 'Vielleicht Später';

  @override
  String get members_dialog_limitReached_viewPricing => 'Preise Ansehen';

  @override
  String get growthChart_premium_title => 'Wachstumsprognosen sind Premium';

  @override
  String get growthChart_premium_message =>
      'Upgraden Sie auf den Bezahlplan, um zu sehen, wie Ihre Kinder wachsen, und Ratschläge zu erhalten, wann Sie die nächsten Größen kaufen sollten.';

  @override
  String get growthChart_premium_viewPricing => 'Preise Ansehen';
}
