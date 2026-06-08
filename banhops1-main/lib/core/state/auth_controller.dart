import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../models/app_user_profile.dart';
import '../services/auth_service.dart';
import '../services/user_session.dart';

class AuthController extends ChangeNotifier {
  AuthController({required AppConfig config}) : _authService = AuthService(config) {
    _loadCachedProfile();
  }

  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;
  AppUserProfile? _profile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppUserProfile? get profile => _profile;

  Future<void> _loadCachedProfile() async {
    try {
      final has = await UserSession.hasSession();
      if (has) {
        final username = await UserSession.getUsername();
        final firstName = await UserSession.getFirstName();
        _profile = AppUserProfile(
          id: username,
          name: firstName,
          email: '',
          completedTrips: 12,
          languageCode: 'en',
          username: username,
          firstName: firstName,
        );
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> signIn({required String username, required String password}) async {
    await _runAuthAction(() => _authService.signIn(username: username, password: password));
  }

  Future<void> signInWithEmail(String email, String password) async {
    await signIn(username: email.split('@').first, password: password);
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    await _runAuthAction(() => _authService.signUp(
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: email,
          phone: phone,
          password: password,
        ));
  }

  Future<void> signUpWithEmail(String name, String email, String password) async {
    final parts = name.split(' ');
    final first = parts.isNotEmpty ? parts.first : name;
    final last = parts.length > 1 ? parts.sublist(1).join(' ') : 'User';
    await signUp(
      firstName: first,
      lastName: last,
      username: email.split('@').first,
      email: email,
      phone: '01234567890',
      password: password,
    );
  }

  Future<void> signInWithGoogle() async {
    await _runAuthAction(_authService.signInWithGoogle);
  }

  Future<void> signInWithFacebook() async {
    await _runAuthAction(_authService.signInWithFacebook);
  }

  Future<void> signInAsGuest() async {
    await _runAuthAction(_authService.signInAsGuest);
  }

  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authService.signOut();
      _profile = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _runAuthAction(Future<AppUserProfile> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _profile = await action();
    } catch (error) {
      _errorMessage = error.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}