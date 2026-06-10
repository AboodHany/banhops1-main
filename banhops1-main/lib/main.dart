import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/banhops_app.dart';
import 'core/config/app_config.dart';
import 'core/services/supabase_service.dart';
import 'core/services/chat_persistence_service.dart';
import 'core/services/forgot_password_service.dart';
import 'core/state/app_state.dart';
import 'package:banhops1/features/ai_chat/state/chat_provider.dart';
import 'package:banhops1/features/ai_chat/apis/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  ChatPersistenceService.baseUrl = config.backendBaseUrl;
  ForgotPasswordService.baseUrl = config.backendBaseUrl;

  // Configure Gemini API Key and initialize local Hive DB
  ApiService.init(config.aiAgentApiKey);
  await ChatProvider.initHive();

  await SupabaseService.initialize(config);
  final appState = AppState();
  await appState.loadLocale();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      debugPrint('Flutter error: ${details.exceptionAsString()}');
      debugPrintStack(stackTrace: details.stack);
    }
  };

  runApp(BanHopsApp(config: config, appState: appState));
}
