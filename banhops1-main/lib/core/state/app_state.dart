import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  AppState({StorageService? storageService}) : _storageService = storageService ?? StorageService();

  final StorageService _storageService;

  Locale? _locale;
  bool _isReady = false;
  bool _guestMode = false;

  Locale? get locale => _locale;
  bool get isReady => _isReady;
  bool get isGuestMode => _guestMode;

  Future<void> loadLocale() async {
    try {
      final savedLang = await _storageService.getLang();
      _locale = savedLang == null ? null : Locale(savedLang);
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

  void setGuestMode(bool enabled) {
    _guestMode = enabled;
    notifyListeners();
  }
}