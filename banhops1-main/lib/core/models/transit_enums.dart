enum TransitLocationType { university, hospital, station, hub, restaurant, cafe }

enum TransitMode { train, microbus, borderBus }

enum TripStatus { completed, cancelled, inProgress }

enum ChatPhase { waitingForInput, analyzingInput, responseGenerated, readyForQAndA }

String getLocationTypeLabel(TransitLocationType type) => type.name;

String getTransitModeLabel(TransitMode mode) => switch (mode) {
      TransitMode.train => 'TRAIN',
      TransitMode.microbus => 'MICROBUS',
      TransitMode.borderBus => 'BORDER_BUS',
    };

String getTripStatusLabel(TripStatus status) => switch (status) {
      TripStatus.completed => 'COMPLETED',
      TripStatus.cancelled => 'CANCELLED',
      TripStatus.inProgress => 'IN_PROGRESS',
    };

extension TransitLocationTypeLabel on TransitLocationType {
  String get label => getLocationTypeLabel(this);

  static TransitLocationType fromString(String value) {
    return TransitLocationType.values.firstWhere(
      (element) => element.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TransitLocationType.hub,
    );
  }
}

extension TransitModeLabel on TransitMode {
  String get label => getTransitModeLabel(this);

  static TransitMode fromString(String value) {
    return TransitMode.values.firstWhere(
      (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => TransitMode.microbus,
    );
  }
}

extension TripStatusLabel on TripStatus {
  String get label => getTripStatusLabel(this);

  static TripStatus fromString(String value) {
    return TripStatus.values.firstWhere(
      (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => TripStatus.completed,
    );
  }
}