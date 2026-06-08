import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/state/auth_controller.dart';
import '../../../app/app_routes.dart';

/// RegisterScreen - User Registration Integration with Railway Auth using original banhops1-main UI
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  bool _hasMinLength = false;
  bool _hasDigit = false;
  bool _hasUppercase = false;
  bool _hasSpecialChar = false;
  bool _isEmailValid = false;
  bool _isPhoneValid = false;

  void _checkPassword(String value) {
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasDigit = value.contains(RegExp(r'[0-9]'));
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
      _hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*()_+|?]'));
    });
  }

  void _checkEmail(String value) {
    final emailRegex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(value.trim());
    });
  }

  void _checkPhone(String value) {
    final phoneRegex = RegExp(r'^01[0125][0-9]{8}$');
    setState(() {
      _isPhoneValid = phoneRegex.hasMatch(value.trim());
    });
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _username.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  String? _required(String? v, String errorMsg) {
    if (v == null || v.trim().isEmpty) return errorMsg;
    return null;
  }

  Future<void> _submit() async {
    if (!_isPhoneValid || !_isEmailValid || !_hasMinLength || !_hasDigit || !_hasUppercase || !_hasSpecialChar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please meet all input requirements first"),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = context.read<AuthController>();
    await auth.signUp(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      username: _username.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      password: _password.text.trim(),
    );

    if (mounted) {
      if (auth.profile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      } else if (auth.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isMet ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isMet ? Colors.green : Colors.redAccent,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isMet ? Colors.green.shade700 : Colors.red.shade400,
                fontWeight: isMet ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
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
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F4C81).withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.person_add_rounded,
                        size: 48,
                        color: Color(0xFF0F4C81),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      localization.translate('register'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create your BanHops account',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 28),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstName,
                                  decoration: InputDecoration(
                                    labelText: localization.translate('first_name'),
                                    prefixIcon: const Icon(Icons.person_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (v) => _required(v, 'First name is required'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastName,
                                  decoration: InputDecoration(
                                    labelText: localization.translate('last_name'),
                                    prefixIcon: const Icon(Icons.person_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (v) => _required(v, 'Last name is required'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
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
                            onChanged: _checkEmail,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Email is required';
                              if (!_isEmailValid) return 'Enter a valid email';
                              return null;
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                            child: Divider(color: Colors.transparent, height: 1),
                          ),
                          _buildRequirementItem("Email format is valid", _isEmailValid),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: const Icon(Icons.phone_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: _checkPhone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Phone number is required';
                              if (!_isPhoneValid) return "Invalid phone number";
                              return null;
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                            child: Divider(color: Colors.transparent, height: 1),
                          ),
                          _buildRequirementItem("Valid Egyptian phone number (01...)", _isPhoneValid),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _password,
                            decoration: InputDecoration(
                              labelText: localization.translate('password'),
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => setState(() => _obscurePass = !_obscurePass),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            obscureText: _obscurePass,
                            onChanged: _checkPassword,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Password is required';
                              if (!_hasMinLength || !_hasDigit || !_hasUppercase || !_hasSpecialChar) {
                                return "Please satisfy all password conditions";
                              }
                              return null;
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                            child: Divider(color: Colors.transparent, height: 1),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRequirementItem("At least 8 characters", _hasMinLength),
                              _buildRequirementItem("At least one digit (0-9)", _hasDigit),
                              _buildRequirementItem("At least one uppercase letter (A-Z)", _hasUppercase),
                              _buildRequirementItem("At least one special character (!@#\$%)", _hasSpecialChar),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPassword,
                            decoration: InputDecoration(
                              labelText: localization.translate('confirm_password'),
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            obscureText: _obscureConfirm,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Confirm password is required';
                              if (v != _password.text) return 'Passwords do not match';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      value: _agreedToTerms,
                      onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                      title: const Text('I agree to Terms & Conditions'),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 20),
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
                        onPressed: (authController.isLoading || !_agreedToTerms) ? null : _submit,
                        child: authController.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(localization.translate('register')),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: localization.translate('login'),
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
