# GPT Research Task: Copyright-Free Exam Content for Japanese & Korean Learning App

> **Send this entire document to GPT-4 or Claude with web search enabled.**
> **Goal:** Find every official/copyright-free source that can fill our content gaps.
> **Output:** A structured report with URLs, license status, and content counts.

---

## What We're Building

**InstaLingo** — A mobile exam-prep app for Japanese (JLPT N5-N1) and Korean (TOPIK I-II).
We currently have vocabulary (8,081 words from MIT-licensed GitHub repos) and kanji (2,126 characters).
We need to fill the remaining content types WITHOUT relying on AI generation or native speakers.

---

## Content Types We Need — Exact Requirements Per Exam Level

### 1. JLPT GRAMMAR POINTS (580 patterns needed)

| Level | Patterns Needed | What Each Pattern Needs |
|-------|----------------|------------------------|
| N5 | 40 (we have these) | Pattern name, English explanation, Japanese explanation, 2-3 example sentences with translations |
| N4 | 40 (we have these) | Same |
| N3 | ~130 | Same |
| N2 | ~200 | Same |
| N1 | ~250 | Same |

**Research question:** Are there official JLPT grammar lists published by Japan Foundation/JLPT? If not, what are the most authoritative community-compiled lists? Are they copyright-free?

**Known sources to check:**
- JLPT official website (jlpt.jp) — do they publish 出題基準 (test content specifications)?
- JLPT Sensei (jlptsensei.com) — what's the license?
- Tanos JLPT grammar list
- Japanesetest4you grammar lists
- A Handbook of Japanese Grammar Patterns for Teachers and Learners (published book — any free excerpts?)
- Tae Kim's Guide (CC-BY-NC — can we license commercially?)

---

### 2. JLPT MOCK TESTS (75 questions needed: 25 per N3/N2/N1)

We need questions that match the REAL JLPT format exactly:

| Section | N3 | N2 | N1 |
|---------|-----|-----|-----|
| Vocabulary (文字・語彙) | ~6 questions | ~6 questions | ~6 questions |
| Grammar (文法) | ~7 questions | ~7 questions | ~7 questions |
| Reading (読解) | ~6 questions | ~6 questions | ~6 questions |
| Listening (聴解) | ~6 questions | ~6 questions | ~6 questions |

Each question needs: Japanese text, 4 multiple-choice options, correct answer, explanation in 8 languages.

**Research question:** Does jlpt.jp publish official sample questions? How many? Are past papers available? Any copyright-free mock test collections on GitHub?

**Known sources to check:**
- jlpt.jp/e/samples/ — official sample questions (how many per level?)
- GitHub: search "jlpt mock test json" or "jlpt practice questions"
- Amazon JP — are there public-domain JLPT prep books (pre-1950)?
- Archive.org — any scanned JLPT prep materials?

---

### 3. JLPT READING PASSAGES (12 needed: 4 per N3/N2/N1)

| Level | Passage Length | Topic Examples | Questions Per Passage |
|-------|---------------|----------------|----------------------|
| N3 | 200-400 chars | Daily life, announcements, emails | 3-4 |
| N2 | 400-700 chars | Essays, opinions, explanations | 3-4 |
| N1 | 700-1000 chars | Abstract arguments, editorials, literary excerpts | 3-4 |

**Research question:** Are there copyright-free Japanese texts appropriate for these levels? (Aozora Bunko — public domain Japanese literature? NHK Easy News? Government publications?)

**Known sources to check:**
- Aozora Bunko (aozora.gr.jp) — public domain Japanese literature. Can we excerpt?
- NHK News Web Easy — simplified news. License?
- Japanese government white papers — public domain?
- Tatoeba — any multi-sentence texts?
- Wikipedia Japanese — CC-BY-SA, can we adapt?

---

### 4. JLPT LISTENING COMPREHENSION AUDIO

**Research question:** Are there any copyright-free Japanese audio files with transcripts suitable for JLPT listening practice?

**Known sources to check:**
- Tatoeba audio (tatoeba.org/en/audio) — thousands of sentences, CC-BY
- Forvo (forvo.com) — word pronunciations, what license?
- LibriVox Japanese — public domain audiobooks
- NHK radio programs — any public domain?
- Japanese Pod 101 — free tier license?
- VoiceTra / other research datasets

---

### 5. TOPIK II CONTENT (Korean intermediate-advanced)

| Content Type | TOPIK I (we have) | TOPIK II (we NEED) |
|-------------|-------------------|---------------------|
| Vocabulary | 300 words | ~1,500 words |
| Grammar | 40 patterns | ~100 patterns |
| Mock test | 25 questions | 25 questions (different format — includes writing) |
| Reading passages | 4 passages | 4 longer passages |
| Writing prompts | N/A | 2-4 essay prompts with model answers |

**Research question:** Does topik.go.kr (official TOPIK site) publish past papers? Vocabulary lists? Are these government publications (public domain)?

**Known sources to check:**
- topik.go.kr — official past papers (기출문제). Government site = public domain?
- TOPIK Guide (topikguide.com) — vocabulary and grammar lists. License?
- Key to Korean TOPIK lists
- GitHub: search "topik vocabulary json" or "topik grammar"
- National Institute of Korean Language (korean.go.kr) — any free resources?

---

### 6. KOREAN LISTENING + WRITING

**Research question:** Free Korean audio with transcripts? TOPIK writing samples?

**Known sources to check:**
- Tatoeba Korean audio
- KBS Korean radio — any public domain programs?
- TOPIK official writing samples (topik.go.kr)
- Talk To Me In Korean (TTMIK) — free tier license?

---

## Specific Research Questions for GPT

For each source found, report:

1. **Exact URL** (not just domain — the specific page/file)
2. **License** (MIT, CC-BY, CC-BY-SA, CC-BY-NC, Public Domain, Government, Unknown)
3. **Commercial use OK?** (Yes/No/Check)
4. **Content count** (how many items?)
5. **Format** (JSON, CSV, HTML, PDF, audio files?)
6. **Last updated** (is it current for the 2024+ exam format?)
7. **Download method** (direct link? requires scraping? API?)

---

## What We Can Use (License Requirements)

| License | Use? |
|---------|------|
| MIT, Apache, BSD | ✅ Yes |
| CC-BY, CC-BY-SA | ✅ Yes (credit required) |
| Public Domain / CC0 | ✅ Yes |
| Government publication | ✅ Usually yes |
| CC-BY-NC | ❌ NO — reference only |
| Unknown / All Rights Reserved | ❌ NO |

---

## Priority Order

1. **JLPT official samples** (jlpt.jp) — highest authority, likely government
2. **TOPIK official past papers** (topik.go.kr) — government, likely free
3. **GitHub repos** — most likely to have structured JSON/CSV data
4. **Tatoeba** — sentences + audio, CC-BY, already using
5. **Aozora Bunko** — public domain Japanese texts
6. **Community grammar lists** — need license check

---

## Output Format

Return a structured table:

```markdown
| Source | URL | License | Commercial? | Items | Format | Status |
|--------|-----|---------|-------------|-------|--------|--------|
| JLPT N3 sample questions | jlpt.jp/e/samples/n3.html | Government | Yes | 15 questions | HTML | ACCESSIBLE |
| ... | ... | ... | ... | ... | ... | ... |
```

And a summary of what we CAN use immediately vs what needs licensing vs what's unavailable.

---

*Send this prompt to GPT-4 or Claude with web search enabled. Return the full research report.*
