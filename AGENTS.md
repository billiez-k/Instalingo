# InstaLingo Flutter — Agent Notes

## Current State (verified 2025-06-09, branch: claude-code-ver)

### Data: 8,054 JLPT cards (N5–N1)
- 100% coverage: id, word, reading, pos, level, topic, source
- 100% coverage: meaning (en), translation (zh)
- 93.5% coverage: example_text + example_translation (7,532/8,054)
- 522 gaps: 176 N2 + 315 N1 + 31 lower levels — obscure compounds, grammar patterns
- 0 images, 0 audio across all 8,054 cards
- JMdict formatting cleaned: [01] sense indices and ~ notation tags removed
- Posts.json: 25 posts with real JMdict data (was AI-generated slop)
- 2/7 locales in card translations: en + zh_TW only

### L10n: 358 keys across 7 locales
- Abstract class: 358 keys. All 7 locales implement 358/358.
- 266/358 actively used in app code. 92 unused.
- l10n.yaml is DISABLED (renamed to .disabled) — ARB code gen not running
- CRITICAL: Do NOT use nonexistent l10n keys. All keys checked against abstract class.

### Models (8 models in 4 files)
- VocabCard, CardDeck, SRSData, UserProfile: full fromJson/toJson
- ChillPost, ChillComment: full fromJson/toJson
- Achievement: const constructor only, no fromJson/toJson
- DEAD fields: audioUrl, exampleReading, exampleAudioUrl, source, exampleTranslations on VocabCard; proExpiry on UserProfile

### Providers (23 total, 7 DEAD)
- ACTIVE: userProvider, currentDeckProvider, cardByIdGlobalProvider, srsProvider, localeProvider, darkModeProvider, onboardingCompleteProvider, commentStoreProvider, likeStoreProvider, etc.
- DEAD: vocabDeckProvider, cardByIdProvider, OnboardingDataNotifier, SoundNotifier, TtsNotifier, soundServiceProvider, DarkModeNotifier
- srs_provider.dart: NO try/catch on async DB ops

### Screens (24 files)
- 5/24 have loading+error+empty states (review, swipe, chill_feed, profile, collections)
- All hardcoded strings use l10n keys — no raw English strings
- 7 achievement titles still hardcoded in achievements_screen.dart

### Services (12 files, 7 DEAD)
- ACTIVE: FSRSScheduler, CardDataLoader, ChillPostLoader, LanguageService, SoundService
- DEAD: AdPoolManager, CommentStoreNotifier (unused, superseded), LikeStoreNotifier (unused, superseded), NotificationService, CardImageGenerator, ShareService, TtsService
- FSRS-5 implementation: real algorithm with 17 weights, SQLite persistence, stability/difficulty tracking

### Dependencies: 13/29 unused (45%)
- UNUSED: animations, confetti, connectivity_plus, firebase_core, firebase_analytics, firebase_crashlytics, flutter_card_swiper, flutter_local_notifications, flutter_svg, google_mobile_ads, http, purchases_flutter, riverpod_annotation

### Build System
- pubspec.yaml declares 10 asset directories: 3 have real files, 7 are .gitkeep only
- assets/fonts/ and assets/flags/ NOT declared in pubspec but have .gitkeep
- 3 Lottie animations: daily_points.json, points_completed.json, rocket.json

### Key Conventions (DO NOT VIOLATE)
- NO emojis anywhere. Use Phosphor icons (phosphor_flutter) exclusively.
- `context.appTheme` extension for custom theme colors.
- All screens use `flutter_screenutil` (designSize: 390x844).
- Dark mode toggle persisted via SharedPreferences.
- AppLocalizations.of(context) for all user-facing strings.
- NEVER use nonexistent l10n keys — check app_localizations.dart first.

## Project Setup
This is a manually-scaffolded Flutter project (no `flutter create` available on build machine). To initialize properly:

```bash
cd instalingo_flutter
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Dependencies Used
- `flutter_riverpod` + `riverpod_annotation` — State management
- `go_router` — Declarative navigation
- `phosphor_flutter` — Professional icons (ZERO emojis policy)
- `flutter_screenutil` — Responsive design
- `intl` — Date formatting
- `shared_preferences` — Local settings persistence
- `animations` — Material motion transitions
- `shimmer` — Loading skeletons
- `fl_chart` — Charts (stats screen)

## Architecture
- `lib/main.dart` — Entry point with ProviderScope + ScreenUtilInit
- `lib/theme/app_theme.dart` — Light/dark themes, AppThemeExtension
- `lib/router/app_router.dart` — GoRouter configuration
- `lib/models/` — Immutable data classes
- `lib/providers/` — Riverpod state notifiers
- `lib/data/demo_data.dart` — All demo content (English A1)
- `lib/screens/` — Feature screens organized by tab

## Key Conventions
- NO emojis anywhere. Use Phosphor icons exclusively.
- `context.appTheme` extension for accessing custom theme colors.
- All screens use `flutter_screenutil` for responsive sizing (designSize: 390x844).
- Dark mode toggle persisted via SharedPreferences.
- Demo data is const/static — replace with real backend calls.

## Build Commands
```bash
flutter build apk          # Android
flutter build ios          # iOS (requires macOS + Xcode)
flutter build web          # Web
flutter test               # Run tests
flutter analyze            # Static analysis
```

## Missing Assets
The following asset directories are referenced in pubspec.yaml but do not yet contain files:
- `assets/images/`
- `assets/icons/`
- `assets/lottie/`
- `assets/flags/`
- `assets/fonts/Inter-*.ttf`

Add real assets before building for production. Placeholder content uses Phosphor icons and colored containers.
