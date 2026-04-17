import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';

class TrainScreen extends StatelessWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('train_lines'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('where_are_you_coming_from'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _stationTile(l10n.translate('cairo')),
                  _stationTile(l10n.translate('tanta')),
                  _stationTile(l10n.translate('mansoura')),
                  _stationTile(l10n.translate('minya')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stationTile(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_city, color: AppTheme.primaryColor),
          const SizedBox(width: 14),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}
