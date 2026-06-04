# InstaLingo — Content Acquisition Guide v2

> **Purpose:** Hand this entire file to Manus AI (or any autonomous AI agent) to:
> 1. Web-search and download ALL teaching materials (vocab lists, sentence pairs, grammar data, audio, images)
> 2. Process them into our exact JSON format
> 3. Generate ALL 8-language translations for every string
> 4. Output files ready for direct integration into InstaLingo

**Date:** 2026-05-27
**InstaLingo Version:** Post-multi-language-refactor (56 language pairs, 16 exercise types)

---

## 0. CRITICAL: Output Format Requirements (READ FIRST)

### 0.1 Every User-Visible String = 8 Languages

```json
"title": {
  "en": "English A1",
  "zh": "英语A1",
  "zh_TW": "英語A1",
  "ko": "영어 A1",
  "ja": "英語A1",
  "es": "Inglés A1",
  "fr": "Anglais A1",
  "de": "Englisch A1"
}
```

**Rule:** ALL 8 languages MUST be present. Missing entries = fallback to English = BUG.
**Rule:** `zh_TW` (Traditional Chinese) is INDEPENDENT from `zh` (Simplified). Duplicate if identical — never omit.
**Rule:** Entire file is valid JSON. No Dart code. No trailing commas in JSON. UTF-8 encoding.

### 0.2 File Output Structure

Output ONE file per course per language. Create this exact directory structure:

```
instalingo_content/
├── courses/
│   ├── en_a1.json          # English A1 course
│   ├── ko_a1.json          # Korean A1 course
│   ├── ja_a1.json          # Japanese A1 course
│   ├── fr_a1.json          # French A1 course
│   ├── es_a1.json          # Spanish A1 course
│   ├── zh_a1.json          # Chinese A1 course
│   └── de_a1.json          # German A1 course
├── posts/
│   ├── en_posts.json
│   ├── ko_posts.json
│   ├── ja_posts.json
│   ├── fr_posts.json
│   ├── es_posts.json
│   ├── zh_posts.json
│   └── de_posts.json
├── vocabulary/
│   ├── en_vocab.json
│   ├── ko_vocab.json
│   ├── ja_vocab.json
│   ├── fr_vocab.json
│   ├── es_vocab.json
│   ├── zh_vocab.json
│   └── de_vocab.json
└── grammar/
    ├── en_grammar.json
    ├── ko_grammar.json
    ├── ja_grammar.json
    ├── fr_grammar.json
    ├── es_grammar.json
    ├── zh_grammar.json
    └── de_grammar.json
```

---

## 1. Exact Course JSON Schema

### 1.1 Full Schema

```json
{
  "id": "en_a1",
  "level": "A1",
  "language": "en",
  "totalLessons": 50,
  "title": {
    "en": "English A1", "zh": "英语A1", "zh_TW": "英語A1",
    "ko": "영어 A1", "ja": "英語A1", "es": "Inglés A1",
    "fr": "Anglais A1", "de": "Englisch A1"
  },
  "subtitle": {
    "en": "Beginner English", "zh": "初级英语", "zh_TW": "初級英語",
    "ko": "초급 영어", "ja": "初級英語", "es": "Inglés principiante",
    "fr": "Anglais débutant", "de": "Englisch für Anfänger"
  },
  "description": {
    "en": "Master the basics of English. Learn everyday vocabulary, simple grammar, and essential phrases.",
    "zh": "掌握英语基础。学习日常词汇、简单语法和基本短语。",
    "zh_TW": "掌握英語基礎。學習日常詞彙、簡單語法和基本短語。",
    "ko": "영어의 기초를 마스터하세요. 일상 어휘, 간단한 문법, 필수 표현을 배웁니다.",
    "ja": "英語の基礎をマスターしましょう。日常語彙、簡単な文法、必須フレーズを学びます。",
    "es": "Domina los fundamentos del inglés. Aprende vocabulario cotidiano, gramática simple y frases esenciales.",
    "fr": "Maîtrisez les bases de l'anglais. Apprenez le vocabulaire quotidien, la grammaire simple et les phrases essentielles.",
    "de": "Meistern Sie die Grundlagen des Englischen. Lernen Sie Alltagsvokabular, einfache Grammatik und wichtige Redewendungen."
  },
  "sections": [
    {
      "id": "en_sec_1",
      "order": 1,
      "title": {
        "en": "Greetings & Introductions", "zh": "问候与自我介绍", "zh_TW": "問候與自我介紹",
        "ko": "인사와 자기소개", "ja": "挨拶と自己紹介", "es": "Saludos y presentaciones",
        "fr": "Salutations et présentations", "de": "Begrüßungen und Vorstellungen"
      },
      "lessons": [
        {
          "id": "en_l1",
          "order": 1,
          "xpReward": 10,
          "gemsReward": 5,
          "title": {
            "en": "Hello!", "zh": "你好！", "zh_TW": "你好！",
            "ko": "안녕하세요!", "ja": "こんにちは！", "es": "¡Hola!",
            "fr": "Bonjour !", "de": "Hallo!"
          },
          "description": {
            "en": "Learn how to greet people in English.",
            "zh": "学习如何用英语问候他人。",
            "zh_TW": "學習如何用英語問候他人。",
            "ko": "영어로 인사하는 법을 배웁니다.",
            "ja": "英語で挨拶する方法を学びます。",
            "es": "Aprende a saludar en inglés.",
            "fr": "Apprenez à saluer en anglais.",
            "de": "Lernen Sie, wie man auf Englisch grüßt."
          },
          "vocabulary": ["hello", "hi", "goodbye", "good morning", "good night"],
          "exercises": []
        }
      ]
    }
  ]
}
```

### 1.2 Exercise Type Values (exact strings, case-sensitive)

```
vocabularyMultipleChoice
fillInBlank
translateSentence
matchPairs
listenAndType
speaking
dialogueComplete
grammarTip
wordSorting
imageIdentification
flashCard
comprehensionText
grammarTrueFalse
phraseBuilderPrefilled
writing
```

### 1.3 Exercise Schemas — One Per Type

Every exercise has these common fields:
```json
{
  "id": "string — unique exercise ID",
  "type": "string — one of the 16 ExerciseType values above",
  "contentLang": "string — ISO 639-1 code of the LEARNING content language (e.g., 'en', 'ko')",
  "question": "string — the target-language content being tested",
  "instruction": {
    "en": "string — what the user should do, in their native language",
    "zh": "...", "zh_TW": "...", "ko": "...", "ja": "...",
    "es": "...", "fr": "...", "de": "..."
  }
}
```

#### vocabularyMultipleChoice
```json
{
  "id": "ex_en_1",
  "type": "vocabularyMultipleChoice",
  "contentLang": "en",
  "question": "Hello",
  "instruction": { "en": "Tap the correct meaning.", "zh": "点击正确的含义。", "zh_TW": "點擊正確的含義。", "ko": "올바른 의미를 탭하세요.", "ja": "正しい意味をタップしてください。", "es": "Toca el significado correcto.", "fr": "Appuyez sur la bonne signification.", "de": "Tippen Sie auf die richtige Bedeutung." },
  "options": ["Goodbye", "Hello", "Thank you", "Please"],
  "correctAnswer": "Hello",
  "explanation": {
    "en": "'Hello' is the most common English greeting.",
    "zh": "'Hello' 是最常见的英语问候语。",
    "zh_TW": "'Hello' 是最常見的英語問候語。",
    "ko": "'Hello'는 가장 흔한 영어 인사말입니다.",
    "ja": "'Hello'は最も一般的な英語の挨拶です。",
    "es": "'Hello' es el saludo más común en inglés.",
    "fr": "'Hello' est la salutation anglaise la plus courante.",
    "de": "'Hello' ist die häufigste englische Begrüßung."
  }
}
```

#### fillInBlank
```json
{
  "id": "ex_en_2",
  "type": "fillInBlank",
  "contentLang": "en",
  "question": "____ are you? — I'm fine, thank you.",
  "instruction": { "en": "Fill in the blank.", "zh": "填空。", "zh_TW": "填空。", "ko": "빈칸을 채우세요.", "ja": "空欄を埋めてください。", "es": "Rellena el espacio en blanco.", "fr": "Remplissez le blanc.", "de": "Füllen Sie die Lücke aus." },
  "wordBank": ["How", "What", "Where", "Who"],
  "correctAnswer": "How",
  "options": ["How", "What", "Where", "Who"],
  "explanation": {
    "en": "'How are you?' is the standard way to ask about someone's wellbeing.",
    "zh": "'How are you?' 是询问某人近况的标准方式。",
    "zh_TW": "'How are you?' 是詢問某人近況的標準方式。",
    "ko": "'How are you?'는 상대방의 안부를 묻는 표준적인 방법입니다.",
    "ja": "'How are you?'は相手の様子を尋ねる標準的な方法です。",
    "es": "'How are you?' es la forma estándar de preguntar por el bienestar de alguien.",
    "fr": "'How are you?' est la façon standard de demander comment va quelqu'un.",
    "de": "'How are you?' ist die übliche Art, nach dem Wohlbefinden zu fragen."
  }
}
```

#### translateSentence
```json
{
  "id": "ex_en_3",
  "type": "translateSentence",
  "contentLang": "en",
  "question": "How are you?",
  "instruction": { "en": "Choose the correct translation.", "zh": "选择正确的翻译。", "zh_TW": "選擇正確的翻譯。", "ko": "올바른 번역을 고르세요.", "ja": "正しい翻訳を選んでください。", "es": "Elige la traducción correcta.", "fr": "Choisissez la bonne traduction.", "de": "Wählen Sie die richtige Übersetzung." },
  "options": ["你好吗？", "你叫什么？", "你多大？", "你在哪？"],
  "correctAnswer": "你好吗？",
  "explanation": {
    "en": "'How are you?' means '你好吗？' in Chinese.",
    "zh": "'How are you?' 在中文里意思是'你好吗？'。",
    "zh_TW": "'How are you?' 在中文裡意思是'你好嗎？'。",
    "ko": "'How are you?'는 중국어로 '你好吗？'를 의미합니다.",
    "ja": "'How are you?'は中国語で'你好吗？'を意味します。",
    "es": "'How are you?' significa '你好吗？' en chino.",
    "fr": "'How are you?' signifie '你好吗？' en chinois.",
    "de": "'How are you?' bedeutet auf Chinesisch '你好吗？'."
  }
}
```

#### matchPairs
```json
{
  "id": "ex_en_4",
  "type": "matchPairs",
  "contentLang": "en",
  "question": "",
  "instruction": { "en": "Match the words with their translations.", "zh": "将单词与翻译配对。", "zh_TW": "將單詞與翻譯配對。", "ko": "단어와 번역을 연결하세요.", "ja": "単語と翻訳を一致させてください。", "es": "Empareja las palabras con sus traducciones.", "fr": "Associez les mots à leurs traductions.", "de": "Ordnen Sie die Wörter ihren Übersetzungen zu." },
  "pairs": [
    { "left": "Hello", "right": "你好" },
    { "left": "Goodbye", "right": "再见" },
    { "left": "Thank you", "right": "谢谢" },
    { "left": "Please", "right": "请" }
  ]
}
```

#### listenAndType
```json
{
  "id": "ex_en_5",
  "type": "listenAndType",
  "contentLang": "en",
  "question": "",
  "instruction": { "en": "Listen and type what you hear.", "zh": "听录音并输入你听到的内容。", "zh_TW": "聽錄音並輸入你聽到的內容。", "ko": "듣고 들은 내용을 입력하세요.", "ja": "聞こえた内容を入力してください。", "es": "Escucha y escribe lo que oyes.", "fr": "Écoutez et tapez ce que vous entendez.", "de": "Hören Sie zu und tippen Sie, was Sie hören." },
  "audioUrl": "https://cdn.example.com/audio/en/hello.mp3",
  "correctAnswer": "Hello",
  "explanation": { "en": "The speaker said 'Hello'.", "zh": "说话者说的是'Hello'。", "zh_TW": "說話者說的是'Hello'。", "ko": "화자가 'Hello'라고 말했습니다.", "ja": "話者は'Hello'と言いました。", "es": "El hablante dijo 'Hello'.", "fr": "Le locuteur a dit 'Hello'.", "de": "Der Sprecher sagte 'Hello'." }
}
```

#### speaking
```json
{
  "id": "ex_en_6",
  "type": "speaking",
  "contentLang": "en",
  "question": "Hello, how are you?",
  "instruction": { "en": "Say the phrase out loud.", "zh": "大声说出这个短语。", "zh_TW": "大聲說出這個短語。", "ko": "이 문구를 큰 소리로 말하세요.", "ja": "このフレーズを声に出して言ってください。", "es": "Di la frase en voz alta.", "fr": "Dites la phrase à voix haute.", "de": "Sagen Sie den Satz laut." }
}
```

#### dialogueComplete
```json
{
  "id": "ex_en_7",
  "type": "dialogueComplete",
  "contentLang": "en",
  "question": "",
  "instruction": { "en": "Complete the dialogue.", "zh": "完成对话。", "zh_TW": "完成對話。", "ko": "대화를 완성하세요.", "ja": "会話を完成させてください。", "es": "Completa el diálogo.", "fr": "Complétez le dialogue.", "de": "Vervollständigen Sie den Dialog." },
  "dialogue": [
    { "speaker": "A", "text": "Hello! How are you?", "isUser": false },
    { "speaker": "B", "text": "___", "isUser": true }
  ],
  "options": ["I'm fine, thank you!", "My name is John.", "I'm from China.", "See you later!"],
  "correctAnswer": "I'm fine, thank you!",
  "explanation": { "en": "'I'm fine, thank you!' is the standard response to 'How are you?'", "zh": "'I'm fine, thank you!' 是对'How are you?'的标准回答。", "zh_TW": "'I'm fine, thank you!' 是對'How are you?'的標準回答。", "ko": "'I'm fine, thank you!'는 'How are you?'에 대한 표준 응답입니다.", "ja": "'I'm fine, thank you!'は'How are you?'への標準的な返答です。", "es": "'I'm fine, thank you!' es la respuesta estándar a 'How are you?'", "fr": "'I'm fine, thank you!' est la réponse standard à 'How are you?'", "de": "'I'm fine, thank you!' ist die übliche Antwort auf 'How are you?'" }
}
```

#### grammarTip
```json
{
  "id": "ex_en_8",
  "type": "grammarTip",
  "contentLang": "en",
  "question": "",
  "instruction": { "en": "Grammar note", "zh": "语法提示", "zh_TW": "語法提示", "ko": "문법 노트", "ja": "文法ノート", "es": "Nota gramatical", "fr": "Note de grammaire", "de": "Grammatik-Hinweis" },
  "grammarRule": {
    "en": "English sentences start with a capital letter and end with a period (.), question mark (?), or exclamation mark (!).",
    "zh": "英语句子以大写字母开头，以句号(.)、问号(?)或感叹号(!)结尾。",
    "zh_TW": "英語句子以大寫字母開頭，以句號(.)、問號(?)或感嘆號(!)結尾。",
    "ko": "영어 문장은 대문자로 시작하고 마침표(.), 물음표(?), 느낌표(!)로 끝납니다.",
    "ja": "英語の文は大文字で始まり、ピリオド(.)、疑問符(?)、または感嘆符(!)で終わります。",
    "es": "Las oraciones en inglés comienzan con mayúscula y terminan con punto (.), signo de interrogación (?) o exclamación (!).",
    "fr": "Les phrases anglaises commencent par une majuscule et se terminent par un point (.), un point d'interrogation (?) ou d'exclamation (!).",
    "de": "Englische Sätze beginnen mit einem Großbuchstaben und enden mit einem Punkt (.), Fragezeichen (?) oder Ausrufezeichen (!)."
  },
  "grammarExample": {
    "en": "Hello. -> Correct  |  hello -> Incorrect (needs capital H)",
    "zh": "Hello. -> 正确  |  hello -> 错误（需要大写的H）",
    "zh_TW": "Hello. -> 正確  |  hello -> 錯誤（需要大寫的H）",
    "ko": "Hello. -> 맞음  |  hello -> 틀림 (대문자 H 필요)",
    "ja": "Hello. -> 正解  |  hello -> 不正解（大文字のHが必要）",
    "es": "Hello. -> Correcto  |  hello -> Incorrecto (necesita H mayúscula)",
    "fr": "Hello. -> Correct  |  hello -> Incorrect (nécessite un H majuscule)",
    "de": "Hello. -> Richtig  |  hello -> Falsch (benötigt großes H)"
  }
}
```

#### wordSorting
```json
{
  "id": "ex_en_9",
  "type": "wordSorting",
  "contentLang": "en",
  "question": "",
  "instruction": { "en": "Arrange the words into a correct sentence.", "zh": "将单词排列成正确的句子。", "zh_TW": "將單詞排列成正確的句子。", "ko": "단어를 올바른 문장으로 배열하세요.", "ja": "単語を正しい文に並べ替えてください。", "es": "Ordena las palabras en una oración correcta.", "fr": "Remettez les mots dans l'ordre pour former une phrase correcte.", "de": "Ordnen Sie die Wörter zu einem korrekten Satz." },
  "options": ["am", "I", "student", "a"],
  "correctAnswerList": ["I", "am", "a", "student"],
  "explanation": { "en": "'I am a student' is the correct word order.", "zh": "'I am a student' 是正确的词序。", "zh_TW": "'I am a student' 是正確的詞序。", "ko": "'I am a student'가 올바른 어순입니다.", "ja": "'I am a student'が正しい語順です。", "es": "'I am a student' es el orden correcto de las palabras.", "fr": "'I am a student' est l'ordre correct des mots.", "de": "'I am a student' ist die richtige Wortstellung." }
}
```

#### imageIdentification
```json
{
  "id": "ex_en_10",
  "type": "imageIdentification",
  "contentLang": "en",
  "question": "apple",
  "instruction": { "en": "Tap the correct image.", "zh": "点击正确的图片。", "zh_TW": "點擊正確的圖片。", "ko": "올바른 이미지를 탭하세요.", "ja": "正しい画像をタップしてください。", "es": "Toca la imagen correcta.", "fr": "Appuyez sur la bonne image.", "de": "Tippen Sie auf das richtige Bild." },
  "options": ["apple", "banana", "orange", "grape"],
  "correctAnswer": "apple",
  "imageUrl": "https://cdn.example.com/img/en/apple.jpg"
}
```

#### flashCard
```json
{
  "id": "ex_en_11",
  "type": "flashCard",
  "contentLang": "en",
  "question": "Hello",
  "instruction": { "en": "Flip the card to see the translation.", "zh": "翻转卡片查看翻译。", "zh_TW": "翻轉卡片查看翻譯。", "ko": "카드를 뒤집어 번역을 보세요.", "ja": "カードを裏返して翻訳を見てください。", "es": "Voltea la tarjeta para ver la traducción.", "fr": "Retournez la carte pour voir la traduction.", "de": "Drehen Sie die Karte um, um die Übersetzung zu sehen." },
  "correctAnswer": "你好",
  "explanation": {
    "en": "'Hello' (həˈloʊ) — used as a greeting.",
    "zh": "'Hello' (həˈloʊ) — 用作问候语。",
    "zh_TW": "'Hello' (həˈloʊ) — 用作問候語。",
    "ko": "'Hello' (həˈloʊ) — 인사말로 사용됩니다.",
    "ja": "'Hello' (həˈloʊ) — 挨拶として使用されます。",
    "es": "'Hello' (həˈloʊ) — se usa como saludo.",
    "fr": "'Hello' (həˈloʊ) — utilisé comme salutation.",
    "de": "'Hello' (həˈloʊ) — wird als Begrüßung verwendet."
  }
}
```

#### comprehensionText
```json
{
  "id": "ex_en_12",
  "type": "comprehensionText",
  "contentLang": "en",
  "question": "",
  "instruction": { "en": "Read the passage and answer the questions.", "zh": "阅读文章并回答问题。", "zh_TW": "閱讀文章並回答問題。", "ko": "글을 읽고 질문에 답하세요.", "ja": "文章を読んで質問に答えてください。", "es": "Lee el texto y responde las preguntas.", "fr": "Lisez le passage et répondez aux questions.", "de": "Lesen Sie den Text und beantworten Sie die Fragen." },
  "passage": "John is a student. He lives in London. Every morning, he walks to school.",
  "questions": [
    {
      "question": "Where does John live?",
      "options": ["London", "Paris", "Tokyo", "Seoul"],
      "correctAnswer": "London"
    }
  ]
}
```

#### grammarTrueFalse
```json
{
  "id": "ex_en_13",
  "type": "grammarTrueFalse",
  "contentLang": "en",
  "question": "'He go to school' is correct English grammar.",
  "instruction": { "en": "Is this statement true or false?", "zh": "这个说法是对还是错？", "zh_TW": "這個說法是對還是錯？", "ko": "이 문장이 맞습니까, 틀립니까?", "ja": "この文は正しいですか、間違いですか？", "es": "¿Es verdadera o falsa esta afirmación?", "fr": "Cette affirmation est-elle vraie ou fausse ?", "de": "Ist diese Aussage wahr oder falsch?" },
  "isTrue": false,
  "explanation": {
    "en": "Incorrect. The correct form is 'He goes to school' because third-person singular requires 'goes'.",
    "zh": "错误。正确形式是'He goes to school'，因为第三人称单数需要用'goes'。",
    "zh_TW": "錯誤。正確形式是'He goes to school'，因為第三人稱單數需要用'goes'。",
    "ko": "틀렸습니다. 올바른 형태는 'He goes to school'입니다. 3인칭 단수는 'goes'를 사용합니다.",
    "ja": "間違いです。正しい形は'He goes to school'です。三人称単数には'goes'が必要です。",
    "es": "Incorrecto. La forma correcta es 'He goes to school' porque la tercera persona singular requiere 'goes'.",
    "fr": "Incorrect. La forme correcte est 'He goes to school' car la troisième personne du singulier nécessite 'goes'.",
    "de": "Falsch. Die korrekte Form ist 'He goes to school', da die dritte Person Singular 'goes' erfordert."
  }
}
```

#### phraseBuilderPrefilled
```json
{
  "id": "ex_en_14",
  "type": "phraseBuilderPrefilled",
  "contentLang": "en",
  "question": "",
  "instruction": { "en": "Build the correct phrase.", "zh": "构建正确的短语。", "zh_TW": "構建正確的短語。", "ko": "올바른 구문을 만드세요.", "ja": "正しいフレーズを作ってください。", "es": "Construye la frase correcta.", "fr": "Construisez la phrase correcte.", "de": "Bilden Sie die richtige Phrase." },
  "options": ["I", "would", "like", "a", "coffee", "please"],
  "correctAnswerList": ["I", "would", "like", "a", "coffee", "please"]
}
```

#### writing
```json
{
  "id": "ex_en_15",
  "type": "writing",
  "contentLang": "en",
  "question": "",
  "writingPrompt": {
    "en": "Introduce yourself in English. Write at least 3 sentences.",
    "zh": "用英语介绍自己。至少写3句话。",
    "zh_TW": "用英語介紹自己。至少寫3句話。",
    "ko": "영어로 자신을 소개하세요. 최소 3문장을 작성하세요.",
    "ja": "英語で自己紹介をしてください。最低3文書いてください。",
    "es": "Preséntate en inglés. Escribe al menos 3 oraciones.",
    "fr": "Présentez-vous en anglais. Écrivez au moins 3 phrases.",
    "de": "Stellen Sie sich auf Englisch vor. Schreiben Sie mindestens 3 Sätze."
  },
  "sampleAnswer": {
    "en": "Hello! My name is Maria. I am from Spain. I like learning languages.",
    "zh": "你好！我叫Maria。我来自西班牙。我喜欢学习语言。",
    "zh_TW": "你好！我叫Maria。我來自西班牙。我喜歡學習語言。",
    "ko": "안녕하세요! 제 이름은 Maria입니다. 저는 스페인에서 왔습니다. 저는 언어 배우는 것을 좋아합니다.",
    "ja": "こんにちは！私の名前はMariaです。スペイン出身です。言語を学ぶのが好きです。",
    "es": "¡Hola! Me llamo Maria. Soy de España. Me gusta aprender idiomas.",
    "fr": "Bonjour ! Je m'appelle Maria. Je viens d'Espagne. J'aime apprendre les langues.",
    "de": "Hallo! Mein Name ist Maria. Ich komme aus Spanien. Ich lerne gerne Sprachen."
  }
}
```

---

## 2. What to Web Search — Exact Search Queries

### 2.1 English (Learning Language: en)

| # | Search Query | Why | Expected Output |
|---|-------------|-----|-----------------|
| 1 | `"Oxford 3000" wordlist PDF download CEFR` | A1/A2/B1 tagged words | CSV/JSON of ~3000 words |
| 2 | `Tatoeba sentences.csv download` | English sentences with translations | CSV: id, lang, text |
| 3 | `English grammar A1 topics list beginner order` | Grammar teaching sequence | List of 50+ grammar points |
| 4 | `site:lottiefiles.com "celebration" OR "success" OR "star" free animation` | Lottie animations | Free Lottie JSON URLs |
| 5 | `"English A1" example sentences for beginners simple` | Example sentences (< 8 words) | Sentence list grouped by topic |
| 6 | `Common English phrases beginners greetings introductions` | Dialogue/phrase content | Phrases grouped by situation |

### 2.2 Korean (Learning Language: ko)

| # | Search Query | Why | Expected Output |
|---|-------------|-----|-----------------|
| 1 | `"TOPIK I vocabulary list" PDF download` | ~1500 A1-A2 Korean words | Word, romanization, English meaning |
| 2 | `"Sejong Korean" vocabulary beginner PDF free` | Official Sejong A1 vocab | Thematic vocabulary lists |
| 3 | `"Korean Grammar in Use" beginner table of contents` | Grammar progression order | 은/는, 이/가, 입니다, etc. |
| 4 | `"How to Study Korean" unit 0 unit 1 grammar list` | Detailed grammar with examples | Scraped grammar points |
| 5 | `Korean A1 basic expressions greetings PDF` | Essential beginner phrases | 안녕하세요, 감사합니다, etc. |
| 6 | `"Core 2000 Korean" OR "Evita Korean" Anki deck .apkg download` | Words + audio + sentences | .apkg file |

### 2.3 Japanese (Learning Language: ja)

| # | Search Query | Why | Expected Output |
|---|-------------|-----|-----------------|
| 1 | `"JLPT N5 vocabulary list" PDF download` | ~800 N5 words + kanji + reading | Kanji, hiragana, romaji, English |
| 2 | `"Tae Kim's Guide to Japanese" grammar beginner list` | A1 grammar with examples | は, が, です/ます, adjectives, verbs |
| 3 | `"Genki I" vocabulary list by chapter` | Textbook-aligned A1 vocabulary | Words grouped by topic |
| 4 | `Japanese greetings self-introduction phrases PDF beginner` | Dialogue/phrase content | こんにちは, おはよう, etc. |
| 5 | `"Core 2000 Japanese" Anki deck .apkg download` | Words + audio + sentences | .apkg file |
| 6 | `Japanese numbers counters time expressions beginner PDF` | Numbers/time content | 一～十, 時/分, 曜日 |

### 2.4 French (Learning Language: fr)

| # | Search Query | Why | Expected Output |
|---|-------------|-----|-----------------|
| 1 | `"DELF A1 vocabulaire thématique" PDF download` | ~1000 A1 French words by topic | Word, article, English |
| 2 | `French A1 grammar rules beginner PDF essential` | Grammar: être/avoir, articles, present | Rules with examples |
| 3 | `"5000 most common French words" frequency list CSV` | Frequency data for ordering | Rank, word, translation, POS |
| 4 | `French greetings introductions phrases A1 PDF` | Essential phrases | Bonjour, Comment allez-vous?, etc. |
| 5 | `French numbers 1-100 time expressions PDF` | Numbers & time content | 1-100, telling time, days, months |
| 6 | `French A1 reading comprehension texts beginners` | Passages for exercises | Short paragraphs (50-100 words) |

### 2.5 Spanish (Learning Language: es)

| # | Search Query | Why | Expected Output |
|---|-------------|-----|-----------------|
| 1 | `"DELE A1 vocabulario temático" PDF download` | ~1000 A1 Spanish words by topic | Word, article, English |
| 2 | `Spanish A1 grammar rules beginner PDF essential` | Grammar: ser/estar, articles, present | Rules with examples |
| 3 | `"5000 most common Spanish words" frequency list CSV` | Frequency data for ordering | Rank, word, translation, POS |
| 4 | `Spanish greetings introductions phrases A1 PDF` | Essential phrases | Hola, Cómo estás?, Me llamo... |
| 5 | `Spanish numbers 1-100 time expressions PDF` | Numbers & time content | 1-100, telling time, days, months |
| 6 | `Spanish A1 reading comprehension texts beginners` | Passages for exercises | Short paragraphs (50-100 words) |

### 2.6 Chinese (Learning Language: zh — Simplified)

| # | Search Query | Why | Expected Output |
|---|-------------|-----|-----------------|
| 1 | `"HSK 1 vocabulary list" PDF download` | ~150 HSK1 words + pinyin | Hanzi, pinyin, English |
| 2 | `"HSK 2 vocabulary list" PDF download` | ~150 HSK2 words (A1 level) | Same format as HSK1 |
| 3 | `"Chinese Grammar Wiki" A1 grammar points list` | A1 grammar from AllSet Learning | Scraped: 是, 有, 的, 了, measure words |
| 4 | `Chinese greetings self-introduction phrases A1 PDF` | Essential phrases | 你好, 谢谢, 对不起, 我叫... |
| 5 | `Chinese numbers dates time expressions beginner PDF` | Numbers & time content | 一二三..., 年月日, 点分 |
| 6 | `"Spoonfed Chinese" Anki deck .apkg download` | Words + audio + sentences | .apkg file |

### 2.7 German (Learning Language: de)

| # | Search Query | Why | Expected Output |
|---|-------------|-----|-----------------|
| 1 | `"Goethe A1 Wortliste" PDF download` | ~650 A1 German words by topic | Word, article, English |
| 2 | `German A1 grammar rules beginner PDF essential` | Grammar: articles, cases, verb position | Rules with examples |
| 3 | `"5000 most common German words" frequency list CSV` | Frequency data for ordering | Rank, word, translation, gender |
| 4 | `German greetings introductions phrases A1 PDF` | Essential phrases | Hallo, Wie geht's?, Ich heiße... |
| 5 | `"Nicos Weg A1" transcripts DW learn German` | Dialogue transcripts | Scraped dialogues from Deutsche Welle |
| 6 | `German numbers 1-100 time expressions PDF` | Numbers & time content | 1-100, Uhrzeiten, Tage, Monate |

---

## 3. Bulk Dataset Download URLs

### 3.1 Tatoeba (One-Time, Covers ALL Languages)

```
https://downloads.tatoeba.org/exports/sentences.csv        (~300 MB)
https://downloads.tatoeba.org/exports/links.csv             (~100 MB)
https://downloads.tatoeba.org/exports/tags.csv              (~5 MB)
```

**sentences.csv format:** `sentence_id,language_code,text`
**links.csv format:** `sentence_id,translation_id`

### 3.2 Anki Shared Decks

```
https://ankiweb.net/shared/decks?search=Core+2000+Japanese
https://ankiweb.net/shared/decks?search=Korean+vocabulary+beginner
https://ankiweb.net/shared/decks?search=HSK+1
https://ankiweb.net/shared/decks?search=5000+most+common+French
https://ankiweb.net/shared/decks?search=5000+most+common+Spanish
https://ankiweb.net/shared/decks?search=Goethe+A1
```

### 3.3 Frequency Lists

```
https://github.com/hermitdave/FrequencyWords                  (50+ languages)
https://github.com/oprogramador/most-common-words-by-language (multilingual)
https://en.wiktionary.org/wiki/Wiktionary:Frequency_lists     (per language)
```

### 3.4 Audio & Images

```
https://forvo.com/              (native pronunciations)
https://commonvoice.mozilla.org (open speech datasets)
https://tatoeba.org/en/audio    (Tatoeba audio)
https://unsplash.com/           (free photos)
https://www.flaticon.com/       (free icons)
https://lottiefiles.com/        (free Lottie animations)
```

---

## 4. Content Volume Targets Per Course

| Metric | Current (Skeleton) | Target (Minimum) |
|--------|-------------------|------------------|
| Sections per course | 3 | 8 |
| Lessons per section | 3-5 | 5 |
| Lessons total | 10 | 40 |
| Exercises per lesson | 5 (shared!) | 8 (unique!) |
| Exercises total | 50 (same 5 repeated) | 320 |
| Exercise type mix | 5 types | 12+ types |
| Vocabulary words taught | ~50 | ~300 |
| Grammar points covered | ~10 | ~50 |
| Chill Corner posts | 2-4 | 20 |
| Audio files | 0 | ~300 |
| Image files | 0 | ~200 |

---

## 5. Processing Pipeline

### Step 1: Download All Raw Data
From Sections 2-3, download everything into `raw_data/` organized by language.

### Step 2: Normalize Vocabulary Lists
For each language, create a unified CSV:
```csv
word,phonetic,pos,cefr_level,topic,audio_file,image_file,example,example_translation
```

### Step 3: Extract Sentence Pairs from Tatoeba
Filter: target language sentences with English translations. Max 8 words (non-CJK) or 10 chars (CJK). Only A1 vocabulary.

### Step 4: Source Grammar Rules
~50 grammar points per language, in teaching order, each with 8-language translations of rule + example.

### Step 5: Generate Exercises
From vocabulary + sentence pairs + grammar, auto-generate exercises following the schemas in Section 1.3.

**Per-lesson exercise distribution:**
- 2 vocab introduction (flashCard, vocabularyMultipleChoice)
- 2 recognition (matchPairs, listenAndType, imageIdentification)
- 2 production (fillInBlank, wordSorting, translateSentence)
- 1 grammar (grammarTip, grammarTrueFalse)
- 1 integrated (dialogueComplete, comprehensionText, writing, speaking, phraseBuilderPrefilled)

### Step 6: Translate Everything to 8 Languages
Use DeepL API / Google Translate / GPT-4o for all LocalizedText fields. zh and zh_TW must be separate translations — no auto-conversion.

### Step 7: Generate Chill Corner Posts
20-40 posts per language. See Section 6 for schema.

### Step 8: Validate
See Section 7.

---

## 6. Chill Corner Post Schema

```json
{
  "id": "p_ko_1",
  "authorName": "Minji",
  "authorHandle": "@minji_seoul",
  "authorAvatarUrl": "https://cdn.example.com/avatars/minji.jpg",
  "imageUrl": "https://cdn.example.com/posts/kimchi_jjigae.jpg",
  "content": { "en": "...", "zh": "...", "zh_TW": "...", "ko": "...", "ja": "...", "es": "...", "fr": "...", "de": "..." },
  "targetWord": "매운",
  "wordTranslation": { "en": "spicy", "zh": "辣的", "zh_TW": "辣的", "ko": "매운", "ja": "辛い", "es": "picante", "fr": "épicé", "de": "scharf" },
  "wordExplanation": { "en": "...", "zh": "...", "zh_TW": "...", "ko": "...", "ja": "...", "es": "...", "fr": "...", "de": "..." },
  "wordPhonetic": "mae-un",
  "requiredWords": ["매운"],
  "requiredLessonIds": [],
  "createdAt": "2026-05-27T10:00:00Z",
  "characterType": "foodie",
  "location": "Seoul, South Korea",
  "comments": []
}
```

---

## 7. Validation Rules

Before outputting any JSON file, verify:

1. **All LocalizedText fields have exactly 8 keys:** `{'en', 'zh', 'zh_TW', 'ko', 'ja', 'es', 'fr', 'de'}`
2. **No null or empty string values** in any language field
3. **Exercise types are valid** (one of the 16 enum values)
4. **No duplicate exercise IDs** within a course
5. **zh_TW values** are independent from zh — no auto-converted identical strings
6. **A1 sentence length:** ≤ 8 words (non-CJK) or ≤ 10 characters (CJK)
7. **Exercise type variety:** Each lesson has ≥ 5 distinct exercise types
8. **All vocabulary words** in a lesson appear in at least one exercise
9. **Valid UTF-8** encoding throughout

---

## 8. Output Instructions for Manus AI

1. **Read ALL sections** (0-7) before starting.
2. **Start with ONE language** (English A1) as a pilot. Output `en_a1.json` for review, then proceed.
3. **For each JSON file, include a summary:** total exercises, type distribution, vocab coverage, missing translations.
4. **Audio/images:** If you cannot download actual files, use `"https://cdn.instalingo.app/audio/{lang}/{word}.mp3"` placeholders and list all needed files in `media_manifest.json`.
5. **Failed searches:** Note in `acquisition_issues.json` what was searched and what's missing.

---

*Generated: 2026-05-27*
*Replaces: old CONTENT_ACQUISITION_GUIDE.md*
*To share: this entire document to Manus AI or equivalent autonomous content agent*
