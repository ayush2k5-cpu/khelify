# Khelify — Troubleshooting & Setup Guide

**Stop getting stuck.** Follow this guide to fix setup issues and dependency errors.

---

## 1. Required Setup (Check This First)

If your build fails, 90% of the time it's because one of these is wrong.

| Tool | Version Required | How to Check |
|------|------------------|--------------|
| **Flutter SDK** | **3.24.0 or newer** | `flutter --version` |
| **Java JDK** | **Version 17 or 21** | `java --version` |
| **Android Studio** | **Koala or newer** | Help > About |

> [!IMPORTANT]
> **If you are on an older Flutter version (like 3.19 or 3.22), the project WILL NOT RUN.**
> Run `flutter upgrade` immediately.

---

## 2. dependencies vs version solving failed

If you see an error like:
`Because khelify_app depends on package_x >=2.0.0 which requires SDK version >=3.0.0...`

**The Fix:**
1. Run `flutter upgrade` to get the latest SDK.
2. Run `flutter clean`
3. Run `flutter pub get`

**Rule:** Never manually change versions in `pubspec.yaml` to "make it work" unless Lead approves. You will break it for everyone else.

---

## 3. "Gradle task assembleDebug failed"

This usually means your Java version is wrong or Gradle is synced incorrectly.

**The Fix:**
1. Open `android` folder in Android Studio (not VS Code).
2. Let it sync gradle (bottom bar loading).
3. If it asks to upgrade Gradle wrapper? **Say NO.**
4. Check `File > Project Structure > SDK Location > Gradle Settings`. Make sure **Gradle JDK** is set to Java 17.

---

## 4. The "Magic Prompts" (Copy-Paste These)

Stuck? detailed instructions for AI (ChatGPT / Claude / Gemini) will get you the answer faster. Use these templates:

### 🔴 For Build Errors
> "I am working on a Flutter project using **Flutter 3.24**, **Riverpod**, and **Firebase**. I am getting this error when running the app:
>
> ```
> [PASTE THE RED ERROR LOG HERE]
> ```
>
> Explain what is causing this and give me the exact terminal command or code fix to resolve it. Assume I am a beginner."

### 🟠 For Dependency Conflicts
> "I tried to add [PACKAGE NAME] but got a version solving error in pubspec.yaml.
> My current `pubspec.yaml` dependencies are:
> [PASTE YOUR DEPENDENCIES SECTION]
>
> The error message is:
> [PASTE ERROR]
>
> Which version of the package is compatible with my current setup?"

### 🟡 For Logic/Riverpod Issues
> "I am using **Riverpod** for state management. I need to [DESCRIBE GOAL, e.g., 'update the user profile'].
>
> Here is my current provider code:
> [PASTE CODE]
>
> How do I properly read/watch this provider in my Widget? Please show the corrected code."

---

## 5. Golden Rules for this Project

1. **Always run** `flutter pub get` after `git pull`.
2. **Never commit** `.vscode/` or `build/` folders (check `.gitignore`).
3. **If `pubspec.lock` changes** in a PR, purely because you ran `pubspec get`, that is fine.
4. **Windows Users:** Enable "Developer Mode" in Windows Settings if you get symbolic link errors.

---

## 6. Still Stuck?

**Escalation Path:**
1. Paste error in AI using the prompt above.
2. Search error on StackOverflow.
3. Post the *exact error log* in the Team Group Chat.
4. Tag **R1**.
