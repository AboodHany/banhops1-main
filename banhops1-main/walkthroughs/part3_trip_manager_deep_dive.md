# الجزء الثالث: خوارزمية تخطيط الرحلات (TripManager Deep Dive)

في هذا الجزء، سنقوم بتشريح الملف الأهم والأكبر في логиك التطبيق وهو [lib/core/services/trip_manager.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/services/trip_manager.dart). هذا الملف هو المسؤول عن الذكاء الحركي للتطبيق؛ حيث يقوم بحساب وتخمين خطوط السير والبدائل ودمج المترو والقطار والسوزوكي الداخلي وحساب الأجرة الرسمية لعام 2026.

سنقوم بشرح الوظائف والدوال (Functions) بالتفصيل والترتيب المنطقي لتنفيذها:

---

## 1. المدخلات وقاموس الترجمات والثوابت

```dart
class TripManager {
  const TripManager();

  static const Map<String, String> _locationTranslations = {
    'Cairo': 'القاهرة',
    'Giza': 'الجيزة',
    // ... (قاموس ترجمة لجميع المحافظات والمدن والمحطات الداعمة للعربية)
  };
```
* **الأسطر 6-213:** تعريف كلاس `TripManager` وبداخله خريطة ثنائية ثابتة `_locationTranslations` لترجمة أسماء المواقع والمحطات وخطوط المترو إلى اللغة العربية بشكل فوري داخل دالة حساب المسارات لضمان التوافق التام مع واجهة التطبيق العربية.

```dart
  static const List<Map<String, dynamic>> _trains = [
    {
      "train_no": "901",
      "type": "مكيف فرنسي",
      "type_en": "French AC",
      "origin": "القاهرة",
      "origin_en": "Cairo",
      "dest": "الإسكندرية",
      "dest_en": "Alexandria",
      "dep_time": "08:15",
      "arr_benha": "08:50",
      "price": 45.0,
      "duration": 35
    }
  ];
```
* **الأسطر 222-272:** تعريف جداول قطارات افتراضية ثابتة (`_trains`, `_tantaTrains`, `_mansouraTrains`, `_alexTrains`) تستخدم كبيانات مرجعية احتياطية في حال تعطل خادم السيرفر لضمان قدرة التطبيق على عرض مواعيد قطارات حقيقية للمستخدم في أي وقت.

---

## 2. الدالة الرئيسية للمقارنة والترتيب: `evaluate`

هذه الدالة هي التي يتم استدعاؤها من المتحكم (Controller) لتشغيل المنطق وحساب بدائل السير وترتيبها.

```dart
  TripPlanResult evaluate({
    required LocationNode origin,
    required LocationNode destination,
    TripPreferences preferences = const TripPreferences(),
    List<MicrobusLine> microbuses = const [],
    List<Map<String, dynamic>> trains = const [],
    String localeCode = 'en',
  }) {
    final rawAlternatives = _buildAlternatives(origin, destination, microbuses, trains, localeCode);
    final alternatives = rawAlternatives.where((route) => route.transfers <= 2).toList();
```
* **الأسطر 274-283:**
  - تتلقى الدالة موقع البداية (`origin`) وموقع النهاية (`destination`) وتفضيلات المستخدم وقائمتي الميكروباصات والقطارات.
  - تستدعي دالة `_buildAlternatives` لبناء كافة خيارات السير المتاحة.
  - تقوم بفلترة النتائج للتخلص من أي مسار يتطلب أكثر من تحويلتين (`transfers <= 2`) رأفة بالراكب وتسهيلاً للرحلة.

```dart
    if (alternatives.isEmpty) {
      return TripPlanResult(
        originLabel: _translate(origin.name, localeCode),
        destinationLabel: _translate(destination.name, localeCode),
        routes: const [],
        summary: localeCode == 'ar' ? 'لا توجد مسارات متاحة.' : 'No routes available.',
      );
    }
```
* **الأسطر 285-293:** حماية برمجية؛ إذا كانت قائمة المسارات المفلترة فارغة، تعود الدالة فوراً بكائن رحلة فارغ ورسالة تنبيه بلغة المستخدم تفيد بعدم توفر مسارات.

```dart
    final maxTime = alternatives.map((route) => route.durationMinutes).reduce((a, b) => a > b ? a : b).toDouble();
    final maxCost = alternatives.map((route) => route.estimatedCost).reduce((a, b) => a > b ? a : b);
    final maxTransfers = alternatives.map((route) => route.transfers).reduce((a, b) => a > b ? a : b).toDouble();
```
* **الأسطر 295-297:** حساب أعلى القيم المسجلة للوقت والتكلفة والتحويلات بين الخيارات المقترحة. نستخدم هذه القيم القصوى لعملية **التقييس والتوحيد (Normalization)** لتصبح مقارنة الأرقام عادلة وصحيحة رياضياً (تتراوح بين 0 و 1).

```dart
    final scored = alternatives.map((route) {
      final normalizedTime = maxTime > 0 ? route.durationMinutes / maxTime : 0.0;
      final normalizedCost = maxCost > 0 ? route.estimatedCost / maxCost : 0.0;
      final normalizedTransfers = maxTransfers > 0 ? route.transfers / maxTransfers : 0.0;
      final score = (normalizedTime * preferences.timeWeight) +
          (normalizedCost * preferences.costWeight) +
          (normalizedTransfers * preferences.transferWeight);
```
* **الأسطر 299-305:** الدوران على جميع الخيارات وحساب الدرجة الإجمالية (Score) لكل خيار بناءً على معادلة رياضية تضرب القيمة الموحدة في وزن الأولوية المفضل للمستخدم (الوقت، السعر، الراحة والتحويلات). الخيار ذو المجموع الأقل هو الأفضل.

```dart
      return TransitRouteOption(
        // ... (نسخ تفاصيل المسار مع إرفاق النتيجة المحتسبة)
      );
    }).toList()
      ..sort((a, b) => a.score.compareTo(b.score));
```
* **الأسطر 306-320:** بناء قائمة خيارات النقل الجديدة وترتيبها تصاعدياً بناءً على الـ `score` المحتسب (بحيث يظهر الخيار ذو النتيجة الفضلى أولاً).

```dart
    final best = scored.first;
    final ranked = [
      for (var index = 0; index < scored.length; index++)
        TransitRouteOption(
          // ... (تحديث كود الترتيب ووضع علامة isRecommended = true للخيار الأول فقط)
        ),
    ];
```
* **الأسطر 322-338:** استخراج الخيار الفائز الأول وتثبيت متغير التوصية الذكية (`isRecommended: true`) عليه، وإعادة بناء القائمة لتمييز هذا الخيار بنجمة برمجية في واجهة التطبيق.

```dart
    final summary = localeCode == 'ar'
        ? 'الرؤية الذكية تقترح ${best.title} لتحقيق أفضل توازن بين الوقت والتكلفة وراحة السفر.'
        : 'Smart Insight recommends ${best.title} for the best balance of time, cost, and transfer comfort.';

    return TripPlanResult(
      originLabel: originLabel,
      destinationLabel: destinationLabel,
      routes: ranked,
      summary: summary,
    );
  }
```
* **الأسطر 340-352:** توليد نص التلخيص الذكي بلغة المستخدم لإظهاره في كارت "الرؤية الذكية" بالواجهة الرئيسية، وإرجاع كائن الرحلة بالنتائج كاملة.

---

## 3. منطق السوزوكي الداخلي في بنها: `_buildAlternatives`

هذا الجزء يتحكم في قواعد النقل المحلية والتحويل من المواقف للمقاصد الداخلية في بنها.

```dart
  List<TransitRouteOption> _buildAlternatives(
    LocationNode origin,
    LocationNode destination,
    List<MicrobusLine> microbuses,
    List<Map<String, dynamic>> trains,
    String localeCode,
  ) {
    // ...
    final isDestSubBenha = destination.id >= 103 && destination.id <= 110;
```
* **الأسطر 355-372:**
  - يتم فحص معرف وجهة الوصول؛ فإذا كان يقع بين 103 و 110 (وهي المعرفات الخاصة بمقاصد بنها الداخلية مثل مجمع الكليات، كلية الهندسة، منطقة الأهرام، الفلل، إلخ) فإن هذا يعني أن المستخدم يحتاج لمواصلة داخلية إضافية.

```dart
    if (isDestSubBenha && origin.id != 101) {
      final baseAlternatives = _buildAlternativesBase(origin, terminalHub, microbuses, trains, localeCode);
      return baseAlternatives.map((baseRoute) {
        final destName = _translate(destination.name, localeCode);
        final newTitle = localeCode == 'ar'
            ? '${baseRoute.title} + سوزوكي داخلي'
            : '${baseRoute.title} + Internal Suzuki';
        // ... (تحديث الأجرة بزيادة 5 جنيه وإضافة 15 دقيقة للوقت الإجمالي وتعديل الوصف)
```
* **الأسطر 376-401:**
  - **قاعدة السوزوكي الداخلي:** إذا كان الراكب متجهاً لكلية أو مستشفى داخل بنها، تقوم الخوارزمية بحساب مسار الرحلة الطبيعي وصولاً إلى "موقف بنها الرئيسي" أولاً.
  - ثم تقوم بربط المسار تلقائياً بوصلة "سوزوكي داخلي" وترقية السعر بمقدار **5 جنيه** (التعريفة الرسمية)، وإضافة **15 دقيقة** للزمن الكلي للرحلة وتعديل نصوص الإرشادات لإخبار الراكب بالنزول في الموقف واستقلال السوزوكي للوجهة.

* **الأسطر 405-498:** تكرار نفس المنطق والقواعد البرمجية التبادلية في حال كان الانطلاق من المقاصد الداخلية لبنها، أو كان الوصول أو المغادرة عبر "محطة قطار بنها" (المعرف 102)؛ حيث يُعفى الراكب القادم بالقطار من ركوب السوزوكي إذا كانت المحطة هي وجهته النهائية، ولكن يربط بالسوزوكي إذا نزل في محطة القطار وأراد الذهاب لكليات الجامعة.

---

## 4. خريطة المترو والقطار والمونوريل الديناميكية: `_getRailAlternatives`

تقوم هذه الدالة بحساب مسارات معقدة ومتعددة المراحل لخطوط المترو الثلاثة، القطار الكهربائي الخفيف (LRT)، ومونوريل شرق وغرب النيل وتوصيلها بموقف السلام أو المؤسسة للركوب لبنها.

```dart
    final line1Indexes = const { 601: 0, 602: 1, 603: 2, ... 635: 34 };
    final line2Indexes = const { 701: 0, 702: 1, ... 720: 19 };
    // ...
```
* **الأسطر 553-651:** خرائط فهرسة ثابتة لكل محطات المترو والقطار الكهربائي والمونوريل. يحمل كل مفتاح معرف المحطة، وقيمته تمثل ترتيب المحطة في الخط (Index) لحساب عدد المحطات التي سيمر بها الراكب بدقة.

```dart
  double _getMetroFare(int stations) {
    if (stations <= 0) return 0.0;
    if (stations <= 9) return 10.0;
    if (stations <= 16) return 12.0;
    if (stations <= 23) return 15.0;
    return 20.0;
  }
```
* **الأسطر 510-516:** دالة حساب سعر تذكرة المترو الرسمية بناءً على عدد المحطات المستهلكة (من 1 لـ 9 محطات بـ 10 جنيه، ومن 10 لـ 16 بـ 12 جنيه، وهكذا).

* **الأسطر 684-728 (حساب مسارات الخط الأول):**
  - إذا تم رصد المستخدم في محطة تابعة للخط الأول (حلوان - المرج)، يتم حساب عدد المحطات حتى المرج الجديدة، واحتساب سعر تذكرة المترو، ثم إرشاده للنزول في المرج وركوب ميكروباص بنها المباشر من موقف المرج (الأجرة 28 جنيه).

* **الأسطر 730-774 (حساب مسارات الخط الثاني):**
  - إذا كان المستخدم في محطات الخط الثاني (المنيب - شبرا)، يتم حساب المحطات لشبرا الخيمة، وتذكرة المترو، ثم توجيهه لاستقلال ميكروباص بنها من موقف المؤسسة (الأجرة 22 جنيه).

* **الأسطر 776-848 (حساب مسارات الخط الثالث ومونوريل شرق وغرب النيل والـ LRT):**
  - حساب المحطات والتحويلات للوصول لعدلي منصور وموقف السلام، وربطها بميكروباص السلام-بنها (الأجرة 28 جنيه)، مع احتساب أسعار تذاكر المونوريل والـ LRT الرسمية حسب طول الرحلة.

---

## 5. دالة بناء المسارات الأساسية وتصفية التكرارات: `_buildAlternativesBase`

هذه الدالة تجمع كل الخيوط معاً وتتحكم في معالجة القرى والمدن البعيدة.

* **الأسطر 920-922:** حساب زمن الرحلة التقريبي للميكروباص بناءً على المسافة الجغرافية لحساب أوقات واقعية للقرى والمراكز المحيطة ببنها.
* **الأسطر 929-994 (البحث عن قطارات مباشرة):** فحص جدول القطارات وإذا كانت مدينة الانطلاق تحتوي على محطة سكة حديد (مثل القاهرة أو طنطا أو الإسكندرية أو المنصورة)، يتم إنشاء خيار ركوب القطار المباشر فوراً وعرض سعر التذاكر من الأدنى للأعلى حسب نوع القطار.
* **الأسطر 996-1022 (المحافظات البعيدة):** إذا كان المستخدم قادماً من الصعيد أو محافظة بعيدة جداً (مثل المنيا أو الفيوم أو بني سويف)، تقوم الخوارزمية تلقائياً باقتراح مسار مشترك: (قطار من محافظته ل رمسيس بالقاهرة، ثم قطار آخر من رمسيس ل بنها).
* **الأسطر 1025-1167 (محافظات الحدود):** معالجة خاصة لركاب شمال وجنوب سيناء والوادي الجديد والبحر الأحمر؛ حيث يتم توجيههم لركوب حافلات السفر الكبرى (جو باص، سوبر جيت، شرق الدلتا) للوصول للقاهرة أولاً، ثم استقلال ميكروباص الأقاليم لبنها.
* **الأسطر 1170-1215 (تصفية واسترجاع الميكروباص):** مقارنة البداية والنهاية مع خطوط الميكروباص في قاعدة البيانات وعرضها، وإذا لم يتوفر خط مباشر مسبق الإدخال، يتم تفعيل دالة التسعير التلقائي بناءً على إحداثيات الـ GPS لموقع المستخدم لتخمين الأجرة التقريبية للرحلة.

```dart
    final Set<String> seen = {};
    final List<TransitRouteOption> uniqueRoutes = [];
    for (final route in routes) {
      final key = '${route.mode.toString()}-${route.title}-${route.estimatedCost.toStringAsFixed(2)}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueRoutes.add(route);
      }
    }
    return uniqueRoutes;
```
* **الأسطر 1224-1233:** فلترة قائمة النتائج لمنع تكرار كروت المواصلات المتشابهة؛ حيث يتم تكوين مفتاح فرعي مدمج من (الوسيلة، اسم العنوان، السعر)، وإذا تكرر هذا المفتاح يُهمل الكرت الإضافي لتبقى النتائج نظيفة ومنظمة.
