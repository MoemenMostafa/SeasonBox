import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/repositories/family_member_repository.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:seasonbox/data/services/posthog_service.dart';
import 'package:seasonbox/widgets/app_card.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;
  List<FamilyMember> _invites = [];

  @override
  void initState() {
    super.initState();
    _loadInvites();
  }

  Future<void> _loadInvites() async {
    final user = context.read<AuthService>().currentUser;
    if (user?.email == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final invites = await context
          .read<FamilyMemberRepository>()
          .getPendingInvites(user!.email!);
      if (mounted) {
        setState(() {
          _invites = invites;
          _isLoading = false;
        });
      }
    } catch (e) {
      PostHogService.log('Error loading invites: $e', level: LogLevel.error);
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAccept(FamilyMember invite) async {
    final user = context.read<AuthService>().currentUser;
    if (user == null || user.email == null) return;

    try {
      await context
          .read<UserService>()
          .joinFamily(user.uid, user.email!, invite.familyId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.notifications_success_joined)),
        );
        _loadInvites(); // Refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .notifications_error_joining(e.toString()))),
        );
      }
    }
  }

  Future<void> _handleReject(FamilyMember invite) async {
    try {
      await context
          .read<FamilyMemberRepository>()
          .deleteFamilyMember(invite.familyId, invite.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .notifications_success_rejected)),
        );
        _loadInvites(); // Refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .notifications_error_rejecting(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SeasonBoxAppBar(
        title: AppLocalizations.of(context)!.notifications_title,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _invites.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _invites.length,
                  itemBuilder: (context, index) {
                    final invite = _invites[index];
                    return _buildInviteCard(invite);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.notifications_empty,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteCard(FamilyMember invite) {
    final inviterName = invite.inviterName ?? 'Someone';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mail, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.notifications_invite_title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!
                  .notifications_invite_message(inviterName),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!
                  .notifications_invite_familyId(invite.familyId),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _handleReject(invite),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(AppLocalizations.of(context)!
                      .notifications_action_reject),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _handleAccept(invite),
                  child: Text(AppLocalizations.of(context)!
                      .notifications_action_accept),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
