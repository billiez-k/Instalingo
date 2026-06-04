# InstaLingo — Korean Content Sources & Provenance

**Date:** 2026-06-02
**Total files with content:** 9 (no empty placeholders at foundation/topik1 level)
**⚠️ Major gap:** TOPIK II not covered at all. TOPIK I vocabulary needs official source verification.

---

## Provenance by Source

### Source 1: AI Training Knowledge (published TOPIK I syllabus)
**Status:** NEEDS_VERIFICATION — AI reconstructed from training data. NOT downloaded from an official source.
**⚠️ CRITICAL: Must verify against official TOPIK I vocabulary list before production use.**

| File | Items |
|------|-------|
| `korean/topik1/vocabulary.json` | 300 words |
| `korean/foundation/vocabulary.json` | 30 words |
| **Total** | **330 words** |

**Verification path:** Download TOPIK I official vocabulary list from topik.go.kr or learning-korean.com. Cross-reference all 330 words. Mark any missing or incorrect.

---

### Source 2: Tatoeba (CC-BY 2.0 FR)
**URL:** https://tatoeba.org / https://downloads.tatoeba.org/exports/
**License:** CC-BY 2.0 FR — commercial use OK with attribution
**Status:** ✅ SOURCE_VERIFIED — Filtered from sentences.csv + links.csv

| File | Items |
|------|-------|
| `korean/topik1/sentences.json` | 290 sentences |
| `korean/foundation/sentences.json` | 20 sentences |
| **Total** | **310 sentences** |

---

### Source 3: Standard TOPIK I Grammar (public linguistic knowledge)
**Status:** STANDARD_REFERENCE — AI-generated explanations from known patterns. Not copyrighted — grammar patterns are public knowledge. Needs native-speaker review.

| File | Items | Quality | Coverage |
|------|-------|---------|----------|
| `korean/foundation/grammar.json` | 5 points | 5/5 ko ✅ | Foundation |
| `korean/topik1/grammar.json` | 40 points | 40/40 ko ✅ | **Only 27% of standard** |
| **Total** | **45 points** | | **69 standard patterns missing** |

**Critical missing patterns (partial list):**
-아/어요 (polite present), -았/었어요 (past), -(으)ㄹ 거예요 (future), -고 (and/then), -도 (also), -의 (possessive), -부터...까지 (from...to), -(으)ㄹ 수 있다/없다 (can/cannot), -(으)세요 (imperative), -지 마세요 (don't), -ㅂ시다 (let's), -아/어도 되다 (may)

---

### Source 4: AI-Generated Content (needs human review)

| File | Items | Type |
|------|-------|------|
| `korean/topik1/mock_test.json` | 25 questions | Mock test |
| `korean/topik1/passages.json` | 4 passages | Reading comprehension |
| `korean/topik1/dialogues.json` | 5 dialogues | Conversation practice |

**⚠️  All AI_GENERATED items need native-speaker quality review before production use.**

---

## TOPIK II — Completely Missing

| Content Type | Needed |
|-------------|--------|
| Vocabulary | ~1,500 words (levels 3-6) |
| Grammar | ~100 patterns |
| Mock test | 25 questions (includes writing section) |
| Reading passages | 4-8 passages (longer, more complex) |
| Writing prompts | 2-4 essay prompts with model answers |

**No TOPIK II content exists in any form.** This requires full content acquisition from official TOPIK II sources.

---

## Summary

| Provenance | Files | Items | License | Review Needed? |
|------------|-------|-------|---------|---------------|
| Tatoeba | 2 | 310 sentences | CC-BY | No |
| Public knowledge (grammar) | 2 | 45 points | None needed | **Yes** — native speaker + fill gaps |
| AI training data (vocab) | 2 | 330 words | Unverified | **Yes** — verify against official list |
| AI-generated | 3 | ~34 items | N/A | **Yes** — native speaker |
| **Total** | **9** | **~719** | | |

## Critical Action Items

1. **Verify TOPIK I vocabulary** against official list (topik.go.kr)
2. **Fill 69 missing grammar patterns** — critical for exam prep
3. **Native speaker review** — all grammar, mock tests, passages, dialogues
4. **TOPIK II content** — entire level needs creation from scratch
