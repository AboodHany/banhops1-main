class AppUserProfile {
  const AppUserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.completedTrips,
    required this.languageCode,
    this.isGuest = false,
  });

  final String id;
  final String name;
  final String email;
  final int completedTrips;
  final String languageCode;
  final bool isGuest;
}