# Khelify — Product Requirements Document (PRD)

**Version:** MVP 1.0 | **Target Launch:** Feb 24, 2026 | **Platform:** Android

---

## 1. Product Vision

Khelify is an AI sports coaching app that uses your phone camera to analyse athletic technique in real-time, score it 0-100, and track improvement over time. The goal is to democratise sports coaching — giving athletes access to an AI trainer they can carry in their pocket.

**Tagline:** "Train smarter. Score higher."

---

## 2. User Personas

### Persona A — The Grind Athlete
- Age: 16-24
- Trains regularly, no access to a professional coach
- Wants instant, honest feedback on form — not vague praise
- Competes casually, cares about their score going up

### Persona B — The Weekend Warrior
- Age: 20-35
- Plays football, cricket, or badminton socially
- Wants to see if they're doing better than last time
- Motivated by seeing peers' activity on the feed

---

## 3. Core Features (MVP Scope)

### 3.1 Authentication
- Email + password signup and login via Firebase Auth
- On first signup, a user profile is created in Firestore automatically
- Auth state persists across app restarts

### 3.2 Drill Recording & AI Scoring
- User selects a sport tab (Football / Badminton / Cricket)
- User selects a drill from the list (3-5 drills per sport)
- Camera opens and records the drill in real-time
- ML Kit Pose Detection analyses body landmarks during recording
- On completion, app calculates a score (0-100) via ScoringService
- Score is broken down by technique criteria (e.g. "Knee Drive: 85/100")
- Result is saved to `results` collection in Firestore
- A `feed` entry is also created for the social feed

### 3.3 Social Feed
- Shows recent drill activity from all users (not just friends)
- Feed entry shows: avatar, name, drill name, score (with colour bar), time ago
- Sorted by newest first, limited to 50 posts
- Loading state shows shimmer placeholders
- Feed is read-only — no likes, comments, or follows in MVP

### 3.4 User Profile
- Displays: avatar, display name, sport badge, total drills, best score, current tier
- Tier is derived from best score:
  - Elite (≥90) | Pro (75-89) | Advanced (60-74) | Beginner (<60)
- Edit profile: update display name, sport, avatar photo
- Avatar stored in Firebase Storage

### 3.5 Stats Dashboard
- Shows performance history for the logged-in user
- Charts: score over time (line chart), sport breakdown (pie/bar chart)
- Metrics: total drills, average score, best score, current tier
- Uses fl_chart for visualisation
- Data sourced from `results` Firestore collection

### 3.6 Explore / Discovery
- Browse drills by sport (Football / Badminton / Cricket)
- Filter by difficulty: Beginner / Intermediate / Advanced
- Tap a drill to see: name, description, instructions, estimated duration, scoring criteria
- No social discovery (no user search) in MVP

### 3.7 Settings & About
- Toggle: Notifications (UI only in MVP)
- Toggle: Dark Mode (app is dark-only; toggle is placeholder for future)
- Log Out → clears auth state, returns to login screen
- About screen: app name, version, sport icons, team credits

---

## 4. Out of Scope (Post-MVP)

- iOS support
- Social following / likes / comments
- Live coaching or video calls
- Leaderboards
- Paid tiers / subscription
- Apple Sign-In / Google Sign-In
- Push notifications (just UI toggle in MVP)

---

## 5. Non-Functional Requirements

| Requirement | Specification |
|-------------|---------------|
| Performance | App launch < 3 seconds |
| Offline | Shows cached profile and feed if offline |
| Camera | Must run on physical Android device (not emulator) |
| Min Android SDK | API 23 (Android 6.0) |
| Compile SDK | API 35 |
| Orientation | Portrait only |

---

## 6. Known Constraints

- Pose detection requires a physical device — camera does not work on emulator
- Firebase project currently has limited access (Lead + P have access; G, A, R2 added as needed)
- No custom backend — 100% Firebase
- All UI is dark theme only (no light mode toggle logic in MVP)
