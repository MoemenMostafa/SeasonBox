import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:seasonbox/app/theme/theme.dart';
import 'package:seasonbox/features/auth/presentation/widgets/animated_background_icon.dart';
import 'package:seasonbox/data/services/biometric_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.secondaryColor,
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // Background Icons
          const Positioned(
            top: 50,
            left: 30,
            child: AnimatedBackgroundIcon(
              icon: Icons.checkroom_rounded,
              size: 60,
              duration: 4,
            ),
          ),
          const Positioned(
            top: 120,
            right: 40,
            child: AnimatedBackgroundIcon(
              icon: Icons.ac_unit,
              size: 50,
              duration: 5,
            ),
          ),
          const Positioned(
            top: 250,
            left: 50,
            child: AnimatedBackgroundIcon(
              icon: Icons.umbrella,
              size: 45,
              duration: 3,
            ),
          ),
          const Positioned(
            top: 400,
            right: 30,
            child: AnimatedBackgroundIcon(
              icon: Icons.wb_sunny,
              size: 55,
              duration: 6,
            ),
          ),
          const Positioned(
            bottom: 300,
            left: 30,
            child: AnimatedBackgroundIcon(
              icon: Icons.beach_access,
              size: 40,
              duration: 4,
            ),
          ),
          const Positioned(
            bottom: 230,
            right: 50,
            child: AnimatedBackgroundIcon(
              icon: Icons.shopping_bag,
              size: 48,
              duration: 5,
            ),
          ),
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Logo Area
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'SeasonBox',
                            style: GoogleFonts.poppins(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Organize seasonal items for your\nfamily with ease',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  // Feature Cards
                  const FeatureCard(
                    icon: Icons.camera_alt_rounded,
                    title: 'Photo Inventory',
                    subtitle: 'Capture and organize with photos',
                  ),
                  const SizedBox(height: 16),
                  const FeatureCard(
                    icon: Icons.people_rounded,
                    title: 'Family Sharing',
                    subtitle: 'Sync across all family members',
                  ),
                  const SizedBox(height: 16),
                  const FeatureCard(
                    icon: Icons.notifications_active_rounded,
                    title: 'Smart Reminders',
                    subtitle: 'Never miss seasonal changes',
                  ),
                  const Spacer(),
                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/email-login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Login with your Email',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        final user = await authService.signInWithGoogle();
                        if (user != null && context.mounted) {
                          try {
                            await context
                                .read<UserService>()
                                .createUserAndLinkFamily(user);
                          } catch (e) {
                            debugPrint('Error creating user/family: $e');
                          }
                          if (context.mounted) {
                            context.go('/home');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Continue with Google',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<BiometricService>(
                    builder: (context, biometricService, child) {
                      return FutureBuilder<bool>(
                        future: biometricService.isBiometricLoginEnabled(),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final authenticated =
                                      await biometricService.authenticate();
                                  if (authenticated) {
                                    final creds = await biometricService
                                        .getStoredCredentials();
                                    if (creds != null && context.mounted) {
                                      try {
                                        final authService =
                                            Provider.of<AuthService>(context,
                                                listen: false);
                                        await authService
                                            .signInWithEmailAndPassword(
                                          creds['email']!,
                                          creds['password']!,
                                        );
                                        if (context.mounted) {
                                          context.go('/home');
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Login failed: ${e.toString()}')),
                                          );
                                        }
                                      }
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.2),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                        color: Colors.white
                                            .withValues(alpha: 0.5)),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.fingerprint),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Login with Biometrics',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Footer
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                        children: const [
                          TextSpan(text: 'By continuing, you agree to our '),
                          TextSpan(
                            text: 'Terms of Service',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
