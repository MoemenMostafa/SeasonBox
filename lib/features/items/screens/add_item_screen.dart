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
import 'package:seasonbox/core/constants/size_constants.dart';
import 'package:seasonbox/app/providers/user_profile_provider.dart';
import 'package:seasonbox/core/enums/gender.dart';

class AddItemScreen extends StatefulWidget {
  final Item? item; // Optional item for editing
  final String? initialStorageLocationId; // Pre-selected location

  const AddItemScreen({super.key, this.item, this.initialStorageLocationId});

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
  Gender _selectedGender = Gender.unisex;
  String _selectedSize = '10';
  int _quantity = 1;
  String? _assignedChildId;
  String? _storageLocationId;
  final Set<String> _selectedSeasons = {'Winter'}; // Default selection

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  List<Map<String, String>> _existingPhotos = []; // For edit mode
  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();
  List<String> _allExistingTags = [];

  List<FamilyMember> _members = [];
  List<StorageLocation> _locations = [];
  bool _isLoadingData = true;
  bool _isTransitionComplete = false;
  bool _isSaving = false;
  final Map<String, Map<String, File>> _processedImages = {};
  final Map<String, bool> _processingStatus = {};

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
  List<String> get _currentSizes {
    final isMetric = context.watch<UserProfileProvider>().isMetric;
    return _getSizesForCategory(_selectedCategory, isMetric: isMetric);
  }

  List<String> _getSizesForCategory(String category, {required bool isMetric}) {
    if (category == 'Clothes') {
      return isMetric
          ? SizeConstants.clothesSizesMetric
          : SizeConstants.clothesSizesImperial;
    }
    if (category == 'Shoes') {
      return isMetric
          ? SizeConstants.shoeSizesMetric
          : SizeConstants.shoeSizesImperial;
    }
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

  String _getGenderName(BuildContext context, Gender gender) {
    return gender.toDisplayString(context);
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
        _tags.addAll(widget.item!.tags);
        // Load existing photos for edit mode
        _existingPhotos = List<Map<String, String>>.from(widget.item!.photos);
      } else if (widget.initialStorageLocationId != null) {
        _storageLocationId = widget.initialStorageLocationId;
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
      final itemRepository = context.read<ItemRepository>();

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

      final items = await itemRepository
          .getItems(familyId)
          .timeout(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _members = members;
          _locations = locations;
          final tagCounts = <String, int>{};
          for (final item in items) {
            for (final tag in item.tags) {
              tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
            }
          }
          _allExistingTags = tagCounts.keys.toList()
            ..sort((a, b) => tagCounts[b]!.compareTo(tagCounts[a]!));
          _isLoadingData = false;

          // Auto-assign to current user if they're a member (not admin) and creating a new item
          if (widget.item == null &&
              !PermissionService.isAdmin(userId, familyId, members)) {
            _assignedChildId = userId;
          }
        });

        if (widget.item != null) {
          final isMetric = context.read<UserProfileProvider>().isMetric;
          final availableSizes =
              _getSizesForCategory(_selectedCategory, isMetric: isMetric);
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

  void _addTag(String tag) {
    final trimmedTag = tag.trim().toLowerCase();
    if (trimmedTag.isEmpty) return;
    if (_tags.contains(trimmedTag)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.addItem_tags_duplicate)),
      );
      return;
    }
    if (_tags.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.addItem_tags_limitReached)),
      );
      return;
    }
    setState(() {
      _tags.add(trimmedTag);
      _tagController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
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
      if (image != null && mounted) {
        final imageFile = File(image.path);
        final imagePath = image.path;

        setState(() {
          _selectedImages.add(image);
          _processingStatus[imagePath] = true;
        });

        // Start compression in background
        final storageService = context.read<StorageService>();

        try {
          final compressed = await storageService.compressImage(imageFile);
          final thumb = await storageService.generateThumbnail(imageFile);

          if (mounted) {
            setState(() {
              _processedImages[imagePath] = {
                'full': compressed,
                'thumb': thumb,
              };
              _processingStatus[imagePath] = false;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _processingStatus[imagePath] = false;
            });
          }
        }
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

  Future<void> _saveItem({bool stayOnScreen = false}) async {
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

      // Upload newly selected images using pre-processed ones if available
      final List<Map<String, String>> newPhotoMaps = [];
      for (final XFile imageFile in _selectedImages) {
        final processed = _processedImages[imageFile.path];
        Map<String, String> photoUrls;

        if (processed != null) {
          photoUrls = await storageService.uploadPreProcessedImage(
            fullFile: processed['full']!,
            thumbFile: processed['thumb']!,
            userId: userId,
            itemId: itemId,
          );
          // Clean up temp files
          await processed['full']!.delete();
          await processed['thumb']!.delete();
        } else {
          // Fallback if not processed yet
          photoUrls = await storageService.uploadImageWithThumbnail(
            file: File(imageFile.path),
            userId: userId,
            itemId: itemId,
          );
        }
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
        tags: _tags,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.item != null
                  ? 'Item updated successfully'
                  : 'Item added successfully')),
        );

        if (stayOnScreen) {
          _resetForm(keepDefaults: true);
        } else {
          context.pop();
        }
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

  void _resetForm({required bool keepDefaults}) {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _brandController.clear();
      _selectedImages.clear();
      _existingPhotos.clear();
      _processedImages.clear();
      _processingStatus.clear();
      _tags.clear();
      if (!keepDefaults) {
        _selectedCategory = 'Clothes';
        _selectedGender = Gender.unisex;
        _selectedSize = '10';
        _quantity = 1;
        _assignedChildId = null;
        _storageLocationId = null;
        _selectedSeasons.clear();
        _selectedSeasons.add('Winter');
        _isCustomSize = false;
        _customSizeController.clear();
      }
    });
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
        actions: [
          if (widget.item != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _confirmDelete,
              tooltip: 'Delete Item',
            ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () => _saveItem(stayOnScreen: false),
            tooltip: 'Save Item',
          ),
        ],
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
                                          onTap: () async {
                                            final path = image.path;
                                            final processed =
                                                _processedImages[path];
                                            if (processed != null) {
                                              await processed['full']?.delete();
                                              await processed['thumb']
                                                  ?.delete();
                                            }
                                            setState(() {
                                              _selectedImages
                                                  .removeAt(imageIndex);
                                              _processedImages.remove(path);
                                              _processingStatus.remove(path);
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
                                      if (_processingStatus[image.path] == true)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black26,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: const Center(
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
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
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing: 8,
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
                              ),
                              if (_isCustomSize) ...[
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _customSizeController,
                                  keyboardType: TextInputType.text,
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

                        // Tags Section
                        Text(AppLocalizations.of(context)!.addItem_section_tags,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  return _allExistingTags
                                      .where((String option) {
                                    return option.contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                },
                                onSelected: (String selection) {
                                  _addTag(selection);
                                },
                                fieldViewBuilder: (context, controller,
                                    focusNode, onFieldSubmitted) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .addItem_tags_hint,
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          _addTag(controller.text);
                                          controller.clear();
                                        },
                                      ),
                                    ),
                                    onSubmitted: (value) {
                                      _addTag(value);
                                      controller.clear();
                                    },
                                  );
                                },
                              ),
                              if (_tags.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _tags.map((tag) {
                                    return Chip(
                                      label: Text(tag),
                                      onDeleted: () => _removeTag(tag),
                                      deleteIcon:
                                          const Icon(Icons.close, size: 16),
                                      backgroundColor: theme
                                          .colorScheme.primaryContainer
                                          .withValues(alpha: 0.3),
                                      labelStyle: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontSize: 12),
                                      side: BorderSide.none,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    );
                                  }).toList(),
                                ),
                              ],
                              if (_allExistingTags.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(context)!
                                      .addItem_tags_mostUsed,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.hintColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _allExistingTags
                                      .take(10)
                                      .where((tag) => !_tags.contains(tag))
                                      .map((tag) {
                                    return InkWell(
                                      onTap: () => _addTag(tag),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: theme.dividerColor
                                              .withValues(alpha: 0.05),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: theme.dividerColor
                                                  .withValues(alpha: 0.1)),
                                        ),
                                        child: Text(
                                          tag,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
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
                            onPressed: () => _saveItem(stayOnScreen: false),
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
                        if (widget.item == null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFF6366F1), width: 2),
                            ),
                            child: OutlinedButton(
                              onPressed: () => _saveItem(stayOnScreen: true),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Save & Add Another',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6366F1))),
                            ),
                          ),
                        ],
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
      children: Gender.values.map((gender) {
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
