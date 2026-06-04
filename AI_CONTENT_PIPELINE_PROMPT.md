# AI Agent Task: InstaLingo Exam-Prep Content Pipeline — Complete Build

> **To the AI agent:** This is a self-contained, end-to-end task. Read EVERY section before starting. Follow the execution order exactly. **If you cannot verify, access, or confirm something — SKIP it and REPORT. Never fabricate content.**

---

## ⛔ SECTION 0 — CRITICAL RULES (VIOLATE THESE AND YOUR OUTPUT IS REJECTED)

### 0.1 NEVER INVENT CONTENT

Every vocabulary word, sentence, grammar rule, and exam question you output must have a verifiable source. You are a **data curator and formatter**, not a content author. The only exception is creating **distractor options** for multiple-choice questions — those you derive from the existing vocabulary set using semantic/visual/phonetic similarity rules (defined below).

### 0.2 THREE-TIER SOURCE PROVENANCE

Every item you output must carry exactly ONE of these source tags:

| Tag | Meaning | Action Required |
|-----|---------|-----------------|
| `SOURCE_VERIFIED` | Downloaded/copied from an official, public, verifiable source | Include the exact URL or filename |
| `SOURCE_DERIVED` | Adapted/translated from a verified source (e.g., you translated a grammar explanation into Korean) | Include the original source + note what you changed |
| `SOURCE_INACCESSIBLE` | You tried to access a source but couldn't (blocked, 404, paywall, no web access) | Output a placeholder file explaining what you tried. DO NOT invent the data. |

**If you cannot tag an item with one of these three, DO NOT INCLUDE IT.**

### 0.3 SKIP-AND-REPORT PROTOCOL

If any of the following happens, STOP that subtask, create a file named `BLOCKERS.md` listing what failed, and move to the next subtask:

- A source URL returns 404, 403, or a paywall
- You cannot access the web at all
- A source file is in a format you cannot parse
- You find contradicting information across multiple sources
- You are asked to translate into a language you are not confident in

**A partial, honest output with documented gaps is usable. Fabricated content is worse than useless — it will teach learners wrong information.**

### 0.4 THIS IS AN EXAM-PREP APP, NOT A DUOLINGO CLONE

InstaLingo's value proposition is: **"Pick your exam → learn exactly what's tested → practice in real exam format → pass."** It is NOT a casual "learn a language while having fun" app.

Every design decision flows from this:
- Content is organized by **exam syllabus**, not by "fun topics"
- Vocabulary is selected because it's **on the test**, not because it's thematically cute
- Grammar is explained for **test-taking**, not for conversational fluency
- Exercises mirror **real exam question formats**, not gamified minigames
- There is no "general Chinese course" — there is "HSK 1 Prep" which happens to teach you Chinese

---

## 1. What This Is

### 1.1 The Product

**InstaLingo** is a mobile app (Flutter/Dart) for structured exam preparation in three Asian languages:

| Language | Exams Covered | Levels |
|----------|--------------|--------|
| Chinese (zh) | HSK (Hanyu Shuiping Kaoshi) | 1, 2, 3 |
| Korean (ko) | TOPIK (Test of Proficiency in Korean) | I (levels 1-2) |
| Japanese (ja) | JLPT (Japanese Language Proficiency Test) | N5, N4 |

### 1.2 The Developer

An indie developer who can personally verify **Chinese content** (native speaker) but needs AI assistance for **Korean and Japanese** content. The developer has existing Python tooling that converts structured JSON into the app's Dart code.

### 1.3 The App's Tech Stack (What You Need to Know)

- **Framework:** Flutter/Dart
- **Content storage:** A single Dart file: `lib/data/demo_data.dart` (contains all courses, lessons, exercises)
- **UI translations:** 8 ARB files in `lib/l10n/app_*.arb`
- **Content model:** `LocalizedText` — every user-visible string must have entries for 8 locales: `en`, `zh`, `zh_TW`, `ko`, `ja`, `es`, `fr`, `de`
- **Course hierarchy:** `Course` → `Section` → `Lesson` → `Exercise`
- **Exercise types (enum):** `vocabularyMultipleChoice`, `fillInBlank`, `translateSentence`, `matchPairs`, `listenAndType`, `speaking`, `dialogueComplete`, `grammarTip`, `wordSorting`, `imageIdentification`, `flashCard`, `comprehensionText`, `grammarTrueFalse`, `phraseBuilderPrefilled`, `writing`
- **Conversion toolchain:** `tools/json_to_dart.py` converts JSON → Dart code
- **Three language dimensions in the app:**
  1. **UI Language** — what language the app chrome/buttons appear in (ARB files handle this)
  2. **Instruction Language** — what language grammar explanations and exercise instructions are shown in (LocalizedText fields like `explanation`, `grammarRule`, `grammarExample`)
  3. **Target Language** — the language being learned (plain String fields like `question`, `correctAnswer`, `options`)

### 1.4 What You Are Building

You are producing **structured JSON data files** that the developer will feed through Python scripts to generate the final Dart code. You do NOT write Dart code. You do NOT write the Python scripts. You output clean, validated JSON following the schemas below.

---

## 2. Content Architecture: Foundation + Exam Tracks

### 2.1 The Two-Track System

```
┌─────────────────────────────────────────────────────┐
│                 FOUNDATION TRACK                     │
│  (Prerequisites before starting any exam track)      │
│                                                      │
│  Chinese: Pinyin + tones + character basics          │
│  Korean: Hangul + pronunciation + basic particles    │
│  Japanese: Hiragana + Katakana + basic structure     │
│                                                      │
│  ~3-5 lessons per language                           │
│  Must be completed before any exam track unlocks     │
└─────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────┐
│                   EXAM TRACKS                        │
│                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐│
│  │  HSK TRACK   │  │ TOPIK TRACK  │  │ JLPT TRACK  ││
│  │              │  │              │  │             ││
│  │ HSK 1 (150w) │  │ TOPIK I      │  │ JLPT N5     ││
│  │   ↓          │  │ (1500w+)     │  │ (800w)      ││
│  │ HSK 2 (150w) │  │              │  │   ↓         ││
│  │   ↓          │  │ (Only Level  │  │ JLPT N4     ││
│  │ HSK 3 (300w) │  │  1-2 for MVP)│  │ (800w)      ││
│  └──────────────┘  └──────────────┘  └─────────────┘│
└─────────────────────────────────────────────────────┘
```

### 2.2 What Goes in Foundation vs. Exam Tracks

**Foundation Track (per language):**
- Writing system introduction (no exam tests this directly, but learners need it)
- Pronunciation guide (pinyin, hangul reading, kana reading)
- 20-30 highest-frequency survival words (hello, thank you, yes, no, I, you)
- Basic sentence structure overview (SOV for Korean/Japanese, SVO for Chinese)
- How to use the app's exercise types

**Exam Tracks (per level):**
- ALL vocabulary from the official exam syllabus for that level
- ALL grammar points tested at that level
- Exercises in the format of the real exam
- Timed mock tests matching real exam structure
- Score prediction based on mock test performance

### 2.3 Vocabulary Organization

Vocabulary within each exam level is organized in **teaching order**, not random or alphabetical:

| Order Range | Category | Examples (Chinese) |
|-------------|----------|-------------------|
| 1-30 | Greetings, pronouns, basic verbs | 你好, 我, 你, 是, 有, 去 |
| 31-60 | Numbers, time, dates | 一, 二, 今天, 明天, 年, 月 |
| 61-100 | Family, people, occupations | 妈妈, 爸爸, 老师, 学生, 医生 |
| 101-150 | Food, drink, daily objects | 水, 饭, 茶, 书, 手机 |
| 151-200 | Places, directions, transport | 学校, 家, 医院, 左, 右, 车 |
| 201-250 | Adjectives, colors, sizes | 大, 小, 好, 红, 白, 高 |
| 251-300 | Abstract, feelings, advanced | 喜欢, 觉得, 知道, 可能 |

Grammar points are interleaved: introduce ~1 grammar point per 7-10 vocabulary words, immediately after the vocabulary it uses.

---

## 3. Deliverables — Exact File Tree

```
instalingo_content/
│
├── chinese/
│   ├── foundation/
│   │   ├── vocabulary.json        # 20-30 survival words (你好, 谢谢, etc.)
│   │   ├── grammar.json           # 5 basic structure points (SVO, 是, 有, 不, 吗)
│   │   └── sentences.json         # 30 simple sentences using foundation vocab only
│   │
│   ├── hsk1/
│   │   ├── vocabulary.json        # 150 words from official HSK 1 list
│   │   ├── grammar.json           # ~15 HSK 1 grammar points
│   │   ├── sentences.json         # 120 sentence pairs (target zh -> translation en)
│   │   ├── dialogues.json         # 8 short dialogues
│   │   ├── passages.json          # 8 reading passages (50-100 chars each)
│   │   └── mock_test.json         # Full HSK 1 mock (listening 20 + reading 20 = 40 questions)
│   │
│   ├── hsk2/
│   │   ├── vocabulary.json        # 150 NEW words (300 total across HSK 1+2)
│   │   ├── grammar.json           # ~15 HSK 2 grammar points
│   │   ├── sentences.json         # 120 sentence pairs
│   │   ├── dialogues.json         # 8 dialogues
│   │   ├── passages.json          # 8 passages (80-150 chars)
│   │   └── mock_test.json         # Full HSK 2 mock
│   │
│   └── hsk3/
│       ├── vocabulary.json        # 300 NEW words (600 total across HSK 1-3)
│       ├── grammar.json           # ~20 HSK 3 grammar points
│       ├── sentences.json         # 150 sentence pairs
│       ├── dialogues.json         # 10 dialogues
│       ├── passages.json          # 10 passages (100-200 chars)
│       └── mock_test.json         # Full HSK 3 mock
│
├── korean/
│   ├── foundation/
│   │   ├── vocabulary.json        # 20-30 survival words
│   │   ├── grammar.json           # 5 basic structure points
│   │   └── sentences.json         # 30 simple sentences
│   │
│   └── topik1/
│       ├── vocabulary.json        # 300 words from TOPIK I vocabulary list
│       ├── grammar.json           # ~40 TOPIK I grammar points
│       ├── sentences.json         # 150 sentence pairs
│       ├── dialogues.json         # 10 dialogues
│       ├── passages.json          # 10 reading passages
│       └── mock_test.json         # Full TOPIK I mock (30 questions)
│
├── japanese/
│   ├── foundation/
│   │   ├── vocabulary.json        # 20-30 survival words
│   │   ├── grammar.json           # 5 basic structure points
│   │   ├── kana.json              # Hiragana + Katakana character tables
│   │   └── sentences.json         # 30 simple sentences
│   │
│   ├── jlpt_n5/
│   │   ├── vocabulary.json        # 300 words from JLPT N5 list
│   │   ├── kanji.json             # ~100 N5 kanji with readings and examples
│   │   ├── grammar.json           # ~40 JLPT N5 grammar points
│   │   ├── sentences.json         # 150 sentence pairs
│   │   ├── dialogues.json         # 10 dialogues
│   │   ├── passages.json          # 10 passages
│   │   └── mock_test.json         # Full JLPT N5 mock
│   │
│   └── jlpt_n4/
│       ├── vocabulary.json        # 300 NEW words (600 total across N5+N4)
│       ├── kanji.json             # ~100 NEW N4 kanji (200 total)
│       ├── grammar.json           # ~40 JLPT N4 grammar points
│       ├── sentences.json         # 150 sentence pairs
│       ├── dialogues.json         # 10 dialogues
│       ├── passages.json          # 10 passages
│       └── mock_test.json         # Full JLPT N4 mock
│
├── shared/
│   ├── ui_translations.json       # New ARB keys for exam mode UI
│   ├── achievement_translations.json  # 6 achievements in 8 locales
│   └── validation_report.json     # Auto-generated pass/fail results
│
├── SOURCES.md                     # Every source used, URLs, license status, access date
├── BLOCKERS.md                    # Everything that failed, why, what you tried
└── PIPELINE_LOG.md                # Execution log: what happened, decisions made, flags raised
```

**IMPORTANT:** If you cannot complete a file (source inaccessible, not enough data, lack of confidence), create it anyway with a placeholder structure and a clear `"status": "BLOCKED"` field at the top explaining why. Do NOT skip the file entirely — the developer needs to see the gap.

---

## 4. Source Materials — Where to Get Everything

### 4.1 LICENSE WARNING — READ BEFORE DOWNLOADING

| License Type | Abbreviation | Can Use in Commercial App? |
|-------------|-------------|---------------------------|
| Creative Commons Attribution | CC-BY | Yes — must credit |
| Creative Commons Attribution-ShareAlike | CC-BY-SA | Yes — must credit + share-alike |
| Creative Commons Attribution-NonCommercial | CC-BY-NC | NO — non-commercial only |
| Creative Commons Attribution-NonCommercial-ShareAlike | CC-BY-NC-SA | NO — non-commercial only |
| Public Domain / CC0 | PD / CC0 | Yes — no restrictions |
| MIT / Apache / BSD | MIT | Yes — open source licenses |
| Official government publication | GOV | Usually yes — check specific terms |
| Unknown / No license stated | ??? | FLAG — do not use without human legal review |

**If a source is CC-BY-NC:** Download it for REFERENCE ONLY. Mark it in SOURCES.md as "Reference only — NC license, cannot ship." The developer will need to either license it commercially, find a CC-BY alternative, or re-author the content.

### 4.2 Chinese (HSK) — Sources

**Primary sources (try these first):**

| # | What | Where | Format | License |
|---|------|-------|--------|---------|
| C1 | HSK 1-6 Official Vocabulary (2021 standard) | GitHub: `plaktos/hsk_csv` → `hsk.csv` | CSV with 汉语, 拼音, 英语 | MIT |
| C2 | HSK word lists with example sentences | GitHub: `gigacool/hanyu-shuiping-kaoshi` | JSON/CSV | Check |
| C3 | Tatoeba Chinese-English sentences | `https://downloads.tatoeba.org/exports/sentences.csv` + `links.csv` | CSV (filter `lang='cmn'`) | CC-BY 2.0 FR |
| C4 | Chinese Grammar Wiki A1-A2 | `https://resources.allsetlearning.com/chinese/grammar/A1_grammar_points` | HTML/wiki | **CC-BY-NC-SA** — REFERENCE ONLY |
| C5 | HSK past papers (format reference) | Search: `"HSK 1 sample test" PDF` or `hsk.org.cn` | PDF | GOV |

**Fallback sources (if primary fails):**

| # | What | Where | Why useful |
|---|------|-------|-----------|
| C6 | HSK vocabulary Anki decks | AnkiWeb shared decks → search "HSK 1" | Community-curated, usually CC |
| C7 | Mandarin Chinese word frequency lists | GitHub: `hermitdave/FrequencyWords` → `zh_full.txt` | Frequency-ordered, CC-BY-SA |
| C8 | Chinese sentences from Tatoeba (mirror) | `https://github.com/nicknisi/tatoeba-corpus` | Git mirror of Tatoeba |
| C9 | HSK vocabulary with audio | `https://www.digmandarin.com/hsk-1-vocabulary-list` | Human-verified pinyin |
| C10 | Chinese Grammar Wiki (archived) | Archive.org snapshot of AllSet Grammar Wiki | If main site is down |

### 4.3 Korean (TOPIK) — Sources

**Primary sources:**

| # | What | Where | Format | License |
|---|------|-------|--------|---------|
| K1 | TOPIK I Vocabulary (official 1671 words) | `https://learning-korean.com/DL/TOPIK-I-1671.pdf` | PDF | Check |
| K2 | TOPIK vocabulary lists on GitHub | GitHub search: `"topik vocabulary" json` or `"topik" csv` | CSV/JSON | Varies |
| K3 | Tatoeba Korean-English sentences | Same Tatoeba exports → filter `lang='kor'` | CSV | CC-BY 2.0 FR |
| K4 | TOPIK grammar patterns | `https://www.topikguide.com/topik-grammar/` | Web | Check |
| K5 | TOPIK past papers (format) | `https://www.topik.go.kr` → 기출문제 | PDF | GOV |
| K6 | Korean Grammar Dictionary | `https://github.com/digitalpenguin/korean-grammar-dictionary` | JSON | MIT |

**Fallback sources:**

| # | What | Where | Why useful |
|---|------|-------|-----------|
| K7 | National Institute of Korean Language | `https://krdict.korean.go.kr` → download | Official, free |
| K8 | Korean frequency lists | GitHub: `hermitdave/FrequencyWords` → `ko_full.txt` | CC-BY-SA |
| K9 | How to Study Korean (units 1-2) | `https://www.howtostudykorean.com/unit1/` | Detailed grammar, check license |
| K10 | TTMIK free lessons | `https://talktomeinkorean.com/curriculum/` | Free lessons, check license |

### 4.4 Japanese (JLPT) — Sources

**Primary sources:**

| # | What | Where | Format | License |
|---|------|-------|--------|---------|
| J1 | JLPT N5-N4 vocabulary | GitHub: `jamsinclair/open-anki-jlpt-decks` → `n5.csv`, `n4.csv` | CSV | MIT |
| J2 | JLPT vocabulary lists | GitHub: `stephenva/jlpt-vocab` or search `"jlpt" "n5" vocab` | JSON/CSV | Varies |
| J3 | Tatoeba Japanese-English sentences | Same Tatoeba exports → filter `lang='jpn'` | CSV | CC-BY 2.0 FR |
| J4 | JLPT N5-N4 grammar | `https://jlptsensei.com/jlpt-n5-grammar-list/` + N4 list | Web | Check |
| J5 | JLPT sample questions | `https://www.jlpt.jp/e/samples/n5.html` | PDF/Web | GOV |
| J6 | Japanese kanji by JLPT level | GitHub: `davidluzgouveia/kanji-data` → `kanji-jlpt.json` | JSON | MIT |
| J7 | Japanese frequency lists | GitHub: `hermitdave/FrequencyWords` → `ja_full.txt` | CC-BY-SA |

**Fallback sources:**

| # | What | Where | Why useful |
|---|------|-------|-----------|
| J8 | Tae Kim's Japanese Grammar | `https://guidetojapanese.org/learn/grammar` | Classic reference, check license |
| J9 | Jisho.org (JMdict/EDICT) | `https://www.edrdg.org/jmdict/j_jmdict.html` | Authoritative dictionary, CC-BY-SA |
| J10 | KanjiVG (stroke order SVGs) | `https://github.com/KanjiVG/kanjivg` | Vector kanji, CC-BY-SA |
| J11 | Tatoeba audio for Japanese | `https://tatoeba.org/en/audio/index/jpn` | Native audio, CC-BY |

### 4.5 If Sources Are Inaccessible — What to Do

**If you have web access but a specific URL is down:**
1. Try the fallback source for that data type
2. Search for: `"[exam name] vocabulary list" github` — GitHub repos are more stable than personal sites
3. Try `web.archive.org` snapshots of the URL
4. If still blocked, log it in BLOCKERS.md and MOVE ON

**If you have NO web access at all (offline LLM, API without browsing, etc.):**
1. You CAN use:
   - Your training data knowledge of common HSK/TOPIK/JLPT vocabulary (these are published, standardized lists)
   - Your knowledge of basic grammar patterns for each language
   - Your knowledge of common sentence structures
2. You MUST tag everything as `SOURCE_INACCESSIBLE` and explain in PIPELINE_LOG.md
3. You MUST flag the output for human review — the developer needs a native speaker to verify
4. You CAN still produce useful structured data because these exam syllabi are public knowledge
5. You CANNOT fabricate specific Tatoeba sentence IDs — use `"source": "AI-generated from exam vocabulary — SOURCE_INACCESSIBLE — NEEDS HUMAN REVIEW"`

**CRITICAL DISTINCTION:** Using your training knowledge of a PUBLISHED STANDARD (e.g., "HSK 1 has the word 学校") is acceptable. Inventing a word that you think "should be" in HSK 1 is NOT acceptable. If you're not 100% sure a word is on the official list, leave it out.

---

## 5. JSON Schemas — Exact Output Formats

### 5.1 Vocabulary Schema (`vocabulary.json`)

```json
{
  "meta": {
    "language": "zh",
    "exam_level": "HSK 1",
    "total_words": 150,
    "source": "plaktos/hsk_csv (GitHub, MIT license)",
    "source_status": "SOURCE_VERIFIED",
    "validation": {
      "all_locales_present": true,
      "no_english_leakage": true,
      "teaching_order_sequential": true
    }
  },
  "words": [
    {
      "id": "zh_hsk1_001",
      "word": "我",
      "phonetic": "wǒ",
      "pos": "pronoun",
      "exam_level": "HSK 1",
      "topic": "pronouns",
      "teaching_order": 1,
      "meaning": {
        "en": "I; me",
        "zh": "我",
        "zh_TW": "我",
        "ko": "나; 저",
        "ja": "私; わたし",
        "es": "yo",
        "fr": "je; moi",
        "de": "ich"
      },
      "example_sentence_target": "我是学生。",
      "example_sentence_meaning_en": "I am a student.",
      "distractors": ["你", "他", "她"],
      "distractor_rationale": "Same pronoun category — common confusion for beginners",
      "audio_url": null,
      "image_url": null,
      "source": "HSK Official Vocabulary List 2021 (via plaktos/hsk_csv)",
      "source_status": "SOURCE_VERIFIED"
    }
  ]
}
```

**Field rules for vocabulary:**
- `id`: Unique. Format: `{lang}_{exam_level}_{sequence_number}`. Example: `zh_hsk1_001`, `ko_topik1_042`, `ja_n5_078`
- `teaching_order`: Integer starting at 1. This is THE most critical field. It determines lesson sequencing, sentence generation order, and exercise ordering. Follow the category ranges in Section 2.3.
- `distractors`: EXACTLY 3 words that a real learner would plausibly confuse with the target word. Rules for distractor selection:
  - Same word class (noun→noun, verb→verb)
  - Same semantic category (colors→colors, family→family)
  - Or similar appearance/sound (look-alike characters for CJK)
  - Must be from the same or earlier teaching_order (no unreachable words)
  - Do NOT use random words from the vocabulary list
- `meaning`: ALL 8 locale keys required. The zh/zh_TW entries should be the word itself (for Chinese vocabulary). The ko/ja/es/fr/de entries are translations of the word's meaning, NOT the word itself.
- `example_sentence_target`: A short, natural sentence in the target language using the word. Must use ONLY vocabulary at or below the current `teaching_order`.
- `audio_url` and `image_url`: Set to `null` unless you have actual URLs. The developer fills these later.
- Every field that will be shown to a user (like `meaning`) MUST have all 8 locale translations present and non-empty.

### 5.2 Sentence Schema (`sentences.json`)

```json
{
  "meta": {
    "language": "zh",
    "exam_level": "HSK 1",
    "total_sentences": 120,
    "source": "Tatoeba exports (CC-BY 2.0 FR) + supplementary generation",
    "source_status": "SOURCE_VERIFIED",
    "tatoeba_count": 95,
    "ai_generated_count": 25,
    "ai_generated_note": "25 sentences generated for vocabulary not covered by Tatoeba. Flagged for human review."
  },
  "sentences": [
    {
      "id": "zh_hsk1_s001",
      "target_sentence": "我是学生。",
      "target_lang": "zh",
      "translation_en": "I am a student.",
      "vocabulary_used": ["我", "是", "学生"],
      "grammar_points_used": ["是 sentence pattern"],
      "max_teaching_order": 25,
      "word_count": 3,
      "char_count": 5,
      "source": "Tatoeba sentence #381109",
      "source_status": "SOURCE_VERIFIED"
    }
  ]
}
```

**Field rules for sentences:**
- Max 8 words for non-CJK, 10 characters for CJK. Beginners need short sentences.
- `vocabulary_used`: Array of vocabulary `word` values. Every word must exist in the corresponding vocabulary.json.
- `max_teaching_order`: The highest `teaching_order` among all words used. This ensures sentences only use words the learner has encountered up to this point.
- `grammar_points_used`: Array of grammar `topic` values from the corresponding grammar.json.
- `source`: For Tatoeba sentences, include the sentence ID number. For AI-generated sentences, use: `"AI-generated — NEEDS HUMAN REVIEW — vocab gap: [word not in Tatoeba]"`.

### 5.3 Grammar Schema (`grammar.json`)

```json
{
  "meta": {
    "language": "zh",
    "exam_level": "HSK 1",
    "total_points": 15,
    "source": "HSK 1 grammar syllabus + Chinese Grammar Wiki A1",
    "source_status": "SOURCE_DERIVED"
  },
  "grammar_points": [
    {
      "id": "zh_hsk1_g001",
      "topic": "Basic sentence order: Subject + Verb + Object",
      "exam_level": "HSK 1",
      "teaching_order": 2,
      "rule": {
        "en": "Chinese follows Subject-Verb-Object (SVO) word order, like English. The subject comes first, then the verb, then the object.",
        "zh": "中文的基本语序是主语-动词-宾语（SVO），和英语一样。主语在前，动词在中间，宾语在最后。",
        "zh_TW": "中文的基本語序是主語-動詞-賓語（SVO），和英語一樣。主語在前，動詞在中間，賓語在最後。",
        "ko": "중국어는 영어와 마찬가지로 주어-동사-목적어(SVO) 어순을 따릅니다. 주어가 먼저 오고, 그 다음에 동사, 마지막에 목적어가 옵니다.",
        "ja": "中国語は英語と同様に、主語-動詞-目的語（SVO）の語順に従います。主語が最初に来て、次に動詞、最後に目的語が来ます。",
        "es": "El chino sigue el orden Sujeto-Verbo-Objeto (SVO), igual que el inglés. El sujeto va primero, luego el verbo, y finalmente el objeto.",
        "fr": "Le chinois suit l'ordre Sujet-Verbe-Objet (SVO), comme l'anglais. Le sujet vient en premier, puis le verbe, et enfin l'objet.",
        "de": "Chinesisch folgt der Subjekt-Verb-Objekt (SVO) Wortstellung, wie Englisch. Das Subjekt kommt zuerst, dann das Verb, dann das Objekt."
      },
      "example_target": "我是学生。",
      "example_breakdown": {
        "en": "我 (I / subject) + 是 (am / verb) + 学生 (student / object).",
        "zh": "我（主语）+ 是（动词）+ 学生（宾语）。",
        "zh_TW": "我（主語）+ 是（動詞）+ 學生（賓語）。",
        "ko": "我(주어) + 是(동사) + 学生(목적어).",
        "ja": "我（主語）+ 是（動詞）+ 学生（目的語）。",
        "es": "我 (yo / sujeto) + 是 (soy / verbo) + 学生 (estudiante / objeto).",
        "fr": "我 (je / sujet) + 是 (suis / verbe) + 学生 (étudiant / objet).",
        "de": "我 (ich / Subjekt) + 是 (bin / Verb) + 学生 (Schüler / Objekt)."
      },
      "related_vocabulary": ["我", "是", "学生", "你", "老师"],
      "source": "Chinese Grammar Wiki — A1 Basic Sentence Order (CC-BY-NC-SA — REFERENCE ONLY)",
      "source_status": "SOURCE_DERIVED",
      "source_note": "Grammar concept is public knowledge. Wording is original. Original source used as reference only due to NC license."
    }
  ]
}
```

**CRITICAL RULE — Grammar translations:** Every `rule` and `example_breakdown` field MUST have ALL 8 locale translations filled in with meaningful, natural text in that language. **Never** copy the English text into other locale fields. **Never** leave a locale empty.

For Korean and Japanese grammar points specifically: if you are NOT confident in your Korean or Japanese translation, tag those specific locale entries with `"⚠️ NEEDS NATIVE REVIEW"` at the end. Example: `"ko": "한국어 번역입니다. ⚠️ NEEDS NATIVE REVIEW"`. This is honest and safe — the developer can spot-fix tagged entries.

### 5.4 Dialogue Schema (`dialogues.json`)

```json
{
  "meta": {
    "language": "zh",
    "exam_level": "HSK 1",
    "total_dialogues": 8
  },
  "dialogues": [
    {
      "id": "zh_hsk1_d001",
      "topic": "问候 - 第一次见面 (Greetings - First Meeting)",
      "max_teaching_order": 15,
      "context": {
        "en": "Two students meeting for the first time at school.",
        "zh": "两个学生第一次在学校见面。",
        "zh_TW": "兩個學生第一次在學校見面。",
        "ko": "두 학생이 학교에서 처음 만납니다.",
        "ja": "二人の学生が学校で初めて会います。",
        "es": "Dos estudiantes se conocen por primera vez en la escuela.",
        "fr": "Deux étudiants se rencontrent pour la première fois à l'école.",
        "de": "Zwei Schüler treffen sich zum ersten Mal in der Schule."
      },
      "turns": [
        {
          "speaker": "A",
          "text": "你好！",
          "is_user": false
        },
        {
          "speaker": "B",
          "text": "你好！",
          "is_user": true,
          "acceptable_answers": ["你好！", "你好吗？", "您好！"]
        },
        {
          "speaker": "A",
          "text": "你叫什么名字？",
          "is_user": false
        },
        {
          "speaker": "B",
          "text": "我叫小明。你呢？",
          "is_user": true,
          "acceptable_answers": ["我叫小明。你呢？", "我是小明。你呢？", "我叫小明。"]
        },
        {
          "speaker": "A",
          "text": "我叫小红。",
          "is_user": false
        }
      ],
      "vocabulary_used": ["你", "好", "叫", "什么", "名字", "我", "呢"],
      "grammar_points_used": ["是 sentence pattern", "吗 question particle"],
      "source": "AI-generated from HSK 1 vocabulary — needs human review for naturalness",
      "source_status": "SOURCE_DERIVED"
    }
  ]
}
```

**Dialogue rules:**
- 4-8 turns minimum
- At least 2 turns where `is_user: true`
- `acceptable_answers`: Include the exact expected text PLUS 1-2 natural alternatives
- Every word used must be from the vocabulary list for this exam level
- `max_teaching_order` ensures dialogues only use words the learner has been taught
- Context must be translated to ALL 8 locales

### 5.5 Reading Passage Schema (`passages.json`)

```json
{
  "meta": {
    "language": "zh",
    "exam_level": "HSK 1",
    "total_passages": 8
  },
  "passages": [
    {
      "id": "zh_hsk1_p001",
      "title": "小明的一天",
      "exam_level": "HSK 1",
      "max_teaching_order": 60,
      "text": "小明是学生。他每天早上七点起床。他先吃早饭，然后去学校。学校有十个学生和两个老师。小明喜欢学习中文。下午四点，他回家。晚上他在家看书。",
      "char_count": 58,
      "vocabulary_used": ["学生", "早上", "七点", "起床", "吃", "早饭", "然后", "去", "学校", "十", "两", "老师", "喜欢", "学习", "中文", "下午", "四点", "回家", "晚上", "看书"],
      "questions": [
        {
          "question": "小明几点起床？",
          "question_translation_en": "What time does Xiaoming get up?",
          "options": ["六点", "七点", "八点", "九点"],
          "answer": "七点",
          "distractor_rationale": "All are time expressions using numbers from the same vocabulary set — common learner error pattern.",
          "question_type": "detail"
        },
        {
          "question": "学校有几个老师？",
          "question_translation_en": "How many teachers are at the school?",
          "options": ["一个", "两个", "十个", "四个"],
          "answer": "两个",
          "distractor_rationale": "Number expressions from passage — tests careful reading vs skimming.",
          "question_type": "detail"
        },
        {
          "question": "小明喜欢学什么？",
          "question_translation_en": "What does Xiaoming like to study?",
          "options": ["中文", "英文", "日文", "韩文"],
          "answer": "中文",
          "distractor_rationale": "All language names — semantically related distractors.",
          "question_type": "detail"
        }
      ],
      "source": "AI-generated from HSK 1 vocabulary — NEEDS NATIVE REVIEW for naturalness",
      "source_status": "SOURCE_DERIVED"
    }
  ]
}
```

**Passage rules:**
- Length: 50-100 characters for HSK 1/JLPT N5/TOPIK I; 80-150 for HSK 2/JLPT N4; 100-200 for HSK 3
- Every word in the passage MUST be from the vocabulary list (no unseen words)
- Questions must be IN THE TARGET LANGUAGE (this mirrors real exam format where questions are in the language being tested)
- 3-5 questions per passage
- All distractor options must be plausible and from the same vocabulary set

### 5.6 Kanji Schema (`kanji.json`) — Japanese Only

```json
{
  "meta": {
    "language": "ja",
    "exam_level": "JLPT N5",
    "total_kanji": 100,
    "source": "kanji-data GitHub (MIT) + JLPT official kanji list",
    "source_status": "SOURCE_VERIFIED"
  },
  "kanji": [
    {
      "id": "ja_n5_k001",
      "character": "学",
      "onyomi": ["ガク"],
      "kunyomi": ["まな-ぶ"],
      "meaning_en": "study; learning; science",
      "stroke_count": 8,
      "jlpt_level": "N5",
      "teaching_order": 5,
      "example_words": [
        { "word": "学生", "reading": "がくせい", "meaning_en": "student" },
        { "word": "学校", "reading": "がっこう", "meaning_en": "school" },
        { "word": "大学", "reading": "だいがく", "meaning_en": "university" }
      ],
      "source": "davidluzgouveia/kanji-data (GitHub, MIT)",
      "source_status": "SOURCE_VERIFIED"
    }
  ]
}
```

### 5.7 Kana Schema (`kana.json`) — Japanese Foundation

```json
{
  "meta": {
    "language": "ja",
    "type": "foundation",
    "description": "Hiragana and Katakana character tables for absolute beginners"
  },
  "hiragana": [
    { "character": "あ", "romaji": "a", "row": "vowels", "stroke_order_url": null },
    { "character": "い", "romaji": "i", "row": "vowels", "stroke_order_url": null }
  ],
  "katakana": [
    { "character": "ア", "romaji": "a", "row": "vowels", "stroke_order_url": null },
    { "character": "イ", "romaji": "i", "row": "vowels", "stroke_order_url": null }
  ]
}
```

### 5.8 Exam Mock Test Schema (`mock_test.json`)

This is the most complex schema. Mock tests must match the REAL exam format. Research the official format FIRST before writing a single question.

#### HSK 1 Mock Test Structure

```json
{
  "meta": {
    "exam": "HSK 1",
    "language": "zh",
    "level": 1,
    "total_questions": 40,
    "passing_score_pct": 60,
    "time_limit_minutes": 40,
    "source": "Format based on official HSK 1 test specification (hsk.org.cn)",
    "source_status": "SOURCE_DERIVED"
  },
  "sections": [
    {
      "id": "hsk1_listening_1",
      "section_name": "Listening — Part 1: True or False",
      "type": "listening_tf",
      "question_count": 5,
      "description": "Listen to a phrase and decide if the statement matches.",
      "questions": [
        {
          "id": "hsk1_mock_l1_q1",
          "audio_prompt": "他是学生。",
          "statement": "He is a teacher.",
          "answer": false,
          "explanation": {
            "en": "The audio says \"他是学生\" (He is a student), not teacher (老师).",
            "zh": "录音说的是\"他是学生\"，意思是\"He is a student\"，不是老师。",
            "zh_TW": "錄音說的是\"他是學生\"，意思是\"He is a student\"，不是老師。",
            "ko": "오디오는 \"그는 학생입니다\"라고 말합니다. 선생님이 아닙니다.",
            "ja": "音声は「彼は学生です」と言っています。先生ではありません。",
            "es": "El audio dice \"他是学生\" (Él es estudiante), no profesor.",
            "fr": "L'audio dit \"他是学生\" (Il est étudiant), pas professeur.",
            "de": "Das Audio sagt \"他是学生\" (Er ist Schüler), nicht Lehrer."
          },
          "vocabulary_tested": ["学生", "他", "是"],
          "grammar_tested": ["是 sentence pattern"]
        }
      ]
    },
    {
      "id": "hsk1_listening_2",
      "section_name": "Listening — Part 2: Choose the Right Picture",
      "type": "listening_picture",
      "question_count": 5,
      "description": "Listen to a sentence and choose the matching picture.",
      "questions": []
    },
    {
      "id": "hsk1_listening_3",
      "section_name": "Listening — Part 3: Short Dialogue",
      "type": "listening_dialogue",
      "question_count": 5,
      "description": "Listen to a short dialogue and answer a question.",
      "questions": []
    },
    {
      "id": "hsk1_listening_4",
      "section_name": "Listening — Part 4: Fill in the Blank",
      "type": "listening_cloze",
      "question_count": 5,
      "description": "Listen and choose the word that completes the sentence.",
      "questions": []
    },
    {
      "id": "hsk1_reading_1",
      "section_name": "Reading — Part 1: Match Sentence to Picture",
      "type": "reading_picture",
      "question_count": 5,
      "description": "Read a sentence and determine if it matches the picture.",
      "questions": []
    },
    {
      "id": "hsk1_reading_2",
      "section_name": "Reading — Part 2: Choose the Correct Word",
      "type": "reading_cloze",
      "question_count": 5,
      "description": "Fill in the blank with the correct word.",
      "questions": []
    },
    {
      "id": "hsk1_reading_3",
      "section_name": "Reading — Part 3: Sentence Comprehension",
      "type": "reading_mc",
      "question_count": 5,
      "description": "Read a sentence and answer a question about it.",
      "questions": []
    },
    {
      "id": "hsk1_reading_4",
      "section_name": "Reading — Part 4: Sentence Ordering",
      "type": "reading_reorder",
      "question_count": 5,
      "description": "Arrange the words to form a correct sentence.",
      "questions": []
    }
  ]
}
```

#### Exam Format Reference (What to Research)

| Exam | Sections | Question Types | Time (real exam) |
|------|----------|---------------|-----------------|
| HSK 1 | Listening (20q) + Reading (20q) | True/false, picture match, dialogue, cloze, sentence match, reorder | ~35 min |
| HSK 2 | Listening (35q) + Reading (25q) | Similar to HSK 1 + longer dialogues | ~50 min |
| HSK 3 | Listening (40q) + Reading (30q) + Writing (10q) | Adds listening comprehension, reading comprehension, sentence completion | ~85 min |
| TOPIK I | Listening (30q) + Reading (40q) | Multiple choice, picture match, short passage, cloze | 100 min |
| JLPT N5 | Vocabulary (12q) + Grammar (10q) + Reading (6q) + Listening (14q) | Kanji reading, vocab meaning, grammar cloze, reading comprehension, listening comprehension | ~105 min |
| JLPT N4 | Vocabulary (14q) + Grammar (10q) + Reading (10q) + Listening (14q) | Similar to N5 but longer passages, more grammar patterns | ~125 min |

**For the mock test in this app:** Scale to 30-40 questions (not the full exam length — this is a mobile-friendly mock, not a full simulation). Keep the same section types and proportion. Explain in PIPELINE_LOG.md how you scaled it.

### 5.9 UI Translations Schema (`ui_translations.json`)

The developer needs these new ARB keys for exam-mode UI elements. Output FULL translations for all 8 locales for every key:

```json
{
  "meta": {
    "description": "New ARB keys needed for exam mode features. The developer will add these to lib/l10n/app_*.arb files.",
    "locales": ["en", "zh", "zh_TW", "ko", "ja", "es", "fr", "de"]
  },
  "new_keys": {
    "examModeTitle": {
      "en": "Exam Prep", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "examTrackLabel": {
      "en": "{exam_name} Prep", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "foundationTrackLabel": {
      "en": "Basics", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "mockTestTitle": {
      "en": "Mock Test", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "mockTestDescription": {
      "en": "Full-length practice test simulating the real {exam_name}", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "timeRemaining": {
      "en": "Time remaining", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "yourScore": {
      "en": "Your score", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "predictedLevel": {
      "en": "Predicted level: {level}", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "passingNote": {
      "en": "Pass mark: {pct}%", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "examCompleteTitle": {
      "en": "Mock Test Complete!", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "examCompleteBody": {
      "en": "You scored {score}/{total}. Your predicted level is {level}.", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "reviewMistakes": {
      "en": "Review Mistakes", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "retakeTest": {
      "en": "Retake Test", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "examPrepHome": {
      "en": "Back to Exam Tracks", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "hskLabel": {
      "en": "HSK", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "topikLabel": {
      "en": "TOPIK", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "jlptLabel": {
      "en": "JLPT", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "levelIndicator": {
      "en": "Level {n}", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "vocabCount": {
      "en": "{count} words", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "grammarCount": {
      "en": "{count} grammar points", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "listeningSection": {
      "en": "Listening", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "readingSection": {
      "en": "Reading", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "writingSection": {
      "en": "Writing", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "matchPairsInstruction": {
      "en": "Tap a word on the left, then its match on the right",
      "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    },
    "levelAbbreviation": {
      "en": "LV", "zh": "", "zh_TW": "", "ko": "", "ja": "", "es": "", "fr": "", "de": ""
    }
  },
  "fixed_keys": {
    "super": { "ko": "슈퍼", "ja": "スーパー" },
    "superMarket": { "ko": "슈퍼 마켓", "ja": "スーパーマーケット" }
  }
}
```

### 5.10 Achievement Translations Schema (`achievement_translations.json`)

```json
{
  "meta": {
    "description": "Translations for 6 achievement badges. The developer will refactor Achievement.dart to use LocalizedText.",
    "locales": ["en", "zh", "zh_TW", "ko", "ja", "es", "fr", "de"]
  },
  "achievements": [
    {
      "id": "first_lesson",
      "title": {
        "en": "First Steps", "zh": "第一步", "zh_TW": "第一步",
        "ko": "첫걸음", "ja": "第一歩",
        "es": "Primeros pasos", "fr": "Premiers pas", "de": "Erste Schritte"
      },
      "description": {
        "en": "Complete your first lesson",
        "zh": "完成第一课", "zh_TW": "完成第一課",
        "ko": "첫 번째 레슨 완료", "ja": "最初のレッスンを完了",
        "es": "Completa tu primera lección", "fr": "Terminez votre première leçon",
        "de": "Schließe deine erste Lektion ab"
      },
      "iconName": "first_steps",
      "tier": "bronze",
      "targetValue": 1
    },
    {
      "id": "streak_7",
      "title": {
        "en": "Week Warrior", "zh": "周勇士", "zh_TW": "週勇士",
        "ko": "주간 전사", "ja": "週間戦士",
        "es": "Guerrero semanal", "fr": "Guerrier de la semaine", "de": "Wochenkrieger"
      },
      "description": {
        "en": "Maintain a 7-day streak",
        "zh": "保持连续7天学习", "zh_TW": "保持連續7天學習",
        "ko": "7일 연속 학습 유지", "ja": "7日連続学習を維持",
        "es": "Mantén una racha de 7 días", "fr": "Maintenez une série de 7 jours",
        "de": "Halte eine 7-Tage-Serie"
      },
      "iconName": "streak_7",
      "tier": "silver",
      "targetValue": 7
    },
    {
      "id": "mock_test_pass",
      "title": {
        "en": "Exam Ready", "zh": "考试就绪", "zh_TW": "考試就緒",
        "ko": "시험 준비 완료", "ja": "試験準備完了",
        "es": "Listo para el examen", "fr": "Prêt pour l'examen", "de": "Prüfungsbereit"
      },
      "description": {
        "en": "Pass a mock test with a score above 60%",
        "zh": "模拟考试得分超过60%", "zh_TW": "模擬考試得分超過60%",
        "ko": "모의고사 60% 이상 득점", "ja": "模擬試験で60%以上を獲得",
        "es": "Aprueba un examen de prueba con más del 60%",
        "fr": "Réussissez un examen blanc avec plus de 60%",
        "de": "Bestehe eine Probeprüfung mit über 60%"
      },
      "iconName": "exam_ready",
      "tier": "gold",
      "targetValue": 1
    }
  ]
}
```

---

## 6. How Your JSON Becomes App Exercises

You do NOT need to write Dart code or generate exercises directly. But you DO need to understand how your JSON data maps to exercises so you can ensure your outputs are complete and usable.

### 6.1 The Conversion Pipeline

```
Your JSON files
    │
    ▼
tools/build_courses_from_raw.py   ← Developer runs this
    │
    ▼
tools/json_to_dart.py             ← Converts to Dart code
    │
    ▼
lib/data/demo_data.dart           ← Final output, compiled into app
```

**Your job stops at producing the JSON files.** The Python scripts handle everything downstream.

### 6.2 How Each Vocabulary Word Becomes Exercises

Every vocabulary word generates at minimum:

| Exercise Type | Generated From | Example |
|--------------|----------------|---------|
| `flashCard` | `word` + `phonetic` + `meaning` | Show "学校 (xuéxiào)" → flip to reveal "school" |
| `vocabularyMultipleChoice` | `word` + `meaning` + `distractors` | "What does 学校 mean?" Options: [school, student, study, class] |
| `matchPairs` | `word` + `meaning.en` (or phonetic) | Match "学校" ↔ "school" |
| `listenAndType` | `word` + `phonetic` + `audio_url` | Hear "xuéxiào" → type the pinyin |
| `imageIdentification` | `word` + `image_url` (later) | See a school → tap "学校" |

### 6.3 How Sentences Become Exercises

| Exercise Type | Generated From | Example |
|--------------|----------------|---------|
| `fillInBlank` | `target_sentence` + `vocabulary_used` | "我是___。" Options: [学生, 老师, 医生, 工人] |
| `translateSentence` | `target_sentence` ↔ `translation_en` | Translate: "我是学生。" → "I am a student." |
| `wordSorting` | `target_sentence` shuffled | ["学生", "我", "是"] → correct order: "我是学生" |
| `phraseBuilderPrefilled` | `target_sentence` with blanks | Build sentence from word blocks |

### 6.4 How Grammar Points Become Exercises

| Exercise Type | Generated From | Example |
|--------------|----------------|---------|
| `grammarTip` | `rule` + `example_target` + `example_breakdown` | Display grammar rule with example |
| `grammarTrueFalse` | Modified version of `rule` | "Chinese uses SOV word order" → True/False |
| `comprehensionText` | `passage.text` + `passage.questions` | Read passage → answer questions |

### 6.5 How Dialogues Become Exercises

| Exercise Type | Generated From | Example |
|--------------|----------------|---------|
| `dialogueComplete` | `turns` with `is_user: true` blanks | Show dialogue → user fills missing turns |

### 6.6 What You Must Ensure for the Pipeline to Work

1. **Every vocabulary word needs exactly 3 distractors.** No more, no less (unless the vocabulary list is too small — then flag it).
2. **Every sentence needs `vocabulary_used` populated.** The pipeline uses this to verify no word appears before it's taught.
3. **Every grammar point needs `teaching_order`.** Grammar must be introduced after the vocabulary it uses.
4. **Every LocalizedText field (rule, explanation, example_breakdown, context) needs ALL 8 locales.**
5. **The `id` fields must be unique across all files for a given language.** The pipeline uses IDs to deduplicate.

### 6.7 What the Pipeline CANNOT Fix

If you output data with these problems, the pipeline will fail or produce broken exercises:

- Missing locale entries (app crashes on locale switch)
- Vocabulary words with no distractors (multiple choice has 1 option)
- Sentences using vocabulary not in the vocabulary list (pipeline can't verify)
- Grammar points with `teaching_order: 1` that use `teaching_order: 50` vocabulary (nonsensical ordering)
- Exam questions with answers not in the options list

---

## 7. Validation Rules — Run Against Every File

Before delivering ANY file, validate it against these rules. Output results in `shared/validation_report.json`.

### Rule 1: ALL LOCALIZED TEXT FIELDS HAVE 8 NON-EMPTY ENTRIES

```python
REQUIRED_LOCALES = {'en', 'zh', 'zh_TW', 'ko', 'ja', 'es', 'fr', 'de'}

def validate_localized_text(obj, path=""):
    """Recursively check that every dict-like object with locale keys has all 8."""
    if isinstance(obj, dict):
        if all(k in REQUIRED_LOCALES for k in obj.keys() if len(k) == 2):
            missing = REQUIRED_LOCALES - set(obj.keys())
            assert not missing, f"{path}: MISSING locales: {missing}"
            empty = [k for k, v in obj.items() if k in REQUIRED_LOCALES and (v is None or str(v).strip() == "")]
            assert not empty, f"{path}: EMPTY values for locales: {empty}"
        for k, v in obj.items():
            validate_localized_text(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, item in enumerate(obj):
            validate_localized_text(item, f"{path}[{i}]")
```

### Rule 2: NO ENGLISH LEAKAGE IN NON-ENGLISH LOCALES

```python
def validate_no_english_leakage(obj, path=""):
    """For any locale key != 'en', the value must differ from the 'en' value."""
    EXCEPTIONS = {"InstaLingo", "HSK", "TOPIK", "JLPT", "XP", "AI", "OK", "DNA"}
    if isinstance(obj, dict):
        if 'en' in obj:
            en_val = str(obj['en']).strip()
            for loc in REQUIRED_LOCALES - {'en'}:
                if loc in obj:
                    loc_val = str(obj[loc]).strip()
                    if loc_val == en_val and en_val not in EXCEPTIONS:
                        print(f"WARNING {path}.{loc}: Same as English — '{en_val[:80]}'")
```

### Rule 3: TEACHING ORDER IS SEQUENTIAL AND THEMATIC

Vocabulary `teaching_order` must follow the category ranges in Section 2.3. Verify:
- No duplicate `teaching_order` values
- `teaching_order` starts at 1 and is sequential (gaps are OK, but no jumps > 20 within a topic)
- Grammar `teaching_order` is interleaved (roughly 1 grammar point per 7-10 vocab words)

### Rule 4: NO WORD USED BEFORE IT'S TAUGHT

For every sentence, dialogue, and passage: `max_teaching_order` must be >= the highest `teaching_order` of any vocabulary word used. This ensures the learner has encountered every word before seeing it in context.

### Rule 5: DISTRACTORS ARE PLAUSIBLE AND FROM THE SAME VOCABULARY SET

Each multiple-choice question must have distractors that:
- Are from the same vocabulary list (not fabricated words)
- Are from the same word class (noun, verb, adjective)
- Are NOT the correct answer (obviously)
- Are NOT obviously wrong (e.g., a number as a distractor for a color question)
- Include at least one "near-miss" distractor (a word a real learner would confuse)

### Rule 6: EXAM QUESTIONS FOLLOW THE REAL EXAM FORMAT

Each mock_test.json must:
- Have sections in the same order as the real exam
- Have the same question types per section
- Test vocabulary and grammar from the corresponding exam level ONLY
- NOT include questions that would require vocabulary/grammar from a higher level

### Rule 7: NO DUPLICATE CONTENT

No two vocabulary words with the same `word` value. No two sentences with the same `target_sentence`. No duplicate exam questions. No duplicate distractor sets.

### Rule 8: SOURCE ATTRIBUTION ON EVERY ITEM

Every vocabulary word, sentence, grammar point, dialogue, passage, and exam question must have a `source` field and a `source_status` field. Nothing ships anonymous.

### Rule 9: ALL IDs ARE UNIQUE WITHIN A LANGUAGE

Vocabulary IDs, sentence IDs, grammar IDs, dialogue IDs, passage IDs, and exam question IDs must all be unique within the same language. Use the naming conventions from the schemas.

---

## 8. Execution Order — Follow This Exactly

```
STEP 0 — SETUP & SOURCE VERIFICATION
  0.1 Create SOURCES.md — list every source you'll try
  0.2 Create BLOCKERS.md — empty, ready for issues
  0.3 Verify web access. Note in PIPELINE_LOG.md whether ONLINE or OFFLINE.
  0.4 For each primary source in Section 4, attempt access. Log result.
  0.5 For each accessible source, note the license. Flag NC licenses.
  0.6 If any primary source fails, try fallback. Log it in BLOCKERS.md.

STEP 1 — CHINESE (do this first — easiest to verify, sets quality bar)
  1.1 Build chinese/foundation/vocabulary.json (30 words)
  1.2 Build chinese/foundation/grammar.json (5 points)
  1.3 Build chinese/foundation/sentences.json (30 pairs)
  1.4 Build chinese/hsk1/vocabulary.json (150 words)
  1.5 Build chinese/hsk1/grammar.json (15 points)
  1.6 Build chinese/hsk1/sentences.json (120 pairs)
  1.7 Build chinese/hsk1/dialogues.json (8 dialogues)
  1.8 Build chinese/hsk1/passages.json (8 passages)
  1.9 Build chinese/hsk1/mock_test.json (40 questions)
  1.10 Build chinese/hsk2/ (repeat 1.4-1.9 for HSK 2)
  1.11 Build chinese/hsk3/ (repeat 1.4-1.9 for HSK 3)
  1.12 Run ALL 9 validation rules against chinese/ output
  1.13 Fix any validation failures

STEP 2 — KOREAN (developer needs native-speaker review)
  2.1 Build korean/foundation/vocabulary.json
  2.2 Build korean/foundation/grammar.json
  2.3 Build korean/foundation/sentences.json
  2.4 Build korean/topik1/vocabulary.json (300 words)
  2.5 Build korean/topik1/grammar.json (40 points)
  2.6 Build korean/topik1/sentences.json (150 pairs)
  2.7 Build korean/topik1/dialogues.json (10 dialogues)
  2.8 Build korean/topik1/passages.json (10 passages)
  2.9 Build korean/topik1/mock_test.json (30 questions)
  2.10 Run ALL 9 validation rules against korean/ output
  2.11 Tag ALL Korean grammar rule translations with "NEEDS NATIVE REVIEW" marker where confidence is not 100%

STEP 3 — JAPANESE (developer needs native-speaker review)
  3.1 Build japanese/foundation/vocabulary.json
  3.2 Build japanese/foundation/kana.json
  3.3 Build japanese/foundation/grammar.json
  3.4 Build japanese/foundation/sentences.json
  3.5 Build japanese/jlpt_n5/vocabulary.json (300 words)
  3.6 Build japanese/jlpt_n5/kanji.json (100 kanji)
  3.7 Build japanese/jlpt_n5/grammar.json (40 points)
  3.8 Build japanese/jlpt_n5/sentences.json (150 pairs)
  3.9 Build japanese/jlpt_n5/dialogues.json (10 dialogues)
  3.10 Build japanese/jlpt_n5/passages.json (10 passages)
  3.11 Build japanese/jlpt_n5/mock_test.json (30 questions)
  3.12 Build japanese/jlpt_n4/ (repeat 3.5-3.11 for N4)
  3.13 Run ALL 9 validation rules against japanese/ output
  3.14 Tag ALL Japanese grammar rule translations with "NEEDS NATIVE REVIEW" marker where applicable

STEP 4 — SHARED FILES
  4.1 Build shared/ui_translations.json (fill ALL 8 locales, don't leave blanks)
  4.2 Build shared/achievement_translations.json
  4.3 Run cross-language validation (no vocab word appears in multiple languages with different meanings)
  4.4 Build shared/validation_report.json (combine all validation results)

STEP 5 — FINAL DOCUMENTATION
  5.1 Update SOURCES.md with final status of every source
  5.2 Update BLOCKERS.md with everything that failed
  5.3 Write PIPELINE_LOG.md:
      - Which steps completed successfully
      - Total counts (words, sentences, grammar, questions) per language/level
      - All SOURCE_INACCESSIBLE items with what you tried
      - All SOURCE_DERIVED items with what you changed
      - Validation results per file, per rule
      - Recommendations for what needs human review first
      - Estimate of human review effort needed (hours per language)
      - List of specific items tagged "NEEDS NATIVE REVIEW"
```

---

## 9. What AI Cannot Do — Human Review Required

This section is HONEST. Do not pretend you can do these things. The developer needs to know what to verify.

### 9.1 What AI CAN Do Reliably

| Task | Confidence | Notes |
|------|-----------|-------|
| Download and parse CSV/JSON from URLs | 95% | Fails if blocked/paywalled |
| Extract and normalize vocabulary lists | 90% | May misclassify rare POS |
| Filter Tatoeba sentences by language and length | 100% | Mechanical task |
| Generate 8-language translations | 85% | Minor errors in Korean/Japanese possible |
| Validate JSON schemas and locale completeness | 100% | Mechanical validation |
| Sort vocabulary into thematic groups | 85% | Edge cases possible |
| Generate distractor words from a vocabulary set | 80% | Rules-based, but may miss learner confusion patterns |
| Write exam questions matching a format template | 75% | Format correct, content quality varies |

### 9.2 What AI CANNOT Do — Must Be Human-Verified

| Task | Why AI Can't | Who Must Do It | Cost Estimate |
|------|-------------|----------------|--------------|
| **Judge Korean sentence naturalness** | AI Korean often has correct grammar but unnatural phrasing | Native Korean speaker | $15-30/hr, ~5hr = $75-150 |
| **Verify Japanese kanji readings** | On/kun readings are context-dependent; AI frequently picks wrong reading | JLPT-certified Japanese speaker | $15-30/hr, ~5hr = $75-150 |
| **Confirm vocabulary is truly on the official exam list** | AI training data may include outdated or unofficial lists | Cross-reference with official exam body | 1hr per language |
| **Verify grammar rule accuracy (Korean/Japanese)** | Korean particles (은/는 vs 이/가) and Japanese particles (は vs が) have subtle distinctions AI often gets wrong | Native-speaker linguist | Part of review above |
| **Judge distractor quality** | AI can find similar words but doesn't know which specific pairs learners actually confuse | Experienced teacher | Part of review above |
| **Catch cultural inappropriateness** | AI doesn't know that certain examples are culturally weird | Native speaker from that culture | Part of review above |
| **License verification** | AI can identify license text but cannot provide legal advice | Human (developer or lawyer) | 1-2 hours |

### 9.3 The Recommended Human Review Workflow

1. Developer reviews Chinese content PERSONALLY (native speaker) → 2-3 hours, $0
2. Hire Korean native speaker on Upwork: "Review 300 TOPIK I vocabulary words, 40 grammar explanations, 150 sentences, and 30 exam questions for naturalness and accuracy." → ~5 hours, $75-150
3. Hire Japanese native speaker on Upwork: "Review 300 JLPT N5 vocabulary, 100 kanji readings, 40 grammar explanations, 150 sentences, and 30 exam questions." → ~5 hours, $75-150
4. Developer does final license check on all sources → 1 hour
5. Developer runs json_to_dart.py, builds app, smoke-tests each course → 1 hour

**TOTAL HUMAN EFFORT: ~15 hours, $150-300**

---

## 10. If You Cannot Access the Web — Offline Mode

### 10.1 Detection

At the start of Phase 0, try to access: `https://downloads.tatoeba.org/exports/sentences.csv`

If this fails (timeout, 403, DNS error, or you're running in an environment without HTTP), you are in **offline mode**. Log this in PIPELINE_LOG.md and switch to this protocol.

### 10.2 What You Can Still Do Offline

Your training data contains substantial knowledge of:

1. **HSK vocabulary** — The HSK word lists are published international standards. Your training data almost certainly includes them. You can reconstruct HSK 1-3 vocabulary from your knowledge, but tag every word as `SOURCE_INACCESSIBLE`.

2. **TOPIK I vocabulary** — Similarly published. You likely know the common TOPIK I words (가다, 오다, 먹다, etc.).

3. **JLPT N5-N4 vocabulary and kanji** — The JLPT levels are well-documented. You likely know the N5 kanji list (~100 characters).

4. **Basic grammar patterns** — SVO/SOV word order, particle usage, tense formation, negation, question formation are public linguistic knowledge.

5. **Common sentence patterns** — You can generate example sentences from vocabulary, tagged as `SOURCE_INACCESSIBLE`.

### 10.3 What You CANNOT Do Offline

1. **Download Tatoeba sentences** → Skip the Tatoeba step. Generate sentences from vocabulary. Tag ALL sentences as `"AI-generated from vocabulary knowledge — NO TATOEBA ACCESS — NEEDS NATIVE REVIEW"`.

2. **Verify vocabulary against official lists** → Output vocabulary from your knowledge but tag it. Include a note: "This vocabulary list is reconstructed from AI training data, not downloaded from an official source. Verify against official HSK/TOPIK/JLPT syllabus before using."

3. **Confirm exam format details** → Use the format descriptions in Section 5.8 of this prompt. If you're unsure about the exact section breakdown, use the structure provided and note your uncertainty.

### 10.4 Offline Output Tagging

In offline mode, ALL content gets tagged:
```
source_status: "SOURCE_INACCESSIBLE"
source: "[EXAM NAME] syllabus, reconstructed from AI training data — not verified against official source — NEEDS HUMAN VERIFICATION"
```

This is honest. The developer knows exactly what needs checking.

### 10.5 If You Also Cannot Generate Translations

If you cannot translate into Korean, Japanese, or the European locales with confidence:

1. Fill in `en`, `zh`, and `zh_TW` locales (Chinese is the developer's native language)
2. For `ko`, `ja`, `es`, `fr`, `de` locales: fill with placeholder text: `"TRANSLATION NEEDED — [English text here]"`
3. Log this in BLOCKERS.md
4. The developer can batch-translate these using a translation API

**This is FAR better than submitting wrong translations.** Wrong translations teach learners incorrect language. Missing translations are obviously incomplete and get fixed.

---

## 11. Output Format & Developer Handoff

### 11.1 What You Deliver

A directory called `instalingo_content/` containing:
1. All the JSON files listed in Section 3
2. `SOURCES.md` — every source, URL, access date, license status, whether accessible
3. `BLOCKERS.md` — every problem encountered, what you tried, what's blocked
4. `PIPELINE_LOG.md` — execution summary, counts, validation results, review recommendations

### 11.2 What Happens Next (Developer's Job)

The developer will:
1. Review `BLOCKERS.md` first — resolve blocked sources or accept gaps
2. Review `PIPELINE_LOG.md` — understand what needs human review
3. Send Korean and Japanese content to native speakers for verification
4. Personally verify all Chinese content
5. Resolve any license issues flagged in `SOURCES.md`
6. Run `tools/build_courses_from_raw.py` to convert JSON → course structure
7. Run `tools/json_to_dart.py` to generate `demo_data.dart`
8. Add the new ARB keys from `shared/ui_translations.json` to `lib/l10n/app_*.arb`
9. Refactor `lib/models/achievement.dart` to use `LocalizedText`
10. Build and test the app with each locale

### 11.3 File Format Rules

- ALL files must be valid UTF-8 JSON
- NO trailing commas (JSON spec doesn't allow them)
- ALL strings must use double quotes, not single quotes
- Pretty-print with 2-space indentation
- Maximum line length: 120 characters (wrap longer strings)
- If a file would exceed 50,000 lines, split it: `vocabulary_part1.json`, `vocabulary_part2.json`

### 11.4 Do NOT Output

- Dart code (the Python scripts handle this)
- Python scripts (they already exist)
- Flutter widgets
- ARB files (output ui_translations.json instead)
- Any binary files (images, audio)
- HTML, CSS, or any web files
- PDF files

---

## 12. Start Here — First Actions

1. READ THIS ENTIRE DOCUMENT. Do not skip sections. The schemas in Section 5 and the validation rules in Section 7 are binding.

2. Create `instalingo_content/` directory.

3. Create `SOURCES.md` with the source table from Section 4. Mark each source as "NOT YET CHECKED".

4. Create `BLOCKERS.md` with header: "# Blockers & Issues — InstaLingo Content Pipeline" and today's date. Leave body empty.

5. Attempt to access Tatoeba: download the first 10 lines of sentences.csv to verify connectivity. Log result.

6. Attempt to access ONE Chinese source (e.g., plaktos/hsk_csv on GitHub). Log result.

7. Based on results of steps 5-6, determine if you are in ONLINE or OFFLINE mode. Write this at the top of PIPELINE_LOG.md.

8. Begin Phase 1 (Chinese). Chinese is the developer's native language — they can personally verify it. This is your proof-of-quality. If Chinese output is good, the Korean/Japanese output (with review flags) follows the same standards.

9. Follow the Execution Order in Section 8. Do not skip phases.

10. When in doubt: SKIP AND REPORT. Never fabricate.

---

## 13. Quick Reference — Most Common Mistakes to Avoid

| Mistake | Why It's Wrong | How to Avoid |
|---------|---------------|-------------|
| Copying English text into ko/ja locale fields | Korean/Japanese users see English explanations | Actually translate. If unsure, use the "TRANSLATION NEEDED" placeholder |
| Using vocabulary from HSK 3 in an HSK 1 sentence | Learner hasn't learned those words yet | Check max_teaching_order against teaching_order |
| Distractors from a different exam level | Learner shouldn't see words they haven't studied | Only use distractor words from same or earlier teaching_order |
| Grammar point with teaching_order 1 using vocab from teaching_order 50 | Impossible to understand grammar without vocabulary | Set grammar teaching_order AFTER the vocabulary it uses |
| Missing a locale in a LocalizedText field | App crashes or shows blank text | Validate with Rule 1 before delivering |
| Fabricating Tatoeba sentence IDs | The IDs won't match real Tatoeba data | Only use IDs from actual Tatoeba downloads |
| Making exam questions harder than real exam | Gives users false sense of failing | Match real exam difficulty. These are BEGINNER exams |
| Not tagging AI-generated content | Developer won't know what to verify | Every item has a source_status — use it honestly |
| Leaving ui_translations.json locale values empty | Developer has to fill them, defeating the purpose | Fill all 8 locales for every key |
| Mixing up target language vs instruction language | Wrong language shown to user | Target language = plain String. Instruction = LocalizedText |

---

*End of prompt. This document is designed to be handed to any capable AI agent (Claude, Manus, GPT-4, Gemini, etc.) as a complete, self-contained task. The agent outputs the files in Section 3, following all schemas and validation rules, and produces honest documentation about what it could and couldn't do.*
