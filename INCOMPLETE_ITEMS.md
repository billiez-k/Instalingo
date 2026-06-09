# InstaLingo v3 — Incomplete Items Report

**Branch:** `v3-instagram-redesign`  
**Latest Commit:** `34a006d` — "fix: remove dead code, add semantics, tokenize splash colors"  
**Date:** 2026-06-04  
**Total commits:** 3 (fa69579, 34a006d on top of earlier 2bef9c9 + 24afc4c)

---

## Completed (this session — 3 commits)

| # | Fix | Files |
|---|-----|-------|
| 1 | `name.split(' ')` crash with `.where(isNotEmpty)` | `chill_feed_screen.dart`, `post_detail_screen.dart` |
| 2 | TTS persistence via `SharedPreferences` (`TtsNotifier`) | `settings_provider.dart`, `tts_service.dart`, `settings_screen.dart` |
| 3 | `zh` locale fallback (bare `zh` → `zh_CN` + `zh_Hans`/`zh_Hant`) | `app_localizations.dart`, `locale_provider.dart` |
| 4 | Raw error exposure (replace `String? _loadError` with `bool _hasError`) | `swipe_screen.dart` |
| 5 | Corrupted user data (clear prefs instead of silent ignore) | `user_provider.dart` |
| 6 | TTS language fallback (`try-catch` around `setLanguage`) | `tts_service.dart` |
| 7 | Hardcoded achievement colors → `BusanHarborTokens.bronze/silver` | `achievements_screen.dart`, `app_theme.dart` |
| 8 | Duplicate `PostCardGradients` extracted to shared constant | `app_theme.dart`, `swipe_screen.dart`, `profile_screen.dart` |
| 9 | `const` constructors added to ~47 classes | 18 files (sed bulk) |
| 10 | `Semantics` widgets added to bottom nav, swipe cards, swipe actions, post detail action buttons, review rating buttons | `main_shell.dart`, `swipe_screen.dart`, `post_detail_screen.dart`, `review_screen.dart` |
| 11 | Dead `ads_provider.dart` deleted (zero imports) | delete |
| 12 | Splash screen hardcoded colors → `BusanHarborTokens` | `main.dart` |

---

## Items Not Completed (Requires Manual Follow-up)

### 1. Hardcoded Onboarding Content

**Files:** `lib/screens/onboarding/proficiency_screen.dart:24-29`, `lib/screens/onboarding/learning_goal_screen.dart`, `lib/screens/onboarding/commitment_screen.dart`, `lib/screens/onboarding/motivation_screen.dart`

**Issue:** Level descriptions, goal options, commitment durations, and motivation reasons are hardcoded English strings.

**Fix needed:** Add strings to all 8 localization files (`lib/l10n/app_localizations_*.dart`). Requires ~20 new getters × 9 files = ~180 string entries.

**Estimated effort:** 2-3 hours

### 2. Remaining Accessibility Semantics

**Not yet covered:**
- Icon buttons in headers (back, close, filter — in multiple screens)
- `_FilterChip`, `_CollectionCard` in `collections_screen.dart`
- `_FeatureItem` in `paywall_modal.dart`
- `_StreakDay` in `streak_calendar.dart`
- Settings toggles and menu items across multiple screens
- Onboarding next/back buttons
- Achievement badges

**Estimated effort:** 2-3 hours (touches ~10 screen files)

### 3. Potentially Dead / Stub Files

| File | Status |
|------|--------|
| `lib/providers/ads_provider.dart` | ✅ Deleted |
| `lib/providers/srs_provider.dart` | Self-reference only — likely stub, verify before deleting |
| `lib/providers/revenuecat_provider.dart` | Stub for in-app purchases — keep until IAP is implemented |
| `lib/data/card_data_loader.dart` | Referenced by 1 import — verify usage |

### 4. Missing Assets

`pubspec.yaml` references empty directories:
- `assets/images/`, `assets/icons/`, `assets/lottie/`, `assets/flags/`
- `assets/fonts/Inter-*.ttf`

Add real assets or remove pubspec references before production build.

### 5. Remaining Hardcoded Colors

| File | Line | Note |
|------|------|------|
| `swipe_screen.dart` | 419 | `Color(0xFF0A0A0A)` — card bottom bar, intentional design |
| `card_image_generator.dart` | 28-42 | `dart:ui` paint colors — low-level, not worth tokenizing |
| `post_image.dart` | 28-35 | Instagram-brand gradient colors — different design language, kept intentionally |

### 6. Cannot Verify (No Flutter SDK)

These checks MUST be done manually before merging:
1. `flutter analyze` — catch syntax errors, unused imports, type mismatches
2. `flutter test` — run existing test suite
3. `flutter build apk --debug` — verify clean compilation
4. Manual smoke test on device (all 4 tabs, flip cards, TTS toggle, zh locale switch)

---

## Summary

| Category | Done | Partial | Pending |
|----------|------|---------|---------|
| Crash fixes | 2/2 | — | — |
| Data persistence | 2/2 | — | — |
| Locale/i18n | 2/2 | — | — |
| Code quality (const/dedup/tokens) | 4/4 | — | — |
| Accessibility (Semantics) | 6 widgets | — | ~10 more |
| Dead code removal | 1 file | — | 1-3 files |
| Hardcoded content | — | — | onboarding (20+ strings × 9 files) |
| Missing assets | — | — | 5 directories |

