# خريطة وهيكل مجلدات مشروع بنهوبس بالتفصيل (Project Structure Map)

يحتوي هذا الملف على الهيكل الشجري الكامل لملفات ومجلدات مشروع **بنهوبس (BanHops)**، متبوعاً بشرح تفصيلي لدور وأهمية كل ملف ومجلد برمي، مع إبقاء المصطلحات التقنية باللغة الإنجليزية كما هي مستخدمة في سوق العمل لتسهيل فهمها ومراجعتها للفريق.

---

## 1. مخطط الهيكل الشجري للنظام (ASCII Tree Diagram)

```text
banhops1-main/
├── .env                          # Environment Variables
├── .env.example                  # Template لملف البيئة
├── .gitignore                    # الملفات المستبعدة من الـ Version Control
├── analysis_options.yaml         # Linter Rules وكتابة الكود النظيف
├── pubspec.yaml                  # Configuration File وتحديد الـ Dependencies والـ Assets
├── pubspec.lock                  # إقفال وتثبيت إصدارات الـ Packages
├── benha_microbuses.json         # Local Fallback Data للميكروباصات
├── benha_trains.json             # Local Fallback Data للقطارات
│
├── android/                      # Native Android Code & Configurations
├── ios/                          # Native iOS Code & Configurations
├── web/                          # Web Assets & Configurations
├── windows/                      # Native Windows Runner
│
├── assets/                       # Static Assets (مجلد الصور والأيقونات)
│
├── supabase/                     # Database Backend (ملفات قاعدة البيانات السحابية)
│   └── migrations/               # Database Schema
│       ├── 20260526_0001_banhops_schema.sql
│       └── 20260526_0002_banhops_seed.sql
│
├── walkthroughs/                 # Documentation (ملفات الشرح التفصيلي لجميع الأكواد)
│   ├── part1_entry_and_config.md
│   ├── part2_models_and_services.md
│   ├── part3_trip_manager_deep_dive.md
│   ├── part4_state_controllers.md
│   ├── part5_auth_and_home_screens.md
│   ├── part6_search_and_features_screens.md
│   ├── defense_preparedness_qa.md # كبسولة أسئلة وأجوبة المناقشة
│   └── project_structure_map.md   # هذا الملف
│
└── lib/                          # Source Code Folder (مجلد الأكواد البرمجية الرئيسي للتطبيق)
    │
    ├── main.dart                 # Entry Point (نقطة انطلاق التطبيق الأولى)
    │
    ├── app/                      # Application Settings & Routing
    │   ├── app_routes.dart       # Routing Paths (أسماء وعناوين صفحات التطبيق)
    │   └── banhops_app.dart      # Root Widget & MultiProvider (حقن الحالات واللغات)
    │
    ├── core/                     # Core Layer (مكونات النظام العامة المشتركة)
    │   ├── config/
    │   │   └── app_config.dart   # Configuration Manager (قراءة متغيرات السيرفر)
    │   ├── data/
    │   │   └── demo_transit_catalog.dart # Demo/Fallback Catalog (بيانات الخطوط الثابتة محلياً)
    │   ├── localization/
    │   │   └── app_localizations.dart    # Localization Manager (إدارة الترجمة)
    │   ├── theme/
    │   │   └── app_theme.dart    # Theme Config (إعدادات الألوان للوضع الفاتح والداكن)
    │   ├── models/               # Data Models (كلاسات تحويل البيانات الجغرافية والرحلات)
    │   │   ├── app_user_profile.dart
    │   │   ├── chat_message.dart
    │   │   ├── location_node.dart
    │   │   ├── microbus_line.dart
    │   │   ├── transit_enums.dart
    │   │   ├── transit_route_option.dart
    │   │   └── trip_record.dart
    │   ├── services/             # Core Services (خدمات الاتصال بالخوادم والذكاء الاصطناعي)
    │   │   ├── ai_agent_service.dart     # Gemini API Service (تنسيق طلبات الشات)
    │   │   ├── auth_service.dart         # Authentication Service (تسجيل الدخول والـ Social Login)
    │   │   ├── location_service.dart     # GPS Service (طلب الصلاحيات وتحديد موقع الراكب)
    │   │   ├── storage_service.dart      # Local Storage (حفظ اللغة وثيم الشاشة محلياً في الهاتف)
    │   │   ├── supabase_service.dart     # Supabase DB Client (الاتصال وتفويض حماية قاعدة البيانات)
    │   │   ├── trip_repository.dart      # Trip Database CRUD (جلب وإضافة سجلات الرحلات)
    │   │   ├── user_session.dart         # User Session Manager (حفظ ومسح بيانات الجلسة)
    │   │   └── trip_manager.dart         # Routing Algorithm (خوارزمية حساب المسارات والتسعير)
    │   └── state/                # State Management (متحكمات البيانات لإعادة رندرة الشاشات فوراً)
    │       ├── app_state.dart            # App State Controller (تغيير اللغة والوضع الليلي فوراً)
    │       ├── auth_controller.dart      # Auth State Controller (إدارة مؤشرات تحميل الدخول والتسجيل)
    │       ├── chat_controller.dart      # Chat State Controller (تحديث قائمة الحوار في الشات ومؤشر الكتابة)
    │       └── trip_planner_controller.dart # Trip Planner Controller (تحديث واجهة لوحة البحث وحفظ التاريخ)
    │
    └── features/                 # Features Layer (شاشات واجهات المستخدم UI)
        ├── splash/
        │   └── splash_screen.dart        # Splash Screen (شاشة البداية وعرض الشعار)
        ├── auth/
        │   └── presentation/             # Authentication Screens (واجهات الدخول والتسجيل والاستعادة)
        │       ├── welcome_screen.dart   # Welcome & Language Selection (شاشة اختيار اللغة)
        │       ├── login_screen.dart
        │       ├── register_screen.dart
        │       └── forgot_password_screen.dart
        ├── navigation/
        │   └── main_navigation_hub.dart  # Navigation Hub (شريط التبويبات السفلي للتنقل)
        ├── home/
        │   └── presentation/
        │       └── home_screen.dart      # Home Cockpit (واجهة لوحة البحث عن الرحلات)
        ├── search/
        │   └── presentation/
        │       ├── route_results_screen.dart # Results Comparison (عرض ومقارنة كروت المسارات والفلترة)
        │       └── trip_details_screen.dart  # Journey Timeline (التفاصيل خطوة بخطوة وجداول القطارات والخرائط)
        ├── train/
        │   └── presentation/
        │       └── train_screen.dart     # Interactive Train Map (خريطة القطارات التفاعلية باللمس)
        ├── ai_chat/
        │   └── presentation/
        │       └── ai_chat_screen.dart   # Chat Screen (واجهة المحادثة مع المساعد الذكي بنهوبس AI)
        ├── history/
        │   └── presentation/
        │       └── history_screen.dart   # History Screen (عرض سجل الرحلات السابقة)
        └── profile/
            └── presentation/
                └── profile_screen.dart   # Profile & Settings (الملف الشخصي والإعدادات)
```

---

## 2. الشرح التفصيلي لملفات جذر المشروع (Root Files)

* **`.env` (Environment Variables):** يحتوي على الـ Configurations السرية للاتصال بالسيرفر (رابط قاعدة البيانات ومفتاح الـ Gemini API Key). هذا الملف لا يتم رفعه على مستودع الكود لحماية الخوادم.
* **`.env.example`:** نموذج توضيحي لملف البيئة يُظهر فقط أسماء المفاتيح المطلوبة لكي يعرف المطور ما هي البيانات المطلوبة لتشغيل التطبيق.
* **`.gitignore`:** ملف يخبر برنامج Git بالملفات الحساسة والمجلدات المؤقتة التي يجب استبعادها من عملية الرفع إلى الـ Repository (مثل مجلد الـ build وملف الـ `.env`).
* **`analysis_options.yaml`:** ملف يحتوي على الـ Static Analysis Rules وموجهات الـ Linter لفرض أسلوب كتابة كود نظيف ومتوافق مع معايير شركة Google.
* **`pubspec.yaml` (Package Manager):** الملف المركزي لتحديد إعدادات المشروع؛ مثل اسم التطبيق وإصداره، وقائمة الـ Dependencies (المكتبات الخارجية المضافة مثل مكتبة الخرائط وجوجل)، ومسارات الـ Assets الثابتة.
* **`pubspec.lock`:** يضمن قفل وتثبيت النسخ التفصيلية لكل مكتبة تم تنزيلها لضمان تشابه بيئة العمل لكل المطورين.
* **`benha_microbuses.json` & `benha_trains.json` (Local Cache):** ملفات نصوص تحتوي على بيانات خطوط المواصلات والقطارات الثابتة، وتعمل كـ Fallback Data محلياً في حال عدم توفر اتصال بالإنترنت.

---

## 3. الشرح التفصيلي لمجلدات المنصات الأصلية (Native Platform Folders)

* **`android/` (Native Android):** يحتوي على ملف الـ AndroidManifest وملفات بناء الـ Gradle. هنا نقوم بإضافة أذونات نظام أندرويد الرسمية (مثل إذن الوصول للـ GPS وتحديد المواقع).
* **`ios/` (Native iOS):** يحتوي على ملف الـ Info.plist والـ Podfile لإدارة مكتبات آبل الرسمية وطلب أذونات نظام التشغيل iOS.
* **`web/` (Web Build):** يحتوي على ملف الـ index.html والـ Service Workers المسؤولة عن تحويل التطبيق إلى Web App يمكن فتحه من أي متصفح.
* **`windows/`:** يحتوي على كود لغة C++ الأساسي والمسؤول عن تشغيل التطبيق كبرنامج أصلي على نظام تشغيل Windows للكمبيوتر.

---

## 4. الشرح التفصيلي لمجلد الـ lib (Source Code Structure)

يمثل مجلد [lib/](file:///c:/xampp/htdocs/Employee_Task_MS/banhops1-main/banhops1-main/lib) الهيكل المعماري البرمجي للتطبيق ويقسم إلى ثلاث طبقات رئيسية:

### أ. ملف الانطلاق (Entry Point)
* **`main.dart`:** الملف الأول الذي يبدأ عنده معالج النظام بالعمل؛ حيث يقوم بتهيئة روابط فلاتر واتصال قاعدة البيانات وإطلاق التطبيق.

### ب. طبقة إعدادات التطبيق والتوجيه (App Configuration & Routing)
* **`app/app_routes.dart`:** كلاس لتعريف الـ Routing Paths بشكل ثابت لسهولة التنقل بالاسم البرمجي.
* **`app/banhops_app.dart` (Root Widget):** يقوم بإنشاء الـ MaterialApp وحقن الحالات والتحكم باللغات عبر الـ MultiProvider.

### ج. طبقة المكونات المشتركة العامة (Core Layer)
* **`core/config/app_config.dart`:** قراءة متغيرات الـ Environment وسد الفجوات في حال غيابها.
* **`core/data/demo_transit_catalog.dart`:** يحتوي على الـ Static Catalog للمدن ومحطات الانطلاق السريع.
* **`core/localization/app_localizations.dart`:** مسؤول عن تبديل وترجمة الكلمات بشكل فوري داخل الواجهات.
* **`core/theme/app_theme.dart`:** إعدادات ألوان وعناصر التصميم الداخلي للوضعين الفاتح والداكن.
* **`core/models/` (Data Models):** كلاسات برمجية لتحويل نصوص الـ JSON الخام القادمة من السيرفر إلى كائنات برمجية داخل كود Dart (مثل `LocationNode` للمواقع، و`TransitRouteOption` لكروت النتائج).
* **`core/services/` (Services):** الخدمات البرمجية النشطة؛ مثل الاتصال بقاعدة البيانات (`SupabaseService`)، وخدمة تحديد الموقع الجغرافي بالهاتف (`LocationService`)، وخدمة تسجيل الجلسة وكاش الاسم الشخصي (`UserSession`).
* **`core/services/trip_manager.dart` (Routing Engine):** الدماغ والمحرك الرئيسي للبرنامج؛ يحتوي على خوارزمية حساب المسارات وربط المترو والقطار والـ LRT، وقاعدة تسعير السوزوكي الداخلي بـ 5 جنيه الثابتة.
* **`core/state/` (State Management):** كلاسات ترث من `ChangeNotifier` وتتحكم بحفظ وتحديث البيانات وإعادة رندرة الشاشات فوراً باستخدام الدالة `notifyListeners()`.

### د. طبقة واجهات المستخدم (Features/UI Layer)
مقسمة إلى ميزات برمجية مستقلة، وكل ميزة تحتوي على شاشاتها المستقلة:
* **`splash/splash_screen.dart`:** شاشة البداية وعرض الشعار وفحص الجلسات.
* **`auth/presentation/`:** شاشات التسجيل والولوج والترحيب واختيار اللغات.
* **`navigation/main_navigation_hub.dart`:** يستضيف الـ BottomNavigationBar للتنقل السريع بين التبويبات.
* **`home/presentation/home_screen.dart`:** اللوحة الرئيسية للبحث عن المسارات وكروت الانطلاق السريع.
* **`search/presentation/route_results_screen.dart`:** لعرض ومقارنة كروت بدائل السير وترتيبها وتصفيتها بالفلاتر.
* **`search/presentation/trip_details_screen.dart`:** لعرض تفاصيل المسار المختار خطوة بخطوة، والخرائط الحقيقية، وجدول مواعيد وتذاكر القطارات.
* **`train/presentation/train_screen.dart`:** لوحة تفاعلية مرسومة بالـ Canvas برمجياً لعرض محطات السكك الحديدية ودعم التكبير واللمس.
* **`ai_chat/presentation/ai_chat_screen.dart`:** واجهة المحادثة مع المساعد الذكي "بنهوبس AI" وطلب النصائح.
* **`history/` & `profile/`:** واجهات تتبع الرحلات القديمة وإحصائيات الحساب وتغيير الإعدادات وتسجيل الخروج.
