# InstaLingo Codebase Catalog

> Comprehensive file-by-file catalog of every code file in the InstaLingo project.
> Last updated: 2026-06-09 | Branch: `claude-code-ver`

---

## Project Overview

**InstaLingo** is a Flutter mobile/web app for discovering Japanese vocabulary through an addictive TikTok/Instagram Reels-style swipe interface. It gamifies JLPT vocabulary learning with a social-media "Chill Corner" feed, SRS-based spaced repetition, achievements, streaks, and a Busan Harbor maritime design system.

- **Language:** Dart (Flutter), Python (tooling/data pipeline)
- **Platform:** iOS, Android, Web (PWA)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Navigation:** GoRouter (`go_router`)
- **Icons:** Phosphor (vendored)
- **Monetization:** Google AdMob (ads) + RevenueCat (subscriptions)
- **Analytics:** Firebase (Core, Analytics, Crashlytics)
- **Localization:** 8 locales (en, zh_TW, zh_CN, ja, ko, ms, ar) via custom `AppLocalizations`

---

## Root-Level Files

### `pubspec.yaml` (96 lines)
Flutter project manifest. Defines the app as `instalingo` v2.0.0+1 with SDK constraint `>=3.2.0 <4.0.0`. Declares all dependencies: `flutter_riverpod`, `go_router`, `phosphor_flutter` (vendored), `lottie`, `shimmer`, `confetti`, `cached_network_image`, `flutter_tts`, `google_mobile_ads`, `purchases_flutter` (RevenueCat), `firebase_*`, `shared_preferences`, `sqflite`, `flutter_local_notifications`, `share_plus`, `flutter_screenutil`, `url_launcher`, `intl`, `connectivity_plus`, `http`, `flutter_card_swiper`. Declares bundled assets from `assets/` and `instalingo_content/`. Has a `dependency_overrides` block pointing `phosphor_flutter` to `vendor/phosphor_flutter`.

### `analysis_options.yaml` (21 lines)
Dart static analysis configuration. Includes `package:flutter_lints/flutter.yaml`. Enforces lints: `avoid_print`, `prefer_const_constructors`, `prefer_single_quotes`, `sort_child_properties_last`, `use_super_parameters`, `always_use_package_imports`. Excludes generated files (`*.g.dart`, `*.freezed.dart`). Ignores `invalid_annotation_target`.

### `translate_all_cards.py` (169 lines)
Production translation script for InstaLingo v2 flashcard data. Translates card meanings and example translations into 7 languages (ko, ms, ar, ja, zh_CN, zh_TW) using either Google Cloud Translation API (fast) or the free `deep-translator` library (slow). Supports checkpoint/resume, single-level targeting (`--level`), and batch processing of unique texts. Operates directly on `instalingo_content/japanese/<level>/cards.json` files. Requires `pip install deep-translator google-cloud-translate`.

### `l10n.yaml.disabled` (5 lines)
Disabled Flutter l10n codegen configuration. Specifies ARB directory as `lib/l10n`, template as `app_en.arb`, and output class as `app_localizations.dart`. The `.disabled` suffix means codegen does not currently run — the app uses hand-maintained locale classes instead.

### `.gitignore` (57 lines)
Git ignore rules covering: Flutter/Dart build artifacts (`.dart_tool/`, `build/`, `*.g.dart`, `*.freezed.dart`), IDE files (`.idea/`, `.vscode/`), macOS `.DS_Store`, Android platform secrets (`local.properties`, `key.properties`), iOS generated files (`Pods/`, `Podfile.lock`), test coverage, temp files, Python `__pycache__/`, and raw data archives.

### `README.md` (18 lines)
Project README. Brief introduction to InstaLingo as a multilingual Flutter language-learning app with the Busan Harbor design language. Points readers to `AGENTS.md` for setup instructions and Flutter docs for beginners.

### `AGENTS.md` (57 lines)
Developer agent reference. Documents project setup commands (`flutter pub get`, `build_runner`), key dependencies (Riverpod, GoRouter, Phosphor, ScreenUtil), architecture overview, coding conventions (no emojis, `context.appTheme` extension, ScreenUtil design size 390×844), build commands, and a list of currently empty asset directories.

### `INCOMPLETE_ITEMS.md` (102 lines)
Audit report tracking known incomplete work on the `claude-code-ver` branch. Lists 12 completed fixes (crash fixes, TTS persistence, locale fallbacks, Semantics accessibility, const constructors, dead code removal, color tokenization). Tracks 6 categories of pending work: hardcoded onboarding strings (~180 localization entries needed), remaining accessibility Semantics widgets (~10 screens), potentially dead/stub files, missing asset files, remaining hardcoded colors, and a reminder that Flutter SDK is not available in this environment for `flutter analyze`/`flutter test`/`flutter build`.

---

## `lib/` — Flutter Application Source

### Entry Point

#### `lib/main.dart` (125 lines)
App entry point. `main()` initializes Flutter bindings, locks orientation to portrait, sets transparent status bar with dark icons, then launches `InstaLingoApp` under `ProviderScope`. `InstaLingoApp` is a `ConsumerWidget` that watches `darkModeProvider` and `localeProvider`, shows a loading splash while `localeReadyProvider` resolves, then wraps everything in `ScreenUtilInit` (design size 390×844) and returns a `MaterialApp.router` with theme, locale, and GoRouter. `_AppLoader` is a minimal splash widget (navy background, orange spinner, "InstaLingo" text) shown before `ScreenUtilInit` is ready.

---

### `lib/config/` — Configuration Constants

#### `lib/config/points_config.dart` (28 lines)
Centralized gamification constants. `PointsConfig` (static class, private constructor) defines: `cardSwipedWorth` (5 XP), `cardsSavedWorth` (3 XP), `dailyGoalWorth` (50 XP), `streakDayWorth` (10 XP), `gemPerDay` (5 gems), `smartReviewWorth` (3 XP), `streakShieldCost` (100 gems). `starsFor(double correctRatio)` returns 3 stars for ≥1.0, 2 for ≥0.5, 1 otherwise.

---

### `lib/theme/` — Visual Design System

#### `lib/theme/app_theme.dart` (507 lines)
The "Busan Harbor" maritime design system. Defines:
- **`BusanHarborTokens`** — Raw color palette (navy, orange, cream, ink, sea, coral, brass, mint, amber, bronze, silver with variants).
- **`PostCardGradients`** — 5 dark gradient pairs for post card backgrounds.
- **`AppColors`** — Legacy semantic colors rewired to Busan tokens (primary, secondary, accent, chill, xp, streak, gems, language colors, success/error).
- **`AppTheme`** — `lightTheme` and `darkTheme` getters using `_buildTheme()` with M3 `ThemeData`, custom text theme (heavy display, w800 labels), full-width 54px buttons, 4px radius cards with 1px borders.
- **`AppThemeExtension`** — Custom `ThemeExtension` carrying extra slots (skeleton colors, harbor colors, card shadow, `isDark` flag) with `copyWith`/`lerp`.
- **`AppThemeExtensionX`** — `BuildContext` extension for `context.appTheme` shorthand.

---

### `lib/models/` — Data Models

#### `lib/models/localized_text.dart` (22 lines)
Multi-locale string resolution utility. `LocalizedText` wraps a `Map<String, String>` and provides `resolve(String languageCode)` with English fallback, then first-available fallback. For `zh_TW`, does NOT fall back to `zh` (Simplified) to avoid script mixing.

#### `lib/models/achievement.dart` (44 lines)
Gamified achievement model. Fields: `id`, `title` (LocalizedText), `description` (LocalizedText), `iconName`, `targetValue`, `currentValue` (default 0), `isUnlocked` (default false), `unlockedAt` (DateTime?), `tier` (default 'bronze'). Computed `progressRatio` clamps `currentValue/targetValue` to 0.0–1.0. Has `copyWith`.

#### `lib/models/user.dart` (162 lines)
Central user profile model. `StreakRecord` enum: `completed`, `missed`, `shielded`, `todayPending`, `repaired`. `UserProfile` class with fields: `id`, `displayName`, `email`, `nativeLanguage` (default 'zh_TW'), `learningLanguage` (default 'ja'), `currentLevel` (default 'N5'), `proficiencyLevel`, `dailyGoal`, `streak`, `xp`, `gems`, `totalCardsSwiped`, `isPro`, `proExpiry`, `achievements`, `savedWords`, `alreadyKnewWords`, `activeDays`, `streakShields`, `notificationsEnabled`, `reminderTime`, `joinedAt`. Full `copyWith`, `toJson`/`fromJson` with sensible defaults.

#### `lib/models/vocab_card.dart` (194 lines)
Core flashcard data models:
- **`VocabCard`** — Atomic unit: `id`, `word`, `reading`, `pos`, `level`, `topic`, `imageUrl`, `audioUrl`, `exampleText`, `exampleReading`, `exampleAudioUrl`, `source`, `meanings` (Map<String,String>), `exampleTranslations` (Map<String,String>). Provides `meaningFor(locale)` and backward-compat `meaning`/`meaningZh` getters. `fromJson` handles both old single-field and new map formats.
- **`CardDeck`** — Collection: `id`, `language`, `level`, `displayName`, `displayNameZh`, `totalCards`, `cards` (List<VocabCard>).
- **`SRSData`** — Spaced repetition tracking: `cardId`, `state`, `step`, `stability`, `difficulty`, `due`, `lastReview`, `reviewCount`, `lapseCount`.

#### `lib/models/chill_post.dart` (119 lines)
Social feed models:
- **`ChillPost`** — Feed post: `id`, `authorName`, `authorHandle`, `authorAvatarUrl`, `imageUrl`, `content`, `targetWord`, `targetWordId`, `tags`, `likes`, `comments` (List<ChillComment>), `createdAt`.
- **`ChillComment`** — Comment: `authorName`, `content`.
- **`ChillCharacter`** — Fictional author persona: `id`, `name`, `handle`, `bio`, `avatarUrl`, `level`, `personality`, `colorHex`.

---

### `lib/providers/` — State Management (Riverpod)

#### `lib/providers/locale_provider.dart` (102 lines)
Locale selection. `localeProvider` (`StateNotifierProvider<LocaleNotifier, Locale>`) loads saved locale from SharedPreferences, auto-detects device locale on first launch. Supports zh_TW, zh_CN, ja, ko, ms, ar with en fallback. `localeReadyProvider` (`FutureProvider<bool>`) gates UI rendering until locale is resolved.

#### `lib/providers/onboarding_provider.dart` (75 lines)
Onboarding flow state. `OnboardingData` holds: `nativeLanguage`, `learningLanguage`, `targetLevel`, `proficiencyLevel`, `motivations` (List<String>), `dailyGoalMinutes`, `learningGoal` (enum: examPrep/casual). `onboardingDataProvider` (`StateNotifierProvider`) with setters for each field. 7 total steps.

#### `lib/providers/revenuecat_provider.dart` (15 lines)
Subscription entitlement placeholder. `isProProvider` currently reads `isPro` from `userProvider`. TODO marks it for full RevenueCat integration (offerings, entitlements, restore purchases, promo offers).

#### `lib/providers/settings_provider.dart` (106 lines)
User preferences persistence. Providers: `sharedPrefsProvider` (`FutureProvider<SharedPreferences>`), `darkModeProvider` (bool notifier), `soundEnabledProvider` (bool notifier), `onboardingCompleteProvider` (bool notifier), `ttsEnabledProvider` (bool notifier), `soundServiceProvider` (`Provider.autoDispose<SoundService>` with keepAlive). Each notifier loads from SharedPreferences on init and persists on toggle.

#### `lib/providers/srs_provider.dart` (117 lines)
Spaced Repetition System state. `srsProvider` (`AsyncNotifierProvider<SRSNotifier, List<SRSData>>`) opens SQLite database `instalingo_srs.db`, creates `srs_data` table. Methods: `scheduleReview(cardId, rating)` — runs FSRS algorithm, upserts to SQLite; `getDueCards()` — returns cards where `due <= now`; `getReviewCount()`; `getCardData(cardId)`.

#### `lib/providers/user_provider.dart` (131 lines)
User profile persistence. `userProvider` (`StateNotifierProvider<UserNotifier, UserProfile>`) initializes with defaults (id: user_1, zh_TW native, ja learning, N5 level, dailyGoal 20). Loads/saves JSON from SharedPreferences. Methods: `updateProfile`, `addXp`, `addGems`, `incrementStreak`, `saveWord`, `markAlreadyKnew`, `incrementCardsSwiped`, `unlockAchievement`, `upgradeToPro`.

#### `lib/providers/vocab_deck_provider.dart` (46 lines)
Card deck data provision. Providers: `vocabDeckProvider` (`FutureProvider.family<CardDeck, String>`) loads deck by level; `currentDeckProvider` loads deck for user's current level; `cardByIdProvider` (`FutureProvider.family<VocabCard?, String>`) looks up card in current deck; `cardByIdGlobalProvider` searches all levels (n5→n1). Uses `CardDataLoader`.

---

### `lib/services/` — Business Logic Services

#### `lib/services/language_service.dart` (39 lines)
Language switching orchestrator. `LanguageService(WidgetRef)` syncs three dimensions: UI locale (via `localeProvider`), native language (via `userProvider`), and learning language (via `userProvider`).

#### `lib/services/notification_service.dart` (91 lines)
In-app study reminder. `NotificationService(WidgetRef, BuildContext)` runs a `Timer.periodic(30s)` that checks if current time matches `user.reminderTime`. Fires a `SnackBar` with localized reminder text. TODO: replace with `flutter_local_notifications.zonedSchedule` for true background delivery.

#### `lib/services/sound_service.dart` (63 lines)
Audio/haptic feedback. `SoundService(Ref)` provides: `tap()` (click + light haptic), `correct()` (medium haptic), `wrong()` (heavy haptic), `complete()` (heavy haptic), `levelUp()` (heavy haptic), `select()` (click + selection click). All methods early-return if `soundEnabledProvider` is false.

#### `lib/services/tts_service.dart` (72 lines)
Text-to-speech for Korean and Japanese. `TtsService(Ref)` uses `flutter_tts` with language-specific settings (rate 0.4, pitch 1.0). Methods: `speakKorean(text)`, `speakJapanese(text)`, `speak(text, languageCode)` (auto-detects from character set). Exposed via `ttsServiceProvider`.

#### `lib/services/ads/ad_pool_manager.dart` (25 lines)
AdMob ad pool stub. `AdPoolManager` has `initialize()` (sets `_initialized = true`) and `isReady` getter. TODO: implement native ad pre-loading (5-7 ads), rotation every N cards, free/pro tier gating, failure handling.

#### `lib/services/share/card_image_generator.dart` (52 lines)
Shareable card image generation. `CardImageGenerator.generateCardImage(VocabCard)` uses `dart:ui` Canvas to draw a 1080×1080 PNG: navy background (`#0F1F2E`), two thin orange accent bars, word centered in light text. Returns `Uint8List` PNG bytes. TODO: gradient background, reading/meaning labels, watermark, QR code.

#### `lib/services/share/share_service.dart` (32 lines)
Social sharing via `share_plus`. `ShareService` has: `shareCard(VocabCard, AppLocalizations)` — formats word/reading/meaning + download link as text share; `shareApp(AppLocalizations)` — shares app invite. Could be extended to share the image from `CardImageGenerator`.

#### `lib/services/srs/fsrs_scheduler.dart` (164 lines)
FSRS-5 spaced repetition algorithm implementation. `FSRSScheduler` (static class) with 16 trained weights. `schedule(...)` — main entry: takes card state + rating (1=Again, 2=Hard, 3=Good, 4=Easy), returns updated `SRSData` with new stability, difficulty, due date, and review counts. Rating 1 → lapse → relearning state with reduced stability. Ratings 2-4 → review state with FSRS-5 formula. Helper methods: `retrievability`, `_initialStability`, `_initialDifficulty`, `_deltaD`, `_nextStability` (core formula with hard penalty/easy bonus), `_stabilityAfterFailure`, `_stabilityShortTerm`, `_nextInterval`.

---

### `lib/data/` — Data Loaders

#### `lib/data/card_data_loader.dart` (48 lines)
JLPT vocabulary deck loader. `CardDataLoader.loadDeck(String level)` loads `instalingo_content/japanese/<level>/cards.json` via `rootBundle`, parses to `CardDeck`, sorts cards by difficulty. `_cardDifficulty(VocabCard)` scores by word length (2×), kanji count (8×), reading length (0.5×), with kana-only bonus (-3). Currently hardcoded to Japanese.

#### `lib/data/chill_post_loader.dart` (203 lines)
Chill Corner post/character loader. `ChillPostLoader` loads `posts.json` and `characters.json` from `instalingo_content/shared/`. Handles both `{"posts": [...]}` wrapped and plain array formats with `FormatException` fallback. Falls back to 5 hardcoded demo posts and 5 demo characters (Maya, Kenji, Yuna, Takeshi, Hana) when JSON files are unavailable.

---

### `lib/router/` — Navigation

#### `lib/router/app_router.dart` (192 lines)
Central GoRouter configuration. `AppRouter.router` defines:
- **Slides**: `/splash`, `/onboarding` + 6 sub-steps, `/swipe` (optional `?wordId=`), `/swipe/complete`, `/post/:id`, `/paywall`, `/profile/stats`, `/profile/achievements`, `/profile/settings`, `/profile/edit`, `/profile/help`
- **ShellRoute** (`MainShell`): `/home`, `/review`, `/collections`, `/profile`
- Helpers: `_slidePage()` (horizontal slide transition), `_fadePage()` (fade transition)

---

### `lib/utils/` — Utility Classes

#### `lib/utils/responsive.dart` (60 lines)
Responsive layout utilities. `Responsive` (static) provides: `isMobile()`, `isTablet()`, `isDesktop()`, `isLandscape()`, `maxContentWidth()` (1000/800/560/width), `responsivePadding()` (80/48/32/20). `ConstrainedContent` widget wraps child in centered, width-constrained container with `MediaQuery` manipulation.

---

### `lib/l10n/` — Localization

#### `lib/l10n/app_localizations.dart` (684 lines)
Abstract base class defining ~200 localizable string getters and plural methods (`dayStreakCount`, `lapseCount`, `profile_learningStatus`, `timeSpentHoursMinutes`). Contains `_AppLocalizationsDelegate` mapping locales to implementation factories. `supportedLocales` = [en, zh_TW, zh_CN, ja, ko, ms, ar]. `static of(BuildContext)` convenience accessor.

#### `lib/l10n/app_en.arb` (748 lines)
English ARB template. Master translation source with ~700 entries covering: app titles, onboarding, swipe/gesture labels, review system, achievements, streak mechanics, paywall/subscription, profile/settings, notifications, learning features, exercise types. All other locale ARBs are translations of this file.

#### `lib/l10n/app_zh_TW.arb` (738 lines)
Traditional Chinese (Taiwan) ARB translation. Parallel structure to `app_en.arb` with some untranslated placeholder entries remaining.

#### `lib/l10n/app_localizations_en.dart` (931 lines)
English locale implementation. `AppLocalizationsEn extends AppLocalizations` — overrides all getters and plural methods with English strings.

#### `lib/l10n/app_localizations_zh_tw.dart` (926 lines)
Traditional Chinese (Taiwan) implementation. Uses single Chinese characters for day abbreviations (一, 二, 三...).

#### `lib/l10n/app_localizations_zh_cn.dart` (926 lines)
Simplified Chinese (Mainland China) implementation. Some translations are machine-quality (e.g., "feed" → "饲料" meaning "animal feed").

#### `lib/l10n/app_localizations_ja.dart` (926 lines)
Japanese implementation. App title: "インスタリンゴ". JLPT levels with full Japanese names.

#### `lib/l10n/app_localizations_ko.dart` (926 lines)
Korean implementation. Some translation errors noted (e.g., `perYear` → "/예멘 아랍 공화국" meaning "Yemen Arab Republic").

#### `lib/l10n/app_localizations_ms.dart` (926 lines)
Malay (Bahasa Melayu) implementation. Uses Malay day names (Isnin, Selasa...), uppercase button text.

#### `lib/l10n/app_localizations_ar.dart` (926 lines)
Arabic implementation (RTL). Arabic script, Arabic day names. Some translation errors noted (e.g., `langNameKo` → "شكرا" meaning "thanks").

---

### `lib/widgets/` — Reusable UI Components

#### `lib/widgets/animations.dart` (310 lines)
Shared animation library:
- **`FadeSlide`** — Fade + vertical slide entry with configurable delay, offset, duration.
- **`ScaleBounce`** — Scale from 0.5→1.0 with elasticOut for playful entrance.
- **`Shake`** — Horizontal shake triggered by boolean flip, decaying amplitude.
- **`Pulse`** / **`PulseContainer`** — Continuous gentle scale pulse (1.0–1.05, 1.2s cycle).
- **`StaggerList`** — Column with cascading FadeSlide entries.
- **`Shimmer`** — Moving gradient ShaderMask for loading skeleton effect.

#### `lib/widgets/error_states.dart` (201 lines)
Standardized state widgets:
- **`ErrorState`** — Centered icon + title + message + optional retry button. Falls back to l10n values.
- **`EmptyState`** — Similar layout, tray icon, no retry button.
- **`LessonLoader`** — Full-screen loading with bouncing rocket icon animation, title, and progress indicator.

#### `lib/widgets/harbor_widgets.dart` (214 lines)
"Busan Harbor" design primitives:
- **`HarborAppBar`** — Navy header with optional back button, overline label, title, trailing actions.
- **`HarborOutlinedTile`** — Outlined card with accent border, optional tappable.
- **`HarborEyebrow`** — Uppercase section label with configurable color and letterSpacing.
- **`HarborAccentBar`** — Small horizontal colored bar (3px × 24px) for underlining section headers.
- **`HarborGhostButton`** — Outlined pill button for dark navy surfaces.

#### `lib/widgets/lottie_loader.dart` (85 lines)
Lottie animation wrappers:
- **`LottieLoader`** — Generic configurable loader.
- **`RocketLoader`** — Plays `rocket.json` (loop), default size 100.
- **`PointsCompletedLottie`** — Plays `points_completed.json` once (non-loop), default size 200.
- **`DailyPointsLottie`** — Plays `daily_points.json` (loop), default size 80.

#### `lib/widgets/post_image.dart` (242 lines)
Instagram-style post image renderer for Chill Corner.
- **`PostImage`** — Deterministic gradient from author name hash, optional `CachedNetworkImage` overlay, decorative circles + grid, target word overlay fallback when no image.
- **`_WordOverlay`** — Large target word text + JLPT label + "tap to learn" pill.
- **`_GridOverlay`** — `CustomPainter` drawing faint grid (30px spacing, 0.03 opacity).

#### `lib/widgets/skeleton.dart` (206 lines)
Shimmer-based loading placeholders:
- **`SkeletonLine`** — Shimmering rectangle bar.
- **`SkeletonCircle`** — Shimmering circle (avatar placeholder).
- **`SkeletonCard`** — Bordered card skeleton with lines + large block.
- **`ChillSkeleton`** — Full Chill feed page skeleton (header + 3 post mockups).
- **`LessonSkeleton`** — Lesson content skeleton (title + subtitle + 4 option rows).

#### `lib/widgets/streak_calendar.dart` (342 lines)
Monthly streak calendar widget. `StreakCalendar` (StatelessWidget) displays: flame badge with streak count, pending-today reminder banner, 7-column day grid with colored cells per `StreakRecord` (completed=orange fill, shielded=translucent+shield icon, repaired=70%+wrench icon, todayPending=orange border, missed=dimmed), legend row, streak shields count, optional "Repair streak" button.

---

### `lib/screens/` — Application Screens

#### `lib/screens/splash_screen.dart` (231 lines)
Startup splash screen. Navy gradient background with animated wave (custom `_HarborWavePainter`), compass icon, "InstaLingo" title + tagline. After brief delay, checks `onboardingCompleteProvider` and navigates to `/home` (returning) or `/onboarding` (new user).

#### `lib/screens/error_screen.dart` (53 lines)
Generic error screen. Warning icon, error title (from l10n), optional message. Standalone page for fatal errors.

#### `lib/screens/main_shell.dart` (155 lines)
Bottom navigation shell (Scaffold wrapper). 4 tabs: Home, Review, Collections, Profile. Uses `GoRouterState` to determine active index. Each tab uses Phosphor icons (outline/fill style switching) with animated orange accent bar on active tab. Dark navy bottom bar.

#### `lib/screens/daily_complete_screen.dart` (370 lines)
Daily goal celebration screen. Animated entrance (scale + fade with elastic curve), haptic feedback. Stats grid: cards swiped, saved, XP earned, gems earned. Current streak display. "Continue" → `/home`, "Share Achievement" → `share_plus`.

#### `lib/screens/swipe/swipe_screen.dart` (542 lines)
**Core learning experience** — Instagram Reels-style vertical PageView of vocabulary cards. Each card: word/reading on gradient (top 58%), meaning/actions (bottom 42%). Interactions: tap to flip (examples, tags, POS), double-tap save (heart), skip ("Already Knew"), vertical scroll between cards. Tracks progress, awards XP/gems, navigates to `DailyCompleteScreen` on exhaustion. Supports deep-link `?wordId=`.

#### `lib/screens/swipe/tutorial_overlay.dart` (199 lines)
First-time gesture tutorial. Semi-transparent overlay explaining 3 gestures: heart/save (right swipe), skip (left swipe), next (up swipe). Persists completion to SharedPreferences (`swipe_tutorial_shown`).

#### `lib/screens/review/review_screen.dart` (581 lines)
SRS review screen for saved words. Shows due cards from `srsProvider`. Front face: word + reading. Tap to flip: meaning + example. 4 rating buttons (Again 1, Hard 2, Good 3, Easy 4) trigger `srsProvider.notifier.scheduleReview`. XP awarded per review. "Review Complete" state when all due cards finished.

#### `lib/screens/home/chill_feed_screen.dart` (658 lines)
"Chill Corner" social feed (Instagram-like). `ChillPost` list via `ChillPostLoader`. Post cards: author avatar+name, gradient image (`PostImage`), content (max 4 lines), target word highlight (→ `/swipe`), tags, likes (double-tap heart), comments. Comments in draggable bottom sheet. Pull-to-refresh. FutureBuilder loading with shimmer.

#### `lib/screens/chill/post_detail_screen.dart` (589 lines)
Single ChillPost detail view. Masthead header with date, author row, gradient image, full content, featured target word box (→ `/swipe`), tags, action buttons (heart, comments, share), comment list, comment input field (local-only). Share via `share_plus`.

#### `lib/screens/collections/collections_screen.dart` (439 lines)
Saved words collection (2-column grid). Each card shows word/reading (front) and meaning (back) — tappable to flip. Search bar, level filter chips, word count header. Free tier: 100-word limit with upgrade prompt → `/paywall`.

#### `lib/screens/paywall/paywall_modal.dart` (328 lines)
Subscription bottom sheet. Slide-up animation. Segmented Annual ($59.99/yr, "Save 40%") / Monthly ($9.99/mo) toggle. 4 premium feature bullets. "Start Free Trial" CTA (currently just pops), "Maybe Later" dismiss.

#### `lib/screens/profile/profile_screen.dart` (619 lines)
Main profile screen. Navy masthead: user initials avatar, display name, action pills (Edit, Pro badge), stat strip (streak, XP, gems, level). Menu sections: Stats (→ stats, achievements), Settings (→ paywall, subscription, settings, help). 3-column saved words grid (first 9) at bottom.

#### `lib/screens/profile/stats_screen.dart` (310 lines)
Detailed statistics. Weekly XP bar chart (Mon-Sun, demo data), stat boxes (streak, XP, lessons, words), time spent (hardcoded 4h 32m), `StreakCalendar` widget with actual user data.

#### `lib/screens/profile/achievements_screen.dart` (234 lines)
Achievement list. Demo data (`_getDemoAchievements()`). Summary header (e.g., "2/5 unlocked"), "Unlocked" and "In Progress" sections. Cards showing icon, title, description, tier badge, progress bar/lock.

#### `lib/screens/profile/edit_profile_screen.dart` (400 lines)
Edit profile form. Centered initials avatar, editable name/email fields, tappable info cards: learning language picker (bottom sheet), proficiency level (A1-C2 picker), daily goal (5/10/15/20 min picker). Save via `userProvider.notifier.updateProfile()`.

#### `lib/screens/profile/help_support_screen.dart` (353 lines)
Help/FAQ. Sections: Getting Started (3 items), Learning Features (3 items), Account (2 items). Tappable FAQ items with bottom sheet explanations. "Contact Support" (email) and "Visit Help Center" (URL) buttons via `url_launcher`.

#### `lib/screens/profile/settings_screen.dart` (471 lines)
Settings screen. Sections: Appearance (dark mode, sound, TTS), Notifications (toggle, reminder time picker), Learning (daily goal, native language, learning language pickers), Account (email, check updates, reset progress, help, logout). Uses Riverpod for all toggles, `LanguageService` for language changes.

#### `lib/screens/onboarding/onboarding_screen.dart` (253 lines)
Onboarding intro (step 0). Navy hero panel with compass logo + "Discover Japanese". Cream section with 3 feature bullets: Swipe & Learn, Smart Review, Track Progress. "Get Started" → native language screen, "Skip" → `/home`. Animated fade+slide entrance.

#### `lib/screens/onboarding/native_language_screen.dart` (186 lines)
Onboarding step 1 — Select native/interface language. 6 options: English, T. Chinese, S. Chinese, Korean, Malay, Arabic. Radio-style tiles with orange selection indicator.

#### `lib/screens/onboarding/learning_language_screen.dart` (266 lines)
Onboarding step 2 — Select learning language + JLPT level. Japanese only (hardcoded). N5-N1 level picker with descriptions. Updates profile and onboarding data.

#### `lib/screens/onboarding/proficiency_screen.dart` (155 lines)
Onboarding step 3 — Select proficiency. Options: Beginner (N5), Elementary (N4), Intermediate (N3), Upper-Intermediate (N2), Advanced (N1).

#### `lib/screens/onboarding/learning_goal_screen.dart` (124 lines)
Onboarding step 4 — Learning goal. Two cards: "Prepare for an exam" (examPrep) or "Just for fun" (casual).

#### `lib/screens/onboarding/motivation_screen.dart` (150 lines)
Onboarding step 5 — Motivations. 2-column grid of 8 multi-select options: Career, Travel, Study Abroad, Culture, Family, Just for Fun, Brain Training, Movies & Shows.

#### `lib/screens/onboarding/commitment_screen.dart` (169 lines)
Onboarding step 6 (final) — Daily commitment. 4 options: 5min (Casual), 10min (Regular), 15min (Serious), 20min (Intense). On completion: saves all onboarding data to user profile, sets `onboardingCompleteProvider`, navigates to `/home`.

---

## `vendor/` — Vendored Dependencies

### `vendor/phosphor_flutter/` (Phosphor Icons)

#### `vendor/phosphor_flutter/pubspec.yaml` (46 lines)
Package manifest for `phosphor_flutter` v2.1.0. SDK constraint >=3.0.0. Registers 6 icon font families (Bold, Duotone, Fill, Light, Thin, Regular) with their .ttf font files.

#### `vendor/phosphor_flutter/lib/phosphor_flutter.dart` (6 lines)
Library barrel. Exports: `phosphor_icon_data.dart`, `phosphor_icon.dart`, `phosphor_icons.dart`.

#### `vendor/phosphor_flutter/lib/src/phosphor_icons_base.dart`
Base icon constants class. Contains all 772 Phosphor icon codepoints as `static const PhosphorIconData` fields (e.g., `PhosphorIconsBase.heart`, `.caretLeft`, `.warningCircle`, `.flame`). Each style (Bold, Duotone, Fill, Light, Thin, Regular) has its own subclass.

#### `vendor/phosphor_flutter/lib/src/phosphor_icon_data.dart`
Icon data class. Holds codepoint, fontFamily, fontPackage, matchTextDirection.

#### `vendor/phosphor_flutter/lib/src/phosphor_icon.dart`
Flutter `Icon`-like widget for Phosphor icons. Uses `PhosphorIconData` to render icons with size, color, semanticLabel, textDirection.

#### `vendor/phosphor_flutter/lib/src/phosphor_icons.dart`
Exports all 6 style modules (bold, duotone, fill, light, thin, regular).

#### `vendor/phosphor_flutter/lib/src/phosphor_icons_bold.dart`
772 bold-style Phosphor icon constants.

#### `vendor/phosphor_flutter/lib/src/phosphor_icons_duotone.dart`
772 duotone-style Phosphor icon constants.

#### `vendor/phosphor_flutter/lib/src/phosphor_icons_fill.dart`
772 fill-style Phosphor icon constants.

#### `vendor/phosphor_flutter/lib/src/phosphor_icons_light.dart`
772 light-style Phosphor icon constants.

#### `vendor/phosphor_flutter/lib/src/phosphor_icons_thin.dart`
772 thin-style Phosphor icon constants.

#### `vendor/phosphor_flutter/lib/src/phosphor_icons_regular.dart`
772 regular-style Phosphor icon constants.

---

## `tools/` — Python Data Pipeline & Tooling

#### `tools/parse_jlpt_vocab.py` (48 lines)
Step 1 of Japanese content pipeline. Parses raw JLPT CSV files (n5.csv through n1.csv from open-anki-jlpt-decks, MIT license) into a unified `vocabulary_raw.json` with word, reading, meaning, level fields.

#### `tools/match_jmdict.py` (95 lines)
Step 2. Matches JLPT vocabulary against JMdict XML dictionary (CC-BY-SA 4.0). Adds POS tags, readings, and English glosses to each word. Outputs `vocabulary_with_definitions.json` and `_unmatched.json`.

#### `tools/match_tatoeba_sentences.py` (71 lines)
Step 3. Matches vocabulary entries against Tatoeba corpus CSV to attach real-world Japanese example sentences (text, translation, Tatoeba ID + CC-BY 2.0 license). Outputs `vocabulary_with_sentences.json`. Keeps up to 3 examples per word.

#### `tools/build_final_cards.py` (128 lines)
Step 4 (final). Builds distributable card deck JSONs for N5/N4/N3. Filters: valid entries must have example text, POS, and word length ≤ 10. Groups by JLPT level, maps topics via `TOPIC_MAP`. Outputs `cards.json` per level to `instalingo_content/japanese/<level>/`. Archives filtered-out entries.

#### `tools/generate_chill_posts.py` (126 lines)
Generates Chill Corner social feed JSON. Defines 6 fictional characters (Sakura-chan, Kenji-san, etc.) with personality styles, and post templates per style. Loads cards from card JSONs, creates 50 posts with random dates/likes/comments/tags, writes `instalingo_content/shared/posts.json`.

#### `tools/generate_content.py` (1294 lines)
**Largest tool** — Golden content generator for English A1 courses. Contains:
- `WORD_TRANSLATIONS` — ~240 English words translated to 8 languages (hardcoded real translations).
- `INSTRUCTIONS` — Localized UI text for 9 exercise types.
- Exercise factories: `make_flashcard`, `make_vocab_mc`, `make_match_pairs`, `make_fill_blank`, `make_word_sorting`, `make_listen_type`, `make_image_id`, `make_grammar_tip`, `make_dialogue`.
- `SECTIONS` — Curriculum structure: 8 sections, 40 lessons, each with vocabulary.
- Generates 9 exercises per lesson with real sentences (not AI) and full 8-language localization.
- `validate_course()` checks exercise variety, template garbage, locale completeness, duplicate options.

#### `tools/json_to_dart.py` (130 lines)
Converts golden course JSON to compilable Dart code with `const` constructors for `Course`, `Section`, `Lesson`, `Exercise` objects and `LocalizedText` expressions. Bridges Python pipeline to Flutter codebase.

#### `tools/translation_pipeline.py` (557 lines)
Comprehensive translation management pipeline:
- **Export**: Extracts missing translations from 3 sources (ARB files, ChillPost content, exercise content) into a JSON export file.
- **Import**: Reads translated export, updates cache (SHA-256 keyed), injects translations back into Dart source via regex.
- **Verify**: Checks every `LocalizedText` has all 8 languages non-empty.
- **Stats**: Reports coverage percentages.
- **Cache**: `TranslationCache` class with hash-based change detection.

#### `tools/fix_translations.py` (208 lines)
Translation quality repair. Audits Chinese translations in raw vocab CSVs (missing, non-Chinese, too long). Uses DeepL API (free tier) for batch translation, with manual `[EN]` fallback marker.

#### `tools/validate_no_english_leaks.py` (253 lines)
CI-grade i18n validation. Checks: `LocalizedText` completeness in `demo_data.dart`, ARB file key parity and non-English leakage, hardcoded English strings in Dart widgets, deleted courses absence. Exit code 0 on pass, 1 on failure. Intended as PR gate.

#### `tools/verify_e2e.py` (357 lines)
End-to-end content pipeline integrity check. 7 checks: lesson vocabulary, post prerequisites, `LocalizedText` completeness, no raw English in learning content, UI reads `LocalizedText` properly, no emojis in content, provider vocabulary wiring. Overall pass/fail.

#### `tools/add_vocabulary.py` (173 lines)
One-shot codegen script. Injects `vocabulary` parameter into Lesson constructor helpers and `requiredWords` into Post constructors in `demo_data.dart` via regex-based Dart source manipulation.

#### `tools/data_pipeline.py` (280 lines)
Tatoeba data acquisition pipeline. Downloads `sentences.csv` (~750MB) and `links.csv` (~450MB), builds English sentence index (3-8 words), builds translation link index, filters for Oxford A1 vocabulary words. Reports teachable word coverage statistics. Part of the "real data over synthetic" initiative.

---

## `scripts/` — Utility Scripts

#### `scripts/replace_images.py` (170 lines)
Chill Corner image URL manager. Subcommands: `init` (set placeholder paths), `mapping` (apply CSV-sourced image URLs to posts), `avatars` (apply author avatar URLs), `export` (dump current image URLs to CSV). Operates on `instalingo_content/shared/posts.json` with `.json.bak` backup.

---

## `web/` — Web/PWA Platform

#### `web/index.html` (109 lines)
PWA HTML shell. Preloads Noto Sans CJK fonts (SC, TC, JP, KR) with preconnect hints. PWA meta tags (mobile-web-app-capable, apple-mobile-web-app-capable). Service worker registration. Forces HTML renderer (`flutterWebRenderer = "html"`) for instant CJK rendering. Offline notification bar.

#### `web/flutter_service_worker.js`
PWA service worker. Cache-first strategy: pre-cache app shell on install (main.dart.js, canvaskit, assets, HTML), serve from cache on fetch, update cache in background, clean old caches on activate. Cache name: `instalingo-v3-${timestamp}`.

#### `web/manifest.json` (35 lines)
PWA manifest. Name: "InstaLingo", standalone display, navy theme color (`#0D1B2A`), portrait-primary orientation. 4 icons: 192×192 and 512×512 (regular + maskable variants).

#### `web/favicon.png`
InstaLingo favicon (binary).

---

## `ios/` — iOS Platform

#### `ios/Podfile`
CocoaPods configuration. 3 build configurations (Debug, Profile, Release). Analytics stats disabled.

#### `ios/Runner/AppDelegate.swift` (10+ lines)
iOS app delegate. `@main AppDelegate: FlutterImplicitEngineDelegate`. Standard Flutter iOS boilerplate delegating to `FlutterAppDelegate`.

#### `ios/Runner/SceneDelegate.swift`
iOS scene delegate for multi-window support (standard Flutter template).

#### `ios/Runner/Runner-Bridging-Header.h`
Objective-C bridging header (Flutter standard).

#### `ios/Runner/Info.plist`
iOS app info property list (standard Flutter template).

#### `ios/RunnerTests/RunnerTests.swift` (13 lines)
Placeholder XCTest test case. Single empty `testExample()` method. No real tests written.

#### `ios/Runner.xcodeproj/project.pbxproj`
Xcode project file (auto-generated, Flutter standard).

#### `ios/Flutter/Debug.xcconfig` / `Release.xcconfig`
Flutter iOS build configuration files.

#### `ios/Flutter/AppFrameworkInfo.plist`
Flutter iOS framework info (auto-generated).

---

## `android/` — Android Platform

#### `android/build.gradle.kts`
Top-level Gradle build (Kotlin DSL). `allprojects` repos: google(), mavenCentral(). Root build dir redirected to `../../build`.

#### `android/settings.gradle.kts`
Gradle settings (Kotlin DSL). Standard Flutter Android structure.

#### `android/gradle.properties`
Gradle properties (Flutter standard).

#### `android/.gitignore`
Android-specific git ignore rules.

---

## `instalingo_content/` — Bundled Content Data

#### `instalingo_content/japanese/n5/cards.json`
JLPT N5 vocabulary card deck JSON. Array of `VocabCard` objects with multi-language meanings and example translations. Loaded by `CardDataLoader`.

#### `instalingo_content/japanese/n4/cards.json`
JLPT N4 vocabulary card deck JSON.

#### `instalingo_content/japanese/n3/cards.json`
JLPT N3 vocabulary card deck JSON.

#### `instalingo_content/japanese/n2/cards.json`
JLPT N2 vocabulary card deck JSON.

#### `instalingo_content/japanese/n1/cards.json`
JLPT N1 vocabulary card deck JSON.

#### `instalingo_content/shared/posts.json`
Chill Corner social feed posts JSON. Array of `ChillPost` objects with comments, tags, target word references. Loaded by `ChillPostLoader`.

#### `instalingo_content/shared/characters.json`
Chill Corner character profiles JSON. Array of `ChillCharacter` objects. Loaded by `ChillPostLoader`.

#### `instalingo_content/archive/register_vocabulary.json`
Archived vocabulary registration data from pipeline processing.

#### `instalingo_content/archive/filtered_vocabulary.json`
Archived filtered-out vocabulary entries (did not meet quality thresholds for card generation).

---

## `raw_data/` — Raw Source Data

#### `raw_data/jlpt_n1.csv` through `raw_data/jlpt_n5.csv`
Raw JLPT vocabulary lists by level (CSV format). Source: open-anki-jlpt-decks (MIT license). Consumed by `parse_jlpt_vocab.py`.

#### `raw_data/jmdict_lookup.json`
JMdict dictionary lookup cache. Keyed by Japanese word, contains readings, POS tags, glosses. Produced by `match_jmdict.py`.

#### `raw_data/jpn_indices.csv`
Japanese word frequency indices.

#### `raw_data/word_examples.json`
Example sentences for vocabulary words (Tatoeba-sourced).

#### `raw_data/jlpt_all.json`
Unified JLPT vocabulary across all levels. Produced by `parse_jlpt_vocab.py`.

#### `raw_data/tatoeba_jpn_eng.tsv`
Tatoeba Japanese-English parallel sentence corpus. 1000+ sentence pairs (CC-BY 2.0 license). Used by `match_tatoeba_sentences.py` and `data_pipeline.py`.

#### `raw_data/JMdict_e.xml.gz`
Compressed JMdict Japanese-English dictionary XML. Source: EDRDG (CC-BY-SA 4.0). Parsed by `match_jmdict.py`.

---

## `assets/` — Bundled App Assets

#### `assets/lottie/rocket.json`
Lottie animation: rocket loading animation. Used by `RocketLoader` widget.

#### `assets/lottie/points_completed.json`
Lottie animation: points/lesson completion celebration. Used by `PointsCompletedLottie` widget (plays once).

#### `assets/lottie/daily_points.json`
Lottie animation: daily points/stars animation. Used by `DailyPointsLottie` widget (loop).

#### `assets/images/cards/.gitkeep`
Placeholder for card illustration images directory (currently empty).

#### `assets/icons/.gitkeep`
Placeholder for custom icon assets directory (currently empty).

#### `assets/audio/.gitkeep`
Placeholder for audio pronunciation files directory (currently empty).

#### `assets/fonts/.gitkeep`
Placeholder for custom font files directory (currently empty).

#### `assets/flags/.gitkeep`
Placeholder for language flag images directory (currently empty).

---

## Architecture Summary

```
┌─────────────────────────────────────────────────┐
│  InstaLingo App (Flutter)                        │
│                                                  │
│  main.dart → MaterialApp.router                  │
│    ├── Theme: app_theme.dart (Busan Harbor)      │
│    ├── Router: app_router.dart (GoRouter)        │
│    ├── L10n: app_localizations_*.dart (8 locales)│
│    └── State: Riverpod providers                 │
│                                                  │
│  Screens (UI Layer)                              │
│    splash_screen → onboarding/* or main_shell    │
│    main_shell ─┬─ home/chill_feed_screen          │
│                ├─ review/review_screen            │
│                ├─ collections/collections_screen   │
│                └─ profile/profile_screen + subs   │
│    swipe/swipe_screen (core learning)            │
│    daily_complete_screen (celebration)           │
│    paywall/paywall_modal (monetization)          │
│                                                  │
│  Business Logic (Services)                       │
│    language_service, notification_service,       │
│    sound_service, tts_service, ads/ad_pool_*,    │
│    share/card_image_generator, share/share_*,    │
│    srs/fsrs_scheduler (FSRS-5 algorithm)         │
│                                                  │
│  Data Layer                                      │
│    providers: user, srs, vocab_deck, locale,     │
│              settings, onboarding, revenuecat     │
│    data loaders: card_data_loader,               │
│                  chill_post_loader                │
│                                                  │
│  Models                                          │
│    vocab_card, user, achievement, chill_post,    │
│    localized_text                                │
│                                                  │
│  Widgets (Shared Components)                     │
│    animations, error_states, harbor_widgets,     │
│    lottie_loader, post_image, skeleton,          │
│    streak_calendar                               │
└─────────────────────────────────────────────────┘
      ↑ Data loaded from bundled JSON assets
      │ (instalingo_content/japanese/*/cards.json)
      │ (instalingo_content/shared/{posts,characters}.json)
      ↑ Generated by Python data pipeline (tools/)
        parse_jlpt_vocab → match_jmdict → match_tatoeba
        → build_final_cards → generate_chill_posts
        → translation_pipeline → validate_no_english_leaks
```

---

## File Count Summary

| Category | Count | Description |
|---|---|---|
| Dart source (lib/) | 58 | Flutter app code |
| Localization (.arb + .dart) | 10 | ARB templates + locale implementations |
| Python tools | 14 | Data pipeline, translation, validation |
| Web platform | 3 | PWA shell, service worker, manifest |
| iOS platform | 8+ | Swift, Xcode project, config |
| Android platform | 4+ | Gradle, properties, config |
| Vendor (phosphor) | 12 | Icon font package files |
| Root config/docs | 7 | pubspec, analysis_options, l10n, .gitignore, README, AGENTS, INCOMPLETE_ITEMS |
| Content JSON | 10 | Bundled vocabulary + social content |
| Raw data | 8+ | CSV, XML, TSV source data |
| Assets | 6+ | Lottie animations, placeholders |
| **Total code/config files** | **~140** | |

---

*End of catalog. This file describes every source code and configuration file in the InstaLingo project as of 2026-06-09.*
