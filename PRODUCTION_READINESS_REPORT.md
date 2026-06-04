# InstaLingo — Production Readiness Audit Report (FINAL — V2)

> **Audit Date:** 2026-05-30  
> **App Version:** 1.0.0+1  
> **Flutter SDK:** 3.27.1 (Dart 3.6.0)  
> **Audit Method:** Full end-to-end static code analysis + browser route verification  
> **Files Examined:** 57 source files (screens, providers, services, models, widgets, configs, l10n, infrastructure), 37 infrastructure files  
> **Total Issues Found:** 286+
>
> **⚠️ LIMITATION:** Flutter web renders to an HTML5 Canvas. Browser-based testing cannot visually verify rendered UI, animations, layout, text overflow, or interactive element states. All visual/runtime assertions in this report are based on code analysis, not visual observation. Issues marked **[RUNTIME]** could only be detected via code analysis and may have additional symptoms visible only on real devices.

---

## Executive Summary

**Overall Assessment: PRE-ALPHA / NOT PRODUCTION READY — Overall Score: ~25%**

The app has a strong visual design system ("Busan Harbor") and solid architecture (Riverpod + GoRouter + ScreenUtil). However, it is overwhelmingly **demo/skeleton code**:

- **~70%** of screens use artificial loading delays, hardcoded demo data, or simulated features
- **0%** backend integration — all data is local SharedPreferences or hardcoded DemoData
- **0%** real AI — AI chat returns a single l10n string
- **0%** real audio — TTS barely wired, sound service is just haptics
- **0%** real notifications — 30-second polling loop with hardcoded English
- **0%** in-app purchases — paywall is a decorative modal that does nothing
- **0%** integration tests — 1 widget test that doesn't actually work
- **0%** proper platform configuration — Android uses `com.example` namespace, iOS target not set, web manifest has default Flutter blue colors

---

## 🔴 CRITICAL — Blocking Production Release (18 Issues)

### C1. No Backend Integration — Entire App Is Local-Only
| Area | Issue | Location |
|------|-------|----------|
| **User auth** | No account creation — saves to local SharedPreferences only, no server API call | `account_creation_screen.dart` |
| **Course content** | `DemoData` is the only data source (9501 lines / 625KB) — no API fetches | `demo_data.dart` |
| **Progress sync** | No cloud sync — SharedPreferences only, data lost on device wipe | `offline_service.dart` |
| **Subscription** | Paywall and subscription screens have no IAP integration — buttons do nothing | `paywall_modal.dart`, `subscription_screen.dart` |
| **Multi-device** | No way to resume progress on another device | Systemic |

### C2. No Real AI Integration
| Issue | Location |
|-------|----------|
| **AI Conversation** — response is `l10n.lessonCompleteGreat`, not an LLM call | `ai_conversation_screen.dart:88-99` |
| **AI Characters** — mentioned in onboarding features, never implemented | Referenced in l10n strings only |
| **Microphone button** — icon suggests speech-to-text, actually just focuses text input | `ai_conversation_screen.dart:235-240` |

### C3. No Real Audio/TTS Pipeline
| Issue | Location |
|-------|----------|
| **TTS default language hardcoded to `ko-KR`** regardless of user's learning language | `tts_service.dart:22` |
| **`_configure()` not awaited** in constructor — TTS may speak wrong language | `tts_service.dart:14` |
| **Sound service** uses `HapticFeedback` only — **crashes on web** (MissingPluginException) | `sound_service.dart:25,31,37,43,51` |
| **Lesson exercises** with `audioUrl` or `listenAndType` have no functional audio | `lesson_screen.dart` |
| **`audioplayers`** dependency declared but never used anywhere | `pubspec.yaml:41` |

### C4. Notifications Are a Timer-Based Placeholder
| Issue | Location |
|-------|----------|
| Polls every **30 seconds** instead of using platform notifications | `notification_service.dart:34` |
| **Fires twice per minute** — `now.minute == minute` is true for 60 seconds, timer fires at :00 and :30 | `notification_service.dart:44-45` |
| Snackbar text is **hardcoded English**: `'Time to practice! 🎯'` — not localized | `notification_service.dart:72` |
| **Stored BuildContext** becomes stale after navigation, causes runtime crash | `notification_service.dart:30` |
| No `flutter_local_notifications` or push notification integration | Entire service |

### C5. Placement Test Is About English, Not Target Languages
| Issue | Location |
|-------|----------|
| All 5 questions test **English grammar** — completely irrelevant for Japanese/Korean learners | `placement_test_screen.dart:22-60` |
| Questions are entirely in English, not localized | Same file |
| **Result is never persisted** — the proficiency level is shown in a dialog then discarded | `placement_test_screen.dart:80-86,386` |
| Only 5 questions — statistically meaningless for placement | Same file |
| After test, navigates directly to `/learn` skipping all onboarding | `placement_test_screen.dart:278` |

### C6. Runtime Crash Hazards in Lesson Screen
| Issue | Location |
|-------|----------|
| **No bounds check** on `_currentIndex` — empty exercises list causes `RangeError` | `lesson_screen.dart:64-65` |
| **Division by zero** if `exercises` is empty — `(_currentIndex + 1) / exercises.length` | `lesson_screen.dart:68` |
| **Navigation side-effect in build()** — `addPostFrameCallback` with `context.go('/learn')` | `lesson_screen.dart:53-56` |

### C7. Match Pairs Always Reports Correct (Exercise Type Is Broken)
| Issue | Location |
|-------|----------|
| `_MatchPairsContent.onComplete` sets `_isCorrect = true` unconditionally — no answer verification | `lesson_screen.dart:249-258` |
| Multiple exercise types have **no correctness evaluation** (flashcard, phrase builder, dialogue, writing) | `lesson_screen.dart` throughout |

### C8. Settings Screen Has a Layout Crash
| Issue | Location |
|-------|----------|
| **`Expanded` inside `Column(mainAxisSize: MainAxisSize.min)`** in language picker bottom sheet — throws `RenderFlex` exception at runtime | `settings_screen.dart:320-328` |
| **Toggle ignores incoming value** — `onChanged: (_) { ... toggle(); }` swallows the actual state | `settings_screen.dart:68-75` |

### C9. No Email/Input Validation Anywhere
| Issue | Location |
|-------|----------|
| Email field accepts **any text** — no format validation | `account_creation_screen.dart:133-142` |
| Display name has **no max length** — user could enter 500 characters | `account_creation_screen.dart:124-131` |
| **Silent failure** on keyboard submit with empty name — button doesn't work, no feedback | `account_creation_screen.dart:33` |
| **Empty display name saved** if user taps "Skip" without entering name | `account_creation_screen.dart:167-182` |

### C10. `ConstrainedContent` Causes Systemic Layout Bugs
| Issue | Location |
|-------|----------|
| Modifies `MediaQuery.size` for entire app — every dialog, popup, sheet, and overlay gets wrong width | `responsive.dart:44-51` |

### C11. Android Build Configuration Is Broken
| Issue | Location |
|-------|----------|
| `applicationId = "com.example.instalingo"` — **must change** for production | `android/app/build.gradle.kts:11` |
| **AGP 9.0.1 and Kotlin 2.3.20** — Kotlin 2.3.20 doesn't exist in any stable release → build failure | `android/settings.gradle.kts:18,20` |
| Release build uses **debug signing keys** | `android/app/build.gradle.kts:24-26` |

### C12. Web Manifest Has Placeholder Branding
| Issue | Location |
|-------|----------|
| `background_color` and `theme_color` are default Flutter blue `#0175C2`, not Busan Harbor navy/orange | `web/manifest.json:4-5` |
| Description says `"A new Flutter project."` | `web/manifest.json:7` |

### C13. Only Two Learning Languages
| Issue | Location |
|-------|----------|
| Only **Japanese** and **Korean** as target languages (hardcoded) | `learning_language_screen.dart:20-23` |
| Korean is the **default fallback** — if no language selected, user learns Korean | `account_creation_screen.dart:56` |
| Exam options extremely limited (JLPT N5/N4, TOPIK I only) | `exam_type_screen.dart:20-34` |
| **Kana chart incomplete** — no dakuten/handakuten/yōon | `kana_screen.dart:9-25` |

### C14. The Only Widget Test Is Broken
| Issue | Location |
|-------|----------|
| Test doesn't mock `SharedPreferences`, `ScreenUtilInit`, or `flutter_tts` — will crash at runtime | `test/widget_test.dart:14-20` |
| No business logic tests anywhere in the project | Entire test directory |

### C15. `OfflineService` Has No Error Recovery
| Issue | Location |
|-------|----------|
| **Any data corruption silently loses all offline progress** — no partial recovery, no logging | `offline_service.dart:80-122` |
| Adding a field to `Course`/`Section`/`Lesson` breaks deserialization of saved data | `offline_service.dart` |

### C16. Demo Data File Is Unsustainably Large
| Issue | Location |
|-------|----------|
| 9501 lines / 625KB (+ 1.8MB `.bak` file) — slows compilation and IDE analysis | `demo_data.dart` |
| Should be split into per-language data files | — |

### C17. Unused / Wrong Dependencies
| Issue | Location |
|-------|----------|
| `audioplayers` declared but never used | `pubspec.yaml:41` |
| `flutter_statusbarcolor_ns` — incompatible with Flutter 3.27+ | `pubspec.yaml:50` |
| `pull_to_refresh_flutter3` — may be unused | `pubspec.yaml:52` |
| `connectivity_plus` — may be unused | `pubspec.yaml:54` |

### C18. Missing Asset Directories
| Issue | Location |
|-------|----------|
| `assets/images/`, `assets/icons/`, `assets/flags/` are empty — referenced in pubspec, will cause build failure | `pubspec.yaml:64-67` |
| `assets/lottie/` is empty — `lottie_loader.dart` references `rocket.json` which doesn't exist | `lottie_loader.dart:12` |

---

## 🟠 HIGH — Major Functional Issues (47 Issues)

### H1. Artificial Loading Delays Everywhere (6 locations)
| Delay | Location |
|-------|----------|
| **1.2s** splash before navigation | `splash_screen.dart:48` |
| **1.2s** learn screen skeleton | `learn_screen.dart:39` |
| **1.5s** chill screen | `chill_screen.dart:29` |
| **800ms** lesson screen | `lesson_screen.dart:40` |
| **1.2s** account creation | `account_creation_screen.dart:37` |
| **1.5s** AI conversation simulated typing | `ai_conversation_screen.dart:88-99` |

### H2. Hardcoded Demo Data (8 locations)
| Screen | What's Hardcoded | Location |
|--------|------------------|----------|
| **Vocabulary Review** | 5 English words (Fragrance, Aroma, Dough, Harvest, Bouquet) — not from any course | `vocabulary_review_screen.dart:20-56` |
| **Lesson Complete** | Practiced words `['hello', 'goodbye', 'name']` | `lesson_complete_screen.dart:184-195` |
| **Stats Screen** | 7 daily XP values, lesson count '12', words '32', time '4h32m' | `stats_screen.dart:51-154` |
| **Continue Card** | Lesson progress hardcoded at 35% (`0.35`) | `learn_screen.dart:308` |
| **Daily Goal** | XP earned hardcoded as `15` | `learn_screen.dart:243` |
| **Friends Screen** | 5 fake users (Sophie, Kenji, Marco, Yuna, Liam) | `friends_screen.dart:19-37` |
| **Achievements** | All 6 achievements from DemoData, not user-specific | `achievements_screen.dart:23-24` |
| **Subscription/Paywall** | Prices ($9.99/month, $59.99/year), feature lists | `subscription_screen.dart:66-77`, `paywall_modal.dart:194-196` |

### H3. Multiple Exercise Types Have Broken Answer Evaluation
| Exercise Type | Issue | Location |
|--------------|-------|----------|
| **Match Pairs** | `_isCorrect = true` set unconditionally on completion | `lesson_screen.dart:304` |
| **FlashCard** | `_selectedAnswer = 'flipped'` — no actual answer checking | `lesson_screen.dart:293-302` |
| **Phrase Builder** | `_selectedWords` never compared against `correctAnswerList` | `lesson_screen.dart:340-390` |
| **Dialogue** | `onSelect` sets `_selectedAnswer` but no scoring logic | `lesson_screen.dart:720-760` |
| **Writing** | Submit button hidden, sample answer shown regardless of input | `lesson_screen.dart:2560-2596` |
| **Speaking** | No speech recognition — `onSubmit` just stores text | `lesson_screen.dart:990-1030` |

### H4. Course Provider Can Double-Count Progress
| Issue | Location |
|-------|----------|
| `completeLesson()` increments `completedLessons` **unconditionally** — calling it twice for same lesson counts as 2 | `course_provider.dart:69-72` |
| Same lesson's vocabulary added twice to `learnedWords` | `course_provider.dart:69-72` |

### H5. Chill Corner Has Multiple Crashes
| Issue | Location |
|-------|----------|
| **Empty author name crash** — `name.split(' ').map((s) => s[0])` throws `RangeError` if name is empty | `chill_screen.dart:194-195, 585` |
| **Force-unwrap crash** — `post.wordExampleTranslation!` if null | `post_detail_screen.dart:256-257` |

### H6. Riverpod Anti-Patterns Cause Rebuild Issues
| Issue | Location |
|-------|----------|
| `SoundService` is recreated **every time** any widget reads `soundServiceProvider` | `settings_provider.dart:90-92` |
| `courseForLanguage` may return null if language code is unsupported | `course_provider.dart:13` |
| `PostsNotifier` initializes with `[]` — brief window where state shows empty list | `post_provider.dart:9` |
| `UserNotifier` flashes demo data before loading persisted data | `user_provider.dart:11` |

### H7. Localization Gaps
| Issue | Location |
|-------|----------|
| Notification snackbar is **hardcoded English** | `notification_service.dart:72` |
| Placement test questions and options are **entirely English** | `placement_test_screen.dart:22-58` |
| Kanji screen tab labels are **hardcoded English** ("JLPT N5", "JLPT N4") | `kanji_screen.dart:64-65` |
| `.toUpperCase()` on l10n strings — incorrect for German (ß→SS), Turkish (i→İ) | `welcome_screen.dart:31,78`, `onboarding_screen.dart:70`, `commitment_screen.dart:173` |

### H8. Navigation Fragilities
| Issue | Location |
|-------|----------|
| **All route paths are raw strings** — no constants, refactoring will silently break | Every screen |
| Placement test result dialog **no `mounted` check** before `context.go()` | `placement_test_screen.dart:386` |
| Lesson complete screen "Pick new course" button targets `/onboarding/learning-language` | `lesson_complete_screen.dart:216` |
| Subscription and Super screens both navigate to `/paywall` route — but paywall is actually a modal, not a route | `subscription_screen.dart:124-126`, `super_screen.dart:118-126` |

### H9. ProviderScope Internal API Usage (Will Crash)
| Issue | Location |
|-------|----------|
| `ProviderScope.containerOf(context).read(ttsServiceProvider)` — accessing internal Riverpod API directly. If `ProviderScope` is not an ancestor, crashes at runtime | `kana_screen.dart:69`, `kanji_screen.dart:230` |

### H10. Missing HapticFeedback on Web Will Crash
| Issue | Location |
|-------|----------|
| `HapticFeedback.*` calls throw `MissingPluginException` on web | `sound_service.dart:25,31,37,43,51`, `lesson_screen.dart`, `splash_screen.dart:50`, `learn_screen.dart` |

### H11. Empty State / Null Handling Gaps
| Issue | Location |
|-------|----------|
| **Dead-end spinner** if `learningLanguage` is null on exam type screen — user stuck, can't proceed | `exam_type_screen.dart:42-47` |
| **No back-button confirmation** on any onboarding screen — accidental back loses all unsaved state | All onboarding screens |
| **Study plan** completion shows snackbar but **nothing is persisted** | `study_plan_screen.dart:172-178` |
| **Friends' following state** is in-memory only — lost on hot restart | `friends_screen.dart:59-60` |

### H12. `AnimatedBuilder` Widget Name Concern
| Issue | Location |
|-------|----------|
| `AnimatedBuilder` is used in `vocabulary_review_screen.dart` and `ai_conversation_screen.dart` — this widget was introduced in Flutter 3.10. If targeting older versions, this will **not compile**. | `vocabulary_review_screen.dart:157`, `ai_conversation_screen.dart:418-419` |

---

## 🟡 MEDIUM — UX, Polish & Code Quality Issues (80+ Issues)

### M1. Flag Codes Displayed as Plain Text (2 locations)
Country codes (`CN`, `TW`, `US`, `JP`, etc.) shown as text in bordered boxes instead of actual flag images.
- `native_language_screen.dart:161-168`
- `learning_language_screen.dart:152-169`

### M2. Placeholder Images Everywhere (4+ locations)
- Chill Corner posts — image section shows only an icon placeholder
- Post Detail — same placeholder icon
- User avatar — user icon instead of actual photo
