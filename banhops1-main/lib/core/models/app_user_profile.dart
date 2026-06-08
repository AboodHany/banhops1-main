class AppUserProfile {
  const AppUserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.completedTrips,
    required this.languageCode,
    this.isGuest = false,
    this.username = '',
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
  });

  final String id;
  final String name;
  final String email;
  final int completedTrips;
  final String languageCode;
  final bool isGuest;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;

  AppUserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? completedTrips,
    String? languageCode,
    bool? isGuest,
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
  }) {
    return AppUserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      completedTrips: completedTrips ?? this.completedTrips,
      languageCode: languageCode ?? this.languageCode,
      isGuest: isGuest ?? this.isGuest,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
    );
  }
}