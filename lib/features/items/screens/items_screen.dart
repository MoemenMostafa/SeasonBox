import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/data/models/item.dart';
import 'package:myapp/data/repositories/item_repository.dart';
import 'package:myapp/widgets/season_box_app_bar.dart';
import 'package:myapp/widgets/app_card.dart';
import 'package:myapp/widgets/season_box_add_button.dart';
import 'package:myapp/widgets/skeleton_container.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Item> _items = [];
  bool _isLoading = true;
  String _selectedFilter = 'All Items';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      const familyId = 'test-family-id';
      final items = await context
          .read<ItemRepository>()
          .getItems(familyId)
          .timeout(const Duration(seconds: 5));
      if (mounted) {
        setState(() {
          _items = items;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SeasonBoxAppBar(
        title: 'Items',
        subtitle: '${_items.length} total items',
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
                        _buildFilterChip('All Items'),
                        _buildFilterChip('In Use'),
                        _buildFilterChip('Stored'),
                        _buildFilterChip('Winter'),
                        _buildFilterChip('Summer'),
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
                              onPressed: () {},
                              child: const Text('Clear All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildQuickFilterCard(
                                'Clothes', Icons.checkroom, theme),
                            const SizedBox(width: 12),
                            _buildQuickFilterCard(
                                'Shoes', Icons.do_not_step, theme),
                            const SizedBox(width: 12),
                            _buildQuickFilterCard(
                                'Accessories', Icons.style, theme),
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
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
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

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        backgroundColor: Theme.of(context).cardColor,
        selectedColor: const Color(0xFF6200EE),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildQuickFilterCard(String title, IconData icon, ThemeData theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(Item item, ThemeData theme, bool isDark) {
    return AppCard(
      onTap: () {
        // TODO: Navigate to item detail
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
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  image: item.photos.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(item.photos.first),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: item.photos.isEmpty
                    ? Icon(Icons.image, color: Colors.grey.shade400)
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
                        _buildStatusChip(item.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Size ${item.size} • ${item.gender}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.seasonTags.join(', '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
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
              Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage:
                        AssetImage('assets/images/placeholder_child.png'),
                    // Fallback if asset missing
                    backgroundColor: Colors.purple,
                    child: Text('E',
                        style: TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Emma', // Placeholder
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    'Box A3', // Placeholder
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
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

  Widget _buildStatusChip(String status) {
    Color color;
    Color textColor;
    String label = status;

    switch (status.toLowerCase()) {
      case 'in use':
        color = Colors.green.shade100;
        textColor = Colors.green.shade800;
        label = 'In Use';
        break;
      case 'stored':
        color = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        label = 'Stored';
        break;
      case 'outgrown':
        color = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        label = 'Outgrown';
        break;
      default:
        color = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
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
