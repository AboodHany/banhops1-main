import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_enums.dart';
import '../../../core/models/trip_record.dart';
import '../../../core/services/trip_repository.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Color _statusColor(TripStatus status) {
    return switch (status) {
      TripStatus.completed => AppTheme.successColor,
      TripStatus.cancelled => AppTheme.errorColor,
      _ => AppTheme.warningColor,
    };
  }

  IconData _statusIcon(TripStatus status) {
    return switch (status) {
      TripStatus.completed => Icons.check_circle_rounded,
      TripStatus.cancelled => Icons.cancel_rounded,
      _ => Icons.pending_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final userId = SupabaseService.client?.auth.currentUser?.id;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('history_log')),
      ),
      body: FutureBuilder<List<TripRecord>>(
        future: TripRepository().fetchHistory(userId: userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          final list = snapshot.data ?? const [];

          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.history_rounded,
                        size: 40,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      localization.locale.languageCode == 'ar'
                          ? 'لا توجد رحلات مسجلة في السجل.'
                          : 'No trips in the history log.',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localization.locale.languageCode == 'ar'
                          ? 'ابدأ رحلتك الأولى من الشاشة الرئيسية'
                          : 'Start your first trip from the home screen',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final trip = list[index];
              final originName =
                  localization.translateLocation(trip.origin.name);
              final destName =
                  localization.translateLocation(trip.destination.name);
              final statusText = trip.status == TripStatus.completed
                  ? (localization.locale.languageCode == 'ar'
                      ? 'مكتملة'
                      : 'COMPLETED')
                  : (trip.status == TripStatus.cancelled
                      ? (localization.locale.languageCode == 'ar'
                          ? 'ملغية'
                          : 'CANCELLED')
                      : (localization.locale.languageCode == 'ar'
                          ? 'قيد التنفيذ'
                          : 'IN PROGRESS'));

              final statusColor = _statusColor(trip.status);

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + index * 70),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: AppTheme.premiumCardDecoration(context),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Route header row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.my_location_rounded,
                                          size: 14,
                                          color: AppTheme.primaryColor),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          originName,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: Container(
                                        width: 1,
                                        height: 10,
                                        color: AppTheme.grey300),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_rounded,
                                          size: 14,
                                          color: AppTheme.secondaryColor),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          destName,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Status badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                    AppTheme.radiusRound),
                                border: Border.all(
                                    color: statusColor.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_statusIcon(trip.status),
                                      color: statusColor, size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        if (trip.routes.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            trip.routes.join(' • '),
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 12),

                        // Info chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _HistoryChip(
                              icon: Icons.payments_outlined,
                              label: localization.translate('cost'),
                              value:
                                  '${trip.estimatedCost.toStringAsFixed(2)} ${localization.translate('egp')}',
                              color: AppTheme.successColor,
                            ),
                            _HistoryChip(
                              icon: Icons.swap_vert_rounded,
                              label: localization.translate('transfers'),
                              value: trip.transfers.toString(),
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
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
  const _HistoryChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
