// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'SeasonBox';

  @override
  String get login_tagline =>
      'Organisez les articles saisonniers pour votre famille en toute simplicité';

  @override
  String get login_featureCard_photoInventoryTitle => 'Inventaire Photo';

  @override
  String get login_featureCard_photoInventorySubtitle =>
      'Capturez et organisez avec des photos';

  @override
  String get login_featureCard_familySharingTitle => 'Partage Familial';

  @override
  String get login_featureCard_familySharingSubtitle =>
      'Synchronisez avec tous les membres';

  @override
  String get login_featureCard_smartRemindersTitle => 'Rappels Intelligents';

  @override
  String get login_featureCard_smartRemindersSubtitle =>
      'Ne manquez jamais les changements de saison';

  @override
  String get login_button_email => 'Se connecter avec votre e-mail';

  @override
  String get login_button_google => 'Continuer avec Google';

  @override
  String get login_button_biometric => 'Se connecter avec la biométrie';

  @override
  String get login_footer_terms => 'En continuant, vous acceptez nos ';

  @override
  String get login_footer_termsOfService => 'Conditions d\'utilisation';

  @override
  String get login_footer_and => ' et notre ';

  @override
  String get login_footer_privacyPolicy => 'Politique de confidentialité';

  @override
  String get login_error_googleCancelled =>
      'La connexion Google a été annulée ou a échoué. Veuillez réessayer.';

  @override
  String login_error_signIn(String error) {
    return 'Erreur de connexion : $error';
  }

  @override
  String get login_error_invalidCredentials =>
      'E-mail ou mot de passe invalide. Veuillez réessayer.';

  @override
  String get emailLogin_title => 'Bon Retour';

  @override
  String get emailLogin_subtitle => 'Connectez-vous pour continuer';

  @override
  String get emailLogin_field_email => 'E-mail';

  @override
  String get emailLogin_field_password => 'Mot de passe';

  @override
  String get emailLogin_validation_emailRequired =>
      'Veuillez entrer votre e-mail';

  @override
  String get emailLogin_validation_passwordRequired =>
      'Veuillez entrer votre mot de passe';

  @override
  String get emailLogin_button_forgotPassword => 'Mot de passe oublié ?';

  @override
  String get emailLogin_button_login => 'Se connecter';

  @override
  String get emailLogin_error_emailFirst =>
      'Veuillez d\'abord entrer votre e-mail';

  @override
  String get emailLogin_success_passwordReset =>
      'E-mail de réinitialisation envoyé';

  @override
  String emailLogin_error_generic(String error) {
    return 'Erreur : $error';
  }

  @override
  String home_appBar_subtitle(String familyName) {
    return 'Famille $familyName';
  }

  @override
  String get home_stats_totalItems => 'Articles Totaux';

  @override
  String get home_stats_members => 'Membres';

  @override
  String get home_search_hint => 'Rechercher des articles, emplacements...';

  @override
  String get home_section_quickActions => 'Actions Rapides';

  @override
  String get home_section_familyMembers => 'Membres de la Famille';

  @override
  String get home_section_recentItems => 'Articles Récents';

  @override
  String get home_section_seasonalReminders => 'Rappels Saisonniers';

  @override
  String get home_section_storageLocations => 'Emplacements de Stockage';

  @override
  String get home_action_addItem => 'Ajouter un Article';

  @override
  String get home_action_scanQR => 'Scanner QR';

  @override
  String get home_action_viewAll => 'Tout Voir';

  @override
  String get home_action_manage => 'Gérer';

  @override
  String home_member_age(int age) {
    return 'Âge $age';
  }

  @override
  String home_member_size(String size) {
    return 'Taille $size';
  }

  @override
  String home_member_items(int count) {
    return '$count articles';
  }

  @override
  String get home_member_status_active => 'Actif';

  @override
  String get home_item_storage => 'Stockage';

  @override
  String get home_reminder_fallTitle => 'L\'Automne Approche';

  @override
  String get home_reminder_fallMessage =>
      'Il est temps de vérifier les vêtements d\'automne de vos enfants. Pensez aux changements de taille depuis l\'année dernière.';

  @override
  String get home_reminder_reviewItems => 'Examiner les Articles';

  @override
  String home_error_loadingData(String error) {
    return 'Erreur de chargement des données : $error';
  }

  @override
  String get addItem_title_add => 'Ajouter un Nouvel Article';

  @override
  String get addItem_title_edit => 'Modifier l\'Article';

  @override
  String get addItem_section_photos => 'Photos';

  @override
  String get addItem_section_itemDetails => 'Détails de l\'Article';

  @override
  String get addItem_section_size => 'Taille';

  @override
  String get addItem_section_seasonMember => 'Saison et Membre';

  @override
  String get addItem_section_storageLocation => 'Emplacement de Stockage';

  @override
  String get addItem_button_addPhoto => 'Ajouter une Photo';

  @override
  String get addItem_button_takePhoto => 'Prendre une Photo';

  @override
  String get addItem_button_chooseGallery => 'Choisir dans la Galerie';

  @override
  String get addItem_button_saveItem => 'Enregistrer l\'Article';

  @override
  String get addItem_field_itemName => 'Nom de l\'Article';

  @override
  String get addItem_field_itemNameHint => 'ex., Veste d\'Hiver';

  @override
  String get addItem_field_category => 'Catégorie';

  @override
  String get addItem_field_gender => 'Genre';

  @override
  String get addItem_field_size => 'Taille';

  @override
  String get addItem_field_customSize => 'Entrer une Taille Personnalisée';

  @override
  String get addItem_field_customSizeHint => 'ex., 32W, 10.5, etc.';

  @override
  String get addItem_field_quantity => 'Quantité';

  @override
  String get addItem_field_seasons => 'Saison(s)';

  @override
  String get addItem_field_assignedTo => 'Assigné à';

  @override
  String get addItem_field_assignedToHint => 'Sélectionner un membre';

  @override
  String get addItem_field_none => 'Aucun';

  @override
  String get addItem_category_clothes => 'Vêtements';

  @override
  String get addItem_category_shoes => 'Chaussures';

  @override
  String get addItem_category_accessories => 'Accessoires';

  @override
  String get addItem_category_toys => 'Jouets';

  @override
  String get addItem_category_gear => 'Équipement';

  @override
  String get gender_unisex => 'Unisexe';

  @override
  String get gender_male => 'Masculin';

  @override
  String get gender_female => 'Féminin';

  @override
  String get addItem_season_winter => 'Hiver';

  @override
  String get addItem_season_spring => 'Printemps';

  @override
  String get addItem_season_summer => 'Été';

  @override
  String get addItem_season_fall => 'Automne';

  @override
  String get addItem_size_other => 'Autre';

  @override
  String get addItem_validation_required => 'Requis';

  @override
  String get addItem_validation_selectStorage =>
      'Veuillez sélectionner un emplacement de stockage';

  @override
  String get addItem_validation_selectSize =>
      'Veuillez sélectionner une taille';

  @override
  String get addItem_validation_enterSize => 'Veuillez entrer une taille';

  @override
  String get addItem_success_added => 'Article ajouté avec succès';

  @override
  String get addItem_success_updated => 'Article mis à jour avec succès';

  @override
  String addItem_error_saving(String error) {
    return 'Erreur lors de l\'enregistrement : $error';
  }

  @override
  String addItem_error_pickingImage(String error) {
    return 'Erreur lors de la sélection de l\'image : $error';
  }

  @override
  String addItem_error_loadingData(String error) {
    return 'Erreur de chargement des données : $error';
  }

  @override
  String addItem_location_found(String name) {
    return 'Emplacement trouvé : $name';
  }

  @override
  String addItem_location_unknown(String code) {
    return 'Code d\'emplacement inconnu : $code';
  }

  @override
  String get addItem_section_tags => 'Étiquettes';

  @override
  String get addItem_tags_hint =>
      'Ajouter une étiquette (couleur, marque, matière...)';

  @override
  String get addItem_tags_limitReached => 'Maximum 5 étiquettes autorisées';

  @override
  String get addItem_tags_duplicate => 'L\'étiquette existe déjà';

  @override
  String get addItem_tags_mostUsed => 'Étiquettes plus utilisées';

  @override
  String get profile_title => 'Profil';

  @override
  String get profile_button_editProfile => 'Modifier le Profil';

  @override
  String get profile_role_familyAdmin => 'Administrateur Familial';

  @override
  String get profile_section_familyManagement => 'Gestion Familiale';

  @override
  String get profile_section_appSettings => 'Paramètres de l\'Application';

  @override
  String get profile_section_dataPrivacy => 'Données et Confidentialité';

  @override
  String get profile_section_support => 'Support';

  @override
  String get profile_section_language => 'Langue';

  @override
  String profile_family_name(String familyName) {
    return 'Famille $familyName';
  }

  @override
  String profile_family_members(int count) {
    return '$count membres • Vous êtes administrateur';
  }

  @override
  String get profile_family_inviteMembers => 'Inviter des Membres';

  @override
  String get profile_family_inviteSubtitle => 'Partager l\'accès familial';

  @override
  String get profile_setting_darkMode => 'Mode Sombre';

  @override
  String get profile_setting_darkModeSubtitle => 'Basculer le thème sombre';

  @override
  String get profile_setting_notifications => 'Notifications';

  @override
  String get profile_setting_notificationsSubtitle => 'Rappels et alertes';

  @override
  String get profile_setting_seasonalReminders => 'Rappels Saisonniers';

  @override
  String get profile_setting_seasonalRemindersSubtitle =>
      'Alertes automatiques de saison';

  @override
  String get profile_setting_autoSync => 'Synchronisation Automatique';

  @override
  String get profile_setting_autoSyncSubtitle => 'Synchronisation cloud';

  @override
  String get profile_setting_biometricLogin => 'Connexion Biométrique';

  @override
  String get profile_setting_biometricLoginSubtitle =>
      'Activer Face ID / Touch ID';

  @override
  String get profile_setting_language => 'Langue';

  @override
  String get profile_setting_languageSubtitle =>
      'Changer la langue de l\'application';

  @override
  String get profile_data_exportData => 'Exporter les Données';

  @override
  String get profile_data_exportDataSubtitle => 'Télécharger vos informations';

  @override
  String get profile_data_backupData => 'Sauvegarder les Données';

  @override
  String get profile_data_backupDataSubtitle => 'Créer une copie de sauvegarde';

  @override
  String get profile_data_privacyPolicy => 'Politique de Confidentialité';

  @override
  String get profile_data_privacyPolicySubtitle =>
      'Comment nous protégeons vos données';

  @override
  String get profile_support_helpCenter => 'Centre d\'Aide';

  @override
  String get profile_support_helpCenterSubtitle => 'FAQ et tutoriels';

  @override
  String get profile_support_contactSupport => 'Contacter le Support';

  @override
  String get profile_support_contactSupportSubtitle =>
      'Obtenez de l\'aide de notre équipe';

  @override
  String get profile_support_rateApp => 'Noter l\'Application';

  @override
  String get profile_support_rateAppSubtitle => 'Partagez vos commentaires';

  @override
  String get profile_dialog_logout_title => 'Déconnexion';

  @override
  String get profile_dialog_logout_message =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get profile_dialog_logout_cancel => 'Annuler';

  @override
  String get profile_dialog_logout_confirm => 'Déconnexion';

  @override
  String get profile_dialog_biometric_title =>
      'Activer la Connexion Biométrique';

  @override
  String get profile_dialog_biometric_message =>
      'Veuillez entrer votre e-mail et mot de passe pour les stocker en toute sécurité.';

  @override
  String get profile_dialog_biometric_email => 'E-mail';

  @override
  String get profile_dialog_biometric_password => 'Mot de passe';

  @override
  String get profile_dialog_biometric_cancel => 'Annuler';

  @override
  String get profile_dialog_biometric_enable => 'Activer';

  @override
  String get profile_success_biometricEnabled =>
      'Connexion biométrique activée';

  @override
  String profile_error_logoutFailed(String error) {
    return 'Échec de la déconnexion : $error';
  }

  @override
  String get language_english => 'Anglais';

  @override
  String get language_spanish => 'Espagnol';

  @override
  String get language_french => 'Français';

  @override
  String get language_italian => 'Italien';

  @override
  String get language_german => 'Allemand';

  @override
  String get common_loading => 'Chargement...';

  @override
  String get common_save => 'Enregistrer';

  @override
  String get common_cancel => 'Annuler';

  @override
  String get common_delete => 'Supprimer';

  @override
  String get common_edit => 'Modifier';

  @override
  String get common_add => 'Ajouter';

  @override
  String get common_search => 'Rechercher';

  @override
  String get common_filter => 'Filtrer';

  @override
  String get common_error => 'Erreur';

  @override
  String get common_success => 'Succès';

  @override
  String get common_comingSoon => 'Bientôt disponible';

  @override
  String get addMember_title_add => 'Ajouter un Membre Familial';

  @override
  String get addMember_title_edit => 'Modifier le Membre Familial';

  @override
  String get addMember_success_added => 'Membre familial ajouté avec succès';

  @override
  String get addMember_success_updated =>
      'Membre familial mis à jour avec succès';

  @override
  String get addMember_success_deleted =>
      'Membre familial supprimé avec succès';

  @override
  String addMember_error_saving(String error) {
    return 'Erreur lors de l\'enregistrement du membre : $error';
  }

  @override
  String addMember_error_deleting(String error) {
    return 'Erreur lors de la suppression du membre : $error';
  }

  @override
  String get addMember_dialog_delete_title => 'Supprimer le Membre';

  @override
  String get addMember_dialog_delete_message =>
      'Êtes-vous sûr de vouloir supprimer ce membre familial ? Cette action ne peut pas être annulée.';

  @override
  String get addMember_section_basicInfo => 'Informations de Base';

  @override
  String get addMember_field_name => 'Nom du Membre';

  @override
  String get addMember_field_nameHint => 'Entrez le nom complet';

  @override
  String get addMember_field_gender => 'Genre';

  @override
  String get addMember_field_birthdate => 'Date de Naissance';

  @override
  String get addMember_field_birthdateHint => 'jj/mm/aaaa';

  @override
  String get addMember_section_sizes => 'Tailles Actuelles';

  @override
  String get addMember_field_clothingSize => 'Taille de Vêtement';

  @override
  String get addMember_field_clothingSizeHint => 'ex. 110 (cm) ou 5 (âge)';

  @override
  String get addMember_field_shoeSize => 'Pointure';

  @override
  String get addMember_field_shoeSizeHint => 'ex. 28';

  @override
  String get addMember_section_notes => 'Notes Supplémentaires';

  @override
  String get addMember_field_notesHint =>
      'Notes spéciales sur les préférences de cet enfant, etc.';

  @override
  String get addMember_button_update => 'Mettre à jour';

  @override
  String get addMember_button_add => 'Ajouter';

  @override
  String get addMember_button_deleteMember => 'Supprimer le membre';

  @override
  String get addMember_section_accountAccess => 'Accès au Compte';

  @override
  String get addMember_field_inviteEmail => 'Email d\'invitation';

  @override
  String get addMember_field_inviteEmailHint => 'Entrez l\'adresse e-mail';

  @override
  String get addMember_button_sendInvite => 'Envoyer l\'invitation';

  @override
  String get addMember_button_resendInvite => 'Renvoyer l\'invitation';

  @override
  String get addMember_status_pending => 'Invitation en attente';

  @override
  String get addMember_status_accepted => 'Invitation acceptée';

  @override
  String addMember_status_inviteSent(Object email) {
    return 'Invitation envoyée à $email';
  }

  @override
  String addMember_status_accountLinked(Object email) {
    return 'Compte lié : $email';
  }

  @override
  String get addMember_error_invalidEmail => 'Veuillez entrer un email valide';

  @override
  String get addMember_field_role => 'Rôle du Membre';

  @override
  String get addMember_role_admin => 'Admin';

  @override
  String get addMember_role_coAdmin => 'Co-Administrateur';

  @override
  String get addMember_role_member => 'Membre';

  @override
  String get addMember_role_child => 'Enfant';

  @override
  String get addMember_invite_description =>
      'Invitez des membres de la famille à rejoindre votre famille SeasonBox. Ils pourront voir et gérer les articles selon leur rôle.';

  @override
  String get addMember_validation_nameRequired => 'Veuillez entrer un nom';

  @override
  String get addMember_dialog_cancelInvite_title => 'Annuler l\'invitation';

  @override
  String get addMember_dialog_cancelInvite_message =>
      'Êtes-vous sûr de vouloir annuler cette invitation ? L\'utilisateur ne pourra plus rejoindre en utilisant cette invitation.';

  @override
  String get addMember_button_cancelInvite => 'Annuler l\'invitation';

  @override
  String addMember_share_message(String familyId) {
    return 'Rejoignez ma famille SeasonBox ! Utilisez le code : $familyId';
  }

  @override
  String get addMember_action_share => 'Partager l\'invitation';

  @override
  String get addMember_action_copy => 'Copier le code';

  @override
  String get addMember_snack_copied =>
      'ID de la famille copié dans le presse-papiers';

  @override
  String get register_title => 'Créer un Compte';

  @override
  String get register_subtitle => 'Rejoindre la famille SeasonBox';

  @override
  String get register_field_name => 'Nom complet';

  @override
  String get register_field_familyCode => 'Code famille (Optionnel)';

  @override
  String get register_button_create => 'Créer un Compte';

  @override
  String get register_link_login => 'Vous avez déjà un compte ? Connexion';

  @override
  String get register_text_noAccount => 'Vous n\'avez pas encore de compte ?';

  @override
  String get register_link_registerNow => 'Inscrivez-vous maintenant';

  @override
  String get register_error_familyNotFound => 'Famille introuvable';

  @override
  String get register_success => 'Compte créé avec succès';

  @override
  String get profile_joinFamily_title => 'Rejoindre une famille';

  @override
  String get profile_joinFamily_input => 'Entrez le code famille';

  @override
  String get profile_leaveFamily_title => 'Quitter la famille';

  @override
  String get profile_leaveFamily_confirm =>
      'Êtes-vous sûr de vouloir quitter cette famille ? Vous serez retiré de la liste des membres.';

  @override
  String get profile_disbandFamily_confirm =>
      'Attention : Vous êtes l\'administrateur. Quitter supprimera tous les membres et supprimera le groupe familial. Cette action est irréversible.';

  @override
  String get register_validation_passwordLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get error_no_invitation =>
      'Aucune invitation active trouvée pour cette famille.';

  @override
  String get profile_joinFamily_success =>
      'Vous avez rejoint la famille avec succès';

  @override
  String get profile_leaveFamily_success =>
      'Vous avez quitté la famille avec succès';

  @override
  String get members_title => 'Membres de la Famille';

  @override
  String get members_label_currentSize => 'Taille Actuelle';

  @override
  String get members_label_items => 'Articles';

  @override
  String get members_button_viewItems => 'Voir les Articles';

  @override
  String get members_empty => 'Aucun membre ajouté pour le moment';

  @override
  String members_error_loading(String error) {
    return 'Erreur de chargement des données : $error';
  }

  @override
  String get addStorage_title_add => 'Ajouter un Emplacement de Stockage';

  @override
  String get addStorage_title_edit => 'Modifier l\'Emplacement de Stockage';

  @override
  String get addStorage_success_added =>
      'Emplacement de stockage ajouté avec succès';

  @override
  String get addStorage_success_updated =>
      'Emplacement de stockage mis à jour avec succès';

  @override
  String get addStorage_success_deleted =>
      'Emplacement de stockage supprimé avec succès';

  @override
  String addStorage_error_saving(String error) {
    return 'Erreur lors de l\'enregistrement de l\'emplacement : $error';
  }

  @override
  String addStorage_error_deleting(String error) {
    return 'Erreur lors de la suppression de l\'emplacement : $error';
  }

  @override
  String get addStorage_dialog_delete_title =>
      'Supprimer l\'Emplacement de Stockage';

  @override
  String get addStorage_dialog_delete_message =>
      'Êtes-vous sûr de vouloir supprimer cet emplacement de stockage ?';

  @override
  String get addStorage_section_type => 'Type de Stockage';

  @override
  String get addStorage_section_basicInfo => 'Informations de Base';

  @override
  String get addStorage_field_name => 'Nom du Stockage';

  @override
  String get addStorage_field_nameHint => 'Entrez le nom du stockage';

  @override
  String get addStorage_field_parent => 'Emplacement Parent (Optionnel)';

  @override
  String get addStorage_field_parentNone => 'Aucun (niveau supérieur)';

  @override
  String get addStorage_section_description => 'Description';

  @override
  String get addStorage_field_descriptionHint => 'Description optionnelle';

  @override
  String get addStorage_button_update => 'Mettre à Jour';

  @override
  String get addStorage_button_add => 'Ajouter';

  @override
  String get addStorage_button_deleteLocation =>
      'Supprimer l\'Emplacement de Stockage';

  @override
  String get storage_title => 'Stockage';

  @override
  String storage_error_loading(String error) {
    return 'Erreur de chargement des emplacements de stockage : $error';
  }

  @override
  String get nav_home => 'Accueil';

  @override
  String get nav_items => 'Articles';

  @override
  String get nav_members => 'Membres';

  @override
  String get nav_storage => 'Stockage';

  @override
  String get nav_profile => 'Profil';

  @override
  String storage_subtitle(int count, int itemCount) {
    return '$count emplacements • $itemCount articles';
  }

  @override
  String get storage_searchHint => 'Rechercher des emplacements...';

  @override
  String get storage_filterAll => 'Tout';

  @override
  String get storage_filterBasement => 'Sous-sol';

  @override
  String get storage_filterClosets => 'Placards';

  @override
  String get storage_filterAttic => 'Grenier';

  @override
  String get storage_sectionBoxes => 'Boîtes';

  @override
  String get storage_sectionClosets => 'Placards';

  @override
  String get storage_sectionAreas => 'Zones';

  @override
  String get storage_sectionOther => 'Autre Stockage';

  @override
  String get storage_expandAll => 'Tout Développer';

  @override
  String get storage_noDescription => 'Pas de description';

  @override
  String storage_itemsCount(int count) {
    return '$count articles';
  }

  @override
  String get storage_viewItems => 'Voir les Articles';

  @override
  String get storage_quickActions => 'Actions Rapides';

  @override
  String get storage_scanQrCode => 'Scanner Code QR';

  @override
  String get storage_printLabels => 'Imprimer Étiquettes';

  @override
  String get members_subtitle => 'Gérer les membres de la famille';

  @override
  String get members_summaryMembers => 'Membres';

  @override
  String get members_summaryTotalItems => 'Articles Totaux';

  @override
  String get members_summaryNeedCheck => 'Vérification Nécessaire';

  @override
  String members_ageYears(int age) {
    return '$age ans';
  }

  @override
  String members_born(String date) {
    return 'Né(e): $date';
  }

  @override
  String members_clothes(String size) {
    return 'Vêtements: $size';
  }

  @override
  String members_shoes(String size) {
    return 'Chaussures: $size';
  }

  @override
  String get members_hasItems => '✓ A des articles';

  @override
  String get members_noItemsYet => 'Pas encore d\'articles';

  @override
  String get members_tooltipGrowthChart => 'Tableau de Croissance';

  @override
  String get members_growthChart_actual => 'Historique Réel';

  @override
  String get members_growthChart_expectation => 'Prévision';

  @override
  String members_growthChart_insight(String name, int months) {
    return 'Sur la base de la croissance actuelle, $name aura probablement besoin d\'une nouvelle taille dans environ $months mois.';
  }

  @override
  String members_growthChart_noGrowth(String name) {
    return 'Il n\'y a pas de croissance prévue au cours des 12 prochains mois pour $name.';
  }

  @override
  String get members_tooltipEdit => 'Modifier';

  @override
  String get items_title => 'Articles';

  @override
  String items_subtitle(int count) {
    return '$count articles au total';
  }

  @override
  String items_subtitleWithLocation(String location, int count) {
    return '$location • $count articles';
  }

  @override
  String get items_filterAllItems => 'Tous';

  @override
  String get items_filterInUse => 'En Usage';

  @override
  String get items_filterStored => 'Stocké';

  @override
  String get items_filterWinter => 'Hiver';

  @override
  String get items_filterSummer => 'Été';

  @override
  String get items_quickFilters => 'Filtres Rapides';

  @override
  String get items_clearAll => 'Tout Effacer';

  @override
  String get items_filterClothes => 'Vêtements';

  @override
  String get items_filterShoes => 'Chaussures';

  @override
  String get items_filterAccessories => 'Accessoires';

  @override
  String items_sizeLabel(String size, String gender) {
    return 'Taille $size • $gender';
  }

  @override
  String get items_noSeasonTags => 'Pas d\'étiquette de saison';

  @override
  String items_quantity(int count) {
    return 'Quantité: $count';
  }

  @override
  String get items_statusInUse => 'En Usage';

  @override
  String get items_statusStored => 'Stocké';

  @override
  String get items_statusOutgrown => 'Devenu Petit';

  @override
  String get editProfile_title => 'Modifier le profil';

  @override
  String get editProfile_changePhoto => 'Changer la photo';

  @override
  String get editProfile_section_personalInfo => 'Informations personnelles';

  @override
  String get editProfile_field_fullName => 'Nom complet';

  @override
  String get editProfile_field_email => 'Adresse e-mail';

  @override
  String get editProfile_hint_emailCannotChanged =>
      'L\'e-mail ne peut pas être modifié';

  @override
  String get editProfile_field_phone => 'Numéro de téléphone';

  @override
  String get editProfile_field_role => 'Rôle';

  @override
  String get editProfile_section_preferences => 'Préférences';

  @override
  String get editProfile_pref_emailNotifications => 'Notifications par e-mail';

  @override
  String get editProfile_pref_emailNotificationsSubtitle =>
      'Recevoir des mises à jour par e-mail';

  @override
  String get editProfile_pref_pushNotifications => 'Notifications push';

  @override
  String get editProfile_pref_pushNotificationsSubtitle =>
      'Recevoir des alertes sur votre appareil';

  @override
  String get editProfile_pref_weeklyDigest => 'Résumé hebdomadaire';

  @override
  String get editProfile_pref_weeklyDigestSubtitle =>
      'Résumé de l\'activité familiale';

  @override
  String get editProfile_section_unitsDisplay => 'Unités et affichage';

  @override
  String get editProfile_field_measurementSystem => 'Système de mesure';

  @override
  String get editProfile_option_imperial => 'Impérial (US)';

  @override
  String get editProfile_option_metric => 'Métrique';

  @override
  String get editProfile_button_saveChanges => 'Enregistrer les modifications';

  @override
  String get notifications_title => 'Notifications';

  @override
  String get notifications_empty => 'Aucune nouvelle notification';

  @override
  String get notifications_invite_title => 'Invitation à rejoindre la famille';

  @override
  String notifications_invite_message(String inviterName) {
    return '$inviterName vous a invité à rejoindre sa famille.';
  }

  @override
  String notifications_invite_familyId(String familyId) {
    return 'ID de famille : $familyId';
  }

  @override
  String get notifications_action_accept => 'Accepter';

  @override
  String get notifications_action_reject => 'Refuser';

  @override
  String get notifications_success_joined => 'Famille rejointe avec succès !';

  @override
  String get notifications_success_rejected => 'Invitation refusée.';

  @override
  String notifications_error_joining(String error) {
    return 'Erreur lors de l\'adhésion à la famille : $error';
  }

  @override
  String notifications_error_rejecting(String error) {
    return 'Erreur lors du refus de l\'invitation : $error';
  }
}
