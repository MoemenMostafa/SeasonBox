import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:seasonbox/data/models/storage_location.dart';
import 'package:seasonbox/data/repositories/storage_location_repository.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/widgets/app_card.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';

class AddStorageLocationScreen extends StatefulWidget {
  final StorageLocation? location;

  const AddStorageLocationScreen({super.key, this.location});

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

  @override
  void initState() {
    super.initState();
    if (widget.location != null) {
      _nameController.text = widget.location!.name;
      _descriptionController.text = widget.location!.description;
      _selectedType = widget.location!.type;
      _parentLocationId = widget.location!.parentId;
      // Note: isClimateControlled and isAccessible are not in the model yet
      // If you add them later, initialize them here
    }
    _loadParents();
  }

  Future<void> _loadParents() async {
    try {
      final familyId =
          await context.read<AuthService>().getCurrentUserFamilyId();
      if (!mounted) return;

      if (familyId == null) {
        throw Exception('User not authenticated');
      }
      final locations = await context
          .read<StorageLocationRepository>()
          .getLocations(familyId);
      if (mounted) {
        setState(() {
          // Filter out the current location if editing (can't be its own parent)
          _potentialParents = locations
              .where(
                  (l) => widget.location == null || l.id != widget.location!.id)
              .toList();
        });
      }
    } catch (e) {
      // Handle error silently or show a message
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
            ? 'Edit Storage Location'
            : 'Add Storage Location',
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
                    const Text('Storage Type',
                        style: TextStyle(
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
                    const Text('Basic Information',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Storage Name',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'e.g., Box A4, Emma\'s Closet',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('Parent Location (Optional)',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _parentLocationId,
                            decoration: const InputDecoration(
                              hintText: 'Select parent location',
                            ),
                            items: [
                              const DropdownMenuItem(
                                  value: null, child: Text('None (top level)')),
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
                    const Text('Description',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Additional details about this location...',
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
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveLocation,
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
                              widget.location != null ? 'Update' : 'Add',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.location != null) ...[
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
                          child: const Text(
                            'Delete Location',
                            style: TextStyle(
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
