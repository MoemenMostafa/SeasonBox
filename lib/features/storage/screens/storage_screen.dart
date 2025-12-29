import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/models/storage_location.dart';
import '../../../data/models/item.dart';
import '../../../data/models/family_member.dart';
import '../../../data/repositories/storage_location_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/family_member_repository.dart';
import '../../../features/auth/data/auth_service.dart';
import '../../../widgets/season_box_app_bar.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/season_box_add_button.dart';
import '../../../widgets/season_box_filter_chip.dart';
import '../../../widgets/skeleton_container.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import '../../../core/services/permission_service.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  List<StorageLocation> _locations = [];
  List<Item> _items = [];
  List<FamilyMember> _members = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String? _currentUserId;
  String? _familyId;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    try {
      final authService = context.read<AuthService>();
      final familyId = await authService.getCurrentUserFamilyId();
      final currentUid = authService.currentUid;

      if (familyId == null || currentUid == null) {
        throw Exception('User not authenticated');
      }

      // Load locations, items, and members in parallel
      if (mounted) {
        final results = await Future.wait([
          context.read<StorageLocationRepository>().getLocations(familyId),
          context.read<ItemRepository>().getItems(familyId),
          context.read<FamilyMemberRepository>().getFamilyMembers(familyId),
        ]).timeout(const Duration(seconds: 5));

        setState(() {
          _currentUserId = currentUid;
          _familyId = familyId;
          _locations = results[0] as List<StorageLocation>;
          _items = results[1] as List<Item>;
          _members = results[2] as List<FamilyMember>;
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
                  .storage_error_loading(e.toString()))),
        );
      }
    }
  }

  int _getItemCountForLocation(String locationId) {
    return _items.where((item) => item.storageLocationId == locationId).length;
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'box':
        return Icons.inventory_2;
      case 'closet':
        return Icons.door_sliding;
      case 'area':
        return Icons.garage;
      case 'shelf':
        return Icons.shelves;
      default:
        return Icons.storage;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'box':
        return Colors.blue;
      case 'closet':
        return Colors.green;
      case 'area':
        return Colors.purple;
      case 'shelf':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SeasonBoxAppBar(
        title: AppLocalizations.of(context)!.storage_title,
        subtitle: AppLocalizations.of(context)!
            .storage_subtitle(_locations.length, _items.length),
        actions: null,
      ),
      body: _isLoading
          ? _buildLoadingSkeleton()
          : RefreshIndicator(
              onRefresh: _loadLocations,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStats(theme),
                        _buildSearchAndFilter(theme, isDark),
                      ],
                    ),
                  ),
                  _buildStorageList(theme, isDark),
                  SliverToBoxAdapter(
                    child: _buildQuickActions(theme),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                ],
              ),
            ),
      floatingActionButton: PermissionService.canManageStorage(
        _currentUserId,
        _familyId,
        _members,
      )
          ? SeasonBoxAddButton(
              heroTag: 'add_storage_fab',
              onPressed: () {
                if (context.read<AuthService>().isDemoMode) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not available in Demo Mode')),
                  );
                  return;
                }
                context
                    .push('/add-storage-location')
                    .then((_) => _loadLocations());
              },
            )
          : null,
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats Skeleton
        Row(
          children: List.generate(
              3, // Changed from 2 to 3 to match the 3 stat items
              (index) => Expanded(
                    child: SkeletonContainer.rectangular(
                      height: 100,
                      margin: EdgeInsets.only(
                          right: index == 2 ? 0 : 12), // Adjusted margin
                      borderRadius: BorderRadius.circular(16),
                    ),
                  )),
        ),
        const SizedBox(height: 24),

        // Search Bar Skeleton
        const SkeletonContainer.rectangular(
          height: 50,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        const SizedBox(height: 24),

        // List Header Skeleton
        const SkeletonContainer.rectangular(
          width: 150,
          height: 24,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        const SizedBox(height: 16),

        // List Items Skeleton
        ...List.generate(
          3,
          (index) => SkeletonContainer.rectangular(
            height: 80,
            margin: const EdgeInsets.only(bottom: 12),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(ThemeData theme) {
    final boxCount =
        _locations.where((l) => l.type.toLowerCase() == 'box').length;
    final closetCount =
        _locations.where((l) => l.type.toLowerCase() == 'closet').length;
    final areaCount =
        _locations.where((l) => l.type.toLowerCase() == 'area').length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
                boxCount.toString(),
                AppLocalizations.of(context)!.storage_sectionBoxes,
                Icons.inventory_2,
                Colors.blue,
                theme),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatItem(
                closetCount.toString(),
                AppLocalizations.of(context)!.storage_sectionClosets,
                Icons.door_sliding,
                Colors.green,
                theme),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatItem(
                areaCount.toString(),
                AppLocalizations.of(context)!.storage_sectionAreas,
                Icons.garage,
                Colors.purple,
                theme),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String value, String label, IconData icon, Color color, ThemeData theme) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(ThemeData theme, bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchController,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.storage_searchHint,
              hintStyle: TextStyle(color: theme.hintColor),
              prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
              suffixIcon: (_searchController.text.isNotEmpty ||
                      _selectedFilter != 'All')
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _selectedFilter = 'All';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor:
                  isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SeasonBoxFilterChip(
                label: AppLocalizations.of(context)!.storage_filterAll,
                isSelected: _selectedFilter == 'All',
                onTap: () => setState(() => _selectedFilter = 'All'),
                count: _locations.length,
              ),
              const SizedBox(width: 8),
              SeasonBoxFilterChip(
                label: AppLocalizations.of(context)!.storage_filterBasement,
                isSelected: _selectedFilter == 'Basement',
                onTap: () => setState(() => _selectedFilter = 'Basement'),
                count:
                    _locations.where((l) => l.name.contains('Basement')).length,
              ),
              const SizedBox(width: 8),
              SeasonBoxFilterChip(
                label: AppLocalizations.of(context)!.storage_filterClosets,
                isSelected: _selectedFilter == 'Closets',
                onTap: () => setState(() => _selectedFilter = 'Closets'),
                count: _locations.where((l) => l.type == 'Closet').length,
              ),
              const SizedBox(width: 8),
              SeasonBoxFilterChip(
                label: AppLocalizations.of(context)!.storage_filterAttic,
                isSelected: _selectedFilter == 'Attic',
                onTap: () => setState(() => _selectedFilter = 'Attic'),
                count: _locations.where((l) => l.name.contains('Attic')).length,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStorageList(ThemeData theme, bool isDark) {
    // Hierarchy-aware filtering logic
    final searchQuery = _searchController.text.toLowerCase();
    final matchingIds = <String>{};
    final locationMap = {for (var l in _locations) l.id: l};
    final childrenMap = <String?, List<String>>{};
    for (var l in _locations) {
      childrenMap.putIfAbsent(l.parentId, () => []).add(l.id);
    }

    // 1. Find direct matches based on search and filters
    for (var l in _locations) {
      final matchesSearch = searchQuery.isEmpty ||
          l.name.toLowerCase().contains(searchQuery) ||
          l.description.toLowerCase().contains(searchQuery) ||
          l.type.toLowerCase().contains(searchQuery);

      bool matchesFilter = false;
      if (_selectedFilter == 'All') {
        matchesFilter = true;
      } else if (_selectedFilter == 'Closets') {
        matchesFilter = l.type.toLowerCase() == 'closet';
      } else if (_selectedFilter == 'Basement' || _selectedFilter == 'Attic') {
        final filterTerm = _selectedFilter.toLowerCase();
        final nameMatches = l.name.toLowerCase().contains(filterTerm);
        bool parentMatches = false;
        if (l.parentId != null) {
          final parent = locationMap[l.parentId];
          if (parent != null) {
            parentMatches = parent.name.toLowerCase().contains(filterTerm);
          }
        }
        matchesFilter = nameMatches || parentMatches;
      } else {
        matchesFilter =
            l.name.toLowerCase().contains(_selectedFilter.toLowerCase()) ||
                l.type.toLowerCase().contains(_selectedFilter.toLowerCase());
      }

      if (matchesSearch && matchesFilter) {
        matchingIds.add(l.id);
      }
    }

    // 2. Expand to include ancestors (to maintain path) and descendants (to show folder contents)
    final idsToShow = <String>{};

    void addWithAncestors(String id) {
      if (idsToShow.add(id)) {
        final parentId = locationMap[id]?.parentId;
        if (parentId != null) {
          addWithAncestors(parentId);
        }
      }
    }

    void addWithDescendants(String id) {
      if (idsToShow.add(id)) {
        final children = childrenMap[id] ?? [];
        for (var childId in children) {
          addWithDescendants(childId);
        }
      }
    }

    for (var id in matchingIds) {
      addWithAncestors(id);
      // When searching specifically or filtering, show the contents of the matching location
      if (searchQuery.isNotEmpty || _selectedFilter != 'All') {
        addWithDescendants(id);
      }
    }

    final filteredLocations =
        _locations.where((l) => idsToShow.contains(l.id)).toList();

    // Sort alphabetically by name
    filteredLocations
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    // Enhanced hierarchical grouping logic
    Map<String?, List<StorageLocation>> groupedLocations = {};
    for (var location in filteredLocations) {
      final parentId = location.parentId;
      // Crucial: if the parent isn't in filteredLocations (shouldn't happen with our logic,
      // but good for safety), treat it as top-level if we want to show it.
      // Actually, our addWithAncestors ensures parent is always there.
      if (!groupedLocations.containsKey(parentId)) {
        groupedLocations[parentId] = [];
      }
      groupedLocations[parentId]!.add(location);
    }

    // Top-level locations (no parent or parent not visible)
    final topLevelLocations = groupedLocations[null] ?? [];

    // Build sections
    List<Widget> sections = [];

    // Add top-level locations grouped by type or area
    final boxLocations =
        topLevelLocations.where((l) => l.type == 'Box').toList();
    final closetLocations =
        topLevelLocations.where((l) => l.type == 'Closet').toList();
    final areaLocations =
        topLevelLocations.where((l) => l.type == 'Area').toList();
    final otherLocations = topLevelLocations
        .where((l) => l.type != 'Box' && l.type != 'Closet' && l.type != 'Area')
        .toList();

    if (boxLocations.isNotEmpty) {
      sections.add(_buildSectionHeader(
          AppLocalizations.of(context)!.storage_sectionBoxes, theme));
      sections.addAll(boxLocations
          .map((l) => _buildLocationCard(l, theme, groupedLocations)));
    }

    if (closetLocations.isNotEmpty) {
      sections.add(_buildSectionHeader(
          AppLocalizations.of(context)!.storage_sectionClosets, theme));
      sections.addAll(closetLocations
          .map((l) => _buildLocationCard(l, theme, groupedLocations)));
    }

    if (areaLocations.isNotEmpty) {
      sections.add(_buildSectionHeader(
          AppLocalizations.of(context)!.storage_sectionAreas, theme));
      sections.addAll(areaLocations
          .map((l) => _buildLocationCard(l, theme, groupedLocations)));
    }

    if (otherLocations.isNotEmpty) {
      sections.add(_buildSectionHeader(
          AppLocalizations.of(context)!.storage_sectionOther, theme));
      sections.addAll(otherLocations
          .map((l) => _buildLocationCard(l, theme, groupedLocations)));
    }

    return SliverList(
      delegate: SliverChildListDelegate(sections),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLocationCard(StorageLocation location, ThemeData theme,
      Map<String?, List<StorageLocation>> groupedLocations) {
    final color = _getColorForType(location.type);
    final icon = _getIconForType(location.type);
    final childLocations = groupedLocations[location.id] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AppCard(
        onTap: PermissionService.canManageStorage(
          _currentUserId,
          _familyId,
          _members,
        )
            ? () {
                if (context.read<AuthService>().isDemoMode) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not available in Demo Mode')),
                  );
                  return;
                }
                context
                    .push('/add-storage-location', extra: location)
                    .then((_) => _loadLocations());
              }
            : null,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${location.type} \u2022 ${location.description.isNotEmpty ? location.description : AppLocalizations.of(context)!.storage_noDescription}',
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (PermissionService.canManageStorage(
                  _currentUserId,
                  _familyId,
                  _members,
                ))
                  IconButton(
                    icon: Icon(Icons.add_circle_outline,
                        size: 20, color: theme.colorScheme.primary),
                    onPressed: () {
                      if (context.read<AuthService>().isDemoMode) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Not available in Demo Mode')),
                        );
                        return;
                      }
                      context
                          .push('/add-storage-location', extra: location.id)
                          .then((_) => _loadLocations());
                    },
                    tooltip: 'Add sub-location',
                  ),
                if (childLocations.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.keyboard_arrow_down, size: 20),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 16,
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.storage_itemsCount(
                          _getItemCountForLocation(location.id)),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    context.push(
                      '/items',
                      extra: <String, dynamic>{
                        'initialStorageLocationId': location.id,
                      },
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      AppLocalizations.of(context)!.storage_viewItems,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Show child locations recursively
            if (childLocations.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              ...childLocations.map((child) =>
                  _buildChildLocationItem(child, theme, groupedLocations, 1)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChildLocationItem(
    StorageLocation child,
    ThemeData theme,
    Map<String?, List<StorageLocation>> groupedLocations,
    int level,
  ) {
    final subChildren = groupedLocations[child.id] ?? [];
    final canManage = PermissionService.canManageStorage(
      _currentUserId,
      _familyId,
      _members,
    );

    return Column(
      children: [
        InkWell(
          onTap: canManage
              ? () {
                  if (context.read<AuthService>().isDemoMode) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Not available in Demo Mode')),
                    );
                    return;
                  }
                  context
                      .push('/add-storage-location', extra: child)
                      .then((_) => _loadLocations());
                }
              : null,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0 * level, top: 12, bottom: 8),
            child: Row(
              children: [
                Icon(
                  _getIconForType(child.type),
                  size: 18,
                  color: _getColorForType(child.type),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${child.type} \u2022 ${AppLocalizations.of(context)!.storage_itemsCount(_getItemCountForLocation(child.id))}',
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.inventory_2_outlined,
                      size: 20,
                      color: theme.colorScheme.primary.withValues(alpha: 0.8)),
                  onPressed: () {
                    context.push(
                      '/items',
                      extra: <String, dynamic>{
                        'initialStorageLocationId': child.id,
                      },
                    );
                  },
                  tooltip: 'View items',
                ),
                if (canManage) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline,
                        size: 20,
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.8)),
                    onPressed: () {
                      if (context.read<AuthService>().isDemoMode) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Not available in Demo Mode')),
                        );
                        return;
                      }
                      context
                          .push('/add-storage-location', extra: child.id)
                          .then((_) => _loadLocations());
                    },
                    tooltip: 'Add sub-location',
                  ),
                ],
              ],
            ),
          ),
        ),
        if (subChildren.isNotEmpty)
          ...subChildren.map((subChild) => _buildChildLocationItem(
              subChild, theme, groupedLocations, level + 1)),
      ],
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.storage_quickActions,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  AppLocalizations.of(context)!.storage_scanQrCode,
                  Icons.qr_code_scanner,
                  Colors.purple,
                  theme,
                  onTap: () => context.push('/qr-scanner'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  AppLocalizations.of(context)!.storage_printLabels,
                  Icons.print,
                  Colors.teal,
                  theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, ThemeData theme,
      {VoidCallback? onTap}) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
