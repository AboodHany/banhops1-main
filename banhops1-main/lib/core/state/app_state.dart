import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  AppState({StorageService? storageService}) : _storageService = storageService ?? StorageService();

  final StorageService _storageService;

  Locale? _locale;
  bool _isReady = false;
  bool _guestMode = false;
  ThemeMode _themeMode = ThemeMode.light;

  Locale? get locale => _locale;
  bool get isReady => _isReady;
  bool get isGuestMode => _guestMode;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadLocale() async {
    try {
      final savedLang = await _storageService.getLang();
      _locale = savedLang == null ? null : Locale(savedLang);
      final savedTheme = await _storageService.getThemeMode();
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    } finally {
      _isReady = true;
      notifyListeners();
    }
  }

  Future<void> setLocale(String languageCode) async {
    await _storageService.saveLang(languageCode);
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _storageService.saveThemeMode(
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  void setGuestMode(bool enabled) {
    _guestMode = enabled;
    notifyListeners();
  }
}