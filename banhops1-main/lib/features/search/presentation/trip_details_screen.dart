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

  static const List<Map<String, dynamic>> _trainsData = [
    {
      "train_no": "901",
      "type_en": "French AC",
      "type_ar": "مكيف فرنسي",
      "origin": "القاهرة",
      "origin_en": "Cairo",
      "dest": "الإسكندرية",
      "dest_en": "Alexandria",
      "dep_time": "08:15",
      "arr_benha": "08:50",
      "price": 45.0
    },
    {
      "train_no": "911",
      "type_en": "Spanish AC",
      "type_ar": "مكيف إسباني",
      "origin": "القاهرة",
      "origin_en": "Cairo",
      "dest": "الإسكندرية",
      "dest_en": "Alexandria",
      "dep_time": "10:00",
      "arr_benha": "10:35",
      "price": 45.0
    },
    {
      "train_no": "2025",
      "type_en": "Talgo Luxury",
      "type_ar": "تالجو فاخر",
      "origin": "القاهرة",
      "origin_en": "Cairo",
      "dest": "الإسكندرية",
      "dest_en": "Alexandria",
      "dep_time": "08:00",
      "arr_benha": "08:30",
      "price": 70.0
    },
    {
      "train_no": "945",
      "type_en": "Agriculture AC",
      "type_ar": "مكيف زراعي",
      "origin": "القاهرة",
      "origin_en": "Cairo",
      "dest": "بورسعيد",
      "dest_en": "Port Said",
      "dep_time": "06:10",
      "arr_benha": "06:50",
      "price": 35.0
    },
    {
      "train_no": "965",
      "type_en": "Tahya Misr Fast",
      "type_ar": "سريع تحيا مصر",
      "origin": "القاهرة",
      "origin_en": "Cairo",
      "dest": "المنصورة",
      "dest_en": "Mansoura",
      "dep_time": "07:30",
      "arr_benha": "08:15",
      "price": 20.0
    }
  ];

  Future<void> _launchGoogleMaps() async {
    final Uri googleMapsUri = Uri.parse(route.gmapsUrl);
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $googleMapsUri');
    }
  }

  List<String> _getTransferLocations(String routeId, String localeCode, int transfers) {
    if (transfers < 1) return const [];
    final isAr = localeCode == 'ar';

    if (routeId.contains('monorail-east-metro-microbus')) {
      return isAr 
          ? ['محطة الإستاد (المونوريل)', 'التمشية الي موقف السلام خلف محطة المترو']
          : ['El-Estad (Monorail)', 'Walk to El-Salam Bus Station behind Metro Station'];
    }
    if (routeId.contains('monorail-west-metro-microbus')) {
      return isAr 
          ? ['محطة وادي النيل (المونوريل)', 'التمشية الي موقف السلام خلف محطة المترو']
          : ['Wadi El-Nile (Monorail)', 'Walk to El-Salam Bus Station behind Metro Station'];
    }
    if (routeId.contains('monorail-metro-train')) {
      return isAr 
          ? ['محطة الربط (المونوريل)', 'محطة رمسيس (الشهداء)']
          : ['Monorail Interchange', 'Ramses (Al-Shohadaa) Station'];
    }
    if (routeId.contains('metro-l1-marg-microbus')) {
      return isAr ? ['المرج'] : ['El-Marg'];
    }
    if (routeId.contains('metro-l2-shubra-microbus')) {
      return isAr ? ['محطة مترو مؤسسة'] : ['Shubra El-Khaimah (Al-Moassasa)'];
    }
    if (routeId.contains('metro-l3-adly-microbus') || routeId.contains('lrt-adly-microbus')) {
      return isAr ? ['التمشية الي موقف السلام خلف محطة المترو'] : ['Walk to El-Salam Bus Station behind Metro Station'];
    }

    if (routeId.contains('-suzuki')) {
      return isAr ? ['موقف بنها'] : ['Benha'];
    }
    if (routeId.contains('train-combined')) {
      return isAr ? ['محطة رمسيس بالقاهرة'] : ['Ramses Train Station, Cairo'];
    }
    if (routeId.contains('border-eastdelta-combined')) {
      return isAr ? ['المرج'] : ['El-Marg'];
    }
    if (routeId.contains('border-gobus-classic') || routeId.contains('border-superjet-sharm')) {
      return isAr ? ['موقف أحمد حلمي بالقاهرة'] : ['Ahmed Helmy Hub, Cairo'];
    }
    if (routeId.contains('border-october-kharga')) {
      return isAr ? ['موقف الحصري بـ 6 أكتوبر'] : ['El-Hosary Hub, 6th of October'];
    }

    return isAr ? ['محطة تحويل وسطى بالقاهرة'] : ['Cairo Transfer Hub'];
  }

  String _getRealGuidance(TransitRouteOption route, String origin, String destination, String localeCode) {
    final isAr = localeCode == 'ar';
    if (route.mode == TransitMode.train || route.id.contains('train-combined')) {
      if (isAr) {
        return '1. توجه إلى محطة القطار في $origin.\n'
            '2. اقطع تذكرة إلى محطة بنها (أو تذكرة قطار رمسيس ثم تحويل لقطار بنها إذا لم يكن هناك قطار مباشر).\n'
            '3. اركب القطار المتجه شمالاً نحو الدلتا، ورحلتك ستستغرق حوالي ${route.durationMinutes} دقيقة.\n'
            '4. عند الوصول لمحطة قطار بنها، اخرج من المحطة وتوجه إلى موقف السرفيس الداخلي للوصول إلى وجهتك النهائية ($destination).';
      } else {
        return '1. Head to the train station in $origin.\n'
            '2. Book a ticket to Benha (or to Cairo Ramses then transfer to Benha if no direct train is available).\n'
            '3. Board the train heading north towards the Delta; your journey will take approximately ${route.durationMinutes} minutes.\n'
            '4. Upon arriving at Benha Train Station, exit and take a local microbus/taxi to reach your final destination ($destination).';
      }
    } else if (route.mode == TransitMode.microbus) {
      if (isAr) {
        return '1. اذهب إلى موقف الميكروباصات الرئيسي في $origin.\n'
            '2. ابحث عن سيارات ميكروباص متجهة مباشرة إلى "موقف بنها".\n'
            '3. الأجرة الرسمية هي ${route.estimatedCost} جنيه مصري.\n'
            '4. بعد الوصول لموقف بنها، استقل سرفيس داخلي (خط المحطة أو خط الفلل أو الجامعة) للوصول إلى $destination.';
      } else {
        return '1. Head to the main microbus terminal in $origin.\n'
            '2. Find the microbus service heading directly to "Benha Terminal".\n'
            '3. The official fare is ${route.estimatedCost} EGP.\n'
            '4. After arriving at Benha Terminal, take a local transit microbus (University line, Villas line, or Station line) to reach $destination.';
      }
    } else {
      if (isAr) {
        return '1. توجه إلى أقرب موقف أتوبيس عام في $origin.\n'
            '2. اركب الأتوبيس المتجه إلى القاهرة/رمسيس، ثم انتقل لوسيلة مواصلات أخرى متجهة لبنها.\n'
            '3. اتبع الإرشادات المرئية في الخريطة للوصول بأسرع وقت لـ $destination.';
      } else {
        return '1. Head to the nearest public bus terminal in $origin.\n'
            '2. Take the bus heading to Cairo/Ramses, then transfer to a connecting service to Benha.\n'
            '3. Follow the visual path on the map for the fastest route to $destination.';
      }
    }
  }

  void _showTrainsSheet(BuildContext context, String origin, String localeCode) {
    final localization = AppLocalizations.of(context);
    final isAr = localeCode == 'ar';
    
    final matchingTrains = _trainsData.where((train) {
      final trainOrigin = isAr ? train['origin'] : train['origin_en'];
      return origin.toLowerCase().contains(trainOrigin.toString().toLowerCase()) || 
             trainOrigin.toString().toLowerCase().contains(origin.toLowerCase());
    }).toList();

    final trainsToShow = matchingTrains.isNotEmpty ? matchingTrains : _trainsData;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localization.translate('available_trains'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: trainsToShow.length,
                  itemBuilder: (context, index) {
                    final train = trainsToShow[index];
                    final type = isAr ? train['type_ar'] : train['type_en'];
                    final dest = isAr ? train['dest'] : train['dest_en'];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.train_rounded,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${localization.translate('train_no')} ${train['train_no']} ($type)',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isAr 
                                        ? 'القيام: ${train['dep_time']} | الوصول لبنها: ${train['arr_benha']}'
                                        : 'Dep: ${train['dep_time']} | Arr Benha: ${train['arr_benha']}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${train['price']} ${localization.translate('egp')}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector(BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 17, right: 17),
      child: Container(
        width: 2.5,
        height: 24,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.withValues(alpha: 0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final localeCode = localization.locale.languageCode;
    final transferLocs = _getTransferLocations(route.id, localeCode, route.transfers);
    final realGuidance = _getRealGuidance(route, origin, destination, localeCode);

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
                            for (final tLoc in transferLocs) ...[
                              Text(
                                tLoc,
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
                  // Trip Locations (Your Journey Card)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(20),
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
                        if (transferLocs.isNotEmpty) ...[
                          for (var i = 0; i < transferLocs.length; i++) ...[
                            _buildTimelineConnector(
                              context, 
                              i == 0 ? const Color(0xFF0F4C81) : Colors.orange,
                            ),
                            _buildTimelineNode(
                              context,
                              icon: Icons.alt_route_rounded,
                              color: Colors.orange,
                              label: '${localization.translate('transfer_point')} ${transferLocs.length > 1 ? (i + 1) : ""}'.trim(),
                              name: transferLocs[i],
                            ),
                          ],
                          _buildTimelineConnector(context, Colors.orange),
                        ] else ...[
                          _buildTimelineConnector(context, const Color(0xFF0F4C81)),
                        ],
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

                  // Step-by-Step Details (Step-by-Step Guidance Card)
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
                      realGuidance,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  if (route.mode == TransitMode.train || route.id.contains('train-combined')) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _showTrainsSheet(context, origin, localeCode),
                        icon: const Icon(Icons.train_rounded),
                        label: Text(localization.translate('view_train_schedule')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B998B),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/train');
                        },
                        icon: const Icon(Icons.map_rounded),
                        label: Text(
                          localeCode == 'ar'
                              ? 'عرض شبكة خطوط القطارات بالتطبيق'
                              : 'View Train Network Map in App',
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0F4C81)),
                          foregroundColor: const Color(0xFF0F4C81),
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
