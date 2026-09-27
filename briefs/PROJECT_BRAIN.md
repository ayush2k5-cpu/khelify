# Khelify — Project Brain 🧠

**Last Updated:** Feb 19, 2026 | **Maintained By:** R1

---

## 1. What is Khelify?

Khelify is an AI-powered sports coaching app. It uses your phone camera + Google ML Kit Pose Detection to analyze athletic form in real-time, score technique (0-100), and track improvement over time. Think "AI personal trainer in your pocket."

**Sports Supported:** Football ⚽, Badminton 🏸, Cricket 🏏
**Target Users:** Beginner to Pro athletes in India
**Platform:** Android (MVP). iOS later.

---

## 2. Tech Stack

| Layer | Tool | Version |
|-------|------|---------|
| Framework | Flutter | 3.24+ |
| Language | Dart | 3.5+ |
| State Management | Riverpod | 2.4.9 |
| Auth | Firebase Auth | 4.17.6 |
| Database | Cloud Firestore | 4.15.6 |
| File Storage | Firebase Storage | 11.2.0 |
| Camera | camera package | 0.10.5 |
| Pose Detection | google_mlkit_pose_detection | 0.14.0 |
| Charts | fl_chart | 0.63.0 |
| Progress Bars | percent_indicator | 4.2.2 |
| Images | cached_network_image | 3.3.1 |
| Icons | lucide_icons | 0.257.0 |
| Fonts | google_fonts (Inter) | 6.1.0 |

---

## 3. Design System

### Colors (Dark Theme)
| Name | Hex | Usage |
|------|-----|-------|
| `background` | `#0A0E1A` | Main app background |
| `surface` | `#131829` | Cards, containers |
| `surfaceLight` | `#1C2237` | Elevated surfaces |
| `blue` | `#2872A1` | Primary action / brand |
| `blueLight` | `#1E90FF` | Highlights |
| `blueDark` | `#0F52BA` | Pressed states |
| `gold` | `#FFD700` | Elite tier / achievements |
| `success` | `#00E676` | Positive feedback |
| `warning` | `#FF9800` | Warnings |
| `error` | `#FF5252` | Errors |
| `textPrimary` | `#FFFFFF` (95%) | Main text |
| `textSecondary` | `#FFFFFF` (60%) | Body text |
| `textTertiary` | `#FFFFFF` (35%) | Hints |

### Typography (Google Fonts — Inter)
| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| `displayLarge` | 36px | Bold (700) | Hero numbers |
| `h1` | 24px | Bold (700) | Screen titles |
| `h2` | 20px | SemiBold (600) | Section headers |
| `h3` | 16px | SemiBold (600) | Card titles |
| `bodyLarge` | 16px | Regular (400) | Large body text |
| `bodyMedium` | 14px | Regular (400) | Default body |
| `bodySmall` | 12px | Regular (400) | Captions |
| `label` | 11px | Medium (500) | Labels, chips |
| `button` | 14px | Bold (700) | Button text |

### Gradients
| Name | Colors | Usage |
|------|--------|-------|
| `blue` | `#1E90FF` → `#0F52BA` | Primary buttons |
| `gold` | `#FFD700` → `#FFB800` | Elite/achievement |
| `background` | `#0A0E1A` → `#131829` | Page backgrounds |
| `glass` | 10% white → 5% white | Glass cards |

### Tier System
| Tier | Score Range | Color | Icon |
|------|-----------|-------|------|
| Elite | 90-100 | Gold `#FFD700` | 🏆 |
| Pro | 75-89 | Blue `#1E90FF` | ⚡ |
| Advanced | 60-74 | Silver `#C0C0C0` | 🎯 |
| Beginner | 0-59 | Green `#4CAF50` | 🌱 |

---

## 4. Data Models

### UserModel (`lib/core/models/user_model.dart`)
| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `uid` | String | — | Firebase Auth UID (doc ID) |
| `displayName` | String | — | User's name |
| `email` | String | — | User's email |
| `avatarUrl` | String? | null | Profile picture URL |
| `sport` | String | `"football"` | Selected sport |
| `tier` | String | `"beginner"` | Current tier |
| `totalDrills` | int | 0 | Total drills completed |
| `bestScore` | double | 0.0 | Highest score ever |
| `averageScore` | double | 0.0 | Running average |
| `createdAt` | DateTime | now | Account creation |
| `updatedAt` | DateTime | now | Last update |

**Methods:** `fromFirestore()`, `toFirestore()`, `copyWith()`, `UserModel.newUser()`

### DrillResult (`lib/features/drill/models/drill_result.dart`)
| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Auto-generated doc ID |
| `drillId` | String | Which drill was performed |
| `drillName` | String | Name of the drill |
| `userId` | String | Who performed it |
| `score` | int | 0-100 |
| `tier` | String | Tier achieved |
| `duration` | Duration | How long it took |
| `techniqueBreakdown` | Map<String, double> | e.g. `{"Knee Drive": 85.0}` |
| `videoPath` | String? | Local path before upload |
| `videoUrl` | String? | Cloud URL after upload |
| `timestamp` | DateTime | When completed |

### Drill (`lib/features/drill/models/drill.dart`)
| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Drill identifier |
| `name` | String | Drill name |
| `sport` | String | Sport category |
| `category` | String | Drill category |
| `description` | String | What the drill is |
| `instructions` | List<String> | Step by step |
| `estimatedDuration` | Duration | Expected time |
| `difficulty` | String | "beginner", "intermediate", "advanced" |
| `icon` | String | Emoji icon |
| `scoringCriteria` | List<ScoringCriterion> | What gets scored |

### FeedPost (`lib/features/feed/models/feed_post.dart`)
| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Doc ID |
| `userId` | String | Who did the drill |
| `userName` | String | Denormalized name |
| `userAvatar` | String? | Denormalized avatar |
| `drillName` | String | Which drill |
| `score` | double | Score achieved |
| `timestamp` | DateTime | When |
| `sportType` | String | Sport |

---

## 5. Providers (Riverpod)

| Provider | Type | Location | Purpose |
|----------|------|----------|---------|
| `authServiceProvider` | Provider | `auth/providers/` | AuthService instance |
| `authStateProvider` | StreamProvider | `auth/providers/` | Current auth state |
| `currentUserProvider` | Provider | `auth/providers/` | Current Firebase User |
| `userServiceProvider` | Provider | `core/providers/` | UserService instance |
| `currentUserProfileProvider` | StreamProvider | `core/providers/` | Current user's Firestore data |
| `userByIdProvider` | FutureProvider.family | `core/providers/` | Fetch any user by UID |

---

## 6. App Routes

| Route | Screen | Arguments |
|-------|--------|-----------|
| `/` | AuthGate | — |
| `/signup` | SignupScreen | — |
| `/drill/select` | DrillSelectionScreen | — |
| `/drill/record` | DrillRecordingScreen | `Drill` object |
| `/drill/results` | DrillResultsScreen | `Map{drill, scoringResult, duration}` |

---

## 7. Firestore Collections

### `users` — one doc per user
Doc ID = Auth UID. Fields match `UserModel`.

### `results` — one doc per completed drill
Auto ID. Fields match `DrillResult.toFirestore()`.
**Indexes:** `userId + timestamp (desc)`, `timestamp (desc)`.

### `feed` — one doc per feed entry
Auto ID. Fields match `FeedPost`. Created automatically after drill completion.
**Index:** `timestamp (desc)`.

---

## 8. Folder Structure
```
lib/
├── main.dart                  (Entry point)
├── app.dart                   (MaterialApp widget)
├── core/
│   ├── constants/             (Tier constants)
│   ├── models/                (UserModel — shared)
│   ├── providers/             (User providers — shared)
│   ├── services/              (UserService — shared)
│   └── theme/                 (AppColors, AppTypography, AppGradients, AppTheme)
├── features/
│   ├── auth/                  (Login, Signup, AuthGate)
│   ├── drill/                 (Selection, Recording, Results, Scoring)
│   ├── feed/                  (Social feed — G's feature)
│   ├── profile/               (User profile — P's feature)
│   ├── settings/              (Settings + About — R2's feature)
│   ├── stats/                 (Stats dashboard — A's feature)
│   └── explore/               (Discovery — A's feature)
└── navigation/                (AppRouter)
```

---

## 9. Team & Feature Status

| Feature | Assignee | Branch | Status |
|---------|----------|--------|--------|
| Profile | P | `feature/P/profile` | 🟡 In Progress |
| Feed | G | `feature/G/feed` | 🟡 In Progress |
| Stats | A | `feature/A/stats` | 🔴 Not Started |
| Explore | A | `feature/A/explore` | 🔴 Not Started |
| Settings | R2 | `feature/R2/settings` | 🟡 In Progress |

**Deadline:** Feb 24, 2026

---

## 10. Rules (Non-Negotiable)

1. Use `AppColors`, `AppTypography`, `AppGradients` — never hardcode values.
2. Use `UserModel` from `core/models/` — never create your own.
3. Sports strings are exactly: `"football"`, `"badminton"`, `"cricket"`.
4. Tier strings are exactly: `"beginner"`, `"advanced"`, `"pro"`, `"elite"`.
5. Never push to `main` or `dev` — only Lead merges.
6. Commit messages use `feat:`, `fix:`, `style:`, `refactor:` prefix.
7. Always `flutter pub get` after `git pull`.
