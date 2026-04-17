import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('trip_history'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [_historyTile(context, l10n)]),
      ),
    );
  }

  Widget _historyTile(BuildContext context, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('current_location'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.train, color: AppTheme.primaryColor),
              SizedBox(width: 8),
              Text('Line 1 - Cairo Benha'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text('3/10/2026', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
