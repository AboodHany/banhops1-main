import 'transit_enums.dart';

class TransitRouteOption {
  const TransitRouteOption({
    required this.id,
    required this.title,
    required this.mode,
    required this.durationMinutes,
    required this.estimatedCost,
    required this.transfers,
    required this.rating,
    required this.details,
    required this.gmapsUrl,
    required this.score,
    required this.isRecommended,
  });

  final String id;
  final String title;
  final TransitMode mode;
  final int durationMinutes;
  final double estimatedCost;
  final int transfers;
  final double rating;
  final String details;
  final String gmapsUrl;
  final double score;
  final bool isRecommended;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'mode': mode.label,
        'durationMinutes': durationMinutes,
        'estimatedCost': estimatedCost,
        'transfers': transfers,
        'rating': rating,
        'details': details,
        'gmapsUrl': gmapsUrl,
        'score': score,
        'isRecommended': isRecommended,
      };

  factory TransitRouteOption.fromJson(Map<String, dynamic> json) {
    return TransitRouteOption(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      mode: TransitModeLabel.fromString(json['mode'] as String? ?? 'MICROBUS'),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0,
      transfers: (json['transfers'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      details: json['details'] as String? ?? '',
      gmapsUrl: json['gmapsUrl'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
      isRecommended: json['isRecommended'] as bool? ?? false,
    );
  }
}

class TripPreferences {
  const TripPreferences({
    this.timeWeight = 0.5,
    this.costWeight = 0.3,
    this.transferWeight = 0.2,
  });

  final double timeWeight;
  final double costWeight;
  final double transferWeight;
}

class TripPlanResult {
  const TripPlanResult({
    required this.originLabel,
    required this.destinationLabel,
    required this.routes,
    required this.summary,
  });

  final String originLabel;
  final String destinationLabel;
  final List<TransitRouteOption> routes;
  final String summary;
}