import 'location_node.dart';
import 'transit_enums.dart';

class TripRecord {
  const TripRecord({
    required this.id,
    required this.origin,
    required this.destination,
    required this.estimatedTime,
    required this.estimatedCost,
    required this.transfers,
    required this.status,
    required this.createdAt,
    required this.routes,
  });

  final int id;
  final LocationNode origin;
  final LocationNode destination;
  final int estimatedTime;
  final double estimatedCost;
  final int transfers;
  final TripStatus status;
  final DateTime createdAt;
  final List<String> routes;

  factory TripRecord.fromJson(Map<String, dynamic> json) {
    return TripRecord(
      id: json['id'] as int? ?? 0,
      origin: LocationNode.fromJson(json['origin'] as Map<String, dynamic>? ?? {}),
      destination: LocationNode.fromJson(json['destination'] as Map<String, dynamic>? ?? {}),
      estimatedTime: (json['estimatedTime'] as num?)?.toInt() ?? 0,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0,
      transfers: (json['transfers'] as num?)?.toInt() ?? 0,
      status: TripStatusLabel.fromString(json['status'] as String? ?? 'COMPLETED'),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      routes: (json['routes'] as List<dynamic>? ?? const <dynamic>[])
          .map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'origin': origin.toJson(),
        'destination': destination.toJson(),
        'estimatedTime': estimatedTime,
        'estimatedCost': estimatedCost,
        'transfers': transfers,
        'status': status.label,
        'createdAt': createdAt.toIso8601String(),
        'routes': routes,
      };
}