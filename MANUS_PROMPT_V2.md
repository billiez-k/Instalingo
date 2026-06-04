# Manus AI Prompt v2 — Data Acquisition Only (NO Exercise Generation)

> **Copy-paste this into a NEW Manus AI chat. Upload the 4 files from the zip.**
> 
> ⚠️ **CRITICAL RULE: You are a DATA HUNTER. You download and organize raw data. You do NOT generate course JSON or exercises. My Python scripts handle all exercise generation from your data.**

---

## YOUR ROLE

Download raw teaching materials and output structured data files. You are the **data acquisition layer**, not the content generator.

**You DO:**
- Download bulk datasets (Tatoeba, vocab PDFs, Anki decks)
- Extract and normalize data (parse PDFs → CSV, extract Anki SQLite → JSON)
- Find and download official vocabulary lists per language
- Output structured CSV/JSON files

**You DO NOT:**
- Generate exercises (no fillInBlank, flashCard, etc.)
- Create course JSON files (no en_a1.json output)
- Write any "teaching content" (explanations, instructions)
- Invent sentences or translations

---

## FILES I'M UPLOADING

1. **`generate_content.py`** — My Python script that generates exercises from YOUR data. Study it to understand the input format it needs.
2. **`golden_en_a1.json`** — An example of the final output my scripts produce (for format reference only — you don't produce this).
3. **`CONTENT_ACQUISITION_GUIDE.md`** — Search queries and download URLs for each language.
4. **`APP_REFERENCE_RESEARCH.md`** — Context (optional).

---

## WHAT TO PRODUCE PER LANGUAGE

For EACH of these 6 languages (Korean, Japanese, French, Spanish, Chinese, German), output:

### File 1: `{lang}_vocab.csv`
```
word,phonetic,pos,cefr_level,topic,translation_zh,translation_en
안녕하세요,annyeonghaseyo,interjection,A1,greetings,你好,hello
감사합니다,gamsahamnida,expression,A1,greetings,谢谢,thank you
...
```
- Source: TOPIK I (Korean), JLPT N5 (Japanese), DELF A1 (French), DELE A1 (Spanish), HSK 1-2 (Chinese), Goethe A1 (German)
- Minimum 200 words per language
- Translation columns: `translation_zh` (Chinese translation) AND `translation_en` (English translation)

### File 2: `{lang}_sentences.csv`
Real sentences in the target language with English translations:
```
sentence,target_lang,translation_en
안녕하세요, 저는 민수입니다.,ko,Hello, I am Minsu.
おはようございます。,ja,Good morning.
Bonjour, je m'appelle Marie.,fr,Hello, my name is Marie.
```
- Source: Tatoeba (filter by language + A1 vocabulary)
- OR scrape from official textbook transcripts
- Minimum 300 sentence pairs per language
- Sentences must be ≤ 8 words (non-CJK) or ≤ 10 chars (CJK)

### File 3: `{lang}_grammar.json`
```json
[
  {
    "topic": "은/는 subject particle",
    "cefr_level": "A1",
    "rule_en": "Use 은/는 to mark the topic of a sentence.",
    "example_target": "저는 학생입니다.",
    "example_en": "I am a student."
  }
]
```
- Minimum 40 grammar points per language, in teaching order
- Each with rule explanation in English + example in target language + English translation
- Source: official grammar guides (Tae Kim, How to Study Korean, Chinese Grammar Wiki, etc.)

---

## DATA SOURCES PER LANGUAGE

| Lang | Vocab Source | Sentence Source | Grammar Source |
|------|-------------|-----------------|----------------|
| KO | TOPIK I PDF | Tatoeba (kor-eng pairs) | How to Study Korean units 1-2 |
| JA | JLPT N5 PDF | Tatoeba (jpn-eng pairs) | Tae Kim's Guide (basic section) |
| FR | DELF A1 vocabulaire PDF | Tatoeba (fra-eng pairs) | French A1 grammar guides |
| ES | DELE A1 vocabulario PDF | Tatoeba (spa-eng pairs) | Spanish A1 grammar guides |
| ZH | HSK 1-2 word list PDF | Tatoeba (cmn-eng pairs) | Chinese Grammar Wiki A1 |
| DE | Goethe A1 Wortliste PDF | Tatoeba (deu-eng pairs) + Nicos Weg | German A1 grammar guides |

---

## OUTPUT FORMAT

Deliver everything in this structure:
```
instalingo_raw_data/
├── ko_vocab.csv
├── ko_sentences.csv
├── ko_grammar.json
├── ja_vocab.csv
├── ja_sentences.csv
├── ja_grammar.json
├── fr_vocab.csv
├── fr_sentences.csv
├── fr_grammar.json
├── es_vocab.csv
├── es_sentences.csv
├── es_grammar.json
├── zh_vocab.csv
├── zh_sentences.csv
├── zh_grammar.json
├── de_vocab.csv
├── de_sentences.csv
├── de_grammar.json
└── sources.md                ← URLs of where each file was downloaded from
```

## DON'T STOP HALFWAY

- Complete ALL 6 languages.
- If you can't find a specific PDF, search alternatives and note in `sources.md`.
- If a Tatoeba download is too large, filter by language during streaming.
- Do NOT skip any language.
- Do NOT generate exercises — just raw data.

---

*Upload the zip. You are a data pipeline, not a course generator.*
