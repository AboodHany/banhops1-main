import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

class SupabaseService {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> initialize(AppConfig config) async {
    if (!config.hasSupabase || _isInitialized) {
      return;
    }

    await Supabase.initialize(
      url: config.supabaseUrl,
      anonKey: config.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: true,
      ),
    );
    _isInitialized = true;
  }

  static SupabaseClient? get client {
    if (!_isInitialized) {
      return null;
    }
    return Supabase.instance.client;
  }

  static bool get hasAuthenticatedSession =>
      _isInitialized && Supabase.instance.client.auth.currentSession != null;
}