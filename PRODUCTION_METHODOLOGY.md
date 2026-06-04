# InstaLingo — Production Ship Methodology

**Generated:** 2026-05-30 (Updated after 42 fixes applied)
**Current State:** Content 100% ready. App skeleton cleaned. ~222 functional/UX issues remain. Backend = 0%.

---

## Issue Status After Our Work

| Severity | Was | Fixed | Partial | Remaining | Nature of Remaining |
|----------|-----|-------|---------|-----------|---------------------|
| 🔴 Critical | 18 | 10 | 2 | 6 | Firebase, IAP, AI, tests |
| 🟠 High | 47 | 22 | 15 | 10 | Demo data→real, exercise models, Riverpod config |
| 🟡 Medium | 80 | 10 | 0 | 70 | Flag images, placeholder assets, empty states |
| 🟢 Low | 140 | 0 | 0 | 140 | Lint warnings (`dart fix --apply`) |
| **Total** | **285** | **42** | **17** | **226** | |

## What We Fixed (Entire Session — Content + Code)

| What | Status |
|------|--------|
| All 8-locale content (titles, descriptions, grammar) | ✅ |
| ARB: 554 keys × 8 locales, 0 missing, 0 empty, 0 placeholder mismatches | ✅ |
| English leaks: 0 hardcoded, 0 "Lesson N", 0 "Learn:" | ✅ |
| zh/zh_TW separation: OpenCC s2t on all strings | ✅ |
| Mock tests: 75 questions, JLPT N4 answers fixed | ✅ |
| Content JSON: 16,280 locale slots, 0 empty | ✅ |
| Onboarding: exam/fun fork, dynamic step counters | ✅ |
| TTS: flutter_tts, auto-detect language, 4 screens | ✅ |
| Validator: exit 0, 5 automated rules | ✅ |
| Banned courses deleted (fr/es/de/en/zh) | ✅ |
| Achievement model: LocalizedText, zh_TW resolve fix | ✅ |
| 9 artificial delays → Duration.zero | ✅ |
| HapticFeedback: Web crash fixed | ✅ |
| Match pairs + flashcard + phrase builder: scoring added | ✅ |
| Lesson bounds check + division-by-zero guard | ✅ |
| Settings layout crash fixed | ✅ |
| Account validation added | ✅ |
| Build config: Android app ID, web manifest, assets, gitignore | ✅ |
| Course provider: idempotent guard | ✅ |
| Chill Corner: 2 crash guards | ✅ |
| Exam type: dead-end fixed | ✅ |
| Kanji labels: l10n instead of hardcoded English | ✅ |

## What REMAINS — Production Phase Plan

### Phase 1: Critical Blocker Fixes (Week 1-2, ~40 hours)

These must be done before any App Store submission.

#### 1.1 Build Configuration
- Change `applicationId` from `com.example.instalingo` to `com.instalingo.app`
- Set up release signing keys for Android (keystore)
- Set iOS bundle identifier and development team
- Fix web manifest: replace Flutter blue with Busan Harbor colors, update description

#### 1.2 Backend / Auth (MINIMUM VIABLE)
- **Firebase Auth** for email + Google/Apple sign-in
- **Cloud Firestore** for user profiles, course progress, learned words
- Replace `SharedPreferences` persistence with Firestore sync
- Keep offline fallback (offline_service already has the structure)

#### 1.3 Fix Runtime Crashes
- Sound service: wrap HapticFeedback in try/catch for web
- ProviderScope.containerOf → use `ref.watch` in Consumer widgets instead (kana_screen, kanji_screen)
- Bounds check on _currentIndex in lesson_screen (empty exercises guard)
- Match pairs exercise: implement actual answer verification
- Course provider: idempotent completeLesson (check if already completed)

#### 1.4 Build Fixes
- Fix missing asset directories (assets/images/, assets/icons/, assets/flags/)
- Remove or create `assets/lottie/rocket.json`
- Remove `demo_data.dart.bak` from tracking
- Fix Kotlin version or find compatible AGP version

### Phase 2: Functional Completeness (Week 3-4, ~40 hours)

#### 2.1 Exercise Scoring
- FlashCard: track flip count, not just "flipped"
- Phrase Builder: compare against correctAnswerList
- Dialogue: implement scoring logic
- Writing: enable submit button, compare against sample answer
- Speaking: integrate speech recognition (or remove exercise type for v1)

#### 2.2 Remove Skeleton Code
- Delete artificial loading delays (1.2s splash, 1.2s learn, 1.5s chill, 800ms lesson)
- Replace hardcoded vocabulary review words with actual course vocabulary
- Replace hardcoded stats (12 lessons, 32 words, 4h32m) with real computed values
- Replace 5 fake friends with empty state or real data
- Replace hardcoded daily goal (35%) with actual progress

#### 2.3 Real Features
- **Notifications:** Switch from 30s timer to `flutter_local_notifications` with scheduled reminders. Localize the notification text
- **Placement test:** Replace English questions with Japanese/Korean CEFR-aligned questions. Persist the result
- **Subscription/Paywall:** Integrate RevenueCat or in_app_purchase for real IAP
- **AI Chat:** Wire to actual LLM API (OpenAI/Claude) with language-learning prompt

#### 2.4 Localization Fixes
- Kanji tab labels: "JLPT N5"/"JLPT N4" → l10n keys
- Notification snackbar: hardcoded English → l10n
- `.toUpperCase()` calls on l10n strings → remove or use locale-aware uppercase

### Phase 3: UX Polish (Week 5-6, ~30 hours)

#### 3.1 Empty States & Error Recovery
- Exam type screen: replace SizedBox.shrink() dead-end with proper error state + back navigation
- OfflineService: add try/catch with partial recovery on data corruption
- Add mounted checks before context.go() in all async callbacks

#### 3.2 Asset Replacement
- Replace flag codes (CN, TW, JP, KR) with actual flag images or emoji flags
- Replace placeholder user avatar with generated initials avatar
- Add actual course thumbnail images

#### 3.3 Navigation
- Route constants: define all paths as named constants
- Add back-button confirmation dialogs on onboarding screens
- Fix paywall route (it's a modal, not a route)

### Phase 4: Testing & Store Submission (Week 7-8, ~20 hours)

#### 4.1 Testing
- Write integration tests for onboarding flow
- Write unit tests for course_provider, user_provider, post_provider
- Test on real Android device, iOS device, Chrome
- Test all 8 locales end-to-end
- Test offline mode

#### 4.2 Store Preparation
- App Store screenshots (6.5" and 5.5" for iOS, multiple sizes for Android)
- App Store description in all 8 locales
- Privacy policy URL
- Terms of service
- App Store Connect / Google Play Console setup

#### 4.3 Performance
- Split demo_data.dart into per-language files (625KB is too large)
- Lazy-load course content instead of importing all at startup
- Profile with Flutter DevTools for jank

### Phase 5: Post-Launch (Ongoing)

- **More exam content:** HSK 1-3 for Chinese, TOPIK II for Korean, JLPT N3-N1 for Japanese
- **European languages:** Add back one at a time with native-speaker content verification
- **Google Cloud TTS WaveNet:** Replace device TTS with studio-quality voices
- **FSRS spaced repetition:** Integrate `fsrs` package for optimal review scheduling
- **Social features:** Real friend lists, leaderboards
- **Push notifications:** Real push, not timer-based

---

## Immediate Quick Wins (Today, ~4 hours)

These are low-effort, high-impact fixes that make the app feel less broken:

1. **Remove artificial delays** — delete all `await Future.delayed(Duration(seconds: ...))` calls
2. **Fix TTS language** — detect language from course context, not hardcoded ko-KR
3. **Fix kanji tab labels** — use l10n instead of hardcoded "JLPT N5"/"JLPT N4"
4. **Fix sound service web crash** — wrap HapticFeedback in try/catch
5. **Fix ProviderScope.containerOf** — use Consumer widgets in kana/kanji screens
6. **Add bounds check** in lesson_screen for empty exercises
7. **Remove demo_data.bak** from git tracking
8. **Fix exam_type dead-end spinner** — add proper error state with back button
9. **Fix course_provider double-count** — check if lesson already completed
10. **Wrap matchPairs** onComplete to verify actual matches

---

## Total Effort Estimate

| Phase | Time | Cost (solo) | Cost (hire) |
|-------|------|-------------|-------------|
| 1: Critical fixes | 2 weeks | $0 | $2,000-4,000 |
| 2: Functional completeness | 2 weeks | $0 | $2,000-4,000 |
| 3: UX polish | 2 weeks | $0 | $1,500-3,000 |
| 4: Testing & Store | 2 weeks | $0 | $1,000-2,000 |
| **Total to App Store** | **8 weeks** | **$0** | **$6,500-13,000** |

---

## Minimum Viable Ship (4 Weeks)

If you want to ship faster, cut scope to:

1. Fix build config (day 1)
2. Fix crashes (day 2-3)
3. Remove skeleton code (day 4-5)
4. Add Firebase Auth + Firestore (week 2)
5. Quick wins from above (sprinkled in)
6. Test on real devices (week 3)
7. Store screenshots + listing (week 4)

This gives you a working app with real auth, real progress sync, no crashes, no skeleton delays, and correct exercise scoring. IAP, AI chat, notifications, and social features can wait for v1.1.

---
*See PRODUCTION_FILESYSTEM_AUDIT.md for per-file status and implementation priority.*
