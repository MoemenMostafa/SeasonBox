import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/widgets/app_card.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/models/item.dart';
import 'package:seasonbox/data/models/storage_location.dart';
import 'package:seasonbox/data/repositories/family_member_repository.dart';
import 'package:seasonbox/data/repositories/item_repository.dart';
import 'package:seasonbox/data/repositories/storage_location_repository.dart';
import 'package:seasonbox/app/providers/user_profile_provider.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/core/utils/season_helper.dart';
import 'package:seasonbox/widgets/image_gallery_viewer.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:seasonbox/widgets/season_box_network_image.dart';

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

  String? _familyName;
  String? _userPhotoURL;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final authService = context.read<AuthService>();
      final currentUid = authService.currentUid;
      final familyId = await authService.getCurrentUserFamilyId();

      if (!mounted) return;

      if (familyId == null || currentUid == null) {
        throw Exception('User not authenticated');
      }

      // Fetch user data for family name and photo
      final userService = context.read<UserService>();
      final memberRepo = context.read<FamilyMemberRepository>();
      final itemRepo = context.read<ItemRepository>();

      Map<String, dynamic>? userData;
      if (authService.isDemoMode) {
        userData = {
          'familyName': 'Demo',
          'photoURL': null,
        };
      } else {
        final userDoc = await userService.getUserStream(currentUid).first;
        userData = userDoc.data() as Map<String, dynamic>?;
      }

      final members = await memberRepo
          .getFamilyMembers(familyId)
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;

      final items =
          await itemRepo.getItems(familyId).timeout(const Duration(seconds: 5));

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
          _familyName = userData?['familyName'] ?? 'Your'; // Fallback
          _userPhotoURL = userData?['photoURL'];
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
      appBar: SeasonBoxAppBar(
        title: AppLocalizations.of(context)!.appTitle,
        subtitle: AppLocalizations.of(context)!
            .home_appBar_subtitle(_familyName ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.push('/notifications'),
          ),
        ],
        leading: _userPhotoURL != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    context.push('/profile');
                  },
                  child: CircleAvatar(
                    backgroundImage: _userPhotoURL!.startsWith('assets/')
                        ? AssetImage(_userPhotoURL!) as ImageProvider
                        : NetworkImage(_userPhotoURL!),
                  ),
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats
                        _buildStatsRow(context),
                        const SizedBox(height: 24),

                        // Search
                        // _buildSearchBar(context),
                        // const SizedBox(height: 24),

                        // Quick Actions
                        Text(
                          AppLocalizations.of(context)!
                              .home_section_quickActions,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildQuickActions(context),
                        const SizedBox(height: 24),

                        // Family Members
                        if (_members.isNotEmpty) ...[
                          _buildSectionHeader(
                              context,
                              AppLocalizations.of(context)!
                                  .home_section_familyMembers,
                              () => context.push('/members')),
                          const SizedBox(height: 16),
                          _buildFamilyMembersList(context),
                          const SizedBox(height: 24),
                        ],

                        // Recent Items
                        if (_items.isNotEmpty) ...[
                          _buildSectionHeader(
                              context,
                              AppLocalizations.of(context)!
                                  .home_section_recentItems,
                              () => context.push('/items')),
                          const SizedBox(height: 16),
                          _buildRecentItemsList(context),
                          const SizedBox(height: 24),
                        ],

                        // Seasonal Reminders
                        Text(
                          AppLocalizations.of(context)!
                              .home_section_seasonalReminders,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildSeasonalReminder(context),
                        const SizedBox(height: 24),

                        // Storage Locations
                        if (_locations.isNotEmpty) ...[
                          _buildSectionHeader(
                              context,
                              AppLocalizations.of(context)!
                                  .home_section_storageLocations,
                              () => context.push('/storage'),
                              actionText: AppLocalizations.of(context)!
                                  .home_action_manage),
                          const SizedBox(height: 16),
                          _buildStorageLocations(context),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final userProvider = context.watch<UserProfileProvider>();
    final isPremium = userProvider.isPremium;
    final l10n = AppLocalizations.of(context)!;

    final itemsCount = _items.length;
    const itemsLimit = 50;
    final itemsProgress = (itemsCount / itemsLimit).clamp(0.0, 1.0);

    final membersCount = _members.length;
    const membersLimit = 4;
    final membersProgress = (membersCount / membersLimit).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.checkroom,
                count: '$itemsCount',
                label: l10n.home_stats_totalItems,
                color: Colors.purple.shade100,
                iconColor: Colors.purple,
                onTap: () => context.push('/items'),
                progress: !isPremium ? itemsProgress : null,
                limitLabel: !isPremium ? '$itemsCount/$itemsLimit' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.people,
                count: '$membersCount',
                label: l10n.home_stats_members,
                color: Colors.teal.shade100,
                iconColor: Colors.teal,
                onTap: () => context.push('/members'),
                progress: !isPremium ? membersProgress : null,
                limitLabel: !isPremium ? '$membersCount/$membersLimit' : null,
              ),
            ),
          ],
        ),
        if (!isPremium) ...[
          const SizedBox(height: 16),
          AppCard(
            onTap: () =>
                context.push('/subscription?source=home_premium_banner'),
            backgroundColor: Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(
                    alpha: Theme.of(context).brightness == Brightness.light
                        ? 1.0
                        : 0.3),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.home_premium_banner_title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.home_premium_banner_subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(BuildContext context,
      {required IconData icon,
      required String count,
      required String label,
      required Color color,
      required Color iconColor,
      required VoidCallback onTap,
      double? progress,
      String? limitLabel}) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          count,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (limitLabel != null)
                          Text(
                            limitLabel,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: iconColor.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0 ? Colors.red : iconColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFamilyMembersList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _members.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final member = _members[index];
        // Calculate age from birthdate
        final age = member.birthdate != null
            ? DateTime.now().difference(member.birthdate!).inDays ~/ 365
            : null;

        // Display string for age
        final ageDisplay = age != null
            ? AppLocalizations.of(context)!.home_member_age(age)
            : '?';

        // Get clothing size
        final size = member.clothingSize ?? 'N/A';

        // Calculate item count for this member
        final itemCount =
            _items.where((item) => item.ownerId == member.id).length;

        return _buildMemberCard(
          context,
          member.name,
          '$ageDisplay • ${AppLocalizations.of(context)!.home_member_size(size)}',
          AppLocalizations.of(context)!.home_member_items(itemCount),
          'Active',
          Colors.purple,
          () => context.push('/members'),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.camera_alt,
            label: AppLocalizations.of(context)!.home_action_addItem,
            color: Colors.purple.shade50,
            iconColor: Colors.purple,
            onTap: () {
              if (context.read<AuthService>().isDemoMode) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not available in Demo Mode')),
                );
                return;
              }
              context.push('/add-item').then((_) => _loadData());
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.qr_code_scanner,
            label: AppLocalizations.of(context)!.home_action_scanQR,
            color: Colors.teal.shade50,
            iconColor: Colors.teal,
            onTap: () {
              if (context.read<AuthService>().isDemoMode) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not available in Demo Mode')),
                );
                return;
              }
              context.push('/qr-scanner');
            },
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
      {String? actionText}) {
    final effectiveActionText =
        actionText ?? AppLocalizations.of(context)!.home_action_viewAll;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(effectiveActionText),
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
            backgroundImage: _members
                    .any((m) => m.name == name && m.photoUrl != null)
                ? (() {
                    final url =
                        _members.firstWhere((m) => m.name == name).photoUrl!;
                    return url.startsWith('assets/')
                        ? AssetImage(url) as ImageProvider
                        : NetworkImage(url);
                  })()
                : null,
            child: !_members.any((m) => m.name == name && m.photoUrl != null)
                ? Text(
                    name[0].toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                : null,
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
              '${AppLocalizations.of(context)!.home_member_size(item.size)} • ${item.gender.toDisplayString(context)}',
              AppLocalizations.of(context)!.home_item_storage, // Placeholder
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
              child: SeasonBoxNetworkImage(
                imageUrl: imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
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
    final userProvider = context.read<UserProfileProvider>();
    if (!userProvider.isPremium) return const SizedBox.shrink();

    final upcomingSeason = SeasonHelper.getUpcomingSeasonReminder();
    if (upcomingSeason == null) return const SizedBox.shrink();

    final seasonStrings =
        SeasonHelper.getSeasonStrings(context, upcomingSeason);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(16),
      onTap: null, // Removed non-functional callback
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
                  seasonStrings.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.orange.shade200 : Colors.brown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  seasonStrings.message,
                  style: TextStyle(
                      color: isDark ? Colors.orange.shade100 : Colors.brown),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.home_reminder_reviewItems,
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
            '${location.type} • ${AppLocalizations.of(context)!.home_member_items(itemCount)}',
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
