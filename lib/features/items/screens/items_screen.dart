import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/data/models/item.dart';
import 'package:seasonbox/data/models/storage_location.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/repositories/item_repository.dart';
import 'package:seasonbox/data/repositories/storage_location_repository.dart';
import 'package:seasonbox/data/repositories/family_member_repository.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:seasonbox/widgets/app_card.dart';
import 'package:seasonbox/widgets/season_box_add_button.dart';
import 'package:seasonbox/widgets/season_box_filter_chip.dart';
import 'package:seasonbox/widgets/skeleton_container.dart';
import 'package:seasonbox/widgets/image_gallery_viewer.dart';

class ItemsScreen extends StatefulWidget {
  final String? initialMemberId;
  final String? initialStorageLocationId;

  const ItemsScreen(
      {super.key, this.initialMemberId, this.initialStorageLocationId});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Item> _items = [];
  List<StorageLocation> _locations = [];
  List<FamilyMember> _members = [];
  bool _isLoading = true;
  String _selectedFilter = 'All Items';
  String? _selectedCategory;
  String? _selectedMemberId;
  String? _selectedStorageLocationId;

  @override
  void initState() {
    super.initState();
    _selectedMemberId = widget.initialMemberId;
    _selectedStorageLocationId = widget.initialStorageLocationId;
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final authService = context.read<AuthService>();
      String? familyId = await authService.getCurrentUserFamilyId();
      final userId = authService.currentUser?.uid;

      if (familyId == null || userId == null) {
        throw Exception('User not authenticated');
      }

      if (!mounted) return;

      // 1. Fetch Family Members first to check role
      List<FamilyMember> members;
      try {
        members = await context
            .read<FamilyMemberRepository>()
            .getFamilyMembers(familyId);
      } catch (e) {
        // Fallback: If permission denied (likely data inconsistent), switch to personal family
        debugPrint('Error fetching members for $familyId: $e');
        if (familyId != userId) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Access to family denied. Switching to personal workspace.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          familyId = userId; // Fallback to personal
          members = await context
              .read<FamilyMemberRepository>()
              .getFamilyMembers(familyId);
        } else {
          rethrow;
        }
      }

      // 2. Identify current user's role
      // Default to 'member' if not found (safe fallback)
      final currentUserMember = members.firstWhere(
        (m) => m.id == userId,
        orElse: () => FamilyMember(
          id: userId,
          familyId: familyId!,
          name: 'Me',
          role: familyId == userId ? 'admin' : 'member', // Owner is admin
          birthdate: DateTime.now(),
          gender: 'Unisex',
        ),
      );

      final isRestrictedMember = currentUserMember.role == 'member';

      // 3. Load items (filtered if member) and locations in parallel
      final results = await Future.wait([
        context.read<ItemRepository>().getItems(
              familyId,
              ownerId: isRestrictedMember ? userId : null,
            ),
        context.read<StorageLocationRepository>().getLocations(familyId),
      ]).timeout(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _members = members;
          _items = results[0] as List<Item>;
          _locations = results[1] as List<StorageLocation>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .home_error_loadingData(e.toString()))),
        );
      }
    }
  }

  List<Item> get _filteredItems {
    return _items.where((item) {
      // Member filter
      bool matchesMemberFilter =
          _selectedMemberId == null || item.memberId == _selectedMemberId;

      // Storage location filter
      bool matchesStorageFilter = _selectedStorageLocationId == null ||
          item.storageLocationId == _selectedStorageLocationId;

      // Status/Season filter
      bool matchesStatusFilter = _selectedFilter == 'All Items' ||
          (_selectedFilter == 'In Use' &&
              item.status.toLowerCase() == 'in use') ||
          (_selectedFilter == 'Stored' &&
              item.status.toLowerCase() == 'stored') ||
          (_selectedFilter == 'Winter' &&
              item.seasonTags
                  .any((tag) => tag.toLowerCase().contains('winter'))) ||
          (_selectedFilter == 'Summer' &&
              item.seasonTags
                  .any((tag) => tag.toLowerCase().contains('summer')));

      // Category filter
      bool matchesCategoryFilter = _selectedCategory == null ||
          item.category.toLowerCase() == _selectedCategory!.toLowerCase();

      return matchesMemberFilter &&
          matchesStorageFilter &&
          matchesStatusFilter &&
          matchesCategoryFilter;
    }).toList();
  }

  void _clearAllFilters() {
    setState(() {
      _selectedFilter = 'All Items';
      _selectedCategory = null;
      _selectedMemberId = null;
      _selectedStorageLocationId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Get storage location name if filtering by storage
    String subtitle = '${_filteredItems.length} total items';
    if (_selectedStorageLocationId != null) {
      final location = _locations.firstWhere(
        (l) => l.id == _selectedStorageLocationId,
        orElse: () => StorageLocation(
          id: '',
          familyId: '',
          name: 'Unknown',
          type: 'Box',
          description: '',
        ),
      );
      subtitle = '${location.name} • ${_filteredItems.length} items';
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SeasonBoxAppBar(
        title: AppLocalizations.of(context)!.items_title,
        subtitle: subtitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingSkeleton(theme)
          : RefreshIndicator(
              onRefresh: _loadItems,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          SeasonBoxFilterChip(
                            label: AppLocalizations.of(context)!
                                .items_filterAllItems,
                            isSelected: _selectedFilter == 'All Items',
                            onTap: () =>
                                setState(() => _selectedFilter = 'All Items'),
                          ),
                          SeasonBoxFilterChip(
                            label:
                                AppLocalizations.of(context)!.items_filterInUse,
                            isSelected: _selectedFilter == 'In Use',
                            onTap: () =>
                                setState(() => _selectedFilter = 'In Use'),
                          ),
                          SeasonBoxFilterChip(
                            label: AppLocalizations.of(context)!
                                .items_filterStored,
                            isSelected: _selectedFilter == 'Stored',
                            onTap: () =>
                                setState(() => _selectedFilter = 'Stored'),
                          ),
                          SeasonBoxFilterChip(
                            label: AppLocalizations.of(context)!
                                .items_filterWinter,
                            isSelected: _selectedFilter == 'Winter',
                            onTap: () =>
                                setState(() => _selectedFilter = 'Winter'),
                          ),
                          SeasonBoxFilterChip(
                            label: AppLocalizations.of(context)!
                                .items_filterSummer,
                            isSelected: _selectedFilter == 'Summer',
                            onTap: () =>
                                setState(() => _selectedFilter = 'Summer'),
                          ),
                        ],
                      ),
                    ),

                    // Quick Filters
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .items_quickFilters,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: _clearAllFilters,
                                child: Text(AppLocalizations.of(context)!
                                    .items_clearAll),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildQuickFilterCard(
                                  AppLocalizations.of(context)!
                                      .items_filterClothes,
                                  Icons.checkroom,
                                  theme,
                                  'Clothes'),
                              const SizedBox(width: 12),
                              _buildQuickFilterCard(
                                  AppLocalizations.of(context)!
                                      .items_filterShoes,
                                  Icons.do_not_step,
                                  theme,
                                  'Shoes'),
                              const SizedBox(width: 12),
                              _buildQuickFilterCard(
                                  AppLocalizations.of(context)!
                                      .items_filterAccessories,
                                  Icons.style,
                                  theme,
                                  'Accessories'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Items List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return Dismissible(
                          key: Key(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Item'),
                                  content: const Text(
                                      'Are you sure you want to delete this item? This action cannot be undone.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) async {
                            final itemRepository =
                                context.read<ItemRepository>();
                            // Optimistically remove from list
                            setState(() {
                              _items.removeWhere((i) => i.id == item.id);
                            });

                            try {
                              await itemRepository.deleteItem(
                                  item.familyId, item.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Item deleted')),
                                );
                              }
                            } catch (e) {
                              // Revert if failed (requires reloading or manual insertion back, simplified to reload for now)
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to delete item: $e')),
                                );
                                _loadItems();
                              }
                            }
                          },
                          child: _buildItemCard(item, theme, isDark),
                        );
                      },
                    ),
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),
      floatingActionButton: SeasonBoxAddButton(
        onPressed: () => context.push('/add-item').then((_) => _loadItems()),
      ),
    );
  }

  Widget _buildQuickFilterCard(
      String title, IconData icon, ThemeData theme, String category) {
    final isSelected = _selectedCategory == category;
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = isSelected ? null : category;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : (isDark ? const Color(0xFF334155) : theme.cardColor),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? theme.colorScheme.primary : Colors.transparent,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey.shade300 : Colors.grey.shade600),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(Item item, ThemeData theme, bool isDark) {
    // Find storage location
    final location = _locations.firstWhere(
      (l) => l.id == item.storageLocationId,
      orElse: () => StorageLocation(
        id: '',
        familyId: '',
        name: 'Unknown',
        type: 'Box',
        description: '',
      ),
    );

    // Find family member
    final member = item.memberId != null
        ? _members.firstWhere(
            (m) => m.id == item.memberId,
            orElse: () => FamilyMember(
              id: '',
              familyId: '',
              name: 'Unknown',
              birthdate: DateTime.now(),
              gender: 'Unisex',
            ),
          )
        : null;

    return AppCard(
      onTap: () {
        // Navigate to edit item screen
        context.push('/add-item', extra: item).then((_) => _loadItems());
      },
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              GestureDetector(
                onTap: () {
                  // Extract all image URLs from the item
                  final imageUrls = <String>[];

                  for (final photo in item.photos) {
                    final url = photo['full'] ?? photo['thumb'] ?? '';
                    if (url.isNotEmpty) {
                      imageUrls.add(url);
                    }
                  }

                  // Open gallery viewer
                  if (imageUrls.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryViewer(
                          imageUrls: imageUrls,
                          initialIndex: 0,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    image: item.photos.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(
                              item.photos.first['thumb'] ??
                                  item.photos.first['full'] ??
                                  '',
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: item.photos.isEmpty
                      ? Icon(Icons.image,
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade400)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusChip(item.status, isDark),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!
                          .items_sizeLabel(item.size, item.gender),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.seasonTags.isNotEmpty
                          ? item.seasonTags.join(', ')
                          : AppLocalizations.of(context)!.items_noSeasonTags,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // Menu
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.grey.shade400),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (member != null)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.purple,
                      child: Text(
                        member.name.isNotEmpty
                            ? member.name[0].toUpperCase()
                            : '?',
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      member.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  AppLocalizations.of(context)!.items_quantity(item.quantity),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    location.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isDark) {
    Color color;
    Color textColor;
    String label = status;

    switch (status.toLowerCase()) {
      case 'in use':
        color = isDark
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.green.shade100;
        textColor = isDark ? Colors.green.shade300 : Colors.green.shade800;
        label = AppLocalizations.of(context)!.items_statusInUse;
        break;
      case 'stored':
        color =
            isDark ? Colors.blue.withValues(alpha: 0.2) : Colors.blue.shade100;
        textColor = isDark ? Colors.blue.shade300 : Colors.blue.shade800;
        label = AppLocalizations.of(context)!.items_statusStored;
        break;
      case 'outgrown':
        color = isDark
            ? Colors.orange.withValues(alpha: 0.2)
            : Colors.orange.shade100;
        textColor = isDark ? Colors.orange.shade300 : Colors.orange.shade800;
        label = AppLocalizations.of(context)!.items_statusOutgrown;
        break;
      default:
        color =
            isDark ? Colors.grey.withValues(alpha: 0.2) : Colors.grey.shade200;
        textColor = isDark ? Colors.grey.shade400 : Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Filter Chips Skeleton
        Row(
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SkeletonContainer.rectangular(
                width: 80,
                height: 32,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Quick Filters Skeleton
        Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 2 ? 12 : 0),
                child: SkeletonContainer.rectangular(
                  height: 80,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Items Skeleton
        ...List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SkeletonContainer.rectangular(
              height: 140,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
