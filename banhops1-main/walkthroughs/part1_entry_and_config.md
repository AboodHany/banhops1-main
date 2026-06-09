# الجزء الأول: نقطة انطلاق التطبيق والتهيئة والمسارات

في هذا الجزء، سنقوم بشرح الملفات الأربعة الأولى بالتفصيل والسطر بالسطر لتفهم كيف يتم إقلاع التطبيق، وكيف يتم تحميل الإعدادات وتأهيل الاتصال بقاعدة البيانات، وكيف يتم توجيه المستخدم بين الصفحات المختلفة.

---

## 1. شرح ملف [lib/main.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/main.dart)
هذا هو الملف الرئيسي ونقطة البداية (Entry Point) لأي تطبيق فلاتر. عند تشغيل التطبيق، يبحث نظام التشغيل عن الدالة `main` هنا ويبدأ بتنفيذها.

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/banhops_app.dart';
import 'core/config/app_config.dart';
import 'core/services/supabase_service.dart';
import 'core/state/app_state.dart';
```
* **الأسطر 1-2:** استيراد مكتبات فلاتر الأساسية؛ `foundation.dart` للوظائف البرمجية العامة وتحديد بيئة التشغيل، و`material.dart` لتصميم الواجهات الافتراضي من جوجل.
* **الأسطر 4-7:** استيراد الملفات الخاصة بمشروعنا: ويدجيت التطبيق الأساسية (`BanHopsApp`)، كلاس الإعدادات (`AppConfig`)، خدمة قاعدة البيانات السحابية (`SupabaseService`)، وحالة التطبيق العامة (`AppState`).

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
```
* **السطر 9:** تعريف الدالة `main` الرئيسية، ونلاحظ وجود الكلمة المفتاحية `async` لأنها تحتوي على عمليات غير متزامنة (تنتظر تحميل بيانات أو اتصال بسيرفر).
* **السطر 10:** استدعاء `WidgetsFlutterBinding.ensureInitialized()` وهو سطر مصيري يضمن تهيئة روابط فلاتر مع نظام تشغيل الهاتف قبل تشغيل أي كود برمجي يتفاعل مع خادم أو قاعدة بيانات.

```dart
  final config = AppConfig.fromEnvironment();
  await SupabaseService.initialize(config);
  final appState = AppState();
  await appState.loadLocale();
```
* **السطر 12:** إنشاء كائن الإعدادات `config` عن طريق قراءة المتغيرات البيئية (مثل روابط قاعدة البيانات ومفاتيح الـ API).
* **السطر 13:** استدعاء الدالة غير المتزامنة لتهيئة الاتصال بقاعدة بيانات Supabase، ونستخدم `await` لنجعل التطبيق ينتظر حتى يكتمل الاتصال بنجاح.
* **السطر 14:** إنشاء كائن التحكم بالحالة العامة للتطبيق `appState` (مثل الثيم واللغة).
* **السطر 15:** تحميل لغة التطبيق المخزنة مسبقاً في ذاكرة الهاتف (العربية أو الإنجليزية).

```dart
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      debugPrint('Flutter error: ${details.exceptionAsString()}');
      debugPrintStack(stackTrace: details.stack);
    }
  };
```
* **الأسطر 17-23:** إعداد معالج أخطاء مخصص للتطبيق (`FlutterError.onError`). عندما يحدث أي خطأ برمجي أثناء تشغيل الواجهات، يقوم هذا المعالج بالتقاط الخطأ وعرضه بشكل لائق، وفي وضع التطوير (`kDebugMode`) يقوم بطباعة تفاصيل الخطأ وتتبع المكدس (Stack Trace) في كونسول المطورين لتسهيل إصلاحه.

```dart
  runApp(BanHopsApp(config: config, appState: appState));
}
```
* **السطر 25:** الدالة الأساسية `runApp` التي تطلق أول شاشة وتستدعي الـ Root Widget للتطبيق وهي `BanHopsApp` ممررين لها الإعدادات والحالة التي قمنا بتجهيزها.

---

## 2. شرح ملف [lib/core/config/app_config.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/config/app_config.dart)
هذا الملف مسؤول عن قراءة المتغيرات الخاصة بالخوادم والذكاء الاصطناعي وخرائط جوجل وتخزينها في مكان واحد مركزي.

```dart
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
```
* **الأسطر 1-10:** تعريف الكلاس `AppConfig` مع الكونستراكتور (الباني) الخاص به والذي يتطلب تمرير كل الإعدادات الأساسية عند إنشائه.

```dart
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
```
* **الأسطر 12-28:** دالة مصنع (`factory constructor`) تقوم بقراءة هذه المتغيرات مباشرة من بيئة النظام (Environment Variables) أثناء تجميع التطبيق (Build Time) باستخدام `String.fromEnvironment` و `bool.fromEnvironment` مع وضع قيم افتراضية كاذبة (`false`) للخيارات المنطقية.

```dart
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String aiAgentBaseUrl;
  final String aiAgentApiKey;
  final String googleMapsApiKey;
  final bool enableGoogleSignIn;
  final bool enableFacebookSignIn;
```
* **الأسطر 30-36:** المتغيرات النهائية (`final`) التي ستحتفظ بقيم الإعدادات طوال فترة تشغيل التطبيق دون أن تتغير.

```dart
  bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  bool get hasAiAgent => aiAgentBaseUrl.isNotEmpty;

  bool get hasGoogleMapsApiKey => googleMapsApiKey.isNotEmpty;
}
```
* **الأسطر 38-44:** دوال اختصار (Getters) لفحص حالة الإعدادات؛ تعطي `true` إذا كانت القيم مكتملة وليست فارغة، لنعلم برمجياً هل قاعدة البيانات أو الذكاء الاصطناعي جاهز للعمل أم لا.

---

## 3. شرح ملف [lib/app/app_routes.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/app/app_routes.dart)
هذا الملف يحتوي على تعريف أسماء المسارات (Routes Names) لجميع شاشات التطبيق لكي ننتقل بين الصفحات باستخدام الاسم البرمجي الثابت بدلاً من كتابة النصوص يدوياً وتجنب الأخطاء الإملائية.

```dart
class AppRoutes {
  // Auth Flow (Pages 40-42)
  static const splash = '/';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
```
* **الأسطر 3-7:** مسارات رحلة الدخول (Auth Flow). يبدأ التطبيق بمسار الجذر `/` والذي يمثل شاشة الـ Splash، يليه شاشات الترحيب والولوج وإنشاء الحساب واستعادة كلمة المرور.

```dart
  // Main Navigation (Pages 43-45)
  static const main = '/main';
```
* **السطر 10:** مسار الواجهة الرئيسية والموجه العام للتطبيق (Main Navigation Hub).

```dart
  // Search & Results (Pages 46-48)
  static const routeResults = '/route-results';
  static const tripDetails = '/trip-details';
```
* **الأسطر 13-14:** مسار شاشة خيارات النقل والمقارنة، ومسار شاشة التفاصيل خطوة بخطوة للرحلة.

```dart
  // AI Assistant (Pages 49+)
  static const aiChat = '/ai-chat';
```
* **السطر 17:** مسار شاشة محادثة مساعد الذكاء الاصطناعي.

```dart
  // Additional Screens
  static const train = '/train';
```
* **السطر 20:** مسار شاشة خريطة خطوط القطار التفاعلية.

```dart
  // Legacy routes (kept for compatibility)
  static const auth = '/auth';
  static const home = '/home';
  static const routeDetails = '/route-details';
  static const ai = '/ai';
  static const history = '/history';
  static const profile = '/profile';
  static const language = '/language';
}
```
* **الأسطر 23-30:** مسارات قديمة أو متوافقة رجعياً (Legacy Routes) تم الإبقاء عليها لضمان عدم حدوث مشاكل في حال وجود أجزاء قديمة في الكود تحاول استدعائها.

---

## 4. شرح ملف [lib/app/banhops_app.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/app/banhops_app.dart)
هذا هو القلب النابض لإعدادات واجهة المستخدم للتطبيق؛ حيث يتم حقن مزودي الحالات (State Providers) وتهيئة اللغات والخطوط وموجه الصفحات الرئيسي.

```dart
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
import '../features/auth/presentation/forgot_password_screen.dart';
import '../core/services/user_session.dart';
import '../features/navigation/main_navigation_hub.dart';
import '../features/search/presentation/route_results_screen.dart';
import '../features/search/presentation/trip_details_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/ai_chat/presentation/ai_chat_screen.dart';
import '../features/train/presentation/train_screen.dart';
import 'app_routes.dart';
```
* **الأسطر 1-3:** استيراد حزم المكونات واللغات ومكتبة `Provider` لإدارة الحالات.
* **الأسطر 5-27:** استيراد نماذج البيانات والخدمات والتحكم بالشاشات والمسارات التي سيقوم التطبيق بإنشائها والربط بينها.

```dart
class BanHopsApp extends StatelessWidget {
  const BanHopsApp({super.key, required this.config, required this.appState});

  final AppConfig config;
  final AppState appState;
```
* **الأسطر 29-33:** تعريف الكلاس `BanHopsApp` كويدجيت عديمة الحالة (`StatelessWidget`) وتتلقى كلاً من الإعدادات `config` والحالة العامة `appState` عبر الكونستراكتور.

```dart
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
```
* **الأسطر 35-50:** دالة البناء `build`. نقوم بإرجاع `MultiProvider` لحقن المتحكمات بجميع أنحاء التطبيق حتى تتمكن أي شاشة من الوصول إليها وتعديل البيانات:
  - `AppState`: التحكم في اللغة والثيم.
  - `TripPlannerController`: التحكم في عمليات البحث عن المواصلات والرحلات.
  - `AuthController`: التحكم في تسجيل الدخول وإنشاء الحساب.
  - `ChatController`: التحكم في محادثات المساعد الذكي وسجل الشات.
  - `AppConfig`: توفير الإعدادات والمفاتيح لأي خدمة فرعية.

```dart
      child: Consumer<AppState>(
        builder: (context, state, _) {
          return MaterialApp(
            title: 'BanHops',
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
```
* **الأسطر 51-59:** نستخدم `Consumer<AppState>` لمراقبة حالة التطبيق وتحديث لغته وثيمته فوراً بمجرد قيام المستخدم بتغييرها من الإعدادات.
* **الأسطر 53-59:** بناء الويدجيت السحرية `MaterialApp` وضبط الاسم، إيقاف شريط المطورين التجريبي (`debugShowCheckedModeBanner`) وتحديد اللغة الحالية وثيمات الألوان الفاتحة والداكنة بناءً على حالة الـ `appState`.

```dart
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
```
* **الأسطر 60-66:** إعداد وتفعيل اللغات وتوطين التطبيق:
  - `supportedLocales`: اللغات المدعومة رسمياً (العربية والإنجليزية).
  - `localizationsDelegates`: المندوبون المسؤولون عن ترجمة نصوص النظام الافتراضية للغات المطلوبة وتطبيق اتجاه النصوص (من اليمين لليسار للعربية والعكس للإنجليزية).

```dart
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) return const Locale('en');
              for (final supported in supportedLocales) {
                if (supported.languageCode == locale.languageCode) {
                  return supported;
                }
              }
              return const Locale('en');
            },
```
* **الأسطر 67-75:** وظيفة للتحقق الذكي وتحديد لغة افتراضية عند فتح التطبيق أول مرة؛ حيث تفحص لغة جهاز المستخدم، فإذا كانت العربية أو الإنجليزية تفتح بها، وإلا تفتح باللغة الإنجليزية كخيار افتراضي آمن.

```dart
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
```
* **الأسطر 76-92:** تخصيص ويدجيت عرض الأخطاء الشجرية (`ErrorWidget.builder`). إذا حدث عطب مفاجئ في شجرة الويدجيت البرمجية أثناء الرندرة، بدلاً من إظهار الشاشة الحمراء المخيفة للمستخدم، يتم استبدالها بشاشة بيضاء/رمادية أنيقة مكتوب فيها تفاصيل المشكلة للحفاظ على مظهر احترافي للتطبيق.

```dart
            initialRoute: AppRoutes.splash,
            onGenerateRoute: (settings) {
              switch (settings.name) {
```
* **الأسطر 93-95:** تحديد مسار الشاشة الافتراضية الأولى للتطبيق لتكون شاشة الـ Splash (`AppRoutes.splash`) وبدء تعريف محرك توليد المسارات الديناميكي `onGenerateRoute`.

```dart
                case AppRoutes.splash:
                  return MaterialPageRoute(
                    builder: (_) => SplashScreen(
                      onFinish: (context) async {
                        final hasSession = await UserSession.hasSession();
                        final route = state.locale == null
                            ? AppRoutes.welcome
                            : (hasSession
                                ? AppRoutes.main
                                : AppRoutes.login);
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed(route);
                        }
                      },
                    ),
                  );
```
* **الأسطر 97-112:** إدارة شاشة الـ Splash:
  - عند انتهائها (`onFinish`)، تقوم بفحص: هل توجد جلسة مستخدم سابقة (`hasSession`)؟
  - إذا لم يختر لغة بعد، تذهب به إلى شاشة الترحيب واللغات (`AppRoutes.welcome`).
  - إذا كانت الجلسة موجودة تذهب به للواجهة الرئيسية للتطبيق (`AppRoutes.main`) لتخطي تسجيل الدخول.
  - إذا لم يكن هناك جلسة نشطة، تذهب به لشاشة تسجيل الدخول (`AppRoutes.login`).

```dart
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

                case AppRoutes.forgotPassword:
                  return MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  );
```
* **الأسطر 114-132:** توجيه المستخدم لشاشات الترحيب، الدخول، التسجيل، واستعادة كلمة المرور عند طلبها.

```dart
                case AppRoutes.main:
                  return MaterialPageRoute(
                    builder: (_) => const MainNavigationHub(),
                  );
```
* **الأسطر 135-138:** توجيه المستخدم إلى شاشة الموجه الرئيسي للتبويبات (Main Navigation Hub).

```dart
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
```
* **الأسطر 141-151:** توجيه المستخدم لشاشة خيارات المقارنة (`RouteResultsScreen`) مع قراءة المعاملات المرسلة إليها (مثل اسم نقطة الانطلاق والوصول وكائن المواقع) وعرضها بناءً عليها.

```dart
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
```
* **الأسطر 153-174:** توجيه المستخدم إلى شاشة تفاصيل الرحلة وإرسال خيار المسار المختار والمعاملات لعرض الإرشادات خطوة بخطوة ومخطط الرحلة وسعر تذاكر القطارات.

```dart
                case AppRoutes.aiChat:
                  return MaterialPageRoute(
                    builder: (_) => const AIChatScreen(),
                  );

                case AppRoutes.train:
                  return MaterialPageRoute(
                    builder: (_) => const TrainScreen(),
                  );
```
* **الأسطر 177-185:** توجيه المستخدم إلى شاشة محادثة مساعد الذكاء الاصطناعي وشاشة خريطة القطارات التفاعلية.

```dart
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
```
* **الأسطر 187-221:** توجيه متوافق للمسارات القديمة لضمان عدم تعطل التطبيق ووصول المستخدم إلى الوجهة الصحيحة.

```dart
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
```
* **الأسطر 223-236:** المسار الافتراضي للحماية (Fallback Route). إذا حاول الكود توجيه المستخدم لاسم مسار غير مسجل أو غير موجود نهائياً، يفتح التطبيق صفحة فارغة مكتوب عليها "الخط السير غير متوفر" لتفادي انهيار البرنامج كلياً.
