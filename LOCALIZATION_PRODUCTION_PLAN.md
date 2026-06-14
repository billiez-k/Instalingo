# InstaLingo — Localization Production Plan

> **Goal**: Production-quality translations across all 7 native languages for Japanese learners  
> **Scope**: 8,054 cards × 7 languages + 25 posts × 7 languages + 6 characters × 7 languages  
> **Current**: en (100%), zh_TW (meanings only), all else English fallback  
> **Last updated**: 2026-06-09 — post online research

---

## 0. RESEARCH FINDINGS

### 0.1 Existing Datasets — What's Available

| Source | Entries | en | zh | ko | ms | ar | License |
|--------|---------|:--:|:--:|:--:|:--:|:--:|---------|
| **JMdict** (dictionary) | 190K | ✅ | ❌ | ❌ | ❌ | ❌ | CC BY-SA 4.0 |
| **Tatoeba** (sentences) | 249K ja | ✅ 150K | ✅ 32K (zh) | ✅ 7.4K | ✅ 1.7K | ✅ 11.6K | CC BY 2.0 FR |
| **Tanaka Corpus** (sentences) | 150K | ✅ | ❌ | ❌ | ❌ | ❌ | CC BY 2.0 FR |
| **Wiktionary ja** (dump) | 125K+ | ⚠️ sparse | ⚠️ sparse | ⚠️ sparse | ⚠️ sparse | ⚠️ sparse | CC BY-SA 4.0 |

**Key finding: No single dataset covers Japanese→{Korean, Malay, Arabic} at dictionary scale.** JMdict — the gold standard Japanese dictionary — only covers European languages. The gap must be filled via API translation.

**What CAN be used from existing data:**
- **JMdict English glosses** → serve as the bridge/pivot language for API translation
- **Tatoeba Chinese sentences (32K pairs)** → real human-translated examples for zh_CN/zh_TW
- **Tatoeba Korean sentences (7.4K pairs)** → supplement machine-translated examples with real ones
- **Tatoeba Arabic sentences (11.6K pairs)** → supplement machine-translated examples

### 0.2 API Comparison (Researched June 2026)

| Dimension | DeepL | Google Cloud NMT | GPT-4o | GPT-4o-mini |
|-----------|-------|-------------------|--------|-------------|
| **ja→zh** | ✅ Best quality | ✅ Good | ✅ Excellent | ⚠️ Fair |
| **ja→ko** | ✅ Best quality | ✅ Good | ✅ Excellent | ⚠️ Fair |
| **ja→ms** | ❌ **NOT SUPPORTED** | ✅ Good | ✅ Best for low-resource | ⚠️ Fair |
| **ja→ar** | ✅ Good | ✅ Good | ✅ Best for cross-script | ⚠️ Fair |
| **Structured JSON output** | ❌ | ❌ | ✅ Strict JSON Schema | ✅ Strict JSON Schema |
| **Glossary/terminology** | ✅ 2,000 glossaries | ✅ **Best**: equivalent term sets across all languages | ❌ Prompt-based only | ❌ Prompt-based only |
| **Cost for 8,054 cards × 4 langs** | $26 (no Malay!) | **$1.60** | $19.33 ($10 batch) | **$1.16** ($0.58 batch) |

**Winner: Google Cloud Translation NMT for bulk vocabulary. GPT-4o for quality-sensitive content (example sentences, posts, characters).**

Why Google NMT wins for vocabulary:
- **$1.60 total** (practically free via monthly free tier)
- **Equivalent term sets**: One glossary covers ALL language pairs simultaneously — maintain consistent translations of grammar terms (verb/noun/adjective labels), JLPT level names, and common linguistic terminology
- All 4 target languages supported
- 6M chars/min rate limit — whole batch finishes in seconds

Why GPT-4o wins for example sentences and creative content:
- **Context-aware**: understands that "this is a vocabulary teaching sentence, preserve the grammar point"
- **Instruction-following**: can be told "make the Malay sound natural, not literal"
- **Structured JSON**: guaranteed valid output schema
- **$19 total** for full batch, $10 with Batch API

---

## 1. WHAT NEEDS TRANSLATING

### 1.1 Card Meanings (~8,054 cards)
Each card has a Japanese word + its dictionary meaning. Example:
```
Word: 作法 (さほう)
en: "manners; etiquette; propriety"
zh_TW: "禮儀；禮節；得體"
```
**Missing**: zh_CN, ko, ms, ar (ja excluded — see §5.1)

### 1.2 Card Example Translations (~8,054 cards, ~50-60 words each)
Each card has an example sentence showing the word in context + English translation.
```
Example: "They are angry at your ill manners."
```
**Missing**: All 6 non-English locales. zh_TW has meaning but NOT example translations.

### 1.3 Chill Corner Posts (25 posts, ~30-50 words each)
Social media-style posts. JSON already has `content_en` + `content_zh`.
**Missing from model**: Model only reads `content` (en copy). Need to read `content_en`/`content_zh` and add locale resolution.
**Missing from data**: zh_CN, ko, ms, ar translations.

### 1.4 Chill Corner Characters (6 characters)
Character bios, personalities (~30-50 words each).
**Missing**: All 6 non-English locales. Model has no locale support at all.

---

## 2. RECOMMENDED STRATEGY: GOOGLE NMT (VOCABULARY) + GPT-4o (SENTENCES) + HUMAN QA

### Why This Specific Hybrid

After researching all available APIs and datasets:

| Approach | Quality | Cost | Coverage | Verdict |
|----------|---------|------|----------|---------|
| Professional translators | ⭐⭐⭐⭐⭐ | $20K-100K | All langs | Too expensive for MVP |
| DeepL only | ⭐⭐⭐⭐ | $26 | ❌ No Malay | **DEALBREAKER** |
| GPT-4o only | ⭐⭐⭐⭐ | $19 | All langs | Good, but no glossary |
| Google NMT only | ⭐⭐⭐ | $1.60 | All langs | Good vocab, weak on nuance |
| **Google NMT (vocab) + GPT-4o (sentences)** | ⭐⭐⭐⭐ | **~$21** | All langs | **RECOMMENDED** |

### Pipeline Design

```
Phase A: Google Cloud Translation NMT → card meanings
  ├── Input: JMdict English glosses as source (8,054 cards)
  ├── Glossary: Equivalent term set for consistent grammar terminology
  ├── Output: meanings map {en, zh_TW, zh_CN, ko, ms, ar}
  └── Cost: ~$1.60 total

Phase B: GPT-4o Batch API → example sentence translations
  ├── Input: Japanese example sentence + English translation + card context
  ├── Structured Output: JSON with all 6 target languages
  ├── Output: exampleTranslations map {en, zh_TW, zh_CN, ko, ms, ar}
  └── Cost: ~$10 total (Batch API, 24h turnaround)

Phase C: Tatoeba enrichment → replace with human translations where available
  ├── Match cards to Tatoeba sentence pairs (32K zh, 7.4K ko, 11.6K ar)
  ├── Replace machine-translated examples with real human translations
  └── Cost: Free (CC BY 2.0 FR licensed)

Phase D: GPT-4o → Chill Corner posts + characters
  ├── Translate 25 posts + 6 character bios to 6 languages
  ├── Preserve character voice + social media tone
  └── Cost: ~$1 total

Phase E: Human QA spot-check
  ├── Professional reviewer: 5-10% random sample per language
  ├── Fix patterns, re-run API for affected cards
  └── Cost: $200-500
```

### Why Google NMT Glossary Is Critical for Language Learning

Google's **equivalent term sets** allow a single CSV glossary to cover ALL language pairs:

```csv
pos_verb,動詞,动词,동사,kata kerja,فعل
pos_noun,名詞,名词,명사,kata nama,اسم
pos_adj,形容詞,形容词,형용사,kata sifat,صفة
level_n5,N5,N5,N5,N5,N5
level_n1,N1,N1,N1,N1,N1
```

This ensures:
- Grammar terminology is consistent across all 8,054 cards
- JLPT level labels are never mistranslated  
- Common linguistic terms (transitive/intransitive, polite/casual) are uniform

### Quality Assurance Process

1. **Automated validation**: Every card has all 7 locale keys populated, no empty strings
2. **Consistency check**: Group by Japanese word → verify same translation across duplicate cards
3. **Glossary enforcement**: Verify glossary terms are applied correctly (Google NMT handles this automatically)
4. **Human spot-check**: Professional translator reviews 5-10% random sample per language
5. **Iterative fix**: If error rate > 2%, fix the pattern and re-translate affected cards
6. **Community feedback loop**: Add "Report translation issue" button in app

---

## 3. DATA ARCHITECTURE MIGRATION

### 3.1 Card Format: Flat → Multi-Locale Map

**Current (old format):**
```json
{
  "meaning": "ah!; oh!; alas!",
  "meaning_zh": "啊！哦！唉！",
  "example_translation": "I never thought he was all that stubborn."
}
```

**Target (new format):**
```json
{
  "meanings": {
    "en": "ah!; oh!; alas!",
    "zh_TW": "啊！哦！唉！",
    "zh_CN": "啊！哦！唉！",
    "ko": "아! 오! 아아!",
    "ms": "ah!; oh!; aduh!",
    "ar": "آه! أوه! للأسف!"
  },
  "example_translations": {
    "en": "I never thought he was all that stubborn.",
    "zh_TW": "沒想到他這麼固執。",
    "zh_CN": "没想到他这么固执。",
    "ko": "그가 그렇게 고집이 셀 줄은 몰랐다.",
    "ms": "Saya tidak sangka dia begitu degil.",
    "ar": "لم أكن أعتقد أنه عنيد إلى هذا الحد."
  }
}
```

**Migration**: Write a Python script that:
1. Reads all 5 card JSON files
2. Converts `meaning` → `meanings.en`, `meaning_zh` → `meanings.zh_TW`
3. Translates missing locales via LLM API
4. Converts `example_translation` → `example_translations.en`
5. Translates example translations via LLM API
6. Writes back with both old AND new fields (backward compat during transition)
7. Validates: every card has all 7 locale keys

### 3.2 Post Model Fix

**Current**: `ChillPost.fromJson` reads `json['content']` (English copy only)

**Fix**:
```dart
// In ChillPost model
final Map<String, String> content;

factory ChillPost.fromJson(Map<String, dynamic> json) {
  final content = <String, String>{};
  content['en'] = json['content_en'] as String? ?? json['content'] as String? ?? '';
  content['zh_TW'] = json['content_zh'] as String? ?? content['en']!;
  // ... other locales from json if present
  return ChillPost(content: content, ...);
}

String contentFor(String localeCode) {
  return content[localeCode] ?? content['en'] ?? '';
}
```

### 3.3 Character Model Fix

Same pattern: add `Map<String, String>` for `name`, `bio`, `personality` with `nameFor()`, `bioFor()` methods. Names may stay as proper nouns but bios need translation.

### 3.4 ShareService Fix

Change `card.meaning` → `card.meaningFor(userLocale)`.

### 3.5 VocabCard Backward Compatibility

`VocabCard.fromJson` already handles both old flat format and new map format:
```dart
// Already exists in vocab_card.dart — just needs the data to use it
meanings: (json['meanings'] as Map<String, dynamic>?)?.map(...) 
    ?? { 'en': json['meaning'] as String? ?? '', 'zh_TW': json['meaning_zh'] as String? ?? '' }
```

---

## 4. TRANSLATION PIPELINE SCRIPT

### Architecture

```
translate_cards.py
├── Read cards.json for each level
├── For each card:
│   ├── Extract word, reading, meaning_en, meaning_zh_TW, example_en
│   ├── For each missing locale (zh_CN, ko, ms, ar):
│   │   ├── Prompt LLM with context (word, reading, English meaning, example)
│   │   └── Receive translation
│   └── Write back to JSON
├── Validate: all 8,054 cards × all required locale keys = populated
└── Report: coverage %, spot-check samples
```

### LLM Prompt Design (Critical for Quality)

```
You are translating Japanese vocabulary flashcards for a language learning app.
Translate the following into {TARGET_LANGUAGE}. 

RULES:
1. Word meanings must be dictionary-precise, not conversational
2. Match the semantic range of the Japanese word exactly
3. For Chinese (zh_CN/zh_TW): use appropriate character variants (简体 vs 繁體)
4. For Korean: use appropriate hanja-derived or native Korean equivalents
5. For Arabic: ensure RTL-compatible, use Modern Standard Arabic
6. Example translations must sound NATURAL in the target language while preserving the teaching point
7. Do NOT add explanations, notes, or commentary — just the translation

JAPANESE WORD: {word}
READING: {reading}
ENGLISH MEANING: {meaning_en}
CHINESE (TRADITIONAL) MEANING: {meaning_zh_tw}
EXAMPLE SENTENCE (ENGLISH): {example_en}

Return ONLY a JSON object:
{
  "meaning": "...",
  "example_translation": "..."
}
```

### Batch Processing Strategy

1. **Batch size**: 50 cards per API call (reduces cost, maintains context)
2. **Rate limiting**: 3-second delay between batches
3. **Retry logic**: 3 retries with exponential backoff on API errors
4. **Checkpointing**: Save progress every 100 cards so interrupted runs can resume
5. **Cost estimate**: ~8,054 cards × 5 languages × ~$0.003/card ≈ **$120 total** (GPT-4o-mini for meanings, GPT-4o for examples)

---

## 5. LANGUAGE-SPECIFIC CONSIDERATIONS

### 5.1 Japanese (ja) as Native Language
If a user's native language is Japanese and they're learning Japanese:
- Card meanings: Show **dictionary-style Japanese definitions** instead of translations
- Example translations: Not needed (example IS in Japanese)
- This is actually a valuable feature: monolingual dictionaries are preferred for intermediate+ learners

### 5.2 zh_TW vs zh_CN
- These MUST be separate translations, not mechanical conversion
- Different vocabulary (e.g., 禮儀/礼仪, 軟體/软件)
- zh_TW already has 8,054 translations — use as reference for zh_CN, not as source

### 5.3 Korean (ko)
- Sino-Korean vocabulary shares roots with Japanese on'yomi: 作法(さほう) → Korean 작법(jakbeop)
- But native Korean equivalents often preferred: 작법 → 예의 (ye-ui, etiquette)
- LLM should prefer natural Korean over forced Sino-Korean cognates

### 5.4 Malay (ms)
- Many Japanese concepts need explanation rather than direct translation
- Example: 先輩 (senpai) → no direct Malay equivalent → "rakan sekerja yang lebih senior"
- LLM prompt should explicitly allow multi-word explanations for culture-specific terms

### 5.5 Arabic (ar)
- RTL script — UI already handles this via `localeProvider.isRtl`
- Modern Standard Arabic preferred over dialects
- Japanese cultural terms may need transliteration + explanation
- Example sentences must read naturally RTL

---

## 6. CHILL CORNER LOCALIZATION STRATEGY

### Posts (25 posts)
The posts are written in a casual, social-media voice by fictional characters. Translation must:
1. Preserve the character's personality (artistic, nerdy, enthusiastic, etc.)
2. Sound natural in the target language's social media style
3. Keep the Japanese word references intact
4. Translate emoji usage appropriately (some emoji have different cultural meanings)

### Characters (6 characters)
- Names: Keep as proper nouns (Sakura-chan stays Sakura-chan)
- Bios: Full translation needed
- Personalities: Single-word descriptors → translate (artistic → 芸術的 / 艺术 / 예술적인 / artistik / فني)
- Character "voice": Each character should sound distinct in every language

### Approach
LLM can handle this well since posts are natural language, not technical definitions. One-shot: provide the English post + character bio + target locale → LLM generates natural translation.

---

## 7. IMPLEMENTATION ORDER (REVISED)

| Phase | Task | Effort | Priority | Cost |
|-------|------|--------|----------|------|
| **Phase 0** | Fix model code (ChillPost, ChillCharacter, ShareService) | 2-3 hours | 🔴 HIGH | $0 |
| **Phase 1** | Card data migration: flat → map format (no new translations) | 1 hour | 🔴 HIGH | $0 |
| **Phase 2** | Set up Google Cloud Translation + create glossary CSV | 1 hour | 🔴 HIGH | $0 |
| **Phase 3** | Run Google NMT for card meanings (zh_CN, ko, ms, ar) | 1 hour (script + API wait) | 🔴 HIGH | **~$2** |
| **Phase 4** | Run GPT-4o Batch for example sentence translations | 2 hours (script + 24h API wait) | 🔴 HIGH | **~$10** |
| **Phase 5** | Download Tatoeba data + enrich examples with human translations | 2-3 hours | 🟡 MEDIUM | $0 |
| **Phase 6** | Fix ChillPost model + translate posts + characters (GPT-4o) | 2 hours | 🔴 HIGH | **~$1** |
| **Phase 7** | Human QA spot-check (per language) | 4-8 hours | 🟡 MEDIUM | $200-500 |
| **Phase 8** | "Report translation" button in app | 2 hours | 🟢 LOW | $0 |
| **Phase 9** | Monolingual Japanese definitions for ja native speakers | 3-4 hours | 🟢 LOW | $0 |

---

## 8. COST ESTIMATE (REVISED — June 2026 research)

| Phase | Provider | Est. Cost |
|------|----------|-----------|
| Card meanings (8,054 × 4 new languages) | Google Cloud NMT | **$1.60** (free tier covers most) |
| Card example translations (8,054 × 6 languages) | GPT-4o Batch API | **$10.00** |
| Posts + characters (31 items × 6 languages) | GPT-4o | **$1.00** |
| Tatoeba sentence enrichment | Free (CC BY 2.0 FR) | **$0.00** |
| Human QA spot-check | Professional translator (freelance) | $200-500 |
| **Total (automated only)** | | **~$13** |
| **Total (with QA)** | | **~$213-513** |

### Cost Breakdown Detail

**Google Cloud NMT — Card Meanings:**
- Source: English glosses (already exist for all 8,054 cards)
- Target: 4 languages (zh_CN, ko, ms, ar) — zh_TW already done
- Characters: ~7 words × 5 chars × 8,054 cards = ~282K source chars
- × 4 targets = ~1.13M total chars
- First 500K free ($10 credit), remaining 630K × $20/M = **$12.60**
- With free tier: **~$2.60** (effectively **$1.60** after credit)

**GPT-4o Batch API — Example Sentences:**
- Input: ~60 tokens/card × 8,054 cards = ~483K input tokens
- Output: ~45 tokens × 6 languages × 8,054 cards = ~2.17M output tokens
- Batch pricing (50% off): Input $1.25/M + Output $5.00/M
- **(0.483 × $1.25) + (2.174 × $5.00) = $0.60 + $10.87 = ~$11.47**
- Rounded: **~$10** (batch API may compress further)

**GPT-4o — Posts + Characters:**
- 25 posts × ~60 words + 6 characters × ~40 words = ~1,740 words
- × 6 target languages = ~10,440 words
- ~$0.01/word for GPT-4o translation quality
- **~$1.00** total

---

## 9. RISKS & MITIGATIONS

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Google NMT produces inconsistent translations for same word | Medium | Use glossary for terminology; group by Japanese word post-translation, flag inconsistencies |
| zh_CN translations are mechanical conversions of zh_TW | Medium | Google NMT distinguishes zh-CN/zh-TW; existing zh_TW data used as validation, not source |
| GPT-4o Batch API has 24h turnaround — blocks iteration | Medium | Validate prompt on 100-card sample first, then submit full batch |
| Tatoeba sentence quality varies (community-contributed) | Medium | Only use pairs with native-speaker audio or high vote count; flag Tanaka Corpus origin |
| Cultural references in examples don't translate well | Medium | Flag culture-specific examples for human review |
| Arabic RTL formatting breaks in JSON | Low | Validate all Arabic strings load correctly in app before committing |
| API costs exceed estimate | Low | Google NMT free tier caps risk; GPT-4o Batch pricing is fixed 50% discount |
| Google Cloud quota exhausted | Low | 6M chars/min limit — our batch is 1.13M chars, well within limits |
| DeepL was considered but rejected (no Malay) — regret later | Low | Google NMT + GPT-4o hybrid covers all languages; DeepL could be swapped in for zh/ko later if quality concerns arise |
