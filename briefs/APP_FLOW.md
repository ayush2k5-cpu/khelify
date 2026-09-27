# Khelify — App Flow & Navigation

**Platform:** Android | **Orientation:** Portrait only

---

## 1. App Entry Flow

```
App Launch
    │
    ▼
Firebase Init
    │
    ▼
AuthGate (watches Firebase auth state)
    │
    ├── User NOT logged in ──► LoginScreen
    │                               │
    │                         ┌─────┴──────┐
    │                         │            │
    │                    Sign In      "Sign Up" link
    │                         │            │
    │                         │      SignupScreen
    │                         │            │
    │                         └─────┬──────┘
    │                               │
    │                         Auth success
    │                               │
    └── User logged in ─────────────┘
                                    │
                                    ▼
                              MainLayout
                         (Bottom Navigation Shell)
```

---

## 2. Main Navigation Shell (MainLayout)

5-tab bottom nav bar with a **Record FAB** in the centre:

```
┌─────────────────────────────────────────┐
│                                         │
│           [Screen content]              │
│                                         │
├──────────────────────────────────────── ┤
│  🏠 Feed  🧭 Explore  [●]  📊 Stats  👤 Profile │
└─────────────────────────────────────────┘
                            ↑
                     Record FAB (blue circle)
                     navigates to /drill/select
```

| Tab Index | Icon | Label | Screen | Status |
|-----------|------|----|--------|--------|
| 0 | Home | Feed | `FeedScreen` | ✅ Built |
| 1 | Compass | Explore | `ExploreScreen` | 🔴 Placeholder |
| 2 | — | Record | FAB → Drill flow | ✅ Built |
| 3 | BarChart | Stats | `StatsScreen` | 🔴 Placeholder |
| 4 | User | Profile | `ProfileScreen` | 🔴 Placeholder |

---

## 3. Drill Recording Flow

Triggered by tapping the centre **Record FAB**:

```
MainLayout (FAB tap)
    │
    ▼ Navigator.pushNamed('/drill/select')
DrillSelectionScreen
    │   - Sport tabs: Football / Badminton / Cricket
    │   - List of drills for selected sport
    │   - Tap a drill card
    │
    ▼ Navigator.pushNamed('/drill/record', arguments: Drill)
DrillRecordingScreen
    │   - Camera opens
    │   - Pose detection starts
    │   - User performs drill
    │   - Timer running
    │   - On complete / stop
    │
    ▼ Navigator.pushNamed('/drill/results', arguments: {drill, scoringResult, duration})
DrillResultsScreen
    │   - Shows overall score (0-100)
    │   - Shows tier earned
    │   - Shows technique breakdown (e.g. Knee Drive: 85/100)
    │   - Saves result to Firestore `results` collection
    │   - Creates entry in Firestore `feed` collection
    │
    ▼ "Done" button
MainLayout (back to Feed tab)
```

---

## 4. Profile Flow

```
MainLayout (Tab 4: Profile)
    │
    ▼
ProfileScreen
    │   - Shows: avatar, name, sport, tier, total drills, best score
    │   - "Edit Profile" button
    │
    ▼ (tap Edit Profile)
EditProfileScreen
    │   - Edit: display name, sport, avatar
    │   - Save → updates Firestore `users` doc
    │   - Navigate back to ProfileScreen
    │
    └── (tap Settings icon) → SettingsScreen
```

---

## 5. Settings Flow

```
SettingsScreen (accessible from Profile or nav)
    │   - Notification toggle (UI only)
    │   - Dark mode toggle (placeholder)
    │   - "About Khelify" row
    │   - "Log Out" button
    │
    ├── "About Khelify" ──► AboutScreen
    │                            - App name, version, sport icons, credits
    │
    └── "Log Out" ──► Firebase signOut() ──► AuthGate ──► LoginScreen
```

---

## 6. Screen Inventory

| Screen | File Path | Feature |
|--------|-----------|---------|
| `AuthGate` | `lib/features/auth/screens/auth_gate.dart` | Auth |
| `LoginScreen` | `lib/features/auth/screens/login_screen.dart` | Auth |
| `SignupScreen` | `lib/features/auth/screens/signup_screen.dart` | Auth |
| `MainLayout` | `lib/navigation/main_layout.dart` | Navigation shell |
| `FeedScreen` | `lib/features/feed/screens/feed_screen.dart` | Feed |
| `DrillSelectionScreen` | `lib/features/drill/screens/drill_selection_screen.dart` | Drill |
| `DrillRecordingScreen` | `lib/features/drill/screens/drill_recording_screen.dart` | Drill |
| `DrillResultsScreen` | `lib/features/drill/screens/drill_results_screen.dart` | Drill |
| `ProfileScreen` | `lib/features/profile/screens/profile_screen.dart` | Profile |
| `EditProfileScreen` | `lib/features/profile/screens/edit_profile_screen.dart` | Profile |
| `StatsScreen` | `lib/features/stats/screens/stats_screen.dart` | Stats |
| `ExploreScreen` | `lib/features/explore/screens/explore_screen.dart` | Explore |
| `SettingsScreen` | `lib/features/settings/screens/settings_screen.dart` | Settings |
| `AboutScreen` | `lib/features/settings/screens/about_screen.dart` | Settings |

---

## 7. Named Routes

| Route | Screen | Arguments |
|-------|--------|-----------|
| `/` | `AuthGate` | none |
| `/signup` | `SignupScreen` | none |
| `/drill/select` | `DrillSelectionScreen` | none |
| `/drill/record` | `DrillRecordingScreen` | `Drill` object |
| `/drill/results` | `DrillResultsScreen` | `Map<String, dynamic>` with `drill`, `scoringResult`, `duration` |
