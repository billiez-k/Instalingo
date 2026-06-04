#!/usr/bin/env python3
"""
Restructure demo_data.dart to use LocalizedText for all learning content.
Uses line-by-line parsing to correctly handle nested structures.
"""

import re
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent.resolve()
DATA_FILE = PROJECT_ROOT / "lib" / "data" / "demo_data.dart"

WORD_TRANSLATIONS = {
    'fragrance': {'zh': '香味', 'zh_TW': '香味', 'ko': '향기', 'ja': '香り', 'fr': 'parfum', 'es': 'fragancia', 'de': 'Duft'},
    'aroma': {'zh': '芳香', 'zh_TW': '芳香', 'ko': '향기', 'ja': '香り', 'fr': 'arôme', 'es': 'aroma', 'de': 'Aroma'},
    'dough': {'zh': '面团', 'zh_TW': '麵團', 'ko': '반죽', 'ja': '生地', 'fr': 'pâte', 'es': 'masa', 'de': 'Teig'},
    'breathtaking': {'zh': '令人惊叹的', 'zh_TW': '令人驚嘆的', 'ko': '숨막히는', 'ja': '息を呑むような', 'fr': 'à couper le souffle', 'es': 'impresionante', 'de': 'atemberaubend'},
    'debug': {'zh': '调试', 'zh_TW': '偵錯', 'ko': '디버그', 'ja': 'デバッグ', 'fr': 'déboguer', 'es': 'depurar', 'de': 'debuggen'},
    'vibrant': {'zh': '鲜艳的', 'zh_TW': '鮮豔的', 'ko': '생생한', 'ja': '鮮やかな', 'fr': 'vibrant', 'es': 'vibrante', 'de': 'lebhaft'},
    '매운': {'zh': '辣的', 'zh_TW': '辣的', 'ko': '매운', 'ja': '辛い', 'fr': 'épicé', 'es': 'picante', 'de': 'scharf'},
    '사랑': {'zh': '爱', 'zh_TW': '愛', 'ko': '사랑', 'ja': '愛', 'fr': 'amour', 'es': 'amor', 'de': 'Liebe'},
    '친구': {'zh': '朋友', 'zh_TW': '朋友', 'ko': '친구', 'ja': '友達', 'fr': 'ami', 'es': 'amigo', 'de': 'Freund'},
    '바다': {'zh': '大海', 'zh_TW': '大海', 'ko': '바다', 'ja': '海', 'fr': 'mer', 'es': 'mar', 'de': 'Meer'},
    '행복': {'zh': '幸福', 'zh_TW': '幸福', 'ko': '행복', 'ja': '幸せ', 'fr': 'bonheur', 'es': 'felicidad', 'de': 'Glück'},
    '꿈': {'zh': '梦想', 'zh_TW': '夢想', 'ko': '꿈', 'ja': '夢', 'fr': 'rêve', 'es': 'sueño', 'de': 'Traum'},
    '桜': {'zh': '樱花', 'zh_TW': '櫻花', 'ko': '벚꽃', 'ja': '桜', 'fr': 'cerisier', 'es': 'cerezo', 'de': 'Kirschblüte'},
    '美味しい': {'zh': '好吃的', 'zh_TW': '好吃的', 'ko': '맛있는', 'ja': '美味しい', 'fr': 'délicieux', 'es': 'delicioso', 'de': 'köstlich'},
    '猫': {'zh': '猫', 'zh_TW': '貓', 'ko': '고양이', 'ja': '猫', 'fr': 'chat', 'es': 'gato', 'de': 'Katze'},
    '本': {'zh': '书', 'zh_TW': '書', 'ko': '책', 'ja': '本', 'fr': 'livre', 'es': 'libro', 'de': 'Buch'},
    '沖縄': {'zh': '冲绳', 'zh_TW': '沖繩', 'ko': '오키나와', 'ja': '沖縄', 'fr': 'Okinawa', 'es': 'Okinawa', 'de': 'Okinawa'},
    '友達': {'zh': '朋友', 'zh_TW': '朋友', 'ko': '친구', 'ja': '友達', 'fr': 'ami', 'es': 'amigo', 'de': 'Freund'},
    'bonjour': {'zh': '你好', 'zh_TW': '你好', 'ko': '안녕하세요', 'ja': 'こんにちは', 'fr': 'bonjour', 'es': 'hola', 'de': 'Hallo'},
    'amour': {'zh': '爱', 'zh_TW': '愛', 'ko': '사랑', 'ja': '愛', 'fr': 'amour', 'es': 'amor', 'de': 'Liebe'},
    'fromage': {'zh': '奶酪', 'zh_TW': '起司', 'ko': '치즈', 'ja': 'チーズ', 'fr': 'fromage', 'es': 'queso', 'de': 'Käse'},
    'lumière': {'zh': '光', 'zh_TW': '光', 'ko': '빛', 'ja': '光', 'fr': 'lumière', 'es': 'luz', 'de': 'Licht'},
    'musique': {'zh': '音乐', 'zh_TW': '音樂', 'ko': '음악', 'ja': '音楽', 'fr': 'musique', 'es': 'música', 'de': 'Musik'},
    'voyage': {'zh': '旅行', 'zh_TW': '旅行', 'ko': '여행', 'ja': '旅行', 'fr': 'voyage', 'es': 'viaje', 'de': 'Reise'},
    'hola': {'zh': '你好', 'zh_TW': '你好', 'ko': '안녕하세요', 'ja': 'こんにちは', 'fr': 'bonjour', 'es': 'hola', 'de': 'Hallo'},
    'amigo': {'zh': '朋友', 'zh_TW': '朋友', 'ko': '친구', 'ja': '友達', 'fr': 'ami', 'es': 'amigo', 'de': 'Freund'},
    'familia': {'zh': '家人', 'zh_TW': '家人', 'ko': '가족', 'ja': '家族', 'fr': 'famille', 'es': 'familia', 'de': 'Familie'},
    'sol': {'zh': '太阳', 'zh_TW': '太陽', 'ko': '태양', 'ja': '太陽', 'fr': 'soleil', 'es': 'sol', 'de': 'Sonne'},
    'música': {'zh': '音乐', 'zh_TW': '音樂', 'ko': '음악', 'ja': '音楽', 'fr': 'musique', 'es': 'música', 'de': 'Musik'},
    'libre': {'zh': '自由', 'zh_TW': '自由', 'ko': '자유', 'ja': '自由', 'fr': 'libre', 'es': 'libre', 'de': 'frei'},
    '茶': {'zh': '茶', 'zh_TW': '茶', 'ko': '차', 'ja': '茶', 'fr': 'thé', 'es': 'té', 'de': 'Tee'},
    '爱': {'zh': '爱', 'zh_TW': '愛', 'ko': '사랑', 'ja': '愛', 'fr': 'amour', 'es': 'amor', 'de': 'Liebe'},
    '你好': {'zh': '你好', 'zh_TW': '你好', 'ko': '안녕하세요', 'ja': 'こんにちは', 'fr': 'bonjour', 'es': 'hola', 'de': 'Hallo'},
    '书': {'zh': '书', 'zh_TW': '書', 'ko': '책', 'ja': '本', 'fr': 'livre', 'es': 'libro', 'de': 'Buch'},
    '山': {'zh': '山', 'zh_TW': '山', 'ko': '산', 'ja': '山', 'fr': 'montagne', 'es': 'montaña', 'de': 'Berg'},
    '家': {'zh': '家', 'zh_TW': '家', 'ko': '집', 'ja': '家', 'fr': 'maison', 'es': 'casa', 'de': 'Zuhause'},
    'Brot': {'zh': '面包', 'zh_TW': '麵包', 'ko': '빵', 'ja': 'パン', 'fr': 'pain', 'es': 'pan', 'de': 'Brot'},
    'Freund': {'zh': '朋友', 'zh_TW': '朋友', 'ko': '친구', 'ja': '友達', 'fr': 'ami', 'es': 'amigo', 'de': 'Freund'},
    'Hallo': {'zh': '你好', 'zh_TW': '你好', 'ko': '안녕하세요', 'ja': 'こんにちは', 'fr': 'bonjour', 'es': 'hola', 'de': 'Hallo'},
    'Musik': {'zh': '音乐', 'zh_TW': '音樂', 'ko': '음악', 'ja': '音楽', 'fr': 'musique', 'es': 'música', 'de': 'Musik'},
    'Reise': {'zh': '旅行', 'zh_TW': '旅行', 'ko': '여행', 'ja': '旅行', 'fr': 'voyage', 'es': 'viaje', 'de': 'Reise'},
    'Liebe': {'zh': '爱', 'zh_TW': '愛', 'ko': '사랑', 'ja': '愛', 'fr': 'amour', 'es': 'amor', 'de': 'Liebe'},
}

EXPLANATION_ZH = {
    'fragrance': '一种从花朵或香水中散发出来的甜美怡人的气味。',
    'aroma': '一种独特的、通常令人愉悦的气味，尤其是来自咖啡、葡萄酒或香料的。',
    'dough': '一种由面粉和液体混合而成的浓稠可塑的面团，用于烘烤面包或糕点。',
    'breathtaking': '极其令人印象深刻、美丽或惊讶的，让人感到震撼的。',
    'debug': '找出并消除计算机硬件或软件中的错误。',
    'vibrant': '充满活力、生机勃勃，色彩明亮醒目的。',
    '매운': '具有强烈的辣椒或香料带来的热辣味道。',
    '사랑': '一种深厚、温柔而热烈的感情，是对某人深深的喜爱与关怀。',
    '친구': '一个你非常了解、信任并与之有深厚感情的人。',
    '바다': '覆盖地球大部分表面的广阔咸水水域。',
    '행복': '一种身心愉悦、满足和安宁的状态。',
    '꿈': '一个激励你不断前进的珍贵愿望或理想。',
    '桜': '日本樱花树或其花朵，美丽而短暂的象征。',
    '美味しい': '味道非常可口，让人愉悦。',
    '猫': '一种常见的家养宠物，深受喜爱。',
    '本': '由纸张装订而成的印刷作品，承载着知识。',
    '沖縄': '日本最南端的热带岛屿，以其美丽的海滩和独特的文化闻名。',
    '友達': '一个你非常了解、信任并与之有深厚感情的人。',
    'bonjour': '法语中最常见的问候语，适用于任何时间。',
    'amour': '一种深厚、温柔而热烈的感情，是对某人深深的喜爱与关怀。',
    'fromage': '用牛奶制成的食品，在法国文化中有丰富多样的品种。',
    'lumière': '使事物可见的自然能量，带来明亮和温暖。',
    'musique': '人声或乐器声组合而成的美好艺术形式，表达情感。',
    'voyage': '从一个地方到另一个地方的行为，尤其是长距离的旅程。',
    'hola': '西班牙语中最通用的问候语，任何时间都可以使用。',
    'amigo': '一个你非常了解、信任并与之有深厚感情的人。',
    'familia': '由血缘、婚姻或深厚感情联结在一起的一群人。',
    'sol': '地球围绕其运转的恒星，提供光和热。',
    'música': '人声或乐器声音组合而成的美好形式，表达情感。',
    'libre': '不受限制、可以随心所欲行动或选择的状态。',
    '茶': '用热水冲泡干茶叶制成的饮品，是中国文化的核心。',
    '爱': '一种深厚、温柔而热烈的感情，是对某人深深的喜爱与关怀。',
    '你好': '用来向他人打招呼的标准用语。',
    '书': '由纸张装订而成的印刷作品，承载着知识。',
    '山': '地球表面巨大的自然隆起，高耸入云。',
    '家': '一个人长期居住的地方，特别是与家人一起生活的地方。',
    'Brot': '用面粉和水烘烤而成的食品，是德国饮食的主食。',
    'Freund': '一个你非常了解、信任并与之有深厚感情的人。',
    'Hallo': '德语中最常见的问候语，适用于大多数情况。',
    'Musik': '人声或乐器声组合而成的美好艺术形式。',
    'Reise': '从一个地方到另一个地方的行为，尤其是长距离的旅程。',
    'Liebe': '一种深厚、温柔而热烈的感情，是对某人深深的喜爱与关怀。',
}

EXAMPLE_ZH = {
    'The fragrance of roses filled the garden.': '玫瑰的香味弥漫了整个花园。',
    'The aroma of freshly ground coffee woke everyone up.': '新鲜研磨的咖啡香气唤醒了所有人。',
    'She kneaded the dough until it was smooth and elastic.': '她揉面团直到它变得光滑有弹性。',
    'The view from the mountain was absolutely breathtaking.': '从山顶看到的景色绝对令人惊叹。',
    'It took three hours to debug the application.': '调试这个应用程序花了三个小时。',
    'The market was filled with vibrant colors and sounds.': '市场上充满了鲜艳的色彩和声音。',
    '이 음식은 정말 매워요.': '这个食物真的很辣。',
    '사랑은 아름다운 감정이에요.': '爱是一种美好的感情。',
    '제 친구는 정말 착해요.': '我的朋友真的很善良。',
    '바다를 보고 있으면 마음이 편안해져요.': '看着大海让我的心平静下来。',
    '행복은 작은 것에서 시작해요.': '幸福从小事开始。',
    '저의 꿈은 프로그래머가 되는 거예요.': '我的梦想是成为一名程序员。',
    '公園の桜が満開です。': '公园里的樱花正在盛开。',
    'このラーメンは本当に美味しいです。': '这个拉面真的很好吃。',
    '私の猫はとても可愛いです。': '我的猫非常可爱。',
    'この本はとても面白いです。': '这本书非常有趣。',
    '来月、沖縄へ旅行します。': '下个月，我将去冲绳旅行。',
    '彼は私の大切な友達です。': '他是我重要的朋友。',
    'Bonjour, comment allez-vous?': '你好，您好吗？',
    "L'amour est la plus belle chose au monde.": '爱是世界上最美好的事物。',
    'Le fromage français est délicieux.': '法国奶酪很美味。',
    'Le soleil illumine chaque coin.': '阳光照亮每一个角落。',
    "J'adore la musique classique.": '我喜欢古典音乐。',
    'Bon voyage et profite bien!': '旅途愉快，好好享受！',
    '¡Hola, cómo estás?': '你好，你好吗？',
    'Mi amigo toca la guitarra muy bien.': '我的朋友吉他弹得很好。',
    'Mi familia es muy importante para mí.': '我的家人对我来说非常重要。',
    'El sol brilla muy fuerte hoy.': '今天阳光非常强烈。',
    'Me encanta la música latina.': '我喜欢拉丁音乐。',
    'Ahora soy libre para viajar.': '现在我可以自由旅行了。',
    '请喝茶。': '请喝茶。',
    '我爱我的家人。': '我爱我的家人。',
    '你好，很高兴认识你。': '你好，很高兴认识你。',
    '我喜欢读书。': '我喜欢读书。',
    '这座山很高。': '这座山很高。',
    '我想回家。': '我想回家。',
    'Das Brot ist sehr frisch.': '面包非常新鲜。',
    'Mein Freund kommt aus Berlin.': '我的朋友来自柏林。',
    'Hallo, wie geht es dir?': '你好，你好吗？',
    'Ich höre gerne klassische Musik.': '我喜欢听古典音乐。',
    'Die Reise war wunderbar.': '这次旅行非常美好。',
    'Liebe macht blind.': '爱是盲目的。',
}

EXERCISE_EXPLANATION_ZH = {
    'ex_en_1': '"Hello" 是最常见的英语问候语。',
    'ex_en_2': '"How are you?" 用来询问对方的状况，是日常对话中最常见的句子之一。',
    'ex_en_5': '正确句子是 "I am a student."。',
    'ex_ko_1': '안녕하세요 (annyeonghaseyo) 是韩语中最标准、最礼貌的问候语。',
    'ex_ko_2': '감사합니다 (gamsahamnida) 是韩语中表示感谢的礼貌用语。',
    'ex_ko_5': '저는 학생입니다 (jeoneun haksaengimnida) = 我是学生。',
    'ex_ja_1': 'こんにちは (konnichiwa) 是日语中最标准的白天问候语。',
    'ex_ja_2': 'ありがとう (arigatou) 意为谢谢。加上 ございます 则更加礼貌。',
    'ex_ja_5': '私は田中です (watashi wa tanaka desu) = 我是田中。',
    'ex_fr_1': 'Bonjour 在法语中既可表示"早上好"也可表示"你好"。',
    'ex_fr_2': 'Merci 是法语中表示谢谢的标准方式。加上 "beaucoup" 则表示非常感谢。',
    'ex_fr_5': 'Je suis Marie = 我是玛丽。',
    'ex_es_1': 'Hola 是西班牙语中最通用的问候语，任何时间都可以使用。',
    'ex_es_2': 'Gracias 意为谢谢。"Muchas gracias" 表示非常感谢。',
    'ex_es_5': 'Yo soy Carlos = 我是卡洛斯。Soy 来自动词 ser。',
    'ex_zh_1': '你好 (nǐ hǎo) 是最标准的问候语。对长辈或重要人物使用 您好 (nín hǎo)。',
    'ex_zh_2': '谢谢 (xièxie) 意为感谢。"非常感谢" 表示非常感谢。',
    'ex_zh_5': '我是学生 (wǒ shì xuésheng) = 我是学生。不需要冠词！',
    'ex_de_1': 'Hallo 是非正式的问候语。Guten Tag 则是正式的。Hallo 在大多数情况下都适用。',
    'ex_de_2': 'Danke 意为谢谢。"Danke schön" 表示非常感谢。',
    'ex_de_5': 'Ich bin Marie = 我是玛丽。Bin 是动词 sein 的第一人称形式。',
}

GRAMMAR_RULE_ZH = {
    'ex_en_4': '在英语中，句子以大写字母开头，以句号结尾。',
    'ex_ko_4': '韩语句子的基本语序是主语-宾语-动词（SOV）。',
    'ex_ja_4': '日语助词标记单词的语法功能。は 标记主题，が 标记主语，を 标记宾语。',
    'ex_fr_4': '每个法语名词都有性别：阳性或阴性。冠词必须与名词的性别一致。',
    'ex_es_4': '西班牙语有两个动词表示"是"：Ser（永久/身份）和 Estar（临时/状态）。',
    'ex_zh_4': '汉语的词序与英语一样，是主语-动词-宾语。不需要冠词或动词变位。',
}

GRAMMAR_EXAMPLE_ZH = {
    'ex_en_4': 'Hello. My name is John.',
    'ex_ko_4': '저는 사과를 먹습니다 = 我吃苹果。',
    'ex_ja_4': '私は本を読みます = 我读书。',
    'ex_fr_4': 'Le livre (阳性) / La table (阴性)',
    'ex_es_4': 'Ser: Yo soy médico. Estar: Yo estoy cansado.',
    'ex_zh_4': '我是学生。I am a student.',
}


def build_lt(en_val, translations_dict):
    """Build LocalizedText string."""
    en_esc = en_val.replace("'", "\\'")
    parts = [f"'en': '{en_esc}'"]
    for lang in ['zh', 'zh_TW', 'ko', 'ja', 'fr', 'es', 'de']:
        val = translations_dict.get(lang, en_val)
        val_esc = val.replace("'", "\\'")
        parts.append(f"'{lang}': '{val_esc}'")
    return f"const LocalizedText({{{', '.join(parts)}}})"


def transform_posts(lines):
    """Transform Post fields line by line."""
    result = []
    in_post = False
    in_post_comment = False
    target_word = None
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        if stripped.startswith('Post('):
            in_post = True
            in_post_comment = False
            target_word = None
            result.append(line)
            i += 1
            continue

        if stripped.startswith('PostComment('):
            in_post_comment = True
            result.append(line)
            i += 1
            continue

        if stripped == '),' and in_post_comment:
            in_post_comment = False
            result.append(line)
            i += 1
            continue

        # If we hit a closing `),` that's indented ~10 spaces, it's the Post closing
        if stripped == '),' and in_post and not in_post_comment:
            in_post = False
            result.append(line)
            i += 1
            continue

        if not in_post or in_post_comment:
            result.append(line)
            i += 1
            continue

        # Inside a Post block
        if stripped.startswith('targetWord:'):
            m = re.search(r"targetWord:\s*'([^']+)'", stripped)
            if m:
                target_word = m.group(1)
            result.append(line)
            i += 1
            continue

        if stripped.startswith('wordTranslation:'):
            m = re.search(r"wordTranslation:\s*'([^']+)'", stripped)
            if m and target_word:
                old_val = m.group(1)
                trans = WORD_TRANSLATIONS.get(target_word, {})
                all_trans = {'en': target_word}
                all_trans.update(trans)
                lt = build_lt(target_word, all_trans)
                # Replace the value in the line
                new_line = line.replace(f"wordTranslation: '{old_val}'", f"wordTranslation: {lt}")
                result.append(new_line)
            else:
                result.append(line)
            i += 1
            continue

        if stripped.startswith('wordExplanation:'):
            m = re.search(r"wordExplanation:\s*'([^']+)'", stripped)
            if m:
                en_val = m.group(1)
                zh_val = EXPLANATION_ZH.get(target_word, en_val) if target_word else en_val
                lt = build_lt(en_val, {'zh': zh_val, 'zh_TW': zh_val})
                new_line = line.replace(f"wordExplanation: '{en_val}'", f"wordExplanation: {lt}")
                result.append(new_line)
            else:
                result.append(line)
            i += 1
            continue

        if stripped.startswith('wordExample:'):
            # Pattern: wordExample: 'Target sentence. (English translation.)',
            m = re.search(r"wordExample:\s*'([^']+\.?) \(([^)]+)\)'", stripped)
            if m:
                target_sentence = m.group(1).strip()
                en_trans = m.group(2).strip()
                zh_trans = EXAMPLE_ZH.get(en_trans, en_trans)
                lt = build_lt(en_trans, {'zh': zh_trans, 'zh_TW': zh_trans})
                # Replace line with two fields
                indent = line[:len(line) - len(line.lstrip())]
                new_line1 = f"{indent}wordExample: '{target_sentence}',\n"
                new_line2 = f"{indent}wordExampleTranslation: {lt},\n"
                result.append(new_line1 + '\n')
                result.append(new_line2 + '\n')
            else:
                result.append(line)
            i += 1
            continue

        result.append(line)
        i += 1

    return result


def transform_exercises(lines):
    """Transform Exercise fields line by line."""
    result = []
    in_exercise = False
    ex_id = None
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        if stripped.startswith('const Exercise('):
            in_exercise = True
            ex_id = None
            result.append(line)
            i += 1
            continue

        if stripped == '),' and in_exercise:
            in_exercise = False
            result.append(line)
            i += 1
            continue

        if not in_exercise:
            result.append(line)
            i += 1
            continue

        if stripped.startswith('id:'):
            m = re.search(r"id:\s*'([^']+)'", stripped)
            if m:
                ex_id = m.group(1)
            result.append(line)
            i += 1
            continue

        for field_name in ['explanation:', 'grammarRule:', 'grammarExample:', 'writingPrompt:', 'sampleAnswer:']:
            if stripped.startswith(field_name):
                m = re.search(rf"{field_name}\s*'([^']+)'", stripped)
                if m:
                    en_val = m.group(1)
                    if field_name == 'explanation:':
                        zh_val = EXERCISE_EXPLANATION_ZH.get(ex_id, en_val) if ex_id else en_val
                    elif field_name == 'grammarRule:':
                        zh_val = GRAMMAR_RULE_ZH.get(ex_id, en_val) if ex_id else en_val
                    elif field_name == 'grammarExample:':
                        zh_val = GRAMMAR_EXAMPLE_ZH.get(ex_id, en_val) if ex_id else en_val
                    else:
                        zh_val = en_val
                    lt = build_lt(en_val, {'zh': zh_val, 'zh_TW': zh_val})
                    new_line = line.replace(f"{field_name} '{en_val}'", f"{field_name} {lt}")
                    result.append(new_line)
                else:
                    result.append(line)
                i += 1
                break
        else:
            result.append(line)
            i += 1

    return result


def main():
    lines = DATA_FILE.read_text(encoding="utf-8").splitlines(keepends=True)

    print("Transforming posts...")
    lines = transform_posts(lines)

    print("Transforming exercises...")
    lines = transform_exercises(lines)

    DATA_FILE.write_text(''.join(lines), encoding="utf-8")
    print(f"Done. Wrote restructured file to {DATA_FILE}")


if __name__ == "__main__":
    main()
