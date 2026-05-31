class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.aiAgentBaseUrl,
    required this.aiAgentApiKey,
    required this.googleMapsApiKey,
    required this.enableGoogleSignIn,
    required this.enableFacebookSignIn,
  });

  factory AppConfig.fromEnvironment() {
    return AppConfig(
      supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      aiAgentBaseUrl: const String.fromEnvironment('AI_AGENT_BASE_URL'),
      aiAgentApiKey: const String.fromEnvironment('AI_AGENT_API_KEY'),
      googleMapsApiKey: const String.fromEnvironment('GOOGLE_MAPS_API_KEY'),
      enableGoogleSignIn: const bool.fromEnvironment(
        'ENABLE_GOOGLE_SIGN_IN',
        defaultValue: false,
      ),
      enableFacebookSignIn: const bool.fromEnvironment(
        'ENABLE_FACEBOOK_SIGN_IN',
        defaultValue: false,
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

  bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  bool get hasAiAgent => aiAgentBaseUrl.isNotEmpty;

  bool get hasGoogleMapsApiKey => googleMapsApiKey.isNotEmpty;
}