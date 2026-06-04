# InstaLingo — Complete Content Workflow

> **How to go from "skeleton demo content" to "full A1 courses for 7 languages"** — end-to-end pipeline using Manus AI + existing tools.

**Date:** 2026-05-27

---

## Current State Snapshot

| What | Numbers |
|------|---------|
| Courses | 7 (EN, KO, JA, FR, ES, ZH, DE) |
| Sections per course | 3 (target: 8+) |
| Lessons per course | 10 (target: 40+) |
| Exercises per lesson | 5 (all shared! target: 8 unique) |
| Exercise types | 16 (all implemented in UI) |
| Vocab per course | ~50 words |
| Chill Corner posts | 2-4 per language |
| Audio files | 0 |
| Image files | 0 |
| Total codebase | ~59K LOC, 91 files |
| `demo_data.dart` | ~20K lines (single monolithic file) |

---

## The 6-Phase Workflow

```
Phase 1 ─── Phase 2 ─── Phase 3 ─── Phase 4 ─── Phase 5 ─── Phase 6
[Research]  [Acquire]   [Process]   [Translate]  [Integrate] [Verify]
  DONE        Manus       Manus       Manus       Copilot     Scripts
             AI does     AI does     AI does     I code       Existing
             searches    JSON gen    8 langs     Flutter      tools
```

---

## PHASE 1: Research & Reference ✅ DONE

**Files you already have:**
- `APP_REFERENCE_RESEARCH.md` — what to learn from 11 competitor apps
- `BUSUU_COMPARISON.md` — Busuu deep-dive comparison
- `busuuref.md` — Busuu APK reverse engineering (exercise types, data models, gamification)
- `LEARNING_MODES_REFERENCE.md` — our 16 exercise types catalog + gaps

**No further action needed here.** These are reference docs for understanding best practices.

---

## PHASE 2: Acquire Raw Teaching Materials 💻 → Manus AI

**What to hand Manus AI:** Just the file `CONTENT_ACQUISITION_GUIDE.md` — it has EVERYTHING.

**No need to zip the Flutter repo.** Manus doesn't need the code — it just needs to know the output format (Section 0-1 of the guide). The guide contains:
- Exact JSON schemas for all 16 exercise types
- 8-language requirement rules
- 42 exact web search queries across 7 languages
- Bulk dataset download URLs (Tatoeba, Anki, frequency lists)
- Output directory structure

**What Manus will produce:**

```
instalingo_content/          ← Manus outputs this folder
├── courses/
│   ├── en_a1.json          ← 8 sections, 40 lessons, 320 exercises
│   ├── ko_a1.json
│   ├── ja_a1.json
│   ├── fr_a1.json
│   ├── es_a1.json
│   ├── zh_a1.json
│   └── de_a1.json
├── posts/
│   ├── en_posts.json       ← 20 posts each
│   ├── ko_posts.json
│   └── ...
├── vocabulary/
│   ├── en_vocab.json       ← Master vocab DB per language
│   └── ...
├── grammar/
│   ├── en_grammar.json     ← ~50 grammar points each
│   └── ...
├── audio/                  ← MP3 files per word
│   ├── en/hello.mp3
│   └── ...
├── images/                 ← JPG/PNG per word
│   ├── en/apple.jpg
│   └── ...
└── media_manifest.json     ← List of all audio/image files needed
```

**Strategy for Manus:**
1. **Pilot run:** Ask Manus to do English A1 first (`en_a1.json`). Review the output format. Then tell it "do the other 6 languages."
2. **If Manus can't download audio/images:** It will output placeholder URLs + `media_manifest.json`. You source audio/images separately (Forvo, Unsplash).
3. **Translation:** Manus will use DeepL/Google Translate API or GPT-4o to generate all 8-language entries.

---

## PHASE 3: Process Raw Data into JSON 💻 → Manus AI

Manus follows the processing pipeline in Section 5 of `CONTENT_ACQUISITION_GUIDE.md`:

1. Download Tatoeba CSVs → extract sentence pairs per language
2. Download vocab PDFs/lists → normalize to unified CSV
3. Scrape/download grammar resources → structured JSON
4. Auto-generate exercises from sentence pairs + vocab + grammar
5. Assemble into course JSON with correct section/lesson hierarchy

**Key quality rules Manus must follow:**
- A1 sentence length filter: ≤ 8 words (non-CJK), ≤ 10 chars (CJK)
- Exercise type variety: ≥ 5 types per lesson
- All 8 languages present in every `LocalizedText` field
- `zh_TW` is independent from `zh` (separate translation, not auto-converted)

---

## PHASE 4: Translate to 8 Languages 💻 → Manus AI or You

**Option A: Let Manus do it** (recommended — it's already in the CONTENT_ACQUISITION_GUIDE.md pipeline)

**Option B: Use the existing `translation_pipeline.py` tool:**
```bash
# Export all LocalizedText strings to a JSON file
python tools/translation_pipeline.py --export --out translation_export.json

# Hand translation_export.json to an AI translator (GPT, Claude, DeepL)
# It fills in all missing language entries

# Import back into demo_data.dart
python tools/translation_pipeline.py --import --in translation_export_translated.json

# Verify completeness
python tools/translation_pipeline.py --verify
```

**Option C: Hybrid** — Let Manus generate course JSON with English content. Then use `translation_pipeline.py` to extract, translate, and re-inject the 7 other languages.

---

## PHASE 5: Integrate into Flutter App 👨‍💻 → Me (Copilot)

Once Manus delivers the `instalingo_content/` folder, I (Copilot) handle integration.

### Step 5a: Create JSON Loaders

Add JSON loading capability to `CourseProvider` and `PostProvider`:

```dart
// New: lib/data/content_loader.dart
class ContentLoader {
  static Future<Course> loadCourse(String langCode, String level) async {
    final json = await rootBundle.loadString('assets/content/courses/${langCode}_$level.json');
    return Course.fromJson(jsonDecode(json));
  }
}
```

### Step 5b: Add JSON Serialization to Models

Add `fromJson` / `toJson` to `Course`, `Section`, `Lesson`, `Exercise`, `Post`.

### Step 5c: Switch from Const to Loaded Content

Currently `demo_data.dart` uses `const` constructors. We'll:

1. Keep `demo_data.dart` as fallback for offline/no-asset scenarios
2. Add `ContentLoader` that tries JSON assets first, falls back to `demo_data.dart`
3. Update `CourseNotifier` and `PostsNotifier` to use `ContentLoader`

### Step 5d: Bundle Assets

Add to `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/content/courses/
    - assets/content/posts/
    - assets/content/audio/
    - assets/content/images/
```

### Step 5e: Verify Build

```bash
flutter pub get
flutter analyze          # Must show 0 errors
flutter build web        # Must succeed
```

---

## PHASE 6: Verify Everything 🧪 → Scripts

### Run existing verification:
```bash
python tools/verify_e2e.py        # 7 automated checks
python tools/translation_pipeline.py --verify   # LocalizedText completeness
```

### Manual verification:
1. Launch app with each of the 8 native languages
2. Verify no English fallback text appears
3. Complete a lesson in each of the 7 target languages
4. Check Chill Corner posts unlock correctly
5. Verify audio plays (if audio files exist)
6. Verify images display (if image files exist)

---

## ALSO: What to Do With Competitor Source Code

You mentioned having source code of other language learning apps. Use it for:

### 1. Extract Exercise Type Ideas
- Look at their exercise/view/layout XML or Compose files
- Map each exercise type to our 16 types
- Identify unique types we don't have → add to our `ExerciseType` enum

### 2. Study Their JSON/API Format
- If they use bundled JSON: study the structure → improve our schema
- If they use API: study the response format → design our future API
- Look for how they handle multi-language content

### 3. Gamification Mechanics
- Extract XP/point calculation formulas
- League tier thresholds
- Streak freeze/repair logic
- Daily quest generation algorithms

### 4. Content Progression
- How they order vocabulary (frequency-based? thematic? CEFR?)
- Grammar teaching sequence
- Skill tree / path design

**How to hand off:** You don't need to zip the whole InstaLingo repo. Just give Manus:
1. `CONTENT_ACQUISITION_GUIDE.md` (for data format & search queries)
2. `APP_REFERENCE_RESEARCH.md` (for what to look for in competitor source)
3. The competitor app source code itself (for Manus to analyze)

---

## Summary: What to Do Right Now

```
[YOU] ──> Open Manus AI
          │
          ├── Paste CONTENT_ACQUISITION_GUIDE.md (whole file)
          ├── Say: "Follow this guide. Start with English A1 (en_a1.json) as pilot."
          ├── Wait for pilot output → review format
          ├── Say: "Format looks good. Now do all 7 languages."
          │
          └── Wait for full instalingo_content/ folder delivery

[YOU] ──> Also ask Manus to analyze your competitor source code
          ├── Paste APP_REFERENCE_RESEARCH.md
          ├── Upload competitor source code
          └── Say: "Analyze these apps and tell me what exercise types,
               gamification mechanics, and content structures we should adopt."

[COPILOT] ──> Once Manus delivers the content folder:
          ├── Create ContentLoader + JSON serialization
          ├── Migrate from const demo_data.dart to JSON assets
          ├── Run flutter analyze + flutter build
          └── Verify with translation_pipeline.py + verify_e2e.py
```

---

## File Reference

| File | Purpose | Who Uses It |
|------|---------|-------------|
| `CONTENT_ACQUISITION_GUIDE.md` | Exact search queries, JSON schemas, processing pipeline, output format | **Manus AI** |
| `APP_REFERENCE_RESEARCH.md` | What to learn from 11 competitor apps, lesson modes, UX patterns | **Manus AI** or any research assistant |
| `LEARNING_MODES_REFERENCE.md` | Our 16 exercise types catalog, gaps analysis, implementation notes | Reference for Copilot |
| `BUSUU_COMPARISON.md` | Busuu vs InstaLingo gap analysis, implementation priority | Reference for Copilot |
| `busuuref.md` | Busuu APK reverse engineering deep dive | Reference for Copilot |
| `WHAT_IS_LEFT_FLUTTER.md` | Remaining Flutter tasks not related to content | Reference for Copilot |
| `tools/translation_pipeline.py` | Export/import/verify LocalizedText translations | Copilot (Phase 4/6) |
| `tools/verify_e2e.py` | 7 automated content verification checks | Copilot (Phase 6) |

---

*Generated: 2026-05-27*
