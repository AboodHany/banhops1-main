import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/app_user_profile.dart';
import 'user_session.dart';

class AuthService {
  AuthService(this._config);

  final AppConfig _config;
  static const String _baseUrl = 'https://banhops-backend-production.up.railway.app';

  Future<AppUserProfile> signIn({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/api/auth/login');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username.trim(),
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final firstName = data['firstName'] ?? '';
      final lastName = data['lastName'] ?? '';
      final email = data['email'] ?? '';
      final phone = data['phone'] ?? '';
      
      // Save session locally
      await UserSession.save(
        username: username,
        firstName: firstName,
      );

      return AppUserProfile(
        id: username,
        name: '$firstName $lastName'.trim().isNotEmpty ? '$firstName $lastName'.trim() : username,
        email: email,
        completedTrips: 12,
        languageCode: 'en',
        username: username,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
    } else {
      String errorMessage = 'Login failed';
      try {
        final errorData = jsonDecode(response.body);
        String rawMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;

        if (rawMessage.contains("interpolatedMessage='")) {
          final regex = RegExp(r"interpolatedMessage='([^']+)'");
          final match = regex.firstMatch(rawMessage);
          errorMessage = match?.group(1) ?? errorMessage;
        } else {
          errorMessage = rawMessage;
        }
      } catch (_) {
        if (response.body.contains('<title>')) {
          errorMessage = 'Server Error: ${response.statusCode}';
        } else if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      }
      throw Exception(errorMessage);
    }
  }

  Future<AppUserProfile> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/api/auth/signup');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Auto-save session on successful signup if backend returns profile
      try {
        final data = jsonDecode(response.body);
        final rUsername = data['username'] ?? username;
        final rFirstName = data['firstName'] ?? firstName;
        
        await UserSession.save(
          username: rUsername,
          firstName: rFirstName,
        );

        return AppUserProfile(
          id: rUsername,
          name: '$rFirstName ${data['lastName'] ?? lastName}'.trim(),
          email: data['email'] ?? email,
          completedTrips: 0,
          languageCode: 'en',
          username: rUsername,
          firstName: rFirstName,
          lastName: data['lastName'] ?? lastName,
          phone: data['phone'] ?? phone,
        );
      } catch (_) {
        await UserSession.save(
          username: username,
          firstName: firstName,
        );
        return AppUserProfile(
          id: username,
          name: '$firstName $lastName'.trim(),
          email: email,
          completedTrips: 0,
          languageCode: 'en',
          username: username,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );
      }
    } else {
      String errorMessage = 'Signup Failed';
      try {
        final responseBody = jsonDecode(response.body);
        String rawMessage = responseBody['message'] ?? responseBody['error'] ?? errorMessage;

        if (rawMessage.contains("interpolatedMessage='")) {
          final regex = RegExp(r"interpolatedMessage='([^']+)'");
          final match = regex.firstMatch(rawMessage);
          errorMessage = match?.group(1) ?? errorMessage;
        } else {
          errorMessage = rawMessage;
        }
      } catch (_) {
        if (response.body.contains('<title>')) {
          errorMessage = 'Server Error: ${response.statusCode}';
        } else if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      }
      throw Exception(errorMessage);
    }
  }

  // Fallback methods to keep existing code working if called
  Future<AppUserProfile> signInWithEmail(String email, String password) async {
    return signIn(username: email.split('@').first, password: password);
  }

  Future<AppUserProfile> signUpWithEmail(String name, String email, String password) async {
    final parts = name.split(' ');
    final first = parts.isNotEmpty ? parts.first : name;
    final last = parts.length > 1 ? parts.sublist(1).join(' ') : 'User';
    return signUp(
      firstName: first,
      lastName: last,
      username: email.split('@').first,
      email: email,
      phone: '01234567890',
      password: password,
    );
  }

  Future<AppUserProfile> signInWithGoogle() async {
    if (!_config.enableGoogleSignIn) {
      return _guestProfile(
        message: 'Google Sign-In is disabled until the client ID is configured.',
      );
    }

    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return _guestProfile(message: 'Google sign-in was cancelled.');
      }

      final username = googleUser.email.split('@').first;
      await UserSession.save(
        username: username,
        firstName: googleUser.displayName ?? 'Google User',
      );

      return AppUserProfile(
        id: username,
        name: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        completedTrips: 0,
        languageCode: 'en',
        username: username,
        firstName: googleUser.displayName ?? 'Google User',
      );
    } catch (error) {
      return _guestProfile(message: 'Google sign-in failed: $error');
    }
  }

  Future<AppUserProfile> signInWithFacebook() async {
    if (!_config.enableFacebookSignIn) {
      return _guestProfile(
        message: 'Facebook Sign-In is disabled until app credentials are configured.',
      );
    }

    try {
      final loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success || loginResult.accessToken == null) {
        return _guestProfile(message: 'Facebook sign-in was cancelled or failed.');
      }

      final userData = await FacebookAuth.instance.getUserData();
      final username = ((userData['email'] as String?) ?? 'fb_user').split('@').first;
      final firstName = (userData['name'] as String?) ?? 'Facebook User';

      await UserSession.save(
        username: username,
        firstName: firstName,
      );

      return AppUserProfile(
        id: username,
        name: firstName,
        email: (userData['email'] as String?) ?? 'facebook@banhops.local',
        completedTrips: 0,
        languageCode: 'en',
        username: username,
        firstName: firstName,
      );
    } catch (error) {
      return _guestProfile(message: 'Facebook sign-in failed: $error');
    }
  }

  Future<AppUserProfile> signInAsGuest() async {
    await UserSession.save(
      username: 'guest',
      firstName: 'Guest Rider',
    );
    return _guestProfile(message: 'Guest session started.');
  }

  Future<void> signOut() async {
    await UserSession.clear();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  AppUserProfile _guestProfile({required String message}) {
    debugPrint(message);
    return const AppUserProfile(
      id: 'guest',
      name: 'Guest Rider',
      email: 'guest@banhops.local',
      completedTrips: 0,
      languageCode: 'en',
      isGuest: true,
      username: 'guest',
      firstName: 'Guest Rider',
    );
  }
}
