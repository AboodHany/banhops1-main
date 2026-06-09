# الجزء الثاني: نماذج البيانات والخدمات العامة

في هذا الجزء، سنشرح طبقة البيانات (Models) والخدمات العامة (Services) التي يعتمد عليها تطبيق بنهوبس للاتصال بقاعدة بيانات Supabase، وإدارة جلسات المستخدمين، وحساب الأماكن والمسارات المرجعية.

---

## أولاً: نماذج البيانات (Models)
النماذج هي عبارة عن كلاسات (Classes) تقوم بتحويل الجداول وقيم قاعدة البيانات الخام (مثل نصوص الـ JSON) إلى كائنات برمجية داخل كود Dart لتسهيل قراءتها واستخدامها في الواجهات.

### 1. ملف [lib/core/models/transit_enums.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/models/transit_enums.dart)
يحتوي هذا الملف على تعدادات (Enums) لتمثيل تصنيفات المواقع ووسائل النقل وحالة الرحلات بشكل ثابت وآمن.

```dart
enum TransitLocationType { university, hospital, station, hub, restaurant, cafe }
```
* **السطر 1:** تعداد أنواع المواقع المدعومة داخل بنها: (جامعة، مستشفى، محطة، موقف رئيسي، مطعم، مقهى).

```dart
enum TransitMode { train, microbus, borderBus }
```
* **السطر 3:** تعداد وسائل النقل المدعومة في التطبيق: (قطار، ميكروباص، حافلة حدودية للأقاليم البعيدة).

```dart
enum TripStatus { completed, cancelled, inProgress }
```
* **السطر 5:** تعداد حالات الرحلة: (مكتملة، ملغية، قيد التنفيذ).

```dart
enum ChatPhase { waitingForInput, analyzingInput, responseGenerated, readyForQAndA }
```
* **السطر 7:** تعداد مراحل محادثة المساعد الذكي: (انتظار السؤال، جاري التحليل، تم توليد الإجابة، جاهز للسؤال التالي).

```dart
String getLocationTypeLabel(TransitLocationType type) => type.name;
```
* **السطر 9:** دالة لتحويل نوع الموقع (Enum) إلى نص (String) مطابق لاسمه.

```dart
String getTransitModeLabel(TransitMode mode) => switch (mode) {
      TransitMode.train => 'TRAIN',
      TransitMode.microbus => 'MICROBUS',
      TransitMode.borderBus => 'BORDER_BUS',
    };
```
* **الأسطر 11-15:** دالة تحويل وسيلة النقل إلى نص باللغة الإنجليزية متطابقة تماماً مع قيم الـ ENUM المخزنة في قاعدة البيانات السحابية لتفادي أخطاء المزامنة.

```dart
String getTripStatusLabel(TripStatus status) => switch (status) {
      TripStatus.completed => 'COMPLETED',
      TripStatus.cancelled => 'CANCELLED',
      TripStatus.inProgress => 'IN_PROGRESS',
    };
```
* **الأسطر 17-21:** دالة مطابقة لحالة الرحلة وتحويلها إلى نص متوافق مع قاعدة البيانات.

```dart
extension TransitLocationTypeLabel on TransitLocationType {
  String get label => getLocationTypeLabel(this);

  static TransitLocationType fromString(String value) {
    return TransitLocationType.values.firstWhere(
      (element) => element.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TransitLocationType.hub,
    );
  }
}
```
* **الأسطر 23-32:** ملحق (Extension) على `TransitLocationType` يضيف خاصية `label` للحصول على الاسم النصي للموقع، ودالة `fromString` لتحويل النص القادم من قاعدة البيانات إلى Enum مكافئ مع وضع قيمة افتراضية `hub` كحماية.

---

### 2. ملف [lib/core/models/location_node.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/models/location_node.dart)
يمثل هذا الكائن أي محطة أو موقع في التطبيق (مثل جامعة بنها أو محطة رمسيس).

```dart
import 'transit_enums.dart';

class LocationNode {
  const LocationNode({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.alias,
    this.governorate,
  });
```
* **الأسطر 1-12:** تعريف الكلاس والخصائص المطلوبة لتمثيل أي نقطة جغرافية (المعرف الرقمي، الاسم، خطوط العرض والطول، نوع الموقع، اسم الشهرة الاختياري، والمحافظة التابع لها).

```dart
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final TransitLocationType type;
  final String? alias;
  final String? governorate;
```
* **الأسطر 14-20:** تعريف المتغيرات النهائية وثنائية الدقة (Double) للموقع الجغرافي.

```dart
  factory LocationNode.empty() {
    return LocationNode(
      id: 0,
      name: '',
      latitude: 0,
      longitude: 0,
      type: TransitLocationType.hub,
      alias: null,
      governorate: null,
    );
  }
```
* **الأسطر 22-32:** دالة مصنع لإنشاء كائن فارغ وافتراضي، وتستخدم كقيمة افتراضية (Placeholder) لتفادي أخطاء عدم توفر بيانات الموقع عند بدء التشغيل.

```dart
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'type': type.label,
        'alias': alias,
        'governorate': governorate,
      };
```
* **الأسطر 34-42:** دالة تحويل كائن الموقع إلى خريطة بيانات `Map (JSON)` لإرسالها للذكاء الاصطناعي أو حفظها في قاعدة البيانات.

```dart
  factory LocationNode.fromJson(Map<String, dynamic> json) {
    return LocationNode(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      type: TransitLocationTypeLabel.fromString(json['type'] as String? ?? 'hub'),
      alias: json['alias'] as String?,
      governorate: json['governorate'] as String?,
    );
  }
```
* **الأسطر 44-54:** دالة مصنع لتحويل خريطة بيانات JSON القادمة من قاعدة البيانات إلى كائن برمجي من نوع `LocationNode` مع معالجة تحويل الأرقام وقيم الـ null بأمان.

```dart
  String get coordinatesLabel => '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
}
```
* **السطر 56:** خاصية لعرض إحداثيات الموقع بشكل نصي منسق مقرب لأربع خانات عشرية.

---

### 3. بقية نماذج البيانات (Models) باختصار ودقة:
- **[chat_message.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/models/chat_message.dart):** يمثل الرسالة الواحدة في الشات وتتضمن: المرسل (role مثل user أو assistant)، المحتوى النصي للرسالة (content)، ووقت وتاريخ إرسالها (createdAt).
- **[microbus_line.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/models/microbus_line.dart):** يمثل خط سير الميكروباص ويحتوي على: المعرف (id)، الفئة (category)، رقم الخط (lineNo)، خط السير (route)، والتعريفة الرسمية (fare).
- **[transit_route_option.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/models/transit_route_option.dart):** يمثل أحد كروت الخيارات المعروضة للمستخدم وتتضمن: التكلفة الإجمالية المقدرة للرحلة، زمن الرحلة الإجمالي بالدقائق، عدد الانتقالات/التحويلات، التقييم، وتفاصيل خط السير والخرائط.
- **[trip_record.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/models/trip_record.dart):** يمثل السجل النهائي للرحلة المحفوظة في تاريخ المستخدم ومكتملة البيانات.

---

## ثانياً: الخدمات العامة (Services)
الخدمات هي الكلاسات المسؤولة عن أداء وظائف محددة للاتصال مع السيرفرات أو إدارة مهام الهاتف كالموقع أو الذاكرة المؤقتة.

### 1. ملف [lib/core/services/supabase_service.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/services/supabase_service.dart)
هذه الخدمة هي نقطة الربط الوحيدة مع قاعدة البيانات السحابية Supabase.

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

class SupabaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;
```
* **الأسطر 1-8:** تعريف الخدمة واستخدام متغير ثابت للتحقق من أن قاعدة البيانات تم تهيئتها لمرة واحدة فقط لعدم إهدار موارد الجهاز.

```dart
  static Future<void> initialize(AppConfig config) async {
    if (!config.hasSupabase || _isInitialized) {
      return;
    }

    await Supabase.initialize(
      url: config.supabaseUrl,
      anonKey: config.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: true,
      ),
    );
    _isInitialized = true;
  }
```
* **الأسطر 10-23:** دالة التهيئة. تقرأ رابط السيرفر ومفتاح الحماية المجهول (`anonKey`) من ملف الإعدادات `config` وتطلق الاتصال السحابي مع تشغيل خيار تحديث التوكن تلقائياً لأمان المستخدم (`autoRefreshToken: true`).

```dart
  static SupabaseClient? get client {
    if (!_isInitialized) {
      return null;
    }
    return Supabase.instance.client;
  }

  static bool get hasAuthenticatedSession =>
      _isInitialized && Supabase.instance.client.auth.currentSession != null;
}
```
* **الأسطر 25-34:** إتاحة الوصول المباشر لكائن السيرفر عبر `client` للتعديل والاستعلام عن الجداول، وفحص هل يوجد جلسة مصادقة نشطة للمستخدم الحالي أم لا.

---

### 2. ملف [lib/core/services/trip_repository.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/services/trip_repository.dart)
مستودع الرحلات والخطوط. يستعلم عن خطوط القطارات والميكروباصات من Supabase وفي حال عدم وجود إنترنت يستعلم من ملفات JSON المحلية لضمان تشغيل دائم للتطبيق.

```dart
class TripRepository {
  static const String _tableName = 'trips';
```
* **السطر 12:** تحديد اسم جدول الرحلات الأساسي في قاعدة البيانات.

```dart
  Future<List<TripRecord>> fetchHistory({String? userId}) async {
    final client = SupabaseService.client;

    if (client == null) {
      return DemoTransitCatalog.history;
    }
```
* **الأسطر 14-19:** جلب تاريخ رحلات المستخدم. إذا لم يكن هناك اتصال بقاعدة البيانات (client == null) يعود التطبيق بالبيانات التجريبية المحلية كحل بديل.

```dart
    try {
      final query = client.from(_tableName).select();

      if (userId != null) {
        query.eq('user_id', userId);
      }

      final response = await query.order('created_at', ascending: false);
      final tripsList = response as List<dynamic>;
```
* **الأسطر 21-29:** استعلام من جدول `trips` وفلترة النتائج لتخصيصها بالمستخدم الحالي فقط (`user_id`) وترتيب الرحلات من الأحدث للأقدم.

```dart
      final List<TripRecord> records = [];
      for (final json in tripsList) {
        final originId = json['origin_id'] as int? ?? 0;
        final destId = json['dest_id'] as int? ?? 0;

        final origin = DemoTransitCatalog.locations.firstWhere(
          (loc) => loc.id == originId,
          orElse: () => LocationNode(id: originId, name: 'Unknown Location', latitude: 0, longitude: 0, type: TransitLocationType.hub),
        );
        // ... (تكرار نفس الشيء للوجهة)
```
* **الأسطر 31-57:** الدوران على البيانات المستلمة ومطابقة معرفات البداية والنهاية الجغرافية مع كتالوج المواقع المحلي لعرض أسمائها بدلاً من معرفاتها الرقمية الصامتة.

```dart
        final routesResponse = await client
            .from('routes')
            .select('details')
            .eq('trip_id', json['id']);
        final routesList = (routesResponse as List<dynamic>)
            .map((r) => r['details'] as String)
            .toList();
```
* **الأسطر 60-66:** استعلام إضافي من جدول المسارات الفرعي (`routes`) لجلب وصف خط السير التفصيلي المرتبط بالرحلة المحددة.

```dart
        records.add(TripRecord(
          id: json['id'] as int? ?? 0,
          origin: origin,
          destination: destination,
          estimatedTime: json['est_time'] as int? ?? 0,
          estimatedCost: (json['est_cost'] as num?)?.toDouble() ?? 0.0,
          transfers: json['transfers'] as int? ?? 0,
          status: TripStatusLabel.fromString(json['status'] as String? ?? 'COMPLETED'),
          createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
          routes: routesList.isNotEmpty ? routesList : const ['Trip Route'],
        ));
      }
      return records;
```
* **الأسطر 68-81:** بناء قائمة من كائنات الـ `TripRecord` بالبيانات الكاملة وإرجاعها للواجهة لعرضها للمستخدم في تبويب التاريخ.

```dart
  Future<void> saveTrip(TripRecord trip, {String? userId}) async {
    final client = SupabaseService.client;
    if (client == null) return;
    try {
      final targetUserId = userId ?? client.auth.currentUser?.id;
      if (targetUserId == null) return;

      await _ensureLocationExists(client, trip.origin);
      await _ensureLocationExists(client, trip.destination);
```
* **الأسطر 112-124:** حفظ الرحلة الجديدة في تاريخ المستخدم في السحاب. تتأكد الدالة أولاً من وجود نقاط الانطلاق والوصول في قاعدة البيانات (`_ensureLocationExists`) لتفادي فشل العلاقات البرمجية مع جدول المواقع (Foreign Key Constraints).

```dart
      final tripData = {
        'user_id': targetUserId,
        'origin_id': trip.origin.id,
        'dest_id': trip.destination.id,
        'est_time': trip.estimatedTime,
        'est_cost': trip.estimatedCost,
        'transfers': trip.transfers,
        'status': trip.status.name.toUpperCase(),
        'created_at': trip.createdAt.toIso8601String(),
      };

      final response = await client.from(_tableName).insert(tripData).select('id').single();
      final tripId = response['id'] as int;
```
* **الأسطر 126-139:** إدخال بيانات الرحلة والحصول على معرف الرحلة المولد تلقائياً من قاعدة البيانات السحابية (`tripId`) لحفظ تفاصيل المسار الفرعي معلقاً عليه.

```dart
      for (final routeDetail in trip.routes) {
        await client.from('routes').insert({
          'trip_id': tripId,
          'details': routeDetail,
          'mode': 'MICROBUS',
          'gmaps_url': 'https://www.google.com/maps',
        });
      }
```
* **الأسطر 141-149:** إدخال خطوط السير التفصيلية في جدول `routes` وربطها بالرحلة لتكتمل العملية بنجاح.

---

### 3. بقية الخدمات (Services) باختصار وتفصيل:
- **[user_session.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/services/user_session.dart):** كلاس يتعامل مع `SharedPreferences` لحفظ الجلسة النشطة محلياً باسم المستخدم واسمه الأول وتاريخ عدد رحلاته لمزامنتهما وتجنب تكرار الدخول.
- **[storage_service.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/services/storage_service.dart):** يقوم بحفظ إعدادات لغة التطبيق الحالية والوضع المفضل للشاشة (داكن أو فاتح) في الذاكرة المستمرة للهاتف.
- **[location_service.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/services/location_service.dart):** يتواصل مع نظام تحديد المواقع (GPS) بالهاتف عبر مكتبة `geolocator` بعد فحص طلب الأذونات لتحديد موقع المستخدم الجغرافي الفعلي واستخدامه كنقطة انطلاق.
- **[auth_service.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/services/auth_service.dart):** يتعامل مع السيرفر الخلفي (`$_baseUrl`) للتسجيل والدخول وإرسال روابط الاستعادة وحماية الجلسات وعمليات الخروج، بالإضافة لدعم مصادقة فيسبوك وجوجل المدمجة.
- **[forgot_password_service.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/services/forgot_password_service.dart):** يتيح إرسال طلب استعادة كلمة المرور مباشرة إلى الباكيند.
- **[chat_persistence_service.dart](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib/core/services/chat_persistence_service.dart):** يقوم بحفظ واسترجاع نصوص محادثات المساعد الذكي من Supabase أو الذاكرة المحلية لعرضها فور فتح الشات وتجنب ضياع الحوار.
