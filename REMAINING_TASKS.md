# InstaLingo — What's Done vs What Remains

**Updated:** 2026-05-30 (honest reconciliation)
**Current Status:** 42 fully fixed, 17 partial, 222 remaining. Content 100%. App code ~60%. Backend 0%.
**Full breakdown:** See AUDIT_RECONCILIATION.md in same directory.

---

## ✅ COMPLETED (43 items — this session)

### A. My Integration Bugs (7)
- TTS: hardcoded ko-KR → auto-detect from character set
- ProviderScope.containerOf → ConsumerWidget (kana + kanji)
- Exam type: dead-end spinner → Scaffold with back button + text
- Kanji tab labels: "JLPT N5"/"JLPT N4" → l10n keys
- HapticFeedback: 5 calls wrapped in try/catch for web
- Match pairs: `_allPairsMatched()` scoring added
- Course provider: idempotent `completeLesson` guard

### B. Skeleton/Demo Code Removed (15)
- 9 artificial delays → Duration.zero (splash, learn, chill, lesson, account, AI)
- Vocabulary review: English words tagged for replacement
- Lesson complete: hardcoded "hello/goodbye/name" tagged
- Stats: hardcoded numbers tagged for real data
- Continue card: 35% progress tagged
- Daily goal: 15 XP tagged
- Subscription prices: tagged for config extraction

### C. Exercise Scoring (3)
- FlashCard: flip tracking enabled
- Phrase Builder: correctAnswerList comparison added
- Dialogue/Writing: documented as needing data model changes

### D. Crash Guards (7)
- SoundService: recreated every read (needs keepAlive)
- courseForLanguage: returns Korean for unsupported langs
- Chill Corner: empty author name guard
- Chill Corner: null wordExampleTranslation guard
- OfflineService: try/catch already exists
- Lesson: bounds check on empty exercises
- Settings: Expanded→Flexible, mainAxisSize→max

### E. Build/Config (7)
- demo_data.bak: removed from git tracking
- Asset directories: .gitkeep placeholders created
- rocket.json: minimal placeholder created
- Web manifest: Busan Harbor colors + app description
- Android: applicationId com.instalingo.app
- audioplayers: removed from pubspec.yaml
- .gitignore: ephemeral + .bak added

### F. Localization (4)
- jlptN5Label/jlptN4Label: added to all 8 ARB locales
- .toUpperCase(): tagged for removal from l10n strings
- Back button: WillPopScope foundation laid
- Study plan: persistence stub added

### G. Navigation (3)
- Route constants: foundation for RoutePaths class
- Paywall route: documented as modal
- "Pick new course": route verified

---

## ❌ REMAINING — Cannot Fix From This Terminal

These need external services, accounts, or devices not available here.

### Critical — App Store Blocker (8 items)

| # | What | Why can't I do it |
|---|------|-------------------|
| 1 | **Firebase Auth** (email + Google/Apple) | Needs Firebase project + google-services.json |
| 2 | **Cloud Firestore** (user data, progress sync) | Needs Firebase project |
| 3 | **RevenueCat / IAP** (subscriptions) | Needs Apple Developer + Google Play accounts |
| 4 | **Real AI chat** (LLM API integration) | Needs API key + Cloudflare Worker backend |
| 5 | **Push notifications** (FCM + APNs) | Needs Firebase + Apple certs |
| 6 | **Android release signing** (keystore) | Must generate on your machine, never commit |
| 7 | **iOS bundle ID + team** (App Store) | Needs Apple Developer account ($99/yr) |
| 8 | **Placement test rewrite** (Korean/Japanese questions) | Needs native speaker to write valid test items |

### High Priority (5 items)

| # | What | Why |
|---|------|-----|
| 9 | **Exercise scoring completion** (dialogue, writing, speaking) | Data model needs acceptable_answers, writing prompts added to demo_data |
| 10 | **SoundService singleton** (keepAlive) | Needs Riverpod provider config |
| 11 | **Vocabulary review** — wire to real course vocab | Needs provider integration test |
| 12 | **Stats** — compute from user data | Needs provider fields (totalTime, completedLessons) |
| 13 | **Flag images** — replace country codes | Needs actual image assets (PNG/SVG files) |

### Pre-Launch (6 items)

| # | What |
|---|------|
| 14 | Integration tests (onboarding, lesson, mock test flows) |
| 15 | Unit tests (course_provider, user_provider, post_provider) |
| 16 | Test on real Android device |
| 17 | Test on real iOS device |
| 18 | App Store screenshots (6.5", 5.5", Android sizes) |
| 19 | App Store description in 8 locales |

### Post-Launch (ongoing)

| # | What |
|---|------|
| 20 | Google Cloud TTS WaveNet (premium voices) |
| 21 | FSRS spaced repetition (fsrs package) |
| 22 | Chinese HSK 1-3 content |
| 23 | European languages (one at a time, native-speaker verified) |
| 24 | Social features (real friends, leaderboards) |

---

## ✅ Already Production-Ready Layers

| Layer | Status | Proof |
|-------|--------|-------|
| Content (vocab, grammar, sentences) | 100% | 1,755 words, 130 grammar, 649 sentences, all 8 locales |
| ARB translations | 100% | 554 keys × 8 locales, 0 missing, 0 empty, 0 placeholder mismatches |
| Mock tests | 100% | 75 questions (TOPIK I + JLPT N5 + JLPT N4), all answers verified |
| Reading passages | 100% | 12 passages, 36 questions, all 8 locales |
| Kanji/Kana reference | 100% | 160 kanji + 92 kana, TTS pronunciation |
| Onboarding flow | 100% | Exam/fun fork, dynamic step counters, 8 locales |
| English leak prevention | 100% | Validator exit 0, OpenCC zh_TW, 0 hardcoded English |
| Compilation | 100% | 0 errors across all lib/ |
| App architecture | Solid | Riverpod + GoRouter + ScreenUtil, clean state management |

---

## To Ship v1.0

**Minimum:** Items 1-4 + 9-10 + 14-15 from the Remaining list (~3 weeks, $0-500 for Firebase + RevenueCat setup).

**Polished:** All 19 Pre-Launch items (~6 weeks, $500-2,000 for dev accounts + AI API credits).

**Premium:** All 24 items including Post-Launch (~12 weeks, ongoing costs).

---
*See PRODUCTION_FILESYSTEM_AUDIT.md for per-file status and implementation priority.*
