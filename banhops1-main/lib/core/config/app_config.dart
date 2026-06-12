import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.aiAgentBaseUrl,
    required this.aiAgentApiKey,
    required this.googleMapsApiKey,
    required this.enableGoogleSignIn,
    required this.enableFacebookSignIn,
    required this.backendBaseUrl,
    this.groqModel = 'llama-3.1-8b-instant',
  });

  factory AppConfig.fromEnvironment() {
    var supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
    var supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');
    var aiAgentBaseUrl = const String.fromEnvironment('AI_AGENT_BASE_URL');
    var aiAgentApiKey = const String.fromEnvironment('AI_AGENT_API_KEY');

    // Dynamically load from local .env file during development if compile-time defines are empty
    if (!kIsWeb) {
      try {
        final envFile = File('.env');
        if (envFile.existsSync()) {
          final lines = envFile.readAsLinesSync();
          final envMap = <String, String>{};
          for (var line in lines) {
            line = line.trim();
            if (line.isEmpty || line.startsWith('#')) continue;
            final parts = line.split('=');
            if (parts.length >= 2) {
              final key = parts[0].trim();
              final value = parts.sublist(1).join('=').trim();
              envMap[key] = value;
            }
          }
          if (supabaseUrl.isEmpty && envMap.containsKey('SUPABASE_URL')) {
            supabaseUrl = envMap['SUPABASE_URL']!;
          }
          if (supabaseAnonKey.isEmpty && envMap.containsKey('SUPABASE_ANON_KEY')) {
            supabaseAnonKey = envMap['SUPABASE_ANON_KEY']!;
          }
          if (aiAgentBaseUrl.isEmpty && envMap.containsKey('AI_AGENT_BASE_URL')) {
            aiAgentBaseUrl = envMap['AI_AGENT_BASE_URL']!;
          }
          if (aiAgentApiKey.isEmpty && envMap.containsKey('AI_AGENT_API_KEY')) {
            aiAgentApiKey = envMap['AI_AGENT_API_KEY']!;
          }
        }
      } catch (e) {
        // Fallback silently if File operations fail (e.g. on restricted environments)
      }
    }

    // Fallbacks from default configs for local development/testing if still empty
    if (supabaseUrl.isEmpty) {
      supabaseUrl = 'https://ujursejrleqjlrfgksfh.supabase.co';
    }
    if (supabaseAnonKey.isEmpty) {
      supabaseAnonKey = 'sb_publishable_7dbspU0EF5Ekj-B-agyN1g_LCO8_4Ux';
    }
    if (aiAgentBaseUrl.isEmpty) {
      aiAgentBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
    }
    if (aiAgentApiKey.isEmpty) {
      aiAgentApiKey = 'AQ.Ab8RN6Ir756QPF5BVbazd9o7boZ_gZn-AHDJpI0ZdPPgmAuE_g'; // Fallback to avoid missing API key error
    }

    return AppConfig(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      aiAgentBaseUrl: aiAgentBaseUrl,
      aiAgentApiKey: aiAgentApiKey,
      googleMapsApiKey: const String.fromEnvironment('GOOGLE_MAPS_API_KEY'),
      enableGoogleSignIn: const bool.fromEnvironment(
        'ENABLE_GOOGLE_SIGN_IN',
        defaultValue: false,
      ),
      enableFacebookSignIn: const bool.fromEnvironment(
        'ENABLE_FACEBOOK_SIGN_IN',
        defaultValue: false,
      ),
      backendBaseUrl: const String.fromEnvironment(
        'BACKEND_BASE_URL',
        defaultValue: 'https://banhops-backend-production.up.railway.app',
      ),
      groqModel: const String.fromEnvironment(
        'GROQ_MODEL',
        defaultValue: 'llama-3.1-8b-instant',
      ),
    );
  }

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String aiAgentBaseUrl;
  final String aiAgentApiKey;
  final String googleMapsApiKey;
  final bool enableGoogleSignIn;
  final bool enableFacebookSignIn;
  final String backendBaseUrl;
  final String groqModel;

  bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  bool get hasAiAgent => aiAgentBaseUrl.isNotEmpty;

  bool get hasGoogleMapsApiKey => googleMapsApiKey.isNotEmpty;

  bool get isGroq => aiAgentBaseUrl.contains('groq.com');
}