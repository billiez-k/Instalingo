# InstaLingo Flutter — File Report (production-ready-step-1)

**Generated:** 2026-06-05  
**Total LOC:** 483,238 (excluding `.git/`, `.dart_tool/`, `build/`)  
**Files:** 206  
**Dart:** 56 files, 11,953 LOC  
**ARB:** 2 files, 1,484 LOC  
**Python:** 13 files, 3,707 LOC  
**JSON:** 18 files (9 in `instalingo_content/`)  
**Content:** Japanese N5–N1 cards + shared posts/characters; archive vocab lists  
**Validator:** Not run  
**Compilation:** Not run

---

## 1. TOTAL LOC BREAKDOWN

| Layer | Files | LOC | % |
|-------|-------|-----|---|
| Raw data (`raw_data/`) | 11 | 197,909 | 41.0% |
| JSON content (`instalingo_content/`) | 12 | 157,954 | 32.7% |
| Vendor data (`vendor/`) | 18 | 106,008 | 21.9% |
| Dart/ARB source (`lib/`) | 58 | 13,437 | 2.8% |
| Python tools (`tools/`) | 13 | 3,707 | 0.8% |
| Platform files (`android/`, `ios/`, `web/`) | 76 | 2,120 | 0.4% |
| Docs (Markdown) | 8 | 575 | 0.1% |
| Other config/metadata | 10 | 1,528 | 0.3% |
| **Grand Total** | **206** | **483,238** | **100%** |

---

## 2. JSON CONTENT — `instalingo_content/` (157,954 LOC)

### Japanese (N5–N1)
| File | Lines |
|------|-------|
| `japanese/n5/cards.json` | 12,081 |
| `japanese/n4/cards.json` | 11,316 |
| `japanese/n3/cards.json` | 35,762 |
| `japanese/n2/cards.json` | 32,209 |
| `japanese/n1/cards.json` | 45,605 |

### Shared
| File | Lines |
|------|-------|
| `shared/characters.json` | 61 |
| `shared/posts.json` | 646 |

### Archive
| File | Lines |
|------|-------|
| `archive/filtered_vocabulary.json` | 4 |
| `archive/register_vocabulary.json` | 20,270 |

---

## 3. DART SOURCE — `lib/` (11,953 LOC + 1,484 ARB)

### Top-Level Breakdown
| Area | Files | LOC |
|------|-------|-----|
| `screens/` | 20 | 6,932 |
| `widgets/` | 6 | 1,358 |
| `services/` | 8 | 536 |
| `models/` | 5 | 505 |
| `providers/` | 7 | 490 |
| `theme/` | 1 | 494 |
| `data/` | 2 | 391 |
| `router/` | 1 | 165 |
| `utils/` | 1 | 60 |
| `config/` | 1 | 27 |
| `l10n/` (generated) | 3 | 868 |
| `main.dart` | 1 | 127 |

### Screens Breakdown
| Area | Files | LOC |
|------|-------|-----|
| `profile/` | 6 | 2,253 |
| `swipe/` | 3 | 1,169 |
| `onboarding/` | 3 | 566 |
| `review/` | 1 | 573 |
| `chill/` | 1 | 530 |
| `collections/` | 1 | 421 |
| `home/` | 1 | 382 |
| `paywall/` | 1 | 327 |
| root screens | 3 | 711 |

---

## 4. ARB SOURCES — `lib/l10n/` (1,484 LOC)

| File | Lines |
|------|-------|
| `app_en.arb` | 747 |
| `app_zh_TW.arb` | 737 |

---

## 5. PYTHON TOOLS — `tools/` (3,707 LOC)

| File | Lines |
|------|-------|
| `generate_content.py` | 1,293 |
| `translation_pipeline.py` | 556 |
| `verify_e2e.py` | 356 |
| `data_pipeline.py` | 279 |
| `validate_no_english_leaks.py` | 252 |
| `fix_translations.py` | 207 |
| `add_vocabulary.py` | 172 |
| `json_to_dart.py` | 129 |
| `build_final_cards.py` | 127 |
| `generate_chill_posts.py` | 125 |
| `match_jmdict.py` | 94 |
| `match_tatoeba_sentences.py` | 70 |
| `parse_jlpt_vocab.py` | 47 |

---

## 6. RAW DATA & VENDOR

| Area | Files | LOC |
|------|-------|-----|
| `raw_data/` | 11 | 197,909 |
| `vendor/` | 18 | 106,008 |

---

*Last updated: 2026-06-05*
