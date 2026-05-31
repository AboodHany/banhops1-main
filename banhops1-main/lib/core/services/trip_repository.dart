import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/demo_transit_catalog.dart';
import '../models/location_node.dart';
import '../models/trip_record.dart';
import '../models/transit_enums.dart';
import '../models/microbus_line.dart';
import 'supabase_service.dart';

class TripRepository {
  static const String _tableName = 'trips';

  Future<List<TripRecord>> fetchHistory({String? userId}) async {
    final client = SupabaseService.client;

    if (client == null) {
      return DemoTransitCatalog.history;
    }

    try {
      final query = client.from(_tableName).select();

      if (userId != null) {
        query.eq('user_id', userId);
      }

      final response = await query.order('created_at', ascending: false);
      final tripsList = response as List<dynamic>;

      final List<TripRecord> records = [];
      for (final json in tripsList) {
        final originId = json['origin_id'] as int? ?? 0;
        final destId = json['dest_id'] as int? ?? 0;

        // Resolve location nodes from local catalog or construct safe fallback
        final origin = DemoTransitCatalog.locations.firstWhere(
          (loc) => loc.id == originId,
          orElse: () => LocationNode(
            id: originId,
            name: 'Unknown Location',
            latitude: 0,
            longitude: 0,
            type: TransitLocationType.hub,
          ),
        );

        final destination = DemoTransitCatalog.locations.firstWhere(
          (loc) => loc.id == destId,
          orElse: () => LocationNode(
            id: destId,
            name: 'Unknown Location',
            latitude: 0,
            longitude: 0,
            type: TransitLocationType.hub,
          ),
        );

        // Fetch routes for this trip
        final routesResponse = await client
            .from('routes')
            .select('details')
            .eq('trip_id', json['id']);
        final routesList = (routesResponse as List<dynamic>)
            .map((r) => r['details'] as String)
            .toList();

        records.add(TripRecord(
          id: json['id'] as int? ?? 0,
          origin: origin,
          destination: destination,
          estimatedTime: json['est_time'] as int? ?? 0,
          estimatedCost: (json['est_cost'] as num?)?.toDouble() ?? 0.0,
          transfers: json['transfers'] as int? ?? 0,
          status: TripStatusLabel.fromString(json['status'] as String? ?? 'COMPLETED'),
          createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
          routes: routesList.isNotEmpty ? routesList : const ['Trip Route'],
        ));
      }

      return records;
    } catch (e) {
      print('Error fetching trip history: $e');
      return DemoTransitCatalog.history;
    }
  }

  Future<int> countCompletedTrips({String? userId}) async {
    final client = SupabaseService.client;

    if (client == null) {
      return DemoTransitCatalog.history.where((trip) => getTripStatusLabel(trip.status) == 'COMPLETED').length;
    }

    try {
      final query = client.from(_tableName).select();

      if (userId != null) {
        query.eq('user_id', userId);
      }

      query.eq('status', 'COMPLETED');

      final response = await query.count();
      return response.count ?? 0;
    } catch (e) {
      print('Error counting completed trips: $e');
      return 0;
    }
  }

  Future<void> saveTrip(TripRecord trip, {String? userId}) async {
    final client = SupabaseService.client;
    if (client == null) return;

    try {
      final targetUserId = userId ?? client.auth.currentUser?.id;
      if (targetUserId == null) {
        return; // Unauthenticated guest can't write to table with FK references users
      }

      // 1. Ensure locations exist in database to satisfy foreign keys
      await _ensureLocationExists(client, trip.origin);
      await _ensureLocationExists(client, trip.destination);

      // 2. Insert trip row
      final tripData = {
        'user_id': targetUserId,
        'origin_id': trip.origin.id,
        'dest_id': trip.destination.id,
        'est_time': trip.estimatedTime,
        'est_cost': trip.estimatedCost,
        'transfers': trip.transfers,
        'status': trip.status.name.toUpperCase(),
        'created_at': trip.createdAt.toIso8601String(),
      };

      final response = await client.from(_tableName).insert(tripData).select('id').single();
      final tripId = response['id'] as int;

      // 3. Insert routes
      for (final routeDetail in trip.routes) {
        await client.from('routes').insert({
          'trip_id': tripId,
          'details': routeDetail,
          'mode': 'MICROBUS',
          'gmaps_url': 'https://www.google.com/maps',
        });
      }
    } catch (e) {
      print('Error saving trip: $e');
    }
  }

  Future<void> _ensureLocationExists(SupabaseClient client, LocationNode loc) async {
    try {
      await client.from('locations').upsert({
        'id': loc.id,
        'name': loc.name,
        'coordinates': 'point(${loc.longitude}, ${loc.latitude})',
        'type': _mapLocationType(loc.type),
      });
    } catch (e) {
      print('Error ensuring location exists in Supabase: $e');
    }
  }

  String _mapLocationType(TransitLocationType type) {
    return switch (type) {
      TransitLocationType.university => 'University',
      TransitLocationType.hospital => 'Hospital',
      TransitLocationType.station => 'Station',
      TransitLocationType.hub => 'Hub',
      TransitLocationType.restaurant => 'Restaurant',
      TransitLocationType.cafe => 'Cafe',
    };
  }

  Future<List<MicrobusLine>> fetchMicrobusLines() async {
    final client = SupabaseService.client;
    if (client != null) {
      try {
        final response = await client.from('microbuses').select();
        final list = (response as List<dynamic>)
            .map((json) => MicrobusLine.fromJson(json as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) {
          return list;
        }
      } catch (e) {
        print('Error fetching microbuses from Supabase: $e');
      }
    }

    try {
      final jsonString = await rootBundle.loadString('benha_microbuses.json');
      final localData = json.decode(jsonString) as List<dynamic>;
      final List<MicrobusLine> list = [];
      for (final catData in localData) {
        final category = catData['category'] as String? ?? '';
        final lines = catData['lines'] as List<dynamic>? ?? [];
        for (final lineJson in lines) {
          final lineMap = lineJson as Map<String, dynamic>;
          list.add(MicrobusLine(
            id: list.length + 1,
            category: category,
            lineNo: lineMap['line_no'] as int? ?? 0,
            route: lineMap['route'] as String? ?? '',
            fare: (lineMap['fare'] as num?)?.toDouble() ?? 0.0,
          ));
        }
      }
      return list;
    } catch (e) {
      print('Error loading local microbuses fallback: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchTrainLines() async {
    final client = SupabaseService.client;
    if (client == null) {
      return [];
    }

    try {
      final response = await client.from('trains').select();
      return (response as List<dynamic>)
          .map((r) => r as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching trains from Supabase: $e');
      return [];
    }
  }
}