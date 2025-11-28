import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/child.dart';
import '../../../data/models/item.dart';
import '../../../data/models/storage_location.dart';
import '../../../data/repositories/child_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/storage_location_repository.dart';
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
  final _sizeController = TextEditingController();
  final _brandController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  String _selectedCategory = 'Clothes';
  String _selectedStatus = 'stored';
  String? _assignedChildId;
  String? _storageLocationId;
  final List<String> _selectedSeasons = [];

  List<Child> _children = [];
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
  final List<String> _statuses = ['stored', 'in_use', 'outgrown', 'donated'];
  final List<String> _seasons = [
    'Spring',
    'Summer',
    'Fall',
    'Winter',
    'All Year'
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // TODO: Get actual family ID
      const familyId = 'test-family-id';

      final children = await context
          .read<ChildRepository>()
          .getChildren(familyId)
          .timeout(const Duration(seconds: 5));
      final locations = await context
          .read<StorageLocationRepository>()
          .getLocations(familyId)
          .timeout(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _children = children;
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
    _sizeController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
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

    setState(() {
      _isSaving = true;
    });

    try {
      const familyId = 'test-family-id';

      final item = Item(
        id: const Uuid().v4(),
        familyId: familyId,
        title: _titleController.text.trim(),
        category: _selectedCategory,
        gender:
            'Unisex', // Default for now as we removed gender dropdown to simplify
        size: _sizeController.text.trim(),
        seasonTags:
            _selectedSeasons.isNotEmpty ? _selectedSeasons : ['All Year'],
        storageLocationId: _storageLocationId!,
        quantity: 1, // Default to 1
        notes: _descriptionController.text.trim(),
        addedAt: DateTime.now(),
        status: _selectedStatus,
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    // Photos Placeholder
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt,
                                size: 40, color: Colors.grey),
                            Text('Add Photo (Coming Soon)',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text('Item Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // Item Name
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        hintText: 'e.g., Winter Jacket',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter item name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: _categories
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value!),
                    ),
                    const SizedBox(height: 16),

                    // Status
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: _statuses
                          .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedStatus = value!),
                    ),
                    const SizedBox(height: 16),

                    // Size
                    TextFormField(
                      controller: _sizeController,
                      decoration: const InputDecoration(
                        labelText: 'Size',
                        hintText: 'e.g., 4T, 10, M',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter size';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Brand
                    TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(
                        labelText: 'Brand (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text('Season & Child',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // Season (Multi-select simplified to single select for now as per previous code)
                    // Or better, let's just use a single season dropdown for now to match _selectedSeasons usage if it was single
                    // But _selectedSeasons is a List. Let's just use a single dropdown and add it to the list.
                    DropdownButtonFormField<String>(
                      value: _seasons.first, // Default
                      decoration: const InputDecoration(
                        labelText: 'Season',
                        border: OutlineInputBorder(),
                      ),
                      items: _seasons
                          .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _selectedSeasons.clear();
                          _selectedSeasons.add(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Assigned Child (Optional)
                    DropdownButtonFormField<String>(
                      value: _assignedChildId,
                      decoration: InputDecoration(
                        labelText: 'Assigned To (Optional)',
                        border: const OutlineInputBorder(),
                        suffixIcon: _isLoadingData
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      items: [
                        const DropdownMenuItem(
                            value: null, child: Text('None')),
                        if (!_isLoadingData)
                          ..._children.map((c) => DropdownMenuItem(
                              value: c.id, child: Text(c.name))),
                      ],
                      onChanged: _isLoadingData
                          ? null
                          : (value) => setState(() => _assignedChildId = value),
                    ),
                    const SizedBox(height: 24),

                    const Text('Storage Location',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // Storage Location
                    DropdownButtonFormField<String>(
                      value: _storageLocationId,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: const OutlineInputBorder(),
                        suffixIcon: _isLoadingData
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      items: _isLoadingData
                          ? [
                              const DropdownMenuItem(
                                  value: null, child: Text('Loading...'))
                            ]
                          : _locations
                              .map((l) => DropdownMenuItem(
                                  value: l.id, child: Text(l.name)))
                              .toList(),
                      onChanged: _isLoadingData
                          ? null
                          : (value) =>
                              setState(() => _storageLocationId = value),
                      validator: (value) {
                        if (value == null && !_isLoadingData) {
                          return 'Please select a location';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Notes
                    TextFormField(
                      controller:
                          _descriptionController, // Using description controller for notes
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveItem,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Save Item'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
