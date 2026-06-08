import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const _keyUsername = 'username';
  static const _keyFirstName = 'firstName';
  static const _keyTripCount = 'tripCount';

  static Future<void> save({
    required String username,
    required String firstName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyFirstName, firstName);
  }

  static Future<void> saveTripCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTripCount, count);
  }

  static Future<int> getTripCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTripCount) ?? 0;
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? 'guest';
  }

  static Future<String> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFirstName) ?? 'User';
  }

  static Future<bool> hasSession() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_keyUsername);
    return username != null && username != 'guest';
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    // clear all auth keys
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyFirstName);
    await prefs.remove(_keyTripCount);
  }
}
