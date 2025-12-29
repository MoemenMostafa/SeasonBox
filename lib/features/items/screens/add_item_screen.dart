import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/models/item.dart';
import 'package:seasonbox/data/models/storage_location.dart';
import 'package:seasonbox/data/repositories/family_member_repository.dart';
import 'package:seasonbox/data/repositories/family_repository.dart';
import 'package:seasonbox/data/repositories/item_repository.dart';
import 'package:seasonbox/data/repositories/storage_location_repository.dart';
import 'package:seasonbox/data/services/storage_service.dart';
import 'package:seasonbox/core/errors/app_exception.dart';
import 'package:seasonbox/data/services/subscription_service.dart';
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
import 'package:seasonbox/data/services/posthog_service.dart';
import 'package:seasonbox/core/enums/item_type.dart';
import 'package:seasonbox/widgets/loading/boxy_saving_indicator.dart';
import 'package:seasonbox/widgets/season_box_network_image.dart';

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
  final TextEditingController _locationController = TextEditingController();
  List<String> _allExistingTags = [];

  List<FamilyMember> _members = [];
  List<StorageLocation> _locations = [];
  bool _isLoadingData = true;
  bool _isTransitionComplete = false;
  bool _isSaving = false;
  bool _isDirty = false;
  bool _quickAddTriggered = false;
  final Map<String, Map<String, Uint8List>> _processedImages = {};
  final Map<String, bool> _processingStatus = {};
  Map<String, int> _locationDepths = {};

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

  ItemType _mapCategoryToItemType(String category) {
    switch (category.toLowerCase()) {
      case 'clothes':
        return ItemType.clothes;
      case 'shoes':
        return ItemType.shoes;
      case 'toys':
        return ItemType.toys;
      case 'gear':
        return ItemType.gear;
      case 'accessories':
        return ItemType.decoration;
      default:
        return ItemType.other;
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => _isDirty = true);
    _descriptionController.addListener(() => _isDirty = true);
    _brandController.addListener(() => _isDirty = true);
    _brandController.addListener(() => _isDirty = true);
    _tagController.addListener(() => _isDirty = true);
    _customSizeController.addListener(() => _isDirty = true);
    // Location controller doesn't need dirty listener as it's read-only
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
        _assignedChildId = widget.item!.ownerId;
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

          // Auto-trigger camera if quick add is enabled and it's a new item
          final userProfile = context.read<UserProfileProvider>();
          if (widget.item == null &&
              userProfile.quickAddItemEnabled &&
              !_quickAddTriggered) {
            _quickAddTriggered = true;
            _pickImage(ImageSource.camera);
          }
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

      final currentUid = authService.currentUid;
      final familyId = await authService.getCurrentUserFamilyId();

      if (familyId == null || currentUid == null) {
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
          _organizeLocations(locations);
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
              !PermissionService.isAdmin(currentUid, familyId, members)) {
            _assignedChildId = currentUid;
          }
        });

        if (_storageLocationId != null && _locations.isNotEmpty) {
          final loc = _locations.firstWhere((l) => l.id == _storageLocationId,
              orElse: () => StorageLocation(
                  id: '', familyId: '', name: '', type: '', description: ''));
          if (loc.id.isNotEmpty) {
            _locationController.text = loc.name;
          }
        }

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
      PostHogService.log('Error loading data in AddItemScreen: $e',
          level: LogLevel.error);
      if (mounted) {
        setState(() => _isLoadingData = false);
        String message = 'Error loading data. Please try again.';
        if (e is AppException) {
          message = e.message;
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  void _organizeLocations(List<StorageLocation> allLocations) {
    if (allLocations.isEmpty) {
      _locations = [];
      _locationDepths.clear();
      return;
    }

    final organized = <StorageLocation>[];
    _locationDepths.clear();

    // Group by parentId
    final childrenMap = <String?, List<StorageLocation>>{};
    for (var loc in allLocations) {
      final pid =
          loc.parentId == null || loc.parentId!.isEmpty ? null : loc.parentId;
      childrenMap.putIfAbsent(pid, () => []).add(loc);
    }

    // Sort each group alphabetically
    for (var key in childrenMap.keys) {
      childrenMap[key]!.sort((a, b) => a.name.compareTo(b.name));
    }

    // Recursive traversal
    void traverse(String? parentId, int depth) {
      final children = childrenMap[parentId];
      if (children != null) {
        for (var child in children) {
          organized.add(child);
          _locationDepths[child.id] = depth;
          traverse(child.id, depth + 1);
        }
      }
    }

    traverse(null, 0);
    _locations = organized;
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final filteredLocations = searchQuery.isEmpty
                ? _locations
                : _locations
                    .where((l) => l.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .common_search, // Assuming this key exists, or use 'Search'
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filteredLocations.length,
                        itemBuilder: (context, index) {
                          final location = filteredLocations[index];
                          // Only use indentation if NOT searching
                          final depth = searchQuery.isEmpty
                              ? (_locationDepths[location.id] ?? 0)
                              : 0;
                          final indent = depth * 16.0;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _storageLocationId = location.id;
                                _locationController.text = location.name;
                                _isDirty = true;
                              });
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 16.0 + indent,
                                right: 16.0,
                                top: 12.0,
                                bottom: 12.0,
                              ),
                              child: Row(
                                children: [
                                  if (depth > 0)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.subdirectory_arrow_right,
                                        size: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      location.name,
                                      style: TextStyle(
                                        fontWeight:
                                            _storageLocationId == location.id
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color: _storageLocationId == location.id
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : null,
                                      ),
                                    ),
                                  ),
                                  if (_storageLocationId == location.id)
                                    Icon(
                                      Icons.check,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
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
    _locationController.dispose();
    _customSizeController.dispose();
    super.dispose();
  }

  // --- Image Picker Logic ---
  Future<void> _pickImage(ImageSource source) async {
    final userProvider = context.read<UserProfileProvider>();
    final subscriptionService = context.read<SubscriptionService>();
    final appUser = userProvider.appUser;

    final currentPhotoCount = _existingPhotos.length + _selectedImages.length;
    final photoLimit =
        appUser != null ? subscriptionService.getPhotoLimit(appUser) : 1;

    if (currentPhotoCount >= photoLimit) {
      if (mounted) {
        _showImageLimitDialog(photoLimit);
      }
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null && mounted) {
        final imagePath = image.path;

        setState(() {
          _isDirty = true;
          _selectedImages.add(image);
          _processingStatus[imagePath] = true;
        });

        // Start compression in background
        final storageService = context.read<StorageService>();

        try {
          final compressed = await storageService.compressImage(image);
          final thumb = await storageService.generateThumbnail(image);

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
      PostHogService.log('Error picking image: $e', level: LogLevel.error);
      if (mounted) {
        String message = 'Error picking image. Please try again.';
        if (e is AppException) {
          message = e.message;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
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
          _locationController.text = location.name;
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

    final userProvider = context.read<UserProfileProvider>();
    final authService = context.read<AuthService>();
    final familyRepo = context.read<FamilyRepository>();

    // Check item count limit for new items
    if (widget.item == null) {
      final familyId = await authService.getCurrentUserFamilyId();
      if (familyId != null) {
        final family = await familyRepo.getFamily(familyId);
        if (family != null) {
          final subscriptionService = context.read<SubscriptionService>();
          final appUser = userProvider.appUser;
          if (appUser != null &&
              !subscriptionService.canAddItem(appUser, family)) {
            if (mounted) {
              _showUpgradeDialog();
            }
            return;
          }
        }
      }
    }
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

      final currentUid = authService.currentUid;
      if (currentUid == null) throw Exception('No user logged in');

      // Generate item ID first (needed for storage path)
      final itemId = widget.item?.id ?? const Uuid().v4();

      // Upload newly selected images using pre-processed ones if available
      final List<Map<String, String>> newPhotoMaps = [];
      for (final XFile imageFile in _selectedImages) {
        Map<String, String> photoUrls;

        if (authService.isDemoMode) {
          // Mock upload for demo mode
          // Use a random existing demo image or a placeholder
          photoUrls = {
            'full': 'assets/images/demo/winter_jacket.png', // Placeholder
            'thumb': 'assets/images/demo/winter_jacket.png',
          };
        } else {
          final processed = _processedImages[imageFile.path];
          if (processed != null) {
            photoUrls = await storageService.uploadPreProcessedData(
              fullData: processed['full']!,
              thumbData: processed['thumb']!,
              userId: currentUid,
              itemId: itemId,
            );
          } else {
            // Fallback if not processed yet
            photoUrls = await storageService.uploadImageWithThumbnail(
              file: imageFile,
              userId: currentUid,
              itemId: itemId,
            );
          }
        }
        newPhotoMaps.add(photoUrls);
      }

      // Combine existing photos with new ones
      final allPhotos = [..._existingPhotos, ...newPhotoMaps];

      final sizeString =
          _isCustomSize ? _customSizeController.text.trim() : _selectedSize;

      // Parse size range if numeric
      Map<String, num>? parsedSizeRange;
      final numberRegex = RegExp(r'(\d+([\.,]\d+)?)');
      final matches = numberRegex.allMatches(sizeString).toList();
      if (matches.isNotEmpty) {
        if (matches.length == 1) {
          final val =
              double.tryParse(matches[0].group(0)!.replaceAll(',', '.')) ?? 0.0;
          parsedSizeRange = {'min': val, 'max': val};
        } else {
          final val1 =
              double.tryParse(matches[0].group(0)!.replaceAll(',', '.')) ?? 0.0;
          final val2 =
              double.tryParse(matches[1].group(0)!.replaceAll(',', '.')) ?? 0.0;
          parsedSizeRange = {
            'min': val1 < val2 ? val1 : val2,
            'max': val1 < val2 ? val2 : val1,
          };
        }
      }

      final item = Item(
        id: itemId,
        familyId: familyId,
        title: _titleController.text.trim(),
        category: _selectedCategory,
        gender: _selectedGender,
        size: sizeString,
        sizeRange: parsedSizeRange,
        seasonTags: _selectedSeasons.toList(),
        tags: _tags,
        storageLocationId: _storageLocationId!,
        ownerId: _assignedChildId,
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
      PostHogService.log('Error saving item: $e', level: LogLevel.error);
      if (mounted) {
        String message =
            'Error saving item. Please check your connection or permissions.';
        if (e is AppException) {
          message = e.message;
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showImageLimitDialog(int limit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            AppLocalizations.of(context)!.addItem_images_limitReached_title),
        content: Text(AppLocalizations.of(context)!
            .addItem_images_limitReached_message(limit)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.common_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/subscription?source=image_limit');
            },
            child:
                Text(AppLocalizations.of(context)!.home_premium_banner_button),
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Item Limit Reached'),
        content: const Text(
            'You have reached the limit of 50 items for the free tier. Upgrade to Paid for unlimited items!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/subscription?source=item_limit');
            },
            child: const Text('View Plans'),
          ),
        ],
      ),
    );
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
        PostHogService.log('Error deleting item: $e', level: LogLevel.error);
        if (mounted) {
          setState(() => _isSaving = false);
          String message = 'Error deleting item. Please try again.';
          if (e is AppException) {
            message = e.message;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop && _isDirty && !_isSaving) {
          PostHogService.log('ui_abandonment', level: LogLevel.info, context: {
            'screen': 'AddItemScreen',
            'title_length': _titleController.text.length,
            'has_images': _selectedImages.isNotEmpty,
          });
        }
      },
      child: Scaffold(
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
            ? Center(
                child: BoxySavingIndicator(
                  itemType: _mapCategoryToItemType(_selectedCategory),
                  size: 200,
                ),
              )
            : !_isTransitionComplete
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
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
                                                color:
                                                    theme.colorScheme.primary,
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
                                        final url = photo['full'] ??
                                            photo['thumb'] ??
                                            '';
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
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: SeasonBoxNetworkImage(
                                              imageUrl: photoMap['thumb'] ??
                                                  photoMap['full'] ??
                                                  '',
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
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
                                                padding:
                                                    const EdgeInsets.all(4),
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
                                                  color: Colors.white,
                                                  size: 16),
                                            ),
                                          ),
                                        ),
                                        if (_processingStatus[image.path] ==
                                            true)
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
                                                child:
                                                    CircularProgressIndicator(
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
                                          child: Text(
                                              _getCategoryName(context, c))))
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
                                        label: Text(
                                            AppLocalizations.of(context)!
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)))
                                    : DropdownButtonFormField<String>(
                                        key: ValueKey(_assignedChildId),
                                        // Ensure the initial value exists in the items list to prevent crashes
                                        initialValue: (_assignedChildId ==
                                                    null ||
                                                _members.any((m) =>
                                                    m.id == _assignedChildId))
                                            ? _assignedChildId
                                            : null,
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
                                          ..._members.map((m) =>
                                              DropdownMenuItem(
                                                  value: m.id,
                                                  child: Text(m.name))),
                                        ],
                                        onChanged: (v) => setState(
                                            () => _assignedChildId = v),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)))
                                    : TextFormField(
                                        controller: _locationController,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          hintText: 'Select location',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                          suffixIcon:
                                              Icon(Icons.arrow_drop_down),
                                        ),
                                        onTap: _showLocationPicker,
                                        validator: (v) =>
                                            _storageLocationId == null
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
                                      backgroundColor: theme.brightness ==
                                              Brightness.dark
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
                          Text(
                              AppLocalizations.of(context)!
                                  .addItem_section_tags,
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
                                side: BorderSide(color: theme.dividerColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.common_cancel,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  // _buildLoadingSkeleton and _buildGenderSelector remain same or similar

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
