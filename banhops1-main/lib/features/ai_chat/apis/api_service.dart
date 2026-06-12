class ApiService {
  static String? _apiKey;
  static String _baseUrl = '';
  static String _groqModel = 'llama-3.1-8b-instant';

  static void init(String key, {String baseUrl = '', String groqModel = 'llama-3.1-8b-instant'}) {
    _apiKey = key;
    _baseUrl = baseUrl;
    _groqModel = groqModel;
  }

  static String get apiKey {
    final configuredKey = _apiKey?.trim() ?? '';
    if (configuredKey.isNotEmpty) {
      return configuredKey;
    }

    const defineKey = String.fromEnvironment('AI_AGENT_API_KEY');
    if (defineKey.isNotEmpty) {
      return defineKey.trim();
    }

    const backupKey = String.fromEnvironment('API_KEY');
    if (backupKey.isNotEmpty) {
      return backupKey.trim();
    }

    throw StateError(
      'Missing API key. Please configure it in your environment or via AppConfig.',
    );
  }

  static String get baseUrl => _baseUrl;

  static String get groqModel => _groqModel;

  static bool get isGroq => _baseUrl.contains('groq.com');

  static bool get isConfigured {
    try {
      return apiKey.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
