import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/data/models/item.dart';
import 'package:seasonbox/data/models/storage_location.dart';
import 'package:seasonbox/data/models/family_member.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/storage_location_repository.dart';
import '../../../data/repositories/family_member_repository.dart';
import '../../../features/auth/data/auth_service.dart';
import '../../../widgets/season_box_app_bar.dart';
import 'package:seasonbox/widgets/app_card.dart';
import 'package:seasonbox/widgets/season_box_add_button.dart';
import 'package:seasonbox/widgets/season_box_filter_chip.dart';
import 'package:seasonbox/widgets/skeleton_container.dart';

class ItemsScreen extends StatefulWidget {
  final String? initialMemberId;

  const ItemsScreen({super.key, this.initialMemberId});

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

  @override
  void initState() {
    super.initState();
    _selectedMemberId = widget.initialMemberId;
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final familyId =
          await context.read<AuthService>().getCurrentUserFamilyId();
      if (familyId == null) {
        throw Exception('User not authenticated');
      }

      if (!mounted) return;

      // Load items, storage locations, and family members in parallel
      final results = await Future.wait([
        context.read<ItemRepository>().getItems(familyId),
        context.read<StorageLocationRepository>().getLocations(familyId),
        context.read<FamilyMemberRepository>().getFamilyMembers(familyId),
      ]).timeout(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _items = results[0] as List<Item>;
          _locations = results[1] as List<StorageLocation>;
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
          SnackBar(content: Text('Error loading items: $e')),
        );
      }
    }
  }

  String _getFilteredTitle() {
    if (_selectedMemberId != null) {
      final member = _members.firstWhere(
        (m) => m.id == _selectedMemberId,
        orElse: () => FamilyMember(
          id: '',
          familyId: '',
          name: 'Unknown',
          birthdate: DateTime.now(),
          gender: 'Unisex',
        ),
      );
      return '${member.name}\'s Items';
    }
    return 'Items';
  }

  List<Item> get _filteredItems {
    return _items.where((item) {
      // Member filter
      bool matchesMemberFilter =
          _selectedMemberId == null || item.memberId == _selectedMemberId;

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
          matchesStatusFilter &&
          matchesCategoryFilter;
    }).toList();
  }

  void _clearAllFilters() {
    setState(() {
      _selectedFilter = 'All Items';
      _selectedCategory = null;
      _selectedMemberId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SeasonBoxAppBar(
        title: _getFilteredTitle(),
        subtitle: _selectedMemberId != null
            ? 'Filtered by member'
            : 'Manage your items',
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingSkeleton(theme)
          : SingleChildScrollView(
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
                          label: 'All Items',
                          isSelected: _selectedFilter == 'All Items',
                          onTap: () =>
                              setState(() => _selectedFilter = 'All Items'),
                        ),
                        SeasonBoxFilterChip(
                          label: 'In Use',
                          isSelected: _selectedFilter == 'In Use',
                          onTap: () =>
                              setState(() => _selectedFilter = 'In Use'),
                        ),
                        SeasonBoxFilterChip(
                          label: 'Stored',
                          isSelected: _selectedFilter == 'Stored',
                          onTap: () =>
                              setState(() => _selectedFilter = 'Stored'),
                        ),
                        SeasonBoxFilterChip(
                          label: 'Winter',
                          isSelected: _selectedFilter == 'Winter',
                          onTap: () =>
                              setState(() => _selectedFilter = 'Winter'),
                        ),
                        SeasonBoxFilterChip(
                          label: 'Summer',
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
                              'Quick Filters',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: _clearAllFilters,
                              child: const Text('Clear All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildQuickFilterCard(
                                'Clothes', Icons.checkroom, theme, 'Clothes'),
                            const SizedBox(width: 12),
                            _buildQuickFilterCard(
                                'Shoes', Icons.do_not_step, theme, 'Shoes'),
                            const SizedBox(width: 12),
                            _buildQuickFilterCard('Accessories', Icons.style,
                                theme, 'Accessories'),
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
                      return _buildItemCard(item, theme, isDark);
                    },
                  ),
                  const SizedBox(height: 80), // Space for FAB
                ],
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
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  image: item.photos.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(item.photos.first),
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
                      'Size ${item.size} • ${item.gender}',
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
                          : 'No season tags',
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
                  'Quantity: ${item.quantity}',
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
        label = 'In Use';
        break;
      case 'stored':
        color =
            isDark ? Colors.blue.withValues(alpha: 0.2) : Colors.blue.shade100;
        textColor = isDark ? Colors.blue.shade300 : Colors.blue.shade800;
        label = 'Stored';
        break;
      case 'outgrown':
        color = isDark
            ? Colors.orange.withValues(alpha: 0.2)
            : Colors.orange.shade100;
        textColor = isDark ? Colors.orange.shade300 : Colors.orange.shade800;
        label = 'Outgrown';
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
