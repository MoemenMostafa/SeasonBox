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

import 'package:seasonbox/widgets/image_gallery_viewer.dart';
import 'package:seasonbox/core/services/permission_service.dart';
import 'package:seasonbox/data/services/posthog_service.dart';
import 'package:seasonbox/core/enums/gender.dart';
import 'package:seasonbox/app/providers/user_profile_provider.dart';

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
  String? _selectedCategory;
  String? _selectedMemberId;
  String? _selectedStorageLocationId;
  Gender? _selectedGender;
  String? _selectedStatus; // 'In Use', 'Stored'
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMemberId = widget.initialMemberId;
    _selectedStorageLocationId = widget.initialStorageLocationId;
    _loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    try {
      final authService = context.read<AuthService>();
      final itemRepository = context.read<ItemRepository>();
      final locationRepository = context.read<StorageLocationRepository>();
      final memberRepository = context.read<FamilyMemberRepository>();

      String? familyId = await authService.getCurrentUserFamilyId();
      final userId = authService.currentUser?.uid;

      if (familyId == null || userId == null) {
        throw Exception('User not authenticated');
      }

      if (!mounted) return;

      // 1. Fetch Family Members first to check role
      List<FamilyMember> members;
      try {
        members = await memberRepository.getFamilyMembers(familyId);
      } catch (e) {
        // Fallback: If permission denied (likely data inconsistent), switch to personal family
        PostHogService.log('Error fetching members for $familyId: $e',
            level: LogLevel.error);
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
          members = await memberRepository.getFamilyMembers(familyId);
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
          gender: Gender.unisex,
        ),
      );

      final isRestrictedMember = currentUserMember.role == 'member';

      // 3. Load items (filtered if member) and locations in parallel
      final results = await Future.wait([
        itemRepository.getItems(
          familyId,
          ownerId: isRestrictedMember ? userId : null,
        ),
        locationRepository.getLocations(familyId),
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
    final query = _searchController.text.toLowerCase().trim();
    final userProfile = context.read<UserProfileProvider>();
    final statusTrackingEnabled = userProfile.statusTrackingEnabled;

    return _items.where((item) {
      bool matchesMemberFilter =
          _selectedMemberId == null || item.ownerId == _selectedMemberId;

      // Storage location filter
      bool matchesStorageFilter = _selectedStorageLocationId == null ||
          item.storageLocationId == _selectedStorageLocationId;

      // Gender filter
      bool matchesGenderFilter =
          _selectedGender == null || item.gender == _selectedGender;

      // Status filter (only if enabled)
      bool matchesStatusFilter = true;
      if (statusTrackingEnabled && _selectedStatus != null) {
        matchesStatusFilter =
            item.status.toLowerCase() == _selectedStatus!.toLowerCase();
      }

      // Category filter
      bool matchesCategoryFilter = _selectedCategory == null ||
          item.category.toLowerCase() == _selectedCategory!.toLowerCase();

      // Search filter (title, category, tags, size)
      bool matchesSearch = query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.tags.any((tag) => tag.toLowerCase().contains(query)) ||
          _isSizeMatch(item, query);

      return matchesMemberFilter &&
          matchesStorageFilter &&
          matchesGenderFilter &&
          matchesStatusFilter &&
          matchesCategoryFilter &&
          matchesSearch;
    }).toList();
  }

  bool _isSizeMatch(Item item, String query) {
    if (query.isEmpty) return false;

    final lowerQuery = query.toLowerCase();

    // 1. Exact or partial string match on item.size (e.g., "M", "92", "EU 92")
    if (item.size.toLowerCase().contains(lowerQuery)) return true;

    // 2. Parse query for numeric values/ranges
    final numberRegex = RegExp(r'(\d+([\.,]\d+)?)');
    final queryMatches = numberRegex.allMatches(query).toList();

    if (queryMatches.isNotEmpty) {
      // Get item's numeric range
      double itemMin;
      double itemMax;

      if (item.sizeRange != null) {
        itemMin = (item.sizeRange!['min'] ?? 0.0).toDouble();
        itemMax = (item.sizeRange!['max'] ?? 0.0).toDouble();
      } else {
        // Try to extract numbers from item.size if sizeRange is missing
        final itemMatches = numberRegex.allMatches(item.size).toList();
        if (itemMatches.isEmpty) return false; // No numbers in item size

        if (itemMatches.length == 1) {
          itemMin = itemMax =
              double.tryParse(itemMatches[0].group(0)!.replaceAll(',', '.')) ??
                  -1.0;
        } else {
          itemMin =
              double.tryParse(itemMatches[0].group(0)!.replaceAll(',', '.')) ??
                  -1.0;
          itemMax =
              double.tryParse(itemMatches[1].group(0)!.replaceAll(',', '.')) ??
                  -1.0;
        }
      }

      if (itemMin == -1.0) return false;

      // Handle query
      if (queryMatches.length == 1) {
        // Single number query: check if it fits in item's range
        final qNum =
            double.tryParse(queryMatches[0].group(0)!.replaceAll(',', '.')) ??
                -1.0;
        return qNum >= itemMin && qNum <= itemMax;
      } else {
        // Range query: check for overlap
        final qMin =
            double.tryParse(queryMatches[0].group(0)!.replaceAll(',', '.')) ??
                -1.0;
        final qMax =
            double.tryParse(queryMatches[1].group(0)!.replaceAll(',', '.')) ??
                -1.0;

        if (qMin == -1.0 || qMax == -1.0) return false;

        // Overlap if: max(min1, min2) <= min(max1, max2)
        final overlapMin = qMin > itemMin ? qMin : itemMin;
        final overlapMax = qMax < itemMax ? qMax : itemMax;
        return overlapMin <= overlapMax;
      }
    }

    return false;
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedMemberId = null;
      _selectedStorageLocationId = null;
      _selectedGender = null;
      _selectedStatus = null;
    });
  }

  Widget _buildFilterButton(ThemeData theme) {
    bool hasActiveFilters = _selectedCategory != null ||
        _selectedMemberId != null ||
        _selectedGender != null ||
        _selectedStatus != null;

    return GestureDetector(
      onTap: () => _showFilterBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hasActiveFilters
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: 20,
              color:
                  hasActiveFilters ? Colors.white : theme.colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              AppLocalizations.of(context)!.items_filter_title,
              style: TextStyle(
                color:
                    hasActiveFilters ? Colors.white : theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActiveFilterChips(BuildContext context) {
    final chips = <Widget>[];

    if (_selectedCategory != null) {
      chips.add(_buildActiveChip(context, _selectedCategory!, () {
        setState(() => _selectedCategory = null);
      }));
    }

    if (_selectedGender != null) {
      chips.add(_buildActiveChip(
          context, _selectedGender!.toDisplayString(context), () {
        setState(() => _selectedGender = null);
      }));
    }

    if (_selectedStatus != null) {
      chips.add(_buildActiveChip(context, _selectedStatus!, () {
        setState(() => _selectedStatus = null);
      }));
    }

    if (_selectedMemberId != null) {
      final member = _members.firstWhere((m) => m.id == _selectedMemberId,
          orElse: () => FamilyMember(
              id: '',
              familyId: '',
              name: 'Unknown',
              birthdate: DateTime.now(),
              gender: Gender.unisex));
      chips.add(_buildActiveChip(context, member.name, () {
        setState(() => _selectedMemberId = null);
      }));
    }

    return chips;
  }

  Widget _buildActiveChip(
      BuildContext context, String label, VoidCallback onDelete) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onDeleted: onDelete,
        deleteIcon: const Icon(Icons.close, size: 14),
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side:
            BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
        padding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);
            final l10n = AppLocalizations.of(context)!;
            final userProfile = context.read<UserProfileProvider>();

            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.items_filter_title,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              _clearAllFilters();
                              setModalState(() {});
                              Navigator.pop(context);
                            },
                            child: Text(l10n.items_clearAll),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Category
                      _buildFilterSection(
                        l10n.items_filter_category,
                        ['Clothes', 'Shoes', 'Accessories']
                            .map((cat) => FilterChip(
                                  label: Text(cat),
                                  selected: _selectedCategory == cat,
                                  onSelected: (val) {
                                    setState(() =>
                                        _selectedCategory = val ? cat : null);
                                    setModalState(() {});
                                  },
                                ))
                            .toList(),
                      ),

                      // Gender
                      _buildFilterSection(
                        l10n.items_filter_gender,
                        Gender.values
                            .map((g) => FilterChip(
                                  label: Text(g.toDisplayString(context)),
                                  selected: _selectedGender == g,
                                  onSelected: (val) {
                                    setState(
                                        () => _selectedGender = val ? g : null);
                                    setModalState(() {});
                                  },
                                ))
                            .toList(),
                      ),

                      // Status (if enabled)
                      if (userProfile.statusTrackingEnabled)
                        _buildFilterSection(
                          l10n.items_filter_status,
                          ['In Use', 'Stored']
                              .map((s) => FilterChip(
                                    label: Text(s),
                                    selected: _selectedStatus == s,
                                    onSelected: (val) {
                                      setState(() =>
                                          _selectedStatus = val ? s : null);
                                      setModalState(() {});
                                    },
                                  ))
                              .toList(),
                        ),

                      // Member
                      _buildFilterSection(
                        l10n.items_filter_member,
                        _members
                            .map((m) => FilterChip(
                                  label: Text(m.name),
                                  selected: _selectedMemberId == m.id,
                                  onSelected: (val) {
                                    setState(() =>
                                        _selectedMemberId = val ? m.id : null);
                                    setModalState(() {});
                                  },
                                ))
                            .toList(),
                      ),

                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection(String title, List<Widget> chips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: chips),
        const SizedBox(height: 24),
      ],
    );
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
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadItems,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: TextField(
                        controller: _searchController,
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.home_search_hint,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: theme.brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    // Filter Row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          _buildFilterButton(theme),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _buildActiveFilterChips(context),
                              ),
                            ),
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
                        final canDelete = PermissionService.canDeleteItem(
                          context.read<AuthService>().currentUser?.uid,
                          item,
                          context.read<AuthService>().currentUser?.uid,
                          _members,
                        );

                        return Dismissible(
                          key: Key(item.id),
                          direction: canDelete
                              ? DismissDirection.endToStart
                              : DismissDirection.none,
                          dismissThresholds: const {
                            DismissDirection.endToStart: 0.7,
                          },
                          background: canDelete
                              ? Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                          confirmDismiss: canDelete
                              ? (direction) async {
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
                                                Navigator.of(context)
                                                    .pop(false),
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
                                }
                              : null,
                          onDismissed: canDelete
                              ? (direction) async {
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Item deleted')),
                                      );
                                    }
                                  } catch (e) {
                                    // Revert if failed (requires reloading or manual insertion back, simplified to reload for now)
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to delete item: $e')),
                                      );
                                      _loadItems();
                                    }
                                  }
                                }
                              : null,
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
        heroTag: 'add_item_fab',
        onPressed: () {
          context.push(
            '/add-item',
            extra: {
              'initialStorageLocationId': _selectedStorageLocationId,
            },
          ).then((_) => _loadItems());
        },
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
    final member = item.ownerId != null
        ? _members.firstWhere(
            (m) => m.id == item.ownerId,
            orElse: () => FamilyMember(
              id: '',
              familyId: '',
              name: 'Unknown',
              birthdate: DateTime.now(),
              gender: Gender.unisex,
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
                        if (context
                            .read<UserProfileProvider>()
                            .statusTrackingEnabled)
                          _buildQuickStatusToggle(item),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.items_sizeLabel(
                          item.size, item.gender.toDisplayString(context)),
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
                    if (item.tags.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: item.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '#$tag',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
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
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuickStatusToggle(Item item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isStored = item.status.toLowerCase() == 'stored';

    return GestureDetector(
      onTap: () async {
        final newStatus = isStored ? 'In Use' : 'Stored';
        final updatedItem = item.copyWith(
          status: newStatus,
          lastUsedAt: newStatus == 'In Use' ? DateTime.now() : item.lastUsedAt,
        );

        try {
          await context.read<ItemRepository>().updateItem(updatedItem);
          setState(() {
            final index = _items.indexWhere((i) => i.id == item.id);
            if (index != -1) {
              _items[index] = updatedItem;
            }
          });
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update status: $e')),
            );
          }
        }
      },
      child: _buildStatusChip(item.status, isDark),
    );
  }
}
