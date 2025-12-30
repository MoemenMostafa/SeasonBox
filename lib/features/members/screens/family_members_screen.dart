import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/item.dart';
import '../../../data/repositories/family_member_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../features/auth/data/auth_service.dart';
import '../../../widgets/season_box_app_bar.dart';
import '../../../widgets/season_box_add_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/skeleton_container.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:seasonbox/widgets/limit_reached_dialog.dart';
import '../../../core/services/permission_service.dart';
import '../../../app/providers/user_profile_provider.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  List<FamilyMember> _members = [];
  List<Item> _items = [];
  bool _isLoading = true;
  String? _currentUserId;
  String? _familyId;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final authService = context.read<AuthService>();
      final familyId = await authService.getCurrentUserFamilyId();
      final currentUid = authService.currentUid;

      if (familyId == null || currentUid == null) {
        throw Exception('User not authenticated');
      }

      if (!mounted) return;

      final members = await context
          .read<FamilyMemberRepository>()
          .getFamilyMembers(familyId)
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;

      final items = await context
          .read<ItemRepository>()
          .getItems(familyId)
          .timeout(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _currentUserId = currentUid;
          _familyId = familyId;
          _members = members;
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _members = [];
          _items = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .members_error_loading(e.toString()))),
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

  Widget _buildMemberCard(FamilyMember member, ThemeData theme) {
    final age =
        member.birthdate != null ? _calculateAge(member.birthdate!) : null;
    final isDark = theme.brightness == Brightness.dark;

    // Calculate actual item count for this member
    final itemCount = _items.where((item) => item.ownerId == member.id).length;

    return AppCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.purple.shade100,
                backgroundImage: member.photoUrl != null
                    ? (member.photoUrl!.startsWith('assets/')
                        ? AssetImage(member.photoUrl!) as ImageProvider
                        : NetworkImage(member.photoUrl!))
                    : null,
                child: member.photoUrl == null
                    ? Text(
                        member.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          member.name,
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
                            age != null
                                ? AppLocalizations.of(context)!
                                    .members_ageYears(age)
                                : '?',
                            style: const TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      member.birthdate != null
                          ? AppLocalizations.of(context)!.members_born(member
                              .birthdate!
                              .toLocal()
                              .toString()
                              .split(' ')[0])
                          : AppLocalizations.of(context)!
                              .members_birthdate_notSet,
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
                      Text(
                          AppLocalizations.of(context)!
                              .members_label_currentSize,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7))),
                      const SizedBox(height: 4),
                      Text(
                          AppLocalizations.of(context)!
                              .members_clothes(member.clothingSize ?? '-'),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          AppLocalizations.of(context)!
                              .members_shoes(member.shoeSize ?? '-'),
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
                      Text(AppLocalizations.of(context)!.members_label_items,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7))),
                      const SizedBox(height: 4),
                      Text('$itemCount',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: theme.colorScheme.primary)),
                      Text(
                          itemCount > 0
                              ? AppLocalizations.of(context)!.members_hasItems
                              : AppLocalizations.of(context)!
                                  .members_noItemsYet,
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
                  onPressed: () {
                    context.push('/items', extra: member.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                      AppLocalizations.of(context)!.members_button_viewItems),
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
                  onPressed: () {
                    if (member.birthdate == null) {
                      _showBirthdatePrompt(member);
                    } else if (member.clothingSize == null &&
                        member.shoeSize == null) {
                      _showSizePrompt(member);
                    } else {
                      context.push('/growth-chart', extra: member);
                    }
                  },
                  icon: Icon(
                    Icons.show_chart,
                    color: (member.birthdate == null ||
                            (member.clothingSize == null &&
                                member.shoeSize == null))
                        ? theme.disabledColor
                        : theme.iconTheme.color,
                  ),
                  tooltip:
                      AppLocalizations.of(context)!.members_tooltipGrowthChart,
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
                  onPressed: PermissionService.canManageMember(
                    _currentUserId,
                    member,
                    _familyId,
                    _members,
                  )
                      ? () {
                          if (context.read<AuthService>().isDemoMode) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Not available in Demo Mode')),
                            );
                            return;
                          }
                          context
                              .push('/add-member', extra: member)
                              .then((_) => _loadMembers());
                        }
                      : null,
                  icon: Icon(
                    Icons.edit,
                    color: PermissionService.canManageMember(
                      _currentUserId,
                      member,
                      _familyId,
                      _members,
                    )
                        ? theme.iconTheme.color
                        : theme.disabledColor,
                  ),
                  tooltip: PermissionService.canManageMember(
                    _currentUserId,
                    member,
                    _familyId,
                    _members,
                  )
                      ? AppLocalizations.of(context)!.members_tooltipEdit
                      : AppLocalizations.of(context)!
                          .members_tooltip_editPermission,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSizePrompt(FamilyMember member) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.members_dialog_sizeRequired_title),
        content: Text(l10n.members_dialog_sizeRequired_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.common_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .push('/add-member', extra: member)
                  .then((_) => _loadMembers());
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(l10n.members_dialog_sizeRequired_button),
          ),
        ],
      ),
    );
  }

  void _showBirthdatePrompt(FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!
            .members_dialog_birthdateRequired_title),
        content: Text(AppLocalizations.of(context)!
            .members_dialog_birthdateRequired_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.common_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context
                  .push('/add-member', extra: member)
                  .then((_) => _loadMembers());
            },
            child: Text(AppLocalizations.of(context)!
                .members_dialog_birthdateRequired_button),
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
        title: AppLocalizations.of(context)!.members_title,
        subtitle: AppLocalizations.of(context)!.members_subtitle,
        actions: const [],
      ),
      body: _isLoading
          ? _buildLoadingSkeleton(theme)
          : RefreshIndicator(
              onRefresh: _loadMembers,
              child: _members.isEmpty
                  ? LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: Text(
                                AppLocalizations.of(context)!.members_empty),
                          ),
                        ),
                      ),
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 84),
                      children: [
                        // Summary Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                  '${_members.length}',
                                  AppLocalizations.of(context)!
                                      .members_summaryMembers,
                                  theme),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSummaryCard(
                                  '${_items.length}',
                                  AppLocalizations.of(context)!
                                      .members_summaryTotalItems,
                                  theme,
                                  color: Colors.teal),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSummaryCard(
                                  '0',
                                  AppLocalizations.of(context)!
                                      .members_summaryNeedCheck,
                                  theme,
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
                              AppLocalizations.of(context)!.members_title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Members List
                        ..._members
                            .map((member) => _buildMemberCard(member, theme)),
                      ],
                    ),
            ),
      floatingActionButton: PermissionService.isAdmin(
              _currentUserId, _familyId, _members)
          ? SeasonBoxAddButton(
              heroTag: 'add_member_fab',
              onPressed: () {
                if (context.read<AuthService>().isDemoMode) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not available in Demo Mode')),
                  );
                  return;
                }
                final isPremium = context.read<UserProfileProvider>().isPremium;
                if (!isPremium && _members.length >= 4) {
                  _showUpgradeDialog();
                } else {
                  context.push('/add-member').then((_) => _loadMembers());
                }
              },
            )
          : null,
    );
  }

  void _showUpgradeDialog() {
    LimitReachedDialog.show(
      context,
      title: AppLocalizations.of(context)!.members_dialog_limitReached_title,
      message:
          AppLocalizations.of(context)!.members_dialog_limitReached_message,
      buttonLabel:
          AppLocalizations.of(context)!.members_dialog_limitReached_viewPricing,
      source: 'member_limit',
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

        // Members List Skeleton
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
