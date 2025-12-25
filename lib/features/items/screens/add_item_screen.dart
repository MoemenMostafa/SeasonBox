import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/models/item.dart';
import 'package:seasonbox/data/models/storage_location.dart';
import 'package:seasonbox/data/repositories/family_member_repository.dart';
import 'package:seasonbox/data/repositories/item_repository.dart';
import 'package:seasonbox/data/repositories/storage_location_repository.dart';
import 'package:seasonbox/data/services/storage_service.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/widgets/app_card.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/widgets/skeleton_container.dart';
import 'package:seasonbox/widgets/image_gallery_viewer.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:seasonbox/core/services/permission_service.dart';

class AddItemScreen extends StatefulWidget {
  final Item? item; // Optional item for editing

  const AddItemScreen({super.key, this.item});

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

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  List<Map<String, String>> _existingPhotos = []; // For edit mode

  List<FamilyMember> _members = [];
  List<StorageLocation> _locations = [];
  bool _isLoadingData = true;
  bool _isTransitionComplete = false;
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

  // ... (Size Constants Remain Unchanged)
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

  List<String> _getSizesForCategory(String category) {
    if (category == 'Clothes') return _clothesSizes;
    if (category == 'Shoes') return _shoeSizes;
    return [];
  }

  final List<Map<String, dynamic>> _seasons = [
    {'label': 'Winter', 'icon': Icons.ac_unit, 'color': Colors.blue},
    {'label': 'Spring', 'icon': Icons.local_florist, 'color': Colors.green},
    {'label': 'Summer', 'icon': Icons.wb_sunny, 'color': Colors.orange},
    {'label': 'Fall', 'icon': Icons.cloud, 'color': Colors.purple},
  ];

  // Localization helper methods
  String _getCategoryName(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'Clothes':
        return l10n.addItem_category_clothes;
      case 'Shoes':
        return l10n.addItem_category_shoes;
      case 'Accessories':
        return l10n.addItem_category_accessories;
      case 'Toys':
        return l10n.addItem_category_toys;
      case 'Gear':
        return l10n.addItem_category_gear;
      default:
        return category;
    }
  }

  String _getGenderName(BuildContext context, String gender) {
    final l10n = AppLocalizations.of(context)!;
    switch (gender) {
      case 'Unisex':
        return l10n.addItem_gender_unisex;
      case 'Boy':
        return l10n.addItem_gender_boy;
      case 'Girl':
        return l10n.addItem_gender_girl;
      default:
        return gender;
    }
  }

  String _getSeasonName(BuildContext context, String season) {
    final l10n = AppLocalizations.of(context)!;
    switch (season) {
      case 'Winter':
        return l10n.addItem_season_winter;
      case 'Spring':
        return l10n.addItem_season_spring;
      case 'Summer':
        return l10n.addItem_season_summer;
      case 'Fall':
        return l10n.addItem_season_fall;
      default:
        return season;
    }
  }

  @override
  void initState() {
    super.initState();
    // Field population is deferred to _onTransitionComplete to prevent UI freeze
  }

  // ... (Lifecycle methods remain unchanged)

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoadingData) {
      final route = ModalRoute.of(context);
      if (route is PageRoute) {
        if (route.animation?.status == AnimationStatus.completed) {
          _onTransitionComplete();
        } else {
          route.animation?.addStatusListener(_onRouteAnimationStatusChanged);
        }
      } else {
        _onTransitionComplete();
      }
    }
  }

  void _onTransitionComplete() {
    if (mounted) {
      if (widget.item != null) {
        _titleController.text = widget.item!.title;
        _descriptionController.text = widget.item!.notes;
        _selectedCategory = widget.item!.category;
        _selectedGender = widget.item!.gender;
        _selectedSize = widget.item!.size;
        _quantity = widget.item!.quantity;
        _assignedChildId = widget.item!.memberId;
        _storageLocationId = widget.item!.storageLocationId;
        _selectedSeasons.clear();
        _selectedSeasons.addAll(widget.item!.seasonTags);
        // Load existing photos for edit mode
        _existingPhotos = List<Map<String, String>>.from(widget.item!.photos);
      }

      setState(() {
        _isTransitionComplete = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadData();
        }
      });
    }
  }

  void _onRouteAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onTransitionComplete();
      final route = ModalRoute.of(context);
      route?.animation?.removeStatusListener(_onRouteAnimationStatusChanged);
    }
  }

  Future<void> _loadData() async {
    // ... (Existing loadData logic)
    if (!_isLoadingData && _members.isNotEmpty) return;

    try {
      // Get all services/repositories before async operations
      final authService = context.read<AuthService>();
      final memberRepository = context.read<FamilyMemberRepository>();
      final locationRepository = context.read<StorageLocationRepository>();

      final familyId = await authService.getCurrentUserFamilyId();
      final userId = authService.currentUser?.uid;

      if (familyId == null || userId == null) {
        throw Exception('User not authenticated');
      }

      final members = await memberRepository
          .getFamilyMembers(familyId)
          .timeout(const Duration(seconds: 5));
      if (!mounted) return;

      final locations = await locationRepository
          .getLocations(familyId)
          .timeout(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _members = members;
          _locations = locations;
          _isLoadingData = false;

          // Auto-assign to current user if they're a member (not admin) and creating a new item
          if (widget.item == null &&
              !PermissionService.isAdmin(userId, familyId, members)) {
            _assignedChildId = userId;
          }
        });

        if (widget.item != null) {
          final availableSizes = _getSizesForCategory(_selectedCategory);
          _isCustomSize = !availableSizes.contains(_selectedSize);
          if (_isCustomSize) {
            _customSizeController.text = _selectedSize;
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!
                .addItem_error_loadingData(e.toString()))));
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

  // --- Image Picker Logic ---
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .addItem_error_pickingImage(e.toString()))),
        );
      }
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title:
                  Text(AppLocalizations.of(context)!.addItem_button_takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(
                  AppLocalizations.of(context)!.addItem_button_chooseGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- QR Scanner Logic ---
  Future<void> _scanQRCode() async {
    // Navigate to unified QR Scanner Screen and wait for result
    final result = await context
        .push<String>('/qr-scanner', extra: {'returnResult': true});

    if (result != null && mounted) {
      final code = result;
      // Assuming code matches a storage location ID or Name
      // In a real app, verify ID exists in _locations
      final location = _locations.firstWhere(
        (l) => l.id == code || l.name == code,
        orElse: () => StorageLocation(
            id: '', familyId: '', name: '', type: '', description: ''),
      );

      if (location.id.isNotEmpty) {
        setState(() {
          _storageLocationId = location.id;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .addItem_location_found(location.name))),
        );
      } else {
        // Optional: Handle unknown code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .addItem_location_unknown(code))),
        );
      }
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;
    // ... (Validation logic)
    if (_storageLocationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context)!.addItem_validation_selectStorage)));
      return;
    }
    if (!_isCustomSize && _selectedSize.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context)!.addItem_validation_selectSize)));
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Get all services/repositories before async operations
      final authService = context.read<AuthService>();
      final storageService = context.read<StorageService>();
      final itemRepository = context.read<ItemRepository>();

      final familyId = await authService.getCurrentUserFamilyId();
      if (familyId == null) throw Exception('User not authenticated');

      final userId = authService.currentUser?.uid;
      if (userId == null) throw Exception('No user logged in');

      // Generate item ID first (needed for storage path)
      final itemId = widget.item?.id ?? const Uuid().v4();

      // Upload newly selected images with thumbnails
      final List<Map<String, String>> newPhotoMaps = [];
      for (final XFile imageFile in _selectedImages) {
        final file = File(imageFile.path);
        final photoUrls = await storageService.uploadImageWithThumbnail(
          file: file,
          userId: userId,
          itemId: itemId,
        );
        newPhotoMaps.add(photoUrls);
      }

      // Combine existing photos with new ones
      final allPhotos = [..._existingPhotos, ...newPhotoMaps];

      final item = Item(
        id: itemId,
        familyId: familyId,
        title: _titleController.text.trim(),
        category: _selectedCategory,
        gender: _selectedGender,
        size: _isCustomSize ? _customSizeController.text.trim() : _selectedSize,
        seasonTags: _selectedSeasons.toList(),
        storageLocationId: _storageLocationId!,
        memberId: _assignedChildId,
        quantity: _quantity,
        notes: _descriptionController.text.trim(),
        addedAt: widget.item?.addedAt ?? DateTime.now(),
        status: 'Stored',
        photos: allPhotos,
      );

      if (widget.item != null) {
        await itemRepository.updateItem(item);
      } else {
        await itemRepository.addItem(item);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.item != null
                  ? 'Item updated successfully'
                  : 'Item added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!
                .addItem_error_saving(e.toString()))));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text(
              'Are you sure you want to delete this item? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() => _isSaving = true);
      try {
        await context.read<ItemRepository>().deleteItem(
              widget.item!.familyId,
              widget.item!.id,
            );
        if (mounted) {
          context.pop(); // Pop dialog or screen? Pop screen.
          // Wait, context.pop() here pops the screen because dialog is already popped by Navigator.of(context).pop(true)
          // Actually, if I use the return value 'confirmed', the dialog is already closed.
          // So I just need to close the AddItemScreen.
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting item: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SeasonBoxAppBar(
        title: widget.item != null ? 'Edit Item' : 'Add New Item',
        actions: widget.item != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _confirmDelete,
                ),
              ]
            : null,
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : !_isTransitionComplete
              ? _buildLoadingSkeleton()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Photos Section
                        Text(
                            AppLocalizations.of(context)!
                                .addItem_section_photos,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 1 +
                                _existingPhotos.length +
                                _selectedImages.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // Add Photo Button
                                return Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: theme.colorScheme.primary,
                                        width: 1.5),
                                  ),
                                  child: InkWell(
                                    onTap: _showImagePickerModal,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.camera_alt,
                                            color: theme.colorScheme.primary,
                                            size: 32),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Add Photo',
                                          style: TextStyle(
                                              color: theme.colorScheme.primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (index <= _existingPhotos.length) {
                                // Display Existing Photo (from Firestore)
                                final photoIndex = index - 1;
                                final photoMap = _existingPhotos[photoIndex];
                                return GestureDetector(
                                  onTap: () {
                                    // Extract all image URLs
                                    final imageUrls = <String>[];
                                    for (final photo in _existingPhotos) {
                                      final url =
                                          photo['full'] ?? photo['thumb'] ?? '';
                                      if (url.isNotEmpty) {
                                        imageUrls.add(url);
                                      }
                                    }

                                    // Open gallery viewer
                                    if (imageUrls.isNotEmpty) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ImageGalleryViewer(
                                            imageUrls: imageUrls,
                                            initialIndex: photoIndex,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: NetworkImage(photoMap['thumb'] ??
                                            photoMap['full'] ??
                                            ''),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _existingPhotos
                                                    .removeAt(photoIndex);
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.close,
                                                  color: Colors.white,
                                                  size: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                // Display Newly Selected Image
                                final imageIndex =
                                    index - 1 - _existingPhotos.length;
                                final image = _selectedImages[imageIndex];
                                return Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: FileImage(File(image.path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedImages
                                                  .removeAt(imageIndex);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close,
                                                color: Colors.white, size: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Item Details Section
                        Text(
                            AppLocalizations.of(context)!
                                .addItem_section_itemDetails,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  AppLocalizations.of(context)!
                                      .addItem_field_itemName,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .addItem_field_itemNameHint,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                ),
                                validator: (value) => value?.isEmpty == true
                                    ? AppLocalizations.of(context)!
                                        .addItem_validation_required
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                  AppLocalizations.of(context)!
                                      .addItem_field_category,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedCategory,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                ),
                                items: _categories
                                    .map((c) => DropdownMenuItem(
                                        value: c,
                                        child:
                                            Text(_getCategoryName(context, c))))
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _selectedCategory = v!;
                                    _isCustomSize = false;
                                    _selectedSize = '';
                                    _customSizeController.clear();
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                  AppLocalizations.of(context)!
                                      .addItem_field_gender,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 8),
                              _buildGenderSelector(theme),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Size Section (Collapsed for brevity - assumes logic is preserved in rebuild)
                        const Text('Size',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  AppLocalizations.of(context)!
                                      .addItem_field_size,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ..._currentSizes.map((size) {
                                    return ChoiceChip(
                                      label: Text(size),
                                      selected: !_isCustomSize &&
                                          _selectedSize == size,
                                      onSelected: (selected) {
                                        if (selected) {
                                          setState(() {
                                            _isCustomSize = false;
                                            _selectedSize = size;
                                            _customSizeController.clear();
                                          });
                                        }
                                      },
                                    );
                                  }),
                                  ChoiceChip(
                                    label: Text(AppLocalizations.of(context)!
                                        .addItem_size_other),
                                    selected: _isCustomSize,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          _isCustomSize = true;
                                          _selectedSize = '';
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              if (_isCustomSize) ...[
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _customSizeController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Custom Size',
                                    hintText: AppLocalizations.of(context)!
                                        .addItem_field_customSizeHint,
                                    border: const OutlineInputBorder(),
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
                              Text(
                                  AppLocalizations.of(context)!
                                      .addItem_field_quantity,
                                  style: const TextStyle(fontSize: 14)),
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
                                    child: Text('$_quantity',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  IconButton.filled(
                                    onPressed: () =>
                                        setState(() => _quantity++),
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Seasons & Member
                        Text(
                            AppLocalizations.of(context)!
                                .addItem_section_seasonMember,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  AppLocalizations.of(context)!
                                      .addItem_field_seasons,
                                  style: const TextStyle(fontSize: 14)),
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
                                            color: isSelected
                                                ? Colors.white
                                                : color),
                                        const SizedBox(width: 4),
                                        Text(_getSeasonName(context, label)),
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
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                  AppLocalizations.of(context)!
                                      .addItem_field_assignedTo,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 8),
                              _isLoadingData
                                  ? const SkeletonContainer.rectangular(
                                      height: 48,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)))
                                  : DropdownButtonFormField<String>(
                                      key: ValueKey(_assignedChildId),
                                      initialValue: _assignedChildId,
                                      decoration: const InputDecoration(
                                        hintText: 'Select member',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                            value: null,
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .addItem_field_none)),
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

                        // Storage Location with QR
                        Text(
                            AppLocalizations.of(context)!
                                .addItem_section_storageLocation,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  AppLocalizations.of(context)!
                                      .addItem_section_storageLocation,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 8),
                              _isLoadingData
                                  ? const SkeletonContainer.rectangular(
                                      height: 48,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)))
                                  : DropdownButtonFormField<String>(
                                      initialValue: _locations.isEmpty
                                          ? null
                                          : _storageLocationId,
                                      decoration: const InputDecoration(
                                        hintText: 'Select location',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                      ),
                                      items: _locations.isEmpty
                                          ? null
                                          : _locations
                                              .map((l) => DropdownMenuItem(
                                                  value: l.id,
                                                  child: Text(l.name)))
                                              .toList(),
                                      onChanged: (v) => setState(
                                          () => _storageLocationId = v),
                                      validator: (v) => v == null
                                          ? 'Please select a location'
                                          : null,
                                    ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _scanQRCode,
                                  icon: const Icon(Icons.qr_code_scanner),
                                  label: Text(AppLocalizations.of(context)!
                                      .home_action_scanQR),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    backgroundColor:
                                        theme.brightness == Brightness.dark
                                            ? Colors.cyan.withValues(alpha: 0.1)
                                            : Colors.cyan.shade50,
                                    foregroundColor: Colors.cyan,
                                    side: BorderSide
                                        .none, // Or theme.colorScheme.outline
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Notes (Notes logic)
                        const Text('Notes (Optional)',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        AppCard(
                          child: TextFormField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText:
                                  'Add any additional notes about item...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Action Buttons (Save/Cancel)
                        // ... (Preserved Save button logic)
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF6366F1)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6)),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _saveItem,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                                widget.item != null
                                    ? 'Update Item'
                                    : 'Save Item',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade700),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                                AppLocalizations.of(context)!.common_cancel,
                                style: const TextStyle(
                                    color: Colors
                                        .white)), // Assuming dark theme button text needs white or dynamic
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
    );
  }

  // _buildLoadingSkeleton and _buildGenderSelector remain same or similar
  Widget _buildLoadingSkeleton() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photos Section
          SkeletonContainer.rectangular(
            width: 100,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          SizedBox(height: 8),
          SkeletonContainer.rectangular(
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          SizedBox(height: 24),

          // Item Details Section
          SkeletonContainer.rectangular(
            width: 120,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          SizedBox(height: 8),
          SkeletonContainer.rectangular(
            height: 200,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          SizedBox(height: 24),

          // Size Section
          SkeletonContainer.rectangular(
            width: 100,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          SizedBox(height: 8),
          SkeletonContainer.rectangular(
            height: 150,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          SizedBox(height: 24),

          // Season & Member Section
          SkeletonContainer.rectangular(
            width: 140,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          SizedBox(height: 8),
          SkeletonContainer.rectangular(
            height: 180,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          SizedBox(height: 24),

          // Storage Location Section
          SkeletonContainer.rectangular(
            width: 130,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          SizedBox(height: 8),
          SkeletonContainer.rectangular(
            height: 120,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector(ThemeData theme) {
    return Row(
      children: ['Boy', 'Girl', 'Unisex'].map((gender) {
        final isSelected = _selectedGender == gender;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _selectedGender = gender),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.grey.shade700),
                ),
                alignment: Alignment.center,
                child: Text(
                  _getGenderName(context, gender),
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade400,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
