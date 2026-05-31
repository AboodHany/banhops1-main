extension JsonUtils on Object? {
  String asString([String fallback = '']) => this is String ? this as String : fallback;

  int asInt([int fallback = 0]) {
    final value = this;
    if (value is int) return value;
    if (value is double) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  double asDouble([double fallback = 0]) {
    final value = this;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  bool asBool([bool fallback = false]) => this is bool ? this as bool : fallback;

  Map<String, dynamic> asMap([Map<String, dynamic>? fallback]) {
    final value = this;
    if (value is Map<String, dynamic>) return value;
    return fallback ?? <String, dynamic>{};
  }

  List<dynamic> asList([List<dynamic>? fallback]) {
    final value = this;
    if (value is List<dynamic>) return value;
    return fallback ?? <dynamic>[];
  }
}