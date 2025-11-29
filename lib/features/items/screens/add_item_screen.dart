import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/item.dart';
import '../../../data/models/storage_location.dart';
import '../../../data/repositories/family_member_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/storage_location_repository.dart';
import '../../../features/auth/data/auth_service.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/season_box_app_bar.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController(); // Used for notes
  final _brandController = TextEditingController();

  // New State Variables
  String _selectedCategory = 'Clothes';
  String _selectedGender = 'Unisex';
  String _selectedSize = '10';
  int _quantity = 1;
  String? _assignedChildId;
  String? _storageLocationId;
  final Set<String> _selectedSeasons = {'Winter'}; // Default selection

  List<FamilyMember> _members = [];
  List<StorageLocation> _locations = [];
  bool _isLoadingData = true;
  bool _isSaving = false;

  final List<String> _categories = [
    'Clothes',
    'Shoes',
    'Accessories',
    'Toys',
    'Gear'
  ];

  bool _isCustomSize = false;
  final TextEditingController _customSizeController = TextEditingController();

  final List<String> _genders = ['Boy', 'Girl', 'Unisex'];

  // Size Constants
  static const List<String> _clothesSizes = [
    'NB', '3M', '6M', '9M', '12M', '18M', '24M', // Baby
    '2T', '3T', '4T', '5T', // Toddler
    '4', '5', '6', '6X', '7', '8', '10', '12', '14', '16', // Kids Numeric
    'XS', 'S', 'M', 'L', 'XL' // Kids Alpha
  ];

  static const List<String> _shoeSizes = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',
    '13', // Little Kids
    '1Y', '2Y', '3Y', '4Y', '5Y', '6Y', '7Y' // Big Kids
  ];

  List<String> get _currentSizes {
    if (_selectedCategory == 'Clothes') return _clothesSizes;
    if (_selectedCategory == 'Shoes') return _shoeSizes;
    return []; // Empty for other categories, defaults to custom input
  }

  final List<Map<String, dynamic>> _seasons = [
    {'label': 'Winter', 'icon': Icons.ac_unit, 'color': Colors.blue},
    {'label': 'Spring', 'icon': Icons.local_florist, 'color': Colors.green},
    {'label': 'Summer', 'icon': Icons.wb_sunny, 'color': Colors.orange},
    {'label': 'Fall', 'icon': Icons.cloud, 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Get family ID from authenticated user
      final familyId =
          await context.read<AuthService>().getCurrentUserFamilyId();
      if (familyId == null) {
        throw Exception('User not authenticated');
      }

      final members = await context
          .read<FamilyMemberRepository>()
          .getFamilyMembers(familyId)
          .timeout(const Duration(seconds: 5));
      if (!mounted) return;

      final locations = await context
          .read<StorageLocationRepository>()
          .getLocations(familyId)
          .timeout(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _members = members;
          _locations = locations;
          _isLoadingData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _customSizeController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;
    if (_storageLocationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a storage location')),
      );
      return;
    }

    if (!_isCustomSize && _selectedSize.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a size')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final familyId =
          await context.read<AuthService>().getCurrentUserFamilyId();
      if (familyId == null) {
        throw Exception('User not authenticated');
      }

      final item = Item(
        id: const Uuid().v4(),
        familyId: familyId,
        title: _titleController.text.trim(),
        category: _selectedCategory,
        gender: _selectedGender,
        size: _isCustomSize ? _customSizeController.text.trim() : _selectedSize,
        seasonTags: _selectedSeasons.toList(),
        storageLocationId: _storageLocationId!,
        quantity: _quantity,
        notes: _descriptionController.text.trim(),
        addedAt: DateTime.now(),
        status: 'stored', // Default status for new items
        photos: [], // Deferred to Sprint 3
      );

      await context.read<ItemRepository>().addItem(item);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding item: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const SeasonBoxAppBar(
        title: 'Add New Item',
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Photos Section
                    const Text('Photos',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Add Photo Button
                          Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: theme.primaryColor,
                                  style: BorderStyle
                                      .solid), // Dashed border would require custom painter or package
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Photo capture coming soon')),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      color: theme.primaryColor),
                                  const SizedBox(height: 4),
                                  Text('Add Photo',
                                      style: TextStyle(
                                          color: theme.primaryColor,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          // Placeholder for existing photos (if any)
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Item Details Section
                    const Text('Item Details',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Item Name',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: 'e.g., Winter Jacket',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            validator: (value) =>
                                value?.isEmpty == true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          const Text('Category',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            items: _categories
                                .map((c) =>
                                    DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _selectedCategory = v!;
                                // Reset size selection when category changes
                                _isCustomSize = false;
                                _selectedSize = '';
                                _customSizeController.clear();
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('Gender', style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          Row(
                            children: _genders.map((gender) {
                              final isSelected = _selectedGender == gender;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ChoiceChip(
                                    label: Text(gender),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(
                                            () => _selectedGender = gender);
                                      }
                                    },
                                    selectedColor: theme.primaryColor,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : theme.textTheme.bodyMedium?.color,
                                    ),
                                    showCheckmark: false,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Size Section
                    const Text('Size',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Size', style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ..._currentSizes.map((size) {
                                return ChoiceChip(
                                  label: Text(size),
                                  selected:
                                      !_isCustomSize && _selectedSize == size,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _isCustomSize = false;
                                        _selectedSize = size;
                                        _customSizeController.clear();
                                      });
                                    }
                                  },
                                  selectedColor: theme.primaryColor,
                                  labelStyle: TextStyle(
                                    color:
                                        !_isCustomSize && _selectedSize == size
                                            ? Colors.white
                                            : theme.textTheme.bodyMedium?.color,
                                  ),
                                  showCheckmark: false,
                                );
                              }),
                              ChoiceChip(
                                label: const Text('Other'),
                                selected: _isCustomSize,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _isCustomSize = true;
                                      _selectedSize = '';
                                    });
                                  }
                                },
                                selectedColor: theme.primaryColor,
                                labelStyle: TextStyle(
                                  color: _isCustomSize
                                      ? Colors.white
                                      : theme.textTheme.bodyMedium?.color,
                                ),
                                showCheckmark: false,
                              ),
                            ],
                          ),
                          if (_isCustomSize) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _customSizeController,
                              decoration: const InputDecoration(
                                labelText: 'Enter Custom Size',
                                hintText: 'e.g., 32W, 10.5, etc.',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (_isCustomSize &&
                                    (value == null || value.isEmpty)) {
                                  return 'Please enter a size';
                                }
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 16),
                          const Text('Quantity',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton.filledTonal(
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Container(
                                width: 60,
                                alignment: Alignment.center,
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton.filled(
                                onPressed: () {
                                  setState(() => _quantity++);
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Season & Child Section
                    const Text('Season & Child',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Season(s)',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _seasons.map((season) {
                              final label = season['label'] as String;
                              final icon = season['icon'] as IconData;
                              final color = season['color'] as Color;
                              final isSelected =
                                  _selectedSeasons.contains(label);
                              return FilterChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(icon,
                                        size: 16,
                                        color:
                                            isSelected ? Colors.white : color),
                                    const SizedBox(width: 4),
                                    Text(label),
                                  ],
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedSeasons.add(label);
                                    } else {
                                      _selectedSeasons.remove(label);
                                    }
                                  });
                                },
                                selectedColor: theme.primaryColor,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : theme.textTheme.bodyMedium?.color,
                                ),
                                showCheckmark: false,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          const Text('Assigned To',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _assignedChildId,
                            decoration: const InputDecoration(
                              hintText: 'Select child',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            items: [
                              const DropdownMenuItem(
                                  value: null, child: Text('None')),
                              ..._members.map((m) => DropdownMenuItem(
                                  value: m.id, child: Text(m.name))),
                            ],
                            onChanged: (v) =>
                                setState(() => _assignedChildId = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Storage Location Section
                    const Text('Storage Location',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Location',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _storageLocationId,
                            decoration: const InputDecoration(
                              hintText: 'Select location',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            items: _locations
                                .map((l) => DropdownMenuItem(
                                    value: l.id, child: Text(l.name)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _storageLocationId = v),
                            validator: (v) =>
                                v == null ? 'Please select a location' : null,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('QR Scanning coming soon')),
                                );
                              },
                              icon: const Icon(Icons.qr_code_scanner),
                              label: const Text('Scan QR Code'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor:
                                    Colors.cyan.withValues(alpha: 0.1),
                                foregroundColor: Colors.cyan,
                                side: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Notes Section
                    const Text('Notes (Optional)',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Add any additional notes about item...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveItem,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Save Item',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
