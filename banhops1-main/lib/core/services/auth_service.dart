import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/app_user_profile.dart';
import 'supabase_service.dart';

class AuthService {
  AuthService(this._config);

  final AppConfig _config;

  bool get _canUseSupabase => SupabaseService.isInitialized;

  Future<AppUserProfile> signInWithEmail(String email, String password) async {
    if (_canUseSupabase) {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    }
    return _profileFromEmail(email, isGuest: false);
  }

  Future<AppUserProfile> signUpWithEmail(String name, String email, String password) async {
    if (_canUseSupabase) {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: <String, dynamic>{'name': name},
      );
    }
    return AppUserProfile(
      id: email,
      name: name,
      email: email,
      completedTrips: 0,
      languageCode: 'en',
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

      final authentication = await googleUser.authentication;
      if (_canUseSupabase && authentication.idToken != null) {
        await Supabase.instance.client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: authentication.idToken!,
          accessToken: authentication.accessToken,
        );
      }

      return AppUserProfile(
        id: googleUser.email,
        name: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        completedTrips: 0,
        languageCode: 'en',
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

      if (_canUseSupabase && loginResult.accessToken != null) {
        await Supabase.instance.client.auth.signInWithIdToken(
          provider: OAuthProvider.facebook,
          idToken: loginResult.accessToken!.toString(),
          accessToken: loginResult.accessToken!.toString(),
        );
      }

      final userData = await FacebookAuth.instance.getUserData();
      return AppUserProfile(
        id: (userData['id'] as String?) ?? 'facebook-user',
        name: (userData['name'] as String?) ?? 'Facebook User',
        email: (userData['email'] as String?) ?? 'facebook@banhops.local',
        completedTrips: 0,
        languageCode: 'en',
      );
    } catch (error) {
      return _guestProfile(message: 'Facebook sign-in failed: $error');
    }
  }

  Future<AppUserProfile> signInAsGuest() async {
    return _guestProfile(message: 'Guest session started.');
  }

  Future<void> signOut() async {
    if (_canUseSupabase) {
      await Supabase.instance.client.auth.signOut();
    }
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  AppUserProfile _profileFromEmail(String email, {required bool isGuest}) {
    return AppUserProfile(
      id: email,
      name: email.split('@').first,
      email: email,
      completedTrips: isGuest ? 0 : 12,
      languageCode: 'en',
      isGuest: isGuest,
    );
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
    );
  }
}
