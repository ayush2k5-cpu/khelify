# Khelify — v1 Product Spec
*Written 2026-11-19 from a grilling session with Ayush. Supersedes `PRD.md`, `PROJECT_BRAIN.md` and `APP_FLOW.md` where they disagree. Decision log: `../research.md`.*

## 1. Why Khelify exists
India has about 1.4 billion people and almost no world-class athletes outside cricket. The talent exists; access, money, infrastructure and visibility do not. Cricket has the BCCI pipeline and reinvests its money; football and most other sports have nothing comparable at the grassroots.

Phones and cheap data now reach tier-2 and tier-3 India. Khelify uses that to give any kid with a phone a fair, visible place to compete and a way to learn. It is Ayush's attempt to help find the next Messi who has the talent but not the access.

## 2. What it is
A sports social platform built on Strava's model. On Strava everyone runs the same stretch of road and compares times. On Khelify everyone does the same standard drill and compares counts and times on a leaderboard. AI feedback and coaching footage teach you how to improve.

- **Compete:** leaderboards rank objective numbers (counts, times).
- **Learn:** a private AI technique score and reference footage show you why you are slow and what good looks like.
- **Be seen (later):** once the leaderboards have real athletes, coaches and scouts come to look at them.

## 3. Who it is for
- **v1 users:** athletes only, focused on grassroots players in tier-2 and tier-3 India who are outside the academy system.
- **Later:** coaches, scouts and academies, who are the people who would actually find the talent.
- **Assumed user context:** a ₹10k-class Android phone with 3-4 GB of RAM, patchy data, often under 18.

## 4. v1 scope

### Drills (5 total)
| Sport | Drill | Leaderboard metric | Detection needed |
|---|---|---|---|
| Football | Keepy-uppies in 60 s | Touch count | Pose and ball |
| Football | Cone dribble course | Time | Pose and cones/ball |
| Football | 20 m sprint | Time | Start and finish detection |
| Badminton | Six-corner shadow footwork | Time or reps | Pose |
| Badminton | Shuttle-run speed | Time | Pose and markers |

Each drill has one reference clip recorded or commissioned by Khelify, plus YouTube embeds that link out to more coaching.

### Features
- **Auth and onboarding:** signup with date of birth, gender and district. Parental consent step for under-18s.
- **Drill flow:** select a drill, watch the reference, framing check, record live, see results (leaderboard metric plus private technique score and feedback).
- **Leaderboards:** one per drill, filtered by age band (U-14, U-17, U-19, Open), gender and area (district, state, India). District is the default view.
- **Profile:** personal bests per drill and a history chart (replaces the old mock stats screen).
- **Explore:** browse drills by sport.
- **Offline:** recording and scoring work without data; the result uploads later.

### Trust and anti-cheat
- Recording happens only live inside the app. No uploads from the gallery.
- A framing check runs before the drill starts (whole body and markers in view).
- Any top-10 or record-breaking entry keeps its video and needs approval (by Ayush now, by trusted coaches later) before it shows on the board.

### Minors and privacy (DPDP Act 2023)
- Date of birth at signup decides the minor flow.
- Under-18s need verifiable parental consent before any data is stored.
- No public face video of minors. Review clips are visible only to reviewers.
- Location is stored and shown only at district level.
- No tracking or targeted ads aimed at children.

### Not in v1
Feed, follows, likes, comments, XP/badges/streaks, Elite/Pro/Advanced/Beginner tiers, settings beyond basics, Connect and Pro Clubs, Khojjoo, monetization, cricket, coach and scout accounts, iOS, languages other than English.

## 5. Tech
| Area | Choice |
|---|---|
| App | React Native, Expo dev build, Expo Router |
| Camera | `react-native-vision-camera` with frame processors |
| AI | `react-native-fast-tflite`: MoveNet Lightning for pose, a small detection model for ball and markers. Fallback: score after recording on slow phones |
| Scoring maths | Ported from the Flutter app (angle calculation, Gaussian scoring) to TypeScript with unit tests |
| Backend | Supabase: Postgres, Auth, Storage, row-level security |
| Language | English only, all strings through a translation layer so Kannada and Hindi can be added later |
| Platform | Android only |

The Flutter app is archived to `projects/archive/`, not deleted. Only the scoring maths and lessons carry over.

## 6. Rollout
1. **Spike (week 1):** prove pose and ball detection on a ₹10k Android phone. Ticket: `tasks/pending/PoseSpikeRn-2026-11-19.md`.
2. **Build v1** in the new React Native app.
3. **Test with whoever is reachable:** friends and nearby Bangalore academies. Goal: it works, scores make sense, cheating is hard.
4. **Real audience:** a tier-2 or tier-3 town near Bangalore, through a coach or school, once the app is proven.

## 7. Definition of done (v1)
100 athletes in one district, each with at least 3 scored drills, and at least one leaderboard with real people competing.

## 8. Open for later (not v1)
- Coach and scout side: verified coaches review top entries, scouts browse boards
- Social layer: feed, follows, squads or clubs (see the old Connect and Pro Clubs brief)
- Tiers based on leaderboard rank
- Khelo India and SAI angle (badges, score cards), monetization
- More sports, Kannada and Hindi, iOS
