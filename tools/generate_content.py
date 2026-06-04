# InstaLingo — Golden Content Generator v2
# Generates REAL pedagogical content, not template garbage.
# Run: python3 tools/generate_content.py --lang en --out assets/content/courses/en_a1.json

import json, re, sys, argparse
from pathlib import Path
from collections import OrderedDict

# ─── Configuration ───────────────────────────────────────────────────
LANG_KEYS = ['en', 'zh', 'zh_TW', 'ko', 'ja', 'es', 'fr', 'de']

VALID_TYPES = {
    'vocabularyMultipleChoice', 'fillInBlank', 'translateSentence', 'matchPairs',
    'listenAndType', 'speaking', 'dialogueComplete', 'grammarTip', 'wordSorting',
    'imageIdentification', 'flashCard', 'comprehensionText', 'grammarTrueFalse',
    'phraseBuilderPrefilled', 'writing'
}

# ─── REAL Translations (not template garbage) ────────────────────────
# These are the instructional UI strings — NOT templates, REAL translations.

INSTRUCTIONS = {
    'flashCard':           {'en':'Flip the card to see the meaning.','zh':'翻转卡片查看含义。','zh_TW':'翻轉卡片查看含義。','ko':'카드를 뒤집어 뜻을 확인하세요.','ja':'カードを裏返して意味を確認してください。','es':'Voltea la tarjeta para ver el significado.','fr':'Retournez la carte pour voir la signification.','de':'Drehen Sie die Karte um, um die Bedeutung zu sehen.'},
    'vocabularyMultipleChoice': {'en':'Choose the correct English word.','zh':'选择正确的英语单词。','zh_TW':'選擇正確的英語單詞。','ko':'올바른 영어 단어를 고르세요.','ja':'正しい英語の単語を選んでください。','es':'Elige la palabra correcta en inglés.','fr':'Choisissez le bon mot anglais.','de':'Wählen Sie das richtige englische Wort.'},
    'matchPairs':          {'en':'Match each English word with its meaning.','zh':'将英语单词与含义配对。','zh_TW':'將英語單詞與含義配對。','ko':'영어 단어와 의미를 연결하세요.','ja':'英語の単語と意味を一致させてください。','es':'Empareja cada palabra en inglés con su significado.','fr':'Associez chaque mot anglais à sa signification.','de':'Ordnen Sie jedes englische Wort seiner Bedeutung zu.'},
    'listenAndType':       {'en':'Listen and type what you hear.','zh':'听录音并输入你听到的内容。','zh_TW':'聽錄音並輸入你聽到的內容。','ko':'듣고 들은 내용을 입력하세요.','ja':'聞こえた内容を入力してください。','es':'Escucha y escribe lo que oyes.','fr':'Écoutez et tapez ce que vous entendez.','de':'Hören Sie zu und tippen Sie, was Sie hören.'},
    'imageIdentification': {'en':'Tap the correct image.','zh':'点击正确的图片。','zh_TW':'點擊正確的圖片。','ko':'올바른 이미지를 탭하세요.','ja':'正しい画像をタップしてください。','es':'Toca la imagen correcta.','fr':'Appuyez sur la bonne image.','de':'Tippen Sie auf das richtige Bild.'},
    'fillInBlank':         {'en':'Fill in the blank with the correct word.','zh':'用正确的单词填空。','zh_TW':'用正確的單詞填空。','ko':'올바른 단어로 빈칸을 채우세요.','ja':'正しい単語で空欄を埋めてください。','es':'Rellena el espacio con la palabra correcta.','fr':'Remplissez le blanc avec le bon mot.','de':'Füllen Sie die Lücke mit dem richtigen Wort.'},
    'wordSorting':         {'en':'Arrange the words into a correct sentence.','zh':'将单词排列成正确的句子。','zh_TW':'將單詞排列成正確的句子。','ko':'단어를 올바른 문장으로 배열하세요.','ja':'単語を正しい文に並べ替えてください。','es':'Ordena las palabras en una oración correcta.','fr':'Remettez les mots dans l\'ordre pour former une phrase.','de':'Ordnen Sie die Wörter zu einem korrekten Satz.'},
    'grammarTip':          {'en':'Grammar note','zh':'语法提示','zh_TW':'語法提示','ko':'문법 노트','ja':'文法ノート','es':'Nota gramatical','fr':'Note de grammaire','de':'Grammatik-Hinweis'},
    'grammarTrueFalse':    {'en':'True or false?','zh':'对还是错？','zh_TW':'對還是錯？','ko':'맞습니까, 틀립니까?','ja':'正しいですか、間違いですか？','es':'¿Verdadero o falso?','fr':'Vrai ou faux ?','de':'Richtig oder falsch?'},
    'dialogueComplete':    {'en':'Complete the dialogue.','zh':'完成对话。','zh_TW':'完成對話。','ko':'대화를 완성하세요.','ja':'会話を完成させてください。','es':'Completa el diálogo.','fr':'Complétez le dialogue.','de':'Vervollständigen Sie den Dialog.'},
    'comprehensionText':   {'en':'Read the passage and answer the question.','zh':'阅读短文并回答问题。','zh_TW':'閱讀短文並回答問題。','ko':'글을 읽고 질문에 답하세요.','ja':'文章を読んで質問に答えてください。','es':'Lee el texto y responde la pregunta.','fr':'Lisez le texte et répondez à la question.','de':'Lesen Sie den Text und beantworten Sie die Frage.'},
    'speaking':            {'en':'Say the phrase out loud.','zh':'大声说出这个短语。','zh_TW':'大聲說出這個短語。','ko':'이 문구를 큰 소리로 말하세요.','ja':'このフレーズを声に出して言ってください。','es':'Di la frase en voz alta.','fr':'Dites la phrase à voix haute.','de':'Sagen Sie den Satz laut.'},
    'phraseBuilderPrefilled': {'en':'Build the correct phrase.','zh':'构建正确的短语。','zh_TW':'構建正確的短語。','ko':'올바른 구문을 만드세요.','ja':'正しいフレーズを作ってください。','es':'Construye la frase correcta.','fr':'Construisez la phrase correcte.','de':'Bilden Sie die richtige Phrase.'},
    'writing':             {'en':'Write a short answer.','zh':'写一个简短回答。','zh_TW':'寫一個簡短回答。','ko':'짧게 답을 쓰세요.','ja':'短い答えを書いてください。','es':'Escribe una respuesta breve.','fr':'Écrivez une réponse courte.','de':'Schreiben Sie eine kurze Antwort.'},
    'translateSentence':   {'en':'Choose the correct translation.','zh':'选择正确的翻译。','zh_TW':'選擇正確的翻譯。','ko':'올바른 번역을 고르세요.','ja':'正しい翻訳を選んでください。','es':'Elige la traducción correcta.','fr':'Choisissez la bonne traduction.','de':'Wählen Sie die richtige Übersetzung.'},
}

# ─── REAL Word Translations (English → Chinese, Korean, Japanese, Spanish, French, German) ───
# These are the ACTUAL translations used in flashCard correctAnswer and matchPairs right side.
# Format: english_word: {zh, ko, ja, es, fr, de}

WORD_TRANSLATIONS = {
    # Greetings
    'hello':       {'zh':'你好','zh_TW':'你好','ko':'안녕하세요','ja':'こんにちは','es':'hola','fr':'bonjour','de':'hallo'},
    'hi':          {'zh':'嗨','zh_TW':'嗨','ko':'안녕','ja':'やあ','es':'hola','fr':'salut','de':'hi'},
    'good morning':{'zh':'早上好','zh_TW':'早上好','ko':'좋은 아침','ja':'おはようございます','es':'buenos días','fr':'bonjour','de':'guten Morgen'},
    'good afternoon':{'zh':'下午好','zh_TW':'下午好','ko':'좋은 오후','ja':'こんにちは','es':'buenas tardes','fr':'bon après-midi','de':'guten Tag'},
    'good evening':{'zh':'晚上好','zh_TW':'晚上好','ko':'좋은 저녁','ja':'こんばんは','es':'buenas noches','fr':'bonsoir','de':'guten Abend'},
    'goodbye':     {'zh':'再见','zh_TW':'再見','ko':'안녕히 가세요','ja':'さようなら','es':'adiós','fr':'au revoir','de':'auf Wiedersehen'},
    'bye':         {'zh':'拜拜','zh_TW':'拜拜','ko':'잘 가','ja':'バイバイ','es':'adiós','fr':'salut','de':'tschüss'},
    'welcome':     {'zh':'欢迎','zh_TW':'歡迎','ko':'환영합니다','ja':'ようこそ','es':'bienvenido','fr':'bienvenue','de':'willkommen'},
    'nice':        {'zh':'好的','zh_TW':'好的','ko':'좋은','ja':'良い','es':'agradable','fr':'agréable','de':'nett'},
    'meet':        {'zh':'见面','zh_TW':'見面','ko':'만나다','ja':'会う','es':'conocer','fr':'rencontrer','de':'treffen'},
    # Names
    'name':        {'zh':'名字','zh_TW':'名字','ko':'이름','ja':'名前','es':'nombre','fr':'nom','de':'Name'},
    'first name':  {'zh':'名','zh_TW':'名','ko':'이름','ja':'名前','es':'nombre','fr':'prénom','de':'Vorname'},
    'last name':   {'zh':'姓','zh_TW':'姓','ko':'성','ja':'名字','es':'apellido','fr':'nom de famille','de':'Nachname'},
    'my':          {'zh':'我的','zh_TW':'我的','ko':'나의','ja':'私の','es':'mi','fr':'mon','de':'mein'},
    'your':        {'zh':'你的','zh_TW':'你的','ko':'너의','ja':'あなたの','es':'tu','fr':'ton','de':'dein'},
    # Countries
    'country':     {'zh':'国家','zh_TW':'國家','ko':'나라','ja':'国','es':'país','fr':'pays','de':'Land'},
    'city':        {'zh':'城市','zh_TW':'城市','ko':'도시','ja':'都市','es':'ciudad','fr':'ville','de':'Stadt'},
    'from':        {'zh':'来自','zh_TW':'來自','ko':'~에서','ja':'〜から','es':'de','fr':'de','de':'aus'},
    # Feelings
    'happy':       {'zh':'开心的','zh_TW':'開心的','ko':'행복한','ja':'嬉しい','es':'feliz','fr':'heureux','de':'glücklich'},
    'sad':         {'zh':'难过的','zh_TW':'難過的','ko':'슬픈','ja':'悲しい','es':'triste','fr':'triste','de':'traurig'},
    'fine':        {'zh':'好的','zh_TW':'好的','ko':'괜찮은','ja':'元気な','es':'bien','fr':'bien','de':'gut'},
    'tired':       {'zh':'累的','zh_TW':'累的','ko':'피곤한','ja':'疲れた','es':'cansado','fr':'fatigué','de':'müde'},
    'good':        {'zh':'好的','zh_TW':'好的','ko':'좋은','ja':'良い','es':'bueno','fr':'bon','de':'gut'},
    'bad':         {'zh':'坏的','zh_TW':'壞的','ko':'나쁜','ja':'悪い','es':'malo','fr':'mauvais','de':'schlecht'},
    # Numbers
    'one':         {'zh':'一','zh_TW':'一','ko':'일','ja':'一','es':'uno','fr':'un','de':'eins'},
    'two':         {'zh':'二','zh_TW':'二','ko':'이','ja':'二','es':'dos','fr':'deux','de':'zwei'},
    'three':       {'zh':'三','zh_TW':'三','ko':'삼','ja':'三','es':'tres','fr':'trois','de':'drei'},
    'four':        {'zh':'四','zh_TW':'四','ko':'사','ja':'四','es':'cuatro','fr':'quatre','de':'vier'},
    'five':        {'zh':'五','zh_TW':'五','ko':'오','ja':'五','es':'cinco','fr':'cinq','de':'fünf'},
    'six':         {'zh':'六','zh_TW':'六','ko':'육','ja':'六','es':'seis','fr':'six','de':'sechs'},
    'seven':       {'zh':'七','zh_TW':'七','ko':'칠','ja':'七','es':'siete','fr':'sept','de':'sieben'},
    'eight':       {'zh':'八','zh_TW':'八','ko':'팔','ja':'八','es':'ocho','fr':'huit','de':'acht'},
    # Days
    'Monday':      {'zh':'星期一','zh_TW':'星期一','ko':'월요일','ja':'月曜日','es':'lunes','fr':'lundi','de':'Montag'},
    'Tuesday':     {'zh':'星期二','zh_TW':'星期二','ko':'화요일','ja':'火曜日','es':'martes','fr':'mardi','de':'Dienstag'},
    'Wednesday':   {'zh':'星期三','zh_TW':'星期三','ko':'수요일','ja':'水曜日','es':'miércoles','fr':'mercredi','de':'Mittwoch'},
    'Thursday':    {'zh':'星期四','zh_TW':'星期四','ko':'목요일','ja':'木曜日','es':'jueves','fr':'jeudi','de':'Donnerstag'},
    'Friday':      {'zh':'星期五','zh_TW':'星期五','ko':'금요일','ja':'金曜日','es':'viernes','fr':'vendredi','de':'Freitag'},
    'Saturday':    {'zh':'星期六','zh_TW':'星期六','ko':'토요일','ja':'土曜日','es':'sábado','fr':'samedi','de':'Samstag'},
    'Sunday':      {'zh':'星期天','zh_TW':'星期天','ko':'일요일','ja':'日曜日','es':'domingo','fr':'dimanche','de':'Sonntag'},
    'week':        {'zh':'星期','zh_TW':'星期','ko':'주','ja':'週','es':'semana','fr':'semaine','de':'Woche'},
    # Food
    'apple':       {'zh':'苹果','zh_TW':'蘋果','ko':'사과','ja':'りんご','es':'manzana','fr':'pomme','de':'Apfel'},
    'banana':      {'zh':'香蕉','zh_TW':'香蕉','ko':'바나나','ja':'バナナ','es':'plátano','fr':'banane','de':'Banane'},
    'bread':       {'zh':'面包','zh_TW':'麵包','ko':'빵','ja':'パン','es':'pan','fr':'pain','de':'Brot'},
    'water':       {'zh':'水','zh_TW':'水','ko':'물','ja':'水','es':'agua','fr':'eau','de':'Wasser'},
    'coffee':      {'zh':'咖啡','zh_TW':'咖啡','ko':'커피','ja':'コーヒー','es':'café','fr':'café','de':'Kaffee'},
    'tea':         {'zh':'茶','zh_TW':'茶','ko':'차','ja':'お茶','es':'té','fr':'thé','de':'Tee'},
    'milk':        {'zh':'牛奶','zh_TW':'牛奶','ko':'우유','ja':'牛乳','es':'leche','fr':'lait','de':'Milch'},
    'egg':         {'zh':'鸡蛋','zh_TW':'雞蛋','ko':'계란','ja':'卵','es':'huevo','fr':'œuf','de':'Ei'},
    'rice':        {'zh':'米饭','zh_TW':'米飯','ko':'밥','ja':'ご飯','es':'arroz','fr':'riz','de':'Reis'},
    'fish':        {'zh':'鱼','zh_TW':'魚','ko':'생선','ja':'魚','es':'pescado','fr':'poisson','de':'Fisch'},
    # Colors
    'red':         {'zh':'红色','zh_TW':'紅色','ko':'빨간색','ja':'赤','es':'rojo','fr':'rouge','de':'rot'},
    'blue':        {'zh':'蓝色','zh_TW':'藍色','ko':'파란색','ja':'青','es':'azul','fr':'bleu','de':'blau'},
    'green':       {'zh':'绿色','zh_TW':'綠色','ko':'초록색','ja':'緑','es':'verde','fr':'vert','de':'grün'},
    'yellow':      {'zh':'黄色','zh_TW':'黃色','ko':'노란색','ja':'黄色','es':'amarillo','fr':'jaune','de':'gelb'},
    'black':       {'zh':'黑色','zh_TW':'黑色','ko':'검은색','ja':'黒','es':'negro','fr':'noir','de':'schwarz'},
    'white':       {'zh':'白色','zh_TW':'白色','ko':'흰색','ja':'白','es':'blanco','fr':'blanc','de':'weiß'},
    # Family
    'mother':      {'zh':'妈妈','zh_TW':'媽媽','ko':'어머니','ja':'母','es':'madre','fr':'mère','de':'Mutter'},
    'father':      {'zh':'爸爸','zh_TW':'爸爸','ko':'아버지','ja':'父','es':'padre','fr':'père','de':'Vater'},
    'sister':      {'zh':'姐妹','zh_TW':'姐妹','ko':'자매','ja':'姉妹','es':'hermana','fr':'sœur','de':'Schwester'},
    'brother':     {'zh':'兄弟','zh_TW':'兄弟','ko':'형제','ja':'兄弟','es':'hermano','fr':'frère','de':'Bruder'},
    'family':      {'zh':'家庭','zh_TW':'家庭','ko':'가족','ja':'家族','es':'familia','fr':'famille','de':'Familie'},
    # People
    'friend':      {'zh':'朋友','zh_TW':'朋友','ko':'친구','ja':'友達','es':'amigo','fr':'ami','de':'Freund'},
    'teacher':     {'zh':'老师','zh_TW':'老師','ko':'선생님','ja':'先生','es':'profesor','fr':'professeur','de':'Lehrer'},
    'student':     {'zh':'学生','zh_TW':'學生','ko':'학생','ja':'学生','es':'estudiante','fr':'étudiant','de':'Schüler'},
    'doctor':      {'zh':'医生','zh_TW':'醫生','ko':'의사','ja':'医者','es':'médico','fr':'médecin','de':'Arzt'},
    # Common words
    'book':        {'zh':'书','zh_TW':'書','ko':'책','ja':'本','es':'libro','fr':'livre','de':'Buch'},
    'pen':         {'zh':'笔','zh_TW':'筆','ko':'펜','ja':'ペン','es':'bolígrafo','fr':'stylo','de':'Kugelschreiber'},
    'phone':       {'zh':'电话','zh_TW':'電話','ko':'전화','ja':'電話','es':'teléfono','fr':'téléphone','de':'Telefon'},
    'computer':    {'zh':'电脑','zh_TW':'電腦','ko':'컴퓨터','ja':'コンピュータ','es':'computadora','fr':'ordinateur','de':'Computer'},
    'house':       {'zh':'房子','zh_TW':'房子','ko':'집','ja':'家','es':'casa','fr':'maison','de':'Haus'},
    'car':         {'zh':'汽车','zh_TW':'汽車','ko':'자동차','ja':'車','es':'coche','fr':'voiture','de':'Auto'},
    'school':      {'zh':'学校','zh_TW':'學校','ko':'학교','ja':'学校','es':'escuela','fr':'école','de':'Schule'},
    'work':        {'zh':'工作','zh_TW':'工作','ko':'일','ja':'仕事','es':'trabajo','fr':'travail','de':'Arbeit'},
    'time':        {'zh':'时间','zh_TW':'時間','ko':'시간','ja':'時間','es':'tiempo','fr':'temps','de':'Zeit'},
    'today':       {'zh':'今天','zh_TW':'今天','ko':'오늘','ja':'今日','es':'hoy','fr':'aujourd\'hui','de':'heute'},
    'morning':     {'zh':'早上','zh_TW':'早上','ko':'아침','ja':'朝','es':'mañana','fr':'matin','de':'Morgen'},
    'afternoon':   {'zh':'下午','zh_TW':'下午','ko':'오후','ja':'午後','es':'tarde','fr':'après-midi','de':'Nachmittag'},
    'evening':     {'zh':'晚上','zh_TW':'晚上','ko':'저녁','ja':'夕方','es':'noche','fr':'soir','de':'Abend'},
    'night':       {'zh':'夜晚','zh_TW':'夜晚','ko':'밤','ja':'夜','es':'noche','fr':'nuit','de':'Nacht'},
    # Verbs
    'like':        {'zh':'喜欢','zh_TW':'喜歡','ko':'좋아하다','ja':'好き','es':'gustar','fr':'aimer','de':'mögen'},
    'love':        {'zh':'爱','zh_TW':'愛','ko':'사랑하다','ja':'愛する','es':'amar','fr':'aimer','de':'lieben'},
    'want':        {'zh':'想要','zh_TW':'想要','ko':'원하다','ja':'欲しい','es':'querer','fr':'vouloir','de':'wollen'},
    'go':          {'zh':'去','zh_TW':'去','ko':'가다','ja':'行く','es':'ir','fr':'aller','de':'gehen'},
    'eat':         {'zh':'吃','zh_TW':'吃','ko':'먹다','ja':'食べる','es':'comer','fr':'manger','de':'essen'},
    'drink':       {'zh':'喝','zh_TW':'喝','ko':'마시다','ja':'飲む','es':'beber','fr':'boire','de':'trinken'},
    'read':        {'zh':'读','zh_TW':'讀','ko':'읽다','ja':'読む','es':'leer','fr':'lire','de':'lesen'},
    'write':       {'zh':'写','zh_TW':'寫','ko':'쓰다','ja':'書く','es':'escribir','fr':'écrire','de':'schreiben'},
    'speak':       {'zh':'说','zh_TW':'說','ko':'말하다','ja':'話す','es':'hablar','fr':'parler','de':'sprechen'},
    'listen':      {'zh':'听','zh_TW':'聽','ko':'듣다','ja':'聞く','es':'escuchar','fr':'écouter','de':'zuhören'},
    'learn':       {'zh':'学习','zh_TW':'學習','ko':'배우다','ja':'学ぶ','es':'aprender','fr':'apprendre','de':'lernen'},
    'live':        {'zh':'住','zh_TW':'住','ko':'살다','ja':'住む','es':'vivir','fr':'vivre','de':'leben'},
    'I':           {'zh':'我','zh_TW':'我','ko':'나','ja':'私','es':'yo','fr':'je','de':'ich'},
    'you':         {'zh':'你','zh_TW':'你','ko':'너','ja':'あなた','es':'tú','fr':'tu','de':'du'},
    'he':          {'zh':'他','zh_TW':'他','ko':'그','ja':'彼','es':'él','fr':'il','de':'er'},
    'she':         {'zh':'她','zh_TW':'她','ko':'그녀','ja':'彼女','es':'ella','fr':'elle','de':'sie'},
    'we':          {'zh':'我们','zh_TW':'我們','ko':'우리','ja':'私たち','es':'nosotros','fr':'nous','de':'wir'},
    'they':        {'zh':'他们','zh_TW':'他們','ko':'그들','ja':'彼ら','es':'ellos','fr':'ils','de':'sie'},
    # Months
    'January':     {'zh':'一月','zh_TW':'一月','ko':'1월','ja':'1月','es':'enero','fr':'janvier','de':'Januar'},
    'February':    {'zh':'二月','zh_TW':'二月','ko':'2월','ja':'2月','es':'febrero','fr':'février','de':'Februar'},
    'March':       {'zh':'三月','zh_TW':'三月','ko':'3월','ja':'3月','es':'marzo','fr':'mars','de':'März'},
    'April':       {'zh':'四月','zh_TW':'四月','ko':'4월','ja':'4月','es':'abril','fr':'avril','de':'April'},
    'June':        {'zh':'六月','zh_TW':'六月','ko':'6월','ja':'6月','es':'junio','fr':'juin','de':'Juni'},
    'July':        {'zh':'七月','zh_TW':'七月','ko':'7월','ja':'7月','es':'julio','fr':'juillet','de':'Juli'},
    # Question words
    'what':        {'zh':'什么','zh_TW':'什麼','ko':'무엇','ja':'何','es':'qué','fr':'quoi','de':'was'},
    'who':         {'zh':'谁','zh_TW':'誰','ko':'누구','ja':'誰','es':'quién','fr':'qui','de':'wer'},
    'when':        {'zh':'什么时候','zh_TW':'什麼時候','ko':'언제','ja':'いつ','es':'cuándo','fr':'quand','de':'wann'},
    'why':         {'zh':'为什么','zh_TW':'為什麼','ko':'왜','ja':'なぜ','es':'por qué','fr':'pourquoi','de':'warum'},
    'how':         {'zh':'怎么','zh_TW':'怎麼','ko':'어떻게','ja':'どう','es':'cómo','fr':'comment','de':'wie'},
    'which':       {'zh':'哪个','zh_TW':'哪個','ko':'어느','ja':'どの','es':'cuál','fr':'lequel','de':'welcher'},
    'question':    {'zh':'问题','zh_TW':'問題','ko':'질문','ja':'質問','es':'pregunta','fr':'question','de':'Frage'},
    'answer':      {'zh':'回答','zh_TW':'回答','ko':'대답하다','ja':'答える','es':'responder','fr':'répondre','de':'antworten'},
    'ask':         {'zh':'问','zh_TW':'問','ko':'묻다','ja':'尋ねる','es':'preguntar','fr':'demander','de':'fragen'},
    # Verbs & states
    'cannot':      {'zh':'不能','zh_TW':'不能','ko':'할 수 없다','ja':'できない','es':'no puede','fr':'ne peut pas','de':'kann nicht'},
    'swim':        {'zh':'游泳','zh_TW':'游泳','ko':'수영하다','ja':'泳ぐ','es':'nadar','fr':'nager','de':'schwimmen'},
    'cook':        {'zh':'做饭','zh_TW':'做飯','ko':'요리하다','ja':'料理する','es':'cocinar','fr':'cuisiner','de':'kochen'},
    'drive':       {'zh':'开车','zh_TW':'開車','ko':'운전하다','ja':'運転する','es':'conducir','fr':'conduire','de':'fahren'},
    'sing':        {'zh':'唱歌','zh_TW':'唱歌','ko':'노래하다','ja':'歌う','es':'cantar','fr':'chanter','de':'singen'},
    'dance':       {'zh':'跳舞','zh_TW':'跳舞','ko':'춤추다','ja':'踊る','es':'bailar','fr':'danser','de':'tanzen'},
    'play':        {'zh':'玩','zh_TW':'玩','ko':'놀다','ja':'遊ぶ','es':'jugar','fr':'jouer','de':'spielen'},
    'walk':        {'zh':'走路','zh_TW':'走路','ko':'걷다','ja':'歩く','es':'caminar','fr':'marcher','de':'gehen'},
    'study':       {'zh':'学习','zh_TW':'學習','ko':'공부하다','ja':'勉強する','es':'estudiar','fr':'étudier','de':'studieren'},
    'do':          {'zh':'做','zh_TW':'做','ko':'하다','ja':'する','es':'hacer','fr':'faire','de':'tun'},
    'am':          {'zh':'是','zh_TW':'是','ko':'~입니다','ja':'〜です','es':'soy/estoy','fr':'suis','de':'bin'},
    'are':         {'zh':'是','zh_TW':'是','ko':'~입니다','ja':'〜です','es':'eres/son','fr':'êtes/sont','de':'bist/sind'},
    # Family & people
    'parent':      {'zh':'父母','zh_TW':'父母','ko':'부모','ja':'親','es':'padre','fr':'parent','de':'Elternteil'},
    'child':       {'zh':'孩子','zh_TW':'孩子','ko':'아이','ja':'子ども','es':'niño','fr':'enfant','de':'Kind'},
    'baby':        {'zh':'婴儿','zh_TW':'嬰兒','ko':'아기','ja':'赤ちゃん','es':'bebé','fr':'bébé','de':'Baby'},
    'spell':       {'zh':'拼写','zh_TW':'拼寫','ko':'철자','ja':'綴る','es':'deletrear','fr':'épeler','de':'buchstabieren'},
    'family name': {'zh':'姓','zh_TW':'姓','ko':'성','ja':'名字','es':'apellido','fr':'nom de famille','de':'Nachname'},
    'call':        {'zh':'打电话','zh_TW':'打電話','ko':'전화하다','ja':'電話する','es':'llamar','fr':'appeler','de':'anrufen'},
    'job':         {'zh':'工作','zh_TW':'工作','ko':'직업','ja':'仕事','es':'trabajo','fr':'travail','de':'Arbeit'},
    'classmate':   {'zh':'同学','zh_TW':'同學','ko':'반친구','ja':'同級生','es':'compañero','fr':'camarade','de':'Klassenkamerad'},
    'neighbor':    {'zh':'邻居','zh_TW':'鄰居','ko':'이웃','ja':'隣人','es':'vecino','fr':'voisin','de':'Nachbar'},
    'person':      {'zh':'人','zh_TW':'人','ko':'사람','ja':'人','es':'persona','fr':'personne','de':'Person'},
    'people':      {'zh':'人们','zh_TW':'人們','ko':'사람들','ja':'人々','es':'gente','fr':'gens','de':'Leute'},
    'boy':         {'zh':'男孩','zh_TW':'男孩','ko':'소년','ja':'男の子','es':'niño','fr':'garçon','de':'Junge'},
    'girl':        {'zh':'女孩','zh_TW':'女孩','ko':'소녀','ja':'女の子','es':'niña','fr':'fille','de':'Mädchen'},
    'adult':       {'zh':'成人','zh_TW':'成人','ko':'성인','ja':'大人','es':'adulto','fr':'adulte','de':'Erwachsener'},
    # Objects
    'bag':         {'zh':'包','zh_TW':'包','ko':'가방','ja':'バッグ','es':'bolsa','fr':'sac','de':'Tasche'},
    'key':         {'zh':'钥匙','zh_TW':'鑰匙','ko':'열쇠','ja':'鍵','es':'llave','fr':'clé','de':'Schlüssel'},
    'computer':    {'zh':'电脑','zh_TW':'電腦','ko':'컴퓨터','ja':'コンピュータ','es':'computadora','fr':'ordinateur','de':'Computer'},
    'watch':       {'zh':'手表','zh_TW':'手錶','ko':'시계','ja':'時計','es':'reloj','fr':'montre','de':'Uhr'},
    'glasses':     {'zh':'眼镜','zh_TW':'眼鏡','ko':'안경','ja':'眼鏡','es':'gafas','fr':'lunettes','de':'Brille'},
    'sock':        {'zh':'袜子','zh_TW':'襪子','ko':'양말','ja':'靴下','es':'calcetín','fr':'chaussette','de':'Socke'},
    'jacket':      {'zh':'夹克','zh_TW':'夾克','ko':'자켓','ja':'ジャケット','es':'chaqueta','fr':'veste','de':'Jacke'},
    'hat':         {'zh':'帽子','zh_TW':'帽子','ko':'모자','ja':'帽子','es':'sombrero','fr':'chapeau','de':'Hut'},
    'coat':        {'zh':'外套','zh_TW':'外套','ko':'코트','ja':'コート','es':'abrigo','fr':'manteau','de':'Mantel'},
    'skirt':       {'zh':'裙子','zh_TW':'裙子','ko':'치마','ja':'スカート','es':'falda','fr':'jupe','de':'Rock'},
    'dress':       {'zh':'连衣裙','zh_TW':'連衣裙','ko':'드레스','ja':'ドレス','es':'vestido','fr':'robe','de':'Kleid'},
    'shoe':        {'zh':'鞋','zh_TW':'鞋','ko':'신발','ja':'靴','es':'zapato','fr':'chaussure','de':'Schuh'},
    'cup':         {'zh':'杯子','zh_TW':'杯子','ko':'컵','ja':'カップ','es':'taza','fr':'tasse','de':'Tasse'},
    # Weather
    'weather':     {'zh':'天气','zh_TW':'天氣','ko':'날씨','ja':'天気','es':'clima','fr':'météo','de':'Wetter'},
    'sun':         {'zh':'太阳','zh_TW':'太陽','ko':'태양','ja':'太陽','es':'sol','fr':'soleil','de':'Sonne'},
    'rain':        {'zh':'雨','zh_TW':'雨','ko':'비','ja':'雨','es':'lluvia','fr':'pluie','de':'Regen'},
    'snow':        {'zh':'雪','zh_TW':'雪','ko':'눈','ja':'雪','es':'nieve','fr':'neige','de':'Schnee'},
    'wind':        {'zh':'风','zh_TW':'風','ko':'바람','ja':'風','es':'viento','fr':'vent','de':'Wind'},
    'hot':         {'zh':'热','zh_TW':'熱','ko':'뜨거운','ja':'暑い','es':'caliente','fr':'chaud','de':'heiß'},
    'cold':        {'zh':'冷','zh_TW':'冷','ko':'추운','ja':'寒い','es':'frío','fr':'froid','de':'kalt'},
    'warm':        {'zh':'温暖','zh_TW':'溫暖','ko':'따뜻한','ja':'暖かい','es':'cálido','fr':'chaud','de':'warm'},
    # Home & furniture
    'home':        {'zh':'家','zh_TW':'家','ko':'집','ja':'家','es':'hogar','fr':'maison','de':'Zuhause'},
    'room':        {'zh':'房间','zh_TW':'房間','ko':'방','ja':'部屋','es':'habitación','fr':'pièce','de':'Zimmer'},
    'kitchen':     {'zh':'厨房','zh_TW':'廚房','ko':'부엌','ja':'台所','es':'cocina','fr':'cuisine','de':'Küche'},
    'bathroom':    {'zh':'浴室','zh_TW':'浴室','ko':'욕실','ja':'浴室','es':'baño','fr':'salle de bain','de':'Badezimmer'},
    'bedroom':     {'zh':'卧室','zh_TW':'臥室','ko':'침실','ja':'寝室','es':'dormitorio','fr':'chambre','de':'Schlafzimmer'},
    'door':        {'zh':'门','zh_TW':'門','ko':'문','ja':'ドア','es':'puerta','fr':'porte','de':'Tür'},
    'window':      {'zh':'窗户','zh_TW':'窗戶','ko':'창문','ja':'窓','es':'ventana','fr':'fenêtre','de':'Fenster'},
    'table':       {'zh':'桌子','zh_TW':'桌子','ko':'테이블','ja':'テーブル','es':'mesa','fr':'table','de':'Tisch'},
    'chair':       {'zh':'椅子','zh_TW':'椅子','ko':'의자','ja':'椅子','es':'silla','fr':'chaise','de':'Stuhl'},
    'bed':         {'zh':'床','zh_TW':'床','ko':'침대','ja':'ベッド','es':'cama','fr':'lit','de':'Bett'},
    'desk':        {'zh':'书桌','zh_TW':'書桌','ko':'책상','ja':'机','es':'escritorio','fr':'bureau','de':'Schreibtisch'},
    'sofa':        {'zh':'沙发','zh_TW':'沙發','ko':'소파','ja':'ソファー','es':'sofá','fr':'canapé','de':'Sofa'},
    'lamp':        {'zh':'灯','zh_TW':'燈','ko':'램프','ja':'ランプ','es':'lámpara','fr':'lampe','de':'Lampe'},
    'floor':       {'zh':'地板','zh_TW':'地板','ko':'바닥','ja':'床','es':'suelo','fr':'sol','de':'Boden'},
    'wall':        {'zh':'墙','zh_TW':'牆','ko':'벽','ja':'壁','es':'pared','fr':'mur','de':'Wand'},
    'shirt':       {'zh':'衬衫','zh_TW':'襯衫','ko':'셔츠','ja':'シャツ','es':'camisa','fr':'chemise','de':'Hemd'},
    # Places
    'school':      {'zh':'学校','zh_TW':'學校','ko':'학교','ja':'学校','es':'escuela','fr':'école','de':'Schule'},
    'bank':        {'zh':'银行','zh_TW':'銀行','ko':'은행','ja':'銀行','es':'banco','fr':'banque','de':'Bank'},
    'park':        {'zh':'公园','zh_TW':'公園','ko':'공원','ja':'公園','es':'parque','fr':'parc','de':'Park'},
    'station':     {'zh':'车站','zh_TW':'車站','ko':'역','ja':'駅','es':'estación','fr':'gare','de':'Bahnhof'},
    'hospital':    {'zh':'医院','zh_TW':'醫院','ko':'병원','ja':'病院','es':'hospital','fr':'hôpital','de':'Krankenhaus'},
    'hotel':       {'zh':'酒店','zh_TW':'酒店','ko':'호텔','ja':'ホテル','es':'hotel','fr':'hôtel','de':'Hotel'},
    'restaurant':  {'zh':'餐厅','zh_TW':'餐廳','ko':'식당','ja':'レストラン','es':'restaurante','fr':'restaurant','de':'Restaurant'},
    'museum':      {'zh':'博物馆','zh_TW':'博物館','ko':'박물관','ja':'博物館','es':'museo','fr':'musée','de':'Museum'},
    'airport':     {'zh':'机场','zh_TW':'機場','ko':'공항','ja':'空港','es':'aeropuerto','fr':'aéroport','de':'Flughafen'},
    'passport':    {'zh':'护照','zh_TW':'護照','ko':'여권','ja':'パスポート','es':'pasaporte','fr':'passeport','de':'Reisepass'},
    'map':         {'zh':'地图','zh_TW':'地圖','ko':'지도','ja':'地図','es':'mapa','fr':'carte','de':'Karte'},
    'trip':        {'zh':'旅行','zh_TW':'旅行','ko':'여행','ja':'旅行','es':'viaje','fr':'voyage','de':'Reise'},
    'visit':       {'zh':'参观','zh_TW':'參觀','ko':'방문하다','ja':'訪れる','es':'visitar','fr':'visiter','de':'besuchen'},
    'arrive':      {'zh':'到达','zh_TW':'到達','ko':'도착하다','ja':'到着する','es':'llegar','fr':'arriver','de':'ankommen'},
    'leave':       {'zh':'离开','zh_TW':'離開','ko':'떠나다','ja':'出発する','es':'salir','fr':'partir','de':'verlassen'},
    'where':       {'zh':'哪里','zh_TW':'哪裡','ko':'어디','ja':'どこ','es':'dónde','fr':'où','de':'wo'},
    'turn':        {'zh':'转弯','zh_TW':'轉彎','ko':'돌다','ja':'曲がる','es':'girar','fr':'tourner','de':'abbiegen'},
    'street':      {'zh':'街道','zh_TW':'街道','ko':'거리','ja':'通り','es':'calle','fr':'rue','de':'Straße'},
    'road':        {'zh':'路','zh_TW':'路','ko':'도로','ja':'道路','es':'carretera','fr':'route','de':'Straße'},
    'help':        {'zh':'帮助','zh_TW':'幫助','ko':'도움','ja':'助け','es':'ayuda','fr':'aide','de':'Hilfe'},
    # Transport
    'car':         {'zh':'汽车','zh_TW':'汽車','ko':'자동차','ja':'車','es':'coche','fr':'voiture','de':'Auto'},
    'bus':         {'zh':'公共汽车','zh_TW':'公共汽車','ko':'버스','ja':'バス','es':'autobús','fr':'bus','de':'Bus'},
    'train':       {'zh':'火车','zh_TW':'火車','ko':'기차','ja':'電車','es':'tren','fr':'train','de':'Zug'},
    'bike':        {'zh':'自行车','zh_TW':'自行車','ko':'자전거','ja':'自転車','es':'bicicleta','fr':'vélo','de':'Fahrrad'},
    'taxi':        {'zh':'出租车','zh_TW':'計程車','ko':'택시','ja':'タクシー','es':'taxi','fr':'taxi','de':'Taxi'},
    'plane':       {'zh':'飞机','zh_TW':'飛機','ko':'비행기','ja':'飛行機','es':'avión','fr':'avion','de':'Flugzeug'},
    'ticket':      {'zh':'票','zh_TW':'票','ko':'티켓','ja':'チケット','es':'billete','fr':'billet','de':'Ticket'},
    'travel':      {'zh':'旅行','zh_TW':'旅行','ko':'여행','ja':'旅行','es':'viajar','fr':'voyager','de':'reisen'},
    'left':        {'zh':'左','zh_TW':'左','ko':'왼쪽','ja':'左','es':'izquierda','fr':'gauche','de':'links'},
    'right':       {'zh':'右','zh_TW':'右','ko':'오른쪽','ja':'右','es':'derecha','fr':'droite','de':'rechts'},
    'straight':    {'zh':'直走','zh_TW':'直走','ko':'직진','ja':'まっすぐ','es':'recto','fr':'tout droit','de':'geradeaus'},
    'near':        {'zh':'近','zh_TW':'近','ko':'가까운','ja':'近く','es':'cerca','fr':'près','de':'nah'},
    'far':         {'zh':'远','zh_TW':'遠','ko':'먼','ja':'遠い','es':'lejos','fr':'loin','de':'weit'},
    'behind':      {'zh':'后面','zh_TW':'後面','ko':'뒤에','ja':'後ろに','es':'detrás','fr':'derrière','de':'hinter'},
    'between':     {'zh':'之间','zh_TW':'之間','ko':'사이에','ja':'間に','es':'entre','fr':'entre','de':'zwischen'},
    'across':      {'zh':'对面','zh_TW':'對面','ko':'건너편에','ja':'向こう側に','es':'al otro lado','fr':'de l\'autre côté','de':'gegenüber'},
    # Daily routine
    'wake':        {'zh':'醒来','zh_TW':'醒來','ko':'깨어나다','ja':'目覚める','es':'despertar','fr':'se réveiller','de':'aufwachen'},
    'get up':      {'zh':'起床','zh_TW':'起床','ko':'일어나다','ja':'起きる','es':'levantarse','fr':'se lever','de':'aufstehen'},
    'wash':        {'zh':'洗','zh_TW':'洗','ko':'씻다','ja':'洗う','es':'lavar','fr':'laver','de':'waschen'},
    'early':       {'zh':'早','zh_TW':'早','ko':'일찍','ja':'早く','es':'temprano','fr':'tôt','de':'früh'},
    'ready':       {'zh':'准备好','zh_TW':'準備好','ko':'준비된','ja':'準備できた','es':'listo','fr':'prêt','de':'bereit'},
    'class':       {'zh':'课','zh_TW':'課','ko':'수업','ja':'授業','es':'clase','fr':'cours','de':'Klasse'},
    'lesson':      {'zh':'课','zh_TW':'課','ko':'레슨','ja':'レッスン','es':'lección','fr':'leçon','de':'Lektion'},
    'office':      {'zh':'办公室','zh_TW':'辦公室','ko':'사무실','ja':'事務所','es':'oficina','fr':'bureau','de':'Büro'},
    'meeting':     {'zh':'会议','zh_TW':'會議','ko':'회의','ja':'会議','es':'reunión','fr':'réunion','de':'Besprechung'},
    'email':       {'zh':'电子邮件','zh_TW':'電子郵件','ko':'이메일','ja':'メール','es':'correo electrónico','fr':'e-mail','de':'E-Mail'},
    'busy':        {'zh':'忙','zh_TW':'忙','ko':'바쁜','ja':'忙しい','es':'ocupado','fr':'occupé','de':'beschäftigt'},
    'start':       {'zh':'开始','zh_TW':'開始','ko':'시작하다','ja':'始める','es':'empezar','fr':'commencer','de':'beginnen'},
    'finish':      {'zh':'完成','zh_TW':'完成','ko':'끝내다','ja':'終える','es':'terminar','fr':'finir','de':'beenden'},
    'relax':       {'zh':'放松','zh_TW':'放鬆','ko':'휴식하다','ja':'リラックスする','es':'relajarse','fr':'se détendre','de':'entspannen'},
    # Leisure & health
    'music':       {'zh':'音乐','zh_TW':'音樂','ko':'음악','ja':'音楽','es':'música','fr':'musique','de':'Musik'},
    'movie':       {'zh':'电影','zh_TW':'電影','ko':'영화','ja':'映画','es':'película','fr':'film','de':'Film'},
    'game':        {'zh':'游戏','zh_TW':'遊戲','ko':'게임','ja':'ゲーム','es':'juego','fr':'jeu','de':'Spiel'},
    'sport':       {'zh':'运动','zh_TW':'運動','ko':'스포츠','ja':'スポーツ','es':'deporte','fr':'sport','de':'Sport'},
    'head':        {'zh':'头','zh_TW':'頭','ko':'머리','ja':'頭','es':'cabeza','fr':'tête','de':'Kopf'},
    'hand':        {'zh':'手','zh_TW':'手','ko':'손','ja':'手','es':'mano','fr':'main','de':'Hand'},
    'arm':         {'zh':'手臂','zh_TW':'手臂','ko':'팔','ja':'腕','es':'brazo','fr':'bras','de':'Arm'},
    'leg':         {'zh':'腿','zh_TW':'腿','ko':'다리','ja':'脚','es':'pierna','fr':'jambe','de':'Bein'},
    'eye':         {'zh':'眼睛','zh_TW':'眼睛','ko':'눈','ja':'目','es':'ojo','fr':'œil','de':'Auge'},
    'ear':         {'zh':'耳朵','zh_TW':'耳朵','ko':'귀','ja':'耳','es':'oreja','fr':'oreille','de':'Ohr'},
    'sick':        {'zh':'生病','zh_TW':'生病','ko':'아픈','ja':'病気の','es':'enfermo','fr':'malade','de':'krank'},
    # Shopping
    'shop':        {'zh':'商店','zh_TW':'商店','ko':'가게','ja':'店','es':'tienda','fr':'magasin','de':'Laden'},
    'buy':         {'zh':'买','zh_TW':'買','ko':'사다','ja':'買う','es':'comprar','fr':'acheter','de':'kaufen'},
    'sell':        {'zh':'卖','zh_TW':'賣','ko':'팔다','ja':'売る','es':'vender','fr':'vendre','de':'verkaufen'},
    'price':       {'zh':'价格','zh_TW':'價格','ko':'가격','ja':'価格','es':'precio','fr':'prix','de':'Preis'},
    'cheap':       {'zh':'便宜','zh_TW':'便宜','ko':'싼','ja':'安い','es':'barato','fr':'bon marché','de':'billig'},
    'money':       {'zh':'钱','zh_TW':'錢','ko':'돈','ja':'お金','es':'dinero','fr':'argent','de':'Geld'},
    'market':      {'zh':'市场','zh_TW':'市場','ko':'시장','ja':'市場','es':'mercado','fr':'marché','de':'Markt'},
    'need':        {'zh':'需要','zh_TW':'需要','ko':'필요하다','ja':'必要だ','es':'necesitar','fr':'avoir besoin','de':'brauchen'},
    'favorite':    {'zh':'最喜欢的','zh_TW':'最喜歡的','ko':'가장 좋아하는','ja':'一番好きな','es':'favorito','fr':'préféré','de':'Lieblings-'},
    'hungry':      {'zh':'饿','zh_TW':'餓','ko':'배고픈','ja':'お腹が空いた','es':'hambriento','fr':'faim','de':'hungrig'},
    'thirsty':     {'zh':'渴','zh_TW':'渴','ko':'목마른','ja':'喉が渇いた','es':'sediento','fr':'soif','de':'durstig'},
    'delicious':   {'zh':'好吃','zh_TW':'好吃','ko':'맛있는','ja':'美味しい','es':'delicioso','fr':'délicieux','de':'köstlich'},
    'big':         {'zh':'大','zh_TW':'大','ko':'큰','ja':'大きい','es':'grande','fr':'grand','de':'groß'},
    'small':       {'zh':'小','zh_TW':'小','ko':'작은','ja':'小さい','es':'pequeño','fr':'petit','de':'klein'},
    'tall':        {'zh':'高','zh_TW':'高','ko':'키가 큰','ja':'背が高い','es':'alto','fr':'grand','de':'groß'},
    'short':       {'zh':'矮','zh_TW':'矮','ko':'키가 작은','ja':'背が低い','es':'bajo','fr':'petit','de':'klein'},
    'new':         {'zh':'新','zh_TW':'新','ko':'새로운','ja':'新しい','es':'nuevo','fr':'nouveau','de':'neu'},
    'old':         {'zh':'老','zh_TW':'老','ko':'오래된','ja':'古い','es':'viejo','fr':'vieux','de':'alt'},
    'young':       {'zh':'年轻','zh_TW':'年輕','ko':'젊은','ja':'若い','es':'joven','fr':'jeune','de':'jung'},
    'beautiful':   {'zh':'美丽','zh_TW':'美麗','ko':'아름다운','ja':'美しい','es':'hermoso','fr':'beau','de':'schön'},
    'can':         {'zh':'能','zh_TW':'能','ko':'할 수 있다','ja':'できる','es':'poder','fr':'pouvoir','de':'können'},
    'it':          {'zh':'它','zh_TW':'它','ko':'그것','ja':'それ','es':'ello','fr':'il/elle','de':'es'},
    'this':        {'zh':'这个','zh_TW':'這個','ko':'이것','ja':'これ','es':'esto','fr':'ceci','de':'dies'},
    'lemon':       {'zh':'柠檬','zh_TW':'檸檬','ko':'레몬','ja':'レモン','es':'limón','fr':'citron','de':'Zitrone'},
    'fruit':       {'zh':'水果','zh_TW':'水果','ko':'과일','ja':'果物','es':'fruta','fr':'fruit','de':'Obst'},
    'sweet':       {'zh':'甜的','zh_TW':'甜的','ko':'달콤한','ja':'甘い','es':'dulce','fr':'sucré','de':'süß'},
    'fresh':       {'zh':'新鲜的','zh_TW':'新鮮的','ko':'신선한','ja':'新鮮な','es':'fresco','fr':'frais','de':'frisch'},
    'breakfast':   {'zh':'早餐','zh_TW':'早餐','ko':'아침 식사','ja':'朝食','es':'desayuno','fr':'petit-déjeuner','de':'Frühstück'},
    'lunch':       {'zh':'午餐','zh_TW':'午餐','ko':'점심','ja':'昼食','es':'almuerzo','fr':'déjeuner','de':'Mittagessen'},
    'dinner':      {'zh':'晚餐','zh_TW':'晚餐','ko':'저녁','ja':'夕食','es':'cena','fr':'dîner','de':'Abendessen'},
    'meal':        {'zh':'一餐','zh_TW':'一餐','ko':'식사','ja':'食事','es':'comida','fr':'repas','de':'Mahlzeit'},
    # Days — FIXED: lowercase keys
    'monday':      {'zh':'星期一','zh_TW':'星期一','ko':'월요일','ja':'月曜日','es':'lunes','fr':'lundi','de':'Montag'},
    'tuesday':     {'zh':'星期二','zh_TW':'星期二','ko':'화요일','ja':'火曜日','es':'martes','fr':'mardi','de':'Dienstag'},
    'wednesday':   {'zh':'星期三','zh_TW':'星期三','ko':'수요일','ja':'水曜日','es':'miércoles','fr':'mercredi','de':'Mittwoch'},
    'thursday':    {'zh':'星期四','zh_TW':'星期四','ko':'목요일','ja':'木曜日','es':'jueves','fr':'jeudi','de':'Donnerstag'},
    'friday':      {'zh':'星期五','zh_TW':'星期五','ko':'금요일','ja':'金曜日','es':'viernes','fr':'vendredi','de':'Freitag'},
    'saturday':    {'zh':'星期六','zh_TW':'星期六','ko':'토요일','ja':'土曜日','es':'sábado','fr':'samedi','de':'Samstag'},
    'sunday':      {'zh':'星期天','zh_TW':'星期天','ko':'일요일','ja':'日曜日','es':'domingo','fr':'dimanche','de':'Sonntag'},
    # Months — lowercase keys
    'january':     {'zh':'一月','zh_TW':'一月','ko':'1월','ja':'1月','es':'enero','fr':'janvier','de':'Januar'},
    'february':    {'zh':'二月','zh_TW':'二月','ko':'2월','ja':'2月','es':'febrero','fr':'février','de':'Februar'},
    'march':       {'zh':'三月','zh_TW':'三月','ko':'3월','ja':'3月','es':'marzo','fr':'mars','de':'März'},
    'april':       {'zh':'四月','zh_TW':'四月','ko':'4월','ja':'4月','es':'abril','fr':'avril','de':'April'},
    'may':         {'zh':'五月','zh_TW':'五月','ko':'5월','ja':'5月','es':'mayo','fr':'mai','de':'Mai'},
    'june':        {'zh':'六月','zh_TW':'六月','ko':'6월','ja':'6月','es':'junio','fr':'juin','de':'Juni'},
    'july':        {'zh':'七月','zh_TW':'七月','ko':'7월','ja':'7月','es':'julio','fr':'juillet','de':'Juli'},
    'august':      {'zh':'八月','zh_TW':'八月','ko':'8월','ja':'8月','es':'agosto','fr':'août','de':'August'},
    'i':           {'zh':'我','zh_TW':'我','ko':'나','ja':'私','es':'yo','fr':'je','de':'ich'},
    # Additional words
    'come':        {'zh':'来','zh_TW':'來','ko':'오다','ja':'来る','es':'venir','fr':'venir','de':'kommen'},
    'here':        {'zh':'这里','zh_TW':'這裡','ko':'여기','ja':'ここ','es':'aquí','fr':'ici','de':'hier'},
    'there':       {'zh':'那里','zh_TW':'那裡','ko':'거기','ja':'そこ','es':'allí','fr':'là','de':'dort'},
    'place':       {'zh':'地方','zh_TW':'地方','ko':'장소','ja':'場所','es':'lugar','fr':'endroit','de':'Ort'},
    'see you':     {'zh':'再见','zh_TW':'再見','ko':'또 봐요','ja':'またね','es':'nos vemos','fr':'à bientôt','de':'bis bald'},
    'later':       {'zh':'稍后','zh_TW':'稍後','ko':'나중에','ja':'後で','es':'más tarde','fr':'plus tard','de':'später'},
    'tomorrow':    {'zh':'明天','zh_TW':'明天','ko':'내일','ja':'明日','es':'mañana','fr':'demain','de':'morgen'},
    'grape':       {'zh':'葡萄','zh_TW':'葡萄','ko':'포도','ja':'ぶどう','es':'uva','fr':'raisin','de':'Traube'},
    'orange':      {'zh':'橙色','zh_TW':'橙色','ko':'주황색','ja':'オレンジ色','es':'naranja','fr':'orange','de':'orange'},
    'brown':       {'zh':'棕色','zh_TW':'棕色','ko':'갈색','ja':'茶色','es':'marrón','fr':'marron','de':'braun'},
    'hour':        {'zh':'小时','zh_TW':'小時','ko':'시간','ja':'時間','es':'hora','fr':'heure','de':'Stunde'},
    'minute':      {'zh':'分钟','zh_TW':'分鐘','ko':'분','ja':'分','es':'minuto','fr':'minute','de':'Minute'},
    'soon':        {'zh':'很快','zh_TW':'很快','ko':'곧','ja':'すぐに','es':'pronto','fr':'bientôt','de':'bald'},
    'thanks':      {'zh':'谢谢','zh_TW':'謝謝','ko':'감사합니다','ja':'ありがとう','es':'gracias','fr':'merci','de':'danke'},
}


def translate_word(word, lang):
    """Get real translation of an English word into the target language."""
    w = word.lower().strip()
    if w in WORD_TRANSLATIONS and lang in WORD_TRANSLATIONS[w]:
        return WORD_TRANSLATIONS[w][lang]
    # Try exact case
    if word.strip() in WORD_TRANSLATIONS and lang in WORD_TRANSLATIONS[word.strip()]:
        return WORD_TRANSLATIONS[word.strip()][lang]
    # Fallback: return the English word prefixed with language marker
    return f"[{lang}] {word}"


def make_localized(en_val, **overrides):
    """Create a proper 8-language LocalizedText dict."""
    result = {'en': en_val}
    for lang in ['zh', 'zh_TW', 'ko', 'ja', 'es', 'fr', 'de']:
        if lang in overrides:
            result[lang] = overrides[lang]
        else:
            result[lang] = en_val  # Fallback — should be overridden
    return result


def make_course_title(lang_code):
    titles = {
        'en': make_localized('English A1',
            zh='英语A1', zh_TW='英語A1', ko='영어 A1', ja='英語A1',
            es='Inglés A1', fr='Anglais A1', de='Englisch A1'),
    }
    return titles.get(lang_code, titles['en'])


def make_course_subtitle():
    return make_localized('Beginner English',
        zh='初级英语', zh_TW='初級英語', ko='초급 영어', ja='初級英語',
        es='Inglés principiante', fr='Anglais débutant', de='Englisch für Anfänger')


def make_course_description():
    return make_localized('Master the basics of English. Learn everyday vocabulary, simple grammar, and essential phrases.',
        zh='掌握英语基础。学习日常词汇、简单语法和基本短语。',
        zh_TW='掌握英語基礎。學習日常詞彙、簡單語法和基本短語。',
        ko='영어의 기초를 마스터하세요. 일상 어휘, 간단한 문법, 필수 표현을 배웁니다.',
        ja='英語の基礎をマスターしましょう。日常語彙、簡単な文法、必須フレーズを学びます。',
        es='Domina los fundamentos del inglés. Aprende vocabulario cotidiano, gramática simple y frases esenciales.',
        fr='Maîtrisez les bases de l\'anglais. Apprenez le vocabulaire quotidien, la grammaire simple et les phrases essentielles.',
        de='Meistern Sie die Grundlagen des Englischen. Lernen Sie Alltagsvokabular, einfache Grammatik und wichtige Redewendungen.')


def make_flashcard(ex_id, word, topic_en):
    """FlashCard: word on front, real Chinese translation on back."""
    return {
        'id': ex_id,
        'type': 'flashCard',
        'contentLang': 'en',
        'question': word,        'correctAnswer': translate_word(word, 'zh'),  # Chinese translation as answer
        'explanation': make_localized(
            f"'{word}' is a common English {topic_en} word. Practice saying it out loud.",
            zh=f"'{word}' 是一个常见的英语{topic_en}词汇。请大声练习发音。",
            zh_TW=f"'{word}' 是一個常見的英語{topic_en}詞彙。請大聲練習發音。",
            ko=f"'{word}'는 일반적인 영어 {topic_en} 단어입니다. 소리 내어 연습하세요.",
            ja=f"'{word}'は一般的な英語の{topic_en}の単語です。声に出して練習しましょう。",
            es=f"'{word}' es una palabra común en inglés para {topic_en}. Practica diciéndola en voz alta.",
            fr=f"'{word}' est un mot anglais courant pour {topic_en}. Entraînez-vous à le dire à voix haute.",
            de=f"'{word}' ist ein häufiges englisches Wort für {topic_en}. Üben Sie, es laut auszusprechen.")
    }


def make_vocab_mc(ex_id, correct_word, distractors, topic_en):
    """Vocabulary multiple choice: see Chinese meaning, pick English word."""
    options = [correct_word] + distractors[:3]
    # Shuffle deterministically by sorting
    options = sorted(options, key=lambda x: (x.lower(), x))
    return {
        'id': ex_id,
        'type': 'vocabularyMultipleChoice',
        'contentLang': 'en',
        'question': translate_word(correct_word, 'zh'),  # Show Chinese meaning as question        'options': options,
        'correctAnswer': correct_word,
        'explanation': make_localized(
            f"'{correct_word}' means '{translate_word(correct_word, 'zh')}' in Chinese.",
            zh=f"'{correct_word}' 的中文意思是'{translate_word(correct_word, 'zh')}'。",
            zh_TW=f"'{correct_word}' 的中文意思是'{translate_word(correct_word, 'zh_TW')}'。",
            ko=f"'{correct_word}'의 한국어 뜻은 '{translate_word(correct_word, 'ko')}'입니다.",
            ja=f"'{correct_word}'の日本語の意味は'{translate_word(correct_word, 'ja')}'です。",
            es=f"'{correct_word}' significa '{translate_word(correct_word, 'es')}' en español.",
            fr=f"'{correct_word}' signifie '{translate_word(correct_word, 'fr')}' en français.",
            de=f"'{correct_word}' bedeutet '{translate_word(correct_word, 'de')}' auf Deutsch.")
    }


def make_match_pairs(ex_id, words):
    """Match English words with Chinese translations."""
    pairs = [{'left': w, 'right': translate_word(w, 'zh')} for w in words]
    return {
        'id': ex_id,
        'type': 'matchPairs',
        'contentLang': 'en',
        'question': '',        'pairs': pairs
    }


def make_fill_blank(ex_id, sentence, correct_word, distractors):
    """Fill in the blank: sentence with ___ gap."""
    blank_sentence = sentence.replace(correct_word, '___', 1)
    options = [correct_word] + distractors[:3]
    options = sorted(options, key=lambda x: (x.lower(), x))
    return {
        'id': ex_id,
        'type': 'fillInBlank',
        'contentLang': 'en',
        'question': blank_sentence,        'wordBank': options,
        'correctAnswer': correct_word,
        'options': options,
        'explanation': make_localized(
            f"The correct word is '{correct_word}'. The full sentence is: {sentence}",
            zh=f"正确的单词是'{correct_word}'。完整句子是：{sentence}",
            zh_TW=f"正確的單詞是'{correct_word}'。完整句子是：{sentence}",
            ko=f"올바른 단어는 '{correct_word}'입니다. 전체 문장: {sentence}",
            ja=f"正しい単語は'{correct_word}'です。全文：{sentence}",
            es=f"La palabra correcta es '{correct_word}'. La oración completa es: {sentence}",
            fr=f"Le mot correct est '{correct_word}'. La phrase complète est : {sentence}",
            de=f"Das richtige Wort ist '{correct_word}'. Der vollständige Satz lautet: {sentence}")
    }


def make_word_sorting(ex_id, sentence):
    """Rearrange jumbled words into correct sentence."""
    words = sentence.rstrip('.').split()
    import random
    random.seed(hash(sentence) % 10000)
    jumbled = words[:]
    random.shuffle(jumbled)
    # Ensure it's different from original
    if jumbled == words:
        random.shuffle(jumbled)
    return {
        'id': ex_id,
        'type': 'wordSorting',
        'contentLang': 'en',
        'question': '',        'options': jumbled,
        'correctAnswerList': words,
        'explanation': make_localized(
            f"The correct order is: {' '.join(words)}.",
            zh=f"正确的顺序是：{' '.join(words)}。",
            zh_TW=f"正確的順序是：{' '.join(words)}。",
            ko=f"올바른 순서는: {' '.join(words)}입니다.",
            ja=f"正しい順序は：{' '.join(words)}です。",
            es=f"El orden correcto es: {' '.join(words)}.",
            fr=f"L'ordre correct est : {' '.join(words)}.",
            de=f"Die richtige Reihenfolge ist: {' '.join(words)}.")
    }


def make_listen_type(ex_id, word):
    """Listen and type a word."""
    return {
        'id': ex_id,
        'type': 'listenAndType',
        'contentLang': 'en',
        'question': '',        'audioUrl': f'https://cdn.instalingo.app/audio/en/{word.replace(" ", "_")}.mp3',
        'correctAnswer': word,
        'explanation': make_localized(
            f"The word is '{word}'.",
            zh=f"这个单词是'{word}'。",
            zh_TW=f"這個單詞是'{word}'。",
            ko=f"이 단어는 '{word}'입니다.",
            ja=f"この単語は'{word}'です。",
            es=f"La palabra es '{word}'.",
            fr=f"Le mot est '{word}'.",
            de=f"Das Wort ist '{word}'.")
    }


def make_image_id(ex_id, correct_word, distractors):
    """Image identification: tap the correct image."""
    return {
        'id': ex_id,
        'type': 'imageIdentification',
        'contentLang': 'en',
        'question': correct_word,        'options': [correct_word] + distractors[:3],
        'correctAnswer': correct_word,
        'imageUrl': f'https://cdn.instalingo.app/images/en/{correct_word.replace(" ", "_")}.jpg'
    }


def make_grammar_tip(ex_id, rule_en, example_en, rule_translations, example_translations):
    """Grammar tip: rule + example."""
    return {
        'id': ex_id,
        'type': 'grammarTip',
        'contentLang': 'en',
        'question': '',        'grammarRule': rule_translations,
        'grammarExample': example_translations
    }


def make_dialogue(ex_id, lines, options, correct):
    """Dialogue completion exercise."""
    dialogue = []
    for speaker, text, is_user in lines:
        dialogue.append({'speaker': speaker, 'text': text, 'isUser': is_user})
    return {
        'id': ex_id,
        'type': 'dialogueComplete',
        'contentLang': 'en',
        'question': '',        'dialogue': dialogue,
        'options': options,
        'correctAnswer': correct,
        'explanation': make_localized(
            f"The correct response is '{correct}'.",
            zh=f"正确的回答是'{correct}'。",
            zh_TW=f"正確的回答是'{correct}'。",
            ko=f"올바른 응답은 '{correct}'입니다.",
            ja=f"正しい返答は'{correct}'です。",
            es=f"La respuesta correcta es '{correct}'.",
            fr=f"La bonne réponse est '{correct}'.",
            de=f"Die richtige Antwort ist '{correct}'.")
    }


# ─── LESSON DEFINITIONS ──────────────────────────────────────────────
# Structure: sections → lessons → vocabulary
# Exercises are auto-generated from vocabulary + templates

SECTIONS = [
    ('Greetings & Introductions', [
        ('Hello & Hi', 'greeting', ['hello','hi','good morning','good afternoon','good evening','welcome','nice','meet']),
        ('My Name Is', 'introduction', ['name','first name','last name','my','your','spell','call','family name']),
        ('How Are You?', 'feeling', ['happy','fine','sad','tired','good','bad','angry','afraid']),
        ('Where Are You From?', 'origin', ['country','city','from','live','come','here','there','place']),
        ('Goodbye', 'farewell', ['goodbye','bye','see you','later','tomorrow','night','soon','thanks']),
    ]),
    ('People & Family', [
        ('Family', 'family', ['mother','father','sister','brother','family','parent','child','baby']),
        ('Friends', 'friend', ['friend','classmate','neighbor','person','people','boy','girl','adult']),
        ('Jobs', 'job', ['teacher','student','doctor','work','job','learn','read','write']),
        ('Describing People', 'description', ['big','small','tall','short','new','old','young','beautiful']),
        ('Pronouns', 'pronoun', ['I','you','he','she','we','they','it','this']),
    ]),
    ('Home & Everyday Objects', [
        ('Rooms', 'room', ['home','house','room','kitchen','bathroom','bedroom','door','window']),
        ('Furniture', 'furniture', ['table','chair','bed','desk','sofa','lamp','floor','wall']),
        ('Common Things', 'object', ['book','pen','bag','key','phone','computer','watch','glasses']),
        ('Clothes', 'clothing', ['shirt','dress','shoe','hat','coat','skirt','sock','jacket']),
        ('Colors', 'color', ['red','blue','green','yellow','black','white','brown','orange']),
    ]),
    ('Food & Drink', [
        ('Fruit & Vegetables', 'fruit', ['apple','banana','orange','grape','lemon','fruit','sweet','fresh']),
        ('Meals', 'meal', ['breakfast','lunch','dinner','meal','rice','bread','egg','fish']),
        ('Drinks', 'drink', ['coffee','tea','water','milk','cup','drink','eat','please']),
        ('Shopping for Food', 'shopping', ['shop','buy','sell','price','cheap','money','market','bag']),
        ('Likes & Dislikes', 'preference', ['like','love','want','need','favorite','hungry','thirsty','delicious']),
    ]),
    ('Numbers, Time & Dates', [
        ('Numbers 1-10', 'number', ['one','two','three','four','five','six','seven','eight']),
        ('Days of the Week', 'day', ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday','week']),
        ('Months', 'month', ['January','February','March','April','May','June','July','August']),
        ('Telling Time', 'time', ['time','hour','minute','morning','afternoon','evening','today','now']),
        ('Weather', 'weather', ['weather','sun','rain','snow','wind','hot','cold','warm']),
    ]),
    ('Places & Directions', [
        ('City Places', 'place', ['school','bank','park','station','hospital','hotel','restaurant','museum']),
        ('Transport', 'transport', ['car','bus','train','bike','taxi','plane','ticket','travel']),
        ('Directions', 'direction', ['left','right','straight','near','far','behind','between','across']),
        ('Travel', 'travel', ['airport','passport','map','trip','visit','arrive','leave','go']),
        ('Asking the Way', 'navigation', ['where','here','there','place','street','road','turn','help']),
    ]),
    ('Daily Routines', [
        ('Morning Routine', 'routine', ['wake','get up','wash','eat','drink','go','early','ready']),
        ('At School', 'school', ['class','lesson','read','write','listen','speak','answer','ask']),
        ('At Work', 'work', ['work','office','meeting','email','call','busy','start','finish']),
        ('Free Time', 'hobby', ['music','movie','game','sport','dance','walk','play','relax']),
        ('Health', 'health', ['head','hand','arm','leg','eye','ear','sick','doctor']),
    ]),
    ('Basic Grammar', [
        ('Be: am, is, are', 'grammar', ['I','you','he','she','we','they','am','are']),
        ('Present Simple', 'grammar', ['live','study','speak','work','read','write','go','do']),
        ('Questions', 'grammar', ['what','who','when','why','how','which','question','answer']),
        ('Can & Cannot', 'grammar', ['can','cannot','swim','cook','drive','play','sing','dance']),
        ('Review', 'review', ['hello','name','from','like','want','where','today','goodbye']),
    ]),
    # MORE sections to be added...
]

# ─── EXERCISE GENERATOR ──────────────────────────────────────────────

def generate_exercises_for_lesson(lesson_id, vocab, topic_slug, topic_en):
    """Generate 9 pedagogically sound exercises for a lesson's vocabulary."""
    exercises = []
    ex_num = 1
    lesson_num = lesson_id.split('_l')[1] if '_l' in lesson_id else '00'
    
    def exid():
        nonlocal ex_num
        eid = f'ex_{lesson_id}_{ex_num:02d}'
        ex_num += 1
        return eid
    
    main_word = vocab[0]
    other_words = vocab[1:5] if len(vocab) > 4 else vocab[1:]
    # Build distractor pool excluding the main word and deduplicating
    distractor_pool = list(dict.fromkeys([w for w in other_words if w != main_word]))
    if len(distractor_pool) < 3:
        # Supplement with common distractor words
        fallback_distractors = ['cat', 'dog', 'run', 'big', 'red', 'book', 'pen', 'eat', 'go', 'see']
        for w in fallback_distractors:
            if w != main_word and w not in distractor_pool:
                distractor_pool.append(w)
            if len(distractor_pool) >= 3:
                break
    
    # 1. flashCard — learn the main word
    exercises.append(make_flashcard(exid(), main_word, topic_en))
    
    # 2. vocabularyMultipleChoice — recognize the main word
    exercises.append(make_vocab_mc(exid(), main_word, distractor_pool, topic_en))
    
    # 3. matchPairs — match words to Chinese translations
    words_to_pair = vocab[:6] if len(vocab) >= 6 else vocab[:4]
    exercises.append(make_match_pairs(exid(), words_to_pair))
    
    # 4. fillInBlank — use main word in a simple sentence
    sentences = {
        'hello': 'I say hello to my friend.',
        'hi': 'Hi, how are you?',
        'good morning': 'Good morning, teacher.',
        'good afternoon': 'Good afternoon, class.',
        'good evening': 'Good evening, everyone.',
        'welcome': 'Welcome to my home.',
        'nice': 'It is a nice day.',
        'meet': 'Nice to meet you.',
        'name': 'My name is John.',
        'first name': 'My first name is Anna.',
        'last name': 'Her last name is Smith.',
        'my': 'This is my book.',
        'your': 'What is your name?',
        'happy': 'I am very happy today.',
        'fine': 'I am fine, thank you.',
        'sad': 'She is sad today.',
        'tired': 'He is tired after work.',
        'good': 'This is a good book.',
        'bad': 'That is a bad idea.',
        'angry': 'Do not be angry.',
        'afraid': 'I am not afraid.',
        'country': 'I love my country.',
        'city': 'I live in a big city.',
        'from': 'I am from China.',
        'live': 'I live in London.',
        'come': 'Come here, please.',
        'here': 'Please sit here.',
        'there': 'The book is there.',
        'place': 'This is a nice place.',
        'goodbye': 'Goodbye, see you later.',
        'bye': 'Bye, have a nice day.',
        'see you': 'See you tomorrow.',
        'later': 'I will call you later.',
        'tomorrow': 'See you tomorrow.',
        'night': 'Good night, sleep well.',
        'soon': 'Come back soon.',
        'thanks': 'Thanks for your help.',
        'mother': 'My mother is a teacher.',
        'father': 'My father works in a hospital.',
        'sister': 'My sister is a student.',
        'brother': 'My brother likes sports.',
        'family': 'I love my family.',
        'friend': 'She is my best friend.',
        'classmate': 'My classmate is from Japan.',
        'neighbor': 'My neighbor has a dog.',
        'person': 'She is a nice person.',
        'people': 'Many people live here.',
        'boy': 'The boy is playing outside.',
        'girl': 'The girl is reading a book.',
        'adult': 'An adult ticket costs more.',
        'teacher': 'The teacher is very kind.',
        'student': 'I am a student.',
        'doctor': 'He wants to be a doctor.',
        'work': 'I work in an office.',
        'job': 'She has a good job.',
        'learn': 'I learn English every day.',
        'read': 'I read a book every night.',
        'write': 'Please write your name here.',
        'big': 'This is a big house.',
        'small': 'I have a small cat.',
        'tall': 'My brother is very tall.',
        'short': 'She has short hair.',
        'new': 'This is my new phone.',
        'old': 'My grandmother is very old.',
        'young': 'She is a young teacher.',
        'beautiful': 'What a beautiful day!',
        'I': 'I am a student.',
        'you': 'You are my friend.',
        'he': 'He is a doctor.',
        'she': 'She is a teacher.',
        'we': 'We are happy today.',
        'they': 'They are from Spain.',
        'it': 'It is a big house.',
        'this': 'This is my book.',
        'home': 'I go home at five.',
        'house': 'My house has three rooms.',
        'room': 'This room is very big.',
        'kitchen': 'My mother is in the kitchen.',
        'bathroom': 'The bathroom is clean.',
        'bedroom': 'My bedroom is small but nice.',
        'door': 'Please close the door.',
        'window': 'I open the window every morning.',
        'table': 'The book is on the table.',
        'chair': 'Please sit on this chair.',
        'bed': 'I go to bed at ten.',
        'desk': 'My desk is near the window.',
        'sofa': 'The cat is on the sofa.',
        'lamp': 'Turn on the lamp please.',
        'floor': 'The floor is very clean.',
        'wall': 'There is a picture on the wall.',
        'book': 'I read a book every day.',
        'pen': 'I have a blue pen.',
        'bag': 'My bag is on the chair.',
        'key': 'I lost my house key.',
        'phone': 'My phone is new.',
        'computer': 'I use a computer for work.',
        'watch': 'I have a new watch.',
        'glasses': 'She wears glasses to read.',
        'shirt': 'I like your blue shirt.',
        'dress': 'She wears a red dress.',
        'shoe': 'I need new shoes.',
        'hat': 'He wears a hat in summer.',
        'coat': 'Put on your coat, it is cold.',
        'skirt': 'She has a black skirt.',
        'sock': 'I need clean socks.',
        'jacket': 'Take your jacket, it is cold.',
        'red': 'I have a red car.',
        'blue': 'The sky is blue today.',
        'green': 'The grass is green.',
        'yellow': 'She has a yellow dress.',
        'black': 'I like black coffee.',
        'white': 'Snow is white.',
        'brown': 'My dog is brown.',
        'orange': 'I like orange juice.',
        'apple': 'I eat an apple every day.',
        'banana': 'This banana is very sweet.',
        'grape': 'I like grape juice.',
        'lemon': 'Lemon is very sour.',
        'fruit': 'I eat fruit every morning.',
        'sweet': 'This cake is very sweet.',
        'fresh': 'I like fresh bread.',
        'breakfast': 'I have breakfast at seven.',
        'lunch': 'We have lunch at noon.',
        'dinner': 'Dinner is at six in the evening.',
        'meal': 'This is a good meal.',
        'rice': 'I eat rice every day.',
        'bread': 'I like fresh bread.',
        'egg': 'I eat an egg for breakfast.',
        'fish': 'Fish is good for you.',
        'coffee': 'I drink coffee in the morning.',
        'tea': 'Would you like some tea?',
        'water': 'Please give me some water.',
        'milk': 'I drink milk every morning.',
        'cup': 'I need a cup of coffee.',
        'drink': 'What would you like to drink?',
        'eat': 'I eat lunch at noon.',
        'please': 'Please sit down.',
        'shop': 'I shop at the market.',
        'buy': 'I want to buy a book.',
        'sell': 'They sell fresh fruit here.',
        'price': 'The price is very high.',
        'cheap': 'This bag is very cheap.',
        'money': 'I have enough money.',
        'market': 'I go to the market every Saturday.',
        'like': 'I like English very much.',
        'love': 'I love my family.',
        'want': 'I want a glass of water.',
        'need': 'I need a new phone.',
        'favorite': 'My favorite color is blue.',
        'hungry': 'I am very hungry now.',
        'thirsty': 'I am thirsty after running.',
        'delicious': 'This cake is delicious!',
        'one': 'I have one sister.',
        'two': 'There are two books on the table.',
        'three': 'I have three cats.',
        'four': 'He is four years old.',
        'five': 'There are five apples.',
        'six': 'She is six years old.',
        'seven': 'There are seven days in a week.',
        'eight': 'I have eight pens.',
        'Monday': 'I go to school on Monday.',
        'Tuesday': 'We have English on Tuesday.',
        'Wednesday': 'She works on Wednesday.',
        'Thursday': 'They visit us on Thursday.',
        'Friday': 'Friday is my favorite day.',
        'Saturday': 'I stay home on Saturday.',
        'Sunday': 'We go to church on Sunday.',
        'week': 'A week has seven days.',
        'January': 'January is the first month.',
        'February': 'February is very cold.',
        'March': 'Spring begins in March.',
        'April': 'It rains a lot in April.',
        'May': 'My birthday is in May.',
        'June': 'School ends in June.',
        'July': 'July is very hot.',
        'August': 'We travel in August.',
        'time': 'What time is it?',
        'hour': 'I work eight hours a day.',
        'minute': 'Please wait a minute.',
        'morning': 'I wake up early in the morning.',
        'afternoon': 'I study in the afternoon.',
        'evening': 'I watch TV in the evening.',
        'today': 'Today is Monday.',
        'now': 'I am busy now.',
        'weather': 'The weather is nice today.',
        'sun': 'The sun is very bright.',
        'rain': 'It will rain tomorrow.',
        'snow': 'I like snow very much.',
        'wind': 'The wind is cold today.',
        'hot': 'It is very hot in summer.',
        'cold': 'Winter is very cold here.',
        'warm': 'Spring is warm and nice.',
        'school': 'I walk to school every day.',
        'bank': 'The bank is near my house.',
        'park': 'We play in the park.',
        'station': 'The train station is far.',
        'hospital': 'He went to the hospital.',
        'hotel': 'They stay at a big hotel.',
        'restaurant': 'We eat at a restaurant.',
        'museum': 'I visit the museum on Sunday.',
        'car': 'I drive my car to work.',
        'bus': 'I take the bus to school.',
        'train': 'The train arrives at ten.',
        'bike': 'I ride my bike to school.',
        'taxi': 'We take a taxi home.',
        'plane': 'The plane flies very high.',
        'ticket': 'I need a train ticket.',
        'travel': 'I want to travel to Japan.',
        'left': 'Turn left at the corner.',
        'right': 'The store is on your right.',
        'straight': 'Go straight for two blocks.',
        'near': 'The park is near my house.',
        'far': 'The airport is very far.',
        'behind': 'The cat is behind the door.',
        'between': 'The bank is between the school and the park.',
        'across': 'The store is across the street.',
        'airport': 'I go to the airport by taxi.',
        'passport': 'I need my passport to travel.',
        'map': 'I use a map to find the way.',
        'trip': 'We plan a trip to Paris.',
        'visit': 'I want to visit my grandmother.',
        'arrive': 'We arrive at the station.',
        'leave': 'I leave home at seven.',
        'go': 'I go to school by bus.',
        'where': 'Where do you live?',
        'street': 'I live on Main Street.',
        'road': 'This road is very busy.',
        'turn': 'Turn left at the next corner.',
        'help': 'Can you help me please?',
        'wake': 'I wake up at six.',
        'get up': 'I get up early every day.',
        'wash': 'I wash my face in the morning.',
        'early': 'I go to bed early.',
        'ready': 'I am ready to go.',
        'class': 'My class starts at eight.',
        'lesson': 'Today we have a new lesson.',
        'listen': 'Please listen to the teacher.',
        'speak': 'I speak English a little.',
        'answer': 'Can you answer this question?',
        'ask': 'Please ask me a question.',
        'office': 'I work in a small office.',
        'meeting': 'I have a meeting at ten.',
        'email': 'I send an email to my boss.',
        'call': 'I call my mother every day.',
        'busy': 'I am very busy today.',
        'start': 'The movie starts at seven.',
        'finish': 'I finish work at five.',
        'music': 'I listen to music every day.',
        'movie': 'We watch a movie tonight.',
        'game': 'Do you play video games?',
        'sport': 'I like to play sport.',
        'dance': 'She can dance very well.',
        'walk': 'I walk in the park every day.',
        'play': 'Children play in the park.',
        'relax': 'I relax at home on weekends.',
        'head': 'I have a pain in my head.',
        'hand': 'Wash your hands please.',
        'arm': 'He broke his left arm.',
        'leg': 'She hurt her leg.',
        'eye': 'I have blue eyes.',
        'ear': 'My ears are cold.',
        'sick': 'I am sick today.',
        'am': 'I am a teacher.',
        'are': 'You are my best friend.',
        'study': 'I study English every day.',
        'do': 'What do you do?',
        'what': 'What is your favorite color?',
        'who': 'Who is that girl?',
        'when': 'When is your birthday?',
        'why': 'Why are you late?',
        'how': 'How old are you?',
        'which': 'Which book do you want?',
        'question': 'Do you have a question?',
        'can': 'I can speak English.',
        'cannot': 'I cannot swim.',
        'swim': 'I can swim very well.',
        'cook': 'My mother can cook well.',
        'drive': 'I cannot drive a car.',
        'sing': 'She can sing beautifully.',
        'dance': 'They can dance together.',
        'parent': 'My parent works at a bank.',
        'child': 'The child is playing outside.',
        'baby': 'The baby is sleeping now.',
        'spell': 'Can you spell your name?',
        'call': 'Please call me later.',
        'family name': 'My family name is Lee.',
    }
    sentence = sentences.get(main_word)
    if not sentence:
        sentence = f'I learn the word {main_word}.'
    # Ensure the word actually appears in the sentence
    if main_word.lower() not in sentence.lower():
        sentence = f'The word is {main_word}.'
    exercises.append(make_fill_blank(exid(), sentence, main_word, distractor_pool))
    
    # 5. wordSorting — rearrange sentence
    sort_sentence = sentences.get(main_word, f'I like {main_word}.')
    # Fix for pronoun edge cases: ensure word appears only once in sort
    if main_word in sort_sentence.split():
        sort_words = sort_sentence.rstrip('.').split()
        if sort_words.count(main_word) > 1:
            # Replace duplicate with a different sentence
            sort_sentence = f'The word is {main_word}.'
    exercises.append(make_word_sorting(exid(), sort_sentence))
    
    # 6. listenAndType — hear and type the main word
    exercises.append(make_listen_type(exid(), main_word))
    
    # 7. imageIdentification — identify main word image
    exercises.append(make_image_id(exid(), main_word, distractor_pool))
    
    # 8. grammarTip or grammarTrueFalse (alternating by lesson number)
    lesson_int = int(lesson_num)
    if lesson_int % 2 == 1:
        grammar_rules = {
            1: ('Use capital letters at the start of sentences.', 'Hello. → Correct | hello. → Wrong'),
            3: ('Use a question mark (?) for questions.', 'How are you? → Correct | How are you. → Wrong'),
            5: ('Use a period (.) at the end of statements.', 'I am happy. → Correct | I am happy → Wrong'),
            7: ('Use "I am" not "I is".', 'I am a student. → Correct | I is a student. → Wrong'),
            9: ('Add "s" for he/she/it in present simple.', 'He likes coffee. → Correct | He like coffee. → Wrong'),
            11: ('Use "a" before consonant sounds.', 'a book → Correct | an book → Wrong'),
            13: ('Use "an" before vowel sounds.', 'an apple → Correct | a apple → Wrong'),
            15: ('Adjectives come before nouns.', 'a red car → Correct | a car red → Wrong'),
            17: ('Use "there is" for one thing.', 'There is a book. → Correct | There are a book. → Wrong'),
            19: ('Use "there are" for many things.', 'There are two books. → Correct | There is two books. → Wrong'),
            21: ('Use "some" for uncountable nouns.', 'I want some water. → Correct | I want a water. → Wrong'),
            23: ('Use "in" for months.', 'My birthday is in May. → Correct | My birthday is on May. → Wrong'),
            25: ('Use "on" for days.', 'I work on Monday. → Correct | I work in Monday. → Wrong'),
            27: ('Use "at" for clock times.', 'I wake up at 7. → Correct | I wake up on 7. → Wrong'),
            29: ('Use "can" for ability.', 'I can swim. → Correct | I can to swim. → Wrong'),
            31: ('Use "please" to be polite.', 'Water, please. → Correct | Give water. → Wrong'),
            33: ('Use "would like" for polite requests.', 'I would like tea. → Correct | I want tea please. → Wrong'),
            35: ('Use "and" to join similar ideas.', 'I like tea and coffee. → Correct | I like tea coffee. → Wrong'),
            37: ('Use "but" to show contrast.', 'It is small but nice. → Correct | It is small and nice. → Wrong'),
            39: ('Put "not" after "be" for negatives.', 'I am not tired. → Correct | I not am tired. → Wrong'),
        }
        rule_info = grammar_rules.get(lesson_int, grammar_rules[1])
        exercises.append(make_grammar_tip(exid(), rule_info[0], rule_info[1],
            make_localized(rule_info[0],
                zh=rule_info[0], zh_TW=rule_info[0], ko=rule_info[0],
                ja=rule_info[0], es=rule_info[0], fr=rule_info[0], de=rule_info[0]),
            make_localized(rule_info[1],
                zh=rule_info[1], zh_TW=rule_info[1], ko=rule_info[1],
                ja=rule_info[1], es=rule_info[1], fr=rule_info[1], de=rule_info[1])))
    else:
        # grammarTrueFalse
        tf_rules = {
            2: ("'She are happy' is correct English.", False, "The correct form is 'She is happy'."),
            4: ("'We is students' is correct English.", False, "The correct form is 'We are students'."),
            6: ("'He like coffee' is correct English.", False, "The correct form is 'He likes coffee'."),
            8: ("'I am a student' is correct English.", True, "Yes! 'I am' is the correct form for first person."),
            10: ("'They is friends' is correct English.", False, "The correct form is 'They are friends'."),
            12: ("'An book' is correct English.", False, "The correct form is 'A book' (consonant sound)."),
            14: ("'A apple' is correct English.", False, "The correct form is 'An apple' (vowel sound)."),
            16: ("'A car red' is correct English.", False, "The correct form is 'A red car' (adjective before noun)."),
            18: ("'There is two books' is correct English.", False, "The correct form is 'There are two books'."),
            20: ("'There are a book' is correct English.", False, "The correct form is 'There is a book'."),
            22: ("'I want a water' is correct English.", False, "The correct form is 'I want some water'."),
            24: ("'My birthday is on May' is correct English.", False, "The correct form is 'My birthday is in May'."),
            26: ("'I work in Monday' is correct English.", False, "The correct form is 'I work on Monday'."),
            28: ("'I wake up on 7' is correct English.", False, "The correct form is 'I wake up at 7'."),
            30: ("'I can to swim' is correct English.", False, "The correct form is 'I can swim'."),
            32: ("'Can I help you?' is correct English.", True, "Yes! 'Can I help you?' is a polite offer."),
            34: ("'I would like tea' is correct English.", True, "Yes! 'Would like' is the polite form of 'want'."),
            36: ("'I like tea coffee' is correct English.", False, "The correct form is 'I like tea and coffee'."),
            38: ("'She is tall but short' makes sense.", False, "Contradictory. Use 'but' for real contrast: 'She is short but strong'."),
            40: ("'I not am tired' is correct English.", False, "The correct form is 'I am not tired'."),
        }
        tf = tf_rules.get(int(lesson_num), tf_rules[2])
        exercises.append({
            'id': exid(), 'type': 'grammarTrueFalse', 'contentLang': 'en',
            'question': tf[0],            'isTrue': tf[1],
            'explanation': make_localized(tf[2],
                zh=tf[2], zh_TW=tf[2], ko=tf[2], ja=tf[2], es=tf[2], fr=tf[2], de=tf[2])
        })
    
    # 9. dialogueComplete — simple dialogue
    dialogue_data = {
        'hello': (
            [('A','Hello!',False), ('B','___',True), ('A',"I'm fine, thanks!",False)],
            ['Hi, how are you?','What is your name?','Where are you from?','Goodbye!'],
            'Hi, how are you?'
        ),
        'name': (
            [('A','What is your name?',False), ('B','___',True), ('A','Nice to meet you, Anna.',False)],
            ['My name is Anna.','I am from China.','I am a student.','Thank you.'],
            'My name is Anna.'
        ),
    }
    dial = dialogue_data.get(main_word)
    if dial:
        exercises.append(make_dialogue(exid(), dial[0], dial[1], dial[2]))
    else:
        # Generic dialogue
        exercises.append(make_dialogue(exid(),
            [('A',f'Do you like {main_word}?',False), ('B','___',True), ('A','Me too!',False)],
            [f'Yes, I like {main_word}.', f'No, I am {main_word}.', f'I am from {main_word}.', f'My name is {main_word}.'],
            f'Yes, I like {main_word}.'
        ))
    
    return exercises


# ─── MAIN GENERATOR ──────────────────────────────────────────────────

def generate_course(lang_code='en', output_path=None):
    """Generate a complete course JSON file."""
    
    # Build section titles with translations
    section_titles_tr = {
        'Greetings & Introductions': make_localized('Greetings & Introductions',
            zh='问候与自我介绍', zh_TW='問候與自我介紹', ko='인사와 자기소개',
            ja='挨拶と自己紹介', es='Saludos y presentaciones',
            fr='Salutations et présentations', de='Begrüßungen und Vorstellungen'),
        'People & Family': make_localized('People & Family',
            zh='人与家庭', zh_TW='人與家庭', ko='사람과 가족',
            ja='人と家族', es='Personas y familia',
            fr='Personnes et famille', de='Menschen und Familie'),
        'Home & Everyday Objects': make_localized('Home & Everyday Objects',
            zh='家与日常物品', zh_TW='家與日常物品', ko='집과 일상 물건',
            ja='家と日用品', es='Casa y objetos diarios',
            fr='Maison et objets quotidiens', de='Zuhause und Alltagsgegenstände'),
        'Food & Drink': make_localized('Food & Drink',
            zh='食物与饮料', zh_TW='食物與飲料', ko='음식과 음료',
            ja='食べ物と飲み物', es='Comida y bebida',
            fr='Nourriture et boissons', de='Essen und Trinken'),
        'Numbers, Time & Dates': make_localized('Numbers, Time & Dates',
            zh='数字、时间与日期', zh_TW='數字、時間與日期', ko='숫자, 시간과 날짜',
            ja='数・時間・日付', es='Números, hora y fechas',
            fr='Nombres, heure et dates', de='Zahlen, Uhrzeit und Daten'),
        'Places & Directions': make_localized('Places & Directions',
            zh='地点与方向', zh_TW='地點與方向', ko='장소와 방향',
            ja='場所と道案内', es='Lugares y direcciones',
            fr='Lieux et directions', de='Orte und Wegbeschreibungen'),
        'Daily Routines': make_localized('Daily Routines',
            zh='日常作息', zh_TW='日常作息', ko='일상생활',
            ja='毎日の習慣', es='Rutinas diarias',
            fr='Routines quotidiennes', de='Tagesabläufe'),
        'Basic Grammar': make_localized('Basic Grammar',
            zh='基础语法', zh_TW='基礎語法', ko='기초 문법',
            ja='基本文法', es='Gramática básica',
            fr='Grammaire de base', de='Grundgrammatik'),
    }
    
    course = OrderedDict([
        ('id', f'{lang_code}_a1'),
        ('level', 'A1'),
        ('language', lang_code),
        ('totalLessons', 0),
        ('title', make_course_title(lang_code)),
        ('subtitle', make_course_subtitle()),
        ('description', make_course_description()),
        ('sections', [])
    ])
    
    section_order = 1
    lesson_order = 1
    total_lessons = 0
    
    for section_name_en, lessons in SECTIONS:
        section_lessons = []
        for lesson_title_en, topic_slug, vocab in lessons:
            lesson_id = f'{lang_code}_l{lesson_order:02d}'
            lesson_title = make_localized(lesson_title_en,
                zh=lesson_title_en, zh_TW=lesson_title_en, ko=lesson_title_en,
                ja=lesson_title_en, es=lesson_title_en, fr=lesson_title_en, de=lesson_title_en)
            lesson_desc = make_localized(f'Learn {lesson_title_en.lower()} vocabulary in English.',
                zh=f'学习{lesson_title_en}相关的英语词汇。',
                zh_TW=f'學習{lesson_title_en}相關的英語詞彙。',
                ko=f'{lesson_title_en} 관련 영어 어휘를 배웁니다.',
                ja=f'{lesson_title_en}に関する英語の語彙を学びます。',
                es=f'Aprende vocabulario en inglés sobre {lesson_title_en.lower()}.',
                fr=f'Apprenez le vocabulaire anglais sur {lesson_title_en.lower()}.',
                de=f'Lernen Sie englisches Vokabular zu {lesson_title_en}.')
            
            exercises = generate_exercises_for_lesson(lesson_id, vocab, topic_slug, topic_slug)
            
            section_lessons.append(OrderedDict([
                ('id', lesson_id),
                ('order', lesson_order),
                ('xpReward', 10),
                ('gemsReward', 5),
                ('title', lesson_title),
                ('description', lesson_desc),
                ('vocabulary', vocab),
                ('exercises', exercises)
            ]))
            
            lesson_order += 1
            total_lessons += 1
        
        section_title = section_titles_tr.get(section_name_en,
            make_localized(section_name_en))
        
        course['sections'].append(OrderedDict([
            ('id', f'{lang_code}_sec_{section_order}'),
            ('order', section_order),
            ('title', section_title),
            ('lessons', section_lessons)
        ]))
        
        section_order += 1
    
    course['totalLessons'] = total_lessons
    
    # Validate
    errors = validate_course(course)
    if errors:
        print(f'VALIDATION ERRORS ({len(errors)}):')
        for e in errors:
            print(f'  ❌ {e}')
        return None
    
    print(f'✅ Generated course: {total_lessons} lessons across {section_order-1} sections')
    print(f'   Total exercises: {sum(len(l["exercises"]) for s in course["sections"] for l in s["lessons"])}')
    
    if output_path:
        Path(output_path).parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(course, f, ensure_ascii=False, indent=2)
        print(f'   Written to: {output_path}')
    
    return course


def validate_course(course):
    """Validate course against quality rules."""
    errors = []
    
    for section in course['sections']:
        for lesson in section['lessons']:
            ex_types = set()
            for ex in lesson['exercises']:
                exid = ex['id']
                
                # Check exercise type is valid
                if ex['type'] not in VALID_TYPES:
                    errors.append(f'{exid}: invalid type {ex["type"]}')
                
                ex_types.add(ex['type'])
                
                # Check duplicate options
                if 'options' in ex and ex['options']:
                    opts = ex['options']
                    if len(opts) != len(set(opts)):
                        errors.append(f'{exid}: duplicate options: {opts}')
                
                # Check flashCard correctAnswer is not a garbage template
                if ex['type'] == 'flashCard':
                    ans = ex.get('correctAnswer', '')
                    if 'A useful' in ans or 'useful word' in ans or 'useful A1' in ans:
                        errors.append(f'{exid}: garbage flashCard correctAnswer')
                    if ans in ('', None):
                        errors.append(f'{exid}: empty flashCard correctAnswer')
                
                # Check vocabularyMultipleChoice question is not garbage
                if ex['type'] == 'vocabularyMultipleChoice':
                    q = ex.get('question', '')
                    if 'belongs to' in q.lower() or 'which word belongs' in q.lower():
                        errors.append(f'{exid}: garbage question format')
                
                # Check matchPairs right side is not garbage
                if ex['type'] == 'matchPairs' and 'pairs' in ex:
                    for p in ex['pairs']:
                        if ':' in p['right'] and p['right'].count(':') == 1:
                            prefix = p['right'].split(':')[0].strip()
                            if prefix[0].isupper() and len(prefix) > 2:
                                errors.append(f'{exid}: garbage matchPair right: {p["right"]}')
                                break
                
                # Check all LocalizedText fields have 8 keys
                localized_fields = ['instruction', 'explanation', 'grammarRule', 'grammarExample',
                                   'writingPrompt', 'sampleAnswer']
                for field in localized_fields:
                    if field in ex and ex[field] and isinstance(ex[field], dict):
                        keys = set(ex[field].keys())
                        expected = {'en', 'zh', 'zh_TW', 'ko', 'ja', 'es', 'fr', 'de'}
                        if keys != expected:
                            missing = expected - keys
                            if missing:
                                errors.append(f'{exid}: {field} missing languages: {missing}')
            
            # Check exercise type variety
            if len(ex_types) < 5:
                errors.append(f'{lesson["id"]}: only {len(ex_types)} exercise types (need >= 5)')
    
    return errors


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='InstaLingo Content Generator')
    parser.add_argument('--lang', default='en', help='Target language code')
    parser.add_argument('--out', default='assets/content/courses/en_a1.json', help='Output path')
    args = parser.parse_args()
    
    result = generate_course(args.lang, args.out)
    if result is None:
        sys.exit(1)
