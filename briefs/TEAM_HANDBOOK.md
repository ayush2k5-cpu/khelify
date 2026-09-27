# Khelify — Team Handbook

**Project:** Khelify (Sports AI Coach) | **Deadline:** Feb 24, 2026 | **Stack:** Flutter + Firebase + Riverpod

---

## 📅 Daily Reporting (Mandatory)

**By 10:00 AM every day**, reply to R1's message in the group chat with:
1.  **Done:** What you finished yesterday.
2.  **Doing:** What you are working on today.
3.  **Blocker:** Anything stopping you? (If none, write "None").

*Example:* "Done: Profile UI. Doing: Connect Firestore. Blocker: None."

**If you are stuck for 30 mins:** Ask in group chat. If no answer in 1 hour -> Tag R1.

---

## Your Branch

```
git fetch origin
git checkout feature/<YourName>/<feature>
```

| Member | Branch |
|--------|--------|
| P | `feature/P/profile` |
| G | `feature/G/feed` |
| A | `feature/A/stats` and `feature/A/explore` |
| R2 | `feature/R2/settings` |

---

## Git Rules

1. **Never push to `main` or `dev`** — only Lead merges
2. **Don't commit until Lead gives you green light**
3. Push to your own branch only → open a PR when done
4. Commit messages: `feat:`, `fix:`, `style:`, `refactor:` prefix
   ```
   feat: add profile screen layout
   fix: correct score color in feed card
   ```
5. Commit often. Small commits > one massive commit.

---

## Code Rules

### Use the theme — never hardcode

```dart
// ✅ DO
color: AppColors.surface
style: AppTypography.bodyMedium

// ❌ DON'T
color: Color(0xFF131829)
fontSize: 16
```

Imports:
```dart
import 'package:khelify_app/core/theme/app_colors.dart';
import 'package:khelify_app/core/theme/app_typography.dart';
import 'package:khelify_app/core/theme/app_gradients.dart';
```

### Shared models — already built

These are on `dev`. Pull before you start:

```dart
import 'package:khelify_app/core/models/user_model.dart';
import 'package:khelify_app/core/services/user_service.dart';
import 'package:khelify_app/core/providers/user_provider.dart';
```

**Do NOT create your own `UserModel`.** Use the one above.

### Folder pattern

Every feature follows:
```
lib/features/<feature>/
├── models/
├── providers/
├── screens/
├── services/
└── widgets/
```

### Widget rules

- Always use `const` constructors when possible
- Use `ConsumerWidget` if you need Riverpod
- Add `super.key` to every widget constructor
- Extract widgets into separate files if >50 lines

---

## Firestore Collections

| Collection | Doc ID | Used For |
|------------|--------|----------|
| `users` | Auth UID | Profile data, tier, scores |
| `results` | Auto | Drill results + technique breakdown |
| `feed` | Auto | Social feed entries (auto-created) |

**Sports:** `"football"`, `"badminton"`, `"cricket"` — use these exact strings

**Tiers:** `"beginner"`, `"advanced"`, `"pro"`, `"elite"` — use these exact strings

---

## If You're Stuck

```
1. Try on your own for 30 minutes
2. Ask in the group chat
3. No answer in 1 hour → R1 escalates to Lead
```

**Need a shared model/service that someone else owns?**
→ Discuss with that Team Member or Lead before creating your own.

---

## Who Decides What

| Type | Who Decides |
|------|-------------|
| Spacing, colors, icons, naming | R1 can approve |
| New package in pubspec | Lead only |
| Model field changes | Lead only |
| Firestore schema changes | Lead only |
| Anything in auth/pose/scoring | Lead only |

---

## PR Checklist (Before Opening)

- [ ] App builds with no errors (`flutter run`)
- [ ] No hardcoded colors/fonts — using `AppColors`/`AppTypography`
- [ ] Using `UserModel` from `core/models/`, not a custom one
- [ ] Files are in correct folders (`screens/`, `widgets/`, etc.)
- [ ] Commit messages follow convention
- [ ] Tested on a real device or emulator
- [ ] No `print()` statements left in code
