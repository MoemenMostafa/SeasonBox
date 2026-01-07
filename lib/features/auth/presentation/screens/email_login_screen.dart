import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/app/theme/theme.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/app/providers/deep_link_provider.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:seasonbox/features/auth/presentation/widgets/animated_background_icon.dart';
import 'package:seasonbox/core/utils/url_helper.dart';
import 'package:flutter/gestures.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<AuthService>(context, listen: false)
            .signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (mounted) {
          final deepLinkProvider =
              Provider.of<DeepLinkProvider>(context, listen: false);
          final redirect = deepLinkProvider.pendingRedirect;
          if (redirect != null) {
            deepLinkProvider.clearPendingRedirect();
            context.go(redirect);
          } else {
            context.go('/home');
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.login_error_invalidCredentials),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.emailLogin_error_emailFirst),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.sendPasswordResetEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.emailLogin_success_passwordReset),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .emailLogin_error_generic(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            top: 300,
            left: 50,
            child: AnimatedBackgroundIcon(
              icon: Icons.umbrella,
              size: 45,
              duration: 3,
            ),
          ),
          const Positioned(
            top: 500,
            right: 30,
            child: AnimatedBackgroundIcon(
              icon: Icons.beach_access,
              size: 40,
              duration: 4,
            ),
          ),
          // Main Content
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)!.emailLogin_title,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.emailLogin_subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 48),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .emailLogin_field_email,
                            hintText: AppLocalizations.of(context)!
                                .emailLogin_field_email,
                            prefixIcon: const Icon(Icons.email_outlined,
                                color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.1),
                            labelStyle: const TextStyle(color: Colors.white70),
                            hintStyle: const TextStyle(color: Colors.white38),
                          ),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .emailLogin_validation_emailRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .emailLogin_field_password,
                            hintText: AppLocalizations.of(context)!
                                .emailLogin_field_password,
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: Colors.white70),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.1),
                            labelStyle: const TextStyle(color: Colors.white70),
                            hintStyle: const TextStyle(color: Colors.white38),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .emailLogin_validation_passwordRequired;
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _resetPassword,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .emailLogin_button_forgotPassword,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!
                                        .emailLogin_button_login,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .register_text_noAccount,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              TextButton(
                                onPressed: () => context.push('/register'),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .register_link_registerNow,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Footer
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                                children: [
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .login_footer_terms),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .login_footer_termsOfService,
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          UrlHelper.launchWebsiteUrl(
                                              context, '/terms'),
                                  ),
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .login_footer_and),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .login_footer_privacyPolicy,
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          UrlHelper.launchWebsiteUrl(
                                              context, '/privacy'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
