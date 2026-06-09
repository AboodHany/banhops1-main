# تدفق العمل وقاعدة البيانات لمشروع بنهوبس (Workflow & Database Guide)

يحتوي هذا الملف على شرح تفصيلي لـ **دورة عمل النظام (Workflow)** وكيفية انتقال البيانات بين الشاشات والخدمات، بالإضافة إلى **معمارية قاعدة البيانات (Database Schema)** وجداولها وعلاقاتها البرمجية، مع الحفاظ على المصطلحات التقنية باللغة الإنجليزية.

---

## أولاً: تدفق عمل النظام (Operational Workflow)

يتمحور نظام بنهوبس حول دورتي عمل أساسيتين (Core User Journeys):

### 1. تدفق تخطيط الرحلات (Trip Planning Flow)

يوضح المخطط التالي كيفية انتقال الطلب من لحظة اختيار المستخدم لمحطة الانطلاق وحتى عرض إرشادات السير وحفظ الرحلة:

```mermaid
sequenceDiagram
    autonumber
    actor User as الراكب (User)
    participant UI as واجهة التطبيق (HomeScreen/UI)
    participant Ctrl as TripPlannerController
    participant Repo as TripRepository
    participant Manager as TripManager (Routing Engine)
    participant DB as Supabase DB (Cloud)

    User->>UI: يحدد نقطة الانطلاق والوصول ويضغط "Get Routes"
    UI->>Ctrl: استدعاء دالة planTrip()
    Ctrl->>Repo: طلب خطوط الميكروباصات والقطارات
    alt اتصال الإنترنت نشط
        Repo->>DB: استعلام من جداول microbuses و trains
        DB-->>Repo: قائمة الخطوط المتاحة
    else انقطاع الإنترنت (Offline Fallback)
        Repo->>Repo: قراءة ملفات benha_microbuses.json و benha_trains.json
    end
    Repo-->>Ctrl: إرجاع البيانات المرجعية للخطوط
    Ctrl->>Manager: تمرير المدخلات لدالة evaluate()
    Note over Manager: 1. فحص هل الوجهة داخل بنها وتحتاج سوزوكي داخلي؟<br/>2. حساب المسارات المباشرة والمترو والقطارات والـ LRT والمونوريل.<br/>3. تقييم وترتيب المسارات بناءً على (Time, Cost, Transfers Weight).
    Manager-->>Ctrl: إرجاع النتائج مرتبة (TripPlanResult)
    Ctrl->>Repo: حفظ الرحلة في سجل التاريخ (saveTrip)
    Repo->>DB: إدخال السجل في جدول trips و routes سحابياً (إذا كان مسجلاً)
    Ctrl->>UI: إشعار الواجهات بالتحديث (notifyListeners)
    UI->>User: التوجيه لـ RouteResultsScreen وعرض المسارات المقترحة
```

---

### 2. تدفق محادثة المساعد الذكي وحمايته (AI Chatbot & Guardrails Flow)

يوضح هذا التدفق كيف يتفاعل المستخدم مع الشات بوت، وكيف يتم حماية المساعد الذكي من الإجابة على الأسئلة الخارجية (Anti-Hallucination Guardrails):

```mermaid
graph TD
    A[الراكب يكتب سؤالاً في شاشة الشات] --> B(تحديث قائمة الرسائل وعرض مؤشر الكتابة Typing Indicator)
    B --> C[استدعاء دالة ask في ChatController]
    C --> D[إرسال السؤال إلى AiAgentService]
    D --> E{هل السؤال داخل نطاق مواصلات بنها والقليوبية؟}
    E -- لا (سؤال خارجي) --> F[تفعيل الـ Guardrails التلقائية للنموذج]
    F --> G[إرجاع رسالة اعتذار ثابتة وصارمة ومحددة]
    E -- نعم (سؤال ملاحة/تعريفة) --> H[تجميع الـ Context: إحداثيات البحث والمسارات المقترحة محلياً]
    H --> I[إرسال السؤال + الـ Context + System Instructions إلى Gemini 1.5 Flash]
    I --> J{هل نجح الاتصال بالـ API؟}
    J -- نعم --> K[صياغة النصيحة الذكية بلهجة مصرية محببة وإرجاعها]
    J -- لا --> L[تفعيل الـ Fallback Mechanism محلياً وإرجاع تلخيص ذكي للرحلة الفضلى]
    K --> M(عرض الرد في الشات وإيقاف مؤشر الكتابة وحفظ الرسالة في جدول chats)
    L --> M
    G --> M
```

---

## ثانياً: معمارية قاعدة البيانات (Database Schema - Supabase)

يعتمد التطبيق على قاعدة بيانات علائقية (Relational Database) تدار عبر **Supabase** ومبنية على محرك **PostgreSQL** القوي.

### 1. مخطط العلاقات البرمجية للجداول (Database ERD)

```mermaid
erDiagram
    users {
        uuid id PK "auth.users.id"
        text name
        bigint current_location_id FK
        timestamptz created_at
    }
    locations {
        bigint id PK
        varchar name
        point coordinates
        location_type type "ENUM"
        timestamptz created_at
    }
    trips {
        bigint id PK
        uuid user_id FK
        bigint origin_id FK
        bigint dest_id FK
        integer est_time
        numeric est_cost
        integer transfers
        trip_status status "ENUM"
        timestamptz created_at
    }
    routes {
        bigint id PK
        bigint trip_id FK
        text details
        route_mode mode "ENUM"
        text gmaps_url
        timestamptz created_at
    }
    chats {
        bigint id PK
        uuid user_id FK
        text message
        text ai_response
        bigint trip_id FK
        timestamptz timestamp
    }
    microbuses {
        bigint id PK
        category varchar
        line_no integer
        route varchar
        fare numeric
    }
    trains {
        bigint id PK
        train_no varchar
        type varchar
        origin varchar
        dest varchar
        price numeric
        dep_time varchar
        arr_benha varchar
    }

    users ||--o| locations : "current_location"
    trips ||--|| users : "belongs_to"
    trips ||--|| locations : "starts_at"
    trips ||--|| locations : "ends_at"
    routes ||--|| trips : "defines"
    chats ||--|| users : "conducted_by"
    chats ||--o| trips : "references"
```

---

### 2. الشرح التفصيلي لجداول قاعدة البيانات وخصائصها التقنية

1. **جدول المواقع (`locations`):**
   - يخزن المحطات، المواقف، والجامعات.
   - يستخدم نوع بيانات هندسي خاص بنظام PostgreSQL وهو **`point`** لتخزين إحداثيات الـ GPS (خطوط العرض والطول) لدعم الحسابات الجغرافية بدقة.
   - حقل `type` هو عبارة عن **`ENUM`** مخصص يقبل قيم محددة فقط (University, Hospital, Station, Hub, Restaurant, Cafe).

2. **جدول المستخدمين (`users`):**
   - يرتبط بعلاقة رأس برأس (1:1) مع جدول المصادقة التلقائي في المنصة `auth.users` عبر حقل المعرّف الفريد `id` (من نوع UUID).
   - يتم التحكم بمزامنة البيانات تلقائياً عند تسجيل حساب جديد باستخدام **Database Trigger** يقوم بتنفيذ وظيفة `handle_new_user()` لحفظ اسم المستخدم وتفاديه للأخطاء.

3. **جدول الرحلات (`trips`):**
   - يسجل سجل عمليات البحث والتخطيط المكتملة.
   - يرتبط بجدول المستخدمين (`user_id`) وجدول المواقع كـ Foreign Keys مرتين: الأولى لنقطة البداية (`origin_id`) والثانية لنقطة الوصول (`dest_id`).
   - يحتوي على قيود حماية (Constraints) لمنع إدخال بيانات خاطئة، مثل التأكد من أن نقطة البداية لا تطابق نقطة النهاية (`origin_id <> dest_id`).

4. **جدول تفاصيل المسار (`routes`):**
   - يسجل الخطوات التفصيلية للرحلة؛ حيث ترتبط كل رحلة في جدول `trips` بعدة مسارات فرعية في هذا الجدول (علاقة 1:N).
   - يحتوي على روابط خرائط جوجل المباشرة (`gmaps_url`) ووسيلة الانتقال المستخدمة.

5. **جدول المحادثات (`chats`):**
   - يخزن الأسئلة والردود التاريخية للمساعد الذكي لتمكين المستخدم من العودة وقراءة استفساراته السابقة.
   - يحتوي على علاقة اختيارية (Nullable FK) مع جدول الرحلات (`trip_id`) لمعرفة هل المحادثة كانت تستعلم عن رحلة معينة محتسبة أم استعلام عام.

6. **جدول القطارات والميكروباصات (`trains` & `microbuses`):**
   - جداول مرجعية ثابتة (Read-Only Tables) للاستعلام السريع عن المواعيد والتعريفة المحدثة لعام 2026.
   - تحتوي على فهارس بحث (Database Indexes) لتسريع عمليات الفلترة والاسترجاع.

---

### 3. سياسات الأمان والحماية (Row-Level Security - RLS)

لضمان أقصى درجات الأمان وحماية البيانات وتوافقها مع المعايير المهنية:
* تم تفعيل الـ **RLS** على جداول `users`, `trips`, `routes`, `chats`.
* لا يمكن لأي مستخدم استعلام أو إضافة أو تعديل أي سجل في جدول الرحلات أو الشات إلا إذا كان يمتلك جلسة نشطة موثقة بـ JWT، وكان المعرف الفريد للمستخدم في التوكن يطابق معرف السجل الحقيقي (`auth.uid() = user_id`).
* تم جعل جداول الاستعلام العامة (`locations`, `microbuses`, `trains`) مقروءة للجميع دون قيود (`using (true)`) لتسهيل الاستعلام السريع حتى في وضع الضيف (Guest Mode).
