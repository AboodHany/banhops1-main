import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                _isSignUp
                    ? l10n.translate('sign_up')
                    : l10n.translate('sign_in'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.translate('welcome'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              if (_isSignUp) ...[
                _buildTextField(
                  context,
                  l10n.translate('first_name'),
                  Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  context,
                  l10n.translate('last_name'),
                  Icons.person_outline,
                ),
                const SizedBox(height: 16),
              ],
              _buildTextField(
                context,
                l10n.translate('email'),
                Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context,
                l10n.translate('password'),
                Icons.lock_outline,
                obscureText: true,
              ),
              if (_isSignUp) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  context,
                  l10n.translate('confirm_password'),
                  Icons.lock_outline,
                  obscureText: true,
                ),
              ],
              const SizedBox(height: 20),
              if (!_isSignUp)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(l10n.translate('forgot_password')),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text(
                  _isSignUp
                      ? l10n.translate('sign_up')
                      : l10n.translate('sign_in'),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignUp
                        ? l10n.translate('already_have_account')
                        : l10n.translate('dont_have_account'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _isSignUp = !_isSignUp);
                    },
                    child: Text(
                      _isSignUp
                          ? l10n.translate('sign_in')
                          : l10n.translate('sign_up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    IconData icon, {
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
