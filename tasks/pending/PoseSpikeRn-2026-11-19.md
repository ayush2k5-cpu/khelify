# [Khelify] React Native Pose and Ball Detection Spike

## What
Build a throwaway Expo dev-build app that runs MoveNet Lightning pose detection and a small ball detection model live on a ₹10k-class Android phone, and measure whether it is fast and accurate enough for the v1 drills.

## Why
The whole move to React Native and the leaderboard design depend on on-device detection working on cheap phones. This must be proven before any other rewrite work starts.

## Scope
- Expo dev build (not Expo Go), `react-native-vision-camera` frame processors, `react-native-fast-tflite`
- MoveNet Lightning (single pose) with GPU delegate, then CPU for comparison
- One small ball detection model (pick a TFLite object detection model that has a sports ball class; record which one)
- Simple on-screen skeleton overlay, FPS counter and a keepy-uppy touch counter (rough heuristic is fine)
- Separate throwaway folder, for example `projects/active/khelify/spike/`. Not the v1 app

## Acceptance Criteria
- [ ] Runs on a real ₹10k-class Android phone (3-4 GB RAM); phone model written in the results
- [ ] Pose alone at 15 fps or better, measured and recorded
- [ ] Pose plus ball detection together: fps measured and recorded
- [ ] Keepy-uppy count over 3 test runs of 60 s compared with a manual count; error recorded
- [ ] Battery and heat over a 5 minute session noted
- [ ] Fallback D tested: record a normal video in-app, run pose on the saved file, time taken recorded
- [ ] Results written to `projects/active/khelify/research.md` under a new `## Spike Results` section, with a go / no-go: live path (B) or score-after-recording only (D)

## Blockers
Needs a ₹10k-class Android test phone (Ayush's own or a friend's).

## Agent
Claude Code

## Created
2026-11-19
