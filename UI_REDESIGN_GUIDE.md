# InstaLingo — Comprehensive UI Redesign Guide

## Design Brief — For AI UI Designers

**Project:** InstaLingo Flutter — A language learning app with social features (Duolingo meets Instagram).
**Deliverable:** Complete Figma design file with 32 screens, 6 reusable widgets, and a unified design system.
**Platform:** iOS primary, Android compatible. Base frame size: 390×844 (iPhone 14 Pro). Must include dark mode variants.
**Goal:** Redesign every screen and reusable widget while preserving ALL functionality. You have complete creative freedom over colors, typography, spacing, shapes, and visual style. The only constraints are structural — what data each screen needs, what interactions it supports, and how navigation flows.

### Your Workflow (follow in this order)

1. **Read the App Architecture section** to understand data flow, state management, and navigation.
2. **Create a Design System first.** Before designing any screen, establish:
   - **Color palette:** Primary, secondary, accent, success, error, warning, background, surface, text (primary/secondary/disabled), gamification colors (XP blue, streak red, gems pink, gold). Provide light and dark variants.
   - **Typography scale:** Display (large titles), headline (section headers), title (card titles), body (paragraphs), label (captions, badges), button text. Specify font family, sizes, weights, line heights.
   - **Spacing system:** Grid base (e.g., 4dp or 8dp), page margins (24dp), card padding (16dp), section gaps (12–32dp), button heights (44–56dp), input heights (56dp), icon container sizes (40–64dp).
   - **Shape system:** Border radii for cards (16–24dp), buttons (12–16dp), pills (20dp), avatars (full circle), inputs (16dp).
   - **Shadow/elevation:** Card shadows, modal shadows, focused input shadows.
   - **Icon system:** Map every Phosphor icon in the functional spec to a specific Phosphor icon name. Use `PhosphorIconsStyle.fill` for active/selected states and `PhosphorIconsStyle.regular` for inactive states.
   - **Component library:** Button variants (primary, secondary, outlined, ghost, icon-only), input fields, cards (lesson card, post card, stat card, menu row), avatars, badges, progress indicators, toggle switches, tab bars, bottom nav items, app bars, skeleton placeholders, empty states, error states.
3. **Design all 32 screens** using the design system. Each screen must be a Figma frame named after its route (e.g., `/learn`, `/lesson/:id`, `/profile/stats`).
4. **Design all 6 widget components** as reusable Figma components with variants (e.g., `Button/Primary/Default`, `Button/Primary/Pressed`, `Card/Post/Default`, `Card/Post/Liked`).
5. **Create a prototype flow** linking the main user journeys: Splash → Onboarding → Learn → Lesson → Complete → Post-Learning → Chill → Profile.

### What You Must Preserve (Functional Contract)
- Every provider read/write must remain
- Every navigation route must remain
- Every user interaction must trigger the same state changes
- Every model field displayed must remain
- Every animation type (entrance, loading, celebration, feedback) must remain
- Every localized text string reference must remain (do not hardcode text)

### What You Can Change Completely (Creative Freedom)
- Colors, fonts, shapes, borders, shadows, gradients
- Layout arrangement (within structural constraints noted per screen)
- Icon choices (as long as Phosphor icon semantics map correctly)
- Spacing, sizing, padding, margins
- Card styles, button styles, input styles
- Background patterns, illustrations, decorative elements
- Motion curves, durations, stagger patterns
- Empty state and error state illustrations
- Skeleton placeholder styling

### Figma-Specific Requirements
- Use **Auto Layout** for all screens and components so resizing works correctly.
- Use **Figma variables** for colors and spacing tokens (light/dark mode support).
- Name every layer descriptively (e.g., `Card/Post/Header/Avatar`, `Button/Primary/Label`).
- Group related screens into Figma pages: `Splash & Shell`, `Onboarding`, `Learn`, `Chill`, `Profile`, `Modals`, `Components`, `Design System`.
- Include **interaction annotations** as Figma comments on each screen: what tappable elements do, what state changes occur, what route they navigate to.
- For every screen, create **light mode** and **dark mode** variants (use Figma variable modes).
- For the **Bottom Navigation Bar**, create a component with 3 variants: Learn (active), Chill (inactive), Profile (inactive), and show state changes.
- For **exercise types** in Lesson Screen, create a component set showing at least 3 exercise variants (e.g., Multiple Choice, Fill in Blank, Match Pairs).
- Include **loading states** for screens that show skeletons: Chill feed skeleton, Lesson skeleton.
- Include **success/celebration states**: Lesson Complete (confetti, stars, XP), Post-Learning (trophy, rewards).
- Include **error states**: ErrorState widget (full screen), empty states for Chill feed, Friends list, Achievements.

### Output Format
Deliver a single Figma file containing:
1. **Design System page** — Colors, typography, spacing, shadows, iconography
2. **Components page** — All reusable components with variants
3. **Splash & Shell page** — SplashScreen, MainShell (with bottom nav)
4. **Onboarding page** — OnboardingScreen, WelcomeScreen, NativeLanguage, LearningLanguage, Proficiency, Motivation, Commitment, AccountCreation, PlacementTest
5. **Learn page** — LearnScreen, LessonScreen, LessonComplete, PostLearning, VocabularyReview
6. **Chill page** — ChillScreen, PostDetail
7. **Profile page** — ProfileScreen, EditProfile, Settings, Stats, Achievements, Course, StudyPlan, Friends, Subscription, Super, HelpSupport
8. **Modals page** — ForceUpdate, PaywallModal
9. **AI Conversation page** — AiConversationScreen
10. **Prototype** — Interactive flow covering: Splash → Onboarding → Learn → Lesson → Complete → Profile → Settings

---

## Table of Contents

1. [Design Brief](#design-brief--for-ai-ui-designers)
2. [App Architecture](#app-architecture)
3. [Navigation Map](#navigation-map)
4. [Data Model Quick Reference](#data-model-quick-reference)
5. [Screen Inventory](#screen-inventory)
   - Splash & Shell
   - Onboarding Flow
   - Learn Tab
   - Chill Tab
   - Profile Tab & Subscreens
   - Modals & Overlays
   - AI Conversation
6. [Widget Inventory](#widget-inventory)
7. [Reconstruction Contract](#reconstruction-contract)
8. [Asset Requirements](#asset-requirements)
9. [Design Deliverables Checklist](#design-deliverables-checklist)

---

## App Architecture

### State Management
The app uses **Riverpod** (flutter_riverpod). Every screen that reads or writes state uses either `ConsumerWidget` or `ConsumerStatefulWidget`.

Key providers:
- `userProvider` — `UserProfile` (displayName, email, avatar, streak, XP, gems, learningLanguage, nativeLanguage, dailyGoal, motivations, learnedWords)
- `courseProvider` — `Course` with sections/lessons/exercises, completion state, locks
- `postsProvider` — List of `Post` objects filtered by learned vocabulary
- `settingsProvider` — darkMode, soundEnabled, notifications, reminderTime
- `localeProvider` — App locale (language code)
- `onboardingDataProvider` — Accumulates onboarding selections before account creation

### Navigation
GoRouter with declarative routes. Bottom nav has 3 tabs: Learn (`/learn`), Chill (`/chill`), Profile (`/profile`). All other routes are push routes that slide in from the right.

### Localization
All user-facing strings come from `AppLocalizations.of(context)!` (ARB-generated). There are ~350 keys per language. You do NOT need to worry about text content — just layout containers that hold localized text.

### Responsive Design
All screens use `flutter_screenutil` with designSize `390×844` (iPhone 14 Pro). Sizes use `.w` (width factor), `.h` (height factor), `.sp` (font scale), `.r` (radius). You can redesign with any sizing system as long as the reconstruction agent can map it.

---

## Navigation Map

```
/                           → redirects based on onboarding state
  /splash                   → auto-navigates to /learn or /onboarding after 2.8s
  /onboarding               → onboarding landing page (app icon + Get Started / Already Have Account)
    /welcome                → feature cards + continue / placement test buttons
    /native-language        → single-select language list
    /learning-language      → single-select target language list
    /proficiency            → single-select CEFR level (A1-C2)
    /motivation             → multi-select motivation grid
    /commitment             → single-select daily time commitment
    /account                → name/email form, creates account
  /placement-test           → 5 adaptive questions with progress bar
  /learn                    → Main Learn tab (course path, daily goal, streak)
    /lesson/:id             → Exercise player (15 exercise types)
    /lesson-complete        → Celebration screen (confetti, XP, stars)
    /post-learning          → Post-lesson review screen
    /vocabulary-review      → Flashcard-style vocabulary review
  /chill                    → Main Chill tab (social feed)
    /post/:id               → Individual post detail with comments
  /profile                  → Main Profile tab
    /edit-profile           → Name/email editing, avatar, language pickers
    /settings               → Dark mode, sound, notifications, language
    /stats                  → Weekly XP bar chart, stat grid, streak calendar
    /achievements           → Achievement list with tier badges and progress bars
    /course                 → Course overview with section/lesson list
    /study-plan             → 5-step study plan wizard (goal, level, schedule, intensity, duration)
    /friends                → Social screen: Friends, Leaderboard, Following tabs
    /subscription           → Monthly/Annual plan selection with feature lists
    /super                  → Premium feature showcase
    /help                   → FAQ and support links
  /ai-conversation          → Chat interface with AI persona
  /force-update             → Mandatory update screen (blocking)
  /paywall                  → Subscription bottom sheet modal
```

**Bottom Navigation (3 tabs):**
- Tab 0: Learn (`/learn`) — `bookOpen` icon
- Tab 1: Chill (`/chill`) — `snowflake` icon
- Tab 2: Profile (`/profile`) — `user` icon

---

## Data Model Quick Reference

### UserProfile
```dart
class UserProfile {
  String id, displayName, email;
  String avatarUrl; // nullable
  String nativeLanguage; // 'en', 'zh', 'ko', etc.
  String learningLanguage; // target language code
  String proficiencyLevel; // 'A1' through 'C2'
  int dailyGoal; // minutes per day
  List<String> motivations; // e.g., ['work', 'travel']
  int xp, gems, streak;
  List<DateTime> activeDays; // for streak calendar
  int streakShields;
  DateTime? lastActiveDate;
  Set<String> learnedWords; // vocabulary tracking
  List<String> unlockedAchievements;
}
```

### Course / Section / Lesson
```dart
class Course {
  String id, title, subtitle, level, language;
  int totalLessons, completedLessons;
  List<Section> sections;
}
class Section {
  String id, title;
  int order;
  bool isLocked;
  List<Lesson> lessons;
}
class Lesson {
  String id;
  LocalizedText title, description;
  int order, xpReward, gemsReward;
  List<Exercise> exercises;
  bool isCompleted, isLocked, isCurrent;
  List<String> vocabulary; // words taught in this lesson
}
```

### Exercise (15 types)
```dart
class Exercise {
  String id;
  ExerciseType type; // vocabularyMultipleChoice, fillInBlank, translateSentence, matchPairs, listenAndType, speaking, dialogueComplete, grammarTip, wordSorting, imageIdentification, flashCard, comprehensionText, grammarTrueFalse, phraseBuilderPrefilled, writing
  String instruction, question;
  List<String> options;
  String correctAnswer;
  LocalizedText explanation; // shown after answering
  LocalizedText? grammarRule, grammarExample; // for grammarTip type
  List<WordPair> pairs; // for matchPairs
  String? passage; // for comprehensionText
  List<String>? correctAnswerList; // for wordSorting
  String? writingPrompt, sampleAnswer; // for writing type
}
```

### Post (Chill Corner)
```dart
class Post {
  String id, authorName, authorHandle;
  String? authorAvatarUrl, imageUrl;
  String content;
  String? targetWord; // vocabulary word being taught
  LocalizedText? wordTranslation, wordExplanation, wordExampleTranslation;
  String? wordPhonetic, wordExample;
  DateTime createdAt;
  int likes;
  bool isLiked, isBookmarked;
  List<String> tags, requiredWords;
  String? location, characterType, characterBio;
  List<PostComment> comments;
}
```

### Achievement
```dart
class Achievement {
  String id, title, description;
  String iconName; // Phosphor icon identifier
  int tier; // 1-3
  int currentProgress, requiredProgress;
  bool isUnlocked;
  DateTime? unlockedAt;
}
```

---

## Screen Inventory

For every screen below, the following fields are documented:
- **File Path:** Where the Dart file lives
- **Route:** GoRouter path
- **Purpose:** What this screen does
- **Data Consumed:** Which providers/models it reads/writes
- **Navigation:** How user arrives and leaves
- **Interactive Elements:** Every tappable/scrollable/input element and its function
- **State Changes:** What provider methods are called on interaction
- **Layout Requirements:** Structural layout only (not style). Scrollable vs fixed, lists vs grids, overlays, modals, top/bottom bars.
- **Special Requirements:** Animations, transitions, haptics, deep links

---

### CATEGORY: Splash & Shell

#### 1. Splash Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/splash_screen.dart` |
| **Route** | `/splash` (initial route, auto-navigates) |
| **Purpose** | App launch branding screen. Checks onboarding completion and routes to Learn or Onboarding after 2.8 seconds. |
| **Data Consumed** | `sharedPrefsProvider` → reads `onboarding_complete` boolean |
| **Navigation** | Auto-routes to `/learn` (if onboarding done) or `/onboarding` (if first launch). No user interaction required. |
| **Interactive Elements** | None. Purely presentational with timed navigation. |
| **State Changes** | Reads SharedPreferences. No provider writes. Triggers medium haptic feedback before navigation. |
| **Layout Requirements** | **Full-screen Stack layout.** Bottom layer: 6 floating particles drifting upward at staggered delays. Center: Logo icon inside a rounded square container with shadow. Below logo: App title text. Below title: Tagline text. Bottom: Circular progress indicator. All elements must support entrance animations. |
| **Special Requirements** | **Entrance animations required:** Logo scales 0.6→1.0 with slight rotation correction (-0.15→0 turns). Title and tagline fade+slide up with staggered delays. Particles float continuously. Must check `mounted` before navigation. |

#### 2. Main Shell

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/main_shell.dart` |
| **Route** | Wraps `/learn`, `/chill`, `/profile` |
| **Purpose** | Root navigation wrapper with persistent bottom tab bar. Determines active tab from current GoRouter path. |
| **Data Consumed** | `GoRouterState.of(context).uri.path` for active tab detection. `AppLocalizations` for tab labels. |
| **Navigation** | Child routes displayed in body. Bottom nav items route to `/learn`, `/chill`, `/profile`. |
| **Interactive Elements** | **3 bottom nav items** (Learn, Chill, Profile). Each has an icon + label stacked vertically. Active item uses filled icon variant + bold label. Inactive uses outline icon + regular label. Entire item area is tappable. |
| **State Changes** | No provider writes. Pure route navigation via `context.go()`. |
| **Layout Requirements** | **Scaffold with bottomNavigationBar.** Body displays the child route widget. Bottom bar is a custom container (not Material BottomNavigationBar) — it uses a Row of 3 equally-spaced tappable column items. Each item: icon above, 2dp gap, label below. Bar must respect SafeArea (notch/home indicator). |
| **Special Requirements** | No state management. Route-driven active state only. Responsive sizing. |

---

### CATEGORY: Onboarding Flow

#### 3. Onboarding Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/onboarding/onboarding_screen.dart` |
| **Route** | `/onboarding` |
| **Purpose** | Onboarding landing page. Shows app branding and offers entry points to the onboarding flow or existing account sign-in. |
| **Data Consumed** | `AppLocalizations` for title, subtitle, button text. No provider reads. |
| **Navigation** | Arrives from `/splash` (first launch). "Get Started" button pushes `/onboarding/welcome`. "I Already Have Account" button goes `/learn`. |
| **Interactive Elements** | **App icon** (100x100 dp container, 28.r radius, primary 10% alpha background, `globeHemisphereEast fill` icon, 48.sp, primary color). **App title** "InstaLingo" (`displayLarge`, 32.sp, primary color). **Subtitle** (`bodyLarge`, 50% alpha, centered, line height 1.5). **"Get Started" button** (full width, 44.h, 16.sp bold, elevated) pushes `/onboarding/welcome`. **"I Already Have Account" button** (full width, 44.h, 14.sp semi-bold, outlined) goes `/learn`. |
| **State Changes** | None. |
| **Layout Requirements** | **Scaffold with SafeArea.** Centered `SingleChildScrollView`. Column: app icon (24.h gap), title (8.h gap), subtitle (36.h gap), Get Started button (10.h gap), Already Have Account button. Padding: 24.w horizontal, 24.h vertical. All content centered. |
| **Special Requirements** | **Entrance animation**: FadeTransition + SlideTransition (slide from y=0.1 to 0), 1200ms, `Curves.easeOut` / `Curves.easeOutCubic`. No back navigation from this screen (it is the entry point). |

#### 4. Welcome Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/onboarding/welcome_screen.dart` |
| **Route** | `/onboarding/welcome` |
| **Purpose** | First onboarding screen. Introduces the app with feature highlights and offers two entry paths: continue onboarding or skip to placement test. |
| **Data Consumed** | `AppLocalizations` for all text content. |
| **Navigation** | Arrives from `/splash`. **Continue button** → `/onboarding/native-language`. **Placement test button** → `/placement-test`. Back button → pops (exits app). |
| **Interactive Elements** | **3 feature cards** (stacked vertically): each has an icon, title, and description. Tappable for visual feedback but no action. **"Continue" button** (full width): routes to native language screen. **"Take Placement Test" button** (full width, secondary style): routes to placement test. **Back button** (app bar): exits onboarding. |
| **State Changes** | None. Pure navigation. |
| **Layout Requirements** | **Scrollable Column.** Top: Screen title + subtitle. Middle: 3 feature cards stacked vertically with gap. Each card: icon in rounded square container (left), title + description (right, expanded). Bottom: 2 full-width buttons stacked with gap. Horizontal padding: 24dp. Bottom safe area padding. |
| **Special Requirements** | Feature cards should feel substantial (not just text). Placement test button must be visually secondary to Continue. |

#### 5. Native Language Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/onboarding/native_language_screen.dart` |
| **Route** | `/onboarding/native-language` |
| **Purpose** | User selects their native language from a list. This determines the app's UI language. |
| **Data Consumed** | `onboardingDataProvider` (writes). `localeProvider` (writes). Hardcoded list of 9 languages with codes, names, and flag emojis. |
| **Navigation** | Arrives from `/onboarding/welcome`. Continue button → `/onboarding/learning-language`. Back → `/onboarding/welcome`. |
| **Interactive Elements** | **Language list** (9 items, scrollable): Each item shows flag emoji, language name. Tapping selects one item (deselects others). Selected state must be visually distinct. **Continue button** (full width, bottom): enabled only when a language is selected. **Back button** (app bar). |
| **State Changes** | On Continue: `onboardingDataProvider.setNativeLanguage(code)` + `localeProvider.setLocale(code)`. |
| **Layout Requirements** | **Fixed header + scrollable list + fixed footer.** Top: Title + subtitle. Middle: ListView of language tiles. Each tile: flag container (40×40 dp rounded square) + language name (expanded) + checkmark icon (visible only when selected). Bottom: Continue button. |
| **Special Requirements** | Single-select only. Continue button disabled until selection made. Flag display uses emoji (not images). |

#### 6. Learning Language Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/onboarding/learning_language_screen.dart` |
| **Route** | `/onboarding/learning-language` |
| **Purpose** | User selects the language they want to learn. This determines course content. |
| **Data Consumed** | `onboardingDataProvider` (writes). Hardcoded list of 6 languages with speaker counts. |
| **Navigation** | Arrives from `/onboarding/native-language`. Continue → `/onboarding/proficiency`. Back → `/onboarding/native-language`. |
| **Interactive Elements** | **Language list** (6 items): Same pattern as Native Language screen, but each item also shows speaker count below the language name. **Continue button** (full width, bottom). **Back button** (app bar). |
| **State Changes** | On Continue: `onboardingDataProvider.setLearningLanguage(code)`. |
| **Layout Requirements** | Same structural layout as Native Language screen: fixed header + scrollable list + fixed footer. Tiles show: flag container + language name + speaker count (below name) + checkmark. |
| **Special Requirements** | Single-select. Speaker count displayed as secondary text. |

#### 7. Proficiency Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/onboarding/proficiency_screen.dart` |
| **Route** | `/onboarding/proficiency` |
| **Purpose** | User selects their CEFR proficiency level (A1 beginner through C2 proficient). |
| **Data Consumed** | `onboardingDataProvider` (writes). 6 levels with localized names and descriptions. |
| **Navigation** | Arrives from `/onboarding/learning-language`. Continue → `/onboarding/motivation`. Back → `/onboarding/learning-language`. |
| **Interactive Elements** | **Level list** (6 items, scrollable): Each item shows level code badge (A1, A2, etc.), level name, and description. Tapping selects one. **Continue button** (full width, bottom). **Back button** (app bar). |
| **State Changes** | On Continue: `onboardingDataProvider.setProficiencyLevel(code)`. |
| **Layout Requirements** | Fixed header + scrollable list + fixed footer. Each tile: level code badge (48×48 dp, rounded square) + level name + description (secondary text) + checkmark. |
| **Special Requirements** | Single-select. Level codes are prominent (A1, A2, B1, B2, C1, C2). |

#### 8. Motivation Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/onboarding/motivation_screen.dart` |
| **Route** | `/onboarding/motivation` |
| **Purpose** | User selects multiple motivations for learning (career, travel, study abroad, culture, family, fun, brain training, movies). |
| **Data Consumed** | `onboardingDataProvider` (writes). 8 motivation options with icons and labels. |
| **Navigation** | Arrives from `/onboarding/proficiency`. Continue → `/onboarding/commitment`. Back → `/onboarding/proficiency`. |
| **Interactive Elements** | **Motivation grid** (8 items in 2-column grid): Each card has an icon and label. Tapping toggles selection. Multiple items can be selected simultaneously. Selected state must be visually distinct from unselected. **Continue button** (full width, bottom): enabled when at least one item selected. **Back button** (app bar). |
| **State Changes** | On Continue: `onboardingDataProvider.setMotivations(selectedIds)`. |
| **Layout Requirements** | Fixed header + scrollable grid + fixed footer. Grid: 2 columns, aspect ratio ~1.6. Each card: icon (top) + label (bottom). Cards can wrap to multiple lines if needed. Bottom: Continue button. |
| **Special Requirements** | Multi-select. Continue requires at least 1 selection. Grid layout preferred over list for visual density. |

#### 9. Commitment Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/onboarding/commitment_screen.dart` |
| **Route** | `/onboarding/commitment` |
| **Purpose** | User selects their daily learning commitment in minutes (5, 10, 15, or 20 min/day). |
| **Data Consumed** | `onboardingDataProvider` (writes). 4 options with labels and minute counts. |
| **Navigation** | Arrives from `/onboarding/motivation`. Continue → `/onboarding/account`. Back → `/onboarding/motivation`. |
| **Interactive Elements** | **Commitment list** (4 items): Each item shows clock icon, label, and minute count. Tapping selects one. **Continue button** (full width, bottom). **Back button** (app bar). |
| **State Changes** | On Continue: `onboardingDataProvider.setDailyGoal(minutes)`. |
| **Layout Requirements** | Fixed header + scrollable list + fixed footer. Each tile: icon container (48×48 dp) + label + subtitle (minute count) + checkmark. |
| **Special Requirements** | Single-select. This sets the daily goal that appears on the Learn screen. |

#### 10. Account Creation Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/onboarding/account_creation_screen.dart` |
| **Route** | `/onboarding/account` |
| **Purpose** | Final onboarding step. User enters display name and optional email, then account is created and onboarding data is flushed to UserProfile. |
| **Data Consumed** | `onboardingDataProvider` (reads all accumulated data + resets). `userProvider` (writes profile). `settingsProvider` (writes onboarding_complete). `LanguageService` (sets native + learning language). |
| **Navigation** | Arrives from `/onboarding/commitment`. **Get Started** or **Skip** → `/learn` (replaces entire stack). Back → `/onboarding/commitment`. |
| **Interactive Elements** | **Avatar placeholder** (center, 100×100 dp circle): Shows user icon. Tappable to change avatar (placeholder for future). **Name text field**: Required. **Email text field**: Optional. **"Get Started" button** (full width): Creates account, shows loading spinner while processing. **"Skip for now" text button**: Creates account with defaults, skips name/email. |
| **State Changes** | On submit: reads all onboarding data, calls `userProvider.updateProfile()` with displayName, email, proficiency, dailyGoal, motivations. Calls `LanguageService.setNativeLanguage()` and `setLearningLanguage()`. Calls `onboardingCompleteProvider.complete()`. Clears `onboardingDataProvider`. |
| **Layout Requirements** | **Scrollable column.** Center: avatar placeholder. Below: name field. Below: email field. Bottom: primary button + secondary text button. Horizontal padding: 24dp. |
| **Special Requirements** | Loading state on button (spinner replaces text). Skip button must still create a valid account with default values. Name field is required (button disabled if empty). |

#### 11. Placement Test Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/onboarding/placement_test_screen.dart` |
| **Route** | `/placement-test` |
| **Purpose** | Optional 5-question adaptive test that estimates user's proficiency level. Can be accessed from Welcome screen or skipped entirely. |
| **Data Consumed** | Hardcoded 5 questions with options and correct answers. |
| **Navigation** | Arrives from `/onboarding/welcome`. Completing the test shows a result dialog. User can then proceed to onboarding or skip to main app. Back → `/onboarding/welcome`. |
| **Interactive Elements** | **Progress bar** (app bar title area): Shows question progress (1/5 to 5/5). **Question text** (top of body). **Option list** (4 items per question): Tapping selects one option. Options become non-tappable after selection. **Check button** (bottom): Appears after selecting an answer. Checks correctness and shows feedback. **Next button**: Advances to next question or shows result. **Result dialog** (modal): Shows estimated CEFR level, correct count, and action buttons. |
| **State Changes** | Local state only (question index, selected answer, correct count, show result flag). No provider writes. |
| **Layout Requirements** | **App bar with embedded progress bar.** Body: scrollable column. Top: question counter badge + correctness badge (after checking). Question text. Expanded: list of 4 option cards. Bottom: action button (Check / Next / See Result). Result dialog: centered modal with level display, score, and CTA. |
| **Special Requirements** | Option cards must show visual feedback: selected state (before checking), correct state (green), incorrect state (red). Each option has a letter badge (A, B, C, D). Progress bar must be visually prominent. Result dialog must be dismissible only via CTA buttons. |

---

### CATEGORY: Learn Tab

#### 12. Learn Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/learn/learn_screen.dart` |
| **Route** | `/learn` |
| **Purpose** | Main learning hub. Shows personalized greeting, daily goal progress, continue learning card, and the full course path with sections and lessons. |
| **Data Consumed** | `courseProvider` (reads entire course). `userProvider` (reads displayName, streak, dailyGoal, xp, gems, activeDays, learningLanguage, nativeLanguage). |
| **Navigation** | Arrives from splash or bottom nav. Tapping a lesson → `/lesson/:id`. Quick action buttons → `/vocabulary-review` and `/ai-conversation`. |
| **Interactive Elements** | **Top bar** (sticky): Shows greeting (time-based: morning/afternoon/evening) + user display name + streak flame icon with count. **Daily Goal card**: Circular progress ring showing minutes completed vs. goal. Tappable (routes to lesson). **Continue Learning card**: Shows next lesson title + progress. Tappable (routes to lesson). **Quick action buttons** (2): "Review" (cards icon) → vocabulary review. "AI Chat" (robot icon) → AI conversation. **Course path** (scrollable): Sections displayed as expandable groups. Each section contains lesson nodes. Locked sections are visually distinct. **Lesson nodes**: Tapping opens lesson. Locked lessons are non-tappable or show lock overlay. Completed lessons show checkmark. Current lesson is highlighted. |
| **State Changes** | Reads providers. No writes on this screen. |
| **Layout Requirements** | **CustomScrollView with Slivers.** SliverAppBar or SliverToBoxAdapter for top bar. SliverToBoxAdapter for Daily Goal card. SliverToBoxAdapter for Continue Learning card. SliverToBoxAdapter for Quick Actions row. SliverList for course sections. Each section: header with title + lock icon (if locked). Lesson nodes arranged in a path-like layout (zigzag or linear). |
| **Special Requirements** | **Loading skeleton:** Shows `LearnSkeleton` (shimmer placeholders) for 1.2 seconds on first load. Greeting changes based on time of day. Streak count must be prominent. Course path should feel like a journey (visual path connecting nodes). Locked sections should be clearly distinguished. |

#### 13. Lesson Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/learn/lesson_screen.dart` |
| **Route** | `/lesson/:id` |
| **Purpose** | The core exercise player. Displays exercises one at a time with a progress bar. Supports 15 different exercise types. |
| **Data Consumed** | `courseProvider` (reads lesson by ID, exercises). `userProvider` (reads nativeLanguage for grammar tip localization). |
| **Navigation** | Arrives from `/learn` (tapping a lesson). Back → `/learn`. Completing all exercises → `/lesson-complete` with XP/gems/stars params. |
| **Interactive Elements** | **Progress bar** (app bar): Linear progress showing current exercise / total. **Grammar tip button** (app bar action): Lightbulb icon. Opens `GrammarTipOverlay` with rule + example. **Close button** (app bar): Exits lesson. **Exercise content area**: Varies by type. **Check/Continue button** (bottom): Validates answer and shows feedback. **Option cards**: Tapping selects an answer. **Word sorting chips**: Tapping adds/removes words from answer. **Text input**: For fill-in-blank and writing exercises. **Match pairs**: Draggable or tappable pairing. **True/False buttons**. **Flashcard flip**: Tap to reveal translation. |
| **State Changes** | On final exercise completion: `courseProvider.completeLesson(id)` → extracts vocabulary, calls `userProvider.addLearnedWords()`, awards XP/gems. Then navigates to `/lesson-complete`. |
| **Layout Requirements** | **Scaffold with custom app bar.** Body: Column with Expanded content area + fixed bottom action button. Content varies by exercise type but always includes: question/instruction text at top, interactive content in middle. Bottom: full-width action button. Some exercise types show option cards in a list. Grammar tip is an overlay modal (not a separate screen). |
| **Special Requirements** | **15 exercise types** must all be visually distinct but share consistent patterns (option cards, check button, feedback states). After answering: show correct/incorrect feedback with color. Shake animation on wrong answer. Option cards must handle selected, correct, and incorrect states. Progress bar must update smoothly. |

#### 14. Lesson Complete Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/learn/lesson_complete_screen.dart` |
| **Route** | `/lesson-complete` (pushed with params: xpEarned, gemsEarned, stars, correctCount, totalExercises) |
| **Purpose** | Celebration screen shown after completing a lesson. Displays earned XP, gems, and star rating with confetti animation. |
| **Data Consumed** | Route parameters: `xpEarned` (int), `gemsEarned` (int), `stars` (int 1-3), `correctCount`, `totalExercises`. `AppLocalizations` for motivation text. |
| **Navigation** | Arrives from `/lesson/:id` after completing all exercises. **"Continue" button** → `/learn`. No back navigation (lesson is done). |
| **Interactive Elements** | **"Continue" button** (full width, bottom): Routes back to Learn screen. |
| **State Changes** | None. Purely presentational. |
| **Layout Requirements** | **Full-screen Stack.** Background layer: confetti particles falling from top. Content layer (centered): Large star rating display (1-3 stars, animated scale). Motivation text (changes based on star count). XP earned badge with icon. Gems earned badge with icon. Optional: correct answers count. Bottom: Continue button. |
| **Special Requirements** | **Confetti animation required:** Must blast from top center, colored confetti particles falling. **Entrance animations:** Stars bounce in with elastic curve (staggered if multiple). XP and gems count up with number animation. **Haptic feedback:** Heavy impact when stars appear. Confetti plays for ~3 seconds. |

#### 15. Post-Learning Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/learn/post_learning_screen.dart` |
| **Route** | `/post-learning` |
| **Purpose** | Post-lesson review screen showing earned rewards and 4 next-action cards. |
| **Data Consumed** | Constructor params: `lessonId` (default `'lesson_1'`), `xpEarned` (default `10`), `gemsEarned` (default `5`), `stars` (default `2`). |
| **Navigation** | Arrives from lesson flow. Continue Learning → `/learn` (go). Review Vocabulary → `/vocabulary-review` (push). AI Practice → `/ai-conversation` (push). Visit Chill Corner → `/chill` (go). |
| **Interactive Elements** | **Header**: Trophy icon (80×80 dp container, `PhosphorIcons.trophy fill`, success color with 15% alpha background) + "Lesson Complete" title (`displayMedium`, 28.sp) + "What next?" subtitle (`bodyLarge`, 50% alpha). **Rewards row** (centered): XP pill (`+N`, `PhosphorIcons.lightning fill`, xp color), Gems pill (`+N`, `PhosphorIcons.diamond fill`, gems color), 3 star icons (`PhosphorIcons.star fill`, gold if index < stars, else 10% alpha). **Action cards** (4, in scrollable ListView): `_ActionCard` with icon (48×48 dp container, colored background), title (`titleLarge`), subtitle (`bodyMedium`, 50% alpha), chevron. Cards: Continue Learning (primary color), Review Vocabulary (secondary color), AI Practice (chillPrimary color), Visit Chill Corner (accent color). Each card triggers `HapticFeedback.mediumImpact`. |
| **State Changes** | None. Stateless widget. |
| **Layout Requirements** | **Scaffold with SafeArea.** Padding: 24.w horizontal. Column: `SizedBox(height: 40.h)` header, `SizedBox(height: 32.h)` rewards row, Expanded ListView with 4 action cards + spacing (12.h), `SizedBox(height: 16.h)` bottom. Cards have 16.w padding, surface color background, 16.r border radius, `appTheme.border` border. |
| **Special Requirements** | Uses `FadeSlide` animation with staggered delays: header (0ms), rewards (200ms), cards (300ms, 400ms, 500ms, 600ms). Reward pills are rounded (20.r) containers with icon + bold text, using `color.withValues(alpha: 0.1)` background. Star rating shows 3 stars max. |

#### 16. Vocabulary Review Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/learn/vocabulary_review_screen.dart` |
| **Route** | `/vocabulary-review` |
| **Purpose** | Flashcard-style vocabulary review with 3D flip animation and difficulty rating (Hard/Good/Easy). |
| **Data Consumed** | Hardcoded demo `_words` list (5 items: Fragrance, Aroma, Dough, Harvest, Bouquet). Each has word, phonetic, translation, explanation, example. No provider reads in current implementation. |
| **Navigation** | Arrives from `/learn` or Post-Learning screen. Back button → pop. |
| **Interactive Elements** | **App bar**: Back button + title "Vocabulary Review" + progress counter (`${_currentIndex + 1}/${_words.length}`) in actions. **Progress bar**: Linear progress indicator showing card progress (primary color, 6.h height, rounded). **Flashcard** (Expanded, tappable): Front shows word (`titleLarge`, 24.sp), phonetic (`bodyMedium`, 50% alpha), translation (`headlineSmall`), and audio button (64×64 dp circle, primary 10% alpha). Back shows explanation + example sentence. **Difficulty buttons** (3, bottom row): Hard (`arrowUUpLeft`, error color), Good (`check`, primary color), Easy (`star fill`, gold color). Each is an `_ActionButton` with icon, label, colored text, and colored border. Tapping any button triggers `HapticFeedback.mediumImpact` and advances to next card. |
| **State Changes** | Local state: `_currentIndex` (0 to 4), `_isFlipped` (bool). `AnimationController` for flip (400ms, `Curves.easeInOut`). `_flipAnimation` uses `Tween<double>(0, 1)` with `rotateY` transform. |
| **Layout Requirements** | **Scaffold with app bar.** Body: SafeArea, 24.w horizontal padding. Column: progress bar (20.h top), Expanded flashcard, controls (32.h), bottom padding (24.h). Flashcard uses `Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle)` for 3D perspective. Front/back are separate widgets (`_CardFront`, `_CardBack`). Back card is pre-rotated 180° on Y to face forward after flip. |
| **Special Requirements** | **3D flip animation**: 400ms easeInOut, with perspective transform (0.001). When advancing, if flipped, first reverses animation (200ms delay) then increments index. Card front has shadow (`BoxShadow`, blur 20, offset 0,8, `appTheme.cardShadow`). Card back has surfaceVariant background with subtle border. Audio button is a tappable circle with `PhosphorIcons.speakerHigh` icon. |

---

### CATEGORY: Chill Tab

#### 17. Chill Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/chill/chill_screen.dart` |
| **Route** | `/chill` |
| **Purpose** | Social learning feed ("Chill Corner"). Displays AI persona posts that teach vocabulary. Posts are filtered by user's learned vocabulary — only posts with known words are shown. |
| **Data Consumed** | `postsProvider` (reads filtered posts). `userProvider` (reads nativeLanguage for translation display). |
| **Navigation** | Arrives from bottom nav. Tapping a post → `/post/:id`. |
| **Interactive Elements** | **Search icon** (app bar action): Placeholder for future search. **Post cards** (scrollable list): Each card shows author avatar, name, content, target word, likes count, bookmark icon. Tapping card → post detail. **Like button** (heart icon): Tapping toggles like. **Bookmark button**: Tapping toggles bookmark. |
| **State Changes** | On like: `postsProvider.toggleLike(postId)`. On bookmark: `postsProvider.toggleBookmark(postId)`. |
| **Layout Requirements** | **CustomScrollView with SliverAppBar.** AppBar: title "Chill Corner" + AI badge (pill-shaped label). Floating + pinned behavior. Body: SliverList of post cards. Each post card: Author row (avatar + name + character type badge + timestamp). Content text. Target word highlight. Optional image. Action row (like count + like button + bookmark button). |
| **Special Requirements** | **Loading state:** Shows `RocketLoader` animation + "Loading..." text for 1.5 seconds. **Empty state:** If no posts match learned vocabulary, show empty state with message. **AI badge:** Must be visually distinct (pill shape). Post cards should feel like social media content. Target word should be visually highlighted within post text. |

#### 18. Post Detail Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/chill/post_detail_screen.dart` |
| **Route** | `/post/:id` |
| **Purpose** | Detailed view of a single Chill Corner post. Shows full content, vocabulary details (word, translation, explanation, example), and comments section. |
| **Data Consumed** | `postsProvider` (reads post by ID). `userProvider` (reads nativeLanguage). |
| **Navigation** | Arrives from `/chill` (tapping a post). Back → `/chill`. |
| **Interactive Elements** | **Back button** (app bar). **Like button** (heart icon): Toggles like. **Bookmark button**: Toggles bookmark. **Comment input field** (bottom): Text field + send button. Submitting adds a comment. **Comment list**: Shows existing comments. |
| **State Changes** | On like: `postsProvider.toggleLike(postId)`. On bookmark: `postsProvider.toggleBookmark(postId)`. On comment: `postsProvider.addComment(postId, content)`. |
| **Layout Requirements** | **Scaffold with app bar.** Body: Column with Expanded scrollable content + fixed comment input. Scrollable content: Author row. Post content. Vocabulary card (target word, phonetic, translation, explanation, example sentence + translation). Like/bookmark counts. Comments section (list). Bottom: comment input row (text field + send button). |
| **Special Requirements** | **Vocabulary card must be prominent:** Shows target word in large text, phonetic pronunciation, translation in user's native language (via `LocalizedText.get(nativeLang)`), explanation, and example sentence with translation. **Comments:** Each comment shows author name, content, timestamp. AI replies are visually distinct (e.g., different avatar or badge). |

---

### CATEGORY: Profile Tab & Subscreens

#### 19. Profile Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/profile_screen.dart` |
| **Route** | `/profile` |
| **Purpose** | Main profile hub. Shows user identity, stats summary, and organized menu sections for all profile-related screens. |
| **Data Consumed** | `userProvider` (reads full UserProfile). |
| **Navigation** | Arrives from bottom nav. Menu items push to sub-routes. |
| **Interactive Elements** | **Profile header**: Avatar (tappable → `/profile/edit-profile`), display name, learning language flag, streak flame + count, XP count, gems count. **Stats section** (4 menu items): Stats → `/profile/stats`. Achievements → `/profile/achievements`. Course → `/profile/course`. Study Plan → `/profile/study-plan`. **Friends section** (3 items): Friends → `/profile/friends`. Leaderboard → `/profile/friends`. Find Friends → `/profile/friends`. **Settings section** (4 items): Super (premium) → `/profile/super`. Subscription → `/profile/subscription`. Settings → `/profile/settings`. Help → `/profile/help`. Each menu item: icon + label + optional badge + chevron/arrow. |
| **State Changes** | Reads only. No writes. |
| **Layout Requirements** | **CustomScrollView.** SliverToBoxAdapter for profile header. Then grouped menu sections with section titles. Each section contains a card with rounded corners holding menu items. Menu items are full-width tappable rows with icon (left), label (center, expanded), and arrow (right). |
| **Special Requirements** | **Avatar must be tappable** and route to edit profile. Stats should be glanceable (streak, XP, gems displayed prominently in header). Menu sections should be visually grouped. Super/premium item should have a special badge (e.g., "PRO"). |

#### 20. Edit Profile Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/edit_profile_screen.dart` |
| **Route** | `/profile/edit-profile` |
| **Purpose** | Edit user profile: display name, email, avatar, learning language, proficiency level, daily goal. |
| **Data Consumed** | `userProvider` (reads/writes). `LanguageService` (language changes). |
| **Navigation** | Arrives from `/profile` (tapping avatar or menu). Back → `/profile`. Save → `/profile`. |
| **Interactive Elements** | **Avatar** (center, 100×100 dp circle): Shows initials or user icon. Tappable to change (placeholder). **Name field**: Text input, pre-filled with current name. **Email field**: Text input, optional. **Learning language row**: Shows current language. Tapping opens bottom sheet picker. **Proficiency level row**: Shows current level. Tapping opens bottom sheet picker. **Daily goal row**: Shows current goal. Tapping opens bottom sheet picker. **Save button** (app bar action): Writes changes and pops. |
| **State Changes** | On Save: `userProvider.updateProfile(displayName, email)`. Language changes go through `LanguageService`. |
| **Layout Requirements** | **Scrollable list.** Center: avatar with edit badge (small circle with pencil icon, bottom-right). Below: name field. Below: email field. Below: sectioned rows for learning language, proficiency, daily goal. Each row: label (left) + current value (right) + arrow. App bar with title and Save action. |
| **Special Requirements** | **Bottom sheet pickers:** Tapping language/proficiency/goal opens a modal bottom sheet with options. Save must validate name is not empty. Avatar edit is a placeholder (non-functional in demo). |

#### 21. Settings Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/settings_screen.dart` |
| **Route** | `/profile/settings` |
| **Purpose** | App settings: appearance, sound, notifications, language preferences. |
| **Data Consumed** | `settingsProvider` (darkMode, soundEnabled). `userProvider` (nativeLanguage, learningLanguage). `localeProvider` (current locale). |
| **Navigation** | Arrives from `/profile`. Back → `/profile`. |
| **Interactive Elements** | **Dark mode toggle** (switch): Toggles dark/light theme. **Sound effects toggle** (switch): Toggles sound. **Notifications toggle** (switch): Toggles push notifications. **Native language row**: Shows current. Tapping opens bottom sheet picker. **Learning language row**: Shows current. Tapping opens bottom sheet picker. **Reminder time row**: Shows current time. Tapping opens time picker. |
| **State Changes** | On dark mode toggle: `settingsProvider.toggleDarkMode()`. On sound toggle: `settingsProvider.toggleSound()`. On language change: `LanguageService.setNativeLanguage()` or `setLearningLanguage()`. |
| **Layout Requirements** | **Scrollable list with sectioned groups.** Section: "Appearance" (dark mode, sound). Section: "Notifications" (toggle, reminder time). Section: "Language" (native, learning). Each toggle row: icon (left) + label (center, expanded) + Switch (right). Each picker row: icon (left) + label + current value + arrow (right). |
| **Special Requirements** | **Bottom sheet pickers** for language selection. **Time picker** for reminder time. Toggles should have haptic feedback. |

#### 22. Stats Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/stats_screen.dart` |
| **Route** | `/profile/stats` |
| **Purpose** | Learning statistics with weekly XP bar chart, stat grid, time spent card, and streak calendar. |
| **Data Consumed** | `userProvider` (reads `streak`, `xp`, `activeDays`, `streakShields`). |
| **Navigation** | Arrives from `/profile`. Back button → pop. |
| **Interactive Elements** | **Weekly XP Chart** (container with 20.w padding, surface background, 20.r radius, border): Title row with `PhosphorIcons.chartBar fill` icon (primary, 24.sp) + "XP This Week" label. Below: 7 vertical bars (`_Bar` widget) aligned to bottom, showing Mon-Sun. Each bar: XP value label on top (11.sp, primary if today), bar height proportional to value (max 100.h), rounded top (6.r). Today is highlighted with primary color; others use primary 30% alpha. **Stat grid** (2×2): Streak (`PhosphorIcons.flame fill`, streak color, value from `user.streak`), Total XP (`PhosphorIcons.lightning fill`, xp color, value from `user.xp`), Lessons (`PhosphorIcons.checkCircle fill`, success, hardcoded "12"), Words Learned (`PhosphorIcons.bookOpen fill`, primary, hardcoded "32"). Each `_StatBox` has icon container (48×48 dp, colored 10% alpha), value (`headlineLarge`, 28.sp), label (`bodyMedium`, 50% alpha). **Time spent card**: Clock icon container (48×48 dp, secondary 10% alpha) + "Time Spent" title + localized hours/minutes text (`timeSpentHoursMinutes(4, 32)`). **StreakCalendar widget**: Shows current month grid with day states (completed/shielded/repaired/pending/missed). Includes streak shield count badge and "keep streak" banner if today is pending. |
| **State Changes** | Reads only. No local state. |
| **Layout Requirements** | **Scaffold with app bar** (back button + "Stats" title). Body: `ListView` with 20.w horizontal padding, 16.h vertical. Sections separated by 16.h: XP chart container, stat grid row (12.h spacing between boxes), second stat grid row, time spent container, StreakCalendar container. Bottom padding: 40.h. |
| **Special Requirements** | **Custom bar chart** (NOT `fl_chart`): Simple `Container` bars with proportional heights. Uses `Row` with `MainAxisAlignment.spaceAround` and `CrossAxisAlignment.end`. No tooltips or interaction. StreakCalendar is a separate reusable widget (see Widget Inventory). Time spent uses hardcoded demo values (4h 32m). |

#### 23. Achievements Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/achievements_screen.dart` |
| **Route** | `/profile/achievements` |
| **Purpose** | Achievement list showing unlocked and in-progress achievements with tier badges and progress bars. |
| **Data Consumed** | `DemoData.achievements` (static list). No provider reads. |
| **Navigation** | Arrives from `/profile`. Back button → pop. |
| **Interactive Elements** | **Summary header** (container, primary 8% alpha background, 20.r radius, primary 20% alpha border): Trophy icon (56×56 dp, primary 15% alpha) + unlocked/total count (`headlineLarge`, 28.sp) + "Achievements Unlocked" label. **Empty state**: If no achievements, shows `EmptyState` widget (trophy icon). **Unlocked section**: Section title "Unlocked" (`labelLarge`, `onSurfaceVariant` color) + list of `_AchievementCard` widgets. **Locked section**: Section title "In Progress" + list of `_AchievementCard` widgets. Each `_AchievementCard`: icon container (48×48 dp, rounded 12.r, colored background), title (`titleLarge`), tier badge (if unlocked: small pill with tier text in uppercase, tier color 15% alpha background), description (`bodyMedium`, 50% alpha), progress bar (if locked: linear, tier color, 6.h height, with current/target text below), checkmark icon (if unlocked, tier color, 24.sp). |
| **State Changes** | Reads only. |
| **Layout Requirements** | **Scaffold with app bar** (back + title). Body: `ListView` with 20.w horizontal padding, 16.h vertical. Summary header at top. Then conditional sections: "Unlocked" title + cards (12.h spacing), 24.h gap, "In Progress" title + cards. Bottom padding: 40.h. Cards have 16.w padding, 16.r radius, 1-2 dp border. |
| **Special Requirements** | **List layout (NOT grid).** Tier colors: bronze `0xFFCD7F32`, silver `0xFFC0C0C0`, gold `0xFFFFD700`. Unlocked cards: background = tier color 5% alpha, border = tier color 30% alpha, icon container = tier color 15% alpha. Locked cards: background = `surfaceVariant`, border = `appTheme.border`, icon container = `borderLight`, icon color = `onSurfaceVariant`. Title color muted for locked items. Progress bar shows `achievement.progressRatio` value with `currentValue/targetValue` text. |

#### 24. Course Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/course_screen.dart` |
| **Route** | `/profile/course` |
| **Purpose** | Course overview showing course card with progress and a list of sections with completion stats. |
| **Data Consumed** | `courseProvider` (reads full course). `userProvider` (reads `nativeLanguage` for resolving localized titles). |
| **Navigation** | Arrives from `/profile`. Back button → pop. |
| **Interactive Elements** | **Course card** (top, english color 10% alpha background, 20.r radius, english 20% alpha border): Globe icon (48×48 dp, english 15% alpha), course title (`headlineSmall`, resolved via `nativeLang`), subtitle (`bodyMedium`, 50% alpha), progress bar (english color, 8.h, with border radius), lessons completed text (`bodySmall`, 50% alpha). **Sections list**: "Sections" header (`labelLarge`, `onSurfaceVariant`). Each `_SectionItem` is a card with: folder icon (`folderOpen fill` if unlocked, `lockKey` if locked, primary or `onSurfaceVariant` color), section title (`titleLarge`, resolved via `nativeLang`, muted if locked), completed/total count (`bodySmall`, `onSurfaceVariant`), progress bar below (primary if unlocked, `onSurfaceVariant` if locked, 6.h height). |
| **State Changes** | Reads only. |
| **Layout Requirements** | **Scaffold with app bar** (back + "Course Path" title). Body: `ListView` with 20.w horizontal padding, 16.h vertical. Course card (24.w padding). 24.h gap. Sections header + list of section cards (12.h spacing). Bottom padding: 40.h. Section cards: 16.w padding, 16.r radius, surface background, `appTheme.border` border. |
| **Special Requirements** | **NOT expandable.** Sections are static summary cards showing aggregate progress only. Title resolution uses `course.title.resolve(nativeLang)` and `section.title.resolve(nativeLang)` — the designer must preserve text layout that works with variable-length localized strings. Progress uses `completedLessons / totalLessons` for course and `completed / total` per section. |

#### 25. Study Plan Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/study_plan_screen.dart` |
| **Route** | `/profile/study-plan` |
| **Purpose** | 5-step wizard for creating a personalized study plan (goal, level, schedule, intensity, duration). |
| **Data Consumed** | `AppLocalizations` for all step titles, descriptions, and options. No provider reads. |
| **Navigation** | Arrives from `/profile`. Back button → pop. On complete, shows SnackBar and pops. |
| **Interactive Elements** | **Progress bar** (top): Linear progress showing step progress (`(_currentStep + 1) / steps.length`, 8.h height). Step counter text below (`bodySmall`, 50% alpha). **Step title** (`displayMedium`, 32.sp) + description (`bodyLarge`, 50% alpha). **Option cards** (ListView, 4 options per step): Each card is a selectable row with text (`titleLarge`) and checkmark icon (if selected, `checkCircle fill`, primary color). Tapping selects one option for current step. Selected card: primary 10% alpha background, primary border (2.dp). Unselected: `surfaceVariant` background, `appTheme.border` (1.dp). **Navigation buttons** (bottom): "Back" outlined button (if step > 0, left). "Continue" / "Create Plan" elevated button (right, flex 2 on first step, equal flex after). Continue disabled until selection made. Final step shows "Create Plan" which triggers green SnackBar (`profile_studyPlanCreated`, floating, 12.r radius) then pops. |
| **State Changes** | Local state: `_currentStep` (int, 0-4), `_selections` (Map<int, String?>). |
| **Layout Requirements** | **Scaffold with app bar** (back + "Study Plan" title). Body: SafeArea, 24.w horizontal padding. Column: progress bar (16.h top), step counter, title (32.h), description, Expanded ListView of option cards (12.h spacing), button row (24.h bottom). |
| **Special Requirements** | **5 fixed steps**: (1) Goal — daily conversation, business, academic, travel, exam prep. (2) Level — complete beginner, some basics, intermediate, advanced. (3) Schedule — morning, daytime, evening, night. (4) Intensity — every day, 5 days/week, 3 days/week, weekends only. (5) Duration — 5, 10, 15, 20+ minutes. Single-select per step. Must preserve step order and option count. |

#### 26. Friends Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/friends_screen.dart` |
| **Route** | `/profile/friends` |
| **Purpose** | Social screen with 3 tabs: Friends, Leaderboard, Following. Shows user cards with XP/streak stats and Follow buttons. |
| **Data Consumed** | Hardcoded demo `_User` lists per tab. No provider reads. |
| **Navigation** | Arrives from `/profile`. Back button → pop. |
| **Interactive Elements** | **TabBar** (in appBar bottom): 3 tabs — "Friends", "Leaderboard", "Following". Label color = primary when selected, `onSurfaceVariant` when unselected. Indicator = primary color. **Friend list**: Each user card has: `_Avatar` widget (48×48 dp circle, primary 15% alpha background, initials text, 18.sp bold), name (`titleLarge`), handle (`bodySmall`), XP row (`lightning fill` icon, xp color, 12.sp bold), streak row (`flame fill` icon, streak color, 12.sp bold). **Follow button**: Elevated button (36.h, 14.sp text, horizontal 16.w padding). Tapping is placeholder (no-op). **Empty state**: If a tab has no users, shows `EmptyState` widget with `users` icon. |
| **State Changes** | None in demo. |
| **Layout Requirements** | **DefaultTabController** wrapping Scaffold. AppBar with back button, title, and TabBar (3 tabs). Body: `TabBarView` with 3 `_FriendList` widgets. Each list: `ListView.builder` with 16.w padding. Cards: 16.w padding, 16.r radius, surface background, `appTheme.border` border, 12.h bottom margin. |
| **Special Requirements** | **3 tabs, not 2.** Avatar uses initials algorithm: split name by space, take first char of each part, max 2 chars. All 3 tabs share the same card layout. Leaderboard tab shows same card layout without rank numbers (placeholder). Follow button is non-functional in demo. |

#### 27. Subscription Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/subscription_screen.dart` |
| **Route** | `/profile/subscription` |
| **Purpose** | Subscription plan selection with Monthly and Annual pricing tiers. |
| **Data Consumed** | `AppLocalizations` for all text. No provider reads. |
| **Navigation** | Arrives from `/profile`. Back button → pop. "Start Free Trial" button → pushes `/paywall`. |
| **Interactive Elements** | **Header card** (gold 10% alpha background, 20.r radius, gold 30% alpha border): Crown icon (`PhosphorIcons.crown fill`, 48.sp, gold color), "Unlock Your Full Potential" title (`headlineLarge`), subtitle (`bodyLarge`, 50% alpha, centered). **Monthly plan card** (`_PlanCard`): Title "Monthly", price "$9.99", period "/month", 5 features with `checkCircle fill` icons (success color), NOT popular. **Annual plan card** (`_PlanCard`): Title "Annual", price "$59.99", period "/year", 4 features, IS popular (gold border 2.dp, "Best Value" badge in gold 15% alpha pill). **CTA button**: "Start Free Trial" (full width, 56.h, 18.sp bold) with `HapticFeedback.mediumImpact`, pushes `/paywall`. **Cancel text**: "Cancel anytime" (`bodySmall`, 50% alpha, centered). |
| **State Changes** | None in demo. |
| **Layout Requirements** | **Scaffold with app bar** (back + "Subscription" title). Body: `ListView` with 20.w horizontal padding, 16.h vertical. Header card (24.w padding). 24.h gap. Monthly card. 12.h gap. Annual card. 24.h gap. CTA button. 16.h gap. Cancel text. Bottom padding: 40.h. Plan cards: 20.w padding, 20.r radius, surface background. |
| **Special Requirements** | **Plan selection screen (NOT current plan details).** Annual card has `isPopular = true` which adds gold border and "Best Value" badge. Features are hardcoded localized strings. Price strings are hardcoded with `$` prefix. Must preserve the push to `/paywall` route. |

#### 28. Super Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/super_screen.dart` |
| **Route** | `/profile/super` |
| **Purpose** | Premium feature showcase with gradient header and 5 feature rows. CTA pushes to paywall. |
| **Data Consumed** | `AppLocalizations` for all text. No provider reads. |
| **Navigation** | Arrives from `/profile`. Back button → pop. "Upgrade to Super" button → pushes `/paywall`. |
| **Interactive Elements** | **AppBar title**: Sparkle icon (`PhosphorIcons.sparkle fill`, 24.sp, gold) + "InstaLingo Super" text. **Gradient header card** (24.r radius, gold 30% alpha border): Linear gradient from `gold 20% alpha` (top-left) to `gold 5% alpha` (bottom-right). Crown icon (64.sp, gold). "Unlock Your Full Potential" title (`displaySmall`). Subtitle (`bodyLarge`, 50% alpha, centered). **Feature list** (5 `_FeatureItem`s): Each has icon container (48×48 dp, 12.r radius, colored 10% alpha background), title (`titleLarge`), description (`bodyMedium`, 50% alpha). Features: (1) Unlimited AI Conversations (`chatCircleText fill`, chillPrimary), (2) Advanced Speaking Feedback (`microphone fill`, primary), (3) Offline Mode (`downloadSimple fill`, secondary), (4) Personalized Study Plans (`brain fill`, accent), (5) Ad-Free Experience (`heart fill`, streak). **CTA button**: "Upgrade to Super" (full width, 56.h, gold background, white 18.sp bold text) with `HapticFeedback.mediumImpact`. |
| **State Changes** | None. |
| **Layout Requirements** | **Scaffold with app bar** (back + custom title with icon). Body: `ListView` with 20.w horizontal padding, 16.h vertical. Gradient header card (24.w padding). 32.h gap. 5 feature cards (16.h spacing between). 32.h gap. CTA button. Bottom padding: 40.h. Feature cards: 16.w padding, 16.r radius, surface background, `appTheme.border` border. |
| **Special Requirements** | **5 features, not 3-4.** Gradient header is a `LinearGradient` with specific stops (20% → 5% alpha). Each feature has a distinct brand color (chillPrimary, primary, secondary, accent, streak). CTA button uses `ElevatedButton.styleFrom(backgroundColor: AppColors.gold)`. Must preserve push to `/paywall`. |

#### 29. Help & Support Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/profile/help_support_screen.dart` |
| **Route** | `/profile/help` |
| **Purpose** | FAQ sections with expandable items and contact buttons (email + web). |
| **Data Consumed** | `AppLocalizations` for all FAQ content. No provider reads. |
| **Navigation** | Arrives from `/profile`. Back button → pop. |
| **Interactive Elements** | **Search hint container** (primary 8% alpha background, 16.r radius): Magnifying glass icon (`PhosphorIcons.magnifyingGlass`, 24.sp, primary) + "Browse Topics" text (`bodyLarge`, primary color). **NOT functional search** — visual hint only. **FAQ sections** (3 hardcoded): "Getting Started" (3 items), "Learning Features" (3 items), "Account" (2 items). Each section has title (`labelLarge`, `onSurfaceVariant`). Each `_HelpItemWidget`: icon container (40×40 dp, 10.r radius, primary 10% alpha), title (`bodyLarge`, 600 weight), caret right icon (`PhosphorIcons.caretRight`, 18.sp, `onSurfaceVariant`). Tapping triggers `HapticFeedback.selectionClick` and opens **bottom sheet** with full explanation. **Contact buttons**: "Contact Support" (elevated, full width, 52.h, `PhosphorIcons.envelope` icon) → launches `mailto:support@instalingo.app`. "Visit Help Center" (outlined, full width, 52.h, `PhosphorIcons.globe` icon) → launches `https://instalingo.app/faq` in external browser. Both have `HapticFeedback.mediumImpact`. |
| **State Changes** | None. FAQ explanation is shown in a modal bottom sheet, not local state. |
| **Layout Requirements** | **Scaffold with app bar** (back + "Help & Support" title). Body: `ListView` with 20.w horizontal padding, 16.h vertical. Search hint. 24.h gap. FAQ sections (each: section title + items with 8.h spacing, 8.h section gap). 24.h gap. Contact buttons (12.h spacing). Bottom padding: 40.h. Help items: 16.w padding, 12.r radius, surface background, `appTheme.border` border, 8.h bottom margin. |
| **Special Requirements** | **Bottom sheet explanation** (not accordion): Tapping any FAQ item opens a `showModalBottomSheet` with the item title and full description text. Uses `url_launcher` package with `canLaunchUrl` + `launchUrl` (external application mode for web). Must preserve mailto and URL targets. |

#### 30. Force Update Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/force_update_screen.dart` |
| **Route** | `/force-update` |
| **Purpose** | Blocking screen requiring app update. Shows update prompt with feature highlights and store link. |
| **Data Consumed** | `AppLocalizations` for all text. No provider reads. |
| **Navigation** | Arrives when update is required. "Update Now" button opens external browser (`https://instalingo.app/download`). "Not Now" button is placeholder (no-op in demo). No back navigation. |
| **Interactive Elements** | **Pulsing icon** (100x100 dp container, 28.r radius, primary 15% alpha, `downloadSimple fill` icon, 44.sp, wrapped in `PulseContainer`). **Title** "Update Available" (`displayLarge`, 24.sp). **Body text** (`bodyLarge`, 50% alpha, centered, line height 1.6). **Feature rows** (3): Bug Fixes (`bugBeetle`), Performance (`lightning`), New Content (`sparkle`). Each row: icon (20.sp, primary) + label (`bodyLarge`). **"Update Now" button** (full width, 48.h, elevated with icon) with `HapticFeedback.mediumImpact`. Opens store URL via `url_launcher`. **"Not Now" text button** (14.sp, 40% alpha). |
| **State Changes** | None. |
| **Layout Requirements** | **Scaffold with SafeArea.** Centered `SingleChildScrollView`. Column: pulsing icon (32.h gap), title (12.h gap), body (32.h gap), 3 feature rows (12.h spacing), 32.h gap, Update Now button (12.h gap), Not Now button. Padding: 32.w horizontal, 24.h vertical. All centered. |
| **Special Requirements** | **Pulse animation** via `PulseContainer` widget (1.0 to 1.05 scale, 1200ms loop). Uses `url_launcher` with `canLaunchUrl` + `launchUrl` (external application mode). This is a blocking screen, no app bar, no back button. |

---

### CATEGORY: Modals & Overlays

#### 31. Paywall Modal

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/paywall/paywall_modal.dart` |
| **Route** | `/paywall` (shown as `showModalBottomSheet`, not push) |
| **Purpose** | Bottom sheet subscription upsell. Presents annual vs. monthly plans with feature list and pricing. |
| **Data Consumed** | `AppLocalizations` for all text. |
| **Navigation** | Shown as modal overlay on any screen. **"Start Free Trial"** → closes modal. **"Maybe Later"** → closes modal. Drag down → closes modal. |
| **Interactive Elements** | **Annual/Monthly toggle** (segmented control): Tapping switches plan. **"Start Free Trial" button** (full width, bottom). **"Maybe Later" text button**. **Drag handle** (top center visual indicator). |
| **State Changes** | Local state only (`_isAnnual` boolean). |
| **Layout Requirements** | **Bottom sheet modal** (slides up from bottom). Rounded top corners (32dp). Padding: 24dp. Content: Drag handle (40×4 dp). Header with crown icon + title + subtitle. Feature list (4 items with icons). Plan toggle (2 buttons in container). Conditional "Save X%" badge. Price display. CTA button. Secondary dismiss button. |
| **Special Requirements** | **Slide-up entrance animation** (600ms, from bottom). **Toggle animation** (200ms color transition). Must be dismissible by drag and back button. Annual should be pre-selected. |

---

### CATEGORY: AI Conversation

#### 32. AI Conversation Screen

| Field | Value |
|-------|-------|
| **File Path** | `lib/screens/ai/ai_conversation_screen.dart` |
| **Route** | `/ai-conversation` |
| **Purpose** | Chat interface for practicing language with an AI persona (Maya, a cafe worker in Tokyo). Simulates AI responses with delays. |
| **Data Consumed** | `AppLocalizations` for labels. Hardcoded initial AI message. Local message list. |
| **Navigation** | Arrives from `/learn` (Quick Action) or deep link. Back → previous screen. |
| **Interactive Elements** | **Back button** (app bar). **More options** (app bar): Placeholder menu. **Message input field** (bottom): Text input with rounded background. **Microphone button** (left of input): Placeholder for voice input. **Send button** (right of input): Paper plane icon, sends message. **Message bubbles** (scrollable list): User messages (right-aligned). AI messages (left-aligned with avatar). **Typing indicator**: 3 animated dots shown while AI is "typing". |
| **State Changes** | On send: adds user message to list, clears input, shows typing indicator. After 1.5s delay: adds AI response, hides typing indicator, auto-scrolls to bottom. |
| **Layout Requirements** | **Scaffold with app bar.** Body: Column. Top: scenario card (full width, highlighted background). Middle: Expanded ListView of messages. Conditional: typing indicator row. Bottom: input row (microphone button + text field + send button) with top border. SafeArea at bottom. |
| **Special Requirements** | **Auto-scroll** to bottom on new messages (300ms animation). **Typing indicator:** 3 dots with staggered bounce animation. **Message bubbles:** Asymmetric border radius (pointy corner toward sender). **Avatar:** AI has colored circle avatar with initial. User has no avatar. **Scenario card:** Shows current conversation context (e.g., "Cafe in Tokyo"). |

---

## Widget Inventory

Reusable widgets used across multiple screens. These must be redesigned with consistent styling but the same functional behavior.

### 1. FadeSlide
**File:** `lib/widgets/animations.dart`
**Purpose:** Entrance animation combining fade-in + slide-up.
**Parameters:** `child`, `delayMs` (default 0), `slideY` (default 20), `duration` (default 500ms).
**Usage:** Staggered list entrances, page content reveals.
**Must preserve:** Animation curve (easeOut), delay system, slide direction (upward).

### 2. ScaleBounce
**File:** `lib/widgets/animations.dart`
**Purpose:** Elastic bounce-in scale animation.
**Parameters:** `child`, `delayMs`, `initialScale` (default 0.5).
**Usage:** Badge appearances, icon entrances.
**Must preserve:** Elastic curve, 600ms duration.

### 3. Shake
**File:** `lib/widgets/animations.dart`
**Purpose:** Horizontal shake animation for error feedback.
**Parameters:** `child`, `trigger` (bool).
**Usage:** Wrong answer feedback, validation errors.
**Must preserve:** Shake pattern (0 → -10 → 10 → -8 → 8 → 0), 400ms duration.

### 4. Pulse / PulseContainer
**File:** `lib/widgets/animations.dart`
**Purpose:** Continuous subtle scale pulse (1.0 → 1.05 → 1.0).
**Parameters:** `child`.
**Usage:** Attention-drawing CTAs, loading icons.
**Must preserve:** 1200ms loop, easeInOut curve.

### 5. StaggerList
**File:** `lib/widgets/animations.dart`
**Purpose:** Applies staggered FadeSlide to a list of children.
**Parameters:** `children`, `staggerDelayMs` (default 100).
**Usage:** Animated column/list layouts.
**Must preserve:** Incremental delay assignment.

### 6. Shimmer
**File:** `lib/widgets/animations.dart`
**Purpose:** Sweeping gradient shimmer for loading placeholders.
**Parameters:** `child`, `baseColor`, `highlightColor`.
**Usage:** Skeleton loaders.
**Must preserve:** Left-to-right sweep, 1500ms duration, repeating.

### 7. ErrorState
**File:** `lib/widgets/error_states.dart`
**Purpose:** Full-screen error display with optional retry.
**Parameters:** `title`, `message`, `icon`, `onRetry`.
**Usage:** Network errors, missing data.
**Must preserve:** Icon + title + message + retry button layout.

### 8. EmptyState
**File:** `lib/widgets/error_states.dart`
**Purpose:** Full-screen empty state display.
**Parameters:** `title`, `message`, `icon`.
**Usage:** No data available.
**Must preserve:** Icon + title + message layout.

### 9. LessonLoader
**File:** `lib/widgets/error_states.dart`
**Purpose:** Loading state with bouncing rocket icon.
**Parameters:** `title`.
**Usage:** Lesson content loading.
**Must preserve:** Rocket bounce animation, progress indicator.

### 10. SkeletonLine
**File:** `lib/widgets/skeleton.dart`
**Purpose:** Animated placeholder line.
**Parameters:** `width`, `height` (default 16), `borderRadius` (default 8).
**Usage:** Text placeholders in skeleton layouts.

### 11. SkeletonCircle
**File:** `lib/widgets/skeleton.dart`
**Purpose:** Animated circular placeholder.
**Parameters:** `size` (default 48).
**Usage:** Avatar placeholders.

### 12. SkeletonCard
**File:** `lib/widgets/skeleton.dart`
**Purpose:** Placeholder card structure.
**Parameters:** `height` (default 200).
**Usage:** Card loading placeholders.

### 13. ChillSkeleton
**File:** `lib/widgets/skeleton.dart`
**Purpose:** Complete skeleton layout for Chill feed.
**Usage:** Chill screen loading state.
**Must preserve:** Header + 3 post card skeletons structure.

### 14. LessonSkeleton
**File:** `lib/widgets/skeleton.dart`
**Purpose:** Complete skeleton layout for lesson screen.
**Usage:** Lesson screen loading state.
**Must preserve:** Title + subtitle + 4 option skeletons.

### 15. StreakCalendar
**File:** `lib/widgets/streak_calendar.dart`
**Purpose:** Monthly calendar showing streak progress with day states.
**Parameters:** `currentStreak`, `dayRecords`, `isTodayPending`, `onRepairStreak`, `streakShields`.
**Usage:** Learn screen, profile stats.
**Must preserve:** 7-day grid layout, day state coloring (completed/shielded/repaired/pending/missed), legend, repair button.
**Known exception:** Uses `Icons.local_fire_department` (Material icon) for the streak shield badge — the ONLY non-Phosphor icon in the app. Preserve this exception.

### 16. GrammarTipOverlay
**File:** `lib/widgets/grammar_tip_overlay.dart`
**Purpose:** Modal bottom sheet showing grammar rules with example sentences.
**Parameters:** `rule` (String), `example` (String), `explanation` (String?, optional).
**Usage:** Lesson exercises (grammarTip type).
**Must preserve:** `showModalBottomSheet` invocation, scroll-controlled flag, transparent background. Internal sheet structure: header with `bookOpen fill` icon + "Grammar Tip" title + close X, rule text block (secondary 6% alpha background), example block (surfaceVariant with border), optional explanation text, "Got It" button (secondary color, 52.h, 14.r radius). Uses `FadeSlide` with staggered delays (0ms, 100ms, 200ms). Triggers `HapticFeedback.lightImpact` on show.

### 17. LottieLoader / RocketLoader / PointsCompletedLottie / DailyPointsLottie
**File:** `lib/widgets/lottie_loader.dart`
**Purpose:** Lottie animation wrappers.
**Usage:** Loading, celebrations, daily points.
**Must preserve:** Asset paths, auto-play, repeat settings.

---

## Reconstruction Contract

This section defines exactly how your redesigned UI will be wired back into the Flutter codebase. The reconstruction agent (me) will:

### 1. File Structure Preservation
**Every screen file path must remain exactly the same.** If you redesign `lib/screens/learn/learn_screen.dart`, the reconstructed code will be written back to that exact path. Same for all 32 screen files listed above, all 6 widget files, and the theme file.

### 2. Provider Contract
The reconstruction agent will preserve ALL provider reads and writes exactly as they are in the current code. You cannot change:
- Which providers a screen watches (`ref.watch(...)`, `ref.read(...)`)
- Which provider methods are called on interaction
- The order of provider operations
- Provider parameter values

### 3. Navigation Contract
All route paths, route names, and navigation calls (`context.go()`, `context.push()`, `context.pop()`) will be preserved. You can redesign the visual appearance of navigation elements (bottom nav bar, back buttons, app bars) but the navigation logic stays identical.

### 4. Model Field Contract
Every model field displayed on screen must remain accessible. You can redesign HOW fields are displayed (layout, grouping, emphasis) but not WHICH fields are shown. If `Post` has `targetWord`, `wordTranslation`, `wordExplanation`, `wordExample` — all must be rendered in the redesigned UI.

### 5. Interactive Element Contract
Every tappable, scrollable, draggable, and input element must trigger the same callbacks. You can redesign the visual style of buttons, cards, toggles, and inputs, but their `onPressed`, `onTap`, `onChanged`, `onSubmitted` handlers must call the same functions.

### 6. Animation Contract
Animations must be preserved in type and timing:
- **Entrance animations:** FadeSlide, ScaleBounce, StaggerList — these must remain available as reusable widgets
- **Loading animations:** Shimmer, RocketLoader, LottieLoader — must remain
- **Celebration animations:** Confetti on LessonComplete — must remain
- **Feedback animations:** Shake on wrong answer, Pulse on CTA — must remain

You can change animation curves, durations, and visual styling (colors, shadows) but the animation widgets must still exist and be invoked from the same places.

### 7. Localization Contract
All text displayed to users must come from `AppLocalizations.of(context)!`. You cannot hardcode English strings. The reconstruction agent will ensure all `l10n.keyName` references are preserved.

### 8. Responsive Design Contract
The app uses `flutter_screenutil`. You can redesign with any spacing values as long as they use `.w`, `.h`, `.sp`, `.r` extensions. The design size base (390×844) will remain.

### 9. Icon Contract
The app uses Phosphor icons (`phosphor_flutter` package). You can change which specific Phosphor icon is used for any given element, but you cannot introduce emoji or other icon libraries. Every icon must be a `PhosphorIcon` widget.

**Known exception:** `StreakCalendar` widget uses `Icons.local_fire_department` (Material icon) for the streak shield count badge. This is the only non-Phosphor icon in the codebase and must be preserved as-is.

### 10. Theme Contract
The app has a custom `AppThemeExtension` with semantic colors: primary, secondary, accent, success, error, gold, xp, gems, streak, chillPrimary, border, surfaceVariant, onSurfaceVariant, skeleton, skeletonHighlight. You can redesign the actual color values in `lib/theme/app_theme.dart`, but the semantic names must remain so screens can reference them.

### Reconstruction Process
When you deliver the redesigned files:
1. The reconstruction agent reads your redesigned Dart files
2. Compares against the original functional contract above
3. Preserves all provider logic, navigation, state changes, and model field access
4. Merges your visual redesign with the original functional code
5. Verifies all 32 screens compile and all navigation routes work
6. Runs the end-to-end verification script to confirm functionality

---

## Asset Requirements

The following asset directories exist in `assets/` but are mostly empty. Your redesign should account for these placeholders:

| Directory | Contents | Usage |
|-----------|----------|-------|
| `assets/images/` | Empty | Post images, avatars, course thumbnails |
| `assets/icons/` | Empty | Custom app icons, category icons |
| `assets/flags/` | Empty | Country flag images (currently using emoji) |
| `assets/fonts/` | Empty | Inter font family (fallback to system fonts) |
| `assets/lottie/` | 3 JSON files | Rocket, points_completed, daily_points animations |

**You can specify new assets** the reconstruction agent should source (e.g., "use a gradient background instead of solid color", "add a custom illustration for empty states"). The agent will use colored containers, Phosphor icons, or Lottie animations as placeholders for missing image assets.

---

## Design Deliverables Checklist

When you complete the redesign, deliver the following for EACH screen:

- [ ] **Dart file** (or detailed pseudocode) showing:
  - Widget structure (Scaffold, Column, Row, Stack, etc.)
  - All child widgets with their layout parameters
  - Animation widget usage (FadeSlide, ScaleBounce, etc.)
  - Icon names (Phosphor icon identifiers)
  - Text placeholders using `l10n.keyName` format
- [ ] **Visual description** (2-3 sentences per screen):
  - Overall layout approach
  - Key visual elements
  - Interaction patterns
- [ ] **Style guide** (global, not per screen):
  - Color palette (primary, secondary, background, surface, error, success)
  - Typography scale (headline, title, body, caption sizes)
  - Shape system (corner radii, border widths)
  - Shadow/elevation system
  - Spacing scale (small/medium/large gaps)
  - Button styles (primary, secondary, text, icon)
  - Card styles (padding, radius, borders)
  - Input styles (rounded, filled, outlined)

**Do NOT include:**
- Specific hex color values (provide semantic names instead)
- Exact pixel values (provide relative sizing)
- Platform-specific code
- Backend integration logic

---

## Quick Reference: All Files to Redesign

### Screens (32 files)
```
lib/screens/splash_screen.dart
lib/screens/main_shell.dart
lib/screens/onboarding/onboarding_screen.dart
lib/screens/force_update_screen.dart
lib/screens/onboarding/welcome_screen.dart
lib/screens/onboarding/native_language_screen.dart
lib/screens/onboarding/learning_language_screen.dart
lib/screens/onboarding/proficiency_screen.dart
lib/screens/onboarding/motivation_screen.dart
lib/screens/onboarding/commitment_screen.dart
lib/screens/onboarding/account_creation_screen.dart
lib/screens/onboarding/placement_test_screen.dart
lib/screens/learn/learn_screen.dart
lib/screens/learn/lesson_screen.dart
lib/screens/learn/lesson_complete_screen.dart
lib/screens/learn/post_learning_screen.dart
lib/screens/learn/vocabulary_review_screen.dart
lib/screens/chill/chill_screen.dart
lib/screens/chill/post_detail_screen.dart
lib/screens/profile/profile_screen.dart
lib/screens/profile/edit_profile_screen.dart
lib/screens/profile/settings_screen.dart
lib/screens/profile/stats_screen.dart
lib/screens/profile/achievements_screen.dart
lib/screens/profile/course_screen.dart
lib/screens/profile/study_plan_screen.dart
lib/screens/profile/friends_screen.dart
lib/screens/profile/subscription_screen.dart
lib/screens/profile/super_screen.dart
lib/screens/profile/help_support_screen.dart
lib/screens/ai/ai_conversation_screen.dart
lib/screens/paywall/paywall_modal.dart
```

### Widgets (6 files)
```
lib/widgets/animations.dart
lib/widgets/error_states.dart
lib/widgets/grammar_tip_overlay.dart
lib/widgets/lottie_loader.dart
lib/widgets/skeleton.dart
lib/widgets/streak_calendar.dart
```

### Theme (1 file)
```
lib/theme/app_theme.dart
```

**Total: 39 files to redesign.**
