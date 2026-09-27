# Khelify — Coding Conventions

Keep it simple. Follow these rules so everyone's code looks the same.

---

## Folder Structure (Per Feature)

Every feature follows this pattern:

```
lib/features/<feature_name>/
├── models/        ← Data classes (e.g., user_model.dart)
├── providers/     ← Riverpod state management
├── screens/       ← Full-page UI screens
├── services/      ← Firebase/API calls
└── widgets/       ← Reusable UI components
```

---

## Naming Conventions

| Thing | Convention | Example |
|-------|-----------|---------|
| Files | `snake_case.dart` | `feed_card.dart` |
| Classes | `PascalCase` | `FeedCard` |
| Variables | `camelCase` | `userName` |
| Constants | `camelCase` | `primaryColor` |
| Providers | `camelCase` + `Provider` suffix | `feedStreamProvider` |
| Private vars | `_camelCase` | `_isLoading` |
| Folders | `snake_case` | `drill_constants` |

---

## Theme — Always Use App Theme

**Never hardcode colors, font sizes, or text styles.** Always import from core:

```dart
import 'package:khelify_app/core/theme/app_colors.dart';
import 'package:khelify_app/core/theme/app_typography.dart';
import 'package:khelify_app/core/theme/app_gradients.dart';
```

❌ Bad: `color: Color(0xFF1A1A2E)`
✅ Good: `color: AppColors.background`

---

## Riverpod Providers

Use this pattern for all providers:

```dart
// Simple read-only provider
final myServiceProvider = Provider((ref) => MyService());

// Stream from Firestore
final myStreamProvider = StreamProvider<List<MyModel>>((ref) {
  return ref.watch(myServiceProvider).getStream();
});

// State with actions
final myStateProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier(ref.watch(myServiceProvider));
});
```

---

## Firestore Models

Every model must have:

```dart
class MyModel {
  // fields...

  factory MyModel.fromFirestore(DocumentSnapshot doc) { ... }
  Map<String, dynamic> toFirestore() { ... }
  MyModel copyWith({ ... }) { ... }
}
```

---

## Git Commit Messages

```
<type>: <short description>

Examples:
  feat: add profile screen layout
  fix: correct score calculation in feed card
  style: update spacing on stats dashboard
  refactor: extract feed card into separate widget
```

Types: `feat` (new feature), `fix` (bug fix), `style` (UI-only), `refactor` (restructure), `docs` (documentation)

---

## Widget Rules

1. **Always use `const` constructors** when possible
2. **Extract widgets** into separate files if they're >50 lines
3. **Add `super.key`** to every widget constructor
4. **Use `ConsumerWidget`** (not `StatelessWidget`) if you need Riverpod

---

## Import Order

```dart
// 1. Dart/Flutter SDK
import 'package:flutter/material.dart';

// 2. External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 3. App imports (core first, then features)
import 'package:khelify_app/core/theme/app_colors.dart';
import 'package:khelify_app/features/auth/services/auth_service.dart';

// 4. Relative imports (same feature)
import '../models/feed_post.dart';
import '../widgets/feed_card.dart';
```
