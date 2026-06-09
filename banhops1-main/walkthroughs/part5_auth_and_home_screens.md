# الجزء الخامس: واجهات المصادقة والشاشة الرئيسية

في هذا الجزء، سنشرح واجهات المستخدم (UI Screens) لرحلة المصادقة (التسجيل والولوج واختيار اللغة) والواجهة الرئيسية (لوحة البحث السريعة).

---

## 1. شرح ملف شاشة البداية: [lib/features/splash/splash_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/splash/splash_screen.dart)
هذه شاشة متحركة بسيطة تظهر عند تشغيل التطبيق أول مرة.

```dart
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinish});
  final void Function(BuildContext context) onFinish;
```
* **الأسطر 3-6:** تعريف الويدجيت كـ `StatefulWidget` وتتطلب تمرير وظيفة رد نداء (`onFinish`) يتم استدعاؤها بعد انتهاء عرض الشاشة.

```dart
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 1400));
      if (mounted) {
        widget.onFinish(context);
      }
    });
  }
```
* **الأسطر 12-22:** في دالة `initState` (والتي تطلق عند رسم الشاشة لأول مرة)، نقوم بالانتظار لمدة **1.4 ثانية (1400 ملي ثانية)**، ثم نقوم باستدعاء الدالة `onFinish` المسؤولة عن تحويل المستخدم للشاشة المناسبة بناءً على حالته (تلقي اللغة وامتلاك جلسة).

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F4C81), Color(0xFF1B998B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
```
* **الأسطر 25-34:** دالة الـ `build` ترجع شاشة بـ `Scaffold` وخلفية متدرجة الألوان (Gradient) تدمج اللون الأزرق الداكن باللون الأخضر التركوازي بشكل مائل وانسيابي.

```dart
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.directions_bus_filled_rounded, size: 54, color: Colors.white),
              ),
              const SizedBox(height: 18),
              const Text('BanHops', style: ...),
              const SizedBox(height: 8),
              const Text('Banha Smart Transport Guide', style: ...),
            ],
          ),
        ),
```
* **الأسطر 35-62:** وضع محتويات الشاشة في المنتصف (أيقونة ميكروباص بيضاء محاطة بحلقة شفافة، اسم التطبيق "BanHops"، والنص التوضيحي "Banha Smart Transport Guide").

---

## 2. شاشة اختيار اللغة والترحيب: [lib/features/auth/presentation/welcome_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/auth/presentation/welcome_screen.dart)
تسمح للمستخدم باختيار لغة الواجهة عند أول استخدام.

```dart
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final appState = context.watch<AppState>();
```
* **الأسطر 14-16:** قراءة ملف الترجمات الحالي ومراقبة الحالة `AppState` لتحديث شاشة اللغة فور قيام المستخدم بالضغط على أحد الخيارات.

```dart
                    _LanguageCard(
                      title: localization.translate('english'),
                      subtitle: 'Navigate in English',
                      selected: appState.locale?.languageCode == 'en',
                      onTap: () async {
                        await appState.setLocale('en');
                      },
                    ),
```
* **الأسطر 63-70:** كرت اختيار اللغة الإنجليزية. يرسل المعامل `selected = true` إذا كانت اللغة الحالية للمتحكم هي الإنجليزية لتلوين الكرت باللون الأزرق المعتمد ووضع علامة التحقق (صح)، وعند الضغط يستدعي دالة `setLocale('en')` لحفظ التفضيل.

```dart
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: appState.locale == null
                            ? null
                            : () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                        child: Text(localization.translate('continue')),
                      ),
                    ),
```
* **الأسطر 81-90:** زر المتابعة. يكون معطلاً (`null`) إذا لم يقم المستخدم بتحديد أي لغة بعد، وبمجرد الاختيار يتم تفعيله، وعند الضغط عليه يوجه المستخدم لشاشة الدخول ويحذف شاشة الترحيب من مكدس الصفحات (`pushReplacementNamed`).

---

## 3. شاشات الولوج وإنشاء الحساب (Auth Screens) باختصار
- **[login_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/auth/presentation/login_screen.dart):**
  - تستخدم حقول الإدخال `TextFormField` لاستقبال اسم المستخدم وكلمة المرور مع متحكمات نصوص `TextEditingController`.
  - عند الضغط على "تسجيل الدخول"، تستدعي `authController.signIn(username, password)`.
  - إذا نجحت العملية، يتم التوجيه إلى الشاشة الرئيسية (`AppRoutes.main`)، وإذا فشلت تعرض رسالة الخطأ القادمة من السيرفر في شريط منبثق أسفل الشاشة (SnackBar).
  - تحتوي على خيارات تسجيل الدخول كضيف (Guest) ومصادقة فيسبوك وجوجل.
- **[register_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/auth/presentation/register_screen.dart):**
  - شاشة إنشاء الحساب. تطلب الاسم والبريد والهاتف وبها نظام تحقق من صحة المدخلات (Validation) مثل التأكد من مطابقة كلمة المرور وتنسيق البريد ورقم الهاتف قبل إرسال الطلب للسيرفر السحابي.
- **[forgot_password_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/auth/presentation/forgot_password_screen.dart):**
  - تطلب البريد الإلكتروني لإرسال كود الاستعادة، وتتواصل مع السيرفر وتظهر رسالة نجاح عند الإرسال.

---

## 4. الموجه العام لصفحات الشريط السفلي: [lib/features/navigation/main_navigation_hub.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/navigation/main_navigation_hub.dart)
يحتوي هذا الملف على الهيكل الأساسي الذي يستضيف الشاشات الثلاث الرئيسية بعد تسجيل الدخول.

```dart
class _MainNavigationHubState extends State<MainNavigationHub> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    HomeScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];
```
* **الأسطر 20-27:** الاحتفاظ برقم التبويب النشط حالياً (`_selectedIndex`) في المتغير المحلي، ومصفوفة تحوي الشاشات الثلاث (الرئيسية، السجل، الحساب الشخصي).

```dart
  @override
  Widget build(BuildContext context) {
    // ...
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
```
* **الأسطر 34-51:** بناء الواجهة وعرض الشاشة المحددة من المصفوفة بناءً على الرقم المختار في السلة، وعند قيام المستخدم بالضغط على أي أيقونة في الشريط السفلي، يتم استدعاء `setState` لتحديث رقم التبويب وإعادة رندرة الشاشة المناسبة فوراً.

---

## 5. الشاشة الرئيسية لطلب الرحلة: [lib/features/home/presentation/home_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/home/presentation/home_screen.dart)
هذه هي قمرة القيادة للتطبيق ومحور البحث عن المواصلات.

```dart
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final planner = context.watch<TripPlannerController>();
```
* **الأسطر 26-28:** قراءة نصوص اللغات ومراقبة حالة المخطط `TripPlannerController` لتحديث القوائم المنسدلة للبلاد والمدن والمسارات المكتشفة تلقائياً.

```dart
          _SearchCard(
            planner: planner,
            localization: localization,
          ),
```
* **السطر 73-76:** استدعاء كارت البحث الفرعي وتمرير متحكم الرحلات له لرسم القوائم وحساب التكلفة والمسارات.

* **شرح متحكمات كارت البحث الفرعي (`_SearchCard`):**
  - **قائمة المحافظة:** يعرض المحافظات المتاحة، وعند التغيير يستدعي `planner.setSelectedOriginGovernorate(value)` لتتغير قائمة المدن التابعة لها تلقائياً.
  - **قائمة المدينة:** يعرض المدن أو المراكز التابعة للمحافظة المختارة ويستدعي `setSelectedOriginCity`.
  - **قائمة الوجهة في بنها:** يعرض النقاط الداخلية لعاصمة القليوبية (الجامعة، الكليات، الموقف، المستشفى).
  - **زر "احصل على الطرق" (Get Routes):** عند الضغط عليه، يستدعي دالة التخطيط `planner.planTrip` ثم يوجه المستخدم لشاشة نتائج خيارات النقل (`RouteResultsScreen`) مرسلاً تفاصيل نقطة البداية والنهاية عبر المعاملات البرمجية (`arguments`).
