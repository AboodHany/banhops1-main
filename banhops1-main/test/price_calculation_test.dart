import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:banhops1/core/models/location_node.dart';
import 'package:banhops1/core/models/microbus_line.dart';
import 'package:banhops1/core/models/transit_enums.dart';
import 'package:banhops1/core/services/trip_manager.dart';

void main() {
  test('Microbus price calculation test for Obour -> Benha', () {
    // 1. Load microbuses from local JSON file
    final file = File('benha_microbuses.json');
    final jsonString = file.readAsStringSync();
    final localData = json.decode(jsonString) as List<dynamic>;
    final List<MicrobusLine> microbuses = [];
    for (final catData in localData) {
      final category = catData['category'] as String? ?? '';
      final lines = catData['lines'] as List<dynamic>? ?? [];
      for (final lineJson in lines) {
        final lineMap = lineJson as Map<String, dynamic>;
        microbuses.add(MicrobusLine(
          id: microbuses.length + 1,
          category: category,
          lineNo: lineMap['line_no'] as int? ?? 0,
          route: lineMap['route'] as String? ?? '',
          fare: (lineMap['fare'] as num?)?.toDouble() ?? 0.0,
        ));
      }
    }

    // 2. Setup origin and destination
    const origin = LocationNode(
      id: 308,
      name: 'Al-Obour',
      latitude: 30.2089,
      longitude: 31.4789,
      type: TransitLocationType.hub,
      alias: 'Obour City',
      governorate: 'Qalyubia',
    );

    const destination = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    // 3. Evaluate route
    const manager = TripManager();
    final result = manager.evaluate(
      origin: origin,
      destination: destination,
      microbuses: microbuses,
    );

    // 4. Print results
    print('Routes found:');
    for (final route in result.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP');
    }

    // Find the microbus route
    final microbusRoutes = result.routes.where((r) => r.mode == TransitMode.microbus).toList();
    expect(microbusRoutes.isNotEmpty, true);
    
    // Check that we matched the database microbus, which has a fare of 41.0 or 45.0
    final hasOfficialFare = microbusRoutes.any((r) => r.estimatedCost == 41.0 || r.estimatedCost == 45.0);
    expect(hasOfficialFare, true);
  });

  test('Train routing test for Minya El-Qamh -> Benha Train Station', () {
    const origin = LocationNode(
      id: 361,
      name: 'Minya El-Qamh',
      latitude: 30.5119,
      longitude: 31.3465,
      type: TransitLocationType.station,
      alias: 'Minya El-Qamh Station',
      governorate: 'Sharqia',
    );

    const destination = LocationNode(
      id: 102,
      name: 'Benha Train Station',
      latitude: 30.4607,
      longitude: 31.1865,
      type: TransitLocationType.station,
      alias: 'Rail Hub',
      governorate: 'Qalyubia',
    );

    final List<Map<String, dynamic>> trains = [
      {
        "train_no": "944",
        "type": "سريع تحيا مصر",
        "type_en": "Tahya Misr Fast",
        "origin": "منية القمح",
        "origin_en": "Minya El-Qamh",
        "dest": "بنها",
        "dest_en": "Benha",
        "dep_time": "06:30",
        "arr_benha": "07:00",
        "price": 10.0,
        "duration": 30
      },
      {
        "train_no": "946",
        "type": "سريع تحيا مصر",
        "type_en": "Tahya Misr Fast",
        "origin": "منية القمح",
        "origin_en": "Minya El-Qamh",
        "dest": "بنها",
        "dest_en": "Benha",
        "dep_time": "17:30",
        "arr_benha": "18:00",
        "price": 10.0,
        "duration": 30
      }
    ];

    const manager = TripManager();
    final result = manager.evaluate(
      origin: origin,
      destination: destination,
      trains: trains,
    );

    print('Routes from Minya El-Qamh:');
    for (final route in result.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP');
    }

    final trainRoutes = result.routes.where((r) => r.mode == TransitMode.train).toList();
    expect(trainRoutes.isNotEmpty, true);
    expect(trainRoutes.any((r) => r.title.contains('Egypt Railway Train') && r.estimatedCost == 10.0), true);
  });

  test('Border governorate bus routing test for Arish -> Benha & Hurghada -> Benha', () {
    const arishOrigin = LocationNode(
      id: 419,
      name: 'Arish',
      latitude: 31.1321,
      longitude: 33.8032,
      type: TransitLocationType.hub,
      alias: 'North Sinai Capital',
      governorate: 'North Sinai',
    );

    const hurghadaOrigin = LocationNode(
      id: 416,
      name: 'Hurghada',
      latitude: 27.2579,
      longitude: 33.8116,
      type: TransitLocationType.hub,
      alias: 'Red Sea Capital',
      governorate: 'Red Sea',
    );

    const destination = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    const manager = TripManager();

    // Test Arish
    final arishResult = manager.evaluate(
      origin: arishOrigin,
      destination: destination,
    );

    print('Routes from Arish:');
    for (final route in arishResult.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP');
    }

    final arishBorderBuses = arishResult.routes.where((r) => r.mode == TransitMode.borderBus).toList();
    expect(arishBorderBuses.length, 2);
    // MCV Direct Bus (165 EGP) and East Delta Bus + Microbus (50 EGP)
    expect(arishBorderBuses.any((r) => r.estimatedCost == 165.0), true);
    expect(arishBorderBuses.any((r) => r.estimatedCost == 50.0), true);

    // Test Hurghada
    final hurghadaResult = manager.evaluate(
      origin: hurghadaOrigin,
      destination: destination,
    );

    print('Routes from Hurghada:');
    for (final route in hurghadaResult.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP');
    }

    final hurghadaBorderBuses = hurghadaResult.routes.where((r) => r.mode == TransitMode.borderBus).toList();
    expect(hurghadaBorderBuses.length, 2);
    // Go Bus / High Jet Economy (206.5 EGP) and Super Jet / Go Bus Deluxe (251.5 EGP)
    expect(hurghadaBorderBuses.any((r) => r.estimatedCost == 206.5), true);
    expect(hurghadaBorderBuses.any((r) => r.estimatedCost == 251.5), true);
  });

  test('Dynamic Suzuki leg appending for Obour -> Colleges Complex', () {
    final file = File('benha_microbuses.json');
    final jsonString = file.readAsStringSync();
    final localData = json.decode(jsonString) as List<dynamic>;
    final List<MicrobusLine> microbuses = [];
    for (final catData in localData) {
      final category = catData['category'] as String? ?? '';
      final lines = catData['lines'] as List<dynamic>? ?? [];
      for (final lineJson in lines) {
        final lineMap = lineJson as Map<String, dynamic>;
        microbuses.add(MicrobusLine(
          id: microbuses.length + 1,
          category: category,
          lineNo: lineMap['line_no'] as int? ?? 0,
          route: lineMap['route'] as String? ?? '',
          fare: (lineMap['fare'] as num?)?.toDouble() ?? 0.0,
        ));
      }
    }

    const origin = LocationNode(
      id: 308,
      name: 'Al-Obour',
      latitude: 30.2089,
      longitude: 31.4789,
      type: TransitLocationType.hub,
      alias: 'Obour City',
      governorate: 'Qalyubia',
    );

    const destination = LocationNode(
      id: 103,
      name: 'Colleges Complex (Commerce - Arts)',
      latitude: 30.4613,
      longitude: 31.1803,
      type: TransitLocationType.university,
      alias: 'Colleges Complex',
      governorate: 'Qalyubia',
    );

    const manager = TripManager();
    final result = manager.evaluate(
      origin: origin,
      destination: destination,
      microbuses: microbuses,
    );

    print('Routes found to Colleges Complex:');
    for (final route in result.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP, Transfers: ${route.transfers}');
    }

    final microbusRoutes = result.routes.where((r) => r.mode == TransitMode.microbus).toList();
    expect(microbusRoutes.isNotEmpty, true);
    
    final hasOfficialSuzukiFare = microbusRoutes.any((r) => r.estimatedCost == 46.0 || r.estimatedCost == 50.0);
    expect(hasOfficialSuzukiFare, true);

    expect(microbusRoutes.any((r) => r.transfers == 1), true);
    expect(microbusRoutes.any((r) => r.title.contains('Suzuki') || r.title.contains('سوزوكي')), true);
  });

  test('Metro Line 1 routing test for Helwan University -> Benha', () {
    const origin = LocationNode(
      id: 603,
      name: 'Helwan University',
      latitude: 29.8660,
      longitude: 31.3150,
      type: TransitLocationType.station,
      alias: 'Metro Line 1',
      governorate: 'Cairo',
    );

    const destination = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    const manager = TripManager();
    final result = manager.evaluate(
      origin: origin,
      destination: destination,
    );

    print('Routes from Helwan University:');
    for (final route in result.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP, Transfers: ${route.transfers}');
    }

    expect(result.routes.isNotEmpty, true);
    expect(result.routes.any((r) => r.title.contains('Direct Microbus') || r.title.contains('ميكروباص مباشر')), false);
    
    // Helwan University is Line 1. Should have exactly 1 simplified rail option:
    // Route B (via El-Marg): Metro 30 stations (20 EGP) + Microbus (28 EGP) = 48.0 EGP
    expect(result.routes.length, 1);
    expect(result.routes.any((r) => r.id.contains('metro-l1-marg-microbus') && r.estimatedCost == 48.0), true);
  });

  test('LRT routing test for El-Shorouk -> Benha', () {
    const origin = LocationNode(
      id: 901,
      name: 'El-Shorouk',
      latitude: 30.1410,
      longitude: 31.6320,
      type: TransitLocationType.station,
      alias: 'LRT Line',
      governorate: 'Cairo',
    );

    const destination = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    const manager = TripManager();
    final result = manager.evaluate(
      origin: origin,
      destination: destination,
    );

    print('Routes from El-Shorouk LRT:');
    for (final route in result.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP, Transfers: ${route.transfers}');
    }

    expect(result.routes.isNotEmpty, true);
    // El-Shorouk LRT is 3 stations to Adly Mansour (10 EGP) + Microbus (28 EGP) = 38.0 EGP
    expect(result.routes.any((r) => r.id.contains('lrt-adly-microbus') && r.estimatedCost == 38.0), true);
    expect(result.routes.any((r) => r.title.contains('Direct Microbus') || r.title.contains('ميكروباص مباشر')), false);
  });

  test('Monorail West routing test for Hyper One -> Benha', () {
    const origin = LocationNode(
      id: 1102,
      name: 'Hyper One',
      latitude: 30.0150,
      longitude: 30.9850,
      type: TransitLocationType.station,
      alias: 'West Monorail',
      governorate: 'Giza',
    );

    const destination = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    const manager = TripManager();
    final result = manager.evaluate(
      origin: origin,
      destination: destination,
    );

    print('Routes from Hyper One Monorail:');
    for (final route in result.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP, Transfers: ${route.transfers}');
    }

    expect(result.routes.isNotEmpty, true);
    // Hyper One: 5 stations Monorail (20 EGP) + 30 stations Metro (20 EGP) + Microbus (28 EGP) = 68.0 EGP
    expect(result.routes.any((r) => r.id.contains('monorail-west-metro-microbus') && r.estimatedCost == 68.0), true);
    expect(result.routes.any((r) => r.title.contains('Direct Microbus') || r.title.contains('ميكروباص مباشر')), false);
  });

  test('Metro Line 2 routing test for Cairo University -> Benha', () {
    const origin = LocationNode(
      id: 706,
      name: 'Cairo University',
      latitude: 30.0260,
      longitude: 31.2010,
      type: TransitLocationType.station,
      alias: 'Metro Line 2',
      governorate: 'Giza',
    );

    const destination = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    const manager = TripManager();
    final result = manager.evaluate(
      origin: origin,
      destination: destination,
    );

    print('Routes from Cairo University:');
    for (final route in result.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP, Transfers: ${route.transfers}');
    }

    expect(result.routes.isNotEmpty, true);
    // Cairo University is a transfer station on Line 2 and Line 3. It should have 2 options:
    // Route A (via Shubra): Metro 14 stations (12 EGP) + Microbus (22 EGP) = 34.0 EGP
    // Route B (via Adly Mansour): Metro 33 stations (20 EGP) + Microbus (28 EGP) = 48.0 EGP
    expect(result.routes.length, 2);
    expect(result.routes.any((r) => r.id.contains('metro-l2-shubra-microbus') && r.estimatedCost == 34.0), true);
    expect(result.routes.any((r) => r.id.contains('metro-l3-adly-microbus') && r.estimatedCost == 48.0), true);
  });

  test('One-Way Routing constraint test (Benha -> Helwan University)', () {
    const origin = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    const destination = LocationNode(
      id: 601,
      name: 'Helwan University',
      latitude: 29.8660,
      longitude: 31.3150,
      type: TransitLocationType.station,
      alias: 'Metro Line 1',
      governorate: 'Cairo',
    );

    const manager = TripManager();
    final result = manager.evaluate(
      origin: origin,
      destination: destination,
    );

    print('Routes from Benha to Helwan University (should be empty):');
    for (final route in result.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP');
    }

    // Since we only support one-way routes (origin -> Benha) for stations,
    // a pure station as destination should return no routes.
    expect(result.routes.isEmpty, true);
  });

  test('Ramses / Ahmed Helmy multi-option routing test', () {
    const shohadaaOrigin = LocationNode(
      id: 622,
      name: 'Al-Shohadaa Metro',
      latitude: 30.0617,
      longitude: 31.2467,
      type: TransitLocationType.station,
      alias: 'Metro Line 1/2 Ramses',
      governorate: 'Cairo',
    );

    const helmyOrigin = LocationNode(
      id: 201,
      name: 'Ahmed Helmy',
      latitude: 30.0631,
      longitude: 31.2467,
      type: TransitLocationType.hub,
      alias: 'Ramses Area',
      governorate: 'Cairo',
    );

    const destination = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    final List<Map<String, dynamic>> trains = [
      {
        "train_no": "901",
        "type": "مكيف فرنسي",
        "type_en": "French AC",
        "origin": "القاهرة",
        "origin_en": "Cairo",
        "dest": "الإسكندرية",
        "dest_en": "Alexandria",
        "dep_time": "08:15",
        "arr_benha": "08:50",
        "price": 45.0,
        "duration": 35
      }
    ];

    const manager = TripManager();

    // 1. Al-Shohadaa Metro (Ramses Metro)
    final shohadaaResult = manager.evaluate(
      origin: shohadaaOrigin,
      destination: destination,
      trains: trains,
    );

    print('Routes from Al-Shohadaa Metro:');
    for (final route in shohadaaResult.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP');
    }

    // Expecting 3 routes: Metro Line 1 (via El-Marg) + Metro Line 2 (via Shubra) + Train from Ramses
    expect(shohadaaResult.routes.length, 3);
    expect(shohadaaResult.routes.any((r) => r.mode == TransitMode.train && r.title.contains('Ramses')), true);
    expect(shohadaaResult.routes.any((r) => r.id.contains('metro-l1-marg-microbus')), true);
    expect(shohadaaResult.routes.any((r) => r.id.contains('metro-l2-shubra-microbus')), true);

    // 2. Ahmed Helmy (Ramses Hub)
    final helmyResult = manager.evaluate(
      origin: helmyOrigin,
      destination: destination,
      trains: trains,
    );

    print('Routes from Ahmed Helmy:');
    for (final route in helmyResult.routes) {
      print('- ${route.title}: Mode: ${route.mode}, Fare: ${route.estimatedCost} EGP');
    }

    // Expecting at least 2 routes: Train + Direct/Fallback Microbus
    expect(helmyResult.routes.any((r) => r.mode == TransitMode.train && (r.title.contains('Ramses') || r.title.contains('Cairo'))), true);
    expect(helmyResult.routes.any((r) => r.mode == TransitMode.microbus), true);
  });

  test('El-Marg & Shubra terminal metro route exclusion test', () {
    const margOrigin = LocationNode(
      id: 634,
      name: 'El-Marg',
      latitude: 30.1518,
      longitude: 31.3364,
      type: TransitLocationType.hub,
      alias: 'Marg Metro',
      governorate: 'Cairo',
    );

    const shubraOrigin = LocationNode(
      id: 720,
      name: 'Shubra Al-Khaimah',
      latitude: 30.1256,
      longitude: 31.2467,
      type: TransitLocationType.hub,
      alias: 'Metro Shubra',
      governorate: 'Qalyubia',
    );

    const destination = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    const manager = TripManager();

    // 1. El-Marg: should not return a Metro Line 1 option (0 stations)
    final margResult = manager.evaluate(origin: margOrigin, destination: destination);
    print('Routes from El-Marg:');
    for (final r in margResult.routes) {
      print('- ${r.title}: ${r.mode}');
    }
    expect(margResult.routes.any((r) => r.id.contains('metro-l1-marg-microbus')), false);

    // 2. Shubra Al-Khaimah: should not return a Metro Line 2 option (0 stations)
    final shubraResult = manager.evaluate(origin: shubraOrigin, destination: destination);
    print('Routes from Shubra Al-Khaimah:');
    for (final r in shubraResult.routes) {
      print('- ${r.title}: ${r.mode}');
    }
    expect(shubraResult.routes.any((r) => r.id.contains('metro-l2-shubra-microbus')), false);
  });

  test('El-Obour fallback fare verification test', () {
    const obourOrigin = LocationNode(
      id: 308,
      name: 'Al-Obour',
      latitude: 30.2089,
      longitude: 31.4789,
      type: TransitLocationType.hub,
      alias: 'Obour City',
      governorate: 'Qalyubia',
    );

    const destination = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    const manager = TripManager();

    // Evaluate without DB lines (triggers fallback pricing)
    final result = manager.evaluate(
      origin: obourOrigin,
      destination: destination,
      microbuses: const [], // Force fallback
    );

    print('Fallback routes from El-Obour:');
    for (final r in result.routes) {
      print('- ${r.title}: Mode: ${r.mode}, Cost: ${r.estimatedCost} EGP');
    }

    final fallbackMicrobus = result.routes.firstWhere((r) => r.id.contains('microbus-308-101'));
    // Fallback price for Obour (308) should be 41.0 EGP
    expect(fallbackMicrobus.estimatedCost, 41.0);
  });
}
