class MicrobusLine {
  const MicrobusLine({
    required this.id,
    required this.category,
    required this.lineNo,
    required this.route,
    required this.fare,
  });

  final int id;
  final String category;
  final int lineNo;
  final String route;
  final double fare;

  factory MicrobusLine.fromJson(Map<String, dynamic> json) {
    return MicrobusLine(
      id: json['id'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      lineNo: json['line_no'] as int? ?? 0,
      route: json['route'] as String? ?? '',
      fare: (json['fare'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'line_no': lineNo,
        'route': route,
        'fare': fare,
      };
}
