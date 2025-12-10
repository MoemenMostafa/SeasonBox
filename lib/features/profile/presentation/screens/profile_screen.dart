import 'package:flutter/material.dart';

import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/widgets/app_footer.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/app/providers/theme_provider.dart';
import 'package:seasonbox/data/services/biometric_service.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:go_router/go_router.dart';

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
                onSignOut: () async {
                  // Show confirmation dialog
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true && context.mounted) {
                    try {
                      // Disable biometric login if enabled
                      final biometricService = BiometricService();
                      final isBiometricEnabled =
                          await biometricService.isBiometricLoginEnabled();
                      if (isBiometricEnabled) {
                        await biometricService.disableBiometricLogin();
                      }

                      // Sign out from Firebase
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      await authService.signOut();

                      // Navigate to login screen
                      if (context.mounted) {
                        context.go('/login');
                      }
                    } catch (e) {
                      // Show error message if logout fails
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logout failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
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
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return _buildToggleTile(
              context,
              icon: Icons.dark_mode,
              iconColor: Colors.indigo,
              iconBgColor: Colors.indigo.shade50,
              title: 'Dark Mode',
              subtitle: 'Toggle dark theme',
              value: isDark,
              onChanged: (val) {
                themeProvider.toggleTheme(val);
              },
            );
          },
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 12),
        FutureBuilder<bool>(
          future: BiometricService().isBiometricLoginEnabled(),
          builder: (context, snapshot) {
            final isEnabled = snapshot.data ?? false;
            final biometricService = BiometricService();
            return _buildToggleTile(
              context,
              icon: Icons.fingerprint,
              iconColor: Colors.teal,
              iconBgColor: Colors.teal.shade50,
              title: 'Biometric Login',
              subtitle: 'Enable Face ID / Touch ID',
              value: isEnabled,
              onChanged: (val) async {
                if (val) {
                  final authenticated = await biometricService.authenticate();
                  if (authenticated) {
                    if (context.mounted) {
                      _showPasswordDialog(context, biometricService);
                    }
                  }
                } else {
                  await biometricService.disableBiometricLogin();
                  setState(() {});
                }
              },
            );
          },
        ),
      ],
    );
  }

  void _showPasswordDialog(
      BuildContext context, BiometricService biometricService) {
    final passwordController = TextEditingController();
    final emailController =
        TextEditingController(); // We need email too if not stored
    // Ideally we should get email from current user, but for now let's ask for both or assume user knows.
    // Actually, we can get email from FirebaseAuth if logged in.
    // Let's assume we are logged in.
    // But wait, AuthService is needed.

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Biometric Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Please enter your email and password to securely store them.'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                await biometricService.enableBiometricLogin(
                  emailController.text.trim(),
                  passwordController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Biometric login enabled')),
                  );
                }
              }
            },
            child: const Text('Enable'),
          ),
        ],
      ),
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
