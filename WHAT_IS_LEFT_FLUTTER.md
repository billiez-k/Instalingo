# InstaLingo Flutter — What Is Left

## Status
Full Flutter project scaffolded with professional architecture, theme system, animations, and all core screens. `flutter analyze` reports **zero errors**, `flutter build web --no-tree-shake-icons` succeeds.

**Total codebase: ~28,600 lines of Dart across 67 files (58 hand-written + 9 generated localization delegates).**

**Last update:** 2026-05-25 (revision 10) — **Full LocalizedText migration complete**: all 42 Chill Corner posts and all 35 exercises use `LocalizedText` for every translatable field (`wordTranslation`, `wordExplanation`, `wordExampleTranslation`, `explanation`, `grammarRule`, `grammarExample`, `writingPrompt`, `sampleAnswer`). Non-English languages have 6 posts each teaching actual target-language vocabulary (e.g., Korean `매운`/`사랑`/`친구`, French `bonjour`/`amour`/`fromage`). **70 lessons all have `vocabulary` lists** linking to post `requiredWords`. `tools/translation_pipeline.py` v2 handles `LocalizedText` extraction/injection. `tools/verify_e2e.py` runs 7 automated checks. **350 ARB keys per language**. **Zero hardcoded English UI strings**.

## Completed

### Core Infrastructure
- [x] Project setup (pubspec.yaml with all dependencies)
- [x] Theme system (light/dark, colors, typography, `AppThemeExtension`, `context.appTheme`)
- [x] Router (GoRouter with all routes; `static final` to prevent recreation on rebuild)
- [x] State management (Riverpod providers for settings, user, course, posts, locale)
- [x] Models (UserProfile, Course, Section, Lesson, Exercise, Post, Comment, Achievement, Character)
- [x] **Multi-language demo courses** (7 target languages: EN, KO, JA, FR, ES, ZH, DE) — each with 3 sections, 10 lessons, custom exercises using native vocabulary/grammar. Course metadata now includes Traditional Chinese (`zh_TW`) translations in addition to Simplified Chinese (`zh`)
- [x] **Multi-language Chill Corner posts** — language-specific AI persona content that teaches vocabulary *in* the target language (e.g., Korean posts teach Korean words like 매워요 and 사랑; French posts teach French words like bonjour and amour). `postsForLanguage` returns only the matching language set, no English mixing. Reactive via `PostsNotifier` `ref.listen` on `learningLanguage`.
- [x] Offline mode (`SharedPreferences` persistence for course progress and user data via `OfflineService`)
- [x] Network detection (`connectivity_plus`)
- [x] Responsive layout (`flutter_screenutil`, tablet breakpoints)
- [x] RTL support (`locale_provider.dart` + `Directionality` wrapper)
- [x] Skeleton / shimmer loading states (Learn, Chill, Lesson screens via `Skeleton` widget)
- [x] Professional animations (`FadeSlide`, `ScaleBounce`, `Shake`, `Pulse`, `StaggerList`, `Shimmer`)
- [x] Micro-interactions (haptic feedback on all interactive elements)
- [x] **Full UI Localization** — **8 ARB files** (EN, ZH, ZH_TW, KO, JA, ES, FR, DE) with **350 keys each** (2,800 total ARB entries) covering every UI string in the app. All 38 screen/widget files use `l10n.<key>` instead of hardcoded English. Categories include: core navigation, onboarding (language/proficiency/motivation/commitment labels), course metadata (`sections`, `chapter`, `section`), exercise instructions (`tapWordsToBuildAnswer`, `clearAll`, `typeYourAnswerHere`, etc.), lesson completion (`lessonCompletePerfect`, `wordsPracticed`), flashcard review (`flashcardHard`, `flashcardGood`, `flashcardEasy`), profile screens (`profile_appearance`, `profile_unlockFullExperience`, `profile_superTitle`, etc.), chill corner (`chill_share`, `chill_comments`), force update (`forceUpdateBody`, `updateNow`), splash tagline (`appTagline`), time formatting (`timeAgoMinutes`, `timeAgoHours`, `timeSpentHoursMinutes`), speakers count (`speakersCount`), default display name (`defaultDisplayName`), streak calendar (`streakKeepStreak`, `streakShielded`, `streakRepaired`, `streakShieldsRemaining`, `streakRepair`), and reminder time (`reminderTime`)
- [x] Custom animated loaders (`LottieLoader` — rotating dot ring via `CustomPaint`; `RocketLoader` — bouncing rocket with flame particles)
- [x] **Real Lottie animations** — 3 Lottie JSON files downloaded (rocket, points_completed, daily_points) integrated via `Lottie.asset()`
- [x] **Bilingual instruction/content separation** — `Exercise` model has `instruction`, `instructionLang`, `contentLang` fields; all 35 demo exercises now populate these fields (e.g., Chinese instructions for English/Korean/Japanese/French/Spanish/German content; English instructions for Chinese content)
- [x] **Streak freeze + repair system** — `StreakRecord` enum with `completed`, `missed`, `shielded`, `todayPending`, `repaired` states; shield badge on calendar; repair button; urgency banner for pending streaks
- [x] **Onboarding data persistence** — `OnboardingData` provider accumulates native language, learning language, proficiency, motivation, and daily goal selections across all 6 onboarding screens; flushed to `UserProfile` on account creation
- [x] **End-to-end language switching** — native language changes update app locale (`LocaleNotifier`) and `UserProfile`; learning language changes update `UserProfile` and reload course content (`CourseNotifier.switchLanguage()`)
- [x] **Settings language changers** — working bottom-sheet pickers for native language, learning language, and daily goal in Settings screen
- [x] **Edit profile editable fields** — learning language, proficiency level, and daily goal are now tappable and open bottom-sheet pickers
- [x] **All routes reachable** — `/paywall` linked from Super and Subscription screens; `/force-update` linked from Settings; `/vocabulary-review` linked from Post-Learning; zero orphan screens
- [x] **`PointsConfig` (Busuu-style)** — centralized `unitWorth`, `activityWorth`, `smartReviewWorth`, `checkpointWorth`, `correctionWorth`, `streakFreezeCost`, `streakShieldCost`, and `starsFor()` helper. Replaces hardcoded 10 XP / 5 gems scattered across demo data and lesson completion
- [x] **Auto-reactive providers** — `CourseNotifier` and `PostsNotifier` use `ref.listen(userProvider.select((u) => u.learningLanguage), ...)` so course and Chill Corner content reload automatically when the user changes target language. No more manual `switchLanguage()` calls scattered in UI code
- [x] **Vocabulary-gated Chill Corner** — `Lesson.vocabulary` tracks words taught per lesson. `completeLesson()` extracts vocab and calls `addLearnedWords()`. `PostsNotifier._filterPosts()` gates Chill Corner so users only see posts whose `requiredWords` they've learned. Newly completed lessons unlock matching posts in real time via `ref.listen` on `learnedWords`
- [x] **`UserProfile.learnedWords`** — `Set<String>` that accumulates all vocabulary words the user has learned across every lesson. Persisted via `OfflineService`. Enables progress-based content unlocking
- [x] **`Post.requiredWords` / `requiredLessonIds`** — prerequisite metadata on every Chill Corner post. Posts are invisible until the user knows the prerequisite vocabulary or has completed the required lessons
- [x] **Translation pipeline tool** — `tools/translation_pipeline.py` exports all 2,850+ translatable strings (ARB UI + post content + exercise content) into structured JSON. Supports translation-memory caching, differential export, and programmatic import. Scales to thousands of content items
- [x] **`LanguageService`** — single source of truth for language changes. `setNativeLanguage()` updates locale + user profile in one transaction. `setLearningLanguage()` updates user profile; course/posts auto-react. Replaces scattered provider calls in Settings, Edit Profile, and Account Creation
- [x] **Lesson completion reward pipeline** — `LessonScreen` now calls `addXp()`, `addGems()`, and `incrementStreak()` before navigating to `LessonCompleteScreen`. Previously defined in `UserNotifier` but never invoked
- [x] **Localized greeting strings** — `greetingMorning`, `greetingAfternoon`, `greetingEvening`, `readyToLearn` added to all 8 ARB files and wired into `LearnScreen._TopBar`
- [x] **`LocalizedText` model** — course/section/lesson metadata uses `LocalizedText({'en': ..., 'zh': ...})` so titles and descriptions display in the user's native language. **All learning content fields migrated**: `Post.wordTranslation`, `wordExplanation`, `wordExampleTranslation`; `Exercise.explanation`, `grammarRule`, `grammarExample`, `writingPrompt`, `sampleAnswer`; `ExampleSentence.translation`. Every field has 8-language entries (en, zh, zh_TW, ko, ja, fr, es, de)
- [x] **Course metadata Chinese translations** — all 7 courses, 21 sections, 70 lessons have Chinese translations for titles and descriptions
- [x] **Complete string audit** — every screen and widget file audited for hardcoded English UI strings. All 58 Dart files scanned with 3 different detection techniques. **350 ARB keys per language**. Zero user-facing English UI strings remain outside of: (a) actual language proper names in picker lists, (b) demo user names (`Sophie`, `Kenji`, etc.), (c) English learning content
- [x] **Non-English Chill Corner post rewrites** — 6 posts per language (36 total non-English) teaching actual target-language vocabulary. Korean teaches `매운`, `사랑`, `친구`, `바다`, `행복`, `꿈`; Japanese teaches `桜`, `美味しい`, `猫`, `本`, `沖縄`, `友達`; French teaches `bonjour`, `amour`, `fromage`, `lumière`, `musique`, `voyage`; Spanish teaches `hola`, `amigo`, `familia`, `sol`, `música`, `libre`; Chinese teaches `茶`, `爱`, `你好`, `书`, `山`, `家`; German teaches `Brot`, `Freund`, `Hallo`, `Musik`, `Reise`, `Liebe`
- [x] **End-to-end verification script** — `tools/verify_e2e.py` runs 7 automated checks: (1) all 70 lessons have non-empty vocabulary, (2) all 42 post `requiredWords` exist in lesson vocabulary, (3) all `LocalizedText` objects have all 8 languages, (4) no raw strings in translatable fields, (5) UI screens use `.get()` for `LocalizedText`, (6) no emojis in learning content, (7) provider logic correctly wires `vocabulary → learnedWords → post filtering`

### Screens & Flows
- [x] Splash screen (animated logo, routes to `/learn` or `/onboarding` based on completion state)
- [x] Onboarding flow (7 steps: welcome, native language, learning language, proficiency, motivation, commitment, account creation) — all selections persist via `OnboardingData` provider and flush to `UserProfile` on completion
- [x] Onboarding custom transitions (slide + fade via `PageRouteBuilder`)
- [x] Placement Test (`/placement-test`) — 5 adaptive questions with level result dialog
- [x] Learn tab (course path, daily goal card with ring progress, continue learning card, lesson nodes)
- [x] Lesson Player with all exercise types:
  - [x] vocabularyMultipleChoice
  - [x] fillInBlank (with word bank)
  - [x] translateSentence
  - [x] matchPairs
  - [x] grammarTip
  - [x] wordSorting / reorder (drag-and-drop word chips)
  - [x] dialogueComplete (alternating speaker bubbles)
  - [x] imageIdentification (2x2 image grid)
  - [x] listenAndType (simulated audio button + text input)
  - [x] speaking (simulated waveform visualization + record button)
  - [x] **flashCard** — flip animation with 3D rotation (rotateY via Transform)
  - [x] **comprehensionText** — reading passage + multiple choice questions
  - [x] **grammarTrueFalse** — True/False statement evaluation with large buttons
  - [x] **phraseBuilderPrefilled** — sentence builder with pre-filled hint words
  - [x] **writing** — free-text input with sample answer feedback
- [x] Lesson complete screen (confetti, star rating, XP/Gems rewards, circular progress ring)
- [x] Post-Learning Activity screen (`/post-learning`) — review, practice, continue, chill corner options
- [x] Vocabulary Flashcards / Review (`/vocabulary-review`) — flip animation, spaced-repetition buttons (Hard/Good/Easy), progress bar
- [x] Chill Corner (Instagram-style feed, shimmer skeleton loading, word highlight cards, like/comment/share)
- [x] Post detail (word card with phonetic, translation, explanation, example, comments)
- [x] AI Conversation / Roleplay (`/ai-conversation`) — scenario banner, message bubbles, typing indicator, quick replies
- [x] Profile tab (stats, menu sections, achievements, friends, course, settings, subscription, Super, study plan)
- [x] Edit Profile (`/profile/edit`) — name, email, avatar, learning language, proficiency, daily goal
- [x] Help & Support (`/profile/help`) — FAQ sections, contact support, help center links
- [x] Settings screen (dark mode, sound, notifications, reminders, daily goal, account, reset progress, log out)
- [x] Force Update screen (`/force-update`) — animated download icon, feature list, store redirect
- [x] Statistics screen (weekly XP bar chart, stat boxes, time spent)
- [x] Streak Calendar widget (integrated into `stats_screen.dart`)
- [x] Achievements screen (tier badges, progress bars, unlocked/locked states)
- [x] Friends screen (tabs: Friends, Leaderboard, Following) — distinct localized tab labels; previously all showed the same "Friends" label
- [x] Course screen (progress overview, section list)
- [x] Subscription screen (monthly/annual plans, feature list)
- [x] Paywall Modal (`/paywall`) — monthly/annual/trial toggles, feature list, discount badge
- [x] Super screen (premium features showcase)
- [x] Study Plan wizard (5-step goal/level/schedule/intensity/duration configurator)
- [x] Grammar Tip Overlay widget (triggered from lesson app bar info button)
- [x] Error states widget (generic, empty, offline, loading states)

## Known Missing / To Be Implemented

### Backend & Auth
- [ ] Firebase/Supabase integration for real auth
- [ ] Social login (Google, Apple, email/password)
- [ ] Real user data persistence (Firestore/Supabase)
- [ ] Backend API for courses, lessons, posts

### Content & Assets
- [x] ~~Real Lottie animation files~~ **Done** — 3 free LottieFiles animations (rocket, points_completed, daily_points) downloaded and integrated via `Lottie.asset()`
- [ ] Real AI-generated images for Chill Corner posts
- [ ] Audio/TTS for vocabulary pronunciation (`audioplayers` package included)
- [ ] Additional vocabulary beyond A1 level
- [ ] Real grammar tip database
- [ ] Real image assets (`assets/images/`, `assets/icons/`, `assets/flags/` exist but are empty)
- [ ] Real fonts (`assets/fonts/Inter-*.ttf` referenced but missing)

### AI Integration
- [ ] Real AI persona comment generation (currently hardcoded demo replies)
- [ ] Real AI conversation backend (currently simulated responses with 1.5s delay)
- [ ] Speaking feedback with waveform analysis (UI exists, backend missing)
- [ ] Agentic coach for personalized guidance

### Gamification
- [x] ~~Streak freeze + repair mechanics~~ **Done** — `StreakRecord` enum with 5 states (completed, missed, shielded, todayPending, repaired); shield badges; repair button; urgency banner
- [ ] Leaderboards and leagues
- [ ] Weekly challenges
- [ ] Certificates upon course completion
- [ ] XP decay mechanics

### Monetization
- [ ] In-app purchase integration (RevenueCat)
- [ ] Real subscription management

### Technical
- [ ] Unit/widget tests
- [ ] Integration tests
- [ ] CI/CD pipeline
- [ ] App Store / Play Store submission assets
- [ ] Push notification service
- [ ] Analytics (Firebase Analytics, Mixpanel)
- [ ] Crashlytics / error tracking
