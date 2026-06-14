# InstaLingo — Localization Production Plan

> **Goal**: Production-quality translations across all 7 native languages for Japanese learners  
> **Scope**: 8,054 cards × 7 languages + 25 posts × 7 languages + 6 characters × 7 languages  
> **Current**: en (100%), zh_TW (meanings only), all else English fallback

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

## 2. RECOMMENDED STRATEGY: HYBRID LLM + HUMAN QA

### Why This Approach

| Approach | Quality | Cost | Speed | Verdict |
|----------|---------|------|-------|---------|
| Professional translators | ⭐⭐⭐⭐⭐ | $20K-100K | 4-12 weeks | Too expensive for MVP |
| LLM-only (GPT-4/Claude) | ⭐⭐⭐⭐ | $200-500 | 1-2 days | Good enough for MVP with QA |
| Crowdsourcing (Duolingo model) | ⭐⭐ | Free | 6-12 months | Too slow, needs user base |
| **Hybrid: LLM bulk + human spot-check** | ⭐⭐⭐⭐ | $500-2000 | 3-7 days | **RECOMMENDED** |

### Why LLM Quality Is Sufficient for Language Learning

1. **Japanese→Chinese (zh_CN/zh_TW)**: Shared kanji + Sino-Japanese vocabulary = very high LLM accuracy. GPT-4 achieves near-professional quality for this pair.

2. **Japanese→Korean**: Similar grammar structure (SOV, particles) + shared Sino-Korean vocabulary from Chinese borrowings. LLM quality is very high.

3. **Japanese→Malay**: Different language family but straightforward vocabulary mapping. LLM quality is good, needs review for natural phrasing.

4. **Japanese→Arabic**: Most challenging pair (different script, grammar, culture). Needs the most human review.

### Quality Assurance Process

1. **Automated validation**: Every card has all 7 locale keys populated, no empty strings
2. **LLM self-review**: Ask the LLM to re-check its own translations for consistency
3. **Human spot-check**: Professional translator reviews 5-10% random sample per language
4. **Iterative fix**: If error rate > 2%, fix the pattern and re-translate affected cards
5. **Community feedback loop**: Add "Report translation issue" button in app

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

## 7. IMPLEMENTATION ORDER

| Phase | Task | Effort | Priority |
|-------|------|--------|----------|
| **Phase 1** | Fix model code (ChillPost, ChillCharacter, ShareService) | 2-3 hours | 🔴 HIGH |
| **Phase 2** | Card data migration: flat → map format (no new translations) | 1 hour | 🔴 HIGH |
| **Phase 3** | LLM translation pipeline script for card meanings | 3-4 hours | 🔴 HIGH |
| **Phase 4** | LLM translation for card example translations | 2-3 hours (mostly API wait) | 🟡 MEDIUM |
| **Phase 5** | LLM translation for posts + characters | 1 hour | 🟡 MEDIUM |
| **Phase 6** | Human QA spot-check (per language) | 4-8 hours | 🟡 MEDIUM |
| **Phase 7** | "Report translation" button in app | 2 hours | 🟢 LOW |
| **Phase 8** | Monolingual Japanese definitions for ja native speakers | 3-4 hours | 🟢 LOW |

---

## 8. COST ESTIMATE

| Item | Provider | Est. Cost |
|------|----------|-----------|
| Card meanings (8,054 × 5 languages) | GPT-4o-mini | ~$40 |
| Card example translations (8,054 × 6 languages) | GPT-4o | ~$80 |
| Posts + characters (31 items × 6 languages) | GPT-4o | ~$5 |
| Human QA spot-check | Professional translator (freelance) | $200-500 |
| **Total (LLM + minimal QA)** | | **~$125** |
| **Total (LLM + proper QA)** | | **~$625** |

---

## 9. RISKS & MITIGATIONS

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| LLM produces inconsistent translations for same word across cards | Medium | Post-process: group by Japanese word, ensure consistent translation |
| zh_CN translations are mechanical conversions of zh_TW | Medium | Explicitly prompt for zh_CN-specific vocabulary |
| Cultural references in examples don't translate well | Medium | Flag culture-specific examples for human review |
| Arabic RTL formatting breaks in JSON | Low | Validate all Arabic strings load correctly in app |
| API costs exceed estimate | Low | Use GPT-4o-mini for meanings, reserve GPT-4o for examples only |
