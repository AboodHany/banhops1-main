import 'package:flutter/material.dart';
import '../../../core/services/forgot_password_service.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../app/app_routes.dart';

enum _Step { credentials, showPassword }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _Step _step = _Step.credentials;

  final _credentialsKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  String _recoveredPassword = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    super.dispose();
  }

  String _title(AppLocalizations localization) {
    switch (_step) {
      case _Step.credentials:
        return localization.translate('forgot_password');
      case _Step.showPassword:
        return 'Password Recovery';
    }
  }

  String _description(AppLocalizations localization) {
    switch (_step) {
      case _Step.credentials:
        return 'Enter your registered username and email address';
      case _Step.showPassword:
        return 'Your recovered password is:';
    }
  }

  void _handleBack() {
    if (_step == _Step.credentials) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step = _Step.credentials);
    }
  }

  String? _required(String? v, String message) {
    if (v == null || v.trim().isEmpty) return message;
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final r = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');
    if (!r.hasMatch(v.trim())) return 'Invalid email address';
    return null;
  }

  Future<void> _submitCredentials() async {
    if (!(_credentialsKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      final password = await ForgotPasswordService.recoverPassword(
        username: _username.text.trim(),
        email:    _email.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _recoveredPassword = password;
        _step = _Step.showPassword;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
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
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F4C81)),
                  onPressed: _handleBack,
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F4C81).withAlpha(20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.lock_open_rounded,
                            size: 48,
                            color: Color(0xFF0F4C81),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          _title(localization),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _description(localization),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 28),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: KeyedSubtree(
                            key: ValueKey(_step),
                            child: _buildStepContent(localization),
                          ),
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
    );
  }

  Widget _buildStepContent(AppLocalizations localization) {
    switch (_step) {
      case _Step.credentials:
        return _buildCredentials(localization);
      case _Step.showPassword:
        return _buildShowPassword();
    }
  }

  Widget _buildCredentials(AppLocalizations localization) {
    return Form(
      key: _credentialsKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _username,
            decoration: InputDecoration(
              labelText: 'Username',
              prefixIcon: const Icon(Icons.person_outline_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (v) => _required(v, 'Username is required'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _email,
            decoration: InputDecoration(
              labelText: localization.translate('email'),
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitCredentials,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('SUBMIT'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF86EFAC)),
          ),
          child: Column(
            children: [
              const Icon(Icons.lock_open_rounded,
                  color: Color(0xFF16A34A), size: 48),
              const SizedBox(height: 16),
              const Text(
                'YOUR PASSWORD',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF15803D),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _recoveredPassword,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14532D),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
            child: const Text('LOG IN'),
          ),
        ),
      ],
    );
  }
}
