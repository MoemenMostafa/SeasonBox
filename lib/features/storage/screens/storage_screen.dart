import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/models/storage_location.dart';
import '../../../data/repositories/storage_location_repository.dart';
import '../../../widgets/season_box_app_bar.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/season_box_add_button.dart';
import '../../../widgets/skeleton_container.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  List<StorageLocation> _locations = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

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
      const familyId = 'test-family-id';
      final locations = await context
          .read<StorageLocationRepository>()
          .getLocations(familyId)
          .timeout(const Duration(seconds: 5));
      if (mounted) {
        setState(() {
          _locations = locations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading storage locations: $e')),
        );
      }
    }
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
        title: 'Storage Locations',
        subtitle:
            '${_locations.length} locations • ${_locations.length * 15} items',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.grid_view, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingSkeleton()
          : CustomScrollView(
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
      floatingActionButton: SeasonBoxAddButton(
        onPressed: () =>
            context.push('/add-location').then((_) => _loadLocations()),
      ),
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
            child: _buildStatItem(boxCount.toString(), 'Boxes',
                Icons.inventory_2, Colors.blue, theme),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatItem(closetCount.toString(), 'Closets',
                Icons.door_sliding, Colors.green, theme),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatItem(areaCount.toString(), 'Areas', Icons.garage,
                Colors.purple, theme),
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
              hintText: 'Search locations...',
              hintStyle: TextStyle(color: theme.hintColor),
              prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
              suffixIcon: Icon(Icons.tune, color: theme.iconTheme.color),
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
              _buildFilterChip('All', _locations.length, theme),
              const SizedBox(width: 8),
              _buildFilterChip(
                  'Basement',
                  _locations.where((l) => l.name.contains('Basement')).length,
                  theme),
              const SizedBox(width: 8),
              _buildFilterChip('Closets',
                  _locations.where((l) => l.type == 'Closet').length, theme),
              const SizedBox(width: 8),
              _buildFilterChip(
                  'Attic',
                  _locations.where((l) => l.name.contains('Attic')).length,
                  theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, int count, ThemeData theme) {
    final isSelected = _selectedFilter == label ||
        (label.startsWith(_selectedFilter) && _selectedFilter != 'All');
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : (isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color:
                isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStorageList(ThemeData theme, bool isDark) {
    // Filter logic
    final filteredLocations = _locations.where((l) {
      final matchesSearch =
          l.name.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Closets' && l.type == 'Closet') ||
          (_selectedFilter == 'Basement' && l.name.contains('Basement')) ||
          (_selectedFilter == 'Attic' && l.name.contains('Attic'));
      return matchesSearch && matchesFilter;
    }).toList();

    // Grouping logic (simplified for now)
    final basementLocations = filteredLocations
        .where((l) => l.name.contains('Basement') || l.type == 'Box')
        .toList();
    final otherLocations = filteredLocations
        .where((l) => !l.name.contains('Basement') && l.type != 'Box')
        .toList();

    return SliverList(
      delegate: SliverChildListDelegate([
        if (basementLocations.isNotEmpty) ...[
          _buildSectionHeader('Basement Storage', theme),
          ...basementLocations.map((l) => _buildLocationCard(l, theme)),
        ],
        if (otherLocations.isNotEmpty) ...[
          _buildSectionHeader('Other Storage', theme),
          ...otherLocations.map((l) => _buildLocationCard(l, theme)),
        ],
      ]),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Expand All',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(StorageLocation location, ThemeData theme) {
    final color = _getColorForType(location.type);
    final icon = _getIconForType(location.type);

    return AppCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            title: Text(
              location.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              '${location.type} • ${location.description.isNotEmpty ? location.description : "No description"}',
              style: TextStyle(
                  color:
                      theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7)),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '95% Full',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                if (location.qrCodeId != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'QR: ${location.qrCodeId}',
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                const Spacer(),
                Text(
                  'View Items',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Scan QR Code',
                  Icons.qr_code_scanner,
                  Colors.purple,
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  'Print Labels',
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
      String title, IconData icon, Color color, ThemeData theme) {
    return AppCard(
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
