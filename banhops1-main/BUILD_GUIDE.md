# BanHops Build & Deployment Guide

## Setup الأولى (مرة واحدة)

### 1. جهز الـ .env file
```bash
# انسخ .env.example → .env
cp .env.example .env

# فتح .env في أي text editor
# احط الـ API key الجديد في:
SUPABASE_ANON_KEY=sb_publishable_....
```

**⚠️ المهم:** 
- `.env` ما تتcommit أبداً (محفوظ في `.gitignore`)
- الـ API key ما تشاركش في chat أو GitHub

---

## Build للـ Web

```bash
# طريقة 1: باستخدام .env (الأسهل)
flutter pub get
flutter run -d chrome --dart-define-from-file=.env

# طريقة 2: لـ production web
flutter build web \
  --dart-define=SUPABASE_URL=https://ujursejrleqjlrfghsfh.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_...
```

**النتيجة:** المشروع في `build/web/` → يرفع على أي hosting (Firebase, Vercel, Netlify, etc.)

---

## Build للـ APK (Android)

```bash
# طريقة 1: Debug APK (للـ testing فقط)
flutter build apk \
  --dart-define=SUPABASE_URL=https://ujursejrleqjlrfghsfh.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_...

# طريقة 2: Release APK (للـ production)
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://ujursejrleqjlrfghsfh.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_...
```

**النتيجة:** `build/app/outputs/flutter-apk/app-release.apk` → تنزل على الموبايل

---

## Build للـ iOS (اختياري - محتاج Mac)

```bash
flutter build ios --release
```

---

## Quick Start 🚀

```bash
# 1. تثبيت dependencies
flutter pub get

# 2. Run locally للـ testing
flutter run

# 3. Build Web
flutter build web

# 4. Build APK
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

---

## Troubleshooting

### Error: "SUPABASE_ANON_KEY is empty"
✅ **الحل:** تأكد من `.env` موجود و عندك الـ key فيه

### Error: "Unsupported class version"
✅ **الحل:** تحديث Java version
```bash
flutter doctor -v  # شوف الحالة
```

### Web build كبير جداً
✅ **الحل:** عادي، Flutter web أول build يكون كبير. Build الثاني أصغر.
