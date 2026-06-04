#!/usr/bin/env python3
"""
Completely rewrite all non-English post sections in demo_data.dart
to teach target-language vocabulary with LocalizedText fields.
"""

import re
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent.resolve()
DATA_FILE = PROJECT_ROOT / "lib" / "data" / "demo_data.dart"


def build_lt(en_val, trans):
    en_esc = en_val.replace("'", "\\'")
    parts = [f"'en': '{en_esc}'"]
    for lang in ['zh', 'zh_TW', 'ko', 'ja', 'fr', 'es', 'de']:
        val = trans.get(lang, en_val).replace("'", "\\'")
        parts.append(f"'{lang}': '{val}'")
    return f"const LocalizedText({{{', '.join(parts)}}})"


POST_TEMPLATES = {
    'korean': [
        {
            'id': 'p_ko_1', 'author': 'Minji', 'handle': '@minjikfood',
            'content': 'Making kimchi jjigae today! Korean word: 매워요 (mae-un) — the taste that makes Korean food unforgettable!',
            'target': '매운', 'phonetic': '/mɛ.un/',
            'trans': {'en': 'spicy', 'zh': '辣的', 'zh_TW': '辣的', 'ko': '매운', 'ja': '辛い', 'fr': 'épicé', 'es': 'picante', 'de': 'scharf'},
            'expl': {'en': 'Having a strong, hot taste from chili peppers or spices.', 'zh': '具有强烈的辣椒或香料带来的热辣味道。', 'zh_TW': '具有強烈的辣椒或香料帶來的熱辣味。'},
            'example': '이 음식은 정말 매워요.', 'ex_trans': {'en': 'This food is really spicy.', 'zh': '这个食物真的很辣。', 'zh_TW': '這個食物真的很辣。'},
            'likes': 445, 'tags': "['korean', 'food', 'vocabulary']",
            'location': 'Seoul, Korea', 'char_type': 'chef', 'char_bio': 'Seoul chef sharing Korean food culture and daily vocabulary.',
        },
        {
            'id': 'p_ko_2', 'author': 'Jisoo', 'handle': '@jisookpop',
            'content': 'Learning Korean through K-pop lyrics! Today\'s word: 사랑 (sarang) — the most beautiful word in any language.',
            'target': '사랑', 'phonetic': '/sa.ɾaŋ/',
            'trans': {'en': 'love', 'zh': '爱', 'zh_TW': '愛', 'ko': '사랑', 'ja': '愛', 'fr': 'amour', 'es': 'amor', 'de': 'Liebe'},
            'expl': {'en': 'An intense feeling of deep affection and care for someone.', 'zh': '一种深厚、温柔而热烈的感情，是对某人深深的喜爱与关怀。', 'zh_TW': '一種深厚、溫柔而熱烈的感情。'},
            'example': '사랑은 아름다운 감정이에요.', 'ex_trans': {'en': 'Love is a beautiful feeling.', 'zh': '爱是一种美好的感情。', 'zh_TW': '愛是一種美好的感情。'},
            'likes': 612, 'tags': "['korean', 'emotions', 'vocabulary']",
            'location': 'Busan, Korea', 'char_type': 'singer', 'char_bio': 'K-pop fan teaching Korean through lyrics and emotions.',
        },
        {
            'id': 'p_ko_3', 'author': 'Hyunwoo', 'handle': '@hyunwoohangul',
            'content': 'Hanging out with my best friend at a cafe. Korean word: 친구 (chin-gu) — the person who makes every moment better!',
            'target': '친구', 'phonetic': '/tɕʰin.gu/',
            'trans': {'en': 'friend', 'zh': '朋友', 'zh_TW': '朋友', 'ko': '친구', 'ja': '友達', 'fr': 'ami', 'es': 'amigo', 'de': 'Freund'},
            'expl': {'en': 'A person you know well and regard with affection and trust.', 'zh': '一个你非常了解、信任并与之有深厚感情的人。', 'zh_TW': '一個你非常了解、信任並與之有深厚感情的人。'},
            'example': '제 친구는 정말 착해요.', 'ex_trans': {'en': 'My friend is really kind.', 'zh': '我的朋友真的很善良。', 'zh_TW': '我的朋友真的很善良。'},
            'likes': 534, 'tags': "['korean', 'social', 'vocabulary']",
            'location': 'Seoul, Korea', 'char_type': 'student', 'char_bio': 'Seoul student sharing daily life and friendship vocabulary.',
        },
        {
            'id': 'p_ko_4', 'author': 'Yuna', 'handle': '@yunakorea',
            'content': 'Sunset at Busan beach was stunning. Korean word: 바다 (ba-da) — the endless blue that calms the soul.',
            'target': '바다', 'phonetic': '/pa.da/',
            'trans': {'en': 'sea / ocean', 'zh': '大海', 'zh_TW': '大海', 'ko': '바다', 'ja': '海', 'fr': 'mer', 'es': 'mar', 'de': 'Meer'},
            'expl': {'en': 'The vast body of salt water that covers most of the Earth\'s surface.', 'zh': '覆盖地球大部分表面的广阔咸水水域。', 'zh_TW': '覆蓋地球大部分表面的廣闊鹹水水域。'},
            'example': '바다를 보고 있으면 마음이 편안해져요.', 'ex_trans': {'en': 'Looking at the sea calms my mind.', 'zh': '看着大海让我的心平静下来。', 'zh_TW': '看著大海讓我的心平靜下來。'},
            'likes': 478, 'tags': "['korean', 'nature', 'vocabulary']",
            'location': 'Busan, Korea', 'char_type': 'photographer', 'char_bio': 'Busan photographer chasing sunsets and teaching Korean nature words.',
        },
        {
            'id': 'p_ko_5', 'author': 'Eunji', 'handle': '@eunjilife',
            'content': 'Graduated today and feeling so grateful! Korean word: 행복 (haeng-bok) — that warm feeling when everything feels right.',
            'target': '행복', 'phonetic': '/hɛŋ.bok/',
            'trans': {'en': 'happiness', 'zh': '幸福', 'zh_TW': '幸福', 'ko': '행복', 'ja': '幸せ', 'fr': 'bonheur', 'es': 'felicidad', 'de': 'Glück'},
            'expl': {'en': 'A state of well-being, joy, and contentment with life.', 'zh': '一种身心愉悦、满足和安宁的状态。', 'zh_TW': '一種身心愉悅、滿足和安寧的狀態。'},
            'example': '행복은 작은 것에서 시작해요.', 'ex_trans': {'en': 'Happiness starts from small things.', 'zh': '幸福从小事开始。', 'zh_TW': '幸福從小事開始。'},
            'likes': 567, 'tags': "['korean', 'life', 'vocabulary']",
            'location': 'Seoul, Korea', 'char_type': 'teacher', 'char_bio': 'Seoul teacher sharing life moments and empowering Korean vocabulary.',
        },
        {
            'id': 'p_ko_6', 'author': 'Donghyun', 'handle': '@donghyundream',
            'content': 'Working hard to become a developer. Korean word: 꿈 (kkum) — the vision that keeps you going every single day.',
            'target': '꿈', 'phonetic': '/k͈um/',
            'trans': {'en': 'dream', 'zh': '梦想', 'zh_TW': '夢想', 'ko': '꿈', 'ja': '夢', 'fr': 'rêve', 'es': 'sueño', 'de': 'Traum'},
            'expl': {'en': 'A cherished aspiration, ambition, or ideal that motivates you.', 'zh': '一个激励你不断前进的珍贵愿望或理想。', 'zh_TW': '一個激勵你不斷前進的珍貴願望或理想。'},
            'example': '저의 꿈은 프로그래머가 되는 거예요.', 'ex_trans': {'en': 'My dream is to become a programmer.', 'zh': '我的梦想是成为一名程序员。', 'zh_TW': '我的夢想是成為一名程式設計師。'},
            'likes': 389, 'tags': "['korean', 'career', 'vocabulary']",
            'location': 'Seoul, Korea', 'char_type': 'developer', 'char_bio': 'Korean developer sharing career vocabulary and daily motivation.',
        },
    ],
    'japanese': [
        {
            'id': 'p_ja_1', 'author': 'Hana', 'handle': '@hanaanime',
            'content': 'Watching cherry blossoms today. Japanese word: 桜 (sakura) — the flower that captures the heart of every spring in Japan.',
            'target': '桜', 'phonetic': '/sa.ku.ɾa/',
            'trans': {'en': 'cherry blossom', 'zh': '樱花', 'zh_TW': '櫻花', 'ko': '벚꽃', 'ja': '桜', 'fr': 'cerisier', 'es': 'cerezo', 'de': 'Kirschblüte'},
            'expl': {'en': 'The Japanese cherry blossom tree or its flower; a symbol of beauty and transience.', 'zh': '日本樱花树或其花朵，美丽而短暂的象征。', 'zh_TW': '日本櫻花樹或其花朵，美麗而短暫的象徵。'},
            'example': '公園の桜が満開です。', 'ex_trans': {'en': 'The cherry blossoms in the park are in full bloom.', 'zh': '公园里的樱花正在盛开。', 'zh_TW': '公園裡的櫻花正在盛開。'},
            'likes': 534, 'tags': "['japanese', 'nature', 'vocabulary']",
            'location': 'Tokyo, Japan', 'char_type': 'student', 'char_bio': 'Tokyo native sharing Japanese culture and seasonal vocabulary.',
        },
        {
            'id': 'p_ja_2', 'author': 'Takeshi', 'handle': '@takeshiramen',
            'content': 'Perfect ramen weather! Japanese word: 美味しい (oishii) — the single most important word for any food lover in Japan.',
            'target': '美味しい', 'phonetic': '/o.i.ɕi.i/',
            'trans': {'en': 'delicious', 'zh': '好吃的', 'zh_TW': '好吃的', 'ko': '맛있는', 'ja': '美味しい', 'fr': 'délicieux', 'es': 'delicioso', 'de': 'köstlich'},
            'expl': {'en': 'Having a very pleasant taste; delightful to the palate.', 'zh': '味道非常可口，让人愉悦。', 'zh_TW': '味道非常可口，讓人愉悅。'},
            'example': 'このラーメンは本当に美味しいです。', 'ex_trans': {'en': 'This ramen is really delicious.', 'zh': '这个拉面真的很好吃。', 'zh_TW': '這個拉麵真的很好吃。'},
            'likes': 612, 'tags': "['japanese', 'food', 'vocabulary']",
            'location': 'Osaka, Japan', 'char_type': 'chef', 'char_bio': 'Ramen chef in Osaka sharing the best Japanese food vocabulary.',
        },
        {
            'id': 'p_ja_3', 'author': 'Yuki', 'handle': '@yukicat',
            'content': 'My neighbor\'s cat visited again! Japanese word: 猫 (neko) — the unofficial mascot of the internet and Japan alike.',
            'target': '猫', 'phonetic': '/ne.ko/',
            'trans': {'en': 'cat', 'zh': '猫', 'zh_TW': '貓', 'ko': '고양이', 'ja': '猫', 'fr': 'chat', 'es': 'gato', 'de': 'Katze'},
            'expl': {'en': 'A small domesticated carnivorous mammal with soft fur, a short snout, and retractable claws.', 'zh': '一种常见的家养宠物，深受喜爱。', 'zh_TW': '一種常見的家養寵物，深受喜愛。'},
            'example': '私の猫はとても可愛いです。', 'ex_trans': {'en': 'My cat is very cute.', 'zh': '我的猫非常可爱。', 'zh_TW': '我的貓非常可愛。'},
            'likes': 445, 'tags': "['japanese', 'animals', 'vocabulary']",
            'location': 'Kyoto, Japan', 'char_type': 'artist', 'char_bio': 'Kyoto cat lover sharing Japanese animal vocabulary.',
        },
        {
            'id': 'p_ja_4', 'author': 'Akira', 'handle': '@akirabooks',
            'content': 'Visiting the bookstore today. Japanese word: 本 (hon) — the vessel that carries knowledge across generations.',
            'target': '本', 'phonetic': '/hoɴ/',
            'trans': {'en': 'book', 'zh': '书', 'zh_TW': '書', 'ko': '책', 'ja': '本', 'fr': 'livre', 'es': 'libro', 'de': 'Buch'},
            'expl': {'en': 'A written or printed work consisting of pages bound together.', 'zh': '由纸张装订而成的印刷作品，承载着知识。', 'zh_TW': '由紙張裝訂而成的印刷作品，承載著知識。'},
            'example': 'この本はとても面白いです。', 'ex_trans': {'en': 'This book is very interesting.', 'zh': '这本书非常有趣。', 'zh_TW': '這本書非常有趣。'},
            'likes': 389, 'tags': "['japanese', 'reading', 'vocabulary']",
            'location': 'Tokyo, Japan', 'char_type': 'writer', 'char_bio': 'Tokyo writer sharing Japanese literary vocabulary.',
        },
        {
            'id': 'p_ja_5', 'author': 'Saki', 'handle': '@sakitravel',
            'content': 'Planning my Okinawa trip! Japanese word: 沖縄 (Okinawa) — Japan\'s southernmost tropical paradise with unique culture.',
            'target': '沖縄', 'phonetic': '/o.ki.na.wa/',
            'trans': {'en': 'Okinawa', 'zh': '冲绳', 'zh_TW': '沖繩', 'ko': '오키나와', 'ja': '沖縄', 'fr': 'Okinawa', 'es': 'Okinawa', 'de': 'Okinawa'},
            'expl': {'en': 'Japan\'s southernmost tropical island prefecture, famous for beaches, coral reefs, and unique Ryukyuan culture.', 'zh': '日本最南端的热带岛屿，以其美丽的海滩和独特的文化闻名。', 'zh_TW': '日本最南端的熱帶島嶼，以其美麗的海灘和獨特的文化聞名。'},
            'example': '来月、沖縄へ旅行します。', 'ex_trans': {'en': 'Next month, I will travel to Okinawa.', 'zh': '下个月，我将去冲绳旅行。', 'zh_TW': '下個月，我將去沖繩旅行。'},
            'likes': 478, 'tags': "['japanese', 'travel', 'vocabulary']",
            'location': 'Okinawa, Japan', 'char_type': 'traveler', 'char_bio': 'Japanese traveler exploring Okinawa and sharing travel vocabulary.',
        },
        {
            'id': 'p_ja_6', 'author': 'Ken', 'handle': '@kenfriends',
            'content': 'Meeting my language partner today! Japanese word: 友達 (tomodachi) — the companion who makes every journey worth taking.',
            'target': '友達', 'phonetic': '/to.mo.da.tɕi/',
            'trans': {'en': 'friend', 'zh': '朋友', 'zh_TW': '朋友', 'ko': '친구', 'ja': '友達', 'fr': 'ami', 'es': 'amigo', 'de': 'Freund'},
            'expl': {'en': 'A person you know well and regard with affection and trust.', 'zh': '一个你非常了解、信任并与之有深厚感情的人。', 'zh_TW': '一個你非常了解、信任並與之有深厚感情的人。'},
            'example': '彼は私の大切な友達です。', 'ex_trans': {'en': 'He is my important friend.', 'zh': '他是我重要的朋友。', 'zh_TW': '他是我重要的朋友。'},
            'likes': 523, 'tags': "['japanese', 'social', 'vocabulary']",
            'location': 'Osaka, Japan', 'char_type': 'teacher', 'char_bio': 'Osaka language teacher sharing friendship and social vocabulary.',
        },
    ],
    'french': [
        {
            'id': 'p_fr_1', 'author': 'Claire', 'handle': '@claireboulangerie',
            'content': 'Fresh croissants out of the oven! French word: bonjour — the key that opens every door in France.',
            'target': 'bonjour', 'phonetic': '/bɔ̃.ʒuʁ/',
            'trans': {'en': 'hello', 'zh': '你好', 'zh_TW': '你好', 'ko': '안녕하세요', 'ja': 'こんにちは', 'fr': 'bonjour', 'es': 'hola', 'de': 'Hallo'},
            'expl': {'en': 'The standard French greeting used to say hello to someone, literally meaning "good day".', 'zh': '法语中最常见的问候语，字面意思是"美好的一天"。', 'zh_TW': '法語中最常見的問候語，字面意思是"美好的一天"。'},
            'example': 'Bonjour, comment allez-vous?', 'ex_trans': {'en': 'Hello, how are you?', 'zh': '你好，您好吗？', 'zh_TW': '你好，您好嗎？'},
            'likes': 567, 'tags': "['french', 'greetings', 'vocabulary']",
            'location': 'Lyon, France', 'char_type': 'baker', 'char_bio': 'Third-generation baker in Lyon sharing French daily vocabulary.',
        },
        {
            'id': 'p_fr_2', 'author': 'Julien', 'handle': '@julienartist',
            'content': 'Painting by the Seine today. French word: amour — the force that inspired every French poet.',
            'target': 'amour', 'phonetic': '/a.muʁ/',
            'trans': {'en': 'love', 'zh': '爱', 'zh_TW': '愛', 'ko': '사랑', 'ja': '愛', 'fr': 'amour', 'es': 'amor', 'de': 'Liebe'},
            'expl': {'en': 'A deep, tender, and passionate feeling of affection and care for another person.', 'zh': '一种深厚、温柔而热烈的感情，是对某人深深的喜爱与关怀。', 'zh_TW': '一種深厚、溫柔而熱烈的感情。'},
            'example': "L'amour est la plus belle chose au monde.", 'ex_trans': {'en': 'Love is the most beautiful thing in the world.', 'zh': '爱是世界上最美好的事物。', 'zh_TW': '愛是世界上最美好的事物。'},
            'likes': 612, 'tags': "['french', 'emotions', 'vocabulary']",
            'location': 'Paris, France', 'char_type': 'poet', 'char_bio': 'Parisian artist sharing French culture and romantic vocabulary.',
        },
        {
            'id': 'p_fr_3', 'author': 'Camille', 'handle': '@camillecheese',
            'content': 'Cheese tasting with my grandmother. French word: fromage — the soul of every French meal.',
            'target': 'fromage', 'phonetic': '/fʁɔ.maʒ/',
            'trans': {'en': 'cheese', 'zh': '奶酪', 'zh_TW': '起司', 'ko': '치즈', 'ja': 'チーズ', 'fr': 'fromage', 'es': 'queso', 'de': 'Käse'},
            'expl': {'en': 'A food made from the pressed curds of milk, with hundreds of varieties in France alone.', 'zh': '用牛奶制成的食品，在法国有数百种不同的品种。', 'zh_TW': '用牛奶製成的食品，在法國有數百種不同的品種。'},
            'example': 'Le fromage français est délicieux.', 'ex_trans': {'en': 'French cheese is delicious.', 'zh': '法国奶酪很美味。', 'zh_TW': '法國起司很美味。'},
            'likes': 423, 'tags': "['french', 'food', 'vocabulary']",
            'location': 'Normandy, France', 'char_type': 'chef', 'char_bio': 'French cheese expert exploring regional varieties and vocabulary.',
        },
        {
            'id': 'p_fr_4', 'author': 'Luc', 'handle': '@lucnature',
            'content': 'Sunrise over the lavender fields. French word: lumière — the golden gift of every Provence morning.',
            'target': 'lumière', 'phonetic': '/ly.mjɛʁ/',
            'trans': {'en': 'light', 'zh': '光', 'zh_TW': '光', 'ko': '빛', 'ja': '光', 'fr': 'lumière', 'es': 'luz', 'de': 'Licht'},
            'expl': {'en': 'The natural agent that stimulates sight and makes things visible; also a source of hope or inspiration.', 'zh': '使事物可见的自然能量，也是希望或灵感的源泉。', 'zh_TW': '使事物可見的自然能量，也是希望或靈感的源泉。'},
            'example': 'Le soleil illumine chaque coin.', 'ex_trans': {'en': 'The sun lights up every corner.', 'zh': '阳光照亮每一个角落。', 'zh_TW': '陽光照亮每一個角落。'},
            'likes': 498, 'tags': "['french', 'nature', 'vocabulary']",
            'location': 'Provence, France', 'char_type': 'gardener', 'char_bio': 'Provence gardener sharing French nature and light vocabulary.',
        },
        {
            'id': 'p_fr_5', 'author': 'Marie', 'handle': '@mariemusic',
            'content': 'Jazz night in Marseille! French word: musique — the language Beethoven, Bach, and Debussy spoke fluently.',
            'target': 'musique', 'phonetic': '/my.zik/',
            'trans': {'en': 'music', 'zh': '音乐', 'zh_TW': '音樂', 'ko': '음악', 'ja': '音楽', 'fr': 'musique', 'es': 'música', 'de': 'Musik'},
            'expl': {'en': 'Vocal or instrumental sounds combined to produce beauty of form, harmony, and expression of emotion.', 'zh': '人声或乐器声组合而成的美好艺术形式，表达情感。', 'zh_TW': '人聲或樂器聲組合而成的美好藝術形式，表達情感。'},
            'example': "J'adore la musique classique.", 'ex_trans': {'en': 'I love classical music.', 'zh': '我喜欢古典音乐。', 'zh_TW': '我喜歡古典音樂。'},
            'likes': 389, 'tags': "['french', 'arts', 'vocabulary']",
            'location': 'Marseille, France', 'char_type': 'musician', 'char_bio': 'French jazz singer sharing musical vocabulary from the south of France.',
        },
        {
            'id': 'p_fr_6', 'author': 'Pierre', 'handle': '@pierretravel',
            'content': 'Road trip through the Alps! French word: voyage — the adventure that begins the moment you leave your door.',
            'target': 'voyage', 'phonetic': '/vwa.jaʒ/',
            'trans': {'en': 'journey / travel', 'zh': '旅行', 'zh_TW': '旅行', 'ko': '여행', 'ja': '旅行', 'fr': 'voyage', 'es': 'viaje', 'de': 'Reise'},
            'expl': {'en': 'The act of going from one place to another, especially over a long distance.', 'zh': '从一个地方到另一个地方的行为，尤其是长距离的旅程。', 'zh_TW': '從一個地方到另一個地方的行為，尤其是長距離的旅程。'},
            'example': 'Bon voyage et profite bien!', 'ex_trans': {'en': 'Have a good trip and enjoy yourself!', 'zh': '旅途愉快，好好享受！', 'zh_TW': '旅途愉快，好好享受！'},
            'likes': 612, 'tags': "['french', 'travel', 'vocabulary']",
            'location': 'Nice, France', 'char_type': 'traveler', 'char_bio': 'French traveler exploring every region and sharing vocabulary.',
        },
    ],
    'spanish': [
        {
            'id': 'p_es_1', 'author': 'Sofia', 'handle': '@sofiatapas',
            'content': 'Making tapas for friends tonight! Spanish word: hola — the simplest and most powerful word to start any conversation.',
            'target': 'hola', 'phonetic': '/ˈo.la/',
            'trans': {'en': 'hello', 'zh': '你好', 'zh_TW': '你好', 'ko': '안녕하세요', 'ja': 'こんにちは', 'fr': 'bonjour', 'es': 'hola', 'de': 'Hallo'},
            'expl': {'en': 'The standard Spanish greeting used to say hello to someone.', 'zh': '西班牙语中最通用的问候语，用来向他人打招呼。', 'zh_TW': '西班牙語中最通用的問候語。'},
            'example': '¡Hola, cómo estás?', 'ex_trans': {'en': 'Hello, how are you?', 'zh': '你好，你好吗？', 'zh_TW': '你好，你好嗎？'},
            'likes': 567, 'tags': "['spanish', 'greetings', 'vocabulary']",
            'location': 'Barcelona, Spain', 'char_type': 'chef', 'char_bio': 'Barcelona chef sharing Spanish culture and daily vocabulary.',
        },
        {
            'id': 'p_es_2', 'author': 'Mateo', 'handle': '@mateoflamenco',
            'content': 'Practicing flamenco guitar. Spanish word: amigo — the person who shares your joy and your tapas!',
            'target': 'amigo', 'phonetic': '/aˈmi.ɣo/',
            'trans': {'en': 'friend', 'zh': '朋友', 'zh_TW': '朋友', 'ko': '친구', 'ja': '友達', 'fr': 'ami', 'es': 'amigo', 'de': 'Freund'},
            'expl': {'en': 'A person you know well and regard with affection and trust.', 'zh': '一个你非常了解、信任并与之有深厚感情的人。', 'zh_TW': '一個你非常了解、信任並與之有深厚感情的人。'},
            'example': 'Mi amigo toca la guitarra muy bien.', 'ex_trans': {'en': 'My friend plays the guitar very well.', 'zh': '我的朋友吉他弹得很好。', 'zh_TW': '我的朋友吉他彈得很好。'},
            'likes': 423, 'tags': "['spanish', 'social', 'vocabulary']",
            'location': 'Seville, Spain', 'char_type': 'musician', 'char_bio': 'Flamenco guitarist from Seville sharing music and Spanish vocabulary.',
        },
        {
            'id': 'p_es_3', 'author': 'Carmen', 'handle': '@carmenfamily',
            'content': 'Sunday lunch with the whole crew. Spanish word: familia — the heart of every Spanish household and celebration.',
            'target': 'familia', 'phonetic': '/faˈmi.lja/',
            'trans': {'en': 'family', 'zh': '家人', 'zh_TW': '家人', 'ko': '가족', 'ja': '家族', 'fr': 'famille', 'es': 'familia', 'de': 'Familie'},
            'expl': {'en': 'A group of people related by blood, marriage, or strong bonds of affection.', 'zh': '由血缘、婚姻或深厚感情联结在一起的一群人。', 'zh_TW': '由血緣、婚姻或深厚感情聯結在一起的一群人。'},
            'example': 'Mi familia es muy importante para mí.', 'ex_trans': {'en': 'My family is very important to me.', 'zh': '我的家人对我来说非常重要。', 'zh_TW': '我的家人對我來說非常重要。'},
            'likes': 612, 'tags': "['spanish', 'family', 'vocabulary']",
            'location': 'Madrid, Spain', 'char_type': 'teacher', 'char_bio': 'Madrid teacher sharing family traditions and Spanish vocabulary.',
        },
        {
            'id': 'p_es_4', 'author': 'Diego', 'handle': '@diegobeach',
            'content': 'Beach day in Valencia! Spanish word: sol — the golden companion of every perfect Spanish afternoon.',
            'target': 'sol', 'phonetic': '/sol/',
            'trans': {'en': 'sun', 'zh': '太阳', 'zh_TW': '太陽', 'ko': '태양', 'ja': '太陽', 'fr': 'soleil', 'es': 'sol', 'de': 'Sonne'},
            'expl': {'en': 'The star around which the Earth orbits, providing light and warmth.', 'zh': '地球围绕其运转的恒星，提供光和热。', 'zh_TW': '地球圍繞其運轉的恆星，提供光和熱。'},
            'example': 'El sol brilla muy fuerte hoy.', 'ex_trans': {'en': 'The sun shines very strongly today.', 'zh': '今天阳光非常强烈。', 'zh_TW': '今天陽光非常強烈。'},
            'likes': 734, 'tags': "['spanish', 'nature', 'vocabulary']",
            'location': 'Valencia, Spain', 'char_type': 'surfer', 'char_bio': 'Valencia surfer chasing waves and teaching Spanish nature words.',
        },
        {
            'id': 'p_es_5', 'author': 'Lucia', 'handle': '@luciamusic',
            'content': 'Salsa dancing tonight! Spanish word: música — the rhythm that makes every Spanish night unforgettable.',
            'target': 'música', 'phonetic': '/ˈmu.si.ka/',
            'trans': {'en': 'music', 'zh': '音乐', 'zh_TW': '音樂', 'ko': '음악', 'ja': '音楽', 'fr': 'musique', 'es': 'música', 'de': 'Musik'},
            'expl': {'en': 'Vocal or instrumental sounds combined to produce beauty of form and expression of emotion.', 'zh': '人声或乐器声音组合而成的美好形式，表达情感。', 'zh_TW': '人聲或樂器聲音組合而成的美好形式，表達情感。'},
            'example': 'Me encanta la música latina.', 'ex_trans': {'en': 'I love Latin music.', 'zh': '我喜欢拉丁音乐。', 'zh_TW': '我喜歡拉丁音樂。'},
            'likes': 498, 'tags': "['spanish', 'arts', 'vocabulary']",
            'location': 'Granada, Spain', 'char_type': 'dancer', 'char_bio': 'Granada dancer sharing the passion of Spanish music vocabulary.',
        },
        {
            'id': 'p_es_6', 'author': 'Javier', 'handle': '@javierfree',
            'content': 'Just quit my 9-to-5 to become a digital nomad. Spanish word: libre — the word that changes everything.',
            'target': 'libre', 'phonetic': '/ˈli.βɾe/',
            'trans': {'en': 'free', 'zh': '自由', 'zh_TW': '自由', 'ko': '자유', 'ja': '自由', 'fr': 'libre', 'es': 'libre', 'de': 'frei'},
            'expl': {'en': 'Not under the control or in the power of another; able to act or be done as one wishes.', 'zh': '不受他人控制或支配；能够随心所欲地行动。', 'zh_TW': '不受他人控制或支配；能夠隨心所欲地行動。'},
            'example': 'Ahora soy libre para viajar.', 'ex_trans': {'en': 'Now I am free to travel.', 'zh': '现在我可以自由旅行了。', 'zh_TW': '現在我可以自由旅行了。'},
            'likes': 556, 'tags': "['spanish', 'life', 'vocabulary']",
            'location': 'Barcelona, Spain', 'char_type': 'traveler', 'char_bio': 'Spanish nomad sharing life vocabulary and freedom.',
        },
    ],
    'chinese': [
        {
            'id': 'p_zh_1', 'author': 'Wei', 'handle': '@weiteahouse',
            'content': 'Hosting a tea ceremony today. Chinese word: 茶 (chá) — the drink that has shaped Chinese culture for thousands of years.',
            'target': '茶', 'phonetic': '/tʂʰa/',
            'trans': {'en': 'tea', 'zh': '茶', 'zh_TW': '茶', 'ko': '차', 'ja': '茶', 'fr': 'thé', 'es': 'té', 'de': 'Tee'},
            'expl': {'en': 'A hot drink made by steeping dried leaves in boiling water, central to Chinese culture.', 'zh': '用热水冲泡干茶叶制成的饮品，是中国文化的核心。', 'zh_TW': '用熱水沖泡乾茶葉製成的飲品，是中國文化的核心。'},
            'example': '请喝茶。', 'ex_trans': {'en': 'Please drink tea.', 'zh': '请喝茶。', 'zh_TW': '請喝茶。'},
            'likes': 445, 'tags': "['chinese', 'culture', 'vocabulary']",
            'location': 'Hangzhou, China', 'char_type': 'tea master', 'char_bio': 'Tea master in Hangzhou, home of Longjing tea.',
        },
        {
            'id': 'p_zh_2', 'author': 'Ling', 'handle': '@lingcalligraphy',
            'content': 'Practicing calligraphy today. Chinese word: 爱 (ài) — the most powerful character, written with heart at its center.',
            'target': '爱', 'phonetic': '/ai/',
            'trans': {'en': 'love', 'zh': '爱', 'zh_TW': '愛', 'ko': '사랑', 'ja': '愛', 'fr': 'amour', 'es': 'amor', 'de': 'Liebe'},
            'expl': {'en': 'A deep, tender, and passionate feeling of affection and care.', 'zh': '一种深厚、温柔而热烈的感情与关怀。', 'zh_TW': '一種深厚、溫柔而熱烈的感情與關懷。'},
            'example': '我爱我的家人。', 'ex_trans': {'en': 'I love my family.', 'zh': '我爱我的家人。', 'zh_TW': '我愛我的家人。'},
            'likes': 612, 'tags': "['chinese', 'emotions', 'vocabulary']",
            'location': 'Beijing, China', 'char_type': 'calligrapher', 'char_bio': 'Beijing calligrapher exploring the art of Chinese characters.',
        },
        {
            'id': 'p_zh_3', 'author': 'Mei', 'handle': '@meigreetings',
            'content': 'Meeting a new language partner today! Chinese word: 你好 (nǐ hǎo) — the first word every Chinese learner should master.',
            'target': '你好', 'phonetic': '/ni xau/',
            'trans': {'en': 'hello', 'zh': '你好', 'zh_TW': '你好', 'ko': '안녕하세요', 'ja': 'こんにちは', 'fr': 'bonjour', 'es': 'hola', 'de': 'Hallo'},
            'expl': {'en': 'The standard Chinese greeting used to say hello to someone.', 'zh': '汉语中最标准的问候语，用来向他人打招呼。', 'zh_TW': '漢語中最標準的問候語。'},
            'example': '你好，很高兴认识你。', 'ex_trans': {'en': 'Hello, nice to meet you.', 'zh': '你好，很高兴认识你。', 'zh_TW': '你好，很高興認識你。'},
            'likes': 534, 'tags': "['chinese', 'greetings', 'vocabulary']",
            'location': 'Shanghai, China', 'char_type': 'teacher', 'char_bio': 'Shanghai language teacher sharing essential Chinese greetings.',
        },
        {
            'id': 'p_zh_4', 'author': 'Hao', 'handle': '@haoreading',
            'content': 'Visiting the National Library! Chinese word: 书 (shū) — the vessel that carries knowledge across generations.',
            'target': '书', 'phonetic': '/ʂu/',
            'trans': {'en': 'book', 'zh': '书', 'zh_TW': '書', 'ko': '책', 'ja': '本', 'fr': 'livre', 'es': 'libro', 'de': 'Buch'},
            'expl': {'en': 'A written or printed work consisting of pages bound together.', 'zh': '由纸张装订而成的印刷作品，承载着知识。', 'zh_TW': '由紙張裝訂而成的印刷作品，承載著知識。'},
            'example': '我喜欢读书。', 'ex_trans': {'en': 'I like reading books.', 'zh': '我喜欢读书。', 'zh_TW': '我喜歡讀書。'},
            'likes': 389, 'tags': "['chinese', 'education', 'vocabulary']",
            'location': 'Beijing, China', 'char_type': 'librarian', 'char_bio': 'Beijing librarian sharing the joy of Chinese literature.',
        },
        {
            'id': 'p_zh_5', 'author': 'Yan', 'handle': '@yanmountain',
            'content': 'Hiking Huangshan this weekend! Chinese word: 山 (shān) — the character that looks exactly like what it represents.',
            'target': '山', 'phonetic': '/ʂan/',
            'trans': {'en': 'mountain', 'zh': '山', 'zh_TW': '山', 'ko': '산', 'ja': '山', 'fr': 'montagne', 'es': 'montaña', 'de': 'Berg'},
            'expl': {'en': 'A large natural elevation of the Earth\'s surface rising abruptly from the surrounding level.', 'zh': '地球表面巨大的自然隆起，高耸入云。', 'zh_TW': '地球表面巨大的自然隆起，高聳入雲。'},
            'example': '这座山很高。', 'ex_trans': {'en': 'This mountain is very tall.', 'zh': '这座山很高。', 'zh_TW': '這座山很高。'},
            'likes': 478, 'tags': "['chinese', 'nature', 'vocabulary']",
            'location': 'Anhui, China', 'char_type': 'hiker', 'char_bio': 'Chinese hiker exploring famous mountains and sharing nature vocab.',
        },
        {
            'id': 'p_zh_6', 'author': 'Fang', 'handle': '@fanghome',
            'content': 'Spring Festival reunion dinner tonight! Chinese word: 家 (jiā) — more than a house, it is where love lives.',
            'target': '家', 'phonetic': '/tɕia/',
            'trans': {'en': 'home / family', 'zh': '家', 'zh_TW': '家', 'ko': '집', 'ja': '家', 'fr': 'maison', 'es': 'casa', 'de': 'Zuhause'},
            'expl': {'en': 'The place where one lives permanently, especially as a member of a family.', 'zh': '一个人长期居住的地方，特别是与家人一起生活的地方。', 'zh_TW': '一個人長期居住的地方，特別是與家人一起生活的地方。'},
            'example': '我想回家。', 'ex_trans': {'en': 'I want to go home.', 'zh': '我想回家。', 'zh_TW': '我想回家。'},
            'likes': 567, 'tags': "['chinese', 'family', 'vocabulary']",
            'location': 'Guangzhou, China', 'char_type': 'chef', 'char_bio': 'Guangzhou chef sharing family recipes and Chinese home vocabulary.',
        },
    ],
    'german': [
        {
            'id': 'p_de_1', 'author': 'Klaus', 'handle': '@klausbrewer',
            'content': 'Brewing a fresh batch of Hefeweizen! German word: Brot — the staple that has anchored German meals for centuries.',
            'target': 'Brot', 'phonetic': '/bʁoːt/',
            'trans': {'en': 'bread', 'zh': '面包', 'zh_TW': '麵包', 'ko': '빵', 'ja': 'パン', 'fr': 'pain', 'es': 'pan', 'de': 'Brot'},
            'expl': {'en': 'A staple food made from flour and water, baked and commonly eaten in Germany.', 'zh': '用面粉和水烘烤而成的食品，是德国饮食的基石。', 'zh_TW': '用麵粉和水烘烤而成的食品，是德國飲食的基石。'},
            'example': 'Das Brot ist sehr frisch.', 'ex_trans': {'en': 'The bread is very fresh.', 'zh': '面包非常新鲜。', 'zh_TW': '麵包非常新鮮。'},
            'likes': 234, 'tags': "['german', 'food', 'vocabulary']",
            'location': 'Munich, Germany', 'char_type': 'brewer', 'char_bio': 'Munich brewer carrying on German traditions and sharing vocabulary.',
        },
        {
            'id': 'p_de_2', 'author': 'Ingrid', 'handle': '@ingridforest',
            'content': 'Hiking in the Black Forest today. German word: Freund — the companion who makes every trail worth walking.',
            'target': 'Freund', 'phonetic': '/fʁɔɪnt/',
            'trans': {'en': 'friend', 'zh': '朋友', 'zh_TW': '朋友', 'ko': '친구', 'ja': '友達', 'fr': 'ami', 'es': 'amigo', 'de': 'Freund'},
            'expl': {'en': 'A person you know well and regard with affection, trust, and loyalty.', 'zh': '一个你非常了解、信任并忠诚相待的人。', 'zh_TW': '一個你非常了解、信任並忠誠相待的人。'},
            'example': 'Mein Freund kommt aus Berlin.', 'ex_trans': {'en': 'My friend is from Berlin.', 'zh': '我的朋友来自柏林。', 'zh_TW': '我的朋友來自柏林。'},
            'likes': 445, 'tags': "['german', 'social', 'vocabulary']",
            'location': 'Black Forest, Germany', 'char_type': 'hiker', 'char_bio': 'Nature lover exploring German forests and sharing outdoor vocabulary.',
        },
        {
            'id': 'p_de_3', 'author': 'Hans', 'handle': '@hansgreet',
            'content': 'Meeting my new language exchange partner! German word: Hallo — the friendly opener for every German conversation.',
            'target': 'Hallo', 'phonetic': '/ha.lo/',
            'trans': {'en': 'hello', 'zh': '你好', 'zh_TW': '你好', 'ko': '안녕하세요', 'ja': 'こんにちは', 'fr': 'bonjour', 'es': 'hola', 'de': 'Hallo'},
            'expl': {'en': 'The standard German greeting used to say hello to someone.', 'zh': '德语中最常见的问候语，用来向他人打招呼。', 'zh_TW': '德語中最常見的問候語。'},
            'example': 'Hallo, wie geht es dir?', 'ex_trans': {'en': 'Hello, how are you?', 'zh': '你好，你好吗？', 'zh_TW': '你好，你好嗎？'},
            'likes': 312, 'tags': "['german', 'greetings', 'vocabulary']",
            'location': 'Berlin, Germany', 'char_type': 'teacher', 'char_bio': 'Berlin language teacher sharing essential German greetings.',
        },
        {
            'id': 'p_de_4', 'author': 'Anna', 'handle': '@annamusic',
            'content': 'At a classical concert tonight! German word: Musik — the language Beethoven, Bach, and Mozart spoke fluently.',
            'target': 'Musik', 'phonetic': '/muˈziːk/',
            'trans': {'en': 'music', 'zh': '音乐', 'zh_TW': '音樂', 'ko': '음악', 'ja': '音楽', 'fr': 'musique', 'es': 'música', 'de': 'Musik'},
            'expl': {'en': 'Vocal or instrumental sounds combined to produce beauty of form, harmony, and expression.', 'zh': '人声或乐器声组合而成的美好艺术形式，和谐而富有表现力。', 'zh_TW': '人聲或樂器聲組合而成的美好藝術形式。'},
            'example': 'Ich höre gerne klassische Musik.', 'ex_trans': {'en': 'I like listening to classical music.', 'zh': '我喜欢听古典音乐。', 'zh_TW': '我喜歡聽古典音樂。'},
            'likes': 523, 'tags': "['german', 'arts', 'vocabulary']",
            'location': 'Vienna, Austria', 'char_type': 'musician', 'char_bio': 'Classical musician sharing German musical vocabulary.',
        },
        {
            'id': 'p_de_5', 'author': 'Fritz', 'handle': '@fritztravel',
            'content': 'Road trip along the Romantic Road! German word: Reise — the adventure that begins the moment you leave your door.',
            'target': 'Reise', 'phonetic': '/ˈʁaɪ̯zə/',
            'trans': {'en': 'journey / travel', 'zh': '旅行', 'zh_TW': '旅行', 'ko': '여행', 'ja': '旅行', 'fr': 'voyage', 'es': 'viaje', 'de': 'Reise'},
            'expl': {'en': 'The act of going from one place to another, especially over a long distance.', 'zh': '从一个地方到另一个地方的行为，尤其是长距离的旅程。', 'zh_TW': '從一個地方到另一個地方的行為，尤其是長距離的旅程。'},
            'example': 'Die Reise war wunderbar.', 'ex_trans': {'en': 'The journey was wonderful.', 'zh': '这次旅行非常美好。', 'zh_TW': '這次旅行非常美好。'},
            'likes': 389, 'tags': "['german', 'travel', 'vocabulary']",
            'location': 'Bavaria, Germany', 'char_type': 'traveler', 'char_bio': 'German traveler exploring castles and scenic routes while sharing vocab.',
        },
        {
            'id': 'p_de_6', 'author': 'Sophie', 'handle': '@sophielove',
            'content': 'Valentine\'s Day with my partner. German word: Liebe — the force that makes every language worth learning.',
            'target': 'Liebe', 'phonetic': '/ˈliːbə/',
            'trans': {'en': 'love', 'zh': '爱', 'zh_TW': '愛', 'ko': '사랑', 'ja': '愛', 'fr': 'amour', 'es': 'amor', 'de': 'Liebe'},
            'expl': {'en': 'A deep, tender, and passionate feeling of affection and care for another person.', 'zh': '一种深厚、温柔而热烈的感情，是对某人深深的喜爱与关怀。', 'zh_TW': '一種深厚、溫柔而熱烈的感情。'},
            'example': 'Liebe macht blind.', 'ex_trans': {'en': 'Love is blind.', 'zh': '爱是盲目的。', 'zh_TW': '愛是盲目的。'},
            'likes': 612, 'tags': "['german', 'emotions', 'vocabulary']",
            'location': 'Cologne, Germany', 'char_type': 'poet', 'char_bio': 'Cologne poet sharing German romantic vocabulary and verses.',
        },
    ],
}


def render_post(p, hours):
    """Render a single Post constructor as Dart code."""
    lt_trans = build_lt(p['target'], p['trans'])
    lt_expl = build_lt(p['expl']['en'], p['expl'])
    lt_ex_trans = build_lt(p['ex_trans']['en'], p['ex_trans'])

    return f"""        Post(
          id: '{p['id']}',
          authorName: '{p['author']}',
          authorHandle: '{p['handle']}',
          authorAvatarUrl: null,
          imageUrl: null,
          content: '{p['content']}',
          targetWord: '{p['target']}',
          wordTranslation: {lt_trans},
          wordExplanation: {lt_expl},
          wordPhonetic: '{p['phonetic']}',
          wordExample: '{p['example']}',
          wordExampleTranslation: {lt_ex_trans},
          createdAt: DateTime.now().subtract(const Duration(hours: {hours})),
          likes: {p['likes']},
          tags: {p['tags']},
          location: '{p['location']}',
          characterType: '{p['char_type']}',
          characterBio: '{p['char_bio']}',
        ),"""


def render_section(lang, posts):
    """Render a complete _{lang}Posts section."""
    lines = [f"  static List<Post> get _{lang}Posts => ["]
    for i, p in enumerate(posts):
        hours = 3 + i * 3
        lines.append(render_post(p, hours))
    lines.append("      ];")
    return '\n'.join(lines)


def main():
    text = DATA_FILE.read_text(encoding="utf-8")

    # Replace each language-specific post section
    for lang in ['korean', 'japanese', 'french', 'spanish', 'chinese', 'german']:
        pattern = rf"static List<Post> get _{lang}Posts => \[.*?\];"
        replacement = render_section(lang, POST_TEMPLATES[lang])
        new_text, count = re.subn(pattern, replacement, text, flags=re.DOTALL)
        if count == 0:
            print(f"WARNING: Could not find _{lang}Posts section")
        else:
            print(f"Replaced _{lang}Posts ({len(POST_TEMPLATES[lang])} posts)")
        text = new_text

    DATA_FILE.write_text(text, encoding="utf-8")
    print(f"\nDone. Wrote to {DATA_FILE}")


if __name__ == "__main__":
    main()
