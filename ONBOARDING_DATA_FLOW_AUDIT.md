# Onboarding → App Settings: End-to-End Data Flow Audit

> **Question:** After onboarding, are the settings really applied to the app?  
> **Short answer:** Only 2 of 7 fields work correctly. 3 are completely lost. 2 are stored but broken.

---

## Complete Field-by-Field Trace

### 1. nativeLanguage

| Step | Detail |
|------|--------|
| **Collected in** | `native_language_screen.dart` — user taps a language tile |
| **Saved via** | `LanguageService.setNativeLanguage()` → `userProvider.notifier.updateProfile(nativeLanguage:)` → `UserProfile.copyWith(nativeLanguage:)` |
| **Persisted offline** | ✅ YES via `OfflineService.saveUser()` |
| **Consumed in** | `learn_screen.dart:65,119` — lesson/section titles translated to native language |
| | `lesson_screen.dart:48` — grammar tips & explanations in native language |
| | `chill_screen.dart:54,196,220,233` — post captions & word translations |
| | `post_detail_screen.dart:24,44,51,115,309,318,356` — word translations |
| | `settings_screen.dart:162,322` — language picker display |
| **Verdict** | ✅ **WORKS.** Content localization via `LocalizedText.resolve(nativeLang)` is consistent across all screens. |

---

### 2. learningLanguage

| Step | Detail |
|------|--------|
| **Collected in** | `learning_language_screen.dart` — user taps Japanese or Korean |
| **Saved via** | `LanguageService.setLearningLanguage()` → `userProvider.notifier.updateProfile(learningLanguage:)` |
| **Persisted offline** | ✅ YES via `OfflineService.saveUser()` |
| **Consumed in** | `course_provider.dart:15,25,36` — calls `DemoData.courseForLanguage(code)` → **core content driver** |
| | `post_provider.dart:22,43` — calls `DemoData.postsForLanguage(code)` → **chill corner driver** |
| | `profile_screen.dart:164` — displayed "KO A1" or "JA A1" in profile header |
| **Caveats** | ⚠️ Only `'ja'` (Japanese A1) and `'ko'` (Korean A1) have course data. Anything else silently falls back to Korean A1. |
| | ⚠️ No "language not available" error state — user sees wrong language content silently. |
| **Verdict** | ✅ **WORKS** (for ja/ko). Falls back silently for unsupported languages. |

---

### 3. proficiencyLevel — ❌ DECORATIVE ONLY

| Step | Detail |
|------|--------|
| **Collected in** | `proficiency_screen.dart` — user selects A1, A2, B1, B2, C1, or C2 |
| **Saved via** | `account_creation_screen.dart:53` → `data.proficiencyLevel ?? 'A1'` → `UserProfile.proficiencyLevel` |
| **Persisted offline** | ✅ YES |
| **Consumed in** | `profile_screen.dart:165` — displayed as "KO A1" or "JA B1" in profile header |
| | `edit_profile_screen.dart:154-159,226,235` — editable in settings |
| **Used to filter lesson difficulty?** | **NO.** |
| | `course_provider.dart:15` loads course **purely by language code**, not proficiency level |
| | No code in `CourseNotifier`, `lesson_screen.dart`, or any exercise evaluates `proficiencyLevel` |
| | **Only A1 course data exists** — no A2/B1/B2/C1/C2 content anywhere in the codebase |
| | Selecting "C2" during onboarding shows the same A1 content as selecting "A1" |
| **Verdict** | ❌ **BROKEN.** Collected but never used for its intended purpose. The CEFR scale is cosmetic only. |

---

### 4. dailyGoal — ⚠️ SAVED BUT PROGRESS BAR IS BROKEN

| Step | Detail |
|------|--------|
| **Collected in** | `commitment_screen.dart` — user picks 5, 10, 15, or 20 minutes/day |
| **Saved via** | `account_creation_screen.dart:54` → `data.dailyGoal ?? 15` → `UserProfile.dailyGoal` |
| **Persisted offline** | ✅ YES |
| **Consumed in** | `learn_screen.dart:430-431` — daily goal progress bar |
| | `settings_screen.dart:152-155,259,270` — editable picker |

**THE BUG — exact code at learn_screen.dart lines 430-431:**
```dart
final progress = (15 / user.dailyGoal).clamp(0.0, 1.0);
final xpNeeded = (user.dailyGoal - 15).clamp(0, user.dailyGoal);
```

**What this means for each daily goal setting:**

| Goal Set | Progress Shown | Reality |
|----------|---------------|---------|
| **5 min** | `15/5 = 300%` → clamped to 100% | ✅ **Always shows complete** even with zero lessons done. Looks correct but is lying. |
| **10 min** | `15/10 = 150%` → clamped to 100% | ✅ **Always shows complete** even with zero lessons. |
| **15 min** | `15/15 = 100%` | ✅ **Accidentally correct** — only time it coincidentally works. |
| **20 min** | `15/20 = 75%` | ❌ **Always shows 75%** — never reaches 100% no matter how many lessons you do. |

**Root cause:** The `15` is a hardcoded literal, not actual XP earned today. The code never tracks how many lessons the user completed today.

**Verdict** | ❌ **BROKEN.** The only screen that uses `dailyGoal` has a hardcoded numerator. |

---

### 5. motivations — ❌ COMPLETELY DEAD DATA

| Step | Detail |
|------|--------|
| **Collected in** | `motivation_screen.dart` — user picks career, travel, study abroad, culture, etc. (multi-select) |
| **Saved via** | `account_creation_screen.dart:55` → `data.motivations.isNotEmpty ? data.motivations : null` |
| **Persisted offline** | ❌ **NO** — `OfflineService.saveUser()` omits `motivations` from its JSON map |
| **Consumed after onboarding** | **NOWHERE.** Zero consumption sites in the entire codebase. |
| | `grep -r "motivations" lib/` only finds: model definition, copyWith, onboarding provider, account_creation_screen flush |
| | Not shown in profile. Not used for recommendations. Not used for content filtering. |
| **Verdict** | ❌ **DEAD DATA.** Collected at significant UX cost (user spends a full screen picking motivations) then never referenced again. |

---

### 6. learningGoal (exam vs fun) — ❌ LOST FOREVER

| Step | Detail |
|------|--------|
| **Collected in** | `learning_goal_screen.dart` — user picks "Exam Prep" or "Just for Fun" |
| **Saved via** | **NOTHING.** `UserProfile` has no `learningGoal` field. `account_creation_screen.dart:50-56` does NOT include `learningGoal` in the `updateProfile()` call. |
| **Persisted offline** | ❌ NO |
| **Only used during onboarding** | `learning_goal_screen.dart:67-68` — routes to exam-type if `LearningGoal.exam` |
| | `commitment_screen.dart:41` — step counter display |
| | `onboarding_provider.dart:25` — `totalSteps` getter (8 for exam, 7 for fun) |
| **Consumed after onboarding** | **NOWHERE.** The app has no idea whether the user chose "exam prep" or "fun" once they reach `/learn`. |
| **Verdict** | ❌ **LOST.** The user's primary learning goal is thrown away after onboarding. |

---

### 7. examType (JLPT N5, JLPT N4, TOPIK I) — ❌ LOST FOREVER

| Step | Detail |
|------|--------|
| **Collected in** | `exam_type_screen.dart` — user taps an exam card |
| **Saved via** | **NOTHING.** `UserProfile` has no `examType` field. |
| **Persisted offline** | ❌ NO |
| **Only used during onboarding** | `exam_type_screen.dart:40,62,66` — display only |
| **Consumed after onboarding** | **NOWHERE.** The mock test screen reads exam type from URL parameter, not from user profile. |
| | User must manually navigate to `/mock-test/jlpt_n5` via URL — there's no button, no shortcut, no saved preference. |
| **Verdict** | ❌ **LOST.** The exam the user registered to prepare for is thrown away. |

---

## Summary: Only 2 of 7 Work

| # | Field | Saved? | Persisted? | Used? | Verdict |
|---|-------|--------|------------|-------|---------|
| 1 | **nativeLanguage** | ✅ | ✅ | ✅ Content localization | **WORKS** |
| 2 | **learningLanguage** | ✅ | ✅ | ✅ Course + post loading | **WORKS** (only ja/ko) |
| 3 | **proficiencyLevel** | ✅ | ✅ | ❌ Display only — never filters difficulty | **BROKEN** (no A2–C2 content exists) |
| 4 | **dailyGoal** | ✅ | ✅ | ⚠️ Progress bar hardcodes `15` XP | **BROKEN** (see bug above) |
| 5 | **motivations** | ✅ | ❌ Not in OfflineService | ❌ Zero consumption sites | **DEAD DATA** |
| 6 | **learningGoal** | ❌ No field in model | ❌ | ❌ | **LOST FOREVER** |
| 7 | **examType** | ❌ No field in model | ❌ | ❌ | **LOST FOREVER** |

---

## The Real Cost of Each Bug

### Lost learningGoal + examType (Items 6 & 7)
The app collects whether the user wants exam prep or casual learning, and which exam they're targeting. Then it throws this away. Consequences:
- The learn dashboard cannot prioritize exam-relevant content
- The mock test screen has no "take your exam" shortcut
- The app cannot send exam-countdown notifications
- Chill Corner cannot suggest exam-study posts vs fun posts

### Lost motivations (Item 5)
The user spends a full screen selecting motivations (career, travel, culture, etc.). This data is stored in UserProfile but never read by any screen. Consequences:
- No personalized content recommendations
- No motivation-based onboarding personalization
- No way to track "are we meeting the user's goals?"

### Broken dailyGoal (Item 4)
The daily goal progress bar is the first thing the user sees on the learn screen. Showing 75% when they've done zero lessons (goal=20) or 100% when they've done zero (goal=5) erodes trust in the app's gamification system.

### Broken proficiencyLevel (Item 3)
The user selects their level (A1–C2) but all content is A1. An intermediate learner selecting B1 will find all lessons trivially easy. An advanced learner selecting C2 will be bored by beginner content. This will cause rapid churn.

---

## Recommended Fixes

### Phase 1 — Stop Losing Data
1. Add `learningGoal` and `examType` fields to `UserProfile` model
2. Save them in `account_creation_screen.dart:_flushOnboardingData()`
3. Add them to `OfflineService.saveUser()` / `loadUser()`
4. Add `motivations` to `OfflineService.saveUser()` / `loadUser()`

### Phase 2 — Fix Broken Features
5. Fix `learn_screen.dart:430-431` — track actual XP earned today instead of hardcoding `15`
6. Create course content for A2–C2 levels, or at minimum filter lessons by user's proficiency
7. Wire up motivations to something visible (profile display, content recommendations)
8. Add "Take Mock Exam" button on learn dashboard that uses saved `examType`

### Phase 3 — Data Integrity
9. Add data migration path for users who already onboarded without these fields
10. Add validation in OfflineService to detect missing fields in stored data
