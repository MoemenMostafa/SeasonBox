import 'package:flutter/material.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:seasonbox/data/services/storage_service.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/widgets/action_buttons.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const EditProfileScreen({super.key, this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Form Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _imageFile;
  bool _isLoading = false;

  // Preferences State
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  // Dropdown Values
  String _measurementSystem = 'imperial'; // imperial, metric

  @override
  void initState() {
    super.initState();
    // Initialize with real data or defaults
    _nameController =
        TextEditingController(text: widget.userData?['displayName'] ?? '');
    _emailController =
        TextEditingController(text: widget.userData?['email'] ?? '');
    _phoneController =
        TextEditingController(text: widget.userData?['phoneNumber'] ?? '');

    // Initialize preferences if they exist in userData
    if (widget.userData?['preferences'] != null) {
      final prefs = widget.userData!['preferences'] as Map<String, dynamic>;
      _emailNotifications = prefs['emailNotifications'] ?? true;
      _pushNotifications = prefs['pushNotifications'] ?? true;
      _measurementSystem = prefs['measurementSystem'] ?? 'imperial';
      // Language is handled globally by ThemeProvider, typically
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null && mounted) {
        final storageService = context.read<StorageService>();
        final originalFile = File(pickedFile.path);

        // Resize image to thumbnail
        final thumbnailFile =
            await storageService.generateThumbnail(originalFile);

        setState(() {
          _imageFile = thumbnailFile;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      final userService = context.read<UserService>();
      final storageService = context.read<StorageService>();

      final user = authService.currentUser;
      if (user == null) throw Exception('User not logged in');

      String? photoURL;
      if (_imageFile != null) {
        photoURL = await storageService.uploadProfileImage(
          file: _imageFile!,
          userId: user.uid,
        );
      }

      final displayName = _nameController.text.trim();
      String? familyName;
      if (displayName.isNotEmpty) {
        final parts = displayName.split(' ');
        familyName = parts.length > 1 ? parts.last : displayName;
      }

      await userService.updateUserProfile(
        uid: user.uid,
        displayName: displayName,
        familyName: familyName,
        phoneNumber: _phoneController.text.trim(),
        photoURL: photoURL,
        preferences: {
          'emailNotifications': _emailNotifications,
          'pushNotifications': _pushNotifications,
          'measurementSystem': _measurementSystem,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SeasonBoxAppBar(
        title: AppLocalizations.of(context)!.editProfile_title,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white)),
            )
          else
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfilePhoto(context),
              const SizedBox(height: 24),
              _buildSectionTitle(
                  context,
                  AppLocalizations.of(context)!
                      .editProfile_section_personalInfo),
              _buildPersonalInfoForm(context),
              const SizedBox(height: 24),
              _buildSectionTitle(
                  context,
                  AppLocalizations.of(context)!
                      .editProfile_section_preferences),
              _buildPreferences(context),
              const SizedBox(height: 24),
              _buildSectionTitle(
                  context,
                  AppLocalizations.of(context)!
                      .editProfile_section_unitsDisplay),
              _buildUnitsAndDisplay(context),
              const SizedBox(height: 32),
              _buildActionButtons(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(BuildContext context) {
    final currentPhotoUrl = widget.userData?['photoURL'];
    ImageProvider? imageProvider;

    if (_imageFile != null) {
      imageProvider = FileImage(_imageFile!);
    } else if (currentPhotoUrl != null) {
      imageProvider = NetworkImage(currentPhotoUrl);
    } else {
      imageProvider = null;
    }

    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey.shade400,
                      )
                    : null,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6200EA), // Deep Purple
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _pickImage,
          child: Text(
            AppLocalizations.of(context)!.editProfile_changePhoto,
            style: const TextStyle(
              color: Color(0xFF6200EA),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: AppLocalizations.of(context)!.editProfile_field_fullName,
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: AppLocalizations.of(context)!.editProfile_field_email,
            controller: _emailController,
            readOnly: true,
            helperText: AppLocalizations.of(context)!
                .editProfile_hint_emailCannotChanged,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: AppLocalizations.of(context)!.editProfile_field_phone,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: AppLocalizations.of(context)!.editProfile_field_role,
            value: 'Admin',
            items: ['Admin', 'Member'],
            onChanged: (val) {}, // Read-only or functional later
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            title: AppLocalizations.of(context)!
                .editProfile_pref_emailNotifications,
            subtitle: AppLocalizations.of(context)!
                .editProfile_pref_emailNotificationsSubtitle,
            value: _emailNotifications,
            onChanged: (val) => setState(() => _emailNotifications = val),
          ),
          Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.grey.withValues(alpha: 0.2)),
          _buildSwitchTile(
            title: AppLocalizations.of(context)!
                .editProfile_pref_pushNotifications,
            subtitle: AppLocalizations.of(context)!
                .editProfile_pref_pushNotificationsSubtitle,
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitsAndDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDropdownField(
            label: AppLocalizations.of(context)!
                .editProfile_field_measurementSystem,
            value: _measurementSystem,
            items: ['imperial', 'metric'],
            itemLabelBuilder: (item) => item == 'imperial'
                ? AppLocalizations.of(context)!.editProfile_option_imperial
                : AppLocalizations.of(context)!.editProfile_option_metric,
            onChanged: (val) => setState(() => _measurementSystem = val!),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ActionButtons(
      primaryLabel:
          AppLocalizations.of(context)!.editProfile_button_saveChanges,
      secondaryLabel: AppLocalizations.of(context)!.common_cancel,
      onPrimaryPressed: _saveProfile,
      onSecondaryPressed: () => Navigator.pop(context),
      isLoading: _isLoading,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    String? helperText,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly
                ? theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5)
                : theme.inputDecorationTheme.fillColor ?? theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            helperText: helperText,
            helperStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String Function(String)? itemLabelBuilder,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: theme.cardColor,
              icon: Icon(Icons.keyboard_arrow_down,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    itemLabelBuilder != null ? itemLabelBuilder(item) : item,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: theme.colorScheme.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
