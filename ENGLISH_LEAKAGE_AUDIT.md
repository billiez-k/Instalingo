# InstaLingo — Strategic Audit: English Leaks, Content Architecture & Exam-Mode Roadmap

**Date**: 2026-05-28 | **Status**: Full repo scan complete → strategic refocus
**Decision**: Narrow from 7 languages to 3 (zh + ko + ja) + add exam modes (HSK, TOPIK, JLPT)
**Files Scanned**: 66 Dart files + 8 ARB files + generated l10n

---

## Strategic Decision (Read First)

After auditing all 7 courses for English leakage, a clear pattern emerged:

| Course | English question/answer leaks | Verdict |
|--------|------------------------------|---------|
| **Chinese (zh)** | 0 | ✅ Keep — clean, HSK-aligned, you can verify it |
| **Korean (ko)** | 6 minor (deep sentences only) | ✅ Keep — TOPIK-aligned, nearly clean |
| **Japanese (ja)** | 0 | ✅ Keep — JLPT-aligned, clean |
| French (fr) | 425 leaks | ❌ Drop for now |
| Spanish (es) | 425 leaks | ❌ Drop for now |
| German (de) | 425 leaks | ❌ Drop for now |
| English (en) | ~40 (untranslated titles/rules) | ❌ Drop as a learning course (keep as UI fallback) |

**The data made the decision for us.** CJK courses are 99% clean. European courses are 40-65% English-contaminated. Fixing 3 courses with ~300 leaks is a weekend. Fixing 7 courses with ~1,700 leaks is a months-long project with no way to verify quality.

**New scope:** InstaLingo = Chinese, Korean, Japanese with exam modes (HSK 1-3, TOPIK I, JLPT N5-N4).

**Future:** European languages can return when you can afford a native-speaker linguist to verify content per language.

---

## Current State: Known English Leaks in the 3 Keep Courses

### 1. Lesson Titles — "Lesson N" in All Locales 🔴

**84 instances** across ko (28), ja (28), zh (28). All locales show English `"Lesson 1"`.

| Course | Current all locales | Should be |
|--------|--------------------|------------|
| ko | `"Lesson 1"` | `"1과"` |
| ja | `"Lesson 1"` | `"第1課"` |
| zh | `"Lesson 1"` | `"第1课"` |

Fix: simple regex find-replace, 5 minutes per language.

### 2. Description "Learn:" Prefix 🔴

**84 instances**. All descriptions start with English `"Learn: …"`.

| Course | Current | Should be |
|--------|---------|------------|
| ko | `"Learn: 개나리, 간, 것"` | `"배우기: 개나리, 간, 것"` |
| ja | `"Learn: 朝, あちら, いい; よい"` | `"学習: 朝, あちら, いい; よい"` |
| zh | `"Learn: 不客气, 东西, 汉语"` | `"学习: 不客气, 东西, 汉语"` |

### 3. Grammar Rules — English Body Text 🔴

**~60 grammar rules** in ko/ja/zh courses. The label prefix (문법/文法/语法) is translated, but the body text is English for ALL locale keys.

Example from Korean course:
```dart
'ko': "문법: Basic Korean word order — Subject + Object + Verb\nExample: 나는 오렌지를 먹었어요."
// Should be: "문법: 한국어 기본 어순 — 주어 + 목적어 + 동사\n예시: 나는 오렌지를 먹었어요."
```

### 4. English Words in Non-English Explanations 🟡

~300 instances in ko/ja explanations where English target-meaning words appear in non-English text:
```
'ko': "'개나리'의 의미는 'forsythia'입니다."  // "forsythia" should be Korean
'ja': "'朝'の意味は 'morning' です。"           // "morning" should be Japanese
```

### 5. Korean Course — 6 translateSentence with English Options 🔴

6 exercises in the Korean course have English multiple-choice answers. These are deep sentences from Tatoeba (e.g., "But the universe is infinite.") that the generator failed to translate.

### 6. Grammar Examples with "→ English" 🟡

~20 instances in ko/ja/zh grammar examples showing English translations.

### 7. ARB Files — Minor Untranslated Keys 🟡

| Locale | Untranslated | Keys |
|--------|-------------|------|
| ko | 3 | `aiBadge`, `profile_instalingoSuperFAQ`, `profile_superBadge` — all intentional brands/acronyms |
| ja | 3 | Same as ko |
| zh | 2 | `aiBadge`, `aiAssistantName` — intentional |
| zh_TW | 2 | Same as zh |
| ko/ja extra | 2 | `super`: `"Super"`, `superMarket`: `"Super Market"` — should be translated |

### 8. Flutter Code — 2 Hardcoded English Strings 🔴

- `lesson_screen.dart` L1285: `"Tap a word on the left, then its match on the right"` — matchPairs instruction
- `learn_screen.dart` L633: `"LV $value"` — level abbreviation

### 9. Achievement Model — No Localization 🔴

6 achievements with English-only `String title` and `String description`. Model must use `LocalizedText`.

### 10. Content Pedagogy Issues 🟡

Current vocabulary ordering is random (from source data order), not pedagogical:

| Lesson | Korean vocab | Problem |
|--------|-------------|---------|
| ko_l01 | `개나리, 간, 것, 고등학교, 고등학생, 그분, 국적, 금방` | "Forsythia" + "while" + "thing" + "high school" — no thematic coherence |
| ko_l01 grammar | "Basic Korean word order" | Correct concept but wrong place — should be in Lesson 2-3 after vocab foundation |

The vocabulary is accurate (sourced from TOPIK I list) but **not sequenced for learning**. A beginner should learn "hello", "thank you", "yes/no", "I", "you" before learning "nationality", "immediately", and "forsythia."

---

## New Feature: Exam Mode Architecture

This is your differentiator. Duolingo doesn't do this. HelloChinese barely does this.

### What Exam Mode Is

Instead of (or in addition to) generic language courses, offer structured exam preparation tracks:

| Exam | Language | Levels | Learners/year | Official Source |
|------|----------|--------|--------------|-----------------|
| **HSK** | Chinese | 1-6 (you: 1-3) | ~5M test-takers | hsk.org.cn |
| **TOPIK** | Korean | I (1-2), II (3-6) (you: I) | ~375K test-takers | topik.go.kr |
| **JLPT** | Japanese | N5-N1 (you: N5-N4) | ~1M test-takers | jlpt.jp |

### Exam Mode Content Structure

Each exam mode is a **parallel track** alongside the general course, sharing vocabulary/grammar but with different exercise design:

```
Course Structure:
├── General Track (existing)         Exam Track (new)
│   ├── Greetings & Introductions    ├── HSK 1: Listening Practice
│   ├── Daily Life                   │   ├── Audio comprehension (HSK-style)
│   ├── Food & Drink                 │   ├── Sentence reordering (HSK-style)
│   └── ...                          │   └── Mock test section
│                                    ├── HSK 1: Reading Practice
│                                    │   ├── Gap-fill with grammar focus
│                                    │   ├── Sentence matching
│                                    │   └── Mock test section
│                                    ├── HSK 1: Writing Practice (HSK 1-2: pinyin→hanzi)
│                                    └── Full Mock Test (timed, scored)
```

### Exam-Specific Exercise Types (New)

These are exercise types that DON'T exist in your current 16, but are essential for exam prep:

| New Type | Exam | Description |
|----------|------|-------------|
| **audioComprehension** | HSK/TOPIK/JLPT | Listen to a short dialogue, answer a question. Timed. |
| **readingComprehension** | HSK/TOPIK/JLPT | Read a short passage, answer multiple-choice. |
| **sentenceReordering** | HSK/TOPIK | Given scrambled sentence parts, arrange in correct order. |
| **grammarCloze** | JLPT/TOPIK | Fill blanks in a paragraph with correct grammar particles. |
| **kanjiReading** | JLPT | Show kanji compound, select correct reading (hiragana). |
| **hanziWriting** | HSK | Show pinyin + English, user draws/writes the character. |
| **mockTest** | All | Timed, scored, simulates real exam format + passing prediction. |

### Exam Mode Implementation Plan

**Phase 1 — Data Already Have:**
- HSK 1-2 vocabulary → already in zh course (220 words, source: plaktos/hsk_csv)
- JLPT N5 vocabulary → already in ja course (220 words, source: open-anki-jlpt-decks)
- TOPIK I vocabulary → already in ko course (220 words, source: Learning Korean TOPIK PDF)
- Tatoeba sentences → already have 300/pairs per language

**Phase 2 — Content to Create (per exam):**
- 10 mock listening exercises (record audio or use TTS)
- 10 mock reading passages (short, leveled)
- 10 grammar-cloze paragraphs
- 3 full mock tests (40 questions each, timed)
- Exam-specific instructions in all UI languages

**Phase 3 — Features to Build:**
- Timer with countdown (mock test mode)
- Score calculator with level prediction
- Wrong-answer review with grammar explanations
- Progress tracking per exam section (listening/reading/writing)

### Why Exam Mode Wins

1. **User intent is crystal clear.** Someone searching "HSK 1 practice" has extremely high purchase intent. They NEED to pass. "Learn Chinese" is vague.

2. **Willingness to pay is higher.** Exam prep commands premium pricing. HelloChinese charges $19.99/month for HSK prep features. General Chinese learning apps charge $6.99-9.99.

3. **Content is finite and verifiable.** An HSK 1 exam has exactly 150 words and ~20 grammar points. You can verify EVERY exercise against the official syllabus. No ambiguity about "is this good enough?"

4. **Duolingo doesn't compete here.** Zero exam prep features. Their gamification approach is actively bad for exam prep (untimed, no mock tests, no score prediction).

5. **Your existing data is exam-aligned.** You already sourced vocabulary from HSK/TOPIK/JLPT lists. Your grammar points come from exam syllabus sources. The content IS exam content — it's just not packaged as such.

---

## The Fix Workflow (Revised for 3 Languages + Exam Modes)

### Week 1: Clean the Data (You Can Do This Yourself)

```
DAY 1 — Fix lesson titles (84 places)
  Regex replace: "Lesson N" → locale-appropriate for ko/ja/zh
  Time: 1 hour

DAY 1 — Fix "Learn:" prefix (84 places)
  Regex replace: "Learn:" → 배우기/学習/学习
  Time: 1 hour

DAY 2 — Fix grammar rules (60 places)
  Manual edit: translate the English body text for each grammar rule
  into ko/ja/zh (these are YOUR native language — verify personally)
  Time: 3-4 hours

DAY 2 — Fix 6 Korean translateSentence options
  Replace English multiple-choice answers with Korean translations
  Time: 1 hour

DAY 3 — Fix English words in explanations (~300 places)
  Batch replacement: "means 'good'" → locale-appropriate equivalents
  Can mostly regex. Spot-check tricky ones manually.
  Time: 3-4 hours

DAY 4 — Fix ARB files
  Translate ko/ja "super"/"superMarket" extra keys
  Add @meta keys to zh/zh_TW/ko/ja ARBs
  Time: 1 hour

DAY 5 — Fix Flutter code
  Replace 2 hardcoded English strings with ARB keys + translations
  Fix Achievement model: String → LocalizedText
  Translate 6 achievements into zh/zh_TW/ko/ja
  Time: 2-3 hours

DAY 6 — Delete European courses
  Remove fr/es/de/en courses from demo_data.dart
  Remove unused ARB keys for these languages (optional — keep for future)
  Time: 1 hour
```

### Week 2: Pedagogical Re-sequencing

```
Hire: 1 native Korean speaker + 1 native Japanese speaker
Platform: Upwork or Fiverr
Rate: $15-30/hr, ~10 hours each
Task: Review all 28 lessons per language, flag issues, suggest re-ordering
Deliverable: Annotated spreadsheet with "move X to lesson Y, add Z before W"

You do Chinese yourself (it's your native language per demo data).
Time: 3-5 days turnaround from freelancers
Cost: ~$300-600 total
```

### Week 3-4: Exam Mode Content

```
TASK — Build HSK 1 Mock Test (Chinese — your native language, you can do this)
  - 10 listening questions (record yourself or use Azure TTS for now)
  - 10 reading questions
  - 10 writing questions (pinyin→hanzi)
  - Timer + scoring logic
  Time: 3-4 days

TASK — Build TOPIK I Mock Test (Korean)
  - Use your existing TOPIK-aligned vocabulary + Tatoeba sentences
  - Hire freelancer to write 20 exam-style questions ($100-200)
  - You implement the exercise types
  Time: 2-3 days (after freelancer delivers)

TASK — Build JLPT N5 Mock Test (Japanese)
  - Same approach: freelancer writes questions, you implement
  - Cost: $100-200
  Time: 2-3 days

TOTAL: ~$500-800, 2 weeks part-time
```

### Week 5: Polish & Ship

```
- Add CI validation script (tools/validate_l10n.dart)
- Run flutter gen-l10n, verify generated files
- Full pass through zh/ko/ja courses on device
- Record App Store screenshots (Chinese course + HSK mock test)
- Write App Store description with HSK/TOPIK/JLPT keywords
- Ship v1.0 as "InstaLingo: Chinese, Korean & Japanese with Exam Prep"
```

---

## Post-Launch: The Growth Path

### Month 2-3: Deepen Exam Content
- HSK 2-3, TOPIK I level 2, JLPT N4 mock tests
- Add kanji/hanzi writing practice (stroke order animation)
- Add listening comprehension practice with transcripts
- Add vocabulary-by-exam-level flashcard decks

### Month 4-6: Add European Language (One at a Time)
- Pick ONE European language based on user demand data
- Hire native speaker to write + verify ALL content ($2-5K)
- Launch with exam mode (DELF A1, DELE A1, or Goethe A1)
- Rinse and repeat

### Month 6-12: AI Features
- AI conversation practice in target language with corrections
- AI-generated practice questions from user's mistake history
- AI pronunciation feedback (compare waveform to native speaker)

---

## The Numbers That Matter

| Metric | 7-Language "Duolingo Clone" | 3-Language + Exam Prep |
|--------|----------------------------|------------------------|
| Content to verify | 107,520 strings | ~40,000 strings |
| Languages you can personally verify | 1 (Chinese) | 3 (Chinese + hired KR/JP) |
| Time to polish | 3-6 months | 5 weeks |
| Cost to verify content | $10-30K (6 linguists) | $500-800 (2 freelancers) |
| Differentiation | None ("another Duolingo clone") | Strong ("exam prep for Asian languages") |
| Monetization leverage | Low (generic = low WTP) | High (exam prep = premium pricing) |
| User acquisition | Hard ("learn a language" is crowded) | Specific ("HSK 1 practice" has low competition) |
| App Store keyword difficulty | "learn Chinese" = Very High | "HSK practice" = Low-Medium |

---

## What Duolingo (Can't/Won't) Do vs. What You Can

| Feature | Duolingo | Your App |
|---------|----------|----------|
| 40+ languages | ✅ | 3 focused ones |
| Gamified casual learning | ✅ | Not your focus |
| Timed mock exams with score prediction | ❌ | ✅ (your differentiator) |
| Exam-specific grammar explanations | ❌ | ✅ (HSK grammar ≠ general grammar) |
| Character writing practice (stroke order) | ❌ (terrible implementation) | ✅ (make this excellent) |
| Listening comprehension with transcripts | ❌ | ✅ |
| TOPIK I / JLPT N5 official vocabulary coverage | ❌ | ✅ (you already have the data) |
| Per-user mistake analysis | ❌ | 🚧 Planned |

---

## Verification Checklist (Post-Fix)

```
□ All 84 lesson titles → locale-appropriate (ko: N과, ja: 第N課, zh: 第N课)
□ All 84 "Learn:" → translated in ko/ja/zh
□ All 60 grammar rules → body text translated per locale
□ 6 ko translateSentence → Korean options, not English
□ ~300 explanation leaks → no English words in ko/ja text
□ ko/ja ARB: super/superMarket translated
□ zh/zh_TW/ko/ja ARB: @meta keys present
□ lesson_screen.dart: hardcoded string → ARB key
□ learn_screen.dart: "LV" → locale-aware format
□ Achievement model → LocalizedText
□ 6 achievements → translations for zh/zh_TW/ko/ja
□ fr/es/de/en courses removed from demo_data.dart
□ HSK 1 mock test → 30 questions + timer + scoring
□ TOPIK I mock test → 20 questions + timer + scoring
□ JLPT N5 mock test → 20 questions + timer + scoring
□ CI validation script created → blocks future English leaks
□ Full app run-through in zh, ko, ja locales → no English text visible
```

---

## Total Cost & Timeline

| Phase | Time | Cost |
|-------|------|------|
| Week 1: Fix all English leaks | 5 days | $0 |
| Week 2: Pedagogical review by native speakers | 3-5 days async | $300-600 |
| Week 3-4: Build exam modes | 2 weeks part-time | $200-400 for question writing |
| Week 5: Polish, test, ship | 1 week | $0 |
| **TOTAL to shipable v1** | **5 weeks** | **$500-1,000** |

Compared to the old 7-language plan: **3-6 months and $10-30K.**

---

## Recommended Next Action (Today)

1. Run: `git checkout -b codex/asian-focus-cleanup`
2. Delete French, Spanish, German, and English courses from demo_data.dart
3. Fix the 84 lesson titles (regex, 1 hour)
4. Fix the 84 "Learn:" prefixes (regex, 1 hour)
5. Commit: "Drop European languages, fix lesson titles and descriptions for zh/ko/ja"
6. Continue through the Week 1 checklist above

**You can have a clean, correct, 3-language codebase by end of day tomorrow.**

Then spend the rest of the week on grammar rules and ARB fixes. Ship by Friday.

---

*Generated: 2026-05-28 — replaces all previous audit versions*
