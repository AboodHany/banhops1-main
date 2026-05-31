import 'package:flutter/material.dart';

import '../../../core/data/demo_transit_catalog.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_enums.dart';
import '../../../core/models/trip_record.dart';
import '../../../core/services/trip_repository.dart';
import '../../../core/services/supabase_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final userId = SupabaseService.client?.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('history_log'))),
      body: FutureBuilder<List<TripRecord>>(
        future: TripRepository().fetchHistory(userId: userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0F4C81)),
            );
          }

          final list = snapshot.data ?? const [];
          if (list.isEmpty) {
            return Center(
              child: Text(
                localization.locale.languageCode == 'ar'
                    ? 'لا توجد رحلات مسجلة في السجل.'
                    : 'No trips in the history log.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final trip = list[index];
              
              // Translate location names
              final originName = localization.translateLocation(trip.origin.name);
              final destName = localization.translateLocation(trip.destination.name);
              
              // Localize status
              final statusText = trip.status == TripStatus.completed
                  ? (localization.locale.languageCode == 'ar' ? 'مكتملة' : 'COMPLETED')
                  : (trip.status == TripStatus.cancelled
                      ? (localization.locale.languageCode == 'ar' ? 'ملغية' : 'CANCELLED')
                      : (localization.locale.languageCode == 'ar' ? 'قيد التنفيذ' : 'IN_PROGRESS'));

              return Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$originName ➔ $destName',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        trip.routes.join(' • '),
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _HistoryChip(
                            label: localization.translate('cost'),
                            value: '${trip.estimatedCost.toStringAsFixed(2)} ${localization.translate('egp')}',
                          ),
                          _HistoryChip(
                            label: localization.translate('transfers'),
                            value: trip.transfers.toString(),
                          ),
                          _HistoryChip(
                            label: localization.locale.languageCode == 'ar' ? 'الحالة' : 'Status',
                            value: statusText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
