# InstaLingo — Complete Filesystem Production Audit

**Date:** 2026-05-30
**Purpose:** Every file, every function, every data path — what's production-ready and what needs work.

---

## 1. MODELS (lib/models/) — 6 files

| File | Status | Issues |
|------|--------|--------|
| `user.dart` | ✅ **FIXED** | Added learningGoal, examType, motivations persistence |
| `course.dart` | ✅ Clean | 15 ExerciseType enum, LocalizedText metadata |
| `achievement.dart` | ✅ **FIXED** | String→LocalizedText, zh_TW resolution |
| `localized_text.dart` | ✅ Clean | zh_TW independent, no zh fallback |
| `post.dart` | ✅ Clean | LocalizedText content |
| `character.dart` | ✅ Clean | AI character model |

## 2. PROVIDERS (lib/providers/) — 6 files

| File | Status | Issues |
|------|--------|--------|
| `user_provider.dart` | ✅ **FIXED** | Added learningGoal, examType to updateProfile |
| `course_provider.dart` | ✅ **FIXED** | Idempotent completeLesson, default course return |
| `onboarding_provider.dart` | ✅ Clean | LearningGoal enum, totalSteps getter |
| `settings_provider.dart` | ⚠️ | SoundService recreated every read — needs keepAlive |
| `locale_provider.dart` | ✅ Clean | zh_TW detection working |
| `post_provider.dart` | ✅ Clean | Posts filtered by learnedWords |

## 3. SERVICES (lib/services/) — 5 files

| File | Status | Issues |
|------|--------|--------|
| `tts_service.dart` | ✅ **FIXED** | Auto-detect language, lazy initialization |
| `sound_service.dart` | ✅ **FIXED** | HapticFeedback wrapped for web |
| `offline_service.dart` | ✅ **FIXED** | learningGoal, examType, motivations persisted |
| `notification_service.dart` | ⚠️ **PARTIAL** | Timer-based, English text — needs real push + l10n |
| `language_service.dart` | ✅ Clean | Synchronous locale update |

## 4. SCREENS — ONBOARDING (11 files)

| File | Status | Issues |
|------|--------|--------|
| `onboarding_screen.dart` | ✅ Clean | Hero landing page |
| `welcome_screen.dart` | ✅ Clean | Feature showcase |
| `native_language_screen.dart` | ✅ Clean | 8-language grid, dynamic step counter |
| `learning_language_screen.dart` | ✅ **FIXED** | Only ja/ko, subtitle field renamed |
| `learning_goal_screen.dart` | ✅ Clean | Exam/fun fork, dynamic step counter |
| `exam_type_screen.dart` | ✅ **FIXED** | Dead-end spinner→error state, l10n exam labels |
| `proficiency_screen.dart` | ⚠️ | Data collected but no A2-C2 content exists |
| `motivation_screen.dart`| ✅ **FIXED** | Data now persisted to UserProfile |
| `commitment_screen.dart` | ✅ Clean | Dynamic step counter |
| `account_creation_screen.dart` | ✅ **FIXED** | Saves all 7 fields, email validation, maxLength |
| `placement_test_screen.dart` | ❌ | English questions — needs rewrite for JP/KO |

## 5. SCREENS — LEARN (6 files)

| File | Status | Issues |
|------|--------|--------|
| `lesson_screen.dart` | ✅ **FIXED** | Bounds check, match pairs scoring, flashcard tracking, delay removed |
| `learn_screen.dart` | ✅ **FIXED** | Daily goal uses real XP, l10n.levelAbbreviation, delay removed |
| `mock_test_screen.dart` | ✅ **FIXED** | languageCode→toString(), JLPT N4 answers fixed |
| `lesson_complete_screen.dart` | ⚠️ | Hardcoded practiced words — tagged for replacement |
| `post_learning_screen.dart` | ✅ Clean | Post-lesson branching |
| `vocabulary_review_screen.dart` | ❌ | Hardcoded English words — needs course vocabulary wiring |

## 6. SCREENS — REFERENCE (2 files)

| File | Status | Issues |
|------|--------|--------|
| `kana_screen.dart` | ✅ **FIXED** | ConsumerWidget, TTS on tap, no dakuten |
| `kanji_screen.dart` | ✅ **FIXED** | ConsumerWidget, TTS on tap, l10n tab labels |

## 7. SCREENS — PROFILE (11 files)

| File | Status | Issues |
|------|--------|--------|
| `profile_screen.dart` | ✅ **FIXED** | l10n.levelAbbreviation |
| `settings_screen.dart` | ✅ **FIXED** | Layout crash fixed, TTS toggle added |
| `achievements_screen.dart` | ✅ **FIXED** | LocalizedText.resolve(toString()) |
| `stats_screen.dart` | ❌ | Hardcoded numbers — needs real data computation |
| `course_screen.dart` | ✅ Clean | Only ko/ja shown |
| `friends_screen.dart` | ❌ | 5 fake users — needs real social features |
| `subscription_screen.dart` | ❌ | No IAP integration — decorative only |
| `super_screen.dart` | ❌ | Marketing only — no backend |
| `study_plan_screen.dart` | ⚠️ | Completion not persisted |
| `edit_profile_screen.dart` | ✅ Clean | Editable profile fields |
| `help_support_screen.dart` | ✅ Clean | Accordion FAQ |

## 8. SCREENS — OTHER (5 files)

| File | Status | Issues |
|------|--------|--------|
| `main_shell.dart` | ✅ Clean | Bottom nav, notification lifecycle |
| `splash_screen.dart` | ✅ **FIXED** | Delay removed |
| `force_update_screen.dart` | ✅ Clean | Functional |
| `ai_conversation_screen.dart` | ❌ | Fake AI — returns l10n string, no LLM call |
| `paywall_modal.dart` | ❌ | Decorative modal — no IAP |

## 9. DATA (lib/data/) — 2 files

| File | Status | Issues |
|------|--------|--------|
| `demo_data.dart` | ✅ Clean | 2 courses, 659 exercises, all 8 locales |
| `exam_content.dart` | ✅ **FIXED** | 75 questions, JLPT N4 answers fixed |

## 10. LOCALIZATION (lib/l10n/) — 17 files

| File | Status | Issues |
|------|--------|--------|
| 8 ARB files | ✅ Clean | 554 keys × 8 locales, 0 missing, 0 empty |
| 9 Generated Dart files | ✅ Clean | Generated from ARB |

## 11. CONTENT JSON (instalingo_content/) — 30 files

| Directory | Status | Issues |
|-----------|--------|--------|
| korean/ | ✅ Clean | TOPIK I: 300 vocab, 40 grammar, 290 sentences, 25 mock |
| japanese/ | ✅ Clean | JLPT N5+N4: 1,395 vocab, 85 grammar, 300 sentences, 50 mock |
| shared/ | ✅ Clean | UI translations, achievements |

---

## SUMMARY: Overall ~65% Production-Ready

| Layer | Ready | Remaining Work |
|-------|-------|----------------|
| Content | 100% | Nothing |
| Localization | 100% | Nothing |
| Onboarding data flow | 100% | **FIXED** — all 7 fields now saved + persisted |
| Exercise scoring | 75% | Dialogue/Writing need data model changes |
| App screens | 60% | Stats, friends, vocabulary review still fake data |
| Backend | 0% | Firebase Auth + Firestore needed |
| IAP | 0% | RevenueCat or in_app_purchase needed |
| AI | 0% | LLM API integration needed |
| Notifications | 20% | Timer-based placeholder — needs real push |
| Tests | 5% | 1 broken widget test — needs full test suite |
| Design assets | 20% | Placeholder images, flag codes as text |

## Priority Implementation Order

1. **Firebase Auth + Firestore** (backend foundation) — 1 week
2. **RevenueCat / IAP** (monetization) — 3 days
3. **Real push notifications** (engagement) — 2 days
4. **Replace fake data** (stats, friends, vocab review) — 1 week
5. **AI chat** (LLM API) — 3 days
6. **Tests** (integration + unit) — 1 week
7. **Design assets** (images, flags, avatars) — 1 week
8. **App Store submission** (screenshots, listing, privacy policy) — 3 days

**Total to App Store: ~5 weeks of focused work.**
