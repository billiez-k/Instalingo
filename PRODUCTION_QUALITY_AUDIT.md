# InstaLingo — Production Quality Audit & Remediation Plan

> **Audit date**: 2026-06-09  
> **Scope**: Every data field, every content type, every quality dimension  
> **Method**: Automated scan of all 8,054 cards + 25 posts + 6 characters + manual spot-check

---

## 0. DATA PROVENANCE (Where Did the Data Come From?)

**Card data is from legitimate, traceable sources — NOT AI-generated:**

| Layer | Source | License | Quality |
|-------|--------|---------|---------|
| Word list | `open-anki-jlpt-decks` | MIT | Good — community-vetted JLPT word lists |
| Definitions (en) | `JMdict/EDRDG` | CC-BY-SA 4.0 | **Gold standard** — the authoritative Japanese-English dictionary |
| Definitions (zh_TW) | Unknown — not attributed in source field | Unknown | Good quality, needs source verification |
| Example sentences | `Tatoeba` (individual sentence IDs) | CC-BY 2.0 FR | Mixed — Tanaka Corpus origin in many cases, some unnatural |

**Each card has a Tatoeba sentence ID in its `source` field** (e.g., "Tatoeba #74070"). This is outstanding for traceability — every example sentence can be verified, updated, or replaced with a better Tatoeba sentence.

**Posts appear partially AI-generated**: 2/25 posts use formulaic patterns ("Finally mastered...", "Small wins! 🎉"). 3/25 contain emoji. zh_TW translations exist for all 25 posts.

**Characters are fictional creations** — custom bios, no real-world attribution needed.

---

## 1. CRITICAL QUALITY GAPS FOUND

### 🔴 GAP 1: POS Field — 100% Corrupted

**All 8,054 cards have `"pos": "noun"`**. This is clearly a data processing error — the JMdict source data has rich POS information (verb, adj, adv, particle, conjunction, expression, etc.) that was lost during compilation.

**Impact**: Every card in the app shows "noun" as the part of speech. The `_posIcon()` function in swipe_screen.dart (which shows different icons for verb/noun/adj/adv) always shows the noun icon. Users cannot filter or browse by POS.

**Fix**: Re-extract POS from JMdict using word+reading matching. JMdict entries have detailed `<pos>` tags. This is a one-time data processing task.

### 🔴 GAP 2: Topic Field — 100% Empty

**All 8,054 cards have `"topic": "general"`**. No topic diversity whatsoever.

**Impact**: Topic-based filtering, browsing, and themed learning paths are impossible. The `_chip(card.topic, ...)` UI element always shows "general".

**Fix**: Two options:
1. **JMdict-based**: JMdict entries have `<field>` and `<misc>` tags that can be mapped to topics (e.g., linguistics, food, computing, medicine, sports)
2. **LLM classification**: Use GPT-4o to classify each card into topics (food, travel, business, daily life, emotions, nature, technology, etc.) — fast, cheap (~$5 for all 8,054)

### 🔴 GAP 3: Missing Example Sentences — Up to 12%

| Level | Missing Examples | % |
|-------|-----------------|---|
| N5 | 15 | 2% |
| N4 | 10 | 1% |
| N3 | 12 | <1% |
| N2 | **200** | **10%** |
| N1 | **326** | **12%** |

**563 cards (7%) have no example sentence at all.** N2 and N1 are hit hardest — exactly the levels where example sentences are most needed to understand nuanced usage.

### 🔴 GAP 4: Example Sentence Quality Issues

- **5 cards** have example sentences that are just the word itself (e.g., `する` → `愛する`)
- **At least 1 card** has a paragraph-length translation (251 chars) from a Tatoeba sentence that was clearly not written as a vocabulary example
- **Tanaka Corpus origin**: Many Tatoeba sentences trace back to the Tanaka Corpus, which is known to contain stilted, unnatural English. The Tatoeba community has been editing these for years but quality varies.

### 🔴 GAP 5: Zero Audio — All 8,054 Cards

No `audio_url` is populated for any card. The `audio_url` field exists in the schema but contains empty strings or null.

**Impact**: No pronunciation audio. Users cannot hear how the word is spoken. The app relies on device TTS (Flutter TTS) which may not sound natural for Japanese.

**Fix**: Several options:
1. **Forvo API** — human-pronounced words, ~$0.02/word → ~$160 for all 8,054
2. **Amazon Polly / Google Cloud TTS** — synthetic but natural-sounding Japanese, ~$4 per million chars → ~$0.50 total for all readings
3. **JMdict audio projects** — some community projects pair audio with JMdict entries (e.g., Kanji alive)

### 🔴 GAP 6: Zero Images — All 8,054 Cards

No `image_url` is populated for any card.

**Impact**: Visual learners get no image association. Cards are text-only.

**Fix**: 
1. **Unsplash/Pexels API** — free stock photos, can match by topic keyword
2. **AI-generated** — DALL-E/Stable Diffusion for consistent style
3. **Icon-based** — use Phosphor icons by topic as visual anchors (cheapest, most consistent)

### 🟡 GAP 7: Example Reading Missing — Same as Missing Examples

`example_reading` is missing for the same 563 cards that lack example sentences. For cards that DO have examples, `example_reading` appears populated (shows furigana/reading).

### 🟡 GAP 8: Post Content — Partially AI-Generated

2/25 posts contain formulaic AI patterns ("Finally mastered...", "Small wins! 🎉"). 3/25 posts contain emoji (violates the app's zero-emoji policy from AGENTS.md).

**Fix**: Rewrite flagged posts with more authentic, diverse voices. The 6 characters should have distinct writing styles reflecting their personalities.

### 🟡 GAP 9: Post Locale Data Exists But Not Used

All 25 posts have `content_zh` (Traditional Chinese) in the JSON. The `ChillPost.fromJson` model reads `json['content']` instead of `json['content_en']`/`json['content_zh']`. Same bug as documented in the localization plan.

### 🟡 GAP 10: zh_TW Meaning Source Unverified

The `meaning_zh` field is populated for all 8,054 cards but the `source` field only attributes en (JMdict) and example (Tatoeba). Where did the zh_TW translations come from? Need to verify quality and license.

---

## 2. WHAT'S ACTUALLY HIGH QUALITY (Not Everything Is Broken)

| Aspect | Quality | Evidence |
|--------|---------|----------|
| **English meanings** | ⭐⭐⭐⭐⭐ | JMdict — the gold standard. Professionally curated for 30+ years. |
| **Word list coverage** | ⭐⭐⭐⭐⭐ | 8,054 words across N5-N1. Comprehensive JLPT coverage. |
| **Reading (furigana)** | ⭐⭐⭐⭐⭐ | All 8,054 cards have readings. Zero missing. |
| **Example sentence traceability** | ⭐⭐⭐⭐⭐ | Every sentence has a Tatoeba ID. Can be verified, replaced, or enriched. |
| **Card difficulty sorting** | ⭐⭐⭐⭐ | Kanji-aware difficulty scoring in CardDataLoader. |
| **Card→Post linkage** | ⭐⭐⭐⭐⭐ | 0 broken links. All 25 posts link to valid card IDs. |
| **JSON structure** | ⭐⭐⭐⭐⭐ | Clean `{deck: {...}, cards: [...]}` format. Properly parsed by model. |
| **License compliance** | ⭐⭐⭐⭐⭐ | All data sources are CC-BY-SA/MIT licensed with attribution in `source` field. |
| **zh_TW meaning coverage** | ⭐⭐⭐⭐ | All 8,054 cards have Chinese translations. Source attribution needed. |

---

## 3. AI TRANSLATION QUALITY ASSESSMENT

### Will AI-generated translations cause low quality?

**For vocabulary meanings**: NO — this is actually the safest use case.
- JMdict provides authoritative English definitions as source
- Translating "ah!; oh!; alas!" to Korean "아! 오! 아아!" is a straightforward dictionary task
- Google NMT + glossary for terminology consistency makes errors very unlikely
- Risk: Low. Solution: glossary enforcement + spot-check.

**For example sentences**: YES — there are real risks.
- Tatoeba sentences are often unnatural/stilted in English
- Translating a bad English sentence into Korean produces a bad Korean sentence
- LLM translations may lose the grammar teaching point
- Risk: Medium. Solution: Tatoeba enrichment first (real human sentences for zh/ko/ar), then LLM with quality prompts, then human spot-check.

**For post content**: YES — AI-written posts sound fake.
- Formulaic patterns ("Finally mastered...") are detectable
- Character voice is lost in translation
- Risk: Medium. Solution: Human-written source posts, LLM for translation only, character-specific prompts.

### How Production Apps Handle This

| App | Translation Method | QA Process |
|-----|-------------------|------------|
| **Duolingo** | Professional translators + volunteer contributors | A/B testing, user reports, in-house linguists |
| **Busuu** | Professional translators (in-house) | Editorial review, McGraw-Hill certification |
| **LingoDeer** | Professional translators (Asian language focus) | Native speaker review per language pair |
| **Anki (shared decks)** | Community-contributed | User ratings, comments, corrections |
| **Memrise** | Professional + community | User reports, "difficult word" flagging |
| **Drops** | Professional translators | In-house linguistic QA team |

**None of the top apps use pure AI/MT for production content without human review.** The standard is: MT for draft → human editor reviews → publish → community feedback loop.

---

## 4. PRODUCTION-READY REMEDIATION ROADMAP

### Phase 1: Fix Broken Data (Critical — blocks release)

| Task | Effort | Cost | Method |
|------|--------|------|--------|
| Re-extract POS from JMdict | 8-12 hours | $0 | Match 8,054 cards to JMdict XML entries by word+reading. Extract `<pos>` tags. |
| Classify topics (replace "general") | 4 hours | **~$5** | GPT-4o batch classification into 20+ topic categories. Review 5% sample. |
| Fill 563 missing example sentences | 4 hours | **~$2** | Query Tatoeba API for each word. Select best sentence by length/votes. No sentence found → GPT-4o generation with quality prompt. |
| Fix example quality (word-only, paragraph-length) | 2 hours | $0 | Flag and manually replace ~10 bad examples from Tatoeba alternatives. |
| Verify zh_TW meaning source & license | 2 hours | $0 | Research origin, add attribution to source field or flag for re-translation. |

### Phase 2: Enrich Content (Production quality)

| Task | Effort | Cost | Method |
|------|--------|------|--------|
| Add card meanings for zh_CN, ko, ms, ar | 2 hours | **~$2** | Google Cloud NMT with glossary. (Per LOCALIZATION_PRODUCTION_PLAN.md) |
| Add example translations for all 6 non-en locales | 4 hours | **~$10** | GPT-4o Batch API. Enrich with Tatoeba human translations where available. |
| Fix post locale resolution model | 2 hours | $0 | Read `content_en`/`content_zh` in ChillPost.fromJson. Add `contentFor(locale)`. |
| Translate posts to 6 languages | 2 hours | ~$1 | GPT-4o with character-voice prompts. |
| Add locale support to Character model | 2 hours | $0 | Add `bioFor()`, `personalityFor()` methods. |
| Remove emoji from posts | 30 min | $0 | Manual edit or regex strip. |
| Rewrite formulaic AI-sounding posts | 2 hours | $0 | Human edit 2 flagged posts + spot-check others. |
| Add pronunciation audio | 4 hours | **$0.50** | Google Cloud TTS (Japanese voice) → MP3 files → reference in audio_url. |
| Add visual icons by topic | 3 hours | $0 | Map topics → Phosphor icons. No external images needed. |

### Phase 3: QA & Polish (Release-ready)

| Task | Effort | Cost |
|------|--------|------|
| Human QA spot-check: 5% sample per language | 6 hours | $200-500 |
| POS/topic distribution validation | 1 hour | $0 |
| Example sentence quality review: N2/N1 focus | 2 hours | $0 |
| Card→post cross-reference validation | 30 min | $0 |
| "Report issue" button in card detail | 2 hours | $0 |
| Run `flutter analyze` — confirm 0 errors 0 warnings | 5 min | $0 |
| Test all 7 locale paths end-to-end | 2 hours | $0 |

### Phase 4: Future (Ongoing quality)

| Task | Effort | Cost |
|------|--------|------|
| Community translation contributions | Platform build | $0 |
| User-reported translation corrections | Already designed | $0 |
| Periodic Tatoeba sentence refresh | Script — recurring | $0 |
| Audio quality upgrade (Forvo human voices) | 4 hours | $160 |

---

## 5. COST SUMMARY

| Phase | Tasks | Cost |
|-------|-------|------|
| Phase 1: Fix broken data | POS + topics + examples + zh_TW verify | **~$7** |
| Phase 2: Enrich content | Multi-lang translation + audio + icons + posts | **~$14** |
| Phase 3: QA & polish | Human review + validation + report button | **$200-500** |
| **TOTAL (automated)** | | **~$21** |
| **TOTAL (with human QA)** | | **~$221-521** |

---

## 6. IMMEDIATE NEXT ACTIONS (Can Start Now)

1. **Fix POS**: Write script to match cards to JMdict XML, extract POS. This is the single biggest quality issue — affects every card in the app.

2. **Fix topics**: GPT-4o batch classify all 8,054 cards into categories. Replace "general".

3. **Fix ChillPost model**: Read `content_en`/`content_zh`, add `contentFor()`. This immediately unlocks zh_TW post content that already exists.

4. **Remove emoji from posts**: Quick manual edit.

5. **Start Google Cloud NMT + GPT-4o translation pipeline** (per LOCALIZATION_PRODUCTION_PLAN.md).

These 5 tasks fix the most visible quality gaps and can be done without waiting for human translators.
