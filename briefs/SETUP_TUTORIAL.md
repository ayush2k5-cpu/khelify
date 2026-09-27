# Khelify — Zero to Hero Setup Guide

**Welcome to the team!** Follow these exact steps to get the app running on your laptop. Do not skip any step.

---

## Level 1: The Tools 🛠️

Before you do anything, check if you have these installed.

1.  **VS Code** (The Code Editor)
    -   Install "Flutter" extension by Dart Code.
    -   Install "Dart" extension by Dart Code.
    -   Install "Flutter Riverpod Snippets" (optional but helpful).
2.  **Git**
    -   Open Command Prompt (cmd) and type: `git --version`
    -   If it says "command not found", install Git for Windows.
3.  **Flutter SDK**
    -   Open cmd and type: `flutter --version`
    -   **MUST be 3.24.0 or higher.** If older, run `flutter upgrade`.

---

## Level 2: Get the Code 📦

1.  Open VS Code.
2.  Press `Ctrl + Shift + P` -> Type "Git: Clone" -> Enter.
3.  Paste the Repo URL (Get it from Lead/R1).
4.  Select a folder to save it in.
5.  **Important:** When it asks "Would you like to open the cloned repository?", click **OPEN**.

---

## Level 3: Switch to YOUR Branch 🌿

**NEVER work on `main` or `dev`. You have your own branch.**

1.  Open the Terminal in VS Code (`Ctrl + ~`).
2.  Type this to see all branches:
    ```bash
    git fetch origin
    git branch -a
    ```
    *(You should see red lines starting with `remotes/origin/...`)*
3.  Switch to **YOUR** branch (Replace `YOUR_NAME/FEATURE` with your actual branch name from your brief):
    ```bash
    git checkout feature/YOUR_NAME/FEATURE
    ```
    *Example: `git checkout feature/G/feed`*

---

## Level 4: The Build Setup 🏗️

This is where things usually break. Let's fix them before they happen.

1.  **Get Dependencies:**
    In the terminal, type:
    ```bash
    flutter pub get
    ```
    *(If this fails, STOP and ask in the group chat).*

2.  **Check Environment:**
    Type:
    ```bash
    flutter doctor
    ```
    -   **Green ticks** on "Flutter", "Android toolchain", "VS Code" = ✅ Good.
    -   **Red X** on "Android license status unknown"? Run: `flutter doctor --android-licenses` and type `y` to everything.
    -   **Red X** on "Visual Studio"? Ignore it (we are building for Android).

---

## Level 5: Run the App 🚀

1.  **Start your Emulator** (or connect real phone).
    -   Bottom right of VS Code, click "Windows/Linux" or "No Device".
    -   Select your Android Emulator (e.g., Pixel 7 API 34).
    -   Wait for the phone to turn on.
2.  **Run Main:**
    -   Open `lib/main.dart` file.
    -   Press `F5` (or click "Run" > "Start Debugging").
3.  **Wait.** The first time takes 5-10 minutes.
    -   If you see the Khelify login screen on the emulator... **YOU WIN! 🎉**

---

## Level 6: Your First Safe Change 📝

Let's verify you can save work without breaking anything.

1.  Go to `lib/main.dart`.
2.  Add a comment with your name on the last line:
    ```dart
    // Setup verified by [Your Name]
    ```
3.  Save the file (`Ctrl + S`).
4.  Go to "Source Control" tab (on the left, looks like a branch icon).
5.  Type message: "chore: verify setup for [Your Name]"
6.  Click **Commit**.
7.  Click **Sync Changes** (or Push).

**If that works, you are ready to start your Task Brief.**
