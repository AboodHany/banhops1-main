# الجزء السادس: شاشات الرحلات والقطارات والشات والملف الشخصي

في هذا الجزء الأخير، سنشرح بقية واجهات الاستعلام عن الطرق ومقارنتها، تفاصيل الرحلة، خريطة خطوط السكة الحديدية، مساعد الشات الذكي، والملف الشخصي.

---

## 1. شاشة خيارات النقل: [lib/features/search/presentation/route_results_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/search/presentation/route_results_screen.dart)
تعرض هذه الشاشة نتائج البحث والمسارات المقترحة.

```dart
class RouteResultsScreen extends StatefulWidget {
  const RouteResultsScreen({
    super.key,
    required this.originLabel,
    required this.destinationLabel,
    required this.origin,
    required this.destination,
  });
```
* **الأسطر 15-27:** تعريف الشاشة كـ `StatefulWidget` وتتلقى معاملات البداية والنهاية كنصوص جغرافية وكائنات إحداثيات GPS.

```dart
  Future<void> _loadRoutes() async {
    setState(() => _isLoadingRoutes = true);
    try {
      _tripPlanner.setOrigin(widget.origin);
      _tripPlanner.setDestination(widget.destination);

      final result = _tripPlanner.planTrip(localeCode: AppLocalizations.of(context).locale.languageCode);
      if (mounted) {
        setState(() {
          _routes = result.routes;
          _isLoadingRoutes = false;
        });
      }
    } catch (e) { ... }
  }
```
* **الأسطر 49-70:** دالة جلب المسارات. تقوم بتفعيل مؤشر الانتظار، وتمرر البيانات لـ `TripPlannerController` لحساب المسار والأسعار، ثم تخزن المسارات الناتجة في مصفوفة الحالة المحلية وتغلق مؤشر الانتظار لتحديث الواجهة بالنتائج الحقيقية.

```dart
  List<TransitRouteOption> _getFilteredAndSortedRoutes() {
    var filtered = _routes;
    if (_selectedMode != null && _selectedMode != 'ALL') {
      filtered = filtered
          .where((route) => getTransitModeLabel(route.mode) == _selectedMode)
          .toList();
    }
    filtered.sort((a, b) => a.estimatedCost.compareTo(b.estimatedCost));
    return filtered;
  }
```
* **الأسطر 72-84:** دالة الفلترة والترتيب. تفحص الخيار المختار في الفلتر العلوي (الكل، ميكروباص، قطار)، وتصفي المصفوفة بناءً عليه، ثم ترتب النتائج من الأرخص للأغلى سعراً لتظهر خيارات التوفير للمستخدم أولاً.

---

## 2. شاشة إرشادات السير خطوة بخطوة: [lib/features/search/presentation/trip_details_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/search/presentation/trip_details_screen.dart)
هذه الشاشة مسؤولة عن إعطاء الراكب توجيهات نصية ورسومية دقيقة للوصول لوجهته.

```dart
  List<String> _getTransferLocations(String routeId, String localeCode, int transfers) {
    if (transfers < 1) return const [];
    final isAr = localeCode == 'ar';
    final List<String> locs = [];
    if (routeId.contains('monorail-east-metro-microbus')) {
      locs.addAll(isAr 
          ? ['محطة الإستاد (المونوريل)', 'التمشية الي موقف السلام خلف محطة المترو']
          : ['El-Estad (Monorail)', 'Walk to El-Salam Bus Station behind Metro Station']);
    } // ... (التحقق من بقية معرفات الطرق وربط نقاط التحويل المناسبة)
    return locs;
  }
```
* **الأسطر 94-136:** دالة استخراج محطات التحويل والتبديل (Transfer Points). تقرأ معرّف المسار المختار (مثلاً: `monorail-east-metro-microbus`) وتحدد للراكب بلغة واجهته أين سينزل ليغير وسيلة المواصلات (مثل محطة الاستاد وموقف السلام).

```dart
  String _getRealGuidance(TransitRouteOption route, String origin, List<String> transferLocs, String destination, String localeCode) {
    // ...
    if (transferLocs.isEmpty) {
      if (route.mode == TransitMode.train) {
        if (isAr) {
          buffer.writeln('1. توجه إلى محطة القطار في $origin.');
          buffer.writeln('2. اقطع تذكرة قطار مباشر إلى محطة قطار بنها بقيمة ...');
        } // ...
      }
    }
```
* **الأسطر 291-352:** دالة توليد الإرشادات التفصيلية. تبني دليلاً مكتوباً خطوة بخطوة للرحلة بالكامل؛ تحدد للراكب أين يذهب، والخطوات التتابعية مع الأجرة الفردية لكل مرحلة، والأجرة الكلية المعتمدة.

---

## 3. خريطة السكة الحديدية التفاعلية: [lib/features/train/presentation/train_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/train/presentation/train_screen.dart)
تعرض رسماً بيانياً لخطوط القطار.

```dart
  Widget build(BuildContext context) {
    // ...
          AspectRatio(
            aspectRatio: 1.25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 3.2,
                child: CustomPaint(
                  painter: _TrainMapPainter(selectedHub: _selectedHub, isAr: isAr),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
```
* **الأسطر 31-44:** رسم الخريطة. نضع لوحة الرسم المخصصة `CustomPaint` (والتي ترسم الخطوط والمحطات برمجياً عبر الـ Canvas) داخل الويدجيت السحرية `InteractiveViewer` لتمكين الراكب من تكبير وتصغير الخريطة باللمس والتحرك في أرجائها بسلاسة.

* **منطق الرسام المخصص (`_TrainMapPainter`):**
  - **الأسطر 101-115:** رسم شبكة جمالية (Grid) رمادية خفيفة في خلفية الخريطة.
  - **الأسطر 117-125:** تحديد نقاط الإحداثيات للمحطات على اللوحة (بنها في المنتصف، القاهرة في الأسفل، طنطا في الأعلى، الزقازيق في الشرق، منوف في الغرب).
  - **الأسطر 148-162:** رسم خطوط الربط؛ حيث يتم التحقق من التبويب المختار (Hub)، وإذا اختار القاهرة مثلاً يتم رسم وتلوين خط القاهرة-بنها بالأزرق اللامع برمجياً، بينما تظل بقية الخطوط باللون الرمادي الخامل.
  - **الأسطر 191-227:** رسم حلقات دائرية مضيئة حول المحطات النشطة وكتابة أسمائها بالعربية أو الإنجليزية وتفادي تداخل النصوص.

---

## 4. محادثة مساعد الذكاء الاصطناعي: [lib/features/ai_chat/presentation/ai_chat_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/ai_chat/presentation/ai_chat_screen.dart)
شاشة التفاعل الفوري مع الروبوت الذكي.

```dart
  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }
```
* **الأسطر 38-46:** وظيفة التمرير التلقائي. تقوم بتحريك الشاشة لأسفل القائمة فوراً عند إضافة أي رسالة جديدة لضمان رؤية الردود فور كتابتها.

```dart
class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
```
* **الأسطر 219-296:** رسم مؤشر الكتابة التفاعلي (`_TypingBubble`). يستخدم `AnimationController` لرسم ثلاث نقاط زرقاء صغيرة ترتفع وتهبط بتأثير موجي انسيابي (عبر دالة جيب الزاوية `sin`) لمحاكاة التفكير البشري أثناء معالجة الذكاء الاصطناعي للسؤال.

---

## 5. شاشة الملف الشخصي والإعدادات: [lib/features/profile/presentation/profile_screen.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/features/profile/presentation/profile_screen.dart)
تعرض إحصائيات حساب المستخدم وتمكنه من تغيير الإعدادات.

```dart
      body: FutureBuilder<int>(
        future: TripRepository().countCompletedTrips(),
        builder: (context, snapshot) {
          final completedTrips = snapshot.data ?? DemoTransitCatalog.history.where(...).length;
```
* **الأسطر 23-26:** استخدام `FutureBuilder` للاستعلام بشكل غير متزامن من مستودع الرحلات عن عدد الرحلات التي أكملها المستخدم بنجاح، وعرض الرقم فور تحميله مع استخدام الذاكرة المحلية كبديل فوري.

```dart
                    ListTile(
                      leading: const Icon(Icons.language_rounded),
                      title: Text(localization.translate('language')),
                      trailing: Text(appState.locale?.languageCode == 'ar' ? 'العربية' : 'English', ...),
                      onTap: () {
                        final nextLang = appState.locale?.languageCode == 'ar' ? 'en' : 'ar';
                        appState.setLocale(nextLang);
                      },
                    ),
```
* **الأسطر 77-91:** تبويب اللغة. يعرض اللغة النشطة حالياً، وعند النقر يكتشف لغة التطبيق الحالية ويقوم بقلبها للغة المعاكسة فوراً وتغيير اتجاه التطبيق بالكامل.

```dart
                    final confirm = await showDialog<bool>( ... );
                    if (confirm == true && context.mounted) {
                      await context.read<AuthController>().signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                      }
                    }
```
* **الأسطر 105-132:** زر تسجيل الخروج. يظهر نافذة تأكيد منبثقة، وإذا وافق المستخدم يرسل أمراً للمتحكم لحذف الجلسة المؤقتة ومسح التوكن من فيسبوك وجوجل والهاتف، ثم يوجهه لشاشة الدخول ويحذف كل الصفحات السابقة من الذاكرة لضمان خصوصية الحساب.
