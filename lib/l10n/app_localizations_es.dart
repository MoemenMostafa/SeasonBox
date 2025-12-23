// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'SeasonBox';

  @override
  String get login_tagline =>
      'Organiza artículos de temporada para tu familia con facilidad';

  @override
  String get login_featureCard_photoInventoryTitle => 'Inventario Fotográfico';

  @override
  String get login_featureCard_photoInventorySubtitle =>
      'Captura y organiza con fotos';

  @override
  String get login_featureCard_familySharingTitle => 'Compartir en Familia';

  @override
  String get login_featureCard_familySharingSubtitle =>
      'Sincroniza con todos los miembros';

  @override
  String get login_featureCard_smartRemindersTitle =>
      'Recordatorios Inteligentes';

  @override
  String get login_featureCard_smartRemindersSubtitle =>
      'Nunca te pierdas los cambios de temporada';

  @override
  String get login_button_email => 'Iniciar sesión con tu correo';

  @override
  String get login_button_google => 'Continuar con Google';

  @override
  String get login_button_biometric => 'Iniciar sesión con biometría';

  @override
  String get login_footer_terms => 'Al continuar, aceptas nuestros ';

  @override
  String get login_footer_termsOfService => 'Términos de Servicio';

  @override
  String get login_footer_and => ' y ';

  @override
  String get login_footer_privacyPolicy => 'Política de Privacidad';

  @override
  String get login_error_googleCancelled =>
      'El inicio de sesión con Google fue cancelado o falló. Por favor, inténtalo de nuevo.';

  @override
  String login_error_signIn(String error) {
    return 'Error de inicio de sesión: $error';
  }

  @override
  String get login_error_invalidCredentials =>
      'Correo o contraseña inválidos. Por favor, inténtalo de nuevo.';

  @override
  String get emailLogin_title => 'Bienvenido de Nuevo';

  @override
  String get emailLogin_subtitle => 'Inicia sesión para continuar';

  @override
  String get emailLogin_field_email => 'Correo Electrónico';

  @override
  String get emailLogin_field_password => 'Contraseña';

  @override
  String get emailLogin_validation_emailRequired =>
      'Por favor ingresa tu correo';

  @override
  String get emailLogin_validation_passwordRequired =>
      'Por favor ingresa tu contraseña';

  @override
  String get emailLogin_button_forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get emailLogin_button_login => 'Iniciar Sesión';

  @override
  String get emailLogin_error_emailFirst =>
      'Por favor ingresa tu correo primero';

  @override
  String get emailLogin_success_passwordReset =>
      'Correo de restablecimiento enviado';

  @override
  String emailLogin_error_generic(String error) {
    return 'Error: $error';
  }

  @override
  String home_appBar_subtitle(String familyName) {
    return 'Familia $familyName';
  }

  @override
  String get home_stats_totalItems => 'Artículos Totales';

  @override
  String get home_stats_members => 'Miembros';

  @override
  String get home_search_hint => 'Buscar artículos, ubicaciones...';

  @override
  String get home_section_quickActions => 'Acciones Rápidas';

  @override
  String get home_section_familyMembers => 'Miembros de la Familia';

  @override
  String get home_section_recentItems => 'Artículos Recientes';

  @override
  String get home_section_seasonalReminders => 'Recordatorios de Temporada';

  @override
  String get home_section_storageLocations => 'Ubicaciones de Almacenamiento';

  @override
  String get home_action_addItem => 'Agregar Artículo';

  @override
  String get home_action_scanQR => 'Escanear QR';

  @override
  String get home_action_viewAll => 'Ver Todo';

  @override
  String get home_action_manage => 'Administrar';

  @override
  String home_member_age(int age) {
    return 'Edad $age';
  }

  @override
  String home_member_size(String size) {
    return 'Talla $size';
  }

  @override
  String home_member_items(int count) {
    return '$count artículos';
  }

  @override
  String get home_member_status_active => 'Activo';

  @override
  String get home_item_storage => 'Almacenamiento';

  @override
  String get home_reminder_fallTitle => 'Se Acerca el Otoño';

  @override
  String get home_reminder_fallMessage =>
      'Es hora de revisar la ropa de otoño para tus hijos. Considera los cambios de talla del año pasado.';

  @override
  String get home_reminder_reviewItems => 'Revisar Artículos';

  @override
  String home_error_loadingData(String error) {
    return 'Error al cargar datos: $error';
  }

  @override
  String get addItem_title_add => 'Agregar Nuevo Artículo';

  @override
  String get addItem_title_edit => 'Editar Artículo';

  @override
  String get addItem_section_photos => 'Fotos';

  @override
  String get addItem_section_itemDetails => 'Detalles del Artículo';

  @override
  String get addItem_section_size => 'Talla';

  @override
  String get addItem_section_seasonMember => 'Temporada y Miembro';

  @override
  String get addItem_section_storageLocation => 'Ubicación de Almacenamiento';

  @override
  String get addItem_button_addPhoto => 'Agregar Foto';

  @override
  String get addItem_button_takePhoto => 'Tomar Foto';

  @override
  String get addItem_button_chooseGallery => 'Elegir de la Galería';

  @override
  String get addItem_button_saveItem => 'Guardar Artículo';

  @override
  String get addItem_field_itemName => 'Nombre del Artículo';

  @override
  String get addItem_field_itemNameHint => 'ej., Chaqueta de Invierno';

  @override
  String get addItem_field_category => 'Categoría';

  @override
  String get addItem_field_gender => 'Género';

  @override
  String get addItem_field_size => 'Talla';

  @override
  String get addItem_field_customSize => 'Ingresar Talla Personalizada';

  @override
  String get addItem_field_customSizeHint => 'ej., 32W, 10.5, etc.';

  @override
  String get addItem_field_quantity => 'Cantidad';

  @override
  String get addItem_field_seasons => 'Temporada(s)';

  @override
  String get addItem_field_assignedTo => 'Asignado a';

  @override
  String get addItem_field_assignedToHint => 'Seleccionar miembro';

  @override
  String get addItem_field_none => 'Ninguno';

  @override
  String get addItem_category_clothes => 'Ropa';

  @override
  String get addItem_category_shoes => 'Zapatos';

  @override
  String get addItem_category_accessories => 'Accesorios';

  @override
  String get addItem_category_toys => 'Juguetes';

  @override
  String get addItem_category_gear => 'Equipo';

  @override
  String get addItem_gender_unisex => 'Unisex';

  @override
  String get addItem_gender_boy => 'Niño';

  @override
  String get addItem_gender_girl => 'Niña';

  @override
  String get addItem_season_winter => 'Invierno';

  @override
  String get addItem_season_spring => 'Primavera';

  @override
  String get addItem_season_summer => 'Verano';

  @override
  String get addItem_season_fall => 'Otoño';

  @override
  String get addItem_size_other => 'Otro';

  @override
  String get addItem_validation_required => 'Requerido';

  @override
  String get addItem_validation_selectStorage =>
      'Por favor selecciona una ubicación de almacenamiento';

  @override
  String get addItem_validation_selectSize => 'Por favor selecciona una talla';

  @override
  String get addItem_validation_enterSize => 'Por favor ingresa una talla';

  @override
  String get addItem_success_added => 'Artículo agregado exitosamente';

  @override
  String get addItem_success_updated => 'Artículo actualizado exitosamente';

  @override
  String addItem_error_saving(String error) {
    return 'Error al guardar artículo: $error';
  }

  @override
  String addItem_error_pickingImage(String error) {
    return 'Error al seleccionar imagen: $error';
  }

  @override
  String addItem_error_loadingData(String error) {
    return 'Error al cargar datos: $error';
  }

  @override
  String addItem_location_found(String name) {
    return 'Ubicación encontrada: $name';
  }

  @override
  String addItem_location_unknown(String code) {
    return 'Código de ubicación desconocido: $code';
  }

  @override
  String get profile_title => 'Perfil';

  @override
  String get profile_button_editProfile => 'Editar Perfil';

  @override
  String get profile_role_familyAdmin => 'Administrador Familiar';

  @override
  String get profile_section_familyManagement => 'Gestión Familiar';

  @override
  String get profile_section_appSettings => 'Configuración de la App';

  @override
  String get profile_section_dataPrivacy => 'Datos y Privacidad';

  @override
  String get profile_section_support => 'Soporte';

  @override
  String get profile_section_language => 'Idioma';

  @override
  String profile_family_name(String familyName) {
    return 'Familia $familyName';
  }

  @override
  String profile_family_members(int count) {
    return '$count miembros • Eres administrador';
  }

  @override
  String get profile_family_inviteMembers => 'Invitar Miembros';

  @override
  String get profile_family_inviteSubtitle => 'Compartir acceso familiar';

  @override
  String get profile_setting_darkMode => 'Modo Oscuro';

  @override
  String get profile_setting_darkModeSubtitle => 'Cambiar tema oscuro';

  @override
  String get profile_setting_notifications => 'Notificaciones';

  @override
  String get profile_setting_notificationsSubtitle => 'Recordatorios y alertas';

  @override
  String get profile_setting_seasonalReminders => 'Recordatorios de Temporada';

  @override
  String get profile_setting_seasonalRemindersSubtitle =>
      'Alertas automáticas de temporada';

  @override
  String get profile_setting_autoSync => 'Sincronización Automática';

  @override
  String get profile_setting_autoSyncSubtitle => 'Sincronización en la nube';

  @override
  String get profile_setting_biometricLogin => 'Inicio Biométrico';

  @override
  String get profile_setting_biometricLoginSubtitle =>
      'Activar Face ID / Touch ID';

  @override
  String get profile_setting_language => 'Idioma';

  @override
  String get profile_setting_languageSubtitle => 'Cambiar idioma de la app';

  @override
  String get profile_data_exportData => 'Exportar Datos';

  @override
  String get profile_data_exportDataSubtitle => 'Descargar tu información';

  @override
  String get profile_data_backupData => 'Respaldar Datos';

  @override
  String get profile_data_backupDataSubtitle => 'Crear copia de respaldo';

  @override
  String get profile_data_privacyPolicy => 'Política de Privacidad';

  @override
  String get profile_data_privacyPolicySubtitle => 'Cómo protegemos tus datos';

  @override
  String get profile_support_helpCenter => 'Centro de Ayuda';

  @override
  String get profile_support_helpCenterSubtitle =>
      'Preguntas frecuentes y tutoriales';

  @override
  String get profile_support_contactSupport => 'Contactar Soporte';

  @override
  String get profile_support_contactSupportSubtitle =>
      'Obtén ayuda de nuestro equipo';

  @override
  String get profile_support_rateApp => 'Calificar App';

  @override
  String get profile_support_rateAppSubtitle => 'Comparte tu opinión';

  @override
  String get profile_dialog_logout_title => 'Cerrar Sesión';

  @override
  String get profile_dialog_logout_message =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get profile_dialog_logout_cancel => 'Cancelar';

  @override
  String get profile_dialog_logout_confirm => 'Cerrar Sesión';

  @override
  String get profile_dialog_biometric_title => 'Activar Inicio Biométrico';

  @override
  String get profile_dialog_biometric_message =>
      'Por favor ingresa tu correo y contraseña para almacenarlos de forma segura.';

  @override
  String get profile_dialog_biometric_email => 'Correo Electrónico';

  @override
  String get profile_dialog_biometric_password => 'Contraseña';

  @override
  String get profile_dialog_biometric_cancel => 'Cancelar';

  @override
  String get profile_dialog_biometric_enable => 'Activar';

  @override
  String get profile_success_biometricEnabled => 'Inicio biométrico activado';

  @override
  String profile_error_logoutFailed(String error) {
    return 'Error al cerrar sesión: $error';
  }

  @override
  String get language_english => 'Inglés';

  @override
  String get language_spanish => 'Español';

  @override
  String get language_french => 'Francés';

  @override
  String get language_italian => 'Italiano';

  @override
  String get language_german => 'Alemán';

  @override
  String get common_loading => 'Cargando...';

  @override
  String get common_save => 'Guardar';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_delete => 'Eliminar';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_add => 'Agregar';

  @override
  String get common_search => 'Buscar';

  @override
  String get common_filter => 'Filtrar';

  @override
  String get common_error => 'Error';

  @override
  String get common_success => 'Éxito';

  @override
  String get common_comingSoon => 'Próximamente';

  @override
  String get addMember_title_add => 'Agregar Miembro Familiar';

  @override
  String get addMember_title_edit => 'Editar Miembro Familiar';

  @override
  String get addMember_success_added =>
      'Miembro familiar agregado exitosamente';

  @override
  String get addMember_success_updated =>
      'Miembro familiar actualizado exitosamente';

  @override
  String get addMember_success_deleted =>
      'Miembro familiar eliminado exitosamente';

  @override
  String addMember_error_saving(String error) {
    return 'Error al guardar miembro: $error';
  }

  @override
  String addMember_error_deleting(String error) {
    return 'Error al eliminar miembro: $error';
  }

  @override
  String get addMember_dialog_delete_title => 'Eliminar Miembro';

  @override
  String get addMember_dialog_delete_message =>
      '¿Estás seguro de que quieres eliminar este miembro familiar? Esta acción no se puede deshacer.';

  @override
  String get addMember_section_basicInfo => 'Información Básica';

  @override
  String get addMember_field_name => 'Nombre del Miembro';

  @override
  String get addMember_field_nameHint => 'Ingresa nombre completo';

  @override
  String get addMember_field_gender => 'Género';

  @override
  String get addMember_field_birthdate => 'Fecha de Nacimiento';

  @override
  String get addMember_field_birthdateHint => 'dd/mm/aaaa';

  @override
  String get addMember_section_sizes => 'Tallas Actuales';

  @override
  String get addMember_field_clothingSize => 'Talla de Ropa';

  @override
  String get addMember_field_clothingSizeHint => 'ej. 110 (cm) o 5 (edad)';

  @override
  String get addMember_field_shoeSize => 'Talla de Zapato';

  @override
  String get addMember_field_shoeSizeHint => 'ej. 28';

  @override
  String get addMember_section_notes => 'Notas Adicionales';

  @override
  String get addMember_field_notesHint =>
      'Notas especiales sobre las preferencias de este niño, etc.';

  @override
  String get addMember_button_update => 'Actualizar';

  @override
  String get addMember_button_add => 'Agregar';

  @override
  String get addMember_button_deleteMember => 'Eliminar Miembro';

  @override
  String get addMember_section_accountAccess => 'Acceso a la Cuenta';

  @override
  String get addMember_field_inviteEmail => 'Correo de Invitación';

  @override
  String get addMember_field_inviteEmailHint =>
      'Introduce el correo electrónico';

  @override
  String get addMember_button_sendInvite => 'Enviar Invitación';

  @override
  String get addMember_button_resendInvite => 'Reenviar Invitación';

  @override
  String get addMember_status_pending => 'Invitación Pendiente';

  @override
  String get addMember_status_accepted => 'Invitación Aceptada';

  @override
  String addMember_status_inviteSent(Object email) {
    return 'Invitación enviada a $email';
  }

  @override
  String addMember_status_accountLinked(Object email) {
    return 'Cuenta Vinculada: $email';
  }

  @override
  String get addMember_error_invalidEmail =>
      'Por favor, introduce un correo válido';

  @override
  String get addMember_field_role => 'Rol del Miembro';

  @override
  String get addMember_role_admin => 'Admin';

  @override
  String get addMember_role_member => 'Miembro';

  @override
  String get addMember_role_child => 'Hijo/a';

  @override
  String get addMember_invite_description =>
      'Invita a miembros a unirse a tu familia SeasonBox. Podrán ver y gestionar artículos según su rol.';

  @override
  String get addMember_validation_nameRequired => 'Por favor ingresa un nombre';

  @override
  String get addMember_dialog_cancelInvite_title => 'Cancelar invitación';

  @override
  String get addMember_dialog_cancelInvite_message =>
      '¿Estás seguro de que deseas cancelar esta invitación? El usuario ya no podrá unirse usando esta invitación.';

  @override
  String get addMember_button_cancelInvite => 'Cancelar invitación';

  @override
  String addMember_share_message(String familyId) {
    return '¡Únete a mi familia SeasonBox! Usa el código: $familyId';
  }

  @override
  String get addMember_action_share => 'Compartir invitación';

  @override
  String get addMember_action_copy => 'Copiar código';

  @override
  String get addMember_snack_copied => 'ID de familia copiado al portapapeles';

  @override
  String get register_title => 'Crear Cuenta';

  @override
  String get register_subtitle => 'Únete a la familia SeasonBox';

  @override
  String get register_field_name => 'Nombre completo';

  @override
  String get register_field_familyCode => 'Código de familia (Opcional)';

  @override
  String get register_button_create => 'Crear Cuenta';

  @override
  String get register_link_login => '¿Ya tienes una cuenta? Iniciar sesión';

  @override
  String get register_text_noAccount => '¿Aún no tienes cuenta?';

  @override
  String get register_link_registerNow => 'Regístrate ahora';

  @override
  String get register_error_familyNotFound => 'Familia no encontrada';

  @override
  String get register_success => 'Cuenta creada exitosamente';

  @override
  String get profile_joinFamily_title => 'Unirse a familia';

  @override
  String get profile_joinFamily_input => 'Ingresa el código de familia';

  @override
  String get profile_leaveFamily_title => 'Dejar familia';

  @override
  String get profile_leaveFamily_confirm =>
      '¿Está seguro de que desea abandonar esta familia? Será eliminado de la lista de miembros.';

  @override
  String get profile_disbandFamily_confirm =>
      'Advertencia: Eres el administrador. Salir eliminará a todos los miembros y eliminará el grupo familiar. Esta acción no se puede deshacer.';

  @override
  String get error_no_invitation =>
      'No se encontró una invitación activa para esta familia.';

  @override
  String get profile_joinFamily_success =>
      'Te has unido a la familia exitosamente';

  @override
  String get profile_leaveFamily_success =>
      'Has dejado la familia exitosamente';

  @override
  String get members_title => 'Miembros de la Familia';

  @override
  String get members_label_currentSize => 'Talla Actual';

  @override
  String get members_label_items => 'Artículos';

  @override
  String get members_button_viewItems => 'Ver Artículos';

  @override
  String get members_empty => 'No se han agregado miembros aún';

  @override
  String members_error_loading(String error) {
    return 'Error al cargar datos: $error';
  }

  @override
  String get addStorage_title_add => 'Agregar Ubicación de Almacenamiento';

  @override
  String get addStorage_title_edit => 'Editar Ubicación de Almacenamiento';

  @override
  String get addStorage_success_added =>
      'Ubicación de almacenamiento agregada exitosamente';

  @override
  String get addStorage_success_updated =>
      'Ubicación de almacenamiento actualizada exitosamente';

  @override
  String get addStorage_success_deleted =>
      'Ubicación de almacenamiento eliminada exitosamente';

  @override
  String addStorage_error_saving(String error) {
    return 'Error al guardar ubicación: $error';
  }

  @override
  String addStorage_error_deleting(String error) {
    return 'Error al eliminar ubicación: $error';
  }

  @override
  String get addStorage_dialog_delete_title =>
      'Eliminar Ubicación de Almacenamiento';

  @override
  String get addStorage_dialog_delete_message =>
      '¿Estás seguro de que quieres eliminar esta ubicación de almacenamiento?';

  @override
  String get addStorage_section_type => 'Tipo de Almacenamiento';

  @override
  String get addStorage_section_basicInfo => 'Información Básica';

  @override
  String get addStorage_field_name => 'Nombre de Almacenamiento';

  @override
  String get addStorage_field_nameHint => 'Ingresa nombre de almacenamiento';

  @override
  String get addStorage_field_parent => 'Ubicación Principal (Opcional)';

  @override
  String get addStorage_field_parentNone => 'Ninguna (nivel superior)';

  @override
  String get addStorage_section_description => 'Descripción';

  @override
  String get addStorage_field_descriptionHint => 'Descripción opcional';

  @override
  String get addStorage_button_update => 'Actualizar';

  @override
  String get addStorage_button_add => 'Agregar';

  @override
  String get addStorage_button_deleteLocation =>
      'Eliminar Ubicación de Almacenamiento';

  @override
  String get storage_title => 'Almacenamiento';

  @override
  String storage_error_loading(String error) {
    return 'Error al cargar ubicaciones de almacenamiento: $error';
  }

  @override
  String get nav_home => 'Inicio';

  @override
  String get nav_items => 'Artículos';

  @override
  String get nav_members => 'Miembros';

  @override
  String get nav_storage => 'Almacenamiento';

  @override
  String get nav_profile => 'Perfil';

  @override
  String storage_subtitle(int count, int itemCount) {
    return '$count ubicaciones • $itemCount artículos';
  }

  @override
  String get storage_searchHint => 'Buscar ubicaciones...';

  @override
  String get storage_filterAll => 'Todo';

  @override
  String get storage_filterBasement => 'Sótano';

  @override
  String get storage_filterClosets => 'Armarios';

  @override
  String get storage_filterAttic => 'Ático';

  @override
  String get storage_sectionBoxes => 'Cajas';

  @override
  String get storage_sectionClosets => 'Armarios';

  @override
  String get storage_sectionAreas => 'Áreas';

  @override
  String get storage_sectionOther => 'Otro Almacenamiento';

  @override
  String get storage_expandAll => 'Expandir Todo';

  @override
  String get storage_noDescription => 'Sin descripción';

  @override
  String storage_itemsCount(int count) {
    return '$count artículos';
  }

  @override
  String get storage_viewItems => 'Ver Artículos';

  @override
  String get storage_quickActions => 'Acciones Rápidas';

  @override
  String get storage_scanQrCode => 'Escanear Código QR';

  @override
  String get storage_printLabels => 'Imprimir Etiquetas';

  @override
  String get members_subtitle => 'Gestionar miembros de la familia';

  @override
  String get members_summaryMembers => 'Miembros';

  @override
  String get members_summaryTotalItems => 'Artículos Totales';

  @override
  String get members_summaryNeedCheck => 'Necesitan Revisión';

  @override
  String members_ageYears(int age) {
    return '$age años';
  }

  @override
  String members_born(String date) {
    return 'Nacido: $date';
  }

  @override
  String members_clothes(String size) {
    return 'Ropa: $size';
  }

  @override
  String members_shoes(String size) {
    return 'Zapatos: $size';
  }

  @override
  String get members_hasItems => '✓ Tiene artículos';

  @override
  String get members_noItemsYet => 'Sin artículos aún';

  @override
  String get members_tooltipGrowthChart => 'Gráfico de Crecimiento';

  @override
  String get members_tooltipEdit => 'Editar';

  @override
  String get items_title => 'Artículos';

  @override
  String items_subtitle(int count) {
    return '$count artículos en total';
  }

  @override
  String items_subtitleWithLocation(String location, int count) {
    return '$location • $count artículos';
  }

  @override
  String get items_filterAllItems => 'Todos';

  @override
  String get items_filterInUse => 'En Uso';

  @override
  String get items_filterStored => 'Almacenado';

  @override
  String get items_filterWinter => 'Invierno';

  @override
  String get items_filterSummer => 'Verano';

  @override
  String get items_quickFilters => 'Filtros Rápidos';

  @override
  String get items_clearAll => 'Limpiar Todo';

  @override
  String get items_filterClothes => 'Ropa';

  @override
  String get items_filterShoes => 'Zapatos';

  @override
  String get items_filterAccessories => 'Accesorios';

  @override
  String items_sizeLabel(String size, String gender) {
    return 'Talla $size • $gender';
  }

  @override
  String get items_noSeasonTags => 'Sin etiquetas de temporada';

  @override
  String items_quantity(int count) {
    return 'Cantidad: $count';
  }

  @override
  String get items_statusInUse => 'En Uso';

  @override
  String get items_statusStored => 'Almacenado';

  @override
  String get items_statusOutgrown => 'Quedó Pequeño';

  @override
  String get editProfile_title => 'Editar Perfil';

  @override
  String get editProfile_changePhoto => 'Cambiar Foto';

  @override
  String get editProfile_section_personalInfo => 'Información Personal';

  @override
  String get editProfile_field_fullName => 'Nombre Completo';

  @override
  String get editProfile_field_email => 'Correo Electrónico';

  @override
  String get editProfile_hint_emailCannotChanged =>
      'El correo no se puede cambiar';

  @override
  String get editProfile_field_phone => 'Número de Teléfono';

  @override
  String get editProfile_field_role => 'Rol';

  @override
  String get editProfile_section_preferences => 'Preferencias';

  @override
  String get editProfile_pref_emailNotifications => 'Notificaciones por Correo';

  @override
  String get editProfile_pref_emailNotificationsSubtitle =>
      'Recibir actualizaciones por correo';

  @override
  String get editProfile_pref_pushNotifications => 'Notificaciones Push';

  @override
  String get editProfile_pref_pushNotificationsSubtitle =>
      'Recibir alertas en tu dispositivo';

  @override
  String get editProfile_pref_weeklyDigest => 'Resumen Semanal';

  @override
  String get editProfile_pref_weeklyDigestSubtitle =>
      'Resumen de actividad familiar';

  @override
  String get editProfile_section_unitsDisplay => 'Unidades y Visualización';

  @override
  String get editProfile_field_measurementSystem => 'Sistema de Medidas';

  @override
  String get editProfile_option_imperial => 'Imperial (EE. UU.)';

  @override
  String get editProfile_option_metric => 'Métrico';

  @override
  String get editProfile_button_saveChanges => 'Guardar Cambios';
}
