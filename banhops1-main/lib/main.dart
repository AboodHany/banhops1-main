import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/banhops_app.dart';
import 'core/config/app_config.dart';
import 'core/services/supabase_service.dart';
import 'core/state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
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
