# Khelify — Research and Decisions

## Operating Mode
Mode: Continuous
Reason: Long-running product, solo with agents under Ojas, no hard date. Tickets mandatory, handoff every session.

## Product Direction (grilling session 2026-11-19, agreed by Ayush)
Full v1 spec: `briefs/ProductSpec-2026-11-19.md`. Everything older in `briefs/` (PRD, PROJECT_BRAIN, APP_FLOW, firestore_schema) describes the Flutter app and is superseded where it disagrees.

### Essence
A sports social platform for grassroots athletes in tier-2 and tier-3 India, built on Strava's "compete on the same segment" model. AI and coaching footage act as the learning tools. Purpose: find the talent that has no access, money or infrastructure. India has 1.4 billion people and almost no athletes outside cricket.

### Decisions
| # | Decision |
|---|---|
| Spine | Social and competitive platform (Strava model), not a coaching app or a scout network |
| Leaderboards | Objective counts and times only. The pose technique score (0-100) is private coaching feedback |
| Sports | Football and badminton. No cricket in v1 |
| Drills | 3 football (keepy-uppies in 60 s, cone dribble course, 20 m sprint) and 2 badminton (six-corner shadow footwork, shuttle-run speed) |
| Coaching footage | Own reference clip per drill, plus YouTube embeds |
| Anti-cheat | Live in-app capture only (no gallery uploads), framing check before the drill, top-10 and record entries keep their video and need approval before showing |
| Boards | Split by age band (U-14, U-17, U-19, Open), gender and area (district, state, India). District shown by default |
| Minors | Date of birth at signup, parental consent for under-18s (DPDP Act 2023), no public face video of minors, location at district level only |
| Users in v1 | Athletes only. Coaches and scouts come later |
| Device | Android only, ₹10k-class phone is the performance floor, recording works offline and uploads later |
| Language | English only in v1. Built ready for translation; Kannada and Hindi later |
| Name | Khelify |

### Tech decisions
| Area | Decision |
|---|---|
| Framework | React Native with Expo dev build. Flutter/Dart dropped (Ayush hit limits with Flutter) |
| Camera | `react-native-vision-camera` frame processors |
| AI | `react-native-fast-tflite` running MoveNet Lightning (pose) plus a small ball and object detection model. Fallback on slow phones: score after recording |
| Backend | Supabase (Postgres plus row-level security). Firebase dropped |
| Rewrite | Fresh build. Port only the scoring maths (angle calculation, Gaussian scoring) to TypeScript with unit tests. Flutter app goes to `projects/archive/`, nothing deleted |
| October | Not used (the `CLAUDE.md` in this folder was a one-off experiment) |

### Known technical risk
Pose models see bodies, not balls. Keepy-uppy counts need ball detection; the sprint needs start and finish detection. The first ticket is a one-week spike on a ₹10k phone that proves this works before any other rewrite. If it fails, the plan moves to scoring after recording only.

### Rollout
1. Spike on a ₹10k Android phone
2. Test with whoever is reachable: friends and nearby Bangalore academies
3. Real audience (tier-2 or tier-3 town near Bangalore, through a coach or school) only once the app is proven
4. v1 done: 100 athletes in one district, each with at least 3 scored drills, at least one leaderboard with real people competing

### Cut from v1 (may return in v2)
Feed, XP/badges/streaks, Elite/Pro/Advanced/Beginner tiers (return only if based on leaderboard rank), settings stub, Connect and Pro Clubs, Khojjoo, monetization tiers, cricket, coach and scout features.
