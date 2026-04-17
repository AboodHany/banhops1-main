import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';

class LanguageScreen extends StatelessWidget {
  final Locale? currentLocale;
  final void Function(String languageCode) onLocaleSelected;

  const LanguageScreen({
    super.key,
    required this.currentLocale,
    required this.onLocaleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = currentLocale?.languageCode;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(
                Icons.location_pin,
                size: 72,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 28),
              Text(
                l10n.translate('choose_language'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.translate('smart_route'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              _languageButton(
                context,
                label: l10n.translate('arabic'),
                selected: selected == 'ar',
                onPressed: () => onLocaleSelected('ar'),
              ),
              const SizedBox(height: 16),
              _languageButton(
                context,
                label: l10n.translate('english'),
                selected: selected == 'en',
                onPressed: () => onLocaleSelected('en'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageButton(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? AppTheme.primaryColor : Colors.white,
        foregroundColor: selected ? Colors.white : Colors.black87,
        elevation: selected ? 6 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}
