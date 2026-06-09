# الجزء الرابع: متحكمات الحالة والتحكم (State Controllers)

في هذا الجزء، سنقوم بشرح الكيفية التي يدير بها تطبيق بنهوبس حالاته وتغيرات البيانات الفورية عبر أربعة متحكمات رئيسية (Controllers) موجودة في مجلد [lib/core/state/](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/state/).

---

## مقدمة مبسطة: كيف تعمل إدارة الحالة (State Management)؟
لنفترض أن لغة التطبيق تغيرت من العربية إلى الإنجليزية. كيف تعرف كل شاشات التطبيق بهذا التغيير فوراً وتقوم بتعديل واجهاتها؟
- نستخدم كلاسات ترث من **`ChangeNotifier`** (وهي ميزة مدمجة في فلاتر).
- تحتفظ هذه الكلاسات بمتغيرات الحالة (مثل اللغة المحددة أو الرحلة الحالية).
- عند تغيير أي متغير، يستدعي الكود الدالة **`notifyListeners()`**.
- تقوم هذه الدالة بإصدار إشارة لكل الشاشات والويدجيتس التي تراقب هذا المتحكم لتقوم بإعادة بناء نفسها (`Rebuild`) فوراً وعرض البيانات المحدثة.
- نستخدم حزمة `Provider` لحقن هذه الكلاسات وجعلها متاحة لجميع الواجهات باستخدام `context.watch` أو `context.read`.

---

## 1. شرح ملف [lib/core/state/app_state.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/state/app_state.dart)
هذا الكلاس مسؤول عن إدارة ثيم التطبيق (فاتح/داكن)، ولغة التطبيق (عربي/إنجليزي)، وحالة وضع الضيف.

```dart
class AppState extends ChangeNotifier {
  AppState({StorageService? storageService}) : _storageService = storageService ?? StorageService();

  final StorageService _storageService;

  Locale? _locale;
  bool _isReady = false;
  bool _guestMode = false;
  ThemeMode _themeMode = ThemeMode.system;
```
* **الأسطر 5-13:** تعريف الكلاس وتهيئة الخصائص الافتراضية؛ لغة التطبيق (`_locale`)، جاهزية التطبيق بعد تحميل التفضيلات (`_isReady`)، وضع الضيف (`_guestMode`)، والوضع اللوني للمظهر (`_themeMode`) الافتراضي للنظام.

```dart
  Future<void> loadLocale() async {
    try {
      final savedLang = await _storageService.getLang();
      _locale = savedLang == null ? null : Locale(savedLang);
      final savedTheme = await _storageService.getThemeMode();
      _themeMode = savedTheme == 'dark'
          ? ThemeMode.dark
          : savedTheme == 'light'
              ? ThemeMode.light
              : ThemeMode.system;
    } finally {
      _isReady = true;
      notifyListeners();
    }
  }
```
* **الأسطر 20-34:** قراءة التفضيلات المخزنة محلياً عند بدء إقلاع التطبيق (اللغة والثيم)، ونستخدم الـ `finally` لضمان تغيير علامة جاهزية التطبيق وإرسال إشعار التحديث للواجهات (`notifyListeners`) حتى لو فشلت القراءة.

```dart
  Future<void> setLocale(String languageCode) async {
    await _storageService.saveLang(languageCode);
    _locale = Locale(languageCode);
    notifyListeners();
  }
```
* **الأسطر 36-40:** حفظ وتغيير لغة التطبيق الجديدة في ذاكرة الهاتف وتحديث الواجهات فوراً.

```dart
  Future<void> toggleThemeMode() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _storageService.saveThemeMode(
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }
```
* **الأسطر 42-48:** التبديل بين الوضع الليلي والنهاري (الداكن والفاتح) وحفظ التغيير محلياً في الهاتف ثم إشعار الواجهات بالتعديل لرسم الألوان الجديدة.

---

## 2. شرح ملف [lib/core/state/auth_controller.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/state/auth_controller.dart)
يتحكم هذا الملف بحالة تسجيل المستخدم؛ هل التطبيق في مرحلة التحميل حالياً؟ هل هناك رسالة خطأ؟ وما هي بيانات الحساب الشخصي الحالية؟

```dart
class AuthController extends ChangeNotifier {
  AuthController({required AppConfig config}) : _authService = AuthService(config) {
    _loadCachedProfile();
  }
  // ...
  bool _isLoading = false;
  String? _errorMessage;
  AppUserProfile? _profile;
```
* **الأسطر 8-17:** تهيئة خدمة التسجيل وتحميل ملف المستخدم الكاش (`_loadCachedProfile`) وتعريف متغيرات حالة المصادقة (التحميل والخطأ والمستند الشخصي).

```dart
  Future<void> signIn({required String username, required String password}) async {
    await _runAuthAction(() => _authService.signIn(username: username, password: password));
  }

  Future<void> signUp({ ... }) async { ... }
```
* **الأسطر 43-94:** دوال الاتصال بخدمات تسجيل الدخول وإنشاء الحساب والدخول كضيف وتسجيل الخروج. تقوم جميعها بتمرير الطلبات لـ `AuthService`.

```dart
  Future<void> _runAuthAction(Future<AppUserProfile> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _profile = await action();
    } catch (error) {
      _errorMessage = error.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```
* **الأسطر 110-122:** دالة وسيطة ذكية لتشغيل أي عملية مصادقة؛ حيث تفعل مؤشر التحميل وتصفر الخطأ وتعيد رسم الشاشة، ثم تحاول جلب الحساب، وفي حال حدوث فشل تلتقط الخطأ وتخزنه لعرضه، وفي النهاية توقف مؤشر التحميل وتحدث الواجهات مجدداً.

---

## 3. شرح ملف [lib/core/state/chat_controller.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/state/chat_controller.dart)
هذا الملف يتحكم بسجل محادثات مساعد الذكاء الاصطناعي بنهوبس AI.

```dart
class ChatController extends ChangeNotifier {
  // ...
  List<ChatMessage> _messages = <ChatMessage>[];
  ChatPhase _phase = ChatPhase.readyForQAndA;
  String? _lastResponse;
```
* **الأسطر 11-22:** تعريف مصفوفة قائمة الرسائل المتداولة في الشات (`_messages`) وحالة المحادثة والمخرجات الأخيرة.

```dart
  Future<void> ask({
    required String prompt,
    required List<TransitRouteOption> alternatives,
    String? origin,
    String? destination,
  }) async {
    // ...
    final userMsg = ChatMessage(role: 'user', content: prompt.trim(), createdAt: DateTime.now());
    _messages = [..._messages, userMsg];
    _phase = ChatPhase.analyzingInput;
    notifyListeners();
```
* **الأسطر 71-84:** عند قيام المستخدم بإرسال سؤال: يتم إنشاء كائن رسالة وإضافته فوراً لقائمة الحوار، ويتم نقل حالة المحادثة إلى مرحلة التحليل والتفكير (`analyzingInput`) وإرسال إشعار للواجهة لعرض رسالة المستخدم وعرض فقاعة التفكير المتحركة (Typing Indicator).

```dart
    try {
      // ... (حفظ الرسائل محلياً إذا كان الدخول كـ Gemini API مباشر)
      final result = await _aiAgentService.generateAdvice( ... );

      _lastResponse = result.reply;
      final assistantMsg = ChatMessage(role: 'assistant', content: result.reply, ...);
      _messages = [..._messages, assistantMsg];
    } catch (e) {
      // ... (إضافة رسالة تفيد بوجود خطأ في الاتصال)
    } finally {
      _phase = ChatPhase.readyForQAndA;
      notifyListeners();
    }
  }
}
```
* **الأسطر 86-134:** إرسال السؤال مع الخيارات الذكية للرحلة لخدمة الذكاء الاصطناعي، واستقبال الرد وإضافته لقائمة الحوار وتخزينه، وفي النهاية إعادة حالة المساعد لـ "جاهز للاستقبال" وتحديث الشاشة لعرض رد المساعد فوراً.

---

## 4. شرح ملف [lib/core/state/trip_planner_controller.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/state/trip_planner_controller.dart)
هذا هو العقل المنسق لعمليات البحث وتخزين سجل الرحلات النشطة للواجهة الرئيسية.

```dart
class TripPlannerController extends ChangeNotifier {
  TripPlannerController({TripManager? tripManager}) : _tripManager = tripManager ?? const TripManager() {
    loadMicrobusLines();
    loadTrainLines();
  }
```
* **الأسطر 13-17:** باني كلاس المخطط؛ ينشئ كائن `TripManager` لتقييم المسارات، ويستدعي دوال تحميل خطوط القطارات والميكروباصات من المستودع لتجهيزها قبل بدء عمليات البحث.

```dart
  String _selectedOriginGovernorate = 'Cairo';
  LocationNode _selectedOriginCity = DemoTransitCatalog.defaultOrigin;
  LocationNode _selectedBenhaDestination = DemoTransitCatalog.defaultDestination;
  TripPlanResult? _latestPlan;
```
* **الأسطر 22-25:** المتغيرات التي تحتفظ بالاختيارات الحالية للمستخدم في لوحة البحث: المحافظة المختارة للبداية، مدينة البداية المحددة، وجهة الوصول المطلوبة داخل بنها، والنتيجة الأخيرة المحسوبة للمسار.

```dart
  void setSelectedOriginGovernorate(String gov) {
    _selectedOriginGovernorate = gov;
    final cities = getLocationsForGovernorate(gov);
    if (cities.isNotEmpty) {
      _selectedOriginCity = cities.first;
    }
    notifyListeners();
  }
```
* **الأسطر 45-52:** عند تغيير المحافظة المنسدلة من قبل المستخدم: يتم تحديث اسم المحافظة وتحديث قائمة المدن التابعة لها لتظهر أول مدينة تلقائياً، وإشعار الواجهة لإعادة الرسم والتصفية.

```dart
  TripPlanResult planTrip({TripPreferences preferences = const TripPreferences(), String localeCode = 'en'}) {
    _latestPlan = _tripManager.evaluate(
      origin: _selectedOriginCity,
      destination: _selectedBenhaDestination,
      preferences: preferences,
      microbuses: _microbusLines,
      trains: _trainLines,
      localeCode: localeCode,
    );
    _saveTripToHistory();
    Future.microtask(() => notifyListeners());
    return _latestPlan!;
  }
```
* **الأسطر 109-121:** دالة تخطيط الرحلة. تستدعي `evaluate` في الـ `tripManager` لحساب أفضل خيارات السير والتسعير وتخزين النتيجة في `_latestPlan` وحفظ الرحلة في السجل التاريخي، ثم استخدام `Future.microtask` لإرسال إشعار التحديث للواجهات بأمان دون التسبب في مشاكل تداخل الرندرة.
