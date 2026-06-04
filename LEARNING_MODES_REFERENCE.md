# InstaLingo — Learning Modes Reference

> **Purpose:** Hand this file to another AI to research additional learning modes from famous language apps. The AI should compare our current modes against industry best practices and recommend which modes to add, with implementation notes.

---

## 1. App Architecture Context

### Localization Rules (CRITICAL)
- **8 supported native languages:** en, zh, zh_TW, ja, ko, es, fr, de
- **6 learning languages:** en, ja, ko, es, fr, de
- **All user-visible text** must use `LocalizedText({...})` with entries for ALL 8 languages
- **NEVER default to English** — if a native-language entry is missing, the app falls back to English, which is a bug
- **zh_TW (Traditional Chinese) is independent** from zh (Simplified) — no script mixing
- **Exercise `question` field** is the target-language content (e.g., the vocabulary word being tested)
- **Exercise `instruction` field** is the native-language explanation (how to perform the exercise)
- **UI strings** live in ARB files (`lib/l10n/app_*.arb`), regenerated via `flutter pub get`

### Content Pipeline
- All demo content lives in `lib/data/demo_data.dart` (~2,200 LOC)
- 7 courses (EN/KO/JA/FR/ES/ZH/DE), each with 3 sections × 10 lessons × 5 exercises
- Each lesson has a `vocabulary` list of target-language words taught
- Lessons have `_lessonEn()`, `_lessonKo()`, etc. helper functions with translation lookup tables for titles/descriptions

### Tech Stack
- **Flutter** + **Riverpod** (state management)
- **GoRouter** (navigation)
- **flutter_screenutil** (responsive: 390×844 design size)
- **Phosphor Icons** (no emojis)
- **Busan Harbor design system** (navy + orange + cream palette)

---

## 2. Current Exercise Types (16 total)

All defined in `lib/models/course.dart` as `ExerciseType` enum. Each exercise maps to a widget in `lib/screens/learn/lesson_screen.dart`.

### 2.1 vocabularyMultipleChoice
- **What it does:** Shows a question word and 4 options. User picks the correct translation/meaning.
- **UI:** Question text at top, 4 tappable option cards below, selected option highlighted
- **Interaction:** Single tap to select, then "Check" button to verify
- **Data fields used:** `question`, `options`, `correctAnswer`, `explanation`
- **Current state:** ✅ Working
- **Example from demo:** "Which word means hello?" → options: [Goodbye, Hello, Thank you, Please]

### 2.2 fillInBlank
- **What it does:** User fills a blank in a sentence by selecting from a word bank or typing.
- **UI:** Sentence with gap, word bank chips below (or text input), clear/undo buttons
- **Interaction:** Tap word bank chips to fill the blank, reorder by dragging
- **Data fields used:** `question`, `wordBank`, `correctAnswer`, `options`, `explanation`
- **Variants:**
  - **Word bank mode:** `wordBank` is populated → chips to tap
  - **Free typing mode:** `wordBank` is empty → text input field
- **Current state:** ✅ Working (both modes)

### 2.3 matchPairs
- **What it does:** Match left-column words to right-column translations. Right side is shuffled.
- **UI:** Two-column layout with scrollable word lists, arrows-between icon, selection highlight
- **Interaction:** Tap a word on the left (highlighted orange), then tap its match on the right. Correct → both turn green and lock. Wrong → reset. All matched → auto-submit correct.
- **Data fields used:** `pairs` (List<WordPair>), `instruction`
- **Current state:** ✅ Fixed (was static display, now fully interactive as of 2026-05-27)

### 2.4 wordSorting
- **What it does:** Arrange jumbled words/chips into the correct sentence order.
- **UI:** Selected words row (drop zone) + word bank below, drag-to-reorder in drop zone
- **Interaction:** Tap word bank chips to add to sentence, tap selected chips to remove, drag to reorder. "Check" validates order against `correctAnswerList`.
- **Data fields used:** `question`, `options` (word bank), `correctAnswerList`
- **Current state:** ✅ Working

### 2.5 translateSentence
- **What it does:** Translate a given sentence from target language to native language (or vice versa).
- **UI:** Same as vocabularyMultipleChoice — sentence as question, 4 translation options
- **Interaction:** Select correct translation, "Check" to verify
- **Data fields used:** `question`, `options`, `correctAnswer`, `explanation`
- **Current state:** ✅ Working (shares UI with vocabularyMultipleChoice)

### 2.6 dialogueComplete
- **What it does:** Complete a dialogue by selecting the correct response from multiple choices.
- **UI:** Dialogue turns displayed with speaker labels, gap for missing response, option buttons
- **Interaction:** Select the correct dialogue completion from options
- **Data fields used:** `dialogue` (List<DialogueTurn>), `options`, `correctAnswer`
- **Current state:** ✅ Working

### 2.7 imageIdentification
- **What it does:** Identify a word based on an image placeholder (2×2 grid of image cards).
- **UI:** 2×2 grid of image placeholder containers with labels, one is correct
- **Interaction:** Tap the correct image/word option
- **Data fields used:** `imageUrl`, `options`, `correctAnswer`
- **Limitation:** No actual images — uses colored placeholder containers with word labels
- **Current state:** ✅ Working (needs real image assets)

### 2.8 listenAndType
- **What it does:** Listen to audio and type what you hear.
- **UI:** Play button (speaker icon), text input field, "Check" button
- **Interaction:** Tap play (no actual audio), type the word, check against correct answer
- **Data fields used:** `audioUrl`, `correctAnswer`
- **Limitation:** No actual audio files — `audioUrl` is set but no playback logic
- **Current state:** ✅ Working (needs audio assets + playback integration)

### 2.9 speaking
- **What it does:** Practice pronunciation by speaking a word or phrase.
- **UI:** Microphone button (hold to record), waveform visualization, play recording button
- **Interaction:** Hold mic to record, release to stop, play back recording
- **Data fields used:** `question` (word to speak)
- **Limitation:** No speech recognition/analysis — just record + playback
- **Current state:** ✅ Working (needs speech-to-text + pronunciation scoring)

### 2.10 grammarTip
- **What it does:** Display a grammar rule with example. Non-interactive learning card.
- **UI:** Overlay modal with rule text, example sentence, optional explanation
- **Interaction:** Read-only — user taps "Got it" to dismiss
- **Data fields used:** `grammarRule`, `grammarExample`, `explanation`
- **Current state:** ✅ Working

### 2.11 flashCard
- **What it does:** 3D flip animation flashcard showing word on front, translation on back.
- **UI:** Card with front face (target word) + back face (native translation), flip animation (rotateY via Transform)
- **Interaction:** Tap card to flip, swipe or button to mark "Hard"/"Good"/"Easy"
- **Data fields used:** `question`, `correctAnswer`, `explanation`
- **Current state:** ✅ Working

### 2.12 comprehensionText
- **What it does:** Read a passage and answer comprehension questions (multiple choice).
- **UI:** Reading passage at top (scrollable), question + 4 options below
- **Interaction:** Read passage, answer questions one by one
- **Data fields used:** `passage`, `questions`, `options`, `correctAnswer`
- **Current state:** ✅ Working

### 2.13 grammarTrueFalse
- **What it does:** Judge whether a grammar statement is true or false.
- **UI:** Grammar statement, True/False buttons
- **Interaction:** Tap True or False, see result
- **Data fields used:** `question`, `isTrue`, `explanation`
- **Current state:** ✅ Working

### 2.14 phraseBuilderPrefilled
- **What it does:** Build a phrase by selecting from pre-filled word options. Similar to fillInBlank but with phrase-level construction.
- **UI:** Phrase template with slots, word options per slot
- **Interaction:** Select word for each slot
- **Data fields used:** `options`, `correctAnswerList`
- **Current state:** ✅ Working

### 2.15 writing
- **What it does:** Free-text writing exercise. User writes a response to a prompt, compares with sample answer.
- **UI:** Writing prompt at top, multi-line text input, sample answer reveal
- **Interaction:** Type response, tap "Check" to see sample answer comparison
- **Data fields used:** `writingPrompt` (LocalizedText), `sampleAnswer` (LocalizedText)
- **Limitation:** No AI grading — just shows sample answer for self-comparison
- **Current state:** ✅ Working

---

## 3. Current Limitations & Gaps

### Missing Features (by category)

#### Audio/Speech
- No actual audio playback (listenAndType has no audio files)
- No speech recognition or pronunciation scoring (speaking just records)
- No TTS (text-to-speech) for vocabulary pronunciation
- No shadowing exercises (listen + repeat with waveform comparison)

#### Visual
- No real images (imageIdentification uses colored placeholders)
- No video content
- No AR/VR elements
- No illustrated scenes or situational imagery

#### Gamification
- XP/gems/streak system exists but is basic
- No leagues/competitions
- No daily challenges or quests
- No avatar/character customization
- No social competition (friends leaderboard exists but is static demo)

#### Adaptive Learning
- No spaced repetition algorithm (SRS)
- No personalized review scheduling
- No adaptive difficulty (exercises are fixed order)
- No skill tree or mastery tracking per word

#### Content Variety
- All exercises are single-question → check → next
- No multi-step exercises
- No timed challenges
- No listening comprehension with audio
- No dictation (full sentence)
- No role-play scenarios
- No story-based learning
- No song/lyrics exercises
- No news/article reading with vocabulary extraction

#### Teaching Flow
- No explicit "teach" phase before quizzes (vocabulary is introduced in the first exercise)
- No word-by-word introduction with examples
- No progressive disclosure (all 5 exercises appear at once)
- No review/reinforcement between sections

#### Production (Output)
- All exercises test recognition (input), not production (output)
- Only `writing` and `speaking` are output-oriented, but both lack AI grading
- No translation exercises (target → native)
- No sentence composition (free-form)
- No conversation simulation (AI chat exists separately in `/ai-conversation` but isn't integrated into lessons)

---

## 4. What To Research From Other Apps

Hand this section to the research AI. For each famous app, identify:

1. **Unique exercise types** not in our list
2. **Teaching methodology** (how they introduce → practice → test)
3. **Gamification mechanics** (what keeps users engaged)
4. **Content progression** (how difficulty scales)
5. **Review/reinforcement** (spaced repetition, daily review)

### Apps to Research (ranked by relevance)

| App | Why |
|-----|-----|
| **Busuu** | Our primary inspiration. 40+ exercise types, bilingual instruction/content separation. Studied extensively in `BUSUU_COMPARISON.md`. |
| **Duolingo** | Largest user base. Well-known gamification (leagues, gems, hearts). Wide variety of exercise formats. |
| **Memrise** | Video-based learning with native speakers. Spaced repetition. "Learn with Locals" feature. |
| **Lingodeer** | Asian language focus (matches our KR/JA/ZH/DE/FR/ES). Grammar-focused, structured like textbooks. |
| **Drops** | Visual vocabulary learning. Timed sessions. Swipe-based interactions. Beautiful illustrations. |
| **Clozemaster** | Fill-in-the-blank at scale. Mass sentence mining. Great for intermediate learners. |
| **Speakly** | Frequency-based word lists. Focus on most common words first. |
| **Pimsleur** | Audio-first, spaced repetition. Graduated interval recall. |
| **Rosetta Stone** | Immersive, no translation. Image-word association. Speech recognition. |
| **HelloChinese / ChineseSkill** | Chinese-specific. Tone practice, character writing, stroke order. |
| **LingQ** | Reading-focused. Import any content. Vocabulary tracking with SRS. |
| **Beelinguapp** | Parallel text reading. Side-by-side translations. Audiobooks. |
| **Falou** | Conversation simulation. AI role-play scenarios. |
| **ELSA Speak** | AI pronunciation scoring. Detailed phoneme-level feedback. |
| **Mondly** | AR + chatbot + VR. Daily lessons. Statistics tracking. |

### Specific Questions for the Research AI

1. **What exercise types do these apps have that we don't?** List each with interaction model.
2. **How do they structure a "lesson"?** (teach → practice → test flow, number of exercises per lesson, mix of types)
3. **How do they handle review?** (spaced repetition, daily review sessions, "weak words" tracking)
4. **What gamification mechanics drive engagement?** (streaks, leagues, chests, daily quests, XP boosters)
5. **How do they teach grammar?** (dedicated grammar lessons, inline tips, separate grammar section)
6. **What output/production exercises exist?** (speaking, writing, translation, composition)
7. **How do they use multimedia?** (audio, images, video, AR)
8. **What makes their onboarding sticky?** (first-lesson experience, habit formation)

---

## 5. Implementation Notes for New Modes

When adding a new exercise type, follow this checklist:

### Dart Code Changes
1. Add to `ExerciseType` enum in `lib/models/course.dart`
2. Add exercise widget case in `_buildExerciseContent()` in `lib/screens/learn/lesson_screen.dart`
3. Create new widget class in `lesson_screen.dart` (or new file if complex)
4. Add native-language instruction in `_exerciseInstruction()` helper
5. Wire into `_onCheckOrContinue()` if auto-grading is needed

### Content Changes
1. Create exercise examples in `lib/data/demo_data.dart` using the helper pattern
2. All `LocalizedText` fields MUST have 8-language entries
3. Instruction text goes in `instruction` field (native language) or via l10n key
4. Learning content goes in `question`/`options` fields (target language)
5. Add corresponding `vocabulary` words to the lesson

### Localization
1. Add UI strings to ALL 8 ARB files (`lib/l10n/app_*.arb`)
2. Run `flutter pub get` to regenerate Dart delegates
3. Run `flutter analyze` to verify 0 errors

### Key Model Fields Reference
```dart
class Exercise {
  final ExerciseType type;       // Which widget to render
  final String question;          // Target-language content
  final String? instruction;      // Native-language instruction (optional, else l10n)
  final String? contentLang;      // Language of learning content
  final String? instructionLang;  // Language of instruction text
  final List<String>? options;    // Multiple choice options
  final String? correctAnswer;    // Single correct answer
  final List<String>? correctAnswerList; // Ordered correct answers (wordSorting)
  final LocalizedText? explanation; // Why answer is correct (8 languages)
  final List<WordPair>? pairs;    // For matchPairs
  final List<DialogueTurn>? dialogue; // For dialogueComplete
  final LocalizedText? grammarRule;   // Grammar explanation (8 languages)
  final LocalizedText? grammarExample; // Grammar example (8 languages)
  final List<String>? wordBank;   // For fillInBlank/wordSorting
  final String? passage;          // For comprehensionText
  final bool? isTrue;             // For grammarTrueFalse
  final LocalizedText? writingPrompt; // For writing (8 languages)
  final LocalizedText? sampleAnswer;  // For writing (8 languages)
}
```

---

*Generated: 2026-05-27*
*Total exercise types: 16*
*File to share: this entire document*
