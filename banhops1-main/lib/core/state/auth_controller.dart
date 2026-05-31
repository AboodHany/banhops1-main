import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../models/app_user_profile.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthController({required AppConfig config}) : _authService = AuthService(config);

  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;
  AppUserProfile? _profile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppUserProfile? get profile => _profile;

  Future<void> signInWithEmail(String email, String password) async {
    await _runAuthAction(() => _authService.signInWithEmail(email, password));
  }

  Future<void> signUpWithEmail(String name, String email, String password) async {
    await _runAuthAction(() => _authService.signUpWithEmail(name, email, password));
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
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}