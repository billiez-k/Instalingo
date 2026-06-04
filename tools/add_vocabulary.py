#!/usr/bin/env python3
"""
Add vocabulary to all lessons and requiredWords to all posts in demo_data.dart.
"""

import re
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent.resolve()
DATA_FILE = PROJECT_ROOT / "lib" / "data" / "demo_data.dart"

# Vocabulary mapping: lesson_id -> list of words
# Based on lesson titles from demo_data.dart
VOCABULARY = {
    # English A1
    "en_les_1": ["hello", "hi", "goodbye"],
    "en_les_2": ["please", "thank you", "sorry"],
    "en_les_3": ["name", "I", "you", "am", "is"],
    "en_les_4": ["what", "where", "how", "who"],
    "en_les_5": ["one", "two", "three", "four", "five"],
    "en_les_6": ["red", "blue", "green", "yellow"],
    "en_les_7": ["apple", "bread", "water", "coffee"],
    "en_les_8": ["cat", "dog", "bird", "fish"],
    "en_les_9": ["Monday", "Tuesday", "Wednesday", "today"],
    "en_les_10": ["morning", "afternoon", "evening", "night"],

    # Korean A1
    "ko_les_1": ["ㅏ", "ㅓ", "ㅗ", "ㅜ"],
    "ko_les_2": ["ㄱ", "ㄴ", "ㄷ", "ㄹ"],
    "ko_les_3": ["가", "나", "다", "라"],
    "ko_les_4": ["ㄲ", "ㄸ", "ㅃ", "ㅆ", "ㅉ"],
    "ko_les_5": ["ㅑ", "ㅕ", "ㅛ", "ㅠ", "ㅢ"],
    "ko_les_6": ["안녕하세요", "안녕"],
    "ko_les_7": ["감사합니다", "고마워요"],
    "ko_les_8": ["저는", "입니다", "이름"],
    "ko_les_9": ["하나", "둘", "셋", "넷", "다섯"],
    "ko_les_10": ["일", "이", "삼", "사", "오"],

    # Japanese A1
    "ja_les_1": ["あ", "い", "う", "え", "お"],
    "ja_les_2": ["か", "き", "く", "け", "こ"],
    "ja_les_3": ["さ", "し", "す", "せ", "そ"],
    "ja_les_4": ["た", "ち", "つ", "て", "と"],
    "ja_les_5": ["な", "に", "ぬ", "ね", "の"],
    "ja_les_6": ["こんにちは", "おはよう"],
    "ja_les_7": ["ありがとう", "すみません"],
    "ja_les_8": ["私", "は", "です", "名前"],
    "ja_les_9": ["一", "二", "三", "四", "五"],
    "ja_les_10": ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日"],

    # French A1
    "fr_les_1": ["bonjour", "salut", "au revoir"],
    "fr_les_2": ["merci", "s'il vous plaît", "pardon"],
    "fr_les_3": ["je", "tu", "il", "elle", "est"],
    "fr_les_4": ["quoi", "où", "comment", "qui"],
    "fr_les_5": ["un", "deux", "trois", "quatre", "cinq"],
    "fr_les_6": ["rouge", "bleu", "vert", "jaune"],
    "fr_les_7": ["pomme", "pain", "eau", "café"],
    "fr_les_8": ["chat", "chien", "oiseau", "poisson"],
    "fr_les_9": ["lundi", "mardi", "mercredi", "aujourd'hui"],
    "fr_les_10": ["matin", "après-midi", "soir", "nuit"],

    # Spanish A1
    "es_les_1": ["hola", "adiós", "buenos días"],
    "es_les_2": ["gracias", "por favor", "perdón"],
    "es_les_3": ["yo", "tú", "él", "ella", "es"],
    "es_les_4": ["qué", "dónde", "cómo", "quién"],
    "es_les_5": ["uno", "dos", "tres", "cuatro", "cinco"],
    "es_les_6": ["rojo", "azul", "verde", "amarillo"],
    "es_les_7": ["manzana", "pan", "agua", "café"],
    "es_les_8": ["gato", "perro", "pájaro", "pez"],
    "es_les_9": ["lunes", "martes", "miércoles", "hoy"],
    "es_les_10": ["mañana", "tarde", "noche", "día"],

    # Chinese A1
    "zh_les_1": ["一", "二", "三", "四", "五"],
    "zh_les_2": ["六", "七", "八", "九", "十"],
    "zh_les_3": ["你", "好", "我", "是", "人"],
    "zh_les_4": ["什么", "哪里", "怎么", "谁"],
    "zh_les_5": ["大", "小", "多", "少", "好"],
    "zh_les_6": ["红", "蓝", "绿", "黄", "白"],
    "zh_les_7": ["苹果", "面包", "水", "咖啡", "茶"],
    "zh_les_8": ["猫", "狗", "鸟", "鱼", "马"],
    "zh_les_9": ["星期一", "星期二", "星期三", "今天"],
    "zh_les_10": ["早上", "下午", "晚上", "昨天", "明天"],

    # German A1
    "de_les_1": ["Hallo", "Guten Tag", "Auf Wiedersehen"],
    "de_les_2": ["Danke", "Bitte", "Entschuldigung"],
    "de_les_3": ["ich", "du", "er", "sie", "ist"],
    "de_les_4": ["was", "wo", "wie", "wer"],
    "de_les_5": ["eins", "zwei", "drei", "vier", "fünf"],
    "de_les_6": ["rot", "blau", "grün", "gelb"],
    "de_les_7": ["Apfel", "Brot", "Wasser", "Kaffee"],
    "de_les_8": ["Katze", "Hund", "Vogel", "Fisch"],
    "de_les_9": ["Montag", "Dienstag", "Mittwoch", "heute"],
    "de_les_10": ["Morgen", "Nachmittag", "Abend", "Nacht"],
}


def update_helpers(text: str) -> str:
    """Add vocabulary parameter to all _lessonXx helper functions."""
    for lang in ["En", "Ko", "Ja", "Fr", "Es", "Zh", "De"]:
        pattern = rf"(static Lesson _lesson{lang}\\({{required String id, required String title, required String desc, required int order, bool isCompleted = false, bool isCurrent = false}}) =>)"
        replacement = rf"static Lesson _lesson{lang}({{required String id, required String title, required String desc, required int order, required List<String> vocabulary, bool isCompleted = false, bool isCurrent = false}}) =>"
        text = re.sub(pattern, replacement, text)
    return text


def update_helper_calls(text: str) -> str:
    """Add vocabulary argument to all _lessonXx calls."""
    def replacer(m):
        func_name = m.group(1)
        args = m.group(2)
        # Extract id
        id_match = re.search(r"id:\s*'([^']+)'", args)
        if not id_match:
            return m.group(0)
        lesson_id = id_match.group(1)
        vocab = VOCABULARY.get(lesson_id, [])
        vocab_str = ", ".join(f"'{w}'" for w in vocab)
        return f"{func_name}({args}, vocabulary: [{vocab_str}])"

    for lang in ["En", "Ko", "Ja", "Fr", "Es", "Zh", "De"]:
        # Match calls like _lessonKo(id: '...', title: '...', ...)
        pattern = rf"(_lesson{lang}\()([^)]+)(\))"
        text = re.sub(pattern, replacer, text)
    return text


def add_post_required_words(text: str) -> str:
    """Add requiredWords field to all Post constructors."""
    def replacer(m):
        block = m.group(1)
        # Find targetWord
        tw_match = re.search(r"targetWord:\s*'([^']+)'", block)
        if not tw_match:
            return m.group(0)
        target = tw_match.group(1)
        # Add requiredWords after targetWord
        return f"Post({block}\n          requiredWords: ['{target}'],"

    # Match Post( ... ), but we need to be careful about nested content
    # Use a simpler approach: find targetWord lines and add requiredWords after them
    pattern = r"(targetWord:\s*'[^']+',)"
    def replacer2(m):
        return m.group(1) + f"\n          requiredWords: ['{m.group(0).split(chr(39))[1]}'],"
    text = re.sub(pattern, replacer2, text)
    return text


def main():
    text = DATA_FILE.read_text(encoding="utf-8")

    # Step 1: Update helper signatures
    text = update_helpers(text)
    print("Updated _lessonXx helper signatures")

    # Step 2: Update helper calls with vocabulary
    text = update_helper_calls(text)
    print("Updated lesson calls with vocabulary")

    # Step 3: Add requiredWords to posts
    text = add_post_required_words(text)
    print("Added requiredWords to posts")

    DATA_FILE.write_text(text, encoding="utf-8")
    print(f"\nDone. Wrote to {DATA_FILE}")


if __name__ == "__main__":
    main()
