# BanHops

BanHops is a Flutter-based smart transport guide for Benha, Egypt. The app includes localized onboarding, Supabase-backed auth scaffolding, multi-modal route comparison, an AI assistant layer, trip history, profile analytics, and a train map viewer.

## Required configuration

Provide these values before enabling production integrations:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `AI_AGENT_BASE_URL`
- `AI_AGENT_API_KEY`
- `GOOGLE_MAPS_API_KEY`
- `ENABLE_GOOGLE_SIGN_IN=true` when Google OAuth is configured in Supabase and the native clients
- `ENABLE_FACEBOOK_SIGN_IN=true` when Facebook OAuth is configured in Supabase and the native clients

Example launch:

```powershell
flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_anon_key --dart-define=AI_AGENT_BASE_URL=https://your-ai-agent.example.com --dart-define=AI_AGENT_API_KEY=your_ai_key --dart-define=GOOGLE_MAPS_API_KEY=your_maps_key
```

## Missing source data you still need to provide

- The official Benha microbus line matrix: stops, fares, service hours, and line identifiers.
- The municipal and regional train schedule dataset: line-by-line departure times, headways, and interchange rules.
- The exact AI Agent API contract: request URL, required headers, and response JSON schema.
- The final Google Maps native setup values for Android and iOS client manifests.

## Supabase

SQL migrations live under `supabase/migrations/`. Apply the schema first, then the seed file if you want the demo locations.

## Run

```powershell
flutter pub get
flutter run
```
