import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:seasonbox/data/models/storage_location.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/repositories/storage_location_repository.dart';
import 'package:seasonbox/data/repositories/family_member_repository.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/widgets/app_card.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:seasonbox/core/services/permission_service.dart';

class AddStorageLocationScreen extends StatefulWidget {
  final StorageLocation? location;
  final String? initialParentId;

  const AddStorageLocationScreen(
      {super.key, this.location, this.initialParentId});

  @override
  State<AddStorageLocationScreen> createState() =>
      _AddStorageLocationScreenState();
}

class _AddStorageLocationScreenState extends State<AddStorageLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = 'Box';
  String? _parentLocationId;

  bool _isLoading = false;
  List<StorageLocation> _potentialParents = [];
  List<FamilyMember> _allMembers = [];
  String? _currentUserId;
  String? _familyId;

  @override
  void initState() {
    super.initState();
    _loadData();
    if (widget.location != null) {
      _nameController.text = widget.location!.name;
      _descriptionController.text = widget.location!.description;
      _selectedType = widget.location!.type;
      _parentLocationId = widget.location!.parentId;
      // Note: isClimateControlled and isAccessible are not in the model yet
      // If you add them later, initialize them here
    } else if (widget.initialParentId != null) {
      _parentLocationId = widget.initialParentId;
    }
  }

  Future<void> _loadData() async {
    try {
      final authService = context.read<AuthService>();
      final familyId = await authService.getCurrentUserFamilyId();
      final userId = authService.currentUser?.uid;

      if (familyId == null || userId == null) return;

      if (!mounted) return;
      final results = await Future.wait([
        context.read<StorageLocationRepository>().getLocations(familyId),
        context.read<FamilyMemberRepository>().getFamilyMembers(familyId),
      ]);

      if (mounted) {
        setState(() {
          _currentUserId = userId;
          _familyId = familyId;
          final locations = results[0] as List<StorageLocation>;
          _allMembers = results[1] as List<FamilyMember>;
          // Filter out the current location if editing (can't be its own parent)
          _potentialParents = locations
              .where(
                  (l) => widget.location == null || l.id != widget.location!.id)
              .toList();
        });
      }
    } catch (e) {
      // Silently handle error - permissions will default to restricted
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveLocation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final familyId =
          await context.read<AuthService>().getCurrentUserFamilyId();
      if (!mounted) return;

      if (familyId == null) {
        throw Exception('User not authenticated');
      }

      final location = StorageLocation(
        id: widget.location?.id ?? const Uuid().v4(),
        familyId: familyId,
        name: _nameController.text.trim(),
        type: _selectedType,
        parentId: _parentLocationId,
        description: _descriptionController.text.trim(),
        isCapacityLimited: false,
        isFamilyAccessible: true,
        qrCodeId: null,
      );

      if (!mounted) return;
      if (widget.location != null) {
        await context
            .read<StorageLocationRepository>()
            .updateLocation(location);
      } else {
        await context.read<StorageLocationRepository>().addLocation(location);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.location != null
                  ? 'Storage location updated successfully'
                  : 'Storage location added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving location: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteLocation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Storage Location'),
        content: const Text(
            'Are you sure you want to delete this storage location? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final familyId =
          await context.read<AuthService>().getCurrentUserFamilyId();
      if (familyId == null) {
        throw Exception('User not authenticated');
      }

      if (!mounted) return;
      await context
          .read<StorageLocationRepository>()
          .deleteLocation(familyId, widget.location!.id);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Storage location deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting location: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SeasonBoxAppBar(
        title: widget.location != null
            ? AppLocalizations.of(context)!.addStorage_title_edit
            : AppLocalizations.of(context)!.addStorage_title_add,
        actions: widget.location != null
            ? [
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () {},
                ),
              ]
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Storage Type Section
                    Text(AppLocalizations.of(context)!.addStorage_section_type,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Row(
                        children: [
                          _buildTypeCard('Box', Icons.inventory_2),
                          _buildTypeCard('Closet', Icons.door_sliding),
                          _buildTypeCard('Area', Icons.garage),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Basic Information Section
                    Text(
                        AppLocalizations.of(context)!
                            .addStorage_section_basicInfo,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .addStorage_field_name,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .addStorage_field_nameHint,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                              AppLocalizations.of(context)!
                                  .addStorage_field_parent,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _parentLocationId,
                            decoration: const InputDecoration(
                              hintText: 'Select parent location',
                            ),
                            items: [
                              DropdownMenuItem(
                                  value: null,
                                  child: Text(AppLocalizations.of(context)!
                                      .addStorage_field_parentNone)),
                              ..._potentialParents.map((l) => DropdownMenuItem(
                                  value: l.id, child: Text(l.name))),
                            ],
                            onChanged: (value) =>
                                setState(() => _parentLocationId = value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description Section
                    Text(
                        AppLocalizations.of(context)!
                            .addStorage_section_description,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .addStorage_field_descriptionHint,
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade600),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.common_cancel,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: PermissionService.canManageStorage(
                              _currentUserId,
                              _familyId,
                              _allMembers,
                            )
                                ? _saveLocation
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              elevation: 0,
                            ),
                            child: Text(
                              widget.location != null
                                  ? AppLocalizations.of(context)!
                                      .addStorage_button_update
                                  : AppLocalizations.of(context)!
                                      .addStorage_button_add,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.location != null &&
                        PermissionService.canManageStorage(
                          _currentUserId,
                          _familyId,
                          _allMembers,
                        )) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: _deleteLocation,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!
                                .addStorage_button_deleteLocation,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTypeCard(String type, IconData icon) {
    final isSelected = _selectedType == type;
    final theme = Theme.of(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: () => setState(() => _selectedType = type),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color:
                  isSelected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.grey.shade700,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 24,
                    color: isSelected ? Colors.white : Colors.grey.shade400),
                const SizedBox(height: 8),
                Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
