import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/transit_route_option.dart';
import '../../../core/models/transit_enums.dart';
import '../../../core/localization/app_localizations.dart';

/// TripDetailsScreen - Pages 47-48: Trip Details Layout
/// Shows specific step-by-step guidance, pricing for 2026, and Google Maps URL launch button
class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({
    super.key,
    required this.route,
    required this.origin,
    required this.destination,
  });

  final TransitRouteOption route;
  final String origin;
  final String destination;

  Future<void> _launchGoogleMaps() async {
    final Uri googleMapsUri = Uri.parse(route.gmapsUrl);
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $googleMapsUri');
    }
  }

  String? _getTransferLocation(String routeId, String localeCode, int transfers) {
    if (transfers < 1) return null;
    final isAr = localeCode == 'ar';
    if (routeId.contains('-suzuki')) {
      return isAr ? 'موقف بنها' : 'Benha Main Bus Terminal';
    }
    if (routeId.contains('train-combined')) {
      return isAr ? 'محطة رمسيس بالقاهرة' : 'Ramses Train Station, Cairo';
    }
    if (routeId.contains('border-eastdelta-combined')) {
      return isAr ? 'موقف المرج / الترجمان بالقاهرة' : 'El-Marg / Turgoman Hub, Cairo';
    }
    if (routeId.contains('border-gobus-classic')) {
      return isAr ? 'موقف أحمد حلمي بالقاهرة' : 'Ahmed Helmy Hub, Cairo';
    }
    if (routeId.contains('border-superjet-sharm')) {
      return isAr ? 'موقف أحمد حلمي بالقاهرة' : 'Ahmed Helmy Hub, Cairo';
    }
    if (routeId.contains('border-ostaz-shubra')) {
      return isAr ? 'موقف المؤسسة بشبرا الخيمة' : 'El-Maza Hub, Shubra El-Kheima';
    }
    if (routeId.contains('border-highjet-hurghada')) {
      return isAr ? 'موقف أحمد حلمي بالقاهرة' : 'Ahmed Helmy Hub, Cairo';
    }
    if (routeId.contains('border-superjet-hurghada')) {
      return isAr ? 'ميدان رمسيس بالقاهرة' : 'Ramses Square, Cairo';
    }
    if (routeId.contains('border-upperegypt-kharga')) {
      return isAr ? 'موقف الترجمان بالقاهرة' : 'Turgoman Hub, Cairo';
    }
    if (routeId.contains('border-october-kharga')) {
      return isAr ? 'موقف الحصري بـ 6 أكتوبر' : 'El-Hosary Hub, 6th of October';
    }
    return isAr ? 'محطة تحويل وسطى بالقاهرة' : 'Cairo Transfer Hub';
  }

  Widget _buildTimelineNode(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String name,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < 2; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Container(
                width: 2,
                height: 6,
                color: Colors.grey[400],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final localeCode = localization.locale.languageCode;
    final transferLoc = _getTransferLocation(route.id, localeCode, route.transfers);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('route_details')),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Route Info
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F4C81), Color(0xFF1B998B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Route Plan / Itinerary showing transfer points
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.alt_route_rounded,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${localization.translate('route_plan')}:',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 4,
                          children: [
                            Text(
                              origin,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Icon(
                                localeCode == 'ar'
                                    ? Icons.keyboard_arrow_left_rounded
                                    : Icons.keyboard_arrow_right_rounded,
                                color: Colors.white70,
                                size: 16,
                              ),
                            ),
                            if (transferLoc != null) ...[
                              Text(
                                transferLoc,
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  localeCode == 'ar'
                                      ? Icons.keyboard_arrow_left_rounded
                                      : Icons.keyboard_arrow_right_rounded,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                              ),
                            ],
                            Text(
                              destination,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatBox(
                        icon: Icons.payments_rounded,
                        label: localization.translate('cost_2026'),
                        value: '${route.estimatedCost} ${localization.translate('egp')}',
                      ),
                      _StatBox(
                        icon: Icons.swap_vert_rounded,
                        label: localization.translate('transfers'),
                        value: route.transfers.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip Locations
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.translate('your_journey'),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimelineNode(
                          context,
                          icon: Icons.my_location,
                          color: const Color(0xFF0F4C81),
                          label: localization.translate('from'),
                          name: origin,
                        ),
                        if (transferLoc != null) ...[
                          _buildTimelineConnector(),
                          _buildTimelineNode(
                            context,
                            icon: Icons.alt_route_rounded,
                            color: Colors.orange,
                            label: localization.translate('transfer_point'),
                            name: transferLoc,
                          ),
                        ],
                        _buildTimelineConnector(),
                        _buildTimelineNode(
                          context,
                          icon: Icons.location_on,
                          color: const Color(0xFF1B998B),
                          label: localization.translate('to'),
                          name: destination,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Step-by-Step Details
                  Text(
                    localization.translate('step_by_step_guidance'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F4C81).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF0F4C81).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      route.details.isEmpty
                          ? localization.translate('detailed_instructions_fallback')
                          : route.details,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  if (route.mode == TransitMode.train || route.id.contains('train-combined')) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final query = localeCode == 'ar'
                              ? 'مواعيد قطارات سكك حديد مصر من $origin إلى $destination'
                              : 'Egypt railway train schedules from $origin to $destination';
                          final Uri trainUri = Uri.parse(
                            'https://www.google.com/search?q=${Uri.encodeComponent(query)}',
                          );
                          if (await canLaunchUrl(trainUri)) {
                            await launchUrl(trainUri, mode: LaunchMode.externalApplication);
                          }
                        },
                        icon: const Icon(Icons.train_rounded),
                        label: Text(
                          localeCode == 'ar'
                              ? 'الاستعلام عن مواعيد القطارات - سكك حديد مصر'
                              : 'Inquire Train Schedules - ENR Portal',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B998B),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Pricing 2026
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B998B).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF1B998B).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.translate('cost_2026'),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${localization.translate('cost')}:',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              '${route.estimatedCost} ${localization.translate('egp')}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B998B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localization.translate('price_estimate_disclaimer'),
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _launchGoogleMaps,
                      icon: const Icon(Icons.map_rounded),
                      label: Text(localization.translate('view_on_google_maps')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: Text(localization.translate('back_to_results')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
