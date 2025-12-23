import 'package:flutter/material.dart';

import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/widgets/app_footer.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/app/providers/theme_provider.dart';
import 'package:seasonbox/data/services/biometric_service.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:seasonbox/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seasonbox/core/enums/user_role.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _seasonalRemindersEnabled = true;
  bool _autoSyncEnabled = true;

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      default:
        return 'English';
    }
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            final currentLocale = themeProvider.locale;
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)!.profile_setting_language,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildLanguageOption(
                      context, themeProvider, 'English', 'en', currentLocale),
                  _buildLanguageOption(
                      context, themeProvider, 'Español', 'es', currentLocale),
                  _buildLanguageOption(
                      context, themeProvider, 'Français', 'fr', currentLocale),
                  _buildLanguageOption(
                      context, themeProvider, 'Deutsch', 'de', currentLocale),
                  _buildLanguageOption(
                      context, themeProvider, 'Italiano', 'it', currentLocale),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, ThemeProvider themeProvider,
      String name, String code, Locale currentLocale) {
    final isSelected = currentLocale.languageCode == code;
    return ListTile(
      leading: Text(
        _getFlag(code),
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(name),
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.purple) : null,
      onTap: () {
        themeProvider.setLocale(Locale(code));
        Navigator.pop(context);
      },
    );
  }

  String _getFlag(String code) {
    switch (code) {
      case 'en':
        return '🇺🇸';
      case 'es':
        return '🇪🇸';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'it':
        return '🇮🇹';
      default:
        return '🌍';
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.common_comingSoon),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Stream<DocumentSnapshot>? _userStream;

  @override
  void initState() {
    super.initState();
    // Initialize stream once to prevent reloading on setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);
      final user = authService.currentUser;
      if (user != null) {
        setState(() {
          _userStream = userService.getUserStream(user.uid);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // We still need generic access to authService/userService for consistency checks
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: SeasonBoxAppBar(
        title: AppLocalizations.of(context)!.profile_title,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // TODO: Implement settings screen
              _showComingSoon(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_userStream != null)
                StreamBuilder<DocumentSnapshot>(
                  stream: _userStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Return a placeholder or the card with basic info if available
                      // For now, indicator is fine, but since we cache stream it should only happen once.
                      return const Center(child: CircularProgressIndicator());
                    }

                    final userData =
                        snapshot.data?.data() as Map<String, dynamic>?;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileCard(context, userData, user),
                        const SizedBox(height: 24),
                        _buildFamilyManagement(context, userData),
                      ],
                    );
                  },
                )
              else
                const Center(child: CircularProgressIndicator()),
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
                      title: Text(AppLocalizations.of(context)!
                          .profile_dialog_logout_title),
                      content: Text(AppLocalizations.of(context)!
                          .profile_dialog_logout_message),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(AppLocalizations.of(context)!
                              .profile_dialog_logout_cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: Text(AppLocalizations.of(context)!
                              .profile_dialog_logout_confirm),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true && context.mounted) {
                    try {
                      // Get services before async operations
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      final biometricService = BiometricService();

                      // Disable biometric login if enabled
                      // Disable biometric login if enabled (best effort)
                      try {
                        final isBiometricEnabled =
                            await biometricService.isBiometricLoginEnabled();
                        if (isBiometricEnabled) {
                          await biometricService.disableBiometricLogin();
                        }
                      } catch (e) {
                        debugPrint('Error disabling biometric login: $e');
                      }

                      // Sign out from Firebase
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
                            content: Text(AppLocalizations.of(context)!
                                .profile_error_logoutFailed(e.toString())),
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

  Widget _buildProfileCard(
      BuildContext context, Map<String, dynamic>? userData, dynamic authUser) {
    final displayName = userData?['displayName'] ?? 'User';
    final email = userData?['email'] ?? authUser?.email ?? 'No Email';
    final photoURL = userData?['photoURL'];

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
              CircleAvatar(
                radius: 35,
                backgroundImage:
                    photoURL != null ? NetworkImage(photoURL) : null,
                child: photoURL == null
                    ? Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.grey.shade400,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      UserRole.fromString(userData?['role'] ?? 'member')
                          .getLocalizedName(context),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditProfileScreen(userData: userData)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade50,
                foregroundColor: Colors.purple.shade700,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                  AppLocalizations.of(context)!.profile_button_editProfile),
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

  Widget _buildFamilyManagement(
      BuildContext context, Map<String, dynamic>? userData) {
    final familyName = userData?['familyName'];
    final familyId = userData?['familyId'];
    // Need auth service to get current user ID
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    final isSoloFamily = familyId == user?.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            AppLocalizations.of(context)!.profile_section_familyManagement),
        Card(
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.blue.withValues(alpha: 0.2)
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.people, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        familyName != null
                            ? AppLocalizations.of(context)!
                                .profile_family_name(familyName)
                            : AppLocalizations.of(context)!
                                .profile_section_familyManagement,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        familyId ?? '',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (familyId != null)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('families')
                .doc(familyId)
                .collection('members')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              final memberCount = snapshot.data!.docs.length;
              // Can join if solo family AND no other members
              final canJoin = isSoloFamily && memberCount <= 1;
              // Can leave if NOT solo family OR (solo family AND has other members - i.e. disband)
              final canLeave =
                  !isSoloFamily || (isSoloFamily && memberCount > 1);

              return Column(
                children: [
                  const SizedBox(height: 12),
                  if (canJoin)
                    _buildListTile(
                      context,
                      icon: Icons.group_add,
                      iconColor: Colors.teal,
                      iconBgColor: Colors.teal.shade50,
                      title: AppLocalizations.of(context)!
                          .profile_joinFamily_title,
                      subtitle: AppLocalizations.of(context)!
                          .profile_joinFamily_input,
                      onTap: () => _showJoinFamilyDialog(context),
                    ),
                  if (canLeave) ...[
                    if (canJoin)
                      const SizedBox(
                          height:
                              12), // Spacing if both visible (rare/impossible with current logic)
                    _buildListTile(
                      context,
                      icon: Icons.exit_to_app,
                      iconColor: Colors.red,
                      iconBgColor: Colors.red.shade50,
                      title: AppLocalizations.of(context)!
                          .profile_leaveFamily_title,
                      subtitle: AppLocalizations.of(context)!
                          .profile_leaveFamily_title,
                      onTap: () => _showLeaveFamilyDialog(context, familyId,
                          isDisbanding: isSoloFamily),
                    ),
                  ],
                ],
              );
            },
          ),
      ],
    );
  }

  void _showJoinFamilyDialog(BuildContext context) {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.profile_joinFamily_title),
        content: TextField(
          controller: codeController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.profile_joinFamily_input,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
                AppLocalizations.of(context)!.profile_dialog_logout_cancel),
          ),
          TextButton(
            onPressed: () async {
              if (codeController.text.isNotEmpty) {
                try {
                  final userService =
                      Provider.of<UserService>(context, listen: false);
                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  final user = authService.currentUser;

                  if (user != null) {
                    await userService.joinFamily(
                        user.uid, user.email!, codeController.text.trim());
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .profile_joinFamily_success),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Force refresh stream
                      setState(() {
                        _userStream = userService.getUserStream(user.uid);
                      });
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.profile_joinFamily_title),
          ),
        ],
      ),
    );
  }

  void _showLeaveFamilyDialog(BuildContext context, String currentFamilyId,
      {bool isDisbanding = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.profile_leaveFamily_title),
        content: Text(isDisbanding
            ? AppLocalizations.of(context)!.profile_disbandFamily_confirm
            : AppLocalizations.of(context)!.profile_leaveFamily_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
                AppLocalizations.of(context)!.profile_dialog_logout_cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                final userService =
                    Provider.of<UserService>(context, listen: false);
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                final user = authService.currentUser;

                if (user != null) {
                  await userService.leaveFamily(user.uid, currentFamilyId);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .profile_leaveFamily_success),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Force refresh stream (optional as stream updates auto but good for safety)
                    setState(() {
                      _userStream = userService.getUserStream(user.uid);
                    });
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child:
                Text(AppLocalizations.of(context)!.profile_leaveFamily_title),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            AppLocalizations.of(context)!.profile_section_appSettings),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Column(
              children: [
                _buildListTile(
                  context,
                  icon: Icons.language,
                  iconColor: Colors.deepPurple,
                  iconBgColor: Colors.deepPurple.shade50,
                  title: AppLocalizations.of(context)!.profile_setting_language,
                  subtitle: _getLanguageName(themeProvider.locale),
                  onTap: () => _showLanguageBottomSheet(context),
                ),
                const SizedBox(height: 12),
                _buildToggleTile(
                  context,
                  icon: Icons.dark_mode,
                  iconColor: Colors.indigo,
                  iconBgColor: Colors.indigo.shade50,
                  title: AppLocalizations.of(context)!.profile_setting_darkMode,
                  subtitle: AppLocalizations.of(context)!
                      .profile_setting_darkModeSubtitle,
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (val) {
                    themeProvider.toggleTheme(val);
                  },
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        _buildToggleTile(
          context,
          icon: Icons.notifications,
          iconColor: Colors.purple,
          iconBgColor: Colors.purple.shade50,
          title: AppLocalizations.of(context)!.profile_setting_notifications,
          subtitle: AppLocalizations.of(context)!
              .profile_setting_notificationsSubtitle,
          value: _notificationsEnabled,
          onChanged: (val) {
            setState(() {
              _notificationsEnabled = val;
            });
            // TODO: Implement notifications functionality
            _showComingSoon(context);
          },
        ),
        const SizedBox(height: 12),
        _buildToggleTile(
          context,
          icon: Icons.calendar_today,
          iconColor: Colors.orange,
          iconBgColor: Colors.orange.shade50,
          title:
              AppLocalizations.of(context)!.profile_setting_seasonalReminders,
          subtitle: AppLocalizations.of(context)!
              .profile_setting_seasonalRemindersSubtitle,
          value: _seasonalRemindersEnabled,
          onChanged: (val) {
            setState(() {
              _seasonalRemindersEnabled = val;
            });
            // TODO: Implement seasonal reminders functionality
            _showComingSoon(context);
          },
        ),
        const SizedBox(height: 12),
        _buildToggleTile(
          context,
          icon: Icons.sync,
          iconColor: Colors.red,
          iconBgColor: Colors.red.shade50,
          title: AppLocalizations.of(context)!.profile_setting_autoSync,
          subtitle:
              AppLocalizations.of(context)!.profile_setting_autoSyncSubtitle,
          value: _autoSyncEnabled,
          onChanged: (val) {
            setState(() {
              _autoSyncEnabled = val;
            });
            // TODO: Implement auto sync functionality
            _showComingSoon(context);
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
              title:
                  AppLocalizations.of(context)!.profile_setting_biometricLogin,
              subtitle: AppLocalizations.of(context)!
                  .profile_setting_biometricLoginSubtitle,
              value: isEnabled,
              onChanged: (val) async {
                if (val) {
                  final authenticated = await biometricService.authenticate();
                  if (authenticated) {
                    if (context.mounted) {
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      final user = authService.currentUser;
                      final isGoogle = user?.providerData
                              .any((info) => info.providerId == 'google.com') ??
                          false;

                      if (isGoogle && user?.email != null) {
                        try {
                          await biometricService.enableBiometricLogin(
                            user!.email!,
                            "N/A",
                            provider: 'google',
                          );
                          setState(() {});
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      } else {
                        _showPasswordDialog(context, biometricService);
                      }
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
        title:
            Text(AppLocalizations.of(context)!.profile_dialog_biometric_title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                AppLocalizations.of(context)!.profile_dialog_biometric_message),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.emailLogin_field_email),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.emailLogin_field_password),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
                AppLocalizations.of(context)!.profile_dialog_logout_cancel),
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
                    SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .profile_success_biometricEnabled)),
                  );
                }
              }
            },
            child: Text(
                AppLocalizations.of(context)!.profile_dialog_biometric_enable),
          ),
        ],
      ),
    );
  }

  Widget _buildDataPrivacy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            AppLocalizations.of(context)!.profile_section_dataPrivacy),
        _buildListTile(
          context,
          icon: Icons.download,
          iconColor: Colors.blue,
          iconBgColor: Colors.blue.shade50,
          title: AppLocalizations.of(context)!.profile_data_exportData,
          subtitle:
              AppLocalizations.of(context)!.profile_data_exportDataSubtitle,
          onTap: () {
            // TODO: Implement export data
            _showComingSoon(context);
          },
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          icon: Icons.upload,
          iconColor: Colors.green,
          iconBgColor: Colors.green.shade50,
          title: AppLocalizations.of(context)!.profile_data_backupData,
          subtitle:
              AppLocalizations.of(context)!.profile_data_backupDataSubtitle,
          onTap: () {
            // TODO: Implement backup data
            _showComingSoon(context);
          },
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          icon: Icons.security,
          iconColor: Colors.grey.shade700,
          iconBgColor: Colors.grey.shade200,
          title: AppLocalizations.of(context)!.profile_data_privacyPolicy,
          subtitle:
              AppLocalizations.of(context)!.profile_data_privacyPolicySubtitle,
          onTap: () {
            // TODO: Navigate to privacy policy
            _showComingSoon(context);
          },
        ),
      ],
    );
  }

  Widget _buildSupport(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            AppLocalizations.of(context)!.profile_section_support),
        _buildListTile(
          context,
          icon: Icons.help,
          iconColor: Colors.amber.shade700,
          iconBgColor: Colors.amber.shade100,
          title: AppLocalizations.of(context)!.profile_support_helpCenter,
          subtitle:
              AppLocalizations.of(context)!.profile_support_helpCenterSubtitle,
          onTap: () {
            // TODO: Navigate to help center
            _showComingSoon(context);
          },
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          icon: Icons.email,
          iconColor: Colors.purple,
          iconBgColor: Colors.purple.shade50,
          title: AppLocalizations.of(context)!.profile_support_contactSupport,
          subtitle: AppLocalizations.of(context)!
              .profile_support_contactSupportSubtitle,
          onTap: () {
            // TODO: Implement contact support
            _showComingSoon(context);
          },
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          icon: Icons.star,
          iconColor: Colors.green,
          iconBgColor: Colors.green.shade50,
          title: AppLocalizations.of(context)!.profile_support_rateApp,
          subtitle:
              AppLocalizations.of(context)!.profile_support_rateAppSubtitle,
          onTap: () {
            // TODO: Implement rate app
            _showComingSoon(context);
          },
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
