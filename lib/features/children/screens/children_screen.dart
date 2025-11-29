import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/models/child.dart';
import '../../../data/models/item.dart';
import '../../../data/repositories/child_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../widgets/season_box_app_bar.dart';
import '../../../widgets/season_box_add_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/skeleton_container.dart';

class ChildrenScreen extends StatefulWidget {
  const ChildrenScreen({super.key});

  @override
  State<ChildrenScreen> createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  List<Child> _children = [];
  List<Item> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      const familyId = 'test-family-id';

      final children = await context
          .read<ChildRepository>()
          .getChildren(familyId)
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;

      final items = await context
          .read<ItemRepository>()
          .getItems(familyId)
          .timeout(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _children = children;
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _children = [];
          _items = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  int _calculateAge(DateTime birthdate) {
    final now = DateTime.now();
    int age = now.year - birthdate.year;
    if (now.month < birthdate.month ||
        (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  Widget _buildChildCard(Child child, ThemeData theme) {
    final age = _calculateAge(child.birthdate);
    final isDark = theme.brightness == Brightness.dark;

    // Calculate actual item count for this child
    final itemCount = _items
        .where((item) => item.title
            .toLowerCase()
            .contains(child.name.toLowerCase().split(' ').first))
        .length;

    return AppCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.purple.shade100,
                child: Text(
                  child.name[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          child.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.pink.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$age years',
                            style: const TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Born: ${child.birthdate.toLocal().toString().split(' ')[0]}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Size',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7))),
                      const SizedBox(height: 4),
                      Text(
                          'Clothes: ${child.currentSizeByCategory['clothes']?.toStringAsFixed(0) ?? '-'}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'Shoes: ${child.currentSizeByCategory['shoes']?.toStringAsFixed(0) ?? '-'}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Items',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7))),
                      const SizedBox(height: 4),
                      Text('$itemCount',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: theme.colorScheme.primary)),
                      Text(itemCount > 0 ? '✓ Has items' : 'No items yet',
                          style: TextStyle(
                              color: itemCount > 0 ? Colors.green : Colors.grey,
                              fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('View Items'),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {}, // TODO: Edit child
                  icon: Icon(Icons.show_chart, color: theme.iconTheme.color),
                  tooltip: 'Growth Chart',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {}, // TODO: Edit child
                  icon: Icon(Icons.edit, color: theme.iconTheme.color),
                  tooltip: 'Edit',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SeasonBoxAppBar(
        title: 'Children',
        subtitle: 'Manage family members',
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingSkeleton(theme)
          : _children.isEmpty
              ? const Center(
                  child: Text('No children added yet'),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                              '${_children.length}', 'Children', theme),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                              '${_items.length}', 'Total Items', theme,
                              color: Colors.teal),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard('0', 'Need Check', theme,
                              color: Colors.orange),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Family Members',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.filter_list,
                              size: 18, color: theme.colorScheme.primary),
                          label: Text(
                            'Filter',
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Children List
                    ..._children.map((child) => _buildChildCard(child, theme)),
                  ],
                ),
      floatingActionButton: SeasonBoxAddButton(
        onPressed: () =>
            context.push('/add-child').then((_) => _loadChildren()),
      ),
    );
  }

  Widget _buildLoadingSkeleton(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Cards Skeleton
        Row(
          children: List.generate(
              3,
              (index) => Expanded(
                    child: SkeletonContainer.rectangular(
                      height: 80,
                      margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  )),
        ),
        const SizedBox(height: 24),

        // Header Skeleton
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkeletonContainer.rectangular(
              width: 150,
              height: 24,
              borderRadius: BorderRadius.circular(4),
            ),
            SkeletonContainer.rectangular(
              width: 60,
              height: 24,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Children List Skeleton
        ...List.generate(
          2,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    SkeletonContainer.square(
                      size: 60,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonContainer.rectangular(
                            width: 120,
                            height: 20,
                          ),
                          SizedBox(height: 8),
                          SkeletonContainer.rectangular(
                            width: 80,
                            height: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: SkeletonContainer.rectangular(
                            height: 60,
                            borderRadius: BorderRadius.circular(12))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: SkeletonContainer.rectangular(
                            height: 60,
                            borderRadius: BorderRadius.circular(12))),
                  ],
                ),
                const SizedBox(height: 16),
                SkeletonContainer.rectangular(
                  height: 48,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String value, String label, ThemeData theme,
      {Color? color}) {
    final displayColor = color ?? theme.colorScheme.primary;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: displayColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
