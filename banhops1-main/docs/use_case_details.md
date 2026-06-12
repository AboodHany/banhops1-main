# BanHops — Use Case Specifications

## Overview
BanHops is a transit routing app for **Benha, Egypt**. It helps users find optimal routes between their origin city and destinations in Benha using microbus, train, metro, monorail, LRT, and border buses.

---

## Actors

| Actor | Description |
|-------|-------------|
| **Guest User** | Unauthenticated user browsing the app. Can do everything except view trip history and profile. |
| **Authenticated User** | Logged-in user. Has full access including trip history and profile management. |

---

## Use Case 1: Plan Trip

| Field | Value |
|-------|-------|
| **ID** | UC-01 |
| **Name** | Plan Trip |
| **Actor** | Guest User, Authenticated User |
| **Description** | User selects origin governorate, origin city, and a Benha destination, then requests available routes. |
| **Precondition** | App is open on home screen. |
| **Postcondition** | System computes and displays ranked route options. Trip is saved to history. |
| **Main Flow** | 1. User selects governorate from dropdown<br/>2. User selects origin city from dropdown<br/>3. User selects Benha destination from dropdown<br/>4. User taps "Get Routes"<br/>5. System computes route alternatives using microbus, train, metro, monorail, LRT, or border bus data<br/>6. System ranks routes by score (time + cost + transfers)<br/>7. System navigates to route results screen<br/>8. System saves the trip to local history and Supabase (if logged in) |
| **Alternative Flow A** | User taps a "Popular Zone" card → bottom sheet opens → user selects destination → same as step 4+ |
| **Alternative Flow B** | No routes available → system shows "No routes available" message |

---

## Use Case 2: View Route Results

| Field | Value |
|-------|-------|
| **ID** | UC-02 |
| **Name** | View Route Results |
| **Actor** | Guest User, Authenticated User |
| **Description** | User views a ranked list of route options with costs, duration, and transfer info. Can filter by mode or sort. |
| **Precondition** | User has planned a trip (UC-01). |
| **Postcondition** | User sees filtered/sorted route cards. |
| **Main Flow** | 1. System displays route cards ranked by score<br/>2. Each card shows: title, cost (EGP), transfers count, "View Details" button<br/>3. Recommended route is highlighted with a badge |
| **Alternative Flow** | User can filter by mode (Microbus, Train, Border Bus) or view all modes |
| **Includes** | UC-11 (Sort & Filter Routes) |

---

## Use Case 3: View Trip Details

| Field | Value |
|-------|-------|
| **ID** | UC-03 |
| **Name** | View Trip Details |
| **Actor** | Guest User, Authenticated User |
| **Description** | User views step-by-step guidance for a specific route, including leg-by-leg costs, transfer points, and transportation modes. |
| **Precondition** | User is on route results screen (UC-02). |
| **Postcondition** | Trip is saved to history. |
| **Main Flow** | 1. User taps "View Details" on a route card<br/>2. System saves the trip to history<br/>3. System navigates to details screen<br/>4. Screen shows: route plan with transfer points, timeline with transport mode icons, step-by-step guidance text in Arabic or English, cost breakdown per leg, total cost for 2026 rates<br/>5. User can tap "View on Google Maps" to open directions |
| **Alternative Flow A** | If route involves train: buttons to view train schedule and network map are shown |
| **Alternative Flow B** | User taps "Back to Results" to return |

---

## Use Case 4: Chat with AI Assistant

| Field | Value |
|-------|-------|
| **ID** | UC-04 |
| **Name** | Chat with AI Assistant |
| **Actor** | Guest User, Authenticated User |
| **Description** | User asks questions about routes, fares, timing, or stations and gets AI-powered responses. |
| **Precondition** | AI_AGENT_API_KEY is configured. |
| **Postcondition** | User receives AI response in the chat. |
| **Main Flow** | 1. User opens AI chat screen<br/>2. User types a question (e.g., "What is the fastest route?", "What cost?", "Nearest station?")<br/>3. System sends the question plus current trip context to Gemini/Groq API<br/>4. System displays the AI response<br/>5. Chat history is saved locally using Hive |
| **Alternative Flow A** | User taps a suggestion chip (Fastest route?, What cost?, Nearest station?) → auto-sends that prompt |
| **Alternative Flow B** | API key not configured → shows warning "Set API_KEY to start" |
| **Alternative Flow C** | User can clear chat history or change settings (reduce motion, auto-scroll, sound, haptics) |

---

## Use Case 5: View Trip History

| Field | Value |
|-------|-------|
| **ID** | UC-05 |
| **Name** | View Trip History |
| **Actor** | Authenticated User |
| **Description** | User views a chronological list of all previous trips with details. |
| **Precondition** | User is logged in. |
| **Postcondition** | List of previous trips is displayed. |
| **Main Flow** | 1. User navigates to history screen (via bottom nav or home app bar)<br/>2. System fetches trips from local memory + Supabase (if available)<br/>3. System displays trip cards sorted newest first<br/>4. Each card shows: origin/destination names, cost, transfers, status (completed/cancelled/in progress), route summary |
| **Alternative Flow** | No trips yet → shows empty state with message "No trips in the history log" + "Start your first trip from the home screen" |

---

## Use Case 6: View Profile / Account

| Field | Value |
|-------|-------|
| **ID** | UC-06 |
| **Name** | View Profile / Account |
| **Actor** | Authenticated User |
| **Description** | User views account information, completed trip count, and can sign out. |
| **Precondition** | User is logged in. |
| **Postcondition** | Profile screen is displayed. |
| **Main Flow** | 1. User navigates to profile screen<br/>2. System shows user name, email, avatar, completed trips count<br/>3. User can change theme (dark/light) or language<br/>4. User can sign out |
| **Includes** | UC-07, UC-08 |

---

## Use Case 7: Change Language

| Field | Value |
|-------|-------|
| **ID** | UC-07 |
| **Name** | Change Language |
| **Actor** | Guest User, Authenticated User |
| **Description** | User switches between English and Arabic. App updates all text immediately and switches to RTL layout for Arabic. |
| **Precondition** | Settings screen or welcome screen is open. |
| **Postcondition** | App locale is updated. |
| **Main Flow** | 1. User selects Arabic or English<br/>2. System updates locale<br/>3. All UI text switches language<br/>4. Layout direction switches RTL/LTR |

---

## Use Case 8: Change Theme

| Field | Value |
|-------|-------|
| **ID** | UC-08 |
| **Name** | Change Theme |
| **Actor** | Guest User, Authenticated User |
| **Description** | User toggles between Dark Mode and Light Mode. |
| **Precondition** | Settings screen or profile screen is open. |
| **Postcondition** | App theme is updated. |
| **Main Flow** | 1. User selects Dark or Light mode<br/>2. System applies theme immediately |

---

## Use Case 9: Sign In / Sign Up

| Field | Value |
|-------|-------|
| **ID** | UC-09 |
| **Name** | Sign In / Sign Up |
| **Actor** | Guest User |
| **Description** | User creates an account or logs in using email/password or Google/Facebook OAuth. |
| **Precondition** | User is on welcome/login/register screen. |
| **Postcondition** | User is authenticated and navigated to main screen. |
| **Main Flow (Sign In)** | 1. User enters email/username and password<br/>2. System validates credentials against Supabase Auth<br/>3. On success, navigates to main screen<br/>4. On failure, shows error message |
| **Main Flow (Sign Up)** | 1. User enters first name, last name, email, phone, password, confirms password<br/>2. User agrees to terms<br/>3. System validates all fields<br/>4. System creates account in Supabase Auth<br/>5. On success, shows success message and navigates to main screen |

---

## Use Case 10: Guest Mode

| Field | Value |
|-------|-------|
| **ID** | UC-10 |
| **Name** | Guest Mode |
| **Actor** | Guest User |
| **Description** | User continues without logging in. Can use most features except trip history and profile. |
| **Precondition** | User is on welcome screen. |
| **Postcondition** | User enters the app as guest. |
| **Main Flow** | 1. User taps "Continue as Guest"<br/>2. System navigates to main screen<br/>3. Trips are saved to local memory only (not persisted to server) |

---

## Use Case 11: Sort & Filter Routes

| Field | Value |
|-------|-------|
| **ID** | UC-11 |
| **Name** | Sort & Filter Routes |
| **Actor** | Guest User, Authenticated User |
| **Description** | User filters route results by transportation mode (All, Microbus, Train, Border Bus). Routes are sorted by cost ascending. |
| **Precondition** | Route results are displayed (UC-02). |
| **Postcondition** | Filtered/sorted list is shown. |
| **Main Flow** | 1. User taps a filter chip (All / Microbus / Train / Border Bus)<br/>2. System filters the route list by selected mode<br/>3. System sorts by cost (cheapest first)<br/>4. Updated list is displayed |

---

## Use Case 12: View Train Lines Map

| Field | Value |
|-------|-------|
| **ID** | UC-12 |
| **Name** | View Train Lines Map |
| **Actor** | Guest User, Authenticated User |
| **Description** | User views a visual map of train lines available to Benha. |
| **Precondition** | Home screen is open. |
| **Postcondition** | Train schedule or map screen is displayed. |
| **Main Flow** | 1. User taps "Train Lines" section on home screen<br/>2. User taps "View Train Lines Map"<br/>3. System navigates to train screen showing available trains with times and prices |

---

## Use Case 13: View Popular Zones

| Field | Value |
|-------|-------|
| **ID** | UC-13 |
| **Name** | View Popular Zones |
| **Actor** | Guest User, Authenticated User |
| **Description** | User sees quick-access zone cards on the home screen for popular Qalyubia cities. Tapping a zone opens a bottom sheet to pick a Benha destination. |
| **Precondition** | Home screen is open. |
| **Postcondition** | Bottom sheet with Benha destinations is displayed. |
| **Main Flow** | 1. User sees "Popular Zones" cards on home screen (Shubra, Kafr Shukr, Al-Obour)<br/>2. User taps a zone card<br/>3. Bottom sheet opens with all Benha destinations<br/>4. User selects a destination<br/>5. System plans the trip and navigates to route results |

---

## Use Case 14: Forgot Password

| Field | Value |
|-------|-------|
| **ID** | UC-14 |
| **Name** | Forgot Password |
| **Actor** | Guest User |
| **Description** | User recovers their password by providing registered username and email. |
| **Precondition** | User is on login screen. |
| **Postcondition** | Recovered password is displayed. |
| **Main Flow** | 1. User taps "Forgot Password?"<br/>2. User enters username and email<br/>3. System validates and retrieves password<br/>4. Password is displayed on screen |

---

## Data Flow Summary

| Data Source | Purpose | User |
|-------------|---------|------|
| **DemoTransitCatalog** | In-memory location data (governorates, cities, stations, popular zones, Benha destinations) | All users |
| **DemoTransitCatalog.history** | In-memory trip history for guest users | Guest |
| **Supabase (trips table)** | Persistent trip history for logged-in users | Authenticated |
| **Supabase (microbuses table)** | Microbus line data (category, route, fare) | All users |
| **Supabase (trains table)** | Train schedule data | All users |
| **Supabase Auth** | User authentication | Authenticated |
| **Gemini/Groq API** | AI chat responses | All users |
| **Hive (local DB)** | Chat history, user settings (theme, language) | All users |

---

## Route Generation Logic Summary

The `trip_manager.dart` evaluates routes based on:
1. **Origin city** and **Benha destination**
2. Generates alternatives: microbus direct, metro + microbus, monorail + metro + microbus, train direct, combined train, border bus + microbus
3. Each route scored by: `(time × weight) + (cost × weight) + (transfers × weight)`
4. Routes sorted by score (lower = better), top route is marked "Recommended"
5. Deduplication: max 2 cheapest routes per transport mode
