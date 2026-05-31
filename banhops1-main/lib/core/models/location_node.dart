import 'transit_enums.dart';

class LocationNode {
  const LocationNode({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.alias,
    this.governorate,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final TransitLocationType type;
  final String? alias;
  final String? governorate;

  factory LocationNode.empty() {
    return LocationNode(
      id: 0,
      name: '',
      latitude: 0,
      longitude: 0,
      type: TransitLocationType.hub,
      alias: null,
      governorate: null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'type': type.label,
        'alias': alias,
        'governorate': governorate,
      };

  factory LocationNode.fromJson(Map<String, dynamic> json) {
    return LocationNode(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      type: TransitLocationTypeLabel.fromString(json['type'] as String? ?? 'hub'),
      alias: json['alias'] as String?,
      governorate: json['governorate'] as String?,
    );
  }

  String get coordinatesLabel => '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
}