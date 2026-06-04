# Busuu vs InstaLingo — Architecture Comparison & Actionable Gaps

**Date:** 2026-05-24  
**Source analyzed:** `busuuref.md` — Reverse-engineering of Busuu Android APK (v2025.x)

---

## Executive Summary

Busuu is a mature, API-driven language learning app with 40+ exercise types, server-configured gamification, a dual-language resolution system, and 35 Lottie animations. InstaLingo is a Flutter demo with 10 exercise types, static demo data, basic gamification, and no real Lottie assets.

**The biggest structural gap:** Busuu separates **interface language** (instructions in your native language) from **target language** (content you are learning). InstaLingo does not — everything is uniformly localized via ARB. This means a Chinese user learning English sees "Which word means 'hello'?" in English, not in Chinese. This is pedagogically wrong and Busuu explicitly engineered against it.

**The easiest wins:** Download free LottieFiles animations, add 5–10 missing exercise types, implement streak freeze/repair, and add a league system. These are all UI/logic changes — no backend required for a demo.

---

## Detailed Comparison Table

| Area | Busuu (Production) | InstaLingo (Current) | Gap | Priority |
|------|-------------------|---------------------|-----|----------|
| **Platform** | Android native (XML + Jetpack Compose hybrid) | Flutter | Different architecture, not directly comparable | — |
| **Animation** | 35 Lottie JSONs in `/assets/lottie/` | `lottie: ^3.0.0` in pubspec, but `assets/lottie/` is **empty**. Custom `AnimationController` loaders only. | Missing all real Lottie assets | 🔴 High |
| **Image Loading** | Coil (async avatar/course/exercise images) | `cached_network_image` in pubspec, but all images are simulated with colored containers + Phosphor icons | No real images anywhere | 🟡 Medium |
| **Content Delivery** | API-driven (`api.busuu.com`) with Room database caching (24+ DAOs) | Static const data in `demo_data.dart` (~1,222 LOC). No API, no cache. | Zero backend integration | 🔴 High (for production) |
| **Exercise Type Count** | 40+ types (dialogue, flash card, comprehension, dictation, writing, phrase builder, grammar gaps table, grammar true/false, grammar typing, etc.) | 10 types (multiple choice, fill blank, translate, match pairs, word sort, dialogue, grammar tip, listen & type, image ID, speaking) | Missing 30+ exercise variants | 🔴 High |
| **Content Model** | `ApiComponent` with `entityMap` + `translationMap`. Content references IDs; text resolved at runtime by language. | Hardcoded strings directly in Dart const constructors | No separation of content from presentation | 🔴 High |
| **Bilingual Resolution** | `instructions_language` (native) vs `answersDisplayLanguage` (native) vs content resolved in `learningLanguage` (target). Instructions in Chinese, answers in Chinese, but vocabulary words in English. | Single ARB localization. Everything translated uniformly. Chinese ARB translates "hello" to "你好" — but the learning content should stay in English. | **Critical pedagogical flaw** | 🔴 High |
| **Gamification — Points** | Server-configured (`PointsConfigDomainModel`): unitWorth, activityWorth, smartReviewWorth, checkpointWorth, correctionWorth, etc. | Hardcoded 10 XP / lesson, 5 gems / lesson | Point values not configurable | 🟡 Medium |
| **Gamification — Streak** | 5 states: COMPLETED, MISSED, SHIELDED, TODAY_PENDING, REPAIRED. Streak freeze and gem-based repair. | Simple integer counter + calendar grid. No freeze, no repair, no urgency messaging. | Missing 4 of 5 streak states | 🟡 Medium |
| **Gamification — Leagues** | 6 tiers: BRONZE → SILVER → GOLD → PLATINUM → DIAMOND → LEGEND. Weekly reset, promotion/demotion zones, leaderboard API. | Not implemented | Entire league system missing | 🟡 Medium |
| **Gamification — Smart Review** | 3 vocabulary strength buckets: WEAK (0-40%), MEDIUM (41-70%), STRONG (71-100%). Spaced repetition scheduling. | Basic flashcard review with Hard/Good/Easy buttons. No strength tracking or spaced repetition algorithm. | No SRS algorithm | 🟡 Medium |
| **Gamification — Certificates** | PASS (60%+) / FAIL checkpoint tests with 1-3 star rating, pre-lesson intro, result screen | Not implemented | No checkpoint/certification flow | 🟢 Low |
| **Gamification — Weekly Challenges** | Weekly target-based challenges with `WeeklyChallengeProgressView` | Not implemented | No weekly challenge system | 🟢 Low |
| **On-device ML** | Logistic regression model (`onboarding_discount_AI_model_weights.json`) for discount conversion prediction | Not implemented | No ML features | 🟢 Low |
| **Offline Support** | Room database with `updateTime` incremental sync, `isOfflineDataAvailable()` | `SharedPreferences` JSON serialization of Course + UserProfile only. No structured cache. | Basic offline, no incremental sync | 🟡 Medium |
| **Social Features** | Friends, corrections, photo-of-week, community comments | Chill Corner with AI persona posts and simulated comments | Real social features missing | 🟢 Low |

---

## What We Should Implement (Ranked by Impact vs Effort)

### 🔴 Tier 1 — High Impact, Low Effort (Do These First)

#### 1. Download Real Lottie Animations

**Current:** Empty `assets/lottie/` folder. Custom `AnimationController` loaders are placeholders.

**Busuu has:** 35 Lottie JSONs for: points completion, daily goal star, rocket launch (per market), typing indicator, bookmark, send confirmation, loading spinner, splash variants, premium crown, referral bubbles, review intro, lesson loader, etc.

**What to do:**

| Animation | Source on LottieFiles.com | Estimated Effort |
|-----------|--------------------------|-------------------|
| Daily goal completion celebration | Search "daily goal complete" or "success check" | 5 min |
| Points/star micro-animation | Search "star pop" or "coin reward" | 5 min |
| Rocket launch (lesson start) | Search "rocket launch" | 5 min |
| Typing indicator (3 dots) | Search "typing indicator" or "chat typing" | 5 min |
| Bookmark/save word | Search "bookmark" or "heart pop" | 5 min |
| Loading spinner | Search "loading spinner" or "circular loader" | 5 min |
| Confetti burst (already have via `confetti` package) | N/A | Already done |

**Action:** Go to `lottiefiles.com`, search the terms above, download 5–10 free JSON files, drop them in `assets/lottie/`, and replace `RocketLoader`/`LottieLoader` with actual `Lottie.asset()` widgets.

---

#### 2. Separate Interface Language from Target Language in Exercises

**Current (problem):** In `demo_data.dart`, the English course has:
```dart
const Exercise(
  type: ExerciseType.vocabularyMultipleChoice,
  question: 'Which word means "hello"?',
  options: ['Goodbye', 'Hello', 'Thank you', 'Please'],
  correctAnswer: 'Hello',
)
```

A Chinese user learning English sees "Which word means 'hello'?" in English because the ARB doesn't distinguish instruction text from learning content. If you look at `app_zh.arb`, there is no key for exercise instructions.

**Busuu's approach:**
- `instructions_language` = user's native language (e.g., `zh`)
- `answersDisplayLanguage` = user's native language (e.g., `zh`)
- Content text (vocabulary, sentences, dialogue) = target learning language (e.g., `en`)

**What to implement:**

Add two new fields to the `Exercise` model:
```dart
class Exercise {
  // ... existing fields
  final String? instruction;       // Native language: "Choose the correct answer"
  final String? instructionLang;   // "zh", "en", etc.
  final String? contentLang;      // "en", "ko", etc. — the language of the actual learning content
}
```

Then in `demo_data.dart`, generate exercises like this:
```dart
// For a Chinese user learning English:
Exercise(
  instruction: '哪个词的意思是"你好"？',  // In Chinese (native)
  question: 'Hello',                        // In English (target) — the actual content
  options: ['Goodbye', 'Hello', 'Please', 'Sorry'],
  correctAnswer: 'Hello',
)
```

This requires **restructuring `demo_data.dart`** but is the most important pedagogical fix.

---

#### 3. Add 5 High-Value Missing Exercise Types

Busuu has 40+ types. InstaLingo has 10. The biggest gaps that are easy to add:

| New Type | Description | UI Complexity | Effort |
|----------|-------------|----------------|--------|
| `flashCard` | Show word front → tap to flip → show translation/phonetic/audio | Low (reuses vocabulary review flip) | 2 hrs |
| `comprehensionText` | Show a short paragraph → ask 2-3 multiple choice questions about it | Low (reuses MCQ) | 2 hrs |
| `grammarTrueFalse` | Show a grammar statement → tap True or False | Very Low | 1 hr |
| `phraseBuilderPrefilled` | Sentence builder with 1-2 words already placed as hints | Low (reuses wordSorting) | 2 hrs |
| `writing` | Free-text input → AI/simulated correction feedback | Medium | 3 hrs |

**Action:** Extend `ExerciseType` enum, add fields to `Exercise`, and add rendering logic in `lesson_screen.dart`.

---

#### 4. Streak System Enhancement (Freeze + Repair)

**Current:** `currentStreak` is just an integer.

**Busuu has:**
- `COMPLETED` — did a lesson today
- `MISSED` — no lesson, streak at risk
- `SHIELDED` — premium streak freeze (1 missed day allowed)
- `TODAY_PENDING` — current day, no lesson yet → show urgency banner
- `REPAIRED` — user spent gems to restore a broken streak

**What to implement:**

Add `StreakRecord` enum and update the calendar widget:
```dart
enum StreakRecord { completed, missed, shielded, todayPending, repaired }
```

In `stats_screen.dart`:
- `todayPending` → show orange urgency banner: "Complete a lesson to keep your streak!"
- `shielded` → show a shield icon on the calendar day
- `repaired` → show a wrench/restore icon, deduct gems on repair action

**Action:** Add enum to `user.dart`, update `StreakCalendar` widget colors/icons, add streak repair button with gem cost.

---

### 🟡 Tier 2 — Medium Impact, Medium Effort

#### 5. League / Leaderboard System

**Busuu has:** BRONZE → SILVER → GOLD → PLATINUM → DIAMOND → LEGEND. Weekly reset. Promotion (top 3) / demotion (bottom 3) zones. 20 users per league.

**What to implement (demo version):**

Since there's no real backend, generate 19 fake users with randomized avatars, names, and weekly XP. Place the real user somewhere in the middle. Show a `LeagueScreen` with:
- Current league badge in app bar
- Weekly XP leaderboard (top 20)
- Promotion zone (green), safe zone (neutral), demotion zone (red)
- Weekly countdown timer
- "You need X more XP to promote" message

**Action:** New screen `lib/screens/profile/league_screen.dart`, new route `/league`, add to profile menu.

---

#### 6. Vocabulary Strength / Spaced Repetition (SRS)

**Busuu has:** WEAK (0-40%, red) → MEDIUM (41-70%, yellow) → STRONG (71-100%, green). Smart review sessions prioritize WEAK words.

**Current:** Flashcard review with Hard/Good/Easy. No persistence of word strength.

**What to implement:**

Add `VocabStrength` enum and a `nextReviewDate` field:
```dart
enum VocabStrength { weak, medium, strong }

class VocabItem {
  final String word;
  final VocabStrength strength;
  final DateTime nextReviewDate;
  final int reviewCount;
}
```

Algorithm: 
- Hard → strength -= 1, nextReview = now + 4 hours
- Good → strength += 0.5, nextReview = now + 1 day
- Easy → strength += 1, nextReview = now + 3 days
- `SmartReviewScreen` shows only words where `nextReviewDate <= now`

**Action:** Add to `user.dart`, create `SmartReviewScreen`, add "Smart Review" button to Learn tab.

---

#### 7. Certificate / Checkpoint Tests

**Busuu has:** Before unlocking a new section, user must pass a checkpoint test. Result: PASS (60%+) with 1-3 stars, or FAIL with "Review Weak Areas" CTA.

**What to implement (demo version):**

Before unlocking Section 2, show a `CheckpointScreen`:
- "Checkpoint Test: Greetings & Introductions"
- 10 questions from the section's vocabulary/grammar
- Progress bar
- Result screen with percentage, stars, and unlock message

**Action:** New route `/checkpoint/:sectionId`, add pre-unlock check in course path UI.

---

#### 8. Points Configuration (Even if Static)

**Busuu has:** Server-configured point values.

**Current:** Hardcoded 10 XP, 5 gems per lesson.

**What to implement:**

Create a `PointsConfig` class even if it's static for now:
```dart
class PointsConfig {
  static const int lessonComplete = 10;
  static const int sectionComplete = 50;
  static const int checkpointPass = 25;
  static const int smartReviewComplete = 5;
  static const int streakMaintained = 5;
  static const int dailyGoalReached = 15;
  static const int correctionSubmitted = 3; // if we add writing correction
}
```

Replace all hardcoded `xpReward: 10` with references to `PointsConfig`.

**Action:** New file `lib/config/points_config.dart`, refactor `demo_data.dart` and lesson completion logic.

---

### 🟢 Tier 3 — Nice to Have, Lower Priority

#### 9. Weekly Challenges

**Busuu has:** Weekly target-based challenges (e.g., "Complete 5 lessons this week") with `WeeklyChallengeProgressView`.

**Action:** Add a card on the Learn tab showing weekly progress. Low priority because leagues already cover competitive gamification.

#### 10. On-device ML (Discount Conversion)

**Busuu has:** A logistic regression model that predicts if a user will convert to paid if shown a discount.

**Action:** Not worth implementing in a demo. Use A/B testing framework if you go to production.

#### 11. Photo of the Week / Community Corrections

**Busuu has:** Users submit photos with captions, community corrects them. Photo-of-week exercise awards points.

**Action:** Requires real backend and moderation. Skip for demo.

#### 12. Real Backend + API

**Busuu has:** Full REST API (`api.busuu.com`) with incremental sync, Room database, 24+ DAOs.

**Action:** This is production infrastructure, not demo scope. Firebase/Supabase integration is already noted in `WHAT_IS_LEFT_FLUTTER.md`.

---

## Recommended Implementation Order

| # | Feature | Why First? | Est. Time |
|---|---------|-----------|-----------|
| 1 | **Download Lottie animations** | Visual polish, lowest effort | 30 min |
| 2 | **Add 5 missing exercise types** | Pedagogical depth, reuses existing UI patterns | 1 day |
| 3 | **Separate instruction vs content language** | Fixes the most critical pedagogical flaw | 1 day |
| 4 | **Streak freeze + repair** | Retention mechanic, low UI complexity | 4 hrs |
| 5 | **League system (demo version)** | Engagement, competitive gamification | 1 day |
| 6 | **Vocabulary strength + SRS** | Learning efficacy, smart review | 1 day |
| 7 | **Checkpoint tests** | Sense of progression, section gates | 6 hrs |
| 8 | **Points configuration** | Code quality, future flexibility | 2 hrs |

---

## What We Already Do Better Than Busuu

| Feature | InstaLingo | Busuu |
|---------|-----------|-------|
| **Cross-platform** | Flutter = iOS, Android, Web, Desktop from one codebase | Android only (in this analysis) |
| **Onboarding depth** | 7-step flow with motivation/commitment/daily goal | Simpler onboarding |
| **AI Conversation** | Full chat UI with scenario, typing indicator, quick replies | Not mentioned in this analysis |
| **Chill Corner** | Instagram-style social feed with word highlight cards | Standard social feed |
| **Localization languages** | 7 languages already fully localized | 50+ but requires backend |
| **Theme system** | Light/dark with `AppThemeExtension` and `context.appTheme` | Not analyzed |
| **Responsive design** | `flutter_screenutil` + `ConstrainedContent` for desktop web | Mobile only |

---

*This comparison is based on `busuuref.md`, a technical reverse-engineering analysis. No copyrighted Busuu content is reproduced.*
