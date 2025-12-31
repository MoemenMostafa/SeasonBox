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
  String get login_button_demo => 'Prova la modalità demo';

  @override
  String get login_demo_tagline => 'Esplora l\'app con dati generici';

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
  String home_subscription_itemLimit(int count, int limit) {
    return 'Limite articoli: $count / $limit';
  }

  @override
  String get home_subscription_upgradeForUnlimited => 'Passa a illimitato';

  @override
  String get home_subscription_limitReached =>
      'Limite articoli raggiunto! Passa ora a Premium.';

  @override
  String get home_premium_banner_title => 'Sblocca un Potenziale Illimitato';

  @override
  String get home_premium_banner_subtitle =>
      'Gestisci articoli e membri della famiglia illimitati con SeasonBox Premium.';

  @override
  String get home_premium_banner_button => 'Passa a Premium';

  @override
  String get home_search_hint => 'Cerca articoli, taglie o #tag';

  @override
  String get home_search_hint_revamped => 'Cerca per titolo, taglia o #tag';

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
  String get home_reminder_winterTitle => 'L\'Inverno si Avvicina';

  @override
  String get home_reminder_winterMessage =>
      'Mantieni la tua famiglia al caldo. Controlla cappotti invernali, stivali e abbigliamento termico.';

  @override
  String get home_reminder_springTitle => 'La Primavera si Avvicina';

  @override
  String get home_reminder_springMessage =>
      'È ora di strati più leggeri. Verifica se le giacche primaverili e l\'abbigliamento da pioggia dell\'anno scorso vanno ancora bene.';

  @override
  String get home_reminder_summerTitle => 'L\'Estate si Avvicina';

  @override
  String get home_reminder_summerMessage =>
      'Preparati per il sole. Controlla costumi da bagno, pantaloncini e calzature estive.';

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
  String get gender_unisex => 'Unisex';

  @override
  String get gender_male => 'Maschio';

  @override
  String get gender_female => 'Femmina';

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
  String get addItem_section_tags => 'Tag';

  @override
  String get addItem_tags_hint => 'Aggiungi tag (colore, marca, materiale...)';

  @override
  String get addItem_tags_limitReached => 'Massimo 5 tag consentiti';

  @override
  String get addItem_tags_duplicate => 'Il tag esiste già';

  @override
  String get addItem_tags_mostUsed => 'Tag più usati';

  @override
  String get profile_title => 'Profilo';

  @override
  String get profile_button_editProfile => 'Modifica Profilo';

  @override
  String get profile_role_familyAdmin => 'Amministratore Famiglia';

  @override
  String get profile_section_familyManagement => 'Gestione Famiglia';

  @override
  String get profile_setting_subscription => 'Abbonamento';

  @override
  String get profile_subscription_statusFree => 'Piano Gratuito';

  @override
  String get profile_subscription_statusPremium => 'Piano Premium';

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
  String get profile_setting_statusTracking => 'Attiva monitoraggio stato';

  @override
  String get profile_setting_statusTrackingSubtitle =>
      'Sapere se gli articoli sono in uso o archiviati';

  @override
  String get profile_setting_quickAddItem => 'Aggiunta Rapida Articolo';

  @override
  String get profile_setting_quickAddItemSubtitle =>
      'Avvia automaticamente con la fotocamera per i nuovi articoli';

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
  String get addMember_field_birthdate_explanation =>
      'La data di nascita viene utilizzata per calcolare l\'età e fornire previsioni di crescita specifiche per l\'età.';

  @override
  String get addMember_section_sizes => 'Taglie Attuali';

  @override
  String get addMember_section_sizes_explanation =>
      'Le taglie attuali vengono utilizzate come base per prevedere le taglie future in base ai modelli di crescita.';

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
  String get addMember_section_accountAccess => 'Accesso all\'Account';

  @override
  String get addMember_field_inviteEmail => 'Email di Invito';

  @override
  String get addMember_field_inviteEmailHint => 'Inserisci indirizzo email';

  @override
  String get addMember_button_sendInvite => 'Invia Invito';

  @override
  String get addMember_button_resendInvite => 'Reinvia Invito';

  @override
  String get addMember_status_pending => 'Invito in Sospeso';

  @override
  String get addMember_status_accepted => 'Invito Accettato';

  @override
  String addMember_status_inviteSent(Object email) {
    return 'Invito inviato a $email';
  }

  @override
  String addMember_status_accountLinked(Object email) {
    return 'Account Collegato: $email';
  }

  @override
  String get addMember_error_invalidEmail => 'Inserisci un\'email valida';

  @override
  String get addMember_field_role => 'Ruolo Membro';

  @override
  String get addMember_role_admin => 'Admin';

  @override
  String get addMember_role_coAdmin => 'Co-Amministratore';

  @override
  String get addMember_role_member => 'Membro';

  @override
  String get addMember_role_child => 'Bambino/a';

  @override
  String get addMember_invite_description =>
      'Invita i familiari a unirsi alla tua famiglia SeasonBox. Potranno visualizzare e gestire gli articoli in base al loro ruolo.';

  @override
  String get addMember_validation_nameRequired => 'Inserisci un nome';

  @override
  String get addMember_dialog_cancelInvite_title => 'Annulla invito';

  @override
  String get addMember_dialog_cancelInvite_message =>
      'Sei sicuro di voler annullare questo invito? L\'utente non potrà più unirsi utilizzando questo invito.';

  @override
  String get addMember_button_cancelInvite => 'Annulla invito';

  @override
  String addMember_share_message(String familyId) {
    return 'Unisciti alla mia famiglia SeasonBox! Usa il codice: $familyId';
  }

  @override
  String get addMember_action_share => 'Condividi invito';

  @override
  String get addMember_action_copy => 'Copia codice';

  @override
  String get addMember_snack_copied => 'ID famiglia copiato negli appunti';

  @override
  String get register_title => 'Crea Account';

  @override
  String get register_subtitle => 'Unisciti alla famiglia SeasonBox';

  @override
  String get register_field_name => 'Nome completo';

  @override
  String get register_field_familyCode => 'Codice famiglia (Opzionale)';

  @override
  String get register_button_create => 'Crea Account';

  @override
  String get register_link_login => 'Hai già un account? Accedi';

  @override
  String get register_text_noAccount => 'Non hai ancora un account?';

  @override
  String get register_link_registerNow => 'Registrati ora';

  @override
  String get register_error_familyNotFound => 'Famiglia non trovata';

  @override
  String get register_success => 'Account creato con successo';

  @override
  String get profile_joinFamily_title => 'Unisciti alla famiglia';

  @override
  String get profile_joinFamily_input => 'Inserisci codice famiglia';

  @override
  String get profile_leaveFamily_title => 'Lascia famiglia';

  @override
  String get profile_leaveFamily_confirm =>
      'Sei sicuro di voler lasciare questa famiglia? Verrai rimosso dall\'elenco dei membri.';

  @override
  String get profile_disbandFamily_confirm =>
      'Attenzione: Sei l\'amministratore. Uscendo verranno rimossi tutti i membri ed eliminato il gruppo familiare. Questa azione non può essere annullata.';

  @override
  String get register_validation_passwordLength =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get error_no_invitation =>
      'Nessun invito attivo trovato per questa famiglia.';

  @override
  String get profile_joinFamily_success => 'Unito alla famiglia con successo';

  @override
  String get profile_leaveFamily_success => 'Famiglia lasciata con successo';

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
  String get printLabels_title => 'Stampa Etichette';

  @override
  String get printLabels_selectAll => 'Seleziona Tutto';

  @override
  String get printLabels_deselectAll => 'Deseleziona Tutto';

  @override
  String printLabels_printButton(int count) {
    return 'Stampa ($count)';
  }

  @override
  String get printLabels_noStorageSelected =>
      'Seleziona almeno un luogo di stoccaggio.';

  @override
  String get printLabels_searchHint => 'Filtra luoghi di stoccaggio...';

  @override
  String get printLabels_labelSubtitle => 'Etichetta di Stoccaggio';

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
  String get members_birthdate_notSet => 'Data di nascita non impostata';

  @override
  String get members_dialog_birthdateRequired_title =>
      'Data di nascita richiesta';

  @override
  String get members_dialog_birthdateRequired_message =>
      'È necessaria una data di nascita per calcolare l\'età del membro e fornire previsioni di crescita e traguardi precisi sui grafici.';

  @override
  String get members_dialog_birthdateRequired_button =>
      'Imposta data di nascita';

  @override
  String get members_dialog_sizeRequired_title =>
      'Informazioni sulla taglia richieste';

  @override
  String get members_dialog_sizeRequired_message =>
      'Le taglie attuali di abbigliamento o calzature sono necessarie come base per prevedere le taglie future in base ai modelli di crescita.';

  @override
  String get members_dialog_sizeRequired_button => 'Imposta taglie';

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
  String get members_growthChart_actual => 'Cronologia Reale';

  @override
  String get members_growthChart_expectation => 'Previsione';

  @override
  String members_growthChart_insight(String name, int months) {
    return 'In base alla crescita attuale, $name avrà probabilmente bisogno di una nuova taglia tra circa $months mesi.';
  }

  @override
  String members_growthChart_noGrowth(String name) {
    return '$name ha raggiunto la maturità fisica. La crescita standard generalmente si conclude dopo i 18 anni.';
  }

  @override
  String get members_growthChart_reference =>
      'I modelli di crescita si basano sugli standard di crescita dei bambini dell\'Organizzazione Mondiale della Sanità (OMS).';

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
  String get items_filter_title => 'Filtri';

  @override
  String get items_filter_category => 'Categoria';

  @override
  String get items_filter_gender => 'Genere';

  @override
  String get items_filter_status => 'Stato';

  @override
  String get items_filter_member => 'Membro';

  @override
  String get items_filter_active => 'Filtri attivi';

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
      'L\'email non può essere modificata.';

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

  @override
  String get notifications_title => 'Notifiche';

  @override
  String get notifications_empty => 'Nessuna nuova notifica';

  @override
  String get notifications_invite_title => 'Invito a unirsi alla famiglia';

  @override
  String notifications_invite_message(String inviterName) {
    return '$inviterName ti ha invitato a unirti alla sua famiglia.';
  }

  @override
  String notifications_invite_familyId(String familyId) {
    return 'ID Famiglia: $familyId';
  }

  @override
  String get notifications_action_accept => 'Accetta';

  @override
  String get notifications_action_reject => 'Rifiuta';

  @override
  String get notifications_success_joined =>
      'Unito alla famiglia con successo!';

  @override
  String get notifications_success_rejected => 'Invito rifiutato.';

  @override
  String notifications_error_joining(String error) {
    return 'Errore durante l\'adesione alla famiglia: $error';
  }

  @override
  String notifications_error_rejecting(String error) {
    return 'Errore durante il rifiuto dell\'invito: $error';
  }

  @override
  String get subscription_title => 'Abbonamento';

  @override
  String get subscription_subtitle =>
      'Scegli il piano migliore per la tua famiglia';

  @override
  String get subscription_billing_monthly => 'Mensile';

  @override
  String get subscription_billing_yearly => 'Annuale';

  @override
  String get subscription_tier_freeTitle => 'Livello Gratuito';

  @override
  String get subscription_tier_premiumTitle => 'Livello Premium';

  @override
  String get subscription_tier_freePrice => 'Gratis';

  @override
  String subscription_tier_premiumPrice(String price, String period) {
    return '€$price$period';
  }

  @override
  String get subscription_tier_freeDesc => 'Ottimo per iniziare';

  @override
  String get subscription_tier_premiumDesc =>
      'Accesso illimitato per famiglie impegnate';

  @override
  String get subscription_feature_items_free => 'Fino a 50 articoli';

  @override
  String get subscription_feature_photos_free => '1 foto per articolo';

  @override
  String get subscription_feature_photos_premium => '3 foto per articolo';

  @override
  String get subscription_feature_storage_free =>
      'Monitoraggio standard dello storage';

  @override
  String get subscription_feature_members_free =>
      'Fino a 4 membri della famiglia';

  @override
  String get subscription_feature_items_premium => 'Articoli illimitati';

  @override
  String get subscription_feature_members_premium =>
      'Membri della famiglia illimitati';

  @override
  String get subscription_feature_sharing_premium =>
      'Condivisione familiare completa';

  @override
  String get subscription_feature_growth_premium =>
      'Previsioni di crescita e consigli';

  @override
  String get subscription_feature_reminders_premium => 'Promemoria stagionali';

  @override
  String get subscription_currentPlan => 'Piano Attuale';

  @override
  String get subscription_selectPlan => 'Seleziona Piano';

  @override
  String subscription_savingsLabel(String percent) {
    return 'Risparmia il $percent%';
  }

  @override
  String get subscription_bestValue => 'MIGLIOR VALORE';

  @override
  String get subscription_cancelAnytime =>
      'Annulla in qualsiasi momento. Gli articoli esistenti rimangono visibili anche dopo l\'annullamento.';

  @override
  String get addItem_items_limitReached_title => 'Limite articoli raggiunto';

  @override
  String addItem_items_limitReached_message(int limit) {
    return 'Hai raggiunto il limite di $limit articoli per il livello gratuito. Passa a Premium per articoli illimitati!';
  }

  @override
  String get addItem_images_limitReached_title => 'Limite immagini raggiunto';

  @override
  String addItem_images_limitReached_message(int limit) {
    return 'La versione gratuita è limitata a $limit immagine per articolo. Passa a Premium per 3 immagini!';
  }

  @override
  String get members_tooltip_editPermission =>
      'Solo gli amministratori possono modificare altri membri';

  @override
  String get members_button_filter => 'Filtra';

  @override
  String get members_dialog_limitReached_title => 'Limite Raggiunto';

  @override
  String get members_dialog_limitReached_message =>
      'Il livello gratuito è limitato a 4 membri. Passa a Pagamento per membri illimitati e condivisione familiare completa!';

  @override
  String get members_dialog_limitReached_maybeLater => 'Forse Più Tardi';

  @override
  String get members_dialog_limitReached_viewPricing => 'Visualizza Prezzi';

  @override
  String get growthChart_premium_title =>
      'Le Previsioni di Crescita sono Premium';

  @override
  String get growthChart_premium_message =>
      'Passa al piano a pagamento per vedere come stanno crescendo i tuoi figli e ricevere consigli su quando acquistare le prossime taglie.';

  @override
  String get growthChart_premium_viewPricing => 'Visualizza Prezzi';

  @override
  String get subscription_error_store_unavailable =>
      'Il negozio di abbonamenti non è attualmente disponibile. Controlla la tua connessione Internet e assicurati di aver effettuato l\'accesso al Play Store.';

  @override
  String get subscription_button_retry_connection => 'Riprova connessione';

  @override
  String subscription_error_product_not_found(String id) {
    return 'Prodotto di abbonamento non trovato: $id';
  }
}
