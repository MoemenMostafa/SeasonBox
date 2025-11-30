import 'package:flutter/material.dart';

import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/widgets/app_footer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _seasonalRemindersEnabled = true;
  bool _autoSyncEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SeasonBoxAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(context),
              const SizedBox(height: 24),
              _buildFamilyManagement(context),
              const SizedBox(height: 24),
              _buildAppSettings(context),
              const SizedBox(height: 24),
              _buildDataPrivacy(context),
              const SizedBox(height: 24),
              _buildSupport(context),
              const SizedBox(height: 32),
              AppFooter(
                onSignOut: () {
                  // Handle sign out
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(
                    'assets/images/avatar_placeholder.png'), // Placeholder
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sarah Johnson',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'sarah.johnson@email.com',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Family Admin',
                      style: TextStyle(
                        color: Colors.purple.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade50,
                foregroundColor: Colors.purple.shade700,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFamilyManagement(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Family Management'),
        _buildListTile(
          context,
          icon: Icons.people,
          iconColor: Colors.blue,
          iconBgColor: Colors.blue.shade50,
          title: 'Johnson Family',
          subtitle: '5 members • You are admin',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          icon: Icons.person_add,
          iconColor: Colors.green,
          iconBgColor: Colors.green.shade50,
          title: 'Invite Members',
          subtitle: 'Share family access',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAppSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('App Settings'),
        _buildToggleTile(
          context,
          icon: Icons.notifications,
          iconColor: Colors.purple,
          iconBgColor: Colors.purple.shade50,
          title: 'Notifications',
          subtitle: 'Reminders & alerts',
          value: _notificationsEnabled,
          onChanged: (val) {
            setState(() {
              _notificationsEnabled = val;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildToggleTile(
          context,
          icon: Icons.calendar_today,
          iconColor: Colors.orange,
          iconBgColor: Colors.orange.shade50,
          title: 'Seasonal Reminders',
          subtitle: 'Auto season alerts',
          value: _seasonalRemindersEnabled,
          onChanged: (val) {
            setState(() {
              _seasonalRemindersEnabled = val;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildToggleTile(
          context,
          icon: Icons.sync,
          iconColor: Colors.red,
          iconBgColor: Colors.red.shade50,
          title: 'Auto Sync',
          subtitle: 'Cloud synchronization',
          value: _autoSyncEnabled,
          onChanged: (val) {
            setState(() {
              _autoSyncEnabled = val;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDataPrivacy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Data & Privacy'),
        _buildListTile(
          context,
          icon: Icons.download,
          iconColor: Colors.blue,
          iconBgColor: Colors.blue.shade50,
          title: 'Export Data',
          subtitle: 'Download your information',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          icon: Icons.upload,
          iconColor: Colors.green,
          iconBgColor: Colors.green.shade50,
          title: 'Backup Data',
          subtitle: 'Create backup copy',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          icon: Icons.security,
          iconColor: Colors.grey.shade700,
          iconBgColor: Colors.grey.shade200,
          title: 'Privacy Policy',
          subtitle: 'How we protect your data',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSupport(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Support'),
        _buildListTile(
          context,
          icon: Icons.help,
          iconColor: Colors.amber.shade700,
          iconBgColor: Colors.amber.shade100,
          title: 'Help Center',
          subtitle: 'FAQs and tutorials',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          icon: Icons.email,
          iconColor: Colors.purple,
          iconBgColor: Colors.purple.shade50,
          title: 'Contact Support',
          subtitle: 'Get help from our team',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          icon: Icons.star,
          iconColor: Colors.green,
          iconBgColor: Colors.green.shade50,
          title: 'Rate App',
          subtitle: 'Share your feedback',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      isDark ? iconColor.withValues(alpha: 0.2) : iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? iconColor.withValues(alpha: 0.2) : iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }
}
