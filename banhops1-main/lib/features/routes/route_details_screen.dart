import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';

class RouteDetailsScreen extends StatelessWidget {
  const RouteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('route_details'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _routeCard(
            context,
            title: l10n.translate('direct_microbus'),
            duration:
                '45 - 60 ${l10n.locale.languageCode == 'ar' ? 'دقيقة' : 'min'}',
            price: l10n.locale.languageCode == 'ar'
                ? '15 - 20 جنيه'
                : '15 - 20 EGP',
            pros: l10n.translate('pros'),
            cons: l10n.translate('cons'),
          ),
          _routeCard(
            context,
            title: l10n.translate('train_nearby'),
            duration:
                '50 ${l10n.locale.languageCode == 'ar' ? 'دقيقة' : 'min'}',
            price: l10n.locale.languageCode == 'ar'
                ? '50 - 120 جنيه'
                : '50 - 120 EGP',
            pros: l10n.translate('pros'),
            cons: l10n.translate('cons'),
          ),
        ],
      ),
    );
  }

  Widget _routeCard(
    BuildContext context, {
    required String title,
    required String duration,
    required String price,
    required String pros,
    required String cons,
  }) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.directions_bus,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.translate('best_match'),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '$duration | $price',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text('$pros: Direct, cheap, and available all day.'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.cancel, color: Colors.red, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('$cons: May be crowded during peak hours.')),
            ],
          ),
        ],
      ),
    );
  }
}
