import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/config/app_config.dart';
import '../core/localization/app_localizations.dart';
import '../core/models/location_node.dart';
import '../core/models/transit_route_option.dart';
import '../core/models/transit_enums.dart';
import '../core/services/supabase_service.dart';
import '../core/state/app_state.dart';
import '../core/state/auth_controller.dart';
import '../core/state/chat_controller.dart';
import '../core/state/trip_planner_controller.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/navigation/main_navigation_hub.dart';
import '../features/search/presentation/route_results_screen.dart';
import '../features/search/presentation/trip_details_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/ai_chat/presentation/ai_chat_screen.dart';
import '../features/train/presentation/train_screen.dart';
import 'app_routes.dart';

class BanHopsApp extends StatelessWidget {
  const BanHopsApp({super.key, required this.config, required this.appState});

  final AppConfig config;
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: appState),
        ChangeNotifierProvider<TripPlannerController>(
          create: (_) => TripPlannerController(),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(config: config),
        ),
        ChangeNotifierProvider<ChatController>(
          create: (_) => ChatController(config: config),
        ),
        Provider<AppConfig>.value(value: config),
      ],
      child: Consumer<AppState>(
        builder: (context, state, _) {
          return MaterialApp(
            title: 'BanHops',
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
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
                return Scaffold(
                  backgroundColor: const Color(0xFFF0F5FA),
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
            initialRoute: AppRoutes.splash,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                // Auth Flow (Pages 40-42)
                case AppRoutes.splash:
                  return MaterialPageRoute(
                    builder: (_) => SplashScreen(
                      onFinish: (context) {
                        final route = state.locale == null
                            ? AppRoutes.welcome
                            : (SupabaseService.hasAuthenticatedSession
                                ? AppRoutes.main
                                : AppRoutes.login);
                        Navigator.of(context).pushReplacementNamed(route);
                      },
                    ),
                  );

                case AppRoutes.welcome:
                  return MaterialPageRoute(
                    builder: (_) => const WelcomeScreen(),
                  );

                case AppRoutes.login:
                  return MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  );

                case AppRoutes.register:
                  return MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  );

                // Main Navigation Hub (Pages 43-45)
                case AppRoutes.main:
                  return MaterialPageRoute(
                    builder: (_) => const MainNavigationHub(),
                  );

                // Search & Results (Pages 46-48)
                case AppRoutes.routeResults:
                  final args = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    builder: (_) => RouteResultsScreen(
                      originLabel: args?['originLabel'] ?? 'Your Location',
                      destinationLabel: args?['destinationLabel'] ?? 'Benha',
                      origin: args?['origin'] ?? LocationNode.empty(),
                      destination:
                          args?['destination'] ?? LocationNode.empty(),
                    ),
                  );

                case AppRoutes.tripDetails:
                  final args = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    builder: (_) => TripDetailsScreen(
                      route: args?['route'] ??
                          TransitRouteOption(
                            id: '',
                            title: 'Unknown Route',
                            mode: TransitMode.microbus,
                            durationMinutes: 0,
                            estimatedCost: 0,
                            transfers: 0,
                            rating: 0,
                            details: '',
                            gmapsUrl: '',
                            score: 0,
                            isRecommended: false,
                          ),
                      origin: args?['origin'] ?? 'Unknown',
                      destination: args?['destination'] ?? 'Unknown',
                    ),
                  );

                // AI Assistant (Pages 49+)
                case AppRoutes.aiChat:
                  return MaterialPageRoute(
                    builder: (_) => const AIChatScreen(),
                  );

                case AppRoutes.train:
                  return MaterialPageRoute(
                    builder: (_) => const TrainScreen(),
                  );

                // Legacy routes (kept for backward compatibility)
                case AppRoutes.language:
                  return MaterialPageRoute(
                    builder: (_) => const WelcomeScreen(),
                  );

                case AppRoutes.auth:
                  return MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  );

                case AppRoutes.home:
                  return MaterialPageRoute(
                    builder: (_) => const MainNavigationHub(),
                  );

                case AppRoutes.ai:
                  return MaterialPageRoute(
                    builder: (_) => const AIChatScreen(),
                  );

                case AppRoutes.history:
                  return MaterialPageRoute(
                    builder: (_) => const MainNavigationHub(),
                  );

                case AppRoutes.profile:
                  return MaterialPageRoute(
                    builder: (_) => const MainNavigationHub(),
                  );

                case AppRoutes.routeDetails:
                  return MaterialPageRoute(
                    builder: (_) => const MainNavigationHub(),
                  );

                default:
                  return MaterialPageRoute(
                    builder: (_) => Scaffold(
                      body: Center(child: Text('Route ${settings.name} not found')),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}