import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
import 'core/localization/app_localizations.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/ai/ai_chat_screen.dart';
import 'features/auth/auth_screen.dart';
import 'features/history/history_screen.dart';
import 'features/home/home_screen.dart';
import 'features/language/language_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/routes/route_details_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/train/train_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      debugPrint('Flutter startup error: ${details.exceptionAsString()}');
      debugPrintStack(stackTrace: details.stack);
    }
  };
  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Uncaught startup error: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final savedLang = await StorageService().getLang();
      if (mounted) {
        setState(() {
          _locale = savedLang != null ? Locale(savedLang) : null;
          _isReady = true;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading locale: $e');
      }
      if (mounted) {
        setState(() {
          _locale = null;
          _isReady = true;
        });
      }
    }
  }

  void _setLocale(String languageCode) async {
    await StorageService().saveLang(languageCode);
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  void _handleSplashFinish(BuildContext context) {
    try {
      if (!mounted) return;
      if (_locale == null) {
        Navigator.of(context).pushReplacementNamed('/language');
      } else {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Navigation error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'BanHops',
      locale: _locale,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('en');
        for (final supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode) {
            return supported;
          }
        }
        return const Locale('en');
      },
      builder: (context, child) {
        ErrorWidget.builder = (details) {
          if (kDebugMode) {
            debugPrint('Widget build error: ${details.exceptionAsString()}');
            debugPrintStack(stackTrace: details.stack);
          }
          return Scaffold(
            backgroundColor: const Color(0xFFEFF4FB),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'App failed to build.\n${details.exceptionAsString()}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        };
        return child ?? const SizedBox.shrink();
      },
      home: SplashScreen(onFinish: _handleSplashFinish),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/route-details': (context) => const RouteDetailsScreen(),
        '/ai': (context) => const AIChatScreen(),
        '/train': (context) => const TrainScreen(),
        '/history': (context) => const HistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/language') {
          return MaterialPageRoute(
            builder: (routeContext) => LanguageScreen(
              currentLocale: _locale,
              onLocaleSelected: (languageCode) {
                _setLocale(languageCode);
                Navigator.pushReplacementNamed(routeContext, '/auth');
              },
            ),
          );
        }
        // Fallback for undefined routes
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
      },
    );
  }
}
