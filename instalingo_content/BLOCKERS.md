# Blockers & Issues — InstaLingo Content Pipeline

**Date:** 2026-05-28

## RESOLVED BLOCKERS (since initial report)

| Blocker | Resolution |
|---------|-----------|
| No web access | Resolved — using browser/curl to access GitHub raw content |
| Chinese vocabulary needs source | Resolved — downloaded from plaktos/hsk_csv (MIT license) |
| Japanese vocabulary needs source | Resolved — downloaded from open-anki-jlpt-decks (MIT license) |

## REMAINING BLOCKERS

### BLOCKER 1: Korean TOPIK Content Not Downloaded
**Severity:** MEDIUM
**Affects:** All Korean TOPIK I content
**Resolution path:** Developer should search GitHub for "topik vocabulary csv" and download. Common repos: `garfieldkhan/topik-vocab`, `seanbreckenridge/topik-vocabulary`.

### BLOCKER 2: Korean/Japanese Needs Native Review
**Severity:** HIGH
**Affects:** All Korean/Japanese grammar, sentence naturalness, distractor quality
**Resolution path:** Hire Korean + Japanese native speakers (~$75-150 each, 5 hours)

### BLOCKER 3: Non-English Meaning Translations Incomplete
**Severity:** LOW
**Affects:** ko, es, fr, de meaning fields in vocabulary.json
**Resolution path:** Developer can batch-translate using translation API

### BLOCKER 4: Tatoeba Sentences Not Downloaded
**Severity:** MEDIUM
**Affects:** Sentence pairs for all languages
**Resolution path:** Download from https://downloads.tatoeba.org/exports/sentences.csv

## Summary

| Category | Complete | Partial | Blocked |
|----------|----------|---------|---------|
| Phase 1 (English leak fixes) | 9/9 ✅ | 0 | 0 |
| Chinese HSK vocabulary | 3/3 ✅ | 0 | 0 |
| Japanese JLPT vocabulary | 2/2 ✅ | 0 | 0 |
| Korean TOPIK vocabulary | 0/1 | 0 | 1 |
| Sentences/grammar/dialogues | 1/9 | 0 | 8 |
