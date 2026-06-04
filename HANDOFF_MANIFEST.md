# INSTALINGO HANDOFF MANIFEST — Read This First

> **To the AI agent:** This zip contains a complete Flutter language-learning app project. Your job: audit all English-language leaks, then rebuild course content as exam-focused prep material (HSK, TOPIK, JLPT). The master instruction file is `AI_CONTENT_PIPELINE_PROMPT.md` — read it after this manifest.

---

## WHAT THIS PROJECT IS

InstaLingo = mobile app (Flutter/Dart) for Chinese, Korean, Japanese exam prep.
Currently has 7 courses (zh/ko/ja/fr/es/de/en) with widespread English leakage in non-English courses.
The developer is narrowing to 3 languages (zh/ko/ja) + exam modes (HSK, TOPIK, JLPT).

---

## FILE MAP — What Everything Is

### ⭐ PRIMARY INSTRUCTION FILE (read second, after this manifest)
| File | Purpose |
|------|---------|
| `AI_CONTENT_PIPELINE_PROMPT.md` | Complete task spec: schemas, sources, validation rules, execution order, output format |

### 📋 AUDIT & PLANNING DOCS (context — read to understand what's broken)
| File | Purpose |
|------|---------|
| `ENGLISH_LEAKAGE_AUDIT.md` | Full audit of all English leaks found. Lists exact line numbers, counts, and fix plan. |
| `Instalingo Raw Data Source Manifest.md` | Where all current data came from (Tatoeba, HSK/TOPIK/JLPT lists, grammar wikis) |
| `PEDAGOGICAL_AUDIT.md` | Issues with vocabulary sequencing and content quality |
| `HONEST_VERIFICATION.md` | Assessment of what AI can/cannot verify |
| `CONTENT_WORKFLOW.md` | Content generation workflow documentation |
| `CONTENT_ACQUISITION_GUIDE.md` | Detailed content acquisition guide with search queries per language |
| `validation_report.json` | Validation results from the raw data package |

### 🔧 DART SOURCE CODE (the app itself)
| File | Purpose | ⚠️ Issues |
|------|---------|-----------|
| `lib/data/demo_data.dart` | ALL course content (30,499 lines). 7 courses, exercises, vocabulary, grammar. | **MAJOR: 1,700+ English leaks across all non-English courses. Lesson titles are "Lesson N" in all locales. "Learn:" prefix in English. Grammar rules have English body text in ko/ja/zh. ko explanations have English words (~300).** |
| `lib/models/course.dart` | Course, Section, Lesson, Exercise, ExerciseType, WordPair, DialogueTurn classes | Exercise types defined here. `question`/`options`/`correctAnswer` are plain String (not LocalizedText) — architectural limitation. |
| `lib/models/localized_text.dart` | The LocalizedText model — 8-locale map with `resolve()` method | Used for all user-visible metadata. Falls back to English if locale missing. |
| `lib/models/achievement.dart` | Achievement model | **BUG: Uses plain `String title` and `String description` instead of `LocalizedText`. All 6 achievements show English to ALL users.** |
| `lib/l10n/app_en.arb` | English UI strings (192 keys) | Reference file |
| `lib/l10n/app_zh.arb` | Chinese UI strings | 2 intentional untranslated keys (aiBadge, aiAssistantName) |
| `lib/l10n/app_zh_TW.arb` | Traditional Chinese UI strings | Same 2 as zh |
| `lib/l10n/app_ko.arb` | Korean UI strings | **3 untranslated keys (aiBadge, profile_instalingoSuperFAQ, profile_superBadge) + 2 extra keys (super, superMarket) with English values NOT in en.arb** |
| `lib/l10n/app_ja.arb` | Japanese UI strings | **Same issues as ko** |
| `lib/l10n/app_es.arb` | Spanish UI strings | 6 untranslated keys |
| `lib/l10n/app_fr.arb` | French UI strings | **18 untranslated keys (worst)** |
| `lib/l10n/app_de.arb` | German UI strings | 12 untranslated keys |
| `lib/screens/learn/lesson_screen.dart` | Main lesson screen | **Line 1285: Hardcoded English `"Tap a word on the left, then its match on the right"`** |
| `lib/screens/learn/learn_screen.dart` | Learn hub screen | **Line 633: Hardcoded English `"LV $value"`** |
| `lib/services/language_service.dart` | 3-dimension language separation (UI, instruction, target) | |
| `lib/providers/locale_provider.dart` | Locale detection (zh/zh_TW split, device auto-detect) | |

### 🐍 PYTHON TOOLCHAIN (how JSON becomes Dart code)
| File | Purpose |
|------|---------|
| `tools/json_to_dart.py` | Converts JSON course files → Dart code. Reads LocalizedText dicts, Exercise objects, etc. |
| `tools/build_courses_from_raw.py` | Builds course structure from raw vocabulary/sentence/grammar JSON |
| `tools/data_pipeline.py` | Data processing pipeline |
| `tools/generate_content.py` | Exercise generation from structured data |
| `tools/fix_translations.py` | Translation fixing utilities |
| `tools/verify_e2e.py` | End-to-end validation script |
| `tools/translation_pipeline.py` | Translation workflow |
| `tools/restructure_localized_content.py` | Content restructuring |
| `tools/rewrite_posts.py` | Chill Corner post utilities |
| `tools/add_vocabulary.py` | Vocabulary addition utilities |

### 📦 RAW DATA & GOLDEN EXAMPLES
| Path | Purpose |
|------|---------|
| `manus_output/` | Raw acquisition outputs, golden examples, Tatoeba samples, pipeline results |
| `manus_output/golden/` | Golden example course JSON files |
| `manus_output/raw/` | Raw source data (vocab CSVs, sentence CSVs, grammar JSONs) |

---

## 🔴 KNOWN ENGLISH LEAKS — Complete Inventory

### CRITICAL (blocks app from being non-English)
| # | Location | Problem | Count | Fix |
|---|----------|---------|-------|-----|
| 1 | `demo_data.dart` — all lesson titles | `"Lesson N"` in ALL 8 locales for ko/ja/zh courses | 84 | ko→"N과", ja→"第N課", zh→"第N课" |
| 2 | `demo_data.dart` — all lesson descriptions | `"Learn: ..."` prefix in English for ALL locales | 84 | ko→"배우기:", ja→"学習:", zh→"学习:" |
| 3 | `demo_data.dart` — all grammarRule fields | Body text is English in ko/ja/zh locales. Only the label (문법/文法/语法) is translated. | ~60 | Translate each rule body into ko/ja/zh |
| 4 | `demo_data.dart` — explanation fields in ko/ja | English words embedded in Korean/Japanese text. e.g. `"'개나리'의 의미는 'forsythia'입니다."` | ~300 | Replace English words with Korean/Japanese equivalents |
| 5 | `demo_data.dart` — 6 ko translateSentence | English multiple-choice options in Korean course exercises | 6 | Replace with Korean translations |
| 6 | `demo_data.dart` — grammar examples | `"→ English"` in grammar examples for ko/ja/zh | ~20 | Use target-language explanations |
| 7 | `lesson_screen.dart` L1285 | Hardcoded English matchPairs instruction | 1 | Move to ARB key `matchPairsInstruction` |
| 8 | `learn_screen.dart` L633 | Hardcoded `"LV $value"` | 1 | Use locale-aware format |
| 9 | `achievement.dart` model | `String title` and `String description` are English-only | 6 achievements | Refactor to `LocalizedText` |
| 10 | `app_ko.arb` + `app_ja.arb` | `super`/`superMarket` keys have English values not in en.arb | 2 extra keys | Translate to ko/ja |

### European courses (fr/es/de) — to be DELETED per new strategy
| Course | English question/answer leaks |
|--------|------------------------------|
| French (fr) | 425 leaks (40-65% of content is English) |
| Spanish (es) | 425 leaks |
| German (de) | 425 leaks |
| English (en) | ~40 untranslated titles/rules |

### ARB file gaps
| Locale | Untranslated keys | Details |
|--------|-------------------|---------|
| fr | 18 | `chillCorner`, `profile_level`, `xpToGoal`, `aiBadge`, etc. |
| de | 12 | `chillCorner`, `profile_level`, `aiBadge`, etc. |
| es | 6 | `chillCorner`, `aiBadge`, etc. |
| ko | 3 + 2 extra | `aiBadge`, profile badges + `super`/`superMarket` |
| ja | 3 + 2 extra | Same as ko |
| zh | 2 | `aiBadge`, `aiAssistantName` (intentional) |
| zh_TW | 2 | Same as zh |

---

## 🎯 WHAT THE AI NEEDS TO DO

### Phase 1: Fix English Leaks in Existing Code
Follow the fix workflow in `ENGLISH_LEAKAGE_AUDIT.md` Section "The Fix Workflow":
1. Fix 84 lesson titles (regex replace)
2. Fix 84 "Learn:" prefixes (regex replace)
3. Translate 60 grammar rule bodies into ko/ja/zh
4. Fix 6 Korean translateSentence options
5. Fix ~300 English words in ko/ja explanations
6. Fix ko/ja ARB super/superMarket keys
7. Fix 2 hardcoded English strings in Flutter code (→ ARB keys)
8. Refactor Achievement model: String → LocalizedText
9. Delete fr/es/de/en courses from demo_data.dart

### Phase 2: Build New Exam-Focused Content
Follow the execution order in `AI_CONTENT_PIPELINE_PROMPT.md` Section 8:
1. Download official HSK/TOPIK/JLPT vocabulary lists
2. Build structured JSON (vocabulary, sentences, grammar, dialogues, passages, mock tests)
3. Run 9 validation rules against all output
4. Produce complete `instalingo_content/` output directory

### Phase 3: Deliver
Output everything described in `AI_CONTENT_PIPELINE_PROMPT.md` Section 3:
- Complete content JSON files for all 3 languages + all exam levels
- UI translations for new ARB keys
- Achievement translations in 8 locales
- Validation reports
- Pipeline log with human review recommendations

---

## ⛔ CRITICAL RULES FOR THE AI

1. **Read `AI_CONTENT_PIPELINE_PROMPT.md` completely before starting.** It has the exact schemas, source list, and execution order.

2. **Never fabricate content.** Every vocabulary word, sentence, and grammar point must have a verifiable source. If you can't access a source, tag it `SOURCE_INACCESSIBLE` and explain what you tried.

3. **This is an exam-prep app, not a Duolingo clone.** Content is organized by exam syllabus (HSK 1→2→3, TOPIK I, JLPT N5→N4), not by "fun topics."

4. **Every user-visible string needs 8 locale translations:** `en`, `zh`, `zh_TW`, `ko`, `ja`, `es`, `fr`, `de`. No exceptions.

5. **If you cannot do something, SKIP AND REPORT.** Create BLOCKERS.md. A partial output with documented gaps is BETTER than fabricated content.

6. **Chinese is the developer's native language.** Korean and Japanese content needs native-speaker review. Tag uncertain translations with "NEEDS NATIVE REVIEW."

---

## 📂 NAVIGATION ORDER (Read In This Sequence)

1. `HANDOFF_MANIFEST.md` ← YOU ARE HERE
2. `AI_CONTENT_PIPELINE_PROMPT.md` ← The master task specification
3. `ENGLISH_LEAKAGE_AUDIT.md` ← What's broken and how to fix it
4. `lib/models/course.dart` ← Understand the data models
5. `lib/models/localized_text.dart` ← Understand the locale system
6. `lib/data/demo_data.dart` ← See the current content (warning: 30K lines)
7. `tools/json_to_dart.py` ← Understand the conversion pipeline
8. `Instalingo Raw Data Source Manifest.md` ← Where current data came from

Then execute.
