import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/widgets/app_card.dart';
import 'package:seasonbox/widgets/season_box_search_field.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/models/item.dart';
import 'package:seasonbox/data/models/storage_location.dart';
import 'package:seasonbox/data/repositories/family_member_repository.dart';
import 'package:seasonbox/data/repositories/item_repository.dart';
import 'package:seasonbox/data/repositories/storage_location_repository.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/widgets/image_gallery_viewer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FamilyMember> _members = [];
  List<Item> _items = [];
  List<StorageLocation> _locations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final familyId =
          await context.read<AuthService>().getCurrentUserFamilyId();
      if (familyId == null) {
        throw Exception('User not authenticated');
      }

      final members = await context
          .read<FamilyMemberRepository>()
          .getFamilyMembers(familyId)
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;

      final items = await context
          .read<ItemRepository>()
          .getItems(familyId)
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;

      final locations = await context
          .read<StorageLocationRepository>()
          .getLocations(familyId)
          .timeout(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _members = members;
          _items = items;
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
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SeasonBoxAppBar(
        title: 'SeasonBox',
        subtitle: 'Johnson Family',
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats
                      _buildStatsRow(context),
                      const SizedBox(height: 24),

                      // Search
                      _buildSearchBar(context),
                      const SizedBox(height: 24),

                      // Quick Actions
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildQuickActions(context),
                      const SizedBox(height: 24),

                      // Family Members
                      if (_members.isNotEmpty) ...[
                        _buildSectionHeader(context, 'Family Members',
                            () => context.push('/members')),
                        const SizedBox(height: 16),
                        _buildFamilyMembersList(context),
                        const SizedBox(height: 24),
                      ],

                      // Recent Items
                      if (_items.isNotEmpty) ...[
                        _buildSectionHeader(context, 'Recent Items',
                            () => context.push('/items')),
                        const SizedBox(height: 16),
                        _buildRecentItemsList(context),
                        const SizedBox(height: 24),
                      ],

                      // Seasonal Reminders
                      const Text(
                        'Seasonal Reminders',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildSeasonalReminder(context),
                      const SizedBox(height: 24),

                      // Storage Locations
                      if (_locations.isNotEmpty) ...[
                        _buildSectionHeader(context, 'Storage Locations',
                            () => context.push('/storage'),
                            actionText: 'Manage'),
                        const SizedBox(height: 16),
                        _buildStorageLocations(context),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.checkroom,
            count: '${_items.length}',
            label: 'Total Items',
            color: Colors.purple.shade100,
            iconColor: Colors.purple,
            onTap: () => context.push('/items'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.people,
            count: '${_members.length}',
            label: 'Members',
            color: Colors.teal.shade100,
            iconColor: Colors.teal,
            onTap: () => context.push('/members'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context,
      {required IconData icon,
      required String count,
      required String label,
      required Color color,
      required Color iconColor,
      required VoidCallback onTap}) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? iconColor.withValues(alpha: 0.2)
                  : color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return const SeasonBoxSearchField(
      hintText: 'Search items, locations...',
    );
  }

  Widget _buildFamilyMembersList(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          // Calculate age from birthdate
          final age = DateTime.now().difference(member.birthdate).inDays ~/ 365;

          // Get clothing size
          final size = member.clothingSize?.toString() ?? 'N/A';

          // Calculate item count for this member
          final itemCount =
              _items.where((item) => item.memberId == member.id).length;

          return Padding(
            padding:
                EdgeInsets.only(right: index == _members.length - 1 ? 0 : 12),
            child: _buildMemberCard(
              context,
              member.name,
              'Age $age • Size $size',
              '$itemCount items',
              'Active',
              Colors.purple,
              () => context.push('/members'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.camera_alt,
            label: 'Add Item',
            color: Colors.purple.shade50,
            iconColor: Colors.purple,
            onTap: () => context.push('/add-item').then((_) => _loadData()),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.qr_code_scanner,
            label: 'Scan QR',
            color: Colors.teal.shade50,
            iconColor: Colors.teal,
            onTap: () {}, // TODO: QR Scanner
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required Color iconColor,
      required VoidCallback onTap}) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 24),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? iconColor.withValues(alpha: 0.2)
                  : color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, VoidCallback onTap,
      {String actionText = 'View All'}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(actionText),
        ),
      ],
    );
  }

  Widget _buildMemberCard(BuildContext context, String name, String details,
      String itemCount, String status, Color statusColor, VoidCallback onTap) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.purple.shade100,
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(details,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(itemCount,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.purple)),
              Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItemsList(BuildContext context) {
    // Show first 2 items
    final displayItems = _items.take(2).toList();

    if (displayItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: displayItems.map((item) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: displayItems.indexOf(item) == 0 ? 16 : 0,
            ),
            child: _buildItemCard(
              context,
              item.title,
              'Size ${item.size} • ${item.gender}',
              'Storage', // Placeholder
              item.photos.isNotEmpty
                  ? item.photos.first['thumb'] ??
                      item.photos.first['full'] ??
                      ''
                  : 'https://placehold.co/200x200/png?text=${item.category}',
              () => context.push('/items'),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItemCard(BuildContext context, String title, String details,
      String location, String imageUrl, VoidCallback onTap) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: GestureDetector(
              onTap: () {
                // Extract all image URLs from the item
                final imageUrls = <String>[];
                final item = _items.firstWhere(
                  (i) => i.title == title,
                  orElse: () => _items.first,
                );

                for (final photo in item.photos) {
                  final url = photo['full'] ?? photo['thumb'] ?? '';
                  if (url.isNotEmpty) {
                    imageUrls.add(url);
                  }
                }

                // If no valid photos, use the placeholder
                if (imageUrls.isEmpty && imageUrl.isNotEmpty) {
                  imageUrls.add(imageUrl);
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
              child: Image.network(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey.shade200,
                    child:
                        const Icon(Icons.image, size: 48, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(details,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(location,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalReminder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppCard(
      padding: const EdgeInsets.all(16),
      onTap: () {}, // Make it clickable if needed, or null
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.orange.withValues(alpha: 0.2)
                  : Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wb_sunny, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fall Season Approaching',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.orange.shade200 : Colors.brown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Time to check fall clothes for your children. Consider size changes from last year.',
                  style: TextStyle(
                      color: isDark ? Colors.orange.shade100 : Colors.brown),
                ),
                const SizedBox(height: 8),
                Text(
                  'Review Items',
                  style: TextStyle(
                    color: isDark ? Colors.orange : Colors.orange.shade800,
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

  Widget _buildStorageLocations(BuildContext context) {
    // Show first 2 locations
    final displayLocations = _locations.take(2).toList();

    return Column(
      children: displayLocations.map((location) {
        // Count items in this location
        final itemCount = _items
            .where((item) => item.storageLocationId == location.id)
            .length;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildStorageCard(
            context,
            location.name,
            '${location.type} • $itemCount items',
            _getIconForType(location.type),
            _getColorForType(location.type),
            () => context.push('/storage'),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'box':
        return Icons.inventory;
      case 'closet':
        return Icons.door_sliding;
      case 'area':
        return Icons.garage;
      default:
        return Icons.storage;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'box':
        return Colors.orange;
      case 'closet':
        return Colors.green;
      case 'area':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStorageCard(BuildContext context, String title, String details,
      IconData icon, Color iconColor, VoidCallback onTap) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? iconColor.withValues(alpha: 0.2)
                  : iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(details,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
