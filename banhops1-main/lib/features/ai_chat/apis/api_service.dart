class ApiService {
  static String? _apiKey;

  static void init(String key) {
    _apiKey = key;
  }

  static String get apiKey {
    final configuredKey = _apiKey?.trim() ?? '';
    if (configuredKey.isNotEmpty) {
      return configuredKey;
    }

    // Fallbacks to environment variables
    const defineKey = String.fromEnvironment('AI_AGENT_API_KEY');
    if (defineKey.isNotEmpty) {
      return defineKey.trim();
    }

    const backupKey = String.fromEnvironment('API_KEY');
    if (backupKey.isNotEmpty) {
      return backupKey.trim();
    }

    throw StateError(
      'Missing Gemini API key. Please configure it in your environment or via AppConfig.',
    );
  }

  static bool get isConfigured {
    try {
      return apiKey.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
