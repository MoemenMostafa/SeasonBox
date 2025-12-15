// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'SeasonBox';

  @override
  String get login_tagline =>
      'Organizza gli articoli stagionali per la tua famiglia con facilità';

  @override
  String get login_featureCard_photoInventoryTitle => 'Inventario Fotografico';

  @override
  String get login_featureCard_photoInventorySubtitle =>
      'Cattura e organizza con le foto';

  @override
  String get login_featureCard_familySharingTitle => 'Condivisione Familiare';

  @override
  String get login_featureCard_familySharingSubtitle =>
      'Sincronizza con tutti i membri';

  @override
  String get login_featureCard_smartRemindersTitle => 'Promemoria Intelligenti';

  @override
  String get login_featureCard_smartRemindersSubtitle =>
      'Non perdere mai i cambi di stagione';

  @override
  String get login_button_email => 'Accedi con la tua email';

  @override
  String get login_button_google => 'Continua con Google';

  @override
  String get login_button_biometric => 'Accedi con biometria';

  @override
  String get login_footer_terms => 'Continuando, accetti i nostri ';

  @override
  String get login_footer_termsOfService => 'Termini di Servizio';

  @override
  String get login_footer_and => ' e la ';

  @override
  String get login_footer_privacyPolicy => 'Informativa sulla Privacy';

  @override
  String get login_error_googleCancelled =>
      'L\'accesso con Google è stato annullato o non è riuscito. Riprova.';

  @override
  String login_error_signIn(String error) {
    return 'Errore di accesso: $error';
  }

  @override
  String get login_error_invalidCredentials =>
      'Email o password non validi. Riprova.';

  @override
  String get emailLogin_title => 'Bentornato';

  @override
  String get emailLogin_subtitle => 'Accedi per continuare';

  @override
  String get emailLogin_field_email => 'Email';

  @override
  String get emailLogin_field_password => 'Password';

  @override
  String get emailLogin_validation_emailRequired => 'Inserisci la tua email';

  @override
  String get emailLogin_validation_passwordRequired =>
      'Inserisci la tua password';

  @override
  String get emailLogin_button_forgotPassword => 'Password dimenticata?';

  @override
  String get emailLogin_button_login => 'Accedi';

  @override
  String get emailLogin_error_emailFirst => 'Inserisci prima la tua email';

  @override
  String get emailLogin_success_passwordReset =>
      'Email di reimpostazione inviata';

  @override
  String emailLogin_error_generic(String error) {
    return 'Errore: $error';
  }

  @override
  String home_appBar_subtitle(String familyName) {
    return 'Famiglia $familyName';
  }

  @override
  String get home_stats_totalItems => 'Articoli Totali';

  @override
  String get home_stats_members => 'Membri';

  @override
  String get home_search_hint => 'Cerca articoli, posizioni...';

  @override
  String get home_section_quickActions => 'Azioni Rapide';

  @override
  String get home_section_familyMembers => 'Membri della Famiglia';

  @override
  String get home_section_recentItems => 'Articoli Recenti';

  @override
  String get home_section_seasonalReminders => 'Promemoria Stagionali';

  @override
  String get home_section_storageLocations => 'Posizioni di Archiviazione';

  @override
  String get home_action_addItem => 'Aggiungi Articolo';

  @override
  String get home_action_scanQR => 'Scansiona QR';

  @override
  String get home_action_viewAll => 'Vedi Tutto';

  @override
  String get home_action_manage => 'Gestisci';

  @override
  String home_member_age(int age) {
    return 'Età $age';
  }

  @override
  String home_member_size(String size) {
    return 'Taglia $size';
  }

  @override
  String home_member_items(int count) {
    return '$count articoli';
  }

  @override
  String get home_member_status_active => 'Attivo';

  @override
  String get home_item_storage => 'Archiviazione';

  @override
  String get home_reminder_fallTitle => 'L\'Autunno si Avvicina';

  @override
  String get home_reminder_fallMessage =>
      'È ora di controllare i vestiti autunnali dei tuoi bambini. Considera i cambiamenti di taglia dall\'anno scorso.';

  @override
  String get home_reminder_reviewItems => 'Rivedi Articoli';

  @override
  String home_error_loadingData(String error) {
    return 'Errore nel caricamento dei dati: $error';
  }

  @override
  String get addItem_title_add => 'Aggiungi Nuovo Articolo';

  @override
  String get addItem_title_edit => 'Modifica Articolo';

  @override
  String get addItem_section_photos => 'Foto';

  @override
  String get addItem_section_itemDetails => 'Dettagli dell\'Articolo';

  @override
  String get addItem_section_size => 'Taglia';

  @override
  String get addItem_section_seasonMember => 'Stagione e Membro';

  @override
  String get addItem_section_storageLocation => 'Posizione di Archiviazione';

  @override
  String get addItem_button_addPhoto => 'Aggiungi Foto';

  @override
  String get addItem_button_takePhoto => 'Scatta Foto';

  @override
  String get addItem_button_chooseGallery => 'Scegli dalla Galleria';

  @override
  String get addItem_button_saveItem => 'Salva Articolo';

  @override
  String get addItem_field_itemName => 'Nome Articolo';

  @override
  String get addItem_field_itemNameHint => 'es., Giacca Invernale';

  @override
  String get addItem_field_category => 'Categoria';

  @override
  String get addItem_field_gender => 'Genere';

  @override
  String get addItem_field_size => 'Taglia';

  @override
  String get addItem_field_customSize => 'Inserisci Taglia Personalizzata';

  @override
  String get addItem_field_customSizeHint => 'es., 32W, 10.5, ecc.';

  @override
  String get addItem_field_quantity => 'Quantità';

  @override
  String get addItem_field_seasons => 'Stagione/i';

  @override
  String get addItem_field_assignedTo => 'Assegnato a';

  @override
  String get addItem_field_assignedToHint => 'Seleziona membro';

  @override
  String get addItem_field_none => 'Nessuno';

  @override
  String get addItem_category_clothes => 'Vestiti';

  @override
  String get addItem_category_shoes => 'Scarpe';

  @override
  String get addItem_category_accessories => 'Accessori';

  @override
  String get addItem_category_toys => 'Giocattoli';

  @override
  String get addItem_category_gear => 'Attrezzatura';

  @override
  String get addItem_gender_unisex => 'Unisex';

  @override
  String get addItem_gender_boy => 'Maschio';

  @override
  String get addItem_gender_girl => 'Femmina';

  @override
  String get addItem_season_winter => 'Inverno';

  @override
  String get addItem_season_spring => 'Primavera';

  @override
  String get addItem_season_summer => 'Estate';

  @override
  String get addItem_season_fall => 'Autunno';

  @override
  String get addItem_size_other => 'Altro';

  @override
  String get addItem_validation_required => 'Obbligatorio';

  @override
  String get addItem_validation_selectStorage =>
      'Seleziona una posizione di archiviazione';

  @override
  String get addItem_validation_selectSize => 'Seleziona una taglia';

  @override
  String get addItem_validation_enterSize => 'Inserisci una taglia';

  @override
  String get addItem_success_added => 'Articolo aggiunto con successo';

  @override
  String get addItem_success_updated => 'Articolo aggiornato con successo';

  @override
  String addItem_error_saving(String error) {
    return 'Errore nel salvataggio: $error';
  }

  @override
  String addItem_error_pickingImage(String error) {
    return 'Errore nella selezione dell\'immagine: $error';
  }

  @override
  String addItem_error_loadingData(String error) {
    return 'Errore nel caricamento dei dati: $error';
  }

  @override
  String addItem_location_found(String name) {
    return 'Posizione trovata: $name';
  }

  @override
  String addItem_location_unknown(String code) {
    return 'Codice posizione sconosciuto: $code';
  }

  @override
  String get profile_title => 'Profilo';

  @override
  String get profile_button_editProfile => 'Modifica Profilo';

  @override
  String get profile_role_familyAdmin => 'Amministratore Famiglia';

  @override
  String get profile_section_familyManagement => 'Gestione Famiglia';

  @override
  String get profile_section_appSettings => 'Impostazioni App';

  @override
  String get profile_section_dataPrivacy => 'Dati e Privacy';

  @override
  String get profile_section_support => 'Supporto';

  @override
  String get profile_section_language => 'Lingua';

  @override
  String profile_family_name(String familyName) {
    return 'Famiglia $familyName';
  }

  @override
  String profile_family_members(int count) {
    return '$count membri • Sei amministratore';
  }

  @override
  String get profile_family_inviteMembers => 'Invita Membri';

  @override
  String get profile_family_inviteSubtitle => 'Condividi accesso familiare';

  @override
  String get profile_setting_darkMode => 'Modalità Scura';

  @override
  String get profile_setting_darkModeSubtitle => 'Attiva tema scuro';

  @override
  String get profile_setting_notifications => 'Notifiche';

  @override
  String get profile_setting_notificationsSubtitle => 'Promemoria e avvisi';

  @override
  String get profile_setting_seasonalReminders => 'Promemoria Stagionali';

  @override
  String get profile_setting_seasonalRemindersSubtitle =>
      'Avvisi automatici di stagione';

  @override
  String get profile_setting_autoSync => 'Sincronizzazione Automatica';

  @override
  String get profile_setting_autoSyncSubtitle => 'Sincronizzazione cloud';

  @override
  String get profile_setting_biometricLogin => 'Accesso Biometrico';

  @override
  String get profile_setting_biometricLoginSubtitle =>
      'Attiva Face ID / Touch ID';

  @override
  String get profile_setting_language => 'Lingua';

  @override
  String get profile_setting_languageSubtitle => 'Cambia lingua dell\'app';

  @override
  String get profile_data_exportData => 'Esporta Dati';

  @override
  String get profile_data_exportDataSubtitle => 'Scarica le tue informazioni';

  @override
  String get profile_data_backupData => 'Backup Dati';

  @override
  String get profile_data_backupDataSubtitle => 'Crea copia di backup';

  @override
  String get profile_data_privacyPolicy => 'Informativa sulla Privacy';

  @override
  String get profile_data_privacyPolicySubtitle =>
      'Come proteggiamo i tuoi dati';

  @override
  String get profile_support_helpCenter => 'Centro Assistenza';

  @override
  String get profile_support_helpCenterSubtitle => 'FAQ e tutorial';

  @override
  String get profile_support_contactSupport => 'Contatta Supporto';

  @override
  String get profile_support_contactSupportSubtitle =>
      'Ricevi aiuto dal nostro team';

  @override
  String get profile_support_rateApp => 'Valuta App';

  @override
  String get profile_support_rateAppSubtitle => 'Condividi il tuo feedback';

  @override
  String get profile_dialog_logout_title => 'Disconnetti';

  @override
  String get profile_dialog_logout_message =>
      'Sei sicuro di volerti disconnettere?';

  @override
  String get profile_dialog_logout_cancel => 'Annulla';

  @override
  String get profile_dialog_logout_confirm => 'Disconnetti';

  @override
  String get profile_dialog_biometric_title => 'Attiva Accesso Biometrico';

  @override
  String get profile_dialog_biometric_message =>
      'Inserisci email e password per archiviarli in modo sicuro.';

  @override
  String get profile_dialog_biometric_email => 'Email';

  @override
  String get profile_dialog_biometric_password => 'Password';

  @override
  String get profile_dialog_biometric_cancel => 'Annulla';

  @override
  String get profile_dialog_biometric_enable => 'Attiva';

  @override
  String get profile_success_biometricEnabled => 'Accesso biometrico attivato';

  @override
  String profile_error_logoutFailed(String error) {
    return 'Disconnessione fallita: $error';
  }

  @override
  String get language_english => 'Inglese';

  @override
  String get language_spanish => 'Spagnolo';

  @override
  String get language_french => 'Francese';

  @override
  String get language_italian => 'Italiano';

  @override
  String get language_german => 'Tedesco';

  @override
  String get common_loading => 'Caricamento...';

  @override
  String get common_save => 'Salva';

  @override
  String get common_cancel => 'Annulla';

  @override
  String get common_delete => 'Elimina';

  @override
  String get common_edit => 'Modifica';

  @override
  String get common_add => 'Aggiungi';

  @override
  String get common_search => 'Cerca';

  @override
  String get common_filter => 'Filtra';

  @override
  String get common_error => 'Errore';

  @override
  String get common_success => 'Successo';

  @override
  String get common_comingSoon => 'Prossimamente';

  @override
  String get addMember_title_add => 'Aggiungi Membro Familiare';

  @override
  String get addMember_title_edit => 'Modifica Membro Familiare';

  @override
  String get addMember_success_added =>
      'Membro familiare aggiunto con successo';

  @override
  String get addMember_success_updated =>
      'Membro familiare aggiornato con successo';

  @override
  String get addMember_success_deleted =>
      'Membro familiare eliminato con successo';

  @override
  String addMember_error_saving(String error) {
    return 'Errore nel salvataggio del membro: $error';
  }

  @override
  String addMember_error_deleting(String error) {
    return 'Errore nell\'eliminazione del membro: $error';
  }

  @override
  String get addMember_dialog_delete_title => 'Elimina Membro';

  @override
  String get addMember_dialog_delete_message =>
      'Sei sicuro di voler eliminare questo membro familiare? Questa azione non può essere annullata.';

  @override
  String get addMember_section_basicInfo => 'Informazioni di Base';

  @override
  String get addMember_field_name => 'Nome del Membro';

  @override
  String get addMember_field_nameHint => 'Inserisci nome completo';

  @override
  String get addMember_field_gender => 'Genere';

  @override
  String get addMember_field_birthdate => 'Data di Nascita';

  @override
  String get addMember_field_birthdateHint => 'gg/mm/aaaa';

  @override
  String get addMember_section_sizes => 'Taglie Attuali';

  @override
  String get addMember_field_clothingSize => 'Taglia Vestiti';

  @override
  String get addMember_field_clothingSizeHint => 'es. 110 (cm) o 5 (età)';

  @override
  String get addMember_field_shoeSize => 'Numero Scarpe';

  @override
  String get addMember_field_shoeSizeHint => 'es. 28';

  @override
  String get addMember_section_notes => 'Note Aggiuntive';

  @override
  String get addMember_field_notesHint =>
      'Note speciali sulle preferenze di questo bambino, ecc.';

  @override
  String get addMember_button_update => 'Aggiorna';

  @override
  String get addMember_button_add => 'Aggiungi';

  @override
  String get addMember_button_deleteMember => 'Elimina Membro';

  @override
  String get addMember_validation_nameRequired => 'Inserisci un nome';

  @override
  String get members_title => 'Membri della Famiglia';

  @override
  String get members_label_currentSize => 'Taglia Attuale';

  @override
  String get members_label_items => 'Articoli';

  @override
  String get members_button_viewItems => 'Vedi Articoli';

  @override
  String get members_empty => 'Nessun membro aggiunto ancora';

  @override
  String members_error_loading(String error) {
    return 'Errore nel caricamento dei dati: $error';
  }

  @override
  String get addStorage_title_add => 'Aggiungi Posizione di Archiviazione';

  @override
  String get addStorage_title_edit => 'Modifica Posizione di Archiviazione';

  @override
  String get addStorage_success_added =>
      'Posizione di archiviazione aggiunta con successo';

  @override
  String get addStorage_success_updated =>
      'Posizione di archiviazione aggiornata con successo';

  @override
  String get addStorage_success_deleted =>
      'Posizione di archiviazione eliminata con successo';

  @override
  String addStorage_error_saving(String error) {
    return 'Errore nel salvataggio della posizione: $error';
  }

  @override
  String addStorage_error_deleting(String error) {
    return 'Errore nell\'eliminazione della posizione: $error';
  }

  @override
  String get addStorage_dialog_delete_title =>
      'Elimina Posizione di Archiviazione';

  @override
  String get addStorage_dialog_delete_message =>
      'Sei sicuro di voler eliminare questa posizione di archiviazione?';

  @override
  String get addStorage_section_type => 'Tipo di Archiviazione';

  @override
  String get addStorage_section_basicInfo => 'Informazioni di Base';

  @override
  String get addStorage_field_name => 'Nome Archiviazione';

  @override
  String get addStorage_field_nameHint => 'Inserisci nome archiviazione';

  @override
  String get addStorage_field_parent => 'Posizione Principale (Opzionale)';

  @override
  String get addStorage_field_parentNone => 'Nessuna (livello superiore)';

  @override
  String get addStorage_section_description => 'Descrizione';

  @override
  String get addStorage_field_descriptionHint => 'Descrizione opzionale';

  @override
  String get addStorage_button_update => 'Aggiorna';

  @override
  String get addStorage_button_add => 'Aggiungi';

  @override
  String get addStorage_button_deleteLocation =>
      'Elimina Posizione di Archiviazione';

  @override
  String get storage_title => 'Archiviazione';

  @override
  String storage_error_loading(String error) {
    return 'Errore nel caricamento delle posizioni di archiviazione: $error';
  }

  @override
  String get nav_home => 'Home';

  @override
  String get nav_items => 'Articoli';

  @override
  String get nav_members => 'Membri';

  @override
  String get nav_storage => 'Archiviazione';

  @override
  String get nav_profile => 'Profilo';

  @override
  String storage_subtitle(int count, int itemCount) {
    return '$count posizioni • $itemCount articoli';
  }

  @override
  String get storage_searchHint => 'Cerca posizioni...';

  @override
  String get storage_filterAll => 'Tutto';

  @override
  String get storage_filterBasement => 'Seminterrato';

  @override
  String get storage_filterClosets => 'Armadi';

  @override
  String get storage_filterAttic => 'Soffitta';

  @override
  String get storage_sectionBoxes => 'Scatole';

  @override
  String get storage_sectionClosets => 'Armadi';

  @override
  String get storage_sectionAreas => 'Aree';

  @override
  String get storage_sectionOther => 'Altro Spazio';

  @override
  String get storage_expandAll => 'Espandi Tutto';

  @override
  String get storage_noDescription => 'Nessuna descrizione';

  @override
  String storage_itemsCount(int count) {
    return '$count articoli';
  }

  @override
  String get storage_viewItems => 'Vedi Articoli';

  @override
  String get storage_quickActions => 'Azioni Rapide';

  @override
  String get storage_scanQrCode => 'Scansiona Codice QR';

  @override
  String get storage_printLabels => 'Stampa Etichette';

  @override
  String get members_subtitle => 'Gestisci membri della famiglia';

  @override
  String get members_summaryMembers => 'Membri';

  @override
  String get members_summaryTotalItems => 'Articoli Totali';

  @override
  String get members_summaryNeedCheck => 'Da Controllare';

  @override
  String members_ageYears(int age) {
    return '$age anni';
  }

  @override
  String members_born(String date) {
    return 'Nato/a: $date';
  }

  @override
  String members_clothes(String size) {
    return 'Vestiti: $size';
  }

  @override
  String members_shoes(String size) {
    return 'Scarpe: $size';
  }

  @override
  String get members_hasItems => '✓ Ha articoli';

  @override
  String get members_noItemsYet => 'Nessun articolo ancora';

  @override
  String get members_tooltipGrowthChart => 'Grafico Crescita';

  @override
  String get members_tooltipEdit => 'Modifica';

  @override
  String get items_title => 'Articoli';

  @override
  String items_subtitle(int count) {
    return '$count articoli totali';
  }

  @override
  String items_subtitleWithLocation(String location, int count) {
    return '$location • $count articoli';
  }

  @override
  String get items_filterAllItems => 'Tutti';

  @override
  String get items_filterInUse => 'In Uso';

  @override
  String get items_filterStored => 'Archiviato';

  @override
  String get items_filterWinter => 'Inverno';

  @override
  String get items_filterSummer => 'Estate';

  @override
  String get items_quickFilters => 'Filtri Rapidi';

  @override
  String get items_clearAll => 'Cancella Tutto';

  @override
  String get items_filterClothes => 'Vestiti';

  @override
  String get items_filterShoes => 'Scarpe';

  @override
  String get items_filterAccessories => 'Accessori';

  @override
  String items_sizeLabel(String size, String gender) {
    return 'Taglia $size • $gender';
  }

  @override
  String get items_noSeasonTags => 'Nessuna etichetta stagionale';

  @override
  String items_quantity(int count) {
    return 'Quantità: $count';
  }

  @override
  String get items_statusInUse => 'In Uso';

  @override
  String get items_statusStored => 'Archiviato';

  @override
  String get items_statusOutgrown => 'Troppo Piccolo';

  @override
  String get editProfile_title => 'Modifica Profilo';

  @override
  String get editProfile_changePhoto => 'Cambia Foto';

  @override
  String get editProfile_section_personalInfo => 'Informazioni Personali';

  @override
  String get editProfile_field_fullName => 'Nome Completo';

  @override
  String get editProfile_field_email => 'Indirizzo Email';

  @override
  String get editProfile_hint_emailCannotChanged =>
      'L\'email non può essere modificata';

  @override
  String get editProfile_field_phone => 'Numero di Telefono';

  @override
  String get editProfile_field_role => 'Ruolo';

  @override
  String get editProfile_section_preferences => 'Preferenze';

  @override
  String get editProfile_pref_emailNotifications => 'Notifiche Email';

  @override
  String get editProfile_pref_emailNotificationsSubtitle =>
      'Ricevi aggiornamenti via email';

  @override
  String get editProfile_pref_pushNotifications => 'Notifiche Push';

  @override
  String get editProfile_pref_pushNotificationsSubtitle =>
      'Ricevi avvisi sul tuo dispositivo';

  @override
  String get editProfile_pref_weeklyDigest => 'Riepilogo Settimanale';

  @override
  String get editProfile_pref_weeklyDigestSubtitle =>
      'Riepilogo dell\'attività familiare';

  @override
  String get editProfile_section_unitsDisplay => 'Unità e Visualizzazione';

  @override
  String get editProfile_field_measurementSystem => 'Sistema di Misurazione';

  @override
  String get editProfile_option_imperial => 'Imperiale (USA)';

  @override
  String get editProfile_option_metric => 'Metrico';

  @override
  String get editProfile_button_saveChanges => 'Salva Modifiche';
}
