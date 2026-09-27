# Khelify — Firestore Schema

Single source of truth for the database structure. **Everyone must follow this.**

---

## Collections

### 1. `users`

| Field | Type | Description |
|-------|------|-------------|
| _(doc ID)_ | `string` | Firebase Auth UID |
| `displayName` | `string` | User's display name |
| `email` | `string` | User's email |
| `avatarUrl` | `string?` | Firebase Storage URL for avatar |
| `sport` | `string` | `"football"` / `"badminton"` / `"cricket"` |
| `tier` | `string` | `"beginner"` / `"advanced"` / `"pro"` / `"elite"` |
| `totalDrills` | `number` | Total drills completed |
| `bestScore` | `number` | Highest score ever (0-100) |
| `averageScore` | `number` | Running average score |
| `createdAt` | `timestamp` | Account creation time |
| `updatedAt` | `timestamp` | Last profile update |

**Used by:** Profile (P), Feed (G), Stats (A), Settings (R2)

---

### 2. `results`

| Field | Type | Description |
|-------|------|-------------|
| _(doc ID)_ | `string` | Auto-generated |
| `drillId` | `string` | References drill from drill_constants |
| `drillName` | `string` | Drill name (denormalized for quick reads) |
| `userId` | `string` | Firebase Auth UID |
| `sport` | `string` | `"football"` / `"badminton"` / `"cricket"` |
| `score` | `number` | 0-100 |
| `tier` | `string` | Tier at time of drill |
| `duration` | `number` | Duration in seconds |
| `techniqueBreakdown` | `map` | `{"Knee Drive": 85.0, "Arm Swing": 72.0}` |
| `videoUrl` | `string?` | Cloud storage URL |
| `timestamp` | `timestamp` | When drill was completed |

**Used by:** Stats (A), Feed (G), Profile (P — for count/best)

**Indexes needed:**
- `userId` + `timestamp` (descending) — for user's drill history
- `timestamp` (descending) — for global feed

---

### 3. `feed`

| Field | Type | Description |
|-------|------|-------------|
| _(doc ID)_ | `string` | Auto-generated |
| `userId` | `string` | Who did the drill |
| `userName` | `string` | Denormalized for fast reads |
| `userAvatar` | `string?` | Denormalized avatar URL |
| `drillName` | `string` | What drill was done |
| `score` | `number` | Score achieved |
| `sportType` | `string` | `"football"` / `"badminton"` / `"cricket"` |
| `timestamp` | `timestamp` | When it happened |

> [!NOTE]
> Feed entries are **created automatically** when a drill result is saved. The Lead will wire this up — no one else needs to write to this collection.

**Used by:** Feed (G — reads only)

**Indexes needed:**
- `timestamp` (descending) — for chronological feed

---

### 4. `drills` (optional — seed data alternative)

For MVP, drill definitions live in `drill_constants.dart`. If we move to Firestore later:

| Field | Type | Description |
|-------|------|-------------|
| _(doc ID)_ | `string` | Drill ID |
| `name` | `string` | Drill name |
| `sport` | `string` | Sport category |
| `category` | `string` | Drill category |
| `description` | `string` | What the drill is |
| `difficulty` | `string` | `"beginner"` / `"intermediate"` / `"advanced"` |
| `icon` | `string` | Emoji icon |

**Used by:** Explore (A), Drill Selection (Lead)

---

## Security Rules (Starter)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users: read own, write own
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    // Results: read all (for feed), write own
    match /results/{resultId} {
      allow read: if request.auth != null;
      allow create: if request.auth.uid == request.resource.data.userId;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }

    // Feed: read all, write via server/lead only
    match /feed/{feedId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    // Drills: read all (catalog), write admin only
    match /drills/{drillId} {
      allow read: if request.auth != null;
      allow write: if false; // seed via console or admin
    }
  }
}
```
