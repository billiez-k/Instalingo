# Font Research Prompt — InstaLingo Language Learning App

## Context

InstaLingo is a Flutter-based language learning app supporting 8 interface languages (English, 中文简体, 中文繁體, 日本語, 한국어, Español, Français, Deutsch) and 7 learning courses (English, Korean, Japanese, French, Spanish, Chinese, German). The app currently uses a single default system font across all languages. We need to find the optimal font strategy — potentially multiple fonts — that feels native and professional in each target market.

## The Problem

A one-font-fits-all approach doesn't work for a multilingual app:

1. **CJK users** (Chinese, Japanese, Korean) expect fonts that match their native OS typography — what they see in KakaoTalk, LINE, WeChat, Naver, etc.
2. **Latin-script users** (English, Spanish, French, German) expect different font personalities depending on region.
3. **Language learning content** mixes scripts — a Japanese learner sees 日本語 + romaji + English explanations in the same screen. The font must handle mixed-script rendering beautifully.
4. **Brand personality** of language learning apps differs by market — Duolingo's playful rounded feel vs Busuu's clean European aesthetic vs 多邻国's different Chinese typography vs LingoDeer's Asian-market polish.

## Research Goals

### 1. Per-Market Font Analysis

For **each of the 8 target markets**, research and report:

| Market | Research Focus |
|--------|---------------|
| **Taiwan (zh_TW)** | What fonts do top Taiwanese apps use? (LINE Taiwan, 多鄰國, 希平方, VoiceTube, Jella!, any popular education apps). Source Han Sans TC? Noto Sans TC? Any uniquely Taiwanese preferences? |
| **China (zh_CN)** | What fonts do top Chinese apps use? (微信, 多邻国, 百词斩, 扇贝, 得到, 知乎, any ed-tech apps). PingFang SC? Source Han Sans SC? Any unique preferences? |
| **Japan** | What fonts do top Japanese apps use? (LINE Japan, Duolingo JP, スタディサプリ, ドラゴン桜, SmartNews, any education apps). Hiragino? Noto Sans JP? Yu Gothic? What about mixed kana/kanji rendering? |
| **Korea** | What fonts do top Korean apps use? (KakaoTalk, Naver, Duolingo KR, Cake, 말해보카, Riiid). Apple SD Gothic Neo? Noto Sans KR? Any specific preferences for hangul rendering? |
| **Spain** | What fonts do Spanish education apps use? (Duolingo ES, Busuu, Babbel, Wlingua). Do they prefer modern geometric or traditional serif? |
| **France** | What fonts do French apps use? (Duolingo FR, Gymglish, Frantastique, Le Monde). French typography has a distinct tradition — do apps follow it? |
| **Germany** | What fonts do German apps use? (Duolingo DE, Babbel, DW Learn German, Der Spiegel). German design tends clean and functional — does font choice reflect this? |
| **USA/Global** | What fonts do mainstream language apps use? (Duolingo, Babbel, Busuu, Memrise, Rosetta Stone, Drops, Mondly). Analyze their font stacks. |

### 2. Competitor Font Stack Analysis

For **each of these language learning apps**, extract their actual font stacks from web/app source code or design documentation:

- **Duolingo** (global + per-market variants)
- **Babbel** (European-market focused)
- **Busuu** (European-market focused)
- **LingoDeer** (Asian-language focused — Japanese, Korean, Chinese)
- **Drops** / **Scripts** (writing-system focused — Hangul, Kana, Hanzi)
- **Memrise** (global)
- **Cake** (Korean-market English learning)
- **HelloTalk** / **Tandem** (language exchange)
- **Anki** / **Quizlet** (flashcard apps with CJK support)

For each, report:
- Exact font-family CSS or Flutter font stack
- Fallback chain order
- Whether they use different fonts per language
- Any custom font files bundled with the app

### 3. CJK Font Deep Dive

CJK fonts are the hardest problem. Research:

- **Google Noto Sans CJK** (unified Pan-CJK vs region-specific variants: SC/TC/JP/KR)
- **Source Han Sans / 思源黑体 / 源ノ角ゴシック / 본고딕** (Adobe+Google joint, same font with regional glyph variants)
- **PingFang** (Apple system — SC vs TC variants)
- **Hiragino Sans** (Apple system Japan)
- **Apple SD Gothic Neo** (Apple system Korea)
- **Microsoft YaHei / JhengHei** (Windows)
- **Malgun Gothic** (Windows Korea)
- **Meiryo / Yu Gothic** (Windows Japan)

Key question: **Is it better to use one Pan-CJK font (Noto unified) or region-specific fonts (Noto SC for zh_CN, Noto TC for zh_TW, Noto JP for ja, Noto KR for ko)?**

Trade-offs:
- Unified: smaller app bundle, consistent design, but glyphs may look "foreign" to native readers
- Regional: native feel per market, but larger bundle, more complex font loading logic

### 4. Mixed-Script Rendering

Language learning apps display mixed scripts constantly. A Korean learner sees:
```
안녕하세요 (annyeonghaseyo) means "hello"
```
This one line contains Hangul, Latin, and punctuation. The font must:
- Render Hangul with proper spacing/kerning
- NOT make Latin characters look out of place
- Handle the CJK fullwidth/halfwidth character width dance

Test approach: Find fonts where **Latin glyphs are designed to pair with their CJK counterparts** (i.e., the font family includes both Latin and CJK glyphs designed together, rather than two separate fonts mashed together).

### 5. Flutter-Specific Considerations

Since we use Flutter:
- **Font weight availability** — Flutter needs explicit `FontWeight.w100` through `w900` files. Not all CJK fonts have all weights.
- **Font file size** — CJK fonts are huge (10-20 MB per weight). Subsetting or Google Fonts CDN loading strategy?
- **`fontFamilyFallback`** — Flutter's fallback chain. What's the optimal order?
- **`google_fonts` package** vs bundled `.ttf` files vs CDN loading
- **Current fallback chain in our app:**
```
Noto Sans SC → Noto Sans TC → Noto Sans JP → Noto Sans KR →
PingFang TC → PingFang SC → Hiragino Sans → Apple SD Gothic Neo →
Malgun Gothic → Microsoft YaHei → Microsoft JhengHei → Meiryo → sans-serif
```

### 6. Deliverables Needed

From your research, provide:

1. **Recommended Font Strategy** — one font or multiple? If multiple, which font for which language/market?

2. **Top 3-5 Font Candidates** with:
   - Font name and foundry
   - License (open source vs paid — we prefer open source)
   - Which languages it covers
   - Available weights
   - Approximate file size per weight
   - Why it's the right choice for a language learning app
   - Screenshot comparisons (if possible)

3. **Optimal Font Stack** — the exact `fontFamily` and `fontFamilyFallback` configuration for Flutter, with priority order.

4. **Bundle Size Comparison** — if we bundle fonts vs use CDN vs use system fonts only. Trade-offs for each approach.

## Constraints

- **Open source preferred** (SIL OFL or similar) to avoid licensing issues
- Must cover the target languages' character sets completely (no ☒ tofu)
- Reasonable bundle size for mobile (target: <5 MB total for fonts)
- Must look native and professional in each market
- Should work on iOS, Android, Web, and desktop
- Flutter-compatible (.ttf or .otf)

## Tone

Be thorough and evidence-based. Cite actual apps, actual font stacks, actual source code. Screenshots and side-by-side comparisons are very welcome. Don't just name fonts — show why they're the right choice with visual comparisons and real app examples.

If you find that major apps in different markets use COMPLETELY DIFFERENT font strategies (e.g., Japanese apps use Hiragino exclusively while Korean apps bundle custom fonts), say so — we need market-specific truth, not a one-size-fits-all answer.
