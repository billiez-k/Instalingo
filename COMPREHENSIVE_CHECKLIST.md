# InstaLingo — COMPREHENSIVE CHECKLIST

> **Last updated**: 2026-06-09  
> **Branch**: `claude-code-ver`  
> **Flutter**: 3.27.4 | **Dart**: 3.6.2  
> **Flutter analyze**: ✅ 0 errors, 0 warnings  
> **Status**: COMPILES CLEAN — ready for feature work

---

## HOW TO USE THIS FILE
- ✅ = Done, verified working
- ⬜ = Not started
- 🔶 = Partial / stub / needs work
- ❌ = Broken / needs fixing
- 🔁 = verify again after changes

**Before returning ANY task to the user, run `flutter analyze` and confirm 0 errors + 0 warnings.**

---

## 1. BUILD & COMPILATION

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1.1 | `flutter analyze` — 0 errors | ✅ | Verified 2026-06-09 |
| 1.2 | `flutter analyze` — 0 warnings | ✅ | Verified 2026-06-09 |
| 1.3 | `flutter pub get` succeeds | ✅ | intl pinned to ^0.19.0 |
| 1.4 | `flutter run -d chrome` compiles | 🔁 | Cannot verify in sandbox — user must confirm |
| 1.5 | `flutter build apk` works | 🔁 | Cannot verify in sandbox |
| 1.6 | `flutter build ios` works | 🔁 | Cannot verify in sandbox |
| 1.7 | `flutter build web` works | 🔁 | Cannot verify in sandbox |
| 1.8 | `flutter test` all pass | 🔁 | 6 test files exist, need runtime verification |
| 1.9 | `build_runner` codegen up to date | 🔁 | Run: `flutter pub run build_runner build --delete-conflicting-outputs` |

---

## 2. CORE ARCHITECTURE

| # | Item | Status | Notes |
|---|------|--------|-------|
| 2.1 | `main.dart` — entry point with ProviderScope | ✅ | Async gate pattern (localeReady + darkModeReady) |
| 2.2 | GoRouter — 19 routes configured | ✅ | ShellRoute for 4 tabs, errorBuilder for 404 |
| 2.3 | Riverpod — state management | ✅ | 7 providers, all functional |
| 2.4 | ScreenUtilInit — responsive design | ✅ | designSize: 390×844 |
| 2.5 | AppLocalizations — 301 keys × 7 locales | ✅ | All 2,107 strings verified present |
| 2.6 | BusanHarborTokens — design system | ✅ | Full color palette + M3 theme |
| 2.7 | Dark mode toggle | ✅ | Persisted via SharedPreferences |
| 2.8 | Locale switching | ✅ | 8 locales, auto-detection, RTL support |
| 2.9 | Onboarding gate | ✅ | `onboardingCompleteProvider` blocks main UI |

---

## 3. SCREENS — BY TAB

### 3.0 Splash & Onboarding (7 screens)

| # | Screen | Route | Status | Issues |
|---|--------|-------|--------|--------|
| 3.0.1 | SplashScreen | `/splash` | ✅ | Compass logo + wave animation |
| 3.0.2 | OnboardingScreen | `/onboarding` | ✅ | 3 feature bullets + CTA |
| 3.0.3 | NativeLanguageScreen | `/onboarding/native-language` | ✅ | 6 languages, radio tiles |
| 3.0.4 | LearningLanguageScreen | `/onboarding/learning-language` | ✅ | Japanese only + JLPT level |
| 3.0.5 | ProficiencyScreen | `/onboarding/proficiency` | 🔶 | Hardcoded English strings — needs localization |
| 3.0.6 | LearningGoalScreen | `/onboarding/learning-goal` | 🔶 | Hardcoded English strings — needs localization |
| 3.0.7 | MotivationScreen | `/onboarding/motivation` | 🔶 | Hardcoded English strings — needs localization |
| 3.0.8 | CommitmentScreen | `/onboarding/commitment` | 🔶 | Hardcoded English strings — needs localization |

### 3.1 Home Tab

| # | Item | Status | Notes |
|---|------|--------|-------|
| 3.1.1 | ChillFeedScreen — post feed | ✅ | Instagram-style, shimmer loading |
| 3.1.2 | Post cards — author, image, content, tags | ✅ | gradient backgrounds |
| 3.1.3 | Double-tap to like | ✅ | Heart animation on post images |
| 3.1.4 | Comments sheet | 🔶 | Display works; adding comments is fake (SnackBar only, no persistence) |
| 3.1.5 | Post → detail navigation | ✅ | `/post/:id` route |
| 3.1.6 | Post → linked word card | ❌ | `targetWordId` in model but not wired to `/swipe?wordId=...` |
| 3.1.7 | `isLiked` state sync feed↔detail | ❌ | Not synced between screens |

### 3.2 Review Tab

| # | Item | Status | Notes |
|---|------|--------|-------|
| 3.2.1 | ReviewScreen — SRS cards | ✅ | Full FSRS-5 integration |
| 3.2.2 | Again / Hard / Good / Easy buttons | ✅ | 4 rating levels |
| 3.2.3 | Progress bar | ✅ | |
| 3.2.4 | Empty state | ✅ | "All caught up" message |
| 3.2.5 | Review complete celebration | ✅ | |
| 3.2.6 | XP/gems awarded after review | 🔁 | Verify rewards are applied |

### 3.3 Collections Tab

| # | Item | Status | Notes |
|---|------|--------|-------|
| 3.3.1 | CollectionsScreen — saved words grid | ✅ | 2-column grid |
| 3.3.2 | Search filter | ✅ | |
| 3.3.3 | Level filter chips | ✅ | |
| 3.3.4 | Flip card to see meaning | ✅ | |
| 3.3.5 | Free tier limit (100 words) | ✅ | Shows upgrade prompt |
| 3.3.6 | Empty state | ✅ | |

### 3.4 Profile Tab

| # | Item | Status | Notes |
|---|------|--------|-------|
| 3.4.1 | ProfileScreen — masthead + stats + menu | ✅ | 618 lines, largest screen |
| 3.4.2 | Stats strip (streak/XP/gems/saved) | ✅ | |
| 3.4.3 | StatsScreen | 🔶 | Weekly chart is placeholder Container — not a real chart |
| 3.4.4 | AchievementsScreen | 🔶 | 12 hardcoded demo achievements, no persistence |
| 3.4.5 | SettingsScreen | ✅ | Dark mode, notifications, TTS, sound, language, locale |
| 3.4.6 | EditProfileScreen | ✅ | Name, email, daily goal, proficiency, language |
| 3.4.7 | HelpSupportScreen | ✅ | FAQ sections, email support link |
| 3.4.8 | "Course Path" menu | 🔶 | Navigates to `/collections` (placeholder — not a real course path feature) |
| 3.4.9 | "Study Plan" menu | 🔶 | Navigates to `/profile/stats` (placeholder — not a real study plan feature) |

### 3.5 Swipe (Card Learning)

| # | Item | Status | Notes |
|---|------|--------|-------|
| 3.5.1 | SwipeScreen — vertical card feed | ✅ | TikTok-style PageView |
| 3.5.2 | Save / Skip / Flip / Share actions | 🔶 | Share is no-op `() {}` |
| 3.5.3 | Heart animation on save | ✅ | |
| 3.5.4 | Progress bar | ✅ | |
| 3.5.5 | Card shuffle + filter (exclude alreadyKnew) | ✅ | |
| 3.5.6 | Daily goal tracking | ✅ | |
| 3.5.7 | DailyCompleteScreen | ✅ | Celebration with stats + share |
| 3.5.8 | DailyCompleteScreen share text | 🔶 | Uses 🎯 emoji — violates "ZERO emojis" policy |
| 3.5.9 | TutorialOverlay | ✅ | First 3 cards only |
| 3.5.10 | POS icon coverage | 🔶 | Only verb/noun/adj/adv — others fall to generic |
| 3.5.11 | Card hardcoded color | 🔶 | `Color(0xFF0A0A0A)` for bottom bar — should use theme |

### 3.6 Paywall

| # | Item | Status | Notes |
|---|------|--------|-------|
| 3.6.1 | PaywallModal — UI | ✅ | Feature list, annual/monthly toggle, price display |
| 3.6.2 | RevenueCat purchase flow | ❌ | **STUB** — CTA just calls `context.pop()`, no purchase |
| 3.6.3 | Prices | 🔶 | Hardcoded $59.99/$9.99 — not from RevenueCat offerings |
| 3.6.4 | Restore purchases | ❌ | Not implemented |
| 3.6.5 | Pro feature gating | 🔶 | `isProProvider` reads from user — no server validation |

### 3.7 Error/Edge Cases

| # | Item | Status | Notes |
|---|------|--------|-------|
| 3.7.1 | ErrorScreen | ✅ | Generic error display |
| 3.7.2 | 404 route handler | ✅ | GoRouter errorBuilder |
| 3.7.3 | Connectivity awareness | 🔶 | `connectivity_plus` declared but no offline UX |
| 3.7.4 | Data loading errors | 🔶 | CardDataLoader throws; no retry UI surfaced |

---

## 4. DATA MODELS

| # | Model | Status | Notes |
|---|-------|--------|-------|
| 4.1 | `LocalizedText` | ✅ | Multi-locale string with fallback |
| 4.2 | `VocabCard` | ✅ | fromJson with backward compat |
| 4.3 | `CardDeck` | ✅ | |
| 4.4 | `SRSData` | ✅ | FSRS scheduling fields |
| 4.5 | `UserProfile` | ✅ | 21 fields, copyWith, toJson/fromJson |
| 4.6 | `UserProfile.joinedAt` | 🔶 | Hardcoded to `DateTime(2026, 6, 1)` |
| 4.7 | `ChillPost` | ✅ | |
| 4.8 | `ChillComment` | ✅ | |
| 4.9 | `ChillCharacter` | ✅ | |
| 4.10 | `Achievement` | 🔶 | Missing `toJson`/`fromJson` — no persistence |
| 4.11 | `StreakRecord` enum | ✅ | completed, missed, shielded, todayPending, repaired |

---

## 5. PROVIDERS (State Management)

| # | Provider | Status | Notes |
|---|----------|--------|-------|
| 5.1 | `localeProvider` | ✅ | Locale state + SharedPreferences persistence |
| 5.2 | `darkModeProvider` | ✅ | Dark mode toggle + persistence |
| 5.3 | `soundEnabledProvider` | ✅ | Sound/haptic toggle |
| 5.4 | `ttsEnabledProvider` | ✅ | TTS toggle |
| 5.5 | `onboardingCompleteProvider` | ✅ | Onboarding gate |
| 5.6 | `userProvider` | ✅ | XP, gems, streak, words, achievements, pro |
| 5.7 | `vocabDeckProvider` | ✅ | Deck by level |
| 5.8 | `currentDeckProvider` | ✅ | User's current level deck |
| 5.9 | `cardByIdProvider` | ✅ | Card lookup |
| 5.10 | `srsProvider` | ✅ | SQLite-backed FSRS |
| 5.11 | `onboardingDataProvider` | ✅ | 7-step onboarding data |
| 5.12 | `isProProvider` | 🔶 | **STUB** — RevenueCat not integrated |
| 5.13 | `sharedPrefsProvider` | ✅ | SharedPreferences singleton |

---

## 6. SERVICES

| # | Service | Status | Notes |
|---|---------|--------|-------|
| 6.1 | `LanguageService` | ✅ | Locale + language orchestration |
| 6.2 | `SoundService` | ✅ | Haptic + system sound feedback |
| 6.3 | `TtsService` | ✅ | Device TTS for Japanese/Korean |
| 6.4 | `ShareService` | ✅ | Text sharing via share_plus |
| 6.5 | `FSRSScheduler` | ✅ | Full FSRS-5 with 16 trained weights |
| 6.6 | `CardDataLoader` | ✅ | JSON → CardDeck with cache |
| 6.7 | `ChillPostLoader` | ✅ | JSON → posts + characters |
| 6.8 | `NotificationService` | 🔶 | **PARTIAL** — Timer+SnackBar only; needs `flutter_local_notifications.zonedSchedule()` |
| 6.9 | `AdPoolManager` | ❌ | **STUB** — all no-ops, no AdMob loading |
| 6.10 | `CardImageGenerator` | 🔶 | **PARTIAL** — basic navy + word; missing gradient, labels, watermark, QR |
| 6.11 | `NotificationService` — background push | ❌ | Not implemented |
| 6.12 | `SoundService` — real audio | 🔶 | Uses `SystemSound` click; needs `audioplayers` + `.mp3` files |

---

## 7. LOCALIZATION (L10N)

| # | Item | Status | Notes |
|---|------|--------|-------|
| 7.1 | English (en) — 301 strings | ✅ | Complete |
| 7.2 | Arabic (ar) — 301 strings | ✅ | RTL-aware |
| 7.3 | Traditional Chinese (zh_TW) — 301 strings | ✅ | |
| 7.4 | Simplified Chinese (zh_CN) — 301 strings | ✅ | |
| 7.5 | Japanese (ja) — 301 strings | ✅ | |
| 7.6 | Korean (ko) — 301 strings | ✅ | |
| 7.7 | Malay (ms) — 301 strings | ✅ | |
| 7.8 | All `@override` annotations present | ✅ | Fixed 2026-06-09 (49 missing → all added) |
| 7.9 | Onboarding hardcoded strings | 🔶 | ~20 strings in Dart source (proficiency descriptions, goal options, motivation reasons, commitment durations) — not using AppLocalizations |
| 7.10 | `onboarding_exam*` identifiers | 🔶 | Use snake_case — should be camelCase per Dart conventions (info-level, not blocking) |
| 7.11 | `profile_*` identifiers | 🔶 | Use snake_case — should be camelCase (info-level, not blocking) |

---

## 8. ASSETS

| # | Asset | Status | Notes |
|---|-------|--------|-------|
| 8.1 | `assets/lottie/rocket.json` | ✅ | Present |
| 8.2 | `assets/lottie/points_completed.json` | ✅ | Present |
| 8.3 | `assets/lottie/daily_points.json` | ✅ | Present |
| 8.4 | `assets/images/` | ❌ | **EMPTY** — only `.gitkeep` |
| 8.5 | `assets/icons/` | ❌ | **EMPTY** — only `.gitkeep` |
| 8.6 | `assets/audio/` | ❌ | **EMPTY** — only `.gitkeep` |
| 8.7 | `assets/fonts/Inter-*.ttf` | ❌ | **MISSING** — directory has `.gitkeep` only; `fontFamily: 'Inter'` commented out in theme |
| 8.8 | `assets/flags/` | ❌ | **EMPTY** — not even in pubspec.yaml |
| 8.9 | `instalingo_content/japanese/n5/cards.json` | ✅ | 563 KB |
| 8.10 | `instalingo_content/japanese/n4/cards.json` | ✅ | 542 KB |
| 8.11 | `instalingo_content/japanese/n3/cards.json` | ✅ | 1.7 MB |
| 8.12 | `instalingo_content/japanese/n2/cards.json` | ✅ | 1.4 MB |
| 8.13 | `instalingo_content/japanese/n1/cards.json` | ✅ | 2.0 MB |
| 8.14 | `instalingo_content/shared/posts.json` | ✅ | Present |
| 8.15 | `instalingo_content/shared/characters.json` | ✅ | Present |

---

## 9. WIDGETS

| # | Widget | Status | Notes |
|---|--------|--------|-------|
| 9.1 | `FadeSlide` / `AnimatedBuilder` | ✅ | Delayed entrance animations |
| 9.2 | `ErrorState` / `EmptyState` | ✅ | Reusable error/empty states |
| 9.3 | `HarborAppBar` / `HarborSectionHeader` / `HarborListTile` | 🔶 | **Possibly dead code** — not used in current screens |
| 9.4 | `LottieLoader` / variants | ✅ | Lottie animation wrappers |
| 9.5 | `PostImage` | ✅ | Instagram-style gradient backgrounds |
| 9.6 | `SkeletonLine` / `SkeletonCard` / `SkeletonListItem` | ✅ | Shimmer loading placeholders |
| 9.7 | `StreakCalendar` | ✅ | 2-week streak grid |

---

## 10. CONTENT DATA

| # | Item | Status | Notes |
|---|------|--------|-------|
| 10.1 | N5 deck (~800 cards) | ✅ | |
| 10.2 | N4 deck (~700 cards) | ✅ | |
| 10.3 | N3 deck (~1,800 cards) | ✅ | |
| 10.4 | N2 deck (~1,800 cards) | ✅ | |
| 10.5 | N1 deck (~2,000 cards) | ✅ | |
| 10.6 | Chill Corner posts | ✅ | |
| 10.7 | Chill Corner characters | ✅ | |
| 10.8 | Demo fallback for missing JSON | 🔶 | English-only fallback; not localized |
| 10.9 | Card difficulty sorting | ✅ | Kanji detection + length-based |
| 10.10 | Topic field fallback | ✅ | Defaults to 'general' |

---

## 11. MONETIZATION (CRITICAL PATH)

| # | Item | Status | Notes |
|---|------|--------|-------|
| 11.1 | RevenueCat SDK declared | ✅ | `purchases_flutter: ^8.11.0` in pubspec |
| 11.2 | RevenueCat initialization | ❌ | Not configured — `isProProvider` is a stub |
| 11.3 | Paywall → purchase flow | ❌ | CTA button does nothing |
| 11.4 | Restore purchases | ❌ | Not implemented |
| 11.5 | Pro entitlement gating | ❌ | All features ungated |
| 11.6 | AdMob initialization | ❌ | `AdPoolManager` is all no-ops |
| 11.7 | Ad display (free tier) | ❌ | No ads shown anywhere |
| 11.8 | Ad-free for Pro users | ❌ | Not relevant until ads exist |

---

## 12. TESTS

| # | Item | Status | Notes |
|---|------|--------|-------|
| 12.1 | `widget_test.dart` — smoke test | ✅ | 1 test |
| 12.2 | `vocab_card_test.dart` | ✅ | fromJson, SRSData, CardDeck |
| 12.3 | `chill_post_test.dart` | ✅ | fromJson, ChillComment, ChillCharacter |
| 12.4 | `user_test.dart` | ✅ | fromJson, copyWith, defaults |
| 12.5 | `locale_provider_test.dart` | ✅ | Locale detection, parsing, RTL |
| 12.6 | `error_screen_test.dart` | ✅ | Widget rendering |
| 12.7 | Provider tests (user, srs, settings, vocab_deck, onboarding) | ⬜ | **NOT WRITTEN** |
| 12.8 | Screen widget tests (all 20 screens) | ⬜ | **NONE** except ErrorScreen |
| 12.9 | Integration tests (navigation, data flow) | ⬜ | **NONE** |
| 12.10 | L10n tests (all 301 keys × 7 locales) | ⬜ | **NOT WRITTEN** |
| 12.11 | FSRS scheduler tests | ⬜ | **NOT WRITTEN** |
| 12.12 | CardDataLoader tests | ⬜ | **NOT WRITTEN** |

---

## 13. DOCUMENTATION

| # | Item | Status | Notes |
|---|------|--------|-------|
| 13.1 | `AGENTS.md` | 🔶 | **Outdated** — references deleted `demo_data.dart` and `fl_chart` |
| 13.2 | `README.md` | 🔶 | Minimal 18-line intro — needs expansion |
| 13.3 | `COMPREHENSIVE_CHECKLIST.md` | ✅ | This file |
| 13.4 | `CODEBASE_CATALOG.md` | ✅ | Previous audit |
| 13.5 | `INCOMPLETE_ITEMS.md` | ✅ | Known incomplete work |
| 13.6 | API documentation | ⬜ | No backend API exists yet |
| 13.7 | Architecture diagram | ⬜ | Not created |

---

## 14. PLATFORM-SPECIFIC

| # | Item | Status | Notes |
|---|------|--------|-------|
| 14.1 | Android build config | 🔁 | `android/` directory exists, untested |
| 14.2 | iOS build config | 🔁 | `ios/` directory exists, untested |
| 14.3 | Web build config | 🔁 | `web/` directory exists, untested |
| 14.4 | Firebase Android config | 🔶 | `firebase_core` declared but likely not configured |
| 14.5 | Firebase iOS config | 🔶 | Same — no `GoogleService-Info.plist` verified |
| 14.6 | AdMob Android config | 🔶 | `google_mobile_ads` declared but not configured |
| 14.7 | AdMob iOS config | 🔶 | Same |

---

## 15. FUTURE FEATURES (NOT YET STARTED)

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 15.1 | Real backend / API | HIGH | All data is local JSON currently |
| 15.2 | User authentication | HIGH | No auth system |
| 15.3 | Cloud sync (cross-device) | MEDIUM | Depends on backend + auth |
| 15.4 | AI conversation practice | MEDIUM | String exists in UI but no implementation |
| 15.5 | Course path feature | MEDIUM | Menu item exists but routes to collections placeholder |
| 15.6 | Study plan feature | MEDIUM | Menu item exists but routes to stats placeholder |
| 15.7 | Real weekly XP chart | LOW | Placeholder Container in StatsScreen |
| 15.8 | Achievement persistence | MEDIUM | Demo data only, no save/load |
| 15.9 | Card image generator (full) | LOW | Basic navy+word only |
| 15.10 | More learning languages | MEDIUM | Currently Japanese only |
| 15.11 | Social features (real comments, likes) | LOW | Everything is local/demo |
| 15.12 | Push notifications (background) | MEDIUM | Only in-app SnackBar currently |
| 15.13 | Audio pronunciation files | LOW | TTS only; no bundled audio |
| 15.14 | Offline mode improvements | MEDIUM | JSON data works offline but no sync |
| 15.15 | Accessibility audit | LOW | Semantics widgets used but not audited |
| 15.16 | E2E testing | MEDIUM | No integration tests |

---

## 16. KNOWN BUGS / PAPER CUTS

| # | Bug | Severity | Notes |
|---|-----|----------|-------|
| 16.1 | Share action on swipe card is no-op | LOW | `() {}` at line ~415 of swipe_screen.dart |
| 16.2 | Post → word card navigation not wired | LOW | `targetWordId` exists in model, not used |
| 16.3 | Comment submission is fake | LOW | SnackBar only, no persistence |
| 16.4 | `isLiked` not synced feed↔detail | LOW | Like on detail doesn't reflect on feed |
| 16.5 | Emoji in share text | LOW | 🎯 in daily_complete_screen.dart line ~185 |
| 16.6 | Hardcoded card bottom bar color | LOW | `Color(0xFF0A0A0A)` — should use theme |
| 16.7 | POS icon incomplete coverage | LOW | Only verb/noun/adj/adv |
| 16.8 | `UserProfile.joinedAt` hardcoded | LOW | Always `DateTime(2026, 6, 1)` |
| 16.9 | HarborWidgets possibly dead code | LOW | Not used in any screen |

---

## 17. PUBSPEC DEPENDENCY AUDIT

| # | Dependency | Status | Notes |
|---|-----------|--------|-------|
| 17.1 | `flutter_riverpod` ^2.6.1 | ✅ | Used throughout |
| 17.2 | `go_router` ^14.8.1 | ✅ | 19 routes |
| 17.3 | `phosphor_flutter` (vendored) | ✅ | Icons |
| 17.4 | `flutter_screenutil` ^5.9.3 | ✅ | Responsive sizing |
| 17.5 | `intl` ^0.19.0 | ✅ | Pinned for flutter_localizations compat |
| 17.6 | `shared_preferences` ^2.5.3 | ✅ | Settings persistence |
| 17.7 | `sqflite` ^2.4.1 | ✅ | SRS database |
| 17.8 | `shimmer` ^3.0.0 | ✅ | Loading skeletons |
| 17.9 | `confetti` ^0.7.0 | ✅ | Celebration effects |
| 17.10 | `lottie` ^3.3.1 | ✅ | Animations |
| 17.11 | `cached_network_image` ^3.4.0 | ✅ | Post images |
| 17.12 | `flutter_tts` ^4.2.2 | ✅ | Text-to-speech |
| 17.13 | `share_plus` ^9.0.0 | ✅ | Social sharing |
| 17.14 | `url_launcher` ^6.2.6 | ✅ | External links |
| 17.15 | `connectivity_plus` ^6.0.3 | 🔶 | Declared but no connectivity UX |
| 17.16 | `http` ^1.2.1 | 🔶 | Declared but no API calls |
| 17.17 | `flutter_card_swiper` ^0.2.0 | 🔶 | **UNUSED** — swipe uses manual PageView.builder |
| 17.18 | `flutter_svg` ^2.2.0 | 🔶 | Declared but no SVG assets exist |
| 17.19 | `animations` ^2.0.11 | 🔶 | No package APIs used (custom animation code) |
| 17.20 | `flutter_local_notifications` ^17.2.4 | 🔶 | Declared but only in-app SnackBar used |
| 17.21 | `google_mobile_ads` ^5.3.1 | ❌ | Declared but AdPoolManager is all no-ops |
| 17.22 | `purchases_flutter` ^8.11.0 | ❌ | Declared but no RevenueCat integration |
| 17.23 | `firebase_core` ^2.32.0 | 🔶 | Declared but likely not configured |
| 17.24 | `firebase_analytics` ^10.10.7 | 🔶 | Declared but no analytics events |
| 17.25 | `firebase_crashlytics` ^3.5.7 | 🔶 | Declared but no crash reporting setup |

---

## 18. QUICK COMMANDS

```bash
# Verify everything is clean
cd /workspace/project/Instalingo
flutter pub get
flutter analyze          # Must show: "No issues found!" (or only 'info' level)
flutter test             # Run all tests

# Code generation (if models change)
flutter pub run build_runner build --delete-conflicting-outputs

# Build
flutter build apk        # Android
flutter build ios        # iOS (macOS only)
flutter build web        # Web
```

---

## LEGEND
- ✅ Complete & verified
- 🔶 Partial / needs work
- ❌ Broken / stub / not started
- ⬜ Not yet implemented (future)
- 🔁 Needs re-verification (can't test in sandbox)

**Total items**: 164 | ✅ 86 | 🔶 44 | ❌ 13 | ⬜ 10 | 🔁 11
