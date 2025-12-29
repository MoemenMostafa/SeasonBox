import 'package:flutter/material.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:seasonbox/data/services/storage_service.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/widgets/action_buttons.dart';

import 'package:seasonbox/widgets/app_card.dart';

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
  Uint8List? _imageBytes;
  XFile? _pickedXFile;
  bool _isLoading = false;

  // Preferences State
  // Notifications are hidden from UI, but we preserve them during save if needed,
  // or we assume they are managed elsewhere.
  // For now, we'll read them from widget.userData during save to avoid overwriting with null/false if we built a new map.

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

    // Initialize preferences if they exist in userData
    if (widget.userData?['preferences'] != null) {
      final prefs = widget.userData!['preferences'] as Map<String, dynamic>;
      _measurementSystem = prefs['measurementSystem'] ?? 'imperial';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null && mounted) {
        final storageService = context.read<StorageService>();

        // Resize image to thumbnail and get bytes
        final thumbnailBytes =
            await storageService.generateThumbnail(pickedFile);

        setState(() {
          _pickedXFile = pickedFile;
          _imageBytes = thumbnailBytes;
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
      if (_pickedXFile != null) {
        photoURL = await storageService.uploadProfileImage(
          file: _pickedXFile!,
          userId: user.uid,
        );
      }

      final displayName = _nameController.text.trim();
      String? familyName;
      if (displayName.isNotEmpty) {
        final parts = displayName.split(' ');
        familyName = parts.length > 1 ? parts.last : displayName;
      }

      // Reconstruct preferences map, preserving existing notification settings if possible
      final Map<String, dynamic> currentPrefs =
          widget.userData?['preferences'] is Map<String, dynamic>
              ? widget.userData!['preferences']
              : {};

      final newPreferences = {
        ...currentPrefs, // Keep existing values
        'measurementSystem': _measurementSystem, // Update only this
      };

      await userService.updateUserProfile(
        uid: user.uid,
        displayName: displayName,
        familyName: familyName,
        photoURL: photoURL,
        // Role is not editable here
        preferences: newPreferences,
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
              // Preferences (Notifications) removed per request

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

    if (_imageBytes != null) {
      imageProvider = MemoryImage(_imageBytes!);
    } else if (currentPhotoUrl != null) {
      imageProvider = currentPhotoUrl.startsWith('assets/')
          ? AssetImage(currentPhotoUrl) as ImageProvider
          : NetworkImage(currentPhotoUrl);
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
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildPersonalInfoForm(BuildContext context) {
    return AppCard(
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
        ],
      ),
    );
  }

  Widget _buildUnitsAndDisplay(BuildContext context) {
    return AppCard(
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
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
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
          // Decoration to match styling if needed, though standard theme usually handles it
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
