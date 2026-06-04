#!/usr/bin/env python3
"""
build_courses_from_raw.py — Generate full A1 courses from Manus-acquired raw data.
Reads vocab CSVs + sentence CSVs + grammar JSONs → produces course Dart code.
Real data only. No AI filler.

Usage: python3 tools/build_courses_from_raw.py --all
       python3 tools/build_courses_from_raw.py --lang ko
"""

import csv, json, os, re, random, sys
from collections import defaultdict, OrderedDict
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent.resolve()
RAW_DIR = PROJECT_ROOT / "manus_output" / "instalingo_raw_data"
OUT_DIR = PROJECT_ROOT / "manus_output" / "golden"
OUT_DIR.mkdir(parents=True, exist_ok=True)

LANGUAGES = ['ko', 'ja', 'fr', 'es', 'zh', 'de']
random.seed(42)

# ─── 8-language instruction templates (multi-lingual UI) ─────────────
INSTRUCTIONS = {
    'flashCard':           {'en':'Flip the card.','zh':'翻转卡片。','zh_TW':'翻轉卡片。','ko':'카드를 뒤집으세요.','ja':'カードを裏返してください。','es':'Voltea la tarjeta.','fr':'Retournez la carte.','de':'Karte umdrehen.'},
    'vocabularyMultipleChoice': {'en':'Choose the correct word.','zh':'选择正确的词。','zh_TW':'選擇正確的詞。','ko':'올바른 단어를 고르세요.','ja':'正しい単語を選んでください。','es':'Elige la palabra correcta.','fr':'Choisissez le bon mot.','de':'Wählen Sie das richtige Wort.'},
    'matchPairs':          {'en':'Match the pairs.','zh':'配对。','zh_TW':'配對。','ko':'짝을 맞추세요.','ja':'ペアを合わせてください。','es':'Empareja.','fr':'Associez.','de':'Paare zuordnen.'},
    'fillInBlank':         {'en':'Fill in the blank.','zh':'填空。','zh_TW':'填空。','ko':'빈칸을 채우세요.','ja':'空欄を埋めてください。','es':'Rellena el espacio.','fr':'Remplissez le blanc.','de':'Lücke füllen.'},
    'wordSorting':         {'en':'Arrange the words.','zh':'排列单词。','zh_TW':'排列單詞。','ko':'단어를 배열하세요.','ja':'単語を並べ替えてください。','es':'Ordena las palabras.','fr':'Remettez dans l\'ordre.','de':'Wörter ordnen.'},
    'translateSentence':   {'en':'Choose the translation.','zh':'选择翻译。','zh_TW':'選擇翻譯。','ko':'번역을 고르세요.','ja':'翻訳を選んでください。','es':'Elige la traducción.','fr':'Choisissez la traduction.','de':'Übersetzung wählen.'},
    'grammarTip':          {'en':'Grammar note','zh':'语法提示','zh_TW':'語法提示','ko':'문법 노트','ja':'文法ノート','es':'Nota gramatical','fr':'Note de grammaire','de':'Grammatik-Hinweis'},
    'grammarTrueFalse':    {'en':'True or false?','zh':'对还是错？','zh_TW':'對還是錯？','ko':'맞습니까?','ja':'正しいですか？','es':'¿Verdadero o falso?','fr':'Vrai ou faux ?','de':'Richtig oder falsch?'},
    'listenAndType':       {'en':'Listen and type.','zh':'听并输入。','zh_TW':'聽並輸入。','ko':'듣고 입력하세요.','ja':'聞いて入力してください。','es':'Escucha y escribe.','fr':'Écoutez et tapez.','de':'Hören und tippen.'},
    'imageIdentification': {'en':'Tap the image.','zh':'点击图片。','zh_TW':'點擊圖片。','ko':'이미지를 탭하세요.','ja':'画像をタップしてください。','es':'Toca la imagen.','fr':'Appuyez sur l\'image.','de':'Bild antippen.'},
    'dialogueComplete':    {'en':'Complete the dialogue.','zh':'完成对话。','zh_TW':'完成對話。','ko':'대화를 완성하세요.','ja':'会話を完成させてください。','es':'Completa el diálogo.','fr':'Complétez le dialogue.','de':'Dialog vervollständigen.'},
    'speaking':            {'en':'Say it out loud.','zh':'大声说出来。','zh_TW':'大聲說出來。','ko':'큰 소리로 말하세요.','ja':'声に出して言ってください。','es':'Dilo en voz alta.','fr':'Dites-le à voix haute.','de':'Sagen Sie es laut.'},
    'writing':             {'en':'Write a response.','zh':'写出回答。','zh_TW':'寫出回答。','ko':'답을 쓰세요.','ja':'答えを書いてください。','es':'Escribe una respuesta.','fr':'Écrivez une réponse.','de':'Schreiben Sie eine Antwort.'},
}

# ─── Real language name translations ──────────────────────────────────

LANG_NAMES = {
    'ko': {'en': 'Korean',  'zh': '韩语', 'zh_TW': '韓語', 'ko': '한국어', 'ja': '韓国語', 'es': 'coreano', 'fr': 'coréen', 'de': 'Koreanisch'},
    'ja': {'en': 'Japanese','zh': '日语', 'zh_TW': '日語', 'ko': '일본어', 'ja': '日本語', 'es': 'japonés', 'fr': 'japonais', 'de': 'Japanisch'},
    'fr': {'en': 'French',  'zh': '法语', 'zh_TW': '法語', 'ko': '프랑스어','ja': 'フランス語','es': 'francés', 'fr': 'français', 'de': 'Französisch'},
    'es': {'en': 'Spanish', 'zh': '西班牙语','zh_TW':'西班牙語','ko':'스페인어','ja':'スペイン語','es':'español', 'fr':'espagnol', 'de':'Spanisch'},
    'zh': {'en': 'Chinese', 'zh': '中文', 'zh_TW': '中文', 'ko': '중국어', 'ja': '中国語', 'es': 'chino', 'fr': 'chinois', 'de': 'Chinesisch'},
    'de': {'en': 'German',  'zh': '德语', 'zh_TW': '德語', 'ko': '독일어', 'ja': 'ドイツ語', 'es': 'alemán', 'fr': 'allemand', 'de': 'Deutsch'},
}


TOPIC_KEYWORDS = {
    'greeting': ['hello','hi','goodbye','bye','welcome','greet','morning','evening','night','good'],
    'introduction': ['name','introduce','meet','call','spell','我叫','我是'],
    'feeling': ['happy','sad','angry','tired','fine','good','bad','sorry','thank','afraid'],
    'people': ['person','people','man','woman','boy','girl','friend','family','mother','father',
               'sister','brother','child','baby','parent','neighbor','classmate'],
    'food_drink': ['eat','drink','food','water','rice','bread','tea','coffee','milk','apple',
                   'fruit','meal','breakfast','lunch','dinner','sweet','delicious','hungry'],
    'home': ['house','home','room','kitchen','bathroom','bedroom','door','window','table',
             'chair','bed','desk','sofa','lamp','floor','wall','key','bag','book','pen'],
    'time': ['time','day','week','month','year','today','tomorrow','yesterday','morning',
             'afternoon','evening','night','hour','minute','Monday','Tuesday','January','February'],
    'number': ['one','two','three','four','five','six','seven','eight','nine','ten','number','count'],
    'place': ['place','city','country','school','bank','park','station','hospital','hotel',
              'restaurant','museum','airport','street','road','here','there','where'],
    'transport': ['car','bus','train','bike','taxi','plane','travel','ticket','go','come','leave','arrive'],
    'clothing': ['shirt','dress','shoe','hat','coat','skirt','sock','jacket','clothes','wear'],
    'color': ['red','blue','green','yellow','black','white','brown','orange','color'],
    'weather': ['weather','sun','rain','snow','wind','hot','cold','warm'],
    'health': ['sick','doctor','hospital','head','hand','arm','leg','eye','ear','pain','hurt','tired'],
    'shopping': ['buy','sell','shop','price','money','cheap','expensive','market','pay'],
    'grammar': ['verb','noun','adjective','tense','particle','conjugate','sentence','word'],
}

TOPIC_SECTION_MAP = {
    'greeting': 'greetings', 'introduction': 'greetings', 'feeling': 'greetings',
    'people': 'people', 'family': 'people',
    'food_drink': 'food',
    'home': 'daily', 'clothing': 'daily', 'color': 'daily', 'shopping': 'daily',
    'time': 'time', 'number': 'time',
    'place': 'places', 'transport': 'places',
    'weather': 'daily', 'health': 'daily',
    'grammar': 'grammar',
}

def infer_topic(en_translation, word=''):
    """Infer a pedagogical topic from English translation of a word."""
    en_lower = en_translation.lower()
    best_topic = 'general'
    best_score = 0
    for topic, keywords in TOPIC_KEYWORDS.items():
        score = 0
        for kw in keywords:
            if kw in en_lower or kw in word.lower():
                score += 1
        if score > best_score:
            best_score = score
            best_topic = topic
    return best_topic

COURSE_DESCRIPTIONS = {
    'ko': {'en': 'Master basic Korean. Learn Hangul, greetings, numbers, and everyday expressions from real TOPIK materials.',
           'zh': '掌握基础韩语。通过真实TOPIK材料学习韩文、问候、数字和日常表达。',
           'zh_TW': '掌握基礎韓語。通過真實TOPIK材料學習韓文、問候、數字和日常表達。',
           'ko': '기초 한국어를 마스터하세요. 실제 TOPIK 자료로 한글, 인사, 숫자, 일상 표현을 배웁니다.',
           'ja': '基礎韓国語をマスターしましょう。実際のTOPIK教材でハングル、挨拶、数字、日常表現を学びます。',
           'es': 'Domina el coreano básico. Aprende Hangul, saludos, números y expresiones cotidianas con materiales TOPIK reales.',
           'fr': 'Maîtrisez le coréen de base. Apprenez le Hangul, les salutations, les nombres et les expressions quotidiennes.',
           'de': 'Meistern Sie Grundkenntnisse in Koreanisch. Lernen Sie Hangul, Begrüßungen, Zahlen und Alltagsausdrücke.'},
    'ja': {'en': 'Master basic Japanese. Learn hiragana, katakana, greetings, and everyday phrases from JLPT N5 materials.',
           'zh': '掌握基础日语。通过JLPT N5材料学习平假名、片假名、问候和日常短语。',
           'zh_TW': '掌握基礎日語。通過JLPT N5材料學習平假名、片假名、問候和日常短語。',
           'ko': '기초 일본어를 마스터하세요. JLPT N5 자료로 히라가나, 가타카나, 인사, 일상 표현을 배웁니다.',
           'ja': '基礎日本語をマスターしましょう。JLPT N5教材でひらがな、カタカナ、挨拶、日常表現を学びます。',
           'es': 'Domina el japonés básico. Aprende hiragana, katakana, saludos y frases cotidianas con materiales JLPT N5.',
           'fr': 'Maîtrisez le japonais de base. Apprenez les hiragana, katakana, salutations et expressions quotidiennes.',
           'de': 'Meistern Sie Grundkenntnisse in Japanisch. Lernen Sie Hiragana, Katakana, Begrüßungen und Alltagsphrasen.'},
    'fr': {'en': 'Master basic French. Learn greetings, articles, present tense, and everyday vocabulary from DELF A1 materials.',
           'zh': '掌握基础法语。通过DELF A1材料学习问候、冠词、现在时和日常词汇。',
           'zh_TW': '掌握基礎法語。通過DELF A1材料學習問候、冠詞、現在時和日常詞彙。',
           'ko': '기초 프랑스어를 마스터하세요. DELF A1 자료로 인사, 관사, 현재 시제, 일상 어휘를 배웁니다.',
           'ja': '基礎フランス語をマスターしましょう。DELF A1教材で挨拶、冠詞、現在形、日常語彙を学びます。',
           'es': 'Domina el francés básico. Aprende saludos, artículos, presente y vocabulario cotidiano con materiales DELF A1.',
           'fr': 'Maîtrisez le français de base. Apprenez les salutations, articles, présent et vocabulaire quotidien.',
           'de': 'Meistern Sie Grundkenntnisse in Französisch. Lernen Sie Begrüßungen, Artikel, Präsens und Alltagsvokabular.'},
    'es': {'en': 'Master basic Spanish. Learn greetings, ser/estar, present tense, and everyday vocabulary from DELE A1 materials.',
           'zh': '掌握基础西班牙语。通过DELE A1材料学习问候、ser/estar、现在时和日常词汇。',
           'zh_TW': '掌握基礎西班牙語。通過DELE A1材料學習問候、ser/estar、現在時和日常詞彙。',
           'ko': '기초 스페인어를 마스터하세요. DELE A1 자료로 인사, ser/estar, 현재 시제, 일상 어휘를 배웁니다.',
           'ja': '基礎スペイン語をマスターしましょう。DELE A1教材で挨拶、ser/estar、現在形、日常語彙を学びます。',
           'es': 'Domina el español básico. Aprende saludos, ser/estar, presente y vocabulario cotidiano con materiales DELE A1.',
           'fr': 'Maîtrisez l\'espagnol de base. Apprenez les salutations, ser/estar, le présent et le vocabulaire quotidien.',
           'de': 'Meistern Sie Grundkenntnisse in Spanisch. Lernen Sie Begrüßungen, ser/estar, Präsens und Alltagsvokabular.'},
    'zh': {'en': 'Master basic Chinese. Learn pinyin, characters, tones, greetings, and everyday expressions from HSK 1-2 materials.',
           'zh': '掌握基础中文。通过HSK 1-2材料学习拼音、汉字、声调、问候和日常表达。',
           'zh_TW': '掌握基礎中文。通過HSK 1-2材料學習拼音、漢字、聲調、問候和日常表達。',
           'ko': '기초 중국어를 마스터하세요. HSK 1-2 자료로 병음, 한자, 성조, 인사, 일상 표현을 배웁니다.',
           'ja': '基礎中国語をマスターしましょう。HSK 1-2教材でピンイン、漢字、声調、挨拶、日常表現を学びます。',
           'es': 'Domina el chino básico. Aprende pinyin, caracteres, tonos, saludos y expresiones cotidianas con materiales HSK 1-2.',
           'fr': 'Maîtrisez le chinois de base. Apprenez le pinyin, les caractères, les tons, les salutations et expressions quotidiennes.',
           'de': 'Meistern Sie Grundkenntnisse in Chinesisch. Lernen Sie Pinyin, Schriftzeichen, Töne, Begrüßungen und Alltagsausdrücke.'},
    'de': {'en': 'Master basic German. Learn greetings, articles, cases, present tense, and everyday vocabulary from Goethe A1 materials.',
           'zh': '掌握基础德语。通过Goethe A1材料学习问候、冠词、格、现在时和日常词汇。',
           'zh_TW': '掌握基礎德語。通過Goethe A1材料學習問候、冠詞、格、現在時和日常詞彙。',
           'ko': '기초 독일어를 마스터하세요. Goethe A1 자료로 인사, 관사, 격, 현재 시제, 일상 어휘를 배웁니다.',
           'ja': '基礎ドイツ語をマスターしましょう。Goethe A1教材で挨拶、冠詞、格、現在形、日常語彙を学びます。',
           'es': 'Domina el alemán básico. Aprende saludos, artículos, casos, presente y vocabulario cotidiano con materiales Goethe A1.',
           'fr': 'Maîtrisez l\'allemand de base. Apprenez les salutations, articles, cas, présent et vocabulaire quotidien.',
           'de': 'Meistern Sie Grundkenntnisse in Deutsch. Lernen Sie Begrüßungen, Artikel, Fälle, Präsens und Alltagsvokabular.'},
}

SECTION_NAMES = {
    'greetings':     {'en':'Greetings & Introductions','zh':'问候与介绍','zh_TW':'問候與介紹','ko':'인사와 소개','ja':'挨拶と紹介','es':'Saludos y presentaciones','fr':'Salutations et présentations','de':'Begrüßung und Vorstellung'},
    'people':        {'en':'People & Family','zh':'人与家庭','zh_TW':'人與家庭','ko':'사람과 가족','ja':'人と家族','es':'Personas y familia','fr':'Personnes et famille','de':'Menschen und Familie'},
    'daily':         {'en':'Daily Life','zh':'日常生活','zh_TW':'日常生活','ko':'일상생활','ja':'日常生活','es':'Vida diaria','fr':'Vie quotidienne','de':'Alltagsleben'},
    'food':          {'en':'Food & Drink','zh':'饮食','zh_TW':'飲食','ko':'음식과 음료','ja':'食べ物と飲み物','es':'Comida y bebida','fr':'Nourriture et boissons','de':'Essen und Trinken'},
    'places':        {'en':'Places & Travel','zh':'地点与旅行','zh_TW':'地點與旅行','ko':'장소와 여행','ja':'場所と旅行','es':'Lugares y viajes','fr':'Lieux et voyages','de':'Orte und Reisen'},
    'time':          {'en':'Time & Numbers','zh':'时间与数字','zh_TW':'時間與數字','ko':'시간과 숫자','ja':'時間と数字','es':'Tiempo y números','fr':'Temps et nombres','de':'Zeit und Zahlen'},
    'descriptions':  {'en':'Describing Things','zh':'描述事物','zh_TW':'描述事物','ko':'사물 설명하기','ja':'物事を説明する','es':'Describir cosas','fr':'Décrire les choses','de':'Dinge beschreiben'},
    'grammar':       {'en':'Basic Grammar','zh':'基础语法','zh_TW':'基礎語法','ko':'기초 문법','ja':'基本文法','es':'Gramática básica','fr':'Grammaire de base','de':'Grundgrammatik'},
}

# ─── Data loading ─────────────────────────────────────────────────────

def load_vocab(lang):
    """Load vocabulary CSV → list of dicts."""
    path = RAW_DIR / f'{lang}_vocab.csv'
    if not path.exists():
        print(f'  ⚠ No vocab file for {lang}')
        return []
    with open(path, encoding='utf-8') as f:
        return list(csv.DictReader(f))
    
def load_sentences(lang):
    """Load sentence CSV → list of dicts."""
    path = RAW_DIR / f'{lang}_sentences.csv'
    if not path.exists():
        print(f'  ⚠ No sentence file for {lang}')
        return []
    with open(path, encoding='utf-8') as f:
        return list(csv.DictReader(f))

def load_grammar(lang):
    """Load grammar JSON → list of points."""
    path = RAW_DIR / f'{lang}_grammar.json'
    if not path.exists():
        print(f'  ⚠ No grammar file for {lang}')
        return []
    with open(path, encoding='utf-8') as f:
        data = json.load(f)
    return data.get('grammar_points', [])

# ─── Helpers ──────────────────────────────────────────────────────────

def lt(en_text, **overrides):
    """Create 8-language LocalizedText dict. Defaults to English for missing languages.
    For pedagogical content, callers should use explicit dicts, not lt()."""
    d = {'en': en_text}
    for l in ['zh','zh_TW','ko','ja','es','fr','de']:
        d[l] = overrides.get(l, en_text)
    return d

def safe_str(s):
    """JSON-safe string for Dart output."""
    return json.dumps(s if s else '', ensure_ascii=False)

def dart_exercise(ex):
    """Convert exercise dict to Dart Exercise(...) string."""
    lines = []
    lines.append(f"const Exercise(")
    lines.append(f"  id: {safe_str(ex['id'])},")
    lines.append(f"  type: ExerciseType.{ex['type']},")
    lines.append(f"  contentLang: '{ex.get('contentLang','')}',")
    lines.append(f"  question: {safe_str(ex.get('question',''))},")
    if ex.get('instruction'):
        lines.append(f"  instruction: {safe_str(ex['instruction'])},")
    if ex.get('options'):
        lines.append(f"  options: const {safe_str(ex['options'])},")
    if ex.get('correctAnswer'):
        lines.append(f"  correctAnswer: {safe_str(ex['correctAnswer'])},")
    if ex.get('correctAnswerList'):
        lines.append(f"  correctAnswerList: const {safe_str(ex['correctAnswerList'])},")
    if ex.get('explanation') and isinstance(ex['explanation'], dict):
        lines.append(f"  explanation: {lt_to_dart_str(ex['explanation'])},")
    if ex.get('pairs'):
        pair_strs = [f"const WordPair(left: {safe_str(p['left'])}, right: {safe_str(p['right'])})" for p in ex['pairs']]
        lines.append(f"  pairs: const [{', '.join(pair_strs)}],")
    if ex.get('grammarRule') and isinstance(ex['grammarRule'], dict):
        lines.append(f"  grammarRule: {lt_to_dart_str(ex['grammarRule'])},")
    if ex.get('grammarExample') and isinstance(ex['grammarExample'], dict):
        lines.append(f"  grammarExample: {lt_to_dart_str(ex['grammarExample'])},")
    if ex.get('isTrue') is not None:
        lines.append(f"  isTrue: {str(ex['isTrue']).lower()},")
    if ex.get('audioUrl'):
        lines.append(f"  audioUrl: {safe_str(ex['audioUrl'])},")
    if ex.get('imageUrl'):
        lines.append(f"  imageUrl: {safe_str(ex['imageUrl'])},")
    lines.append(f"),")
    return '\n'.join(lines)

def lt_to_dart_str(d):
    """Convert LocalizedText dict to Dart const LocalizedText({...})."""
    parts = []
    for l in ['en','zh','zh_TW','ko','ja','es','fr','de']:
        parts.append(f"'{l}': {safe_str(d.get(l, d.get('en','')))}")
    return f"const LocalizedText({{{', '.join(parts)}}})"

# ─── Exercise generation from real data ───────────────────────────────

def make_sentence_exercises(word, sentences, ex_id_base):
    """Generate exercises using real Tatoeba sentences containing the word."""
    exercises = []
    eid = ex_id_base
    
    # Find sentences containing the word
    matching = []
    word_lower = word.lower().strip()
    for s in sentences:
        sent_lower = s['sentence'].lower()
        if word_lower in sent_lower.split() or f' {word_lower}' in sent_lower:
            matching.append(s)
    
    if not matching:
        return exercises
    
    s = random.choice(matching)
    sent = s['sentence']
    trans = s.get('translation_en', '')
    
    # 1. fillInBlank — real sentence with word removed
    pattern = re.compile(r'\b' + re.escape(word_lower) + r'\b', re.IGNORECASE)
    m = pattern.search(sent)
    if m and 3 <= len(sent.split()) <= 10:
        blanked = sent[:m.start()] + '___' + sent[m.end():]
        # Pick distractors from other sentences
        dist_words = [w for w in [ws.split()[0] for ws in [s2['sentence'] for s2 in sentences[:50]]] 
                     if w.lower() != word_lower and len(w) >= 2]
        random.shuffle(dist_words)
        distractors = list(dict.fromkeys(dist_words))[:3]
        
        exercises.append({
            'id': f'{eid}_02', 'type': 'fillInBlank', 'contentLang': s.get('target_lang',''),
            'question': blanked,            'wordBank': [word] + distractors,
            'correctAnswer': word,
            'options': [word] + distractors,
            'explanation': make_word_explanation(word, s.get('translation_en', word), ''),
        })
    
    # 2. translateSentence — real sentence pair
    if trans and 3 <= len(sent.split()) <= 10:
        # Pick distractor translations from other sentences
        other_trans = [s2['translation_en'] for s2 in sentences[:50] 
                       if s2['translation_en'] != trans and len(s2['translation_en']) > 3]
        random.shuffle(other_trans)
        dist_trans = list(dict.fromkeys(other_trans))[:3]
        opts = [trans] + dist_trans
        random.shuffle(opts)
        
        exercises.append({
            'id': f'{eid}_03', 'type': 'translateSentence', 'contentLang': s.get('target_lang',''),
            'question': sent,            'options': opts,
            'correctAnswer': trans,
            'explanation': make_sentence_explanation(word, sent, trans),
        })
    
    # 3. wordSorting — real sentence scrambled
    words = sent.rstrip('.!?。！？').split()
    if 3 <= len(words) <= 6:
        jumbled = words[:]
        random.shuffle(jumbled)
        if jumbled != words:
            exercises.append({
                'id': f'{eid}_04', 'type': 'wordSorting', 'contentLang': s.get('target_lang',''),
                'question': '',                'options': jumbled,
                'correctAnswerList': words,
                'explanation': make_sentence_explanation(word, sent, ''),
            })
    
    return exercises


def make_match_pairs(words, translations, ex_id):
    """Match target words with their English translations."""
    pairs = []
    for w in words[:6]:
        trans = translations.get(w, w)
        pairs.append({'left': w, 'right': trans})
    return {
        'id': ex_id, 'type': 'matchPairs',
        'contentLang': '', 'question': '',        'pairs': pairs
    }


# ─── Simplified→Traditional Chinese — only characters that DIFFER ─────
_S2T = {
    '见':'見','为':'為','学':'學','语':'語','问':'問','门':'門','们':'們',
    '马':'馬','鱼':'魚','鸟':'鳥','龙':'龍','万':'萬','与':'與','书':'書',
    '车':'車','长':'長','东':'東','乐':'樂','买':'買','卖':'賣','开':'開',
    '关':'關','风':'風','飞':'飛','饭':'飯','电':'電','话':'話','动':'動',
    '会':'會','体':'體','国':'國','对':'對','时':'時','现':'現','点':'點',
    '爱':'愛','无':'無','来':'來','个':'個','说':'說','过':'過','还':'還',
    '后':'後','里':'裡','么':'麼','头':'頭','实':'實','写':'寫','红':'紅',
    '绿':'綠','蓝':'藍','黄':'黃','难':'難','让':'讓','请':'請','谢':'謝',
    '认':'認','识':'識','钱':'錢','银':'銀','错':'錯','觉':'覺','样':'樣',
    '这':'這','习':'習','师':'師','帅':'帥','归':'歸','当':'當','应':'應',
    '从':'從','发':'發','历':'歷','广':'廣','义':'義','专':'專','业':'業',
    '严':'嚴','丰':'豐','临':'臨','丽':'麗','举':'舉','乌':'烏','乔':'喬',
    '争':'爭','产':'產','亲':'親','亿':'億','仅':'僅','仆':'僕','儿':'兒',
    '党':'黨','兰':'蘭','兴':'興','养':'養','农':'農','军':'軍','准':'準',
    '几':'幾','凤':'鳳','击':'擊','凿':'鑿','划':'劃','刚':'剛','创':'創',
    '刘':'劉','别':'別','则':'則','剧':'劇','办':'辦','劝':'勸','务':'務',
    '势':'勢','劳':'勞','医':'醫','区':'區','单':'單','卫':'衛','压':'壓',
    '县':'縣','参':'參','双':'雙','变':'變','号':'號','叹':'嘆','吓':'嚇',
    '吗':'嗎','吨':'噸','听':'聽','响':'響','员':'員','园':'園','围':'圍',
    '图':'圖','圣':'聖','场':'場','备':'備','处':'處','复':'復','够':'夠',
    '梦':'夢','奖':'獎','妇':'婦','孙':'孫','宁':'寧','审':'審','宽':'寬',
    '导':'導','尽':'盡','岁':'歲','岛':'島','带':'帶','干':'幹','庆':'慶',
    '库':'庫','厂':'廠','庙':'廟','废':'廢','录':'錄','彻':'徹','征':'徵',
    '德':'德','态':'態','忆':'憶','战':'戰','戏':'戲','户':'戶','执':'執',
    '扫':'掃','扬':'揚','扰':'擾','护':'護','报':'報','担':'擔','拨':'撥',
    '择':'擇','拥':'擁','拦':'攔','扩':'擴','摆':'擺','据':'據','操':'操',
    '数':'數','敌':'敵','断':'斷','旧':'舊','显':'顯','晒':'曬','术':'術',
    '机':'機','权':'權','条':'條','杨':'楊','极':'極','构':'構','标':'標',
    '树':'樹','检':'檢','欢':'歡','况':'況','没':'沒','法':'法','注':'註',
    '济':'濟','浓':'濃','灵':'靈','炼':'煉','热':'熱','独':'獨','环':'環',
    '画':'畫','疗':'療','监':'監','盘':'盤','众':'眾','种':'種','积':'積',
    '称':'稱','穷':'窮','笔':'筆','简':'簡','类':'類','系':'係','紧':'緊',
    '线':'線','练':'練','组':'組','细':'細','经':'經','结':'結','给':'給',
    '统':'統','继':'繼','续':'續','网':'網','罗':'羅','职':'職','联':'聯',
    '聪':'聰','胜':'勝','脑':'腦','节':'節','范':'範','获':'獲','营':'營',
    '艺':'藝','药':'藥','规':'規','视':'視','览':'覽','计':'計','订':'訂',
    '记':'記','议':'議','讲':'講','许':'許','论':'論','设':'設','证':'證',
    '评':'評','诉':'訴','诊':'診','词':'詞','译':'譯','试':'試','该':'該',
    '详':'詳','误':'誤','读':'讀','课':'課','谁':'誰','调':'調','谈':'談',
    '谊':'誼','谋':'謀','谓':'謂','警':'警','负':'負','财':'財','责':'責',
    '败':'敗','质':'質','购':'購','货':'貨','贪':'貪','贵':'貴','贷':'貸',
    '贸':'貿','费':'費','资':'資','赏':'賞','赔':'賠','赖':'賴','赚':'賺',
    '赛':'賽','赞':'贊','赠':'贈','赢':'贏','赵':'趙','赶':'趕','趋':'趨',
    '践':'踐','踪':'蹤','转':'轉','轮':'輪','软':'軟','轻':'輕','输':'輸',
    '边':'邊','达':'達','运':'運','进':'進','远':'遠','连':'連','选':'選',
    '适':'適','递':'遞','遗':'遺','邮':'郵','乡':'鄉','邻':'鄰','邓':'鄧',
    '郑':'鄭','邹':'鄒','郁':'鬱','郭':'郭','鉴':'鑒','针':'針','钉':'釘',
    '钓':'釣','钙':'鈣','钢':'鋼','铁':'鐵','铜':'銅','链':'鏈','销':'銷',
    '锁':'鎖','锅':'鍋','锋':'鋒','键':'鍵','镇':'鎮','镜':'鏡','闪':'閃',
    '闭':'閉','闯':'闖','间':'間','闲':'閒','闹':'鬧','闻':'聞','阀':'閥',
    '阅':'閱','队':'隊','阵':'陣','阳':'陽','阴':'陰','阶':'階','际':'際',
    '陆':'陸','陈':'陳','险':'險','随':'隨','隐':'隱','雾':'霧','静':'靜',
    '页':'頁','顶':'頂','项':'項','顺':'順','须':'須','顾':'顧','领':'領',
    '颈':'頸','频':'頻','题':'題','颜':'顏','额':'額','饮':'飲','饱':'飽',
    '饰':'飾','馆':'館','驾':'駕','验':'驗','骑':'騎','骗':'騙','骤':'驟',
    '骨':'骨','发':'髮','松':'鬆','齐':'齊','齿':'齒','龟':'龜',
}

def s2t(text):
    """Convert Simplified Chinese to Traditional. Deterministic — no AI."""
    return ''.join(_S2T.get(c, c) for c in text)

def make_word_explanation(word, trans_en, trans_zh=''):
    """Generate multi-language explanation for a word."""
    zh_text = trans_zh or word
    zh_tw_text = s2t(zh_text)
    return {
        'en': f"'{word}' means '{trans_en}'.",
        'zh': f"'{word}' 的意思是 '{zh_text}'。",
        'zh_TW': f"'{word}' 的意思是 '{zh_tw_text}'。",
        'ko': f"'{word}'의 의미는 '{trans_en}'입니다.",
        'ja': f"'{word}'の意味は '{trans_en}' です。",
        'es': f"'{word}' significa '{trans_en}'.",
        'fr': f"'{word}' signifie '{trans_en}'.",
        'de': f"'{word}' bedeutet '{trans_en}'.",
    }

def make_sentence_explanation(word, target_sentence, en_translation):
    """Generate multi-language explanation for a sentence translation."""
    zh_tw_target = s2t(target_sentence)
    return {
        'en': f"'{target_sentence}' means '{en_translation}'.",
        'zh': f"'{target_sentence}' 的意思是 '{en_translation}'。",
        'zh_TW': f"'{zh_tw_target}' 的意思是 '{en_translation}'。",
        'ko': f"'{target_sentence}'의 의미는 '{en_translation}'입니다.",
        'ja': f"'{target_sentence}'の意味は '{en_translation}' です。",
        'es': f"'{target_sentence}' significa '{en_translation}'.",
        'fr': f"'{target_sentence}' signifie '{en_translation}'.",
        'de': f"'{target_sentence}' bedeutet '{en_translation}'.",
    }

def make_flashcard(word, translation_en, translation_zh, ex_id, lang_code):
    """Flash card with word and Chinese translation as answer."""
    zh_ans = translation_zh or translation_en
    return {
        'id': ex_id, 'type': 'flashCard',
        'contentLang': lang_code,
        'question': word,
        'correctAnswer': zh_ans,
        'explanation': make_word_explanation(word, translation_en, translation_zh)
    }


def make_grammar_exercise(grammar_point, ex_id):
    """Grammar tip or true/false from real grammar data."""
    title = grammar_point.get('title', '')
    pattern = grammar_point.get('pattern', '')
    example = grammar_point.get('example', '')
    example_trans = grammar_point.get('example_translation', '')
    source = grammar_point.get('source_excerpt', '')
    
    rule_text = f"{title}"
    if pattern:
        rule_text += f" — {pattern}"
    if example:
        rule_text += f"\nExample: {example}"
    
    example_text = example if example else ''
    if example_trans:
        example_text += f" → {example_trans}"
    
    return {
        'id': ex_id, 'type': 'grammarTip',
        'contentLang': '',
        'question': '',
        'grammarRule': {
            'en': rule_text, 'zh': f'语法：{rule_text}', 'zh_TW': f'語法：{s2t(rule_text)}',
            'ko': f'문법: {rule_text}', 'ja': f'文法: {rule_text}',
            'es': f'Gramática: {rule_text}', 'fr': f'Grammaire : {rule_text}', 'de': f'Grammatik: {rule_text}',
        },
        'grammarExample': {
            'en': example_text, 'zh': f'例：{example_text}', 'zh_TW': f'例：{s2t(example_text)}',
            'ko': f'예: {example_text}', 'ja': f'例: {example_text}',
            'es': f'Ej: {example_text}', 'fr': f'Ex : {example_text}', 'de': f'Bsp: {example_text}',
        }
    }

# ─── Course builder ───────────────────────────────────────────────────

def build_course(lang_code):
    """Build complete A1 course from raw data."""
    print(f"\n{'='*60}")
    print(f"Building {lang_code.upper()} A1 course from raw data...")
    
    vocab = load_vocab(lang_code)
    sentences = load_sentences(lang_code)
    grammar = load_grammar(lang_code)
    
    if not vocab or not sentences:
        print(f"  ❌ Missing data for {lang_code}")
        return None
    
    # Deduplicate sentences
    seen = set()
    unique_sents = []
    for s in sentences:
        key = s['sentence'].strip()
        if key not in seen:
            seen.add(key)
            unique_sents.append(s)
    
    print(f"  Vocab: {len(vocab)} words")
    print(f"  Sentences: {len(unique_sents)} unique (from {len(sentences)} total)")
    print(f"  Grammar: {len(grammar)} points")
    
    # Build word-to-sentence index
    word_sents = defaultdict(list)
    for s in unique_sents:
        sent_words = set(re.findall(r'\b\w+\b', s['sentence'].lower()))
        for v in vocab:
            vw = v.get('word', '').lower().strip()
            if vw and vw in sent_words:
                word_sents[vw].append(s)
    
    words_with_sents = {w: len(sids) for w, sids in word_sents.items() if len(sids) >= 1}
    print(f"  Words with sentence data: {len(words_with_sents)}")
    
    # Filter to A1 only
    a1_vocab = [v for v in vocab if v.get('cefr_level', 'A1').strip() == 'A1']
    if len(a1_vocab) < 100:
        a1_vocab = vocab  # Fallback if no CEFR tags
    print(f"  A1 filtered: {len(a1_vocab)} words (was {len(vocab)})")
    vocab = a1_vocab
    
    # Infer topics from English translations
    for v in vocab:
        en_trans = v.get('example_translation', v.get('translation_en', v.get('word', '')))
        v['_topic'] = infer_topic(en_trans, v.get('word', ''))
    
    # Group vocab by inferred topic
    by_topic = defaultdict(list)
    for v in vocab:
        by_topic[v['_topic']].append(v)
    
    print(f"  Topics found: {dict((k, len(v)) for k, v in sorted(by_topic.items()))}")
    
    # Define section ordering by topic priority
    topic_priority = ['greeting', 'introduction', 'feeling', 'people', 
                      'food_drink', 'time', 'number', 'home', 'clothing', 'color',
                      'place', 'transport', 'weather', 'health', 'shopping', 'grammar', 'general']
    
    section_keys = ['greetings', 'people', 'daily', 'food', 'places', 'time', 'descriptions', 'grammar']
    section_vocab = [[] for _ in section_keys]
    all_assigned = set()
    
    # Distribute topics across sections
    sec_topic_map = {sk: [] for sk in section_keys}
    for topic in topic_priority:
        if topic in by_topic:
            mapped_sec = TOPIC_SECTION_MAP.get(topic, 'general')
            if mapped_sec in sec_topic_map:
                sec_topic_map[mapped_sec].append(topic)
    
    # Assign words to sections based on topic
    for sec_key in section_keys:
        topics_for_sec = sec_topic_map.get(sec_key, [])
        for topic in topics_for_sec:
            for v in by_topic.get(topic, []):
                w = v.get('word', '').strip()
                if w and w not in all_assigned:
                    section_vocab[section_keys.index(sec_key)].append(w)
                    all_assigned.add(w)
    
    # Fill remaining slots
    remaining_words = [v.get('word','').strip() for v in vocab if v.get('word','').strip() not in all_assigned]
    random.shuffle(remaining_words)
    ri = 0
    for i in range(len(section_vocab)):
        while len(section_vocab[i]) < 40 and ri < len(remaining_words):
            w = remaining_words[ri]
            if w not in all_assigned:
                section_vocab[i].append(w)
                all_assigned.add(w)
            ri += 1
    
    # Build vocab translations dict (target → English) and (target → Chinese)
    vocab_trans = {}
    vocab_zh = {}
    for v in vocab:
        w = v.get('word', '').strip()
        if w:
            et = v.get('example_translation', '').strip()
            if not et:
                et = v.get('word', '')
            vocab_trans[w] = et
            zh = v.get('translation_zh', '').strip()
            if zh:
                vocab_zh[w] = zh
    
    all_vocab_words = [v.get('word','').strip() for v in vocab if v.get('word','').strip()]
    
    # Build course structure
    sections = []
    grammar_idx = 0
    
    for sec_i, sec_key in enumerate(section_keys):
        sec_words = section_vocab[sec_i]
        sec_title = SECTION_NAMES.get(sec_key, SECTION_NAMES['greetings'])
        
        lessons = []
        for les_i in range(5):
            # 8 words per lesson
            start_w = les_i * 8
            lesson_words = sec_words[start_w:start_w+8]
            if not lesson_words:
                break
            
            lesson_id = f'{lang_code}_l{sec_i*5 + les_i + 1:02d}'
            exercises = []
            ex_num = 0
            
            for wi, word in enumerate(lesson_words):
                ex_base = f'ex_{lesson_id}_{wi+1:02d}'
                word_sent_list = word_sents.get(word, [])
                trans_en = vocab_trans.get(word, word)
                trans_zh = vocab_zh.get(word, word)
                
                # FlashCard for EVERY word (fix: was only for words with Tatoeba)
                exercises.append(make_flashcard(word, trans_en, trans_zh, f'{ex_base}_01', lang_code))
                
                # Vocab multiple choice for EVERY word
                dist_words = [w for w in lesson_words if w != word]
                if len(dist_words) < 3:
                    dist_words = random.sample([w for w in all_vocab_words if w != word], min(3, len(all_vocab_words)-1))
                exercises.append({
                    'id': f'{ex_base}_02', 'type': 'vocabularyMultipleChoice',
                    'contentLang': lang_code, 'question': trans_zh if trans_zh else word,
                    'options': [word] + dist_words[:3],
                    'correctAnswer': word,
                    'explanation': make_word_explanation(word, trans_en, trans_zh)
                })
                
                # Sentence-based exercises (if Tatoeba available, else fallback)
                if word_sent_list:
                    sent_exs = make_sentence_exercises(word, word_sent_list, ex_base)
                    exercises.extend(sent_exs)
                # No Tatoeba sentence — skip fillInBlank for this word
            
            # Add matchPairs with native-language translations (Chinese as primary)
            mp_id = f'ex_{lesson_id}_mp'
            lesson_trans_native = {w: vocab_zh.get(w, vocab_trans.get(w, w)) for w in lesson_words}
            exercises.append(make_match_pairs(lesson_words, lesson_trans_native, mp_id))
            
            # Add 1 grammar exercise per lesson
            if grammar_idx < len(grammar):
                gp = grammar[grammar_idx]
                grammar_idx += 1
                gid = f'ex_{lesson_id}_gr'
                exercises.append(make_grammar_exercise(gp, gid))
            
            # Add listenAndType + imageIdentification for first word
            if lesson_words:
                w = lesson_words[0]
                exercises.append({
                    'id': f'ex_{lesson_id}_lt', 'type': 'listenAndType',
                    'contentLang': lang_code, 'question': '',                    'audioUrl': f'https://cdn.instalingo.app/audio/{lang_code}/{w.replace(" ","_")}.mp3',
                    'correctAnswer': w,
                    'explanation': make_word_explanation(w, vocab_trans.get(w,w), vocab_zh.get(w,w))
                })
                exercises.append({
                    'id': f'ex_{lesson_id}_im', 'type': 'imageIdentification',
                    'contentLang': lang_code, 'question': w,                    'options': lesson_words[:4],
                    'correctAnswer': w,
                    'imageUrl': f'https://cdn.instalingo.app/images/{lang_code}/{w.replace(" ","_")}.jpg'
                })
            
            # Deduplicate exercise IDs
            seen_eids = set()
            unique_exs = []
            for ex in exercises:
                if ex['id'] not in seen_eids:
                    seen_eids.add(ex['id'])
                    unique_exs.append(ex)
            
            # Limit to ~10 exercises per lesson
            # Reorder: mix FlashCards, matchPairs, vocabMC, grammar, sentence exercises
            fc = [e for e in unique_exs if e['type'] == 'flashCard']
            mp = [e for e in unique_exs if e['type'] == 'matchPairs']
            mc = [e for e in unique_exs if e['type'] == 'vocabularyMultipleChoice']
            gr = [e for e in unique_exs if e['type'] == 'grammarTip']
            other = [e for e in unique_exs if e['type'] not in ('flashCard','matchPairs','vocabularyMultipleChoice','grammarTip')]
            unique_exs = fc[:5] + mp + mc[:3] + gr + other
            unique_exs = unique_exs[:12]
            
            lesson_title = f'Lesson {les_i+1}'
            lesson_desc_simple = f'Learn: {", ".join(lesson_words[:3])}'
            
            lessons.append(OrderedDict([
                ('id', lesson_id),
                ('order', sec_i*5 + les_i + 1),
                ('xpReward', 10), ('gemsReward', 5),
                ('title', lt(lesson_title)),
                ('description', lt(lesson_desc_simple)),
                ('vocabulary', lesson_words),
                ('exercises', unique_exs)
            ]))
        
        sections.append(OrderedDict([
            ('id', f'{lang_code}_sec_{sec_i+1}'),
            ('order', sec_i+1),
            ('title', sec_title),
            ('lessons', lessons)
        ]))
    
    # Build course
    names = LANG_NAMES.get(lang_code, {'en': lang_code.upper()})
    desc_dict = COURSE_DESCRIPTIONS.get(lang_code, {})
    
    title_dict = {}
    subtitle_dict = {}
    beginner_tr = {'en': 'Beginner', 'zh': '初级', 'zh_TW': '初級', 'ko': '초급', 'ja': '初級', 'es': 'principiante', 'fr': 'débutant', 'de': 'Anfänger'}
    for l in ['en','zh','zh_TW','ko','ja','es','fr','de']:
        title_dict[l] = f"{names.get(l, lang_code)} A1"
        if l == 'en':
            subtitle_dict[l] = f"Beginner {names.get(l, lang_code)}"
        else:
            subtitle_dict[l] = f"{beginner_tr.get(l, '')} {names.get(l, lang_code)}"
    
    course = OrderedDict([
        ('id', f'{lang_code}_a1'),
        ('level', 'A1'),
        ('language', lang_code),
        ('totalLessons', sum(len(s['lessons']) for s in sections)),
        ('title', title_dict),
        ('subtitle', subtitle_dict),
        ('description', desc_dict if desc_dict else {'en': f'Learn {names.get("en", lang_code)} A1.'}),
        ('sections', sections)
    ])
    
    # Validate
    total_ex = sum(len(l['exercises']) for s in sections for l in s['lessons'])
    total_lessons = sum(len(s['lessons']) for s in sections)
    print(f"  Generated: {total_lessons} lessons, {total_ex} exercises")
    
    # Check for issues
    issues = []
    for sec in sections:
        for les in sec['lessons']:
            types = set(ex['type'] for ex in les['exercises'])
            if len(types) < 3:
                issues.append(f"{les['id']}: only {len(types)} exercise types")
            eids = [ex['id'] for ex in les['exercises']]
            if len(eids) != len(set(eids)):
                issues.append(f"{les['id']}: duplicate exercise IDs")
    
    if issues:
        print(f"  ⚠ {len(issues)} issues:")
        for i in issues[:5]:
            print(f"    - {i}")
    else:
        print(f"  ✅ No issues")
    
    return course


def course_to_dart(course, getter_name):
    """Convert course dict to Dart code string."""
    lines = []
    lines.append(f"  static Course get {getter_name} => const Course(")
    lines.append(f"    id: {safe_str(course['id'])},")
    lines.append(f"    title: {lt_to_dart_str(course['title'])},")
    lines.append(f"    subtitle: {lt_to_dart_str(course['subtitle'])},")
    lines.append(f"    description: {lt_to_dart_str(course['description'])},")
    lines.append(f"    level: '{course['level']}',")
    lines.append(f"    language: '{course['language']}',")
    lines.append(f"    totalLessons: {course['totalLessons']},")
    lines.append(f"    completedLessons: 0,")
    lines.append(f"    sections: const [")
    
    for sec in course['sections']:
        lines.append(f"      Section(")
        lines.append(f"        id: {safe_str(sec['id'])},")
        lines.append(f"        title: {lt_to_dart_str(sec['title'])},")
        lines.append(f"        order: {sec['order']},")
        lines.append(f"        lessons: const [")
        
        for i, les in enumerate(sec['lessons']):
            is_first = les['order'] == 1
            lines.append(f"          Lesson(")
            lines.append(f"            id: {safe_str(les['id'])},")
            lines.append(f"            title: {lt_to_dart_str(les['title'])},")
            lines.append(f"            description: {lt_to_dart_str(les['description'])},")
            lines.append(f"            order: {les['order']},")
            lines.append(f"            xpReward: 10,")
            lines.append(f"            gemsReward: 5,")
            lines.append(f"            vocabulary: const {safe_str(les['vocabulary'])},")
            lines.append(f"            exercises: const [")
            for ex in les['exercises']:
                lines.append(dart_exercise(ex))
            lines.append(f"            ],")
            lines.append(f"            isCompleted: false,")
            lines.append(f"            isLocked: {str(not is_first).lower()},")
            lines.append(f"            isCurrent: {str(is_first).lower()},")
            lines.append(f"          ),")
        
        lines.append(f"        ],")
        lines.append(f"      ),")
    
    lines.append(f"    ],")
    lines.append(f"  );")
    return '\n'.join(lines)


# ─── Main ─────────────────────────────────────────────────────────────

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--all', action='store_true')
    parser.add_argument('--lang', default='')
    args = parser.parse_args()
    
    lang_map = {
        'ko': 'koreanA1', 'ja': 'japaneseA1', 'fr': 'frenchA1',
        'es': 'spanishA1', 'zh': 'chineseA1', 'de': 'germanA1'
    }
    
    targets = LANGUAGES if args.all else ([args.lang] if args.lang else [])
    
    for lang_code in targets:
        course = build_course(lang_code)
        if course:
            # Save JSON
            json_path = OUT_DIR / f'{lang_code}_a1.json'
            with open(json_path, 'w', encoding='utf-8') as f:
                json.dump(course, f, ensure_ascii=False, indent=2)
            
            # Save Dart
            dart_code = course_to_dart(course, lang_map[lang_code])
            dart_path = OUT_DIR / f'{lang_code}_a1_course.dart'
            with open(dart_path, 'w', encoding='utf-8') as f:
                f.write('// Auto-generated from real Tatoeba + official vocab/grammar sources\n')
                f.write(f'// Language: {lang_code}\n')
                f.write(f'// Generated: 2026-05-27\n\n')
                f.write(dart_code)
            
            print(f"  Saved: {json_path.name} ({json_path.stat().st_size//1024} KB)")
            print(f"  Saved: {dart_path.name} ({dart_path.stat().st_size//1024} KB)")
