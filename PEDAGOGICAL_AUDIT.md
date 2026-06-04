# InstaLingo — Pedagogical Stupidity Audit (Korean A1)

**Date:** 2026-05-27  
**Audited:** Full Korean A1 course (28 lessons, 336 exercises)  
**Found:** 150 pedagogical issues

---

## ISSUE 1: Wrong Topic — "Greetings" section teaches forsythia flowers 🔴

**Section 1 title:** "Greetings & Introductions"

| Lesson | First 3 words taught | What a learner expects |
|--------|---------------------|----------------------|
| L1 | 개나리 (forsythia), 간 (while), 것 (thing) | 안녕하세요 (hello), 감사합니다 (thank you) |
| L2 | 그동안 (meanwhile), 걸다 (to hang), 감사하다 | 이름 (name), 만나다 (to meet) |
| L3 | 괜찮습니다 (it's ok), 결과 (result), 경험 (experience) | 반갑습니다 (nice to meet you) |
| L4 | 국립 (national), 기간 (period), 간단하다 (simple) | 저는 (I am) |
| L5 | 건너편 (opposite side), 과자 (snacks), 간단히 (briefly) | 어디 (where), 나라 (country) |

**Root cause:** Topic inference fails → words sorted alphabetically by first Korean character → random words dumped into sections.

---

## ISSUE 2: Dead Vocabulary — Words Listed But Never Taught 🔴

53 words in Korean course appear in `vocabulary` list but ZERO exercises use them:

```
L1: 국적 (nationality), 금방 (soon)
L2: 고마웠습니다 (thank you-past), 고맙다 (to be thankful)
L3: 결과 (result), 경험 (experience)
L4: 경찰 (police), 그러나 (but)
L5: 관계 (relationship), 그거 (that thing)
L6: 골목 (alley), 감자 (potato)
L7: 기뻐하다 (to be happy), 갈비 (ribs)
...and 39 more
```

A learner sees these words in the lesson overview but NEVER encounters them in any exercise.

---

## ISSUE 3: No-Op Exercises — Question = Answer 🔴

28 vocabularyMultipleChoice exercises where `question == correctAnswer`:

```
ex_ko_l01_01_02: Q="개나리"  A="개나리"  — student just taps the same word
ex_ko_l02_01_02: Q="그동안"  A="그동안"
ex_ko_l03_01_02: Q="괜찮습니다"  A="괜찮습니다"
```

The student sees the Korean word, and the correct answer is... the same Korean word. Zero learning. The question should be the Chinese meaning (e.g., Q="连翘", A="개나리") or the English meaning.

---

## ISSUE 4: English fillInBlank in Korean Course 🔴

28 fillInBlank exercises use English template sentence:

```
Q: "I learn the word ___."
Options: ["개나리", "간", "것", "고등학교"]
```

A Korean learner sees an English sentence with Korean words inserted. Should be: "저는 ___을/를 배웁니다" or a real Korean sentence.

---

## ISSUE 5: Lesson Titles Are Random Words 🔴

28 lessons have titles that are just the first vocabulary word:

```
L1: "개나리" (forsythia) — should be "Basic Greetings"
L2: "그동안" (meanwhile) — should be "Introducing Yourself"
L3: "괜찮습니다" (it's ok) — should be "Asking How Are You"
```

---

## ISSUE 6: Non-A1 Vocabulary in Beginner Course 🟡

10 words above A1 level:
- 고등학교 (high school), 고등학생 (high school student) — not A1
- 국적 (nationality), 경찰 (police), 기간 (period) — A2+
- 교통사고 (traffic accident) — B1

---

## ISSUE 7: vocabularyMultipleChoice wrong direction 🟡

When a Chinese user learns Korean, the question should be the Chinese meaning (user's native language) and the options should be Korean words (target language):

**Current (backward):**
```
Q: 개나리  Options: [개나리, 간, 것, 고등학교]
→ Student sees Korean, picks Korean. No translation learning.
```

**Should be:**
```
Q: 连翘  Options: [개나리, 간, 것, 고등학교]  
→ Student sees Chinese meaning, picks Korean word. Translation learning.
```

---

## FIXES REQUIRED

| # | Fix | Effort |
|---|-----|--------|
| 1 | Manual vocabulary curation per language — pick 320 real A1 words in teaching order | 4h per language |
| 2 | vocabMC: question=Chinese meaning, options=Korean words | 30min in generator |
| 3 | fillInBlank: generate Korean sentences, not English templates | 2h |
| 4 | Lesson titles: write real titles per lesson | 1h |
| 5 | Remove dead vocab from lessons | 30min |
| 6 | Filter non-A1 words | Already done (cefr_level filter) — but CSVs have wrong CEFR tags |

**The fundamental problem:** The vocabulary CSVs cannot be blindly fed into a course generator. A1 courses need CURATED vocabulary in pedagogical order. The current approach of "sort by first character + keyword matching" produces garbage lesson sequences.

---

*Generated: 2026-05-27*
