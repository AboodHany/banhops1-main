import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/transit_route_option.dart';
import '../../../core/models/transit_enums.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/location_node.dart';
import '../../../core/data/demo_transit_catalog.dart';
import '../../../app/app_routes.dart';

/// TripDetailsScreen - Pages 47-48: Trip Details Layout
/// Shows specific step-by-step guidance, pricing for 2026, and Google Maps URL launch button
class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({
    super.key,
    required this.route,
    required this.origin,
    required this.destination,
  });

  final TransitRouteOption route;
  final String origin;
  final String destination;

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final List<LocationNode> _routePoints = [];
  final List<Marker> _markers = [];
  final List<Polyline> _polylines = [];
  final MapController _mapController = MapController();
  bool _mapDataInitialized = false;

  String? _calculatedDistance;
  String? _calculatedDuration;
  bool _isMapRouteLoading = false;

  void _loadRoadRoute() async {
    if (_routePoints.length < 2) return;
    setState(() {
      _isMapRouteLoading = true;
    });

    try {
      final coords = _routePoints.map((p) => '${p.longitude},${p.latitude}').join(';');
      final url = Uri.parse('https://router.project-osrm.org/route/v1/driving/$coords?overview=full&geometries=polyline');
      
      debugPrint('OSRM Request: $url');
      final response = await http.get(url);
      debugPrint('OSRM Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final routeData = data['routes'][0];
          final encodedPolyline = routeData['geometry'] as String;
          final distanceMeters = routeData['distance'] as num;
          final durationSeconds = routeData['duration'] as num;

          debugPrint('OSRM Encoded Polyline: $encodedPolyline');
          final decodedPoints = _decodePolyline(encodedPolyline);
          debugPrint('OSRM Decoded Points Count: ${decodedPoints.length}');
          if (decodedPoints.isNotEmpty) {
            debugPrint('First Point: ${decodedPoints.first}');
            debugPrint('Last Point: ${decodedPoints.last}');
          }

          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                points: decodedPoints,
                color: const Color(0xFF0F4C81),
                strokeWidth: 6,
              ),
            );

            final distanceKm = distanceMeters / 1000.0;
            final durationMins = (durationSeconds / 60.0).round();
            final localeCode = AppLocalizations.of(context).locale.languageCode;

            if (localeCode == 'ar') {
              _calculatedDistance = '${distanceKm.toStringAsFixed(1)} كم';
              _calculatedDuration = '$durationMins دقيقة';
            } else {
              _calculatedDistance = '${distanceKm.toStringAsFixed(1)} km';
              _calculatedDuration = '$durationMins mins';
            }
            _isMapRouteLoading = false;
          });
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _fitPreciseRouteBounds(decodedPoints);
            }
          });
        } else {
          debugPrint('OSRM Response has no routes');
          setState(() {
            _isMapRouteLoading = false;
          });
        }
      } else {
        debugPrint('OSRM Request failed with status: ${response.statusCode}');
        setState(() {
          _isMapRouteLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading road route: $e');
      setState(() {
        _isMapRouteLoading = false;
      });
    }
  }

  void _fitPreciseRouteBounds(List<LatLng> points) {
    if (points.isEmpty) return;
    try {
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(50),
        ),
      );
    } catch (e) {
      debugPrint('Error fitting bounds: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        if (index >= len) return points;
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1)).toSigned(32);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        if (index >= len) return points;
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1)).toSigned(32);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_mapDataInitialized) {
      _initMapData();
      _mapDataInitialized = true;
    }
  }

  void _initMapData() {
    final localization = AppLocalizations.of(context);
    final localeCode = localization.locale.languageCode;
    
    final transferLocs = _getTransferLocations(widget.route.id, localeCode, widget.route.transfers);
    
    LocationNode findNode(String nameOrLabel) {
      return DemoTransitCatalog.locations.firstWhere(
        (l) {
          final normalizedSearch = nameOrLabel.trim().toLowerCase();
          final nameMatch = l.name.trim().toLowerCase() == normalizedSearch;
          final aliasMatch = l.alias?.trim().toLowerCase() == normalizedSearch;
          final transMatch = localization.translateLocation(l.name).trim().toLowerCase() == normalizedSearch;
          return nameMatch || aliasMatch || transMatch;
        },
        orElse: () => LocationNode.empty(),
      );
    }

    final startNode = findNode(widget.origin);
    final endNode = findNode(widget.destination);

    _routePoints.clear();
    _markers.clear();
    _polylines.clear();

    if (startNode.id != 0) {
      _routePoints.add(startNode);
      _markers.add(
        Marker(
          point: LatLng(startNode.latitude, startNode.longitude),
          width: 45,
          height: 45,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0F4C81),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < transferLocs.length; i++) {
      final tLoc = transferLocs[i];
      final tNode = findNode(tLoc);
      if (tNode.id != 0) {
        _routePoints.add(tNode);
        _markers.add(
          Marker(
            point: LatLng(tNode.latitude, tNode.longitude),
            width: 45,
            height: 45,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.alt_route_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      }
    }

    if (endNode.id != 0) {
      _routePoints.add(endNode);
      _markers.add(
        Marker(
          point: LatLng(endNode.latitude, endNode.longitude),
          width: 45,
          height: 45,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1B998B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    if (_routePoints.length >= 2) {
      final polylinePoints = _routePoints.map((node) => LatLng(node.latitude, node.longitude)).toList();
      _polylines.add(
        Polyline(
          points: polylinePoints,
          color: const Color(0xFF0F4C81),
          strokeWidth: 5,
        ),
      );
      _loadRoadRoute();
    }
  }

  void _fitRouteBounds() {
    if (_routePoints.isEmpty) return;
    try {
      final points = _routePoints.map((node) => LatLng(node.latitude, node.longitude)).toList();
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(50),
        ),
      );
    } catch (e) {
      debugPrint('Error fitting route bounds: $e');
    }
  }

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
    final Uri googleMapsUri = Uri.parse(widget.route.gmapsUrl);
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $googleMapsUri');
    }
  }

  List<String> _getTransferLocations(String routeId, String localeCode, int transfers) {
    if (transfers < 1) return const [];
    final isAr = localeCode == 'ar';
    final List<String> locs = [];

    if (routeId.contains('monorail-east-metro-microbus')) {
      locs.addAll(isAr 
          ? ['محطة الإستاد (المونوريل)', 'التمشية الي موقف السلام خلف محطة المترو']
          : ['El-Estad (Monorail)', 'Walk to El-Salam Bus Station behind Metro Station']);
    } else if (routeId.contains('monorail-west-metro-microbus')) {
      locs.addAll(isAr 
          ? ['محطة وادي النيل (المونوريل)', 'التمشية الي موقف السلام خلف محطة المترو']
          : ['Wadi El-Nile (Monorail)', 'Walk to El-Salam Bus Station behind Metro Station']);
    } else if (routeId.contains('monorail-metro-train')) {
      locs.addAll(isAr 
          ? ['محطة الربط (المونوريل)', 'محطة رمسيس (الشهداء)']
          : ['Monorail Interchange', 'Ramses (Al-Shohadaa) Station']);
    } else if (routeId.contains('metro-l1-marg-microbus')) {
      locs.add(isAr ? 'المرج' : 'El-Marg');
    } else if (routeId.contains('metro-l2-shubra-microbus')) {
      locs.add(isAr ? 'محطة مترو مؤسسة' : 'Shubra El-Khaimah (Al-Moassasa)');
    } else if (routeId.contains('metro-l3-adly-microbus') || routeId.contains('lrt-adly-microbus')) {
      locs.add(isAr ? 'التمشية الي موقف السلام خلف محطة المترو' : 'Walk to El-Salam Bus Station behind Metro Station');
    } else if (routeId.contains('train-combined')) {
      locs.add(isAr ? 'محطة رمسيس بالقاهرة' : 'Ramses Train Station, Cairo');
    } else if (routeId.contains('border-eastdelta-combined')) {
      locs.add(isAr ? 'المرج' : 'El-Marg');
    } else if (routeId.contains('border-gobus-classic') || routeId.contains('border-superjet-sharm')) {
      locs.add(isAr ? 'موقف أحمد حلمي بالقاهرة' : 'Ahmed Helmy Hub, Cairo');
    } else if (routeId.contains('border-october-kharga')) {
      locs.add(isAr ? 'موقف الحصري بـ 6 أكتوبر' : 'El-Hosary Hub, 6th of October');
    }

    if (routeId.contains('-suzuki')) {
      locs.add(isAr ? 'موقف بنها' : 'Benha Terminal');
    }

    if (locs.isEmpty && transfers >= 1) {
      locs.add(isAr ? 'محطة تحويل وسطى بالقاهرة' : 'Cairo Transfer Hub');
    }

    return locs;
  }

  List<String> _getLegTransportationModes(String routeId, TransitMode primaryMode, int transfers, String localeCode) {
    final isAr = localeCode == 'ar';
    final List<String> modes = [];

    if (transfers == 0) {
      if (primaryMode == TransitMode.train) {
        modes.add(isAr ? 'قطار' : 'Train');
      } else if (primaryMode == TransitMode.microbus) {
        modes.add(isAr ? 'ميكروباص مباشر' : 'Direct Microbus');
      } else {
        modes.add(isAr ? 'أتوبيس' : 'Bus');
      }
      return modes;
    }

    if (routeId.contains('monorail-east-metro-microbus')) {
      modes.addAll(isAr 
          ? ['مونوريل شرق النيل', 'مترو الخط الثالث', 'ميكروباص']
          : ['Monorail East', 'Metro Line 3', 'Microbus']);
    } else if (routeId.contains('monorail-west-metro-microbus')) {
      modes.addAll(isAr 
          ? ['مونوريل غرب النيل', 'مترو الخط الثالث', 'ميكروباص']
          : ['Monorail West', 'Metro Line 3', 'Microbus']);
    } else if (routeId.contains('monorail-metro-train')) {
      modes.addAll(isAr 
          ? ['مونوريل', 'مترو', 'قطار رمسيس']
          : ['Monorail', 'Metro', 'Ramses Train']);
    } else if (routeId.contains('metro-l1-marg-microbus')) {
      modes.addAll(isAr 
          ? ['مترو الخط الأول', 'ميكروباص']
          : ['Metro Line 1', 'Microbus']);
    } else if (routeId.contains('metro-l2-shubra-microbus') || routeId.contains('metro-l2-shubra-microbus-suzuki')) {
      modes.addAll(isAr 
          ? ['مترو الخط الثاني', 'ميكروباص']
          : ['Metro Line 2', 'Microbus']);
    } else if (routeId.contains('metro-l3-adly-microbus')) {
      modes.addAll(isAr 
          ? ['مترو الخط الثالث', 'ميكروباص']
          : ['Metro Line 3', 'Microbus']);
    } else if (routeId.contains('lrt-adly-microbus')) {
      modes.addAll(isAr 
          ? ['القطار الكهربائي (LRT)', 'ميكروباص']
          : ['LRT Train', 'Microbus']);
    } else if (routeId.contains('train-combined')) {
      modes.addAll(isAr 
          ? ['قطار الصعيد', 'قطار رمسيس - بنها']
          : ['Upper Egypt Train', 'Cairo-Benha Train']);
    } else if (routeId.contains('border-eastdelta-combined') || 
               routeId.contains('border-gobus-classic') || 
               routeId.contains('border-superjet-sharm') ||
               routeId.contains('border-october-kharga')) {
      modes.addAll(isAr 
          ? ['أتوبيس السفر', 'ميكروباص']
          : ['Travel Bus', 'Microbus']);
    }

    if (routeId.contains('-suzuki')) {
      if (modes.isEmpty) {
        modes.add(isAr ? 'ميكروباص مباشر' : 'Direct Microbus');
      }
      modes.add(isAr ? 'سوزوكي داخلي' : 'Internal Suzuki');
    }

    final expectedSegments = transfers + 1;
    while (modes.length < expectedSegments) {
      modes.add(isAr ? 'مواصلة إضافية' : 'Connecting Ride');
    }

    return modes;
  }

  List<double> _getLegCosts(String routeId, double totalCost, int transfers) {
    if (transfers == 0) {
      return [totalCost];
    }

    final List<double> costs = [];
    double remaining = totalCost;

    bool hasSuzuki = routeId.contains('-suzuki');
    if (hasSuzuki) {
      remaining -= 5.0;
    }

    if (routeId.contains('monorail-east-metro-microbus') || routeId.contains('monorail-west-metro-microbus')) {
      final microbus = 28.0;
      final metro = 8.0;
      final monorail = remaining - microbus - metro;
      costs.addAll([monorail, metro, microbus]);
    } else if (routeId.contains('monorail-metro-train')) {
      final train = 35.0;
      final metro = 8.0;
      final monorail = remaining - train - metro;
      costs.addAll([monorail, metro, train]);
    } else if (routeId.contains('metro-l1-marg-microbus')) {
      final microbus = 28.0;
      final metro = remaining - microbus;
      costs.addAll([metro, microbus]);
    } else if (routeId.contains('metro-l2-shubra-microbus')) {
      final microbus = 22.0;
      final metro = remaining - microbus;
      costs.addAll([metro, microbus]);
    } else if (routeId.contains('metro-l3-adly-microbus') || routeId.contains('lrt-adly-microbus')) {
      final microbus = 28.0;
      final metro = remaining - microbus;
      costs.addAll([metro, microbus]);
    } else if (routeId.contains('train-combined')) {
      final train2 = 35.0;
      final train1 = remaining - train2;
      costs.addAll([train1, train2]);
    } else if (routeId.contains('border-eastdelta-combined')) {
      final microbus = 28.0;
      final travel = remaining - microbus;
      costs.addAll([travel, microbus]);
    } else if (routeId.contains('border-gobus-classic') || 
               routeId.contains('border-superjet-sharm') ||
               routeId.contains('border-highjet-hurghada') ||
               routeId.contains('border-superjet-hurghada') ||
               routeId.contains('border-upperegypt-kharga')) {
      final microbus = 26.5;
      final travel = remaining - microbus;
      costs.addAll([travel, microbus]);
    } else if (routeId.contains('border-ostaz-shubra')) {
      final microbus = 21.5;
      final travel = remaining - microbus;
      costs.addAll([travel, microbus]);
    } else if (routeId.contains('border-october-kharga')) {
      final microbus = 60.0;
      final travel = remaining - microbus;
      costs.addAll([travel, microbus]);
    } else {
      final baseLegs = transfers - (hasSuzuki ? 1 : 0) + 1;
      final avg = remaining / baseLegs;
      for (int i = 0; i < baseLegs; i++) {
        costs.add(avg);
      }
    }

    if (hasSuzuki) {
      costs.add(5.0);
    }

    final expectedSegments = transfers + 1;
    while (costs.length < expectedSegments) {
      costs.add(0.0);
    }
    if (costs.length > expectedSegments) {
      costs.removeRange(expectedSegments, costs.length);
    }

    return costs;
  }

  String _getRealGuidance(TransitRouteOption route, String origin, List<String> transferLocs, String destination, String localeCode) {
    final isAr = localeCode == 'ar';
    final buffer = StringBuffer();
    final legModes = _getLegTransportationModes(route.id, route.mode, route.transfers, localeCode);
    final legCosts = _getLegCosts(route.id, route.estimatedCost, route.transfers);

    if (transferLocs.isEmpty) {
      if (route.mode == TransitMode.train) {
        if (isAr) {
          buffer.writeln('1. توجه إلى محطة القطار في $origin.');
          buffer.writeln('2. اقطع تذكرة قطار مباشر إلى محطة قطار بنها بقيمة ${route.estimatedCost.toStringAsFixed(1).replaceAll('.0', '')} جنيه.');
          buffer.writeln('3. اركب القطار المتجه إلى بنها (المدة حوالي ${route.durationMinutes} دقيقة).');
        } else {
          buffer.writeln('1. Head to the train station in $origin.');
          buffer.writeln('2. Purchase a ticket directly to Benha Train Station for ${route.estimatedCost.toStringAsFixed(1).replaceAll('.0', '')} EGP.');
          buffer.writeln('3. Board the train to Benha (duration is approximately ${route.durationMinutes} minutes).');
        }
      } else {
        if (isAr) {
          buffer.writeln('1. اذهب إلى موقف السيارات/الميكروباص الرئيسي في $origin.');
          buffer.writeln('2. استقل ميكروباص مباشر متوجهاً إلى موقف بنها.');
          buffer.writeln('3. الأجرة الرسمية هي ${route.estimatedCost.toStringAsFixed(1).replaceAll('.0', '')} جنيه مصري.');
          buffer.writeln('4. عند الوصول لموقف بنها، تكون قد وصلت لوجهتك.');
        } else {
          buffer.writeln('1. Head to the main microbus/bus terminal in $origin.');
          buffer.writeln('2. Board a direct microbus to Benha Terminal.');
          buffer.writeln('3. The official fare is ${route.estimatedCost.toStringAsFixed(1).replaceAll('.0', '')} EGP.');
          buffer.writeln('4. Upon arriving at Benha Terminal, you have reached your destination.');
        }
      }
      return buffer.toString().trim();
    }

    int step = 1;
    String currentPoint = origin;

    for (int i = 0; i < transferLocs.length; i++) {
      final nextPoint = transferLocs[i];
      final mode = legModes[i];
      final cost = legCosts[i];

      if (isAr) {
        buffer.writeln('$step. استقل ($mode) من $currentPoint متوجهاً إلى $nextPoint (الأجرة الرسمية: ${cost.toStringAsFixed(1).replaceAll('.0', '')} جنيه).');
      } else {
        buffer.writeln('$step. Take ($mode) from $currentPoint to $nextPoint (Official Fare: ${cost.toStringAsFixed(1).replaceAll('.0', '')} EGP).');
      }
      step++;
      currentPoint = nextPoint;
    }

    final lastMode = legModes.last;
    final lastCost = legCosts.last;
    if (isAr) {
      buffer.writeln('$step. استقل ($lastMode) من $currentPoint إلى وجهتك النهائية ($destination) (الأجرة الرسمية: ${lastCost.toStringAsFixed(1).replaceAll('.0', '')} جنيه).');
      buffer.writeln('${step + 1}. الأجرة الرسمية الإجمالية لكافة المراحل هي ${route.estimatedCost.toStringAsFixed(1).replaceAll('.0', '')} جنيه مصري.');
    } else {
      buffer.writeln('$step. Take ($lastMode) from $currentPoint to your final destination ($destination) (Official Fare: ${lastCost.toStringAsFixed(1).replaceAll('.0', '')} EGP).');
      buffer.writeln('${step + 1}. The total official fare for all legs is ${route.estimatedCost.toStringAsFixed(1).replaceAll('.0', '')} EGP.');
    }

    return buffer.toString().trim();
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

  IconData _getModeIcon(String modeText) {
    final t = modeText.toLowerCase();
    if (t.contains('مترو') || t.contains('metro')) {
      return Icons.subway_rounded;
    }
    if (t.contains('قطار') || t.contains('train') || t.contains('lrt') || t.contains('مونوريل') || t.contains('monorail')) {
      return Icons.train_rounded;
    }
    if (t.contains('سوزوكي') || t.contains('suzuki')) {
      return Icons.local_taxi_rounded;
    }
    if (t.contains('أتوبيس') || t.contains('bus')) {
      return Icons.directions_bus_rounded;
    }
    return Icons.directions_bus_filled_rounded;
  }

  Widget _buildTimelineConnector(BuildContext context, Color color, String modeText, double cost) {
    final localization = AppLocalizations.of(context);
    final localeCode = localization.locale.languageCode;
    final isAr = localeCode == 'ar';
    final costText = isAr 
        ? '${cost.toStringAsFixed(1).replaceAll('.0', '')} جنيه'
        : '${cost.toStringAsFixed(1).replaceAll('.0', '')} EGP';

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 17, right: 17),
          child: Container(
            width: 2.5,
            height: 48,
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
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getModeIcon(modeText),
                size: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                '$modeText - $costText',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final route = widget.route;
    final origin = widget.origin;
    final destination = widget.destination;

    final localization = AppLocalizations.of(context);
    final localeCode = localization.locale.languageCode;
    final transferLocs = _getTransferLocations(route.id, localeCode, route.transfers);
    final legModes = _getLegTransportationModes(route.id, route.mode, route.transfers, localeCode);
    final legCosts = _getLegCosts(route.id, route.estimatedCost, route.transfers);
    final realGuidance = _getRealGuidance(route, origin, transferLocs, destination, localeCode);

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
                              legModes[i],
                              legCosts[i],
                            ),
                            _buildTimelineNode(
                              context,
                              icon: Icons.alt_route_rounded,
                              color: Colors.orange,
                              label: '${localization.translate('transfer_point')} ${transferLocs.length > 1 ? (i + 1) : ""}'.trim(),
                              name: transferLocs[i],
                            ),
                          ],
                          _buildTimelineConnector(
                            context,
                            Colors.orange,
                            legModes.last,
                            legCosts.last,
                          ),
                        ] else ...[
                          _buildTimelineConnector(
                            context,
                            const Color(0xFF0F4C81),
                            legModes.first,
                            legCosts.first,
                          ),
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
                  if (_routePoints.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localeCode == 'ar' ? 'خريطة الطريق' : 'Route Map',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 360,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outlineVariant,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Stack(
                              children: [
                                FlutterMap(
                                  mapController: _mapController,
                                  options: MapOptions(
                                    initialCenter: LatLng(_routePoints.first.latitude, _routePoints.first.longitude),
                                    initialZoom: 10.5,
                                    onMapReady: () {
                                      _fitRouteBounds();
                                    },
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.banhops.app',
                                    ),
                                    PolylineLayer(
                                      polylines: _polylines,
                                    ),
                                    MarkerLayer(
                                      markers: _markers,
                                    ),
                                  ],
                                ),
                                if (_calculatedDistance != null && _calculatedDuration != null)
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.15),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.directions_car, size: 16, color: Color(0xFF0F4C81)),
                                              const SizedBox(width: 6),
                                              Text(
                                                _calculatedDistance!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(width: 1, height: 16, color: Colors.grey[300]),
                                          Row(
                                            children: [
                                              const Icon(Icons.access_time, size: 16, color: Color(0xFF0F4C81)),
                                              const SizedBox(width: 6),
                                              Text(
                                                _calculatedDuration!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (_isMapRouteLoading)
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            localeCode == 'ar' ? 'جاري تحميل المسار...' : 'Loading route...',
                                            style: const TextStyle(color: Colors.white, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.routeAiAnalysis,
                          arguments: {
                            'route': widget.route,
                            'origin': widget.origin,
                            'destination': widget.destination,
                          },
                        );
                      },
                      icon: const Icon(Icons.psychology_rounded),
                      label: Text(
                        localeCode == 'ar'
                            ? 'تحليل بواسطة الذكاء الصطناعي'
                            : 'AI Route Analysis',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
