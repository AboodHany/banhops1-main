import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:banhops1/core/localization/app_localizations.dart';
import 'package:banhops1/features/auth/auth_screen.dart';
import 'package:banhops1/features/language/language_screen.dart';
import 'package:banhops1/features/splash/splash_screen.dart';

Widget buildFlowApp({
  String? savedLang,
  void Function(String languageCode)? onLanguageSelected,
}) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en', ''), Locale('ar', '')],
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => SplashScreen(
        onFinish: (ctx) {
          if (savedLang == null) {
            Navigator.of(ctx).pushReplacementNamed('/language');
          } else {
            Navigator.of(ctx).pushReplacementNamed('/auth');
          }
        },
      ),
      '/auth': (context) => const AuthScreen(),
    },
    onGenerateRoute: (settings) {
      if (settings.name == '/language') {
        return MaterialPageRoute(
          builder: (context) => LanguageScreen(
            currentLocale: savedLang == null ? null : Locale(savedLang),
            onLocaleSelected: (languageCode) {
              onLanguageSelected?.call(languageCode);
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        );
      }

      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Unknown route'))),
      );
    },
  );
}

void main() {
  testWidgets('First launch goes Splash -> Language -> Auth', (
    WidgetTester tester,
  ) async {
    String? selectedLang;

    await tester.pumpWidget(
      buildFlowApp(
        savedLang: null,
        onLanguageSelected: (languageCode) => selectedLang = languageCode,
      ),
    );
    await tester.pump();

    expect(find.text('BanHops'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Please select a language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);
    expect(selectedLang, 'en');
  });

  testWidgets('Saved language skips Language screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildFlowApp(savedLang: 'en'));
    await tester.pump();

    expect(find.text('BanHops'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Please select a language'), findsNothing);
    expect(find.byType(AuthScreen), findsOneWidget);
  });
}
