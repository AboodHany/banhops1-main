import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/state/auth_controller.dart';
import '../../../app/app_routes.dart';

/// LoginScreen - Page 41: User Login Integration with Railway Auth using original banhops1-main UI
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final authController = context.watch<AuthController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF4F7FB), Color(0xFFE9F3FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.directions_bus_filled_rounded,
                          size: 48,
                          color: Color(0xFF0F4C81),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      localization.translate('welcome'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'BanHops',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: const Color(0xFF0F4C81),
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localization.translate('login_intro_subtitle'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: localization.translate('username'),
                              prefixIcon: const Icon(Icons.person_outline_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return localization.translate('username_required');
                              }
                              if (value.trim().length < 4) {
                                return localization.translate('username_length_error');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: localization.translate('password'),
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localization.translate('password_required');
                              }
                              if (value.length < 8) {
                                return localization.translate('password_length_error');
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
                        },
                        child: Text(
                          localization.translate('forgot_password'),
                          style: const TextStyle(
                            color: Color(0xFF0F4C81),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (authController.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.redAccent, width: 0.5),
                          ),
                          child: Text(
                            authController.errorMessage!,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: authController.isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                await context.read<AuthController>().signIn(
                                      username: _usernameController.text.trim(),
                                      password: _passwordController.text,
                                    );

                                if (context.mounted &&
                                    context.read<AuthController>().profile != null) {
                                  Navigator.of(context)
                                      .pushReplacementNamed(AppRoutes.main);
                                }
                              },
                        child: authController.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(localization.translate('login')),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: authController.isLoading
                          ? null
                          : () async {
                              await context.read<AuthController>().signInAsGuest();
                              if (context.mounted) {
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.main);
                              }
                            },
                      icon: const Icon(Icons.person_outline_rounded),
                      label: Text(localization.translate('guest_mode')),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed(AppRoutes.register),
                      child: RichText(
                        text: TextSpan(
                          text: localization.translate('dont_have_account_prompt'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: localization.translate('register'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: const Color(0xFF0F4C81),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            localization.translate('or'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _SocialButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: localization.translate('google'),
                      onPressed: authController.isLoading
                          ? null
                          : () async {
                              await context.read<AuthController>().signInWithGoogle();
                              if (context.mounted &&
                                  context.read<AuthController>().profile != null) {
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.main);
                              }
                            },
                    ),
                    const SizedBox(height: 10),
                    _SocialButton(
                      icon: Icons.facebook_rounded,
                      label: localization.translate('facebook'),
                      onPressed: authController.isLoading
                          ? null
                          : () async {
                              await context.read<AuthController>().signInWithFacebook();
                              if (context.mounted &&
                                  context.read<AuthController>().profile != null) {
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.main);
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
