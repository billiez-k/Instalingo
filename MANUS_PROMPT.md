# Manus AI Prompt — InstaLingo Content Generation

> **Copy-paste this entire prompt into Manus AI. Upload the files listed in Step 0 alongside.**

---

## STEP 0: Files I'm Uploading

I'm attaching these files:
1. **`CONTENT_ACQUISITION_GUIDE.md`** — THE AUTHORITATIVE SPEC. Contains exact JSON schemas for all 16 exercise types, 42 search queries across 7 languages, download URLs, the 8-step processing pipeline, validation rules, and output instructions. **Follow this guide exactly.**
2. **`APP_REFERENCE_RESEARCH.md`** — Context on what we're building. 11 competitor apps analyzed, lesson modes we want to add, content storage evolution path. Read for context, but the GUIDE is the spec.
3. **`busuuref.md`** — Busuu APK reverse engineering. Shows how the industry leader structures exercise data (translation-ID system, entity-based vocabulary, 40+ exercise types). Use as reference for quality bar.

---

## YOUR TASK

Generate complete A1-level language learning content for **7 target languages** (English, Korean, Japanese, French, Spanish, Chinese, German) in the exact JSON format specified by `CONTENT_ACQUISITION_GUIDE.md`.

Every string visible to users must be translated into **8 UI languages**: English, Simplified Chinese, Traditional Chinese (zh_TW), Korean, Japanese, Spanish, French, German. zh_TW must be independent from zh — never auto-convert.

---

## PHASED EXECUTION — DO NOT STOP BETWEEN PHASES

### PHASE A: Pilot — English A1 Only (en_a1.json)

1. Read `CONTENT_ACQUISITION_GUIDE.md` completely.
2. Execute Section 2.1 search queries for English.
3. Download raw data: Tatoeba sentences.csv + links.csv, Oxford 3000 wordlist, English grammar A1 topics.
4. Process into one complete `en_a1.json` file following the exact schema in Section 1.
5. **Output the file and report:** total exercises, exercise type distribution, vocabulary coverage, any missing translations.

**MILESTONE: Stop here and show me the pilot.** I will review the format. Do NOT proceed until I say "format is good, continue."

### PHASE B: All 7 Languages (After I approve the pilot)

1. Execute ALL search queries in Section 2 for Korean, Japanese, French, Spanish, Chinese, German.
2. Download ALL raw data for every language (Tatoeba covers all languages in one download — filter per language).
3. Process each language independently following the pipeline in Section 5.
4. For EACH course JSON file, translate ALL LocalizedText fields to 8 languages. Use DeepL API / Google Translate / GPT-4o. Never leave a language blank.
5. Generate Chill Corner posts (20 per language) following Section 6 schema.
6. Generate vocabulary master files and grammar files.
7. For audio/image files: if you cannot download actual media, output placeholder URLs in format `https://cdn.instalingo.app/audio/{lang}/{word}.mp3` and list all required files in `media_manifest.json`.
8. Run validation checks from Section 7 against every output file.

**Output the complete `instalingo_content/` folder structure** as defined in Section 0.2 of the guide.

### PHASE C: Final Report

After all 7 languages are complete, output a summary:

```
COURSE: en_a1 — 8 sections, 42 lessons, 340 exercises — 15 types used — ✓ 8-language complete
COURSE: ko_a1 — 8 sections, 40 lessons, 328 exercises — 14 types used — ✓ 8-language complete
... (one line per course)

POSTS: 20 en, 20 ko, 20 ja, 20 fr, 20 es, 20 zh, 20 de — ✓ 8-language complete
AUDIO: 2,100 files needed (see media_manifest.json)
IMAGES: 1,400 files needed (see media_manifest.json)
ISSUES: (any search failures or missing data — see acquisition_issues.json)
```

---

## CRITICAL RULES — NEVER VIOLATE THESE

1. **Every LocalizedText field must have exactly 8 keys:** `en, zh, zh_TW, ko, ja, es, fr, de`. Missing ANY language = BUG.
2. **zh_TW NEVER falls back to zh.** Translate separately. If identical, duplicate the string — never omit.
3. **A1 difficulty filter:** Sentences ≤ 8 words (non-CJK) or ≤ 10 characters (CJK). Simple grammar only. No subjunctive, no passive, no relative clauses.
4. **Exercise type variety:** Each lesson must have ≥ 5 distinct exercise types. No lesson should be all vocabularyMultipleChoice.
5. **Valid JSON only.** No Dart code. No trailing commas. UTF-8 encoding.
6. **If a search fails** to find a resource, note it in `acquisition_issues.json` — do NOT skip the language. Use alternative sources or generate from what you have.

---

## DON'T STOP HALFWAY

- Do NOT ask me "should I continue?" after each phase. Continue autonomously.
- Do NOT stop if a search query fails — try alternative queries, note the failure, and keep going.
- Do NOT skip any of the 7 languages. All 7 must be complete.
- If you hit rate limits on translation APIs, wait and retry. If impossible, generate English-only content and flag for later translation.
- Only stop at the Phase A milestone (pilot review). After I approve, go straight through Phase B and C without pausing.

---

*Hand this entire prompt + the 3 attached files to Manus AI.*
