# InstaLingo — App Reference Research: What to Learn From Competitors

> **Purpose:** Hand this entire file to an AI (Claude, GPT, Manus) to research competitor apps. It maps out exactly what we need to extract from their approaches — lesson structure, data format, teaching methodology, gamification, and content architecture. After research, we implement our own version.

**Date:** 2026-05-27
**InstaLingo Current State:** 7 learning languages × 8 native UI languages = 56 language-pair combinations. 16 exercise types. ~19,000 lines of demo content. All user-visible text must be `LocalizedText` with 8 language entries.

---

## 1. What We Have — Baseline

| Dimension | Current State |
|-----------|--------------|
| **Exercise types** | 16 (vocab MC, fill blank, translate, match pairs, word sort, listen&type, speaking, dialogue, grammar tip, image ID, flash card, comprehension, true/false, phrase builder, writing) |
| **Course structure** | 3 sections × 10 lessons × 5 exercises per course (skeleton) |
| **Lesson flow** | All 5 exercises appear at once; no teach→practice→test separation |
| **Content storage** | Single monolithic `demo_data.dart` file (~20K lines). All content is `const` Dart code. |
| **Localization** | `LocalizedText({en, zh, zh_TW, ja, ko, es, fr, de})` — 8 entries required everywhere |
| **Target/instruction separation** | `question` = target language text; `instruction` = native language text; `contentLang` / `instructionLang` = language codes |
| **Vocab tracking** | Per-lesson `vocabulary` list; builds `learnedWords` set; unlocks Chill Corner posts |
| **Gamification** | XP, gems, streak, confetti, star ratings (1-3) |
| **Review** | 3D flip flashcards with Hard/Good/Easy (no SRS persistence) |
| **Audio/Images** | Fields exist (`audioUrl`, `imageUrl`) but no real assets |
| **Chill Corner** | Instagram-style posts with `requiredWords` gating |

---

## 2. Competitor Apps to Deep-Research

For each app below, research and document the following **6 dimensions**. Be surgical — we need concrete implementation details, not marketing descriptions.

### Research Dimensions (for every app)

1. **Lesson Structure & Flow**
   - How many steps per lesson? (teach → practice → test → review?)
   - How are vocabulary, grammar, and skills interleaved?
   - What % of exercises are input (recognition) vs output (production)?
   - How long does one lesson take? How many exercises?

2. **Exercise Type Catalog**
   - List EVERY distinct exercise interaction they have
   - Map each to our 16 types — what are we missing?
   - Note UI patterns: drag, swipe, tap, type, speak, draw

3. **Content Data Model**
   - How is content stored? (JSON files, SQLite, API, bundled assets)
   - What is the schema? (fields, relationships, nesting)
   - How do they handle multi-language content? (translation keys vs inline text)
   - How do they version/update content without app updates?

4. **Teaching Methodology**
   - How do they introduce new words? (image + audio + example sentence?)
   - How do they teach grammar? (dedicated tips, inline, separate section?)
   - How do they handle skill progression? (CEFR levels, custom levels?)
   - What's their spaced repetition algorithm? (SM-2, Leitner, custom?)

5. **Gamification & Engagement**
   - What keeps users coming back daily?
   - League/competition system? How many tiers? How is XP calculated?
   - Streak mechanics? Freeze/repair/shields?
   - Rewards beyond XP? (cosmetics, power-ups, stories, certificates)
   - How does the first-lesson experience hook users?

6. **Multimedia Usage**
   - How do they handle audio? (TTS, native recordings, both?)
   - How do they use images? (illustrations, photos, icons?)
   - Any video content? AR? Interactive scenes?
   - Speech recognition approach? Pronunciation scoring?

---

### 2.1 Busuu (PRIMARY REFERENCE — already deep-analyzed in `busuuref.md`)

**What we already know:** See `busuuref.md` and `BUSUU_COMPARISON.md`.

**What to research further:**
- Actual lesson JSON structure — obtain sample API responses from `api.busuu.com/exercises/pool`
- How they generate content for 14+ language pairs — do they write each manually or use translation pipelines?
- Their spaced repetition algorithm details — what intervals? How do they weight weak/medium/strong?
- The `translationMap` → `entityMap` resolution system — how do they keep 50+ UI languages in sync?
- How their "Smart Review" selects which words to quiz

**Key adoptable patterns:**
- `instructions_language` (native) vs `answersDisplayLanguage` (native) vs content in `learningLanguage` (target)
- Translation-ID-based content (not inline strings) → enables A/B testing, updates without app release
- `ApiComponent` recursive tree structure for nested lessons

---

### 2.2 Duolingo

**Research queries:**
- "Duolingo lesson JSON structure reverse engineering"
- "Duolingo exercise types list 2024 2025"
- "Duolingo spaced repetition algorithm SM-2"
- "Duolingo skill tree vs path redesign"
- "Duolingo league system tiers XP thresholds"

**What we want to extract:**
- How do they structure a "skill" → "lesson" → "exercise" hierarchy?
- What are ALL their exercise types? (they have many: tap pairs, speak, listen, translate, fill blank, match, read, complete chat, etc.)
- How does their "path" (linear progression) differ from the old "tree"?
- How do they handle streak freeze with gems? What's the exact gem economy?
- League system: BRONZE → SILVER → GOLD → SAPPHIRE → RUBY → EMERALD → AMETHYPT → PEARL → OBSIDIAN → DIAMOND. How many users per league? XP thresholds for promotion/demotion?
- How do they do "stories" and "radio" lessons?
- Heart system: 5 hearts, lose 1 per mistake, refill with gems or practice

**Adoptable for InstaLingo:**
- The teaching flow: introduce word → match word ↔ image → match word ↔ translation → type the word → use in sentence
- "Legendary" level as a harder mastery challenge
- Daily quest system (3 random quests per day)
- XP boost mechanics (morning/evening chests, 2x XP for 15 min)

---

### 2.3 Memrise

**Research queries:**
- "Memrise course JSON format"
- "Memrise spaced repetition algorithm"
- "Memrise learn with locals video integration"
- "Memrise mem creation system"

**What we want to extract:**
- How do they structure a course? (levels → items → testing)
- What is a "mem"? How do they associate images/mnemonics with words?
- How does their "Learn with Locals" feature work? (short video clips of native speakers)
- What's their SRS algorithm? (planting → watering → growing metaphor)
- How do they handle user-generated content? Any quality control?
- Speed review mode? Difficult words mode?

**Adoptable for InstaLingo:**
- The word-introduction sequence: show word + native speaker video + mnemonic → multiple choice → typing → speed review
- "Difficult Words" separate review queue
- Audio-only review mode (listen and recall meaning)

---

### 2.4 Lingodeer

**Research queries:**
- "Lingodeer lesson structure grammar focus"
- "Lingodeer Japanese Korean Chinese exercises"
- "Lingodeer content API reverse engineering"

**What we want to extract:**
- How do they teach Asian languages differently from Romance/Germanic?
- Grammar tip placement — before exercises as explicit teach, or inline as hints?
- How do they handle character writing? (stroke order, kanji/hanzi practice)
- How do they structure a grammar-heavy lesson vs a vocab-heavy lesson?
- What exercise types are unique to CJK languages?

**Adoptable for InstaLingo:**
- Grammar-first approach for JP/KR/ZH courses
- Character decomposition exercises (radical → character → word)
- "Learning tips" panel that explains linguistic patterns
- Structured grammar notes before each lesson section

---

### 2.5 Drops

**Research queries:**
- "Drops app exercise types swipe interactions"
- "Drops vocabulary category structure"
- "Drops timed session mechanics"

**What we want to extract:**
- How do their swipe-based exercises work? (swipe right = know, left = don't know)
- How do they categorize vocabulary? (topic-based: food, travel, business, etc.)
- What's their 5-minute session structure?
- How do they use illustrations? Are they custom or sourced?
- How does their "dojo" review mode work?

**Adoptable for InstaLingo:**
- Topic-based vocabulary packs as consumable mini-courses
- Timed session mode (5 min, 10 min, 15 min)
- Image-first vocabulary introduction (no translation, pure visual association)
- Swipe interactions for rapid-fire review

---

### 2.6 Clozemaster

**Research queries:**
- "Clozemaster sentence mining approach"
- "Clozemaster Tatoeba integration"
- "Clozemaster fluency fast track"

**What we want to extract:**
- How do they use Tatoeba sentences at scale?
- What's their difficulty filtering? (by word frequency, sentence length)
- How do they group sentences by grammar point?
- What's their "Fluency Fast Track" ordering?

**Adoptable for InstaLingo:**
- Mass sentence-mining pipeline (Tatoeba → filtered → exercise generation)
- Frequency-based sentence ordering (most common words first)
- Cloze deletion exercise at scale (remove 1 word from sentence, pick from 4)

---

### 2.7 Speakly

**Research queries:**
- "Speakly frequency-based word list approach"
- "Speakly 4000 most common words methodology"

**What we want to extract:**
- How do they determine word frequency per language?
- How do they structure the "most important words first" progression?
- How do they integrate grammar into a frequency-based system?

**Adoptable for InstaLingo:**
- Frequency-based course ordering
- Statistical approach to "what to teach next"
- Real-life situation simulation exercises

---

### 2.8 Rosetta Stone

**Research queries:**
- "Rosetta Stone immersion method exercise types"
- "Rosetta Stone no translation approach"

**What we want to extract:**
- How do their image-association exercises work without any translation?
- How do they progressively build sentence complexity?
- What's their speech recognition accuracy threshold?
- How do they handle grammar without explicit instruction?

**Adoptable for InstaLingo:**
- Image-word association without translation (can be a separate "immersion mode")
- Progressive sentence building: word → phrase → sentence → paragraph
- Pronunciation visualization (waveform comparison)

---

### 2.9 Falou

**Research queries:**
- "Falou conversation simulation AI role play"
- "Falou pronunciation scoring technology"

**What we want to extract:**
- How do their AI conversation scenarios work? Pre-scripted or open-ended?
- What pronunciation metrics do they score? (accuracy, fluency, completeness)
- How do they structure a conversation lesson?

**Adoptable for InstaLingo:**
- Structured conversation scenarios (hotel check-in, ordering food, meeting someone)
- Pronunciation scoring integration
- "Quick conversation" mode

---

### 2.10 HelloChinese / ChineseSkill

**Research queries:**
- "HelloChinese character writing stroke order"
- "HelloChinese tone practice exercises"
- "ChineseSkill gamification mechanics"

**What we want to extract:**
- How do they teach tones? (visualization, comparison, minimal pairs)
- Character writing: stroke order animation + handwriting recognition
- Pinyin integration: when do they show/hide pinyin?
- How do they handle simplified vs traditional Chinese?

**Adoptable for InstaLingo (for our Chinese course):**
- Tone pair discrimination exercises
- Character writing with stroke order
- Pinyin toggle (show/hide)
- Radical-based character introduction

---

### 2.11 ELSA Speak

**Research queries:**
- "ELSA Speak pronunciation scoring algorithm"
- "ELSA Speak phoneme-level feedback"

**What we want to extract:**
- How do they score at the phoneme level?
- What feedback do they give? (articulation position, IPA, comparison audio)
- How do they structure pronunciation lessons?

**Adoptable for InstaLingo:**
- Phoneme-level pronunciation feedback (when we add actual speech recognition)
- "Your pronunciation sounds like..." with color coding (green/yellow/red)

---

## 3. Content Data Models — Patterns to Adopt

### 3.1 Translation-ID-Based Content (from Busuu)

Instead of storing raw text in exercise objects, use **translation keys** that resolve at runtime:

```json
{
  "exercise": {
    "type": "multipleChoice",
    "questionId": "q_greetings_001",
    "optionIds": ["opt_hello", "opt_goodbye", "opt_thanks", "opt_please"],
    "correctId": "opt_hello",
    "explanationId": "exp_greetings_001"
  },
  "translations": {
    "q_greetings_001": {
      "en": "Which word means 'hello'?",
      "zh": "哪个词的意思是"你好"？",
      "zh_TW": "哪個詞的意思是「你好」？",
      "ko": "'안녕하세요'의 의미는 무엇인가요?",
      "ja": "「こんにちは」を意味する単語は？",
      "es": "¿Qué palabra significa 'hola'?",
      "fr": "Quel mot signifie 'bonjour' ?",
      "de": "Welches Wort bedeutet 'Hallo'?"
    }
  }
}
```

**Benefits:**
- Content updates don't require code changes
- Same exercise can be served in 8 UI languages by swapping translation files
- Enables A/B testing of instruction wording
- Translation can be done by non-programmers via CSV/JSON

**For InstaLingo:** We should move toward this. Currently we embed strings directly in Dart `const` constructors. This is fine for a demo but won't scale to 56 language pairs.

### 3.2 Entity-Based Vocabulary (from Busuu)

Vocabulary words are entities referenced by ID, not duplicated in every exercise:

```json
{
  "entities": {
    "word_hello": {
      "phrase": { "en": "Hello", "ko": "안녕하세요", ... },
      "phonetic": "həˈloʊ",
      "audio": "https://cdn.example.com/audio/en/hello.mp3",
      "image": "https://cdn.example.com/img/hello.jpg",
      "examples": [
        { "sentence": "Hello, how are you?", "translation": {...} }
      ]
    }
  }
}
```

Exercises reference these entities instead of repeating text.

**For InstaLingo:** Our `vocabulary` list on each `Lesson` is a start. We should expand it to a proper entity system with phonetic, audio, image, and example sentences per word — even in the demo.

### 3.3 Lesson as a Directed Graph (from Duolingo/Busuu)

Instead of a linear list of exercises, lessons can be a **graph** where exercises unlock conditionally:

```
INTRO (teach word 1)
  ↓
INTRO (teach word 2)
  ↓
PRACTICE (match word→meaning)  ← requires both words introduced
  ↓
PRACTICE (type the word)       ← requires match completed
  ↓
TEST (mixed exercise)
```

**For InstaLingo:** Currently all 5 exercises are shown at once in a linear list. We could add "teach-first" mode where vocabulary introduction exercises appear first, then practice, then test.

### 3.4 Content Bundling vs Streaming

| Approach | Who Uses It | Pros | Cons |
|----------|------------|------|------|
| **All bundled in app** | Lingodeer, Drops (partially) | Works offline, fast | Huge APK, hard to update |
| **API-streamed + cache** | Busuu, Duolingo | Small APK, updates anytime | Requires backend |
| **Hybrid: skeleton bundled, details fetched** | Memrise | Best of both | Complex |

**For InstaLingo:** Demo = all bundled. Production = hybrid. Bundle core vocab/grammar, fetch Chill Corner posts and daily challenges dynamically.

---

## 4. Lesson Modes We Should Add

### 4.1 Teach-First Mode (New Lesson Flow)

Current: All 5 exercises dumped at once → user taps through.
Proposed: Structured flow:

```
TEACH PHASE (3-4 exercises)
  ├── flashCard — word + audio + image + example sentence
  ├── grammarTip — if grammar rule applies to this lesson
  ├── dialogueComplete — see the word in conversation
  └── comprehensionText — see the word in a reading passage

PRACTICE PHASE (3-4 exercises)
  ├── vocabularyMultipleChoice — recognize the word
  ├── matchPairs — match word ↔ translation
  ├── fillInBlank — use word in sentence
  └── listenAndType — hear and spell

TEST PHASE (2-3 exercises)
  ├── wordSorting — produce the sentence
  ├── writing — produce free-text
  └── speaking — produce speech
```

**Implementation:** Add a `phase` field to `Exercise` (teach/practice/test). In the lesson screen, group exercises by phase with section headers and progress indicators.

### 4.2 Rapid Review Mode

- 10-20 rapid-fire vocabulary MC questions
- 5-8 seconds per question (timer bar)
- No explanations between questions (only at end)
- XP multiplier for speed + accuracy

### 4.3 Audio-Only Mode

- Listen-and-repeat lesson format
- No reading required — purely audio
- Listen to word → repeat → listen to sentence → repeat → answer comprehension question by speaking
- Like Pimsleur but gamified

### 4.4 Story Mode

- Multi-exercise narrative sequence
- A short story (8-10 sentences) in target language
- Each sentence becomes an exercise: fill blank, reorder words, answer question about it
- At the end: comprehension quiz about the whole story
- Like Duolingo "Stories"

### 4.5 Grammar Deep-Dive Mode

- Dedicated grammar lesson type (not just inline tips)
- Structure: rule explanation → examples → controlled practice → free practice
- Exercise types: grammarTrueFalse, grammarGaps (table), grammarTyping, grammarHighlight (mark the correct form)
- Currently we only have `grammarTip` (read-only) and `grammarTrueFalse` (binary). We're missing the full practice pipeline.

### 4.6 Character Writing Mode (CJK-specific)

- For Chinese/Japanese/Korean learners
- Show character → trace stroke order → write from memory → use in word
- Pinyin/rōmaji toggle
- Radical breakdown exercises

### 4.7 Conversation Simulation Mode

- AI-powered dialogue (already have `AiConversationScreen`)
- Pre-scripted scenarios with branching
- The user fills in blanks in the dialogue
- At the end: free conversation with AI

### 4.8 Timed Challenge Mode

- 1-minute, 3-minute, 5-minute vocabulary blitz
- Leaderboard based on correct answers in time window
- XP multiplier for streaks within the timer
- Like Drops' 5-minute sessions

### 4.9 Placement Test Mode

- Adaptive test: start at medium difficulty → adjust based on answers
- 15-20 questions covering vocab, grammar, listening, reading
- Result: recommended starting section in the course
- Already partially designed (checkpoint tests in BUSUU_COMPARISON.md)

---

## 5. Data Storage Evolution Path

### Stage 1: Current (Const Dart)
```
demo_data.dart → const Exercise(...) → rendered directly
```
**Limits:** No updates without rebuild. 20K lines and growing. Hard to manage 56 language pairs.

### Stage 2: JSON Assets (Near-term, for demo)
```
assets/content/en_a1.json → loaded at runtime → parsed to Exercise objects
assets/content/ko_a1.json
assets/content/ja_a1.json
...
```
**Benefits:** Content editable without recompilation. Can load from remote in production.
**For InstaLingo:** We should convert `demo_data.dart` to JSON files per language per course.

### Stage 3: SQLite Bundle (Mid-term)
```
assets/content/instalingo.db → SQLite with tables:
  courses | sections | lessons | exercises | exercise_options | 
  vocabulary | translations | grammar_rules | posts | post_comments
```
**Benefits:** Queryable, indexable, supports incremental updates.
**For InstaLingo:** When content exceeds 50K lines, switch to SQLite.

### Stage 4: API + Cache (Production)
```
GET /api/v2/courses/{lang} → JSON → SQLite cache → rendered
```
**Benefits:** Content updates without app store review. Personalization. A/B testing.

### Recommended JSON Format for Stage 2:

```json
{
  "course": {
    "id": "en_a1",
    "level": "A1",
    "language": "en",
    "title": { "en": "English A1", "zh": "英语A1", ... },
    "subtitle": { "en": "Beginner English", "zh": "初级英语", ... },
    "description": { "en": "Master the basics...", "zh": "掌握基础...", ... },
    "sections": [
      {
        "id": "en_sec_1",
        "order": 1,
        "title": { "en": "Greetings & Introductions", "zh": "问候与自我介绍", ... },
        "lessons": [
          {
            "id": "en_l1",
            "order": 1,
            "title": { "en": "Hello!", "zh": "你好！", ... },
            "description": { "en": "Learn basic greetings", "zh": "学习基本问候", ... },
            "xpReward": 10,
            "gemsReward": 5,
            "vocabulary": ["hello", "hi", "goodbye"],
            "exercises": [
              {
                "id": "ex_en_1",
                "type": "vocabularyMultipleChoice",
                "contentLang": "en",
                "question": "Hello",
                "instruction": { "en": "Tap the correct meaning", "zh": "点击正确的含义", ... },
                "options": ["Goodbye", "Hello", "Thank you", "Please"],
                "correctAnswer": "Hello",
                "explanation": { "en": "'Hello' is the most common English greeting.", "zh": "...", ... }
              }
            ]
          }
        ]
      }
    ]
  }
}
```

---

## 6. What to Implement (Priority Order)

| # | Feature | Inspiration | Impact | Effort |
|---|---------|------------|--------|--------|
| 1 | **Teach-first lesson flow** (teach→practice→test phases) | Busuu, Duolingo | 🔴 Critical | Medium |
| 2 | **Content migration to JSON** (from const Dart) | All apps | 🔴 Critical | High |
| 3 | **Per-lesson exercise variety** (not shared exercises) | All apps | 🔴 Critical | Medium |
| 4 | **Story mode** (narrative exercises) | Duolingo | 🟡 High | Medium |
| 5 | **Grammar deep-dive lessons** (rule→examples→practice) | Lingodeer, Busuu | 🟡 High | Medium |
| 6 | **Spaced repetition (SRS)** with word strength tracking | Memrise, Busuu | 🟡 High | Medium |
| 7 | **League system** (weekly competition) | Duolingo | 🟡 High | Medium |
| 8 | **Rapid review mode** (timed vocabulary blitz) | Drops, Clozemaster | 🟢 Medium | Low |
| 9 | **Audio-only mode** (listen and respond) | Pimsleur | 🟢 Medium | Medium |
| 10 | **Character writing mode** (stroke order for CJK) | HelloChinese, Lingodeer | 🟢 Medium | High |
| 11 | **Placement test** (adaptive difficulty) | Busuu | 🟢 Medium | Medium |
| 12 | **Entity-based vocabulary** (with audio, image, examples per word) | Busuu | 🟡 High | High |

---

## 7. Source Code Patterns to Study (Open Source)

| Project | Language | What to study |
|---------|----------|---------------|
| **Anki** (github.com/ankitects/anki) | Python/Rust | SM-2 spaced repetition implementation |
| **LibreLingo** (github.com/kantord/LibreLingo) | Python/Dart | Open-source course format, exercise generation |
| **Lute** (github.com/luteorg/lute-v3) | Python | Reading-based language learning, word tracking |
| **OpenSpacedRepetition** (github.com/open-spaced-repetition) | TypeScript | SRS algorithm research and implementation |
| **Tatoeba** (github.com/Tatoeba/tatoeba2) | PHP/CakePHP | Sentence corpus structure, linking, tagging |
| **AnkiDroid** (github.com/ankidroid/Anki-Android) | Kotlin/Java | Mobile SRS implementation, deck parsing (.apkg) |

---

*Generated: 2026-05-27*
*To share: this entire document to any AI for competitive research*
