#!/usr/bin/env python3
"""
Build final card JSON files for the InstaLingo app.

Input: vocabulary_with_sentences.json
Output:
  instalingo_content/japanese/n5/cards.json
  instalingo_content/japanese/n4/cards.json
  instalingo_content/japanese/n3/cards.json
  instalingo_content/archive/filtered_vocabulary.json

Usage: python3 build_final_cards.py --vocab VOCAB_JSON [--content-dir CONTENT_DIR]
"""
import json
import os
import argparse

TOPIC_MAP = {
    "noun": "general", "verb": "actions", "adj": "descriptions",
    "adv": "general", "pronoun": "people", "numeral": "general",
    "particle": "grammar", "conjunction": "grammar",
}


def load_vocab(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def filter_vocab(entries):
    valid = []
    filtered = []

    for entry in entries:
        word = entry.get('word', '')
        reason = None

        if not entry.get('example_text'):
            reason = "no_example_sentence"
        elif not entry.get('pos'):
            reason = "no_jmdict_match"
        elif len(word) > 10:
            reason = "too_long"

        if reason:
            filtered.append({
                "word": word,
                "reading": entry.get('reading', ''),
                "meaning": entry.get('meaning', ''),
                "level": entry.get('level', ''),
                "filter_reason": reason,
                "pos": entry.get('pos', ''),
            })
        else:
            valid.append(entry)

    return valid, filtered


def build_deck(level, entries, display_name, display_name_zh):
    cards = []
    for i, entry in enumerate(entries):
        pos = entry.get('pos', 'noun')
        topic = TOPIC_MAP.get(pos.split('-')[0] if '-' in pos else pos, 'general')
        cards.append({
            "id": f"ja_{level}_{i+1:04d}",
            "word": entry['word'],
            "reading": entry.get('reading', ''),
            "meaning": entry.get('meaning', ''),
            "meaning_zh": entry.get('meaning_zh', ''),
            "pos": pos,
            "level": level.upper(),
            "topic": topic,
            "image_url": None,
            "audio_url": None,
            "example_text": entry.get('example_text'),
            "example_reading": entry.get('example_reading'),
            "example_translation": entry.get('example_translation'),
            "example_audio_url": None,
            "source": "JLPT: open-anki-jlpt-decks (MIT), Dictionary: JMdict/EDRDG (CC-BY-SA 4.0), Examples: Tatoeba (CC-BY 2.0)"
        })

    return {
        "deck": {
            "id": level,
            "language": "ja",
            "level": level.upper(),
            "display_name": display_name,
            "display_name_zh": display_name_zh,
            "total_cards": len(cards)
        },
        "cards": cards
    }


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Build final card JSON files')
    parser.add_argument('--vocab', required=True)
    parser.add_argument('--content-dir', default='instalingo_content')
    args = parser.parse_args()

    vocab = load_vocab(args.vocab)
    valid, filtered = filter_vocab(vocab)

    by_level = {}
    for entry in valid:
        level = entry.get('level', 'N5').lower()
        if level not in by_level:
            by_level[level] = []
        by_level[level].append(entry)

    levels_config = [('n5', 'JLPT N5', 'JLPT N5'), ('n4', 'JLPT N4', 'JLPT N4'), ('n3', 'JLPT N3', 'JLPT N3')]

    for level, display_en, display_zh in levels_config:
        entries = by_level.get(level, [])
        deck = build_deck(level, entries, f"{display_en} - {len(entries)} Words", f"{display_zh} - {len(entries)}字")
        path = os.path.join(args.content_dir, 'japanese', level, 'cards.json')
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(deck, f, ensure_ascii=False, indent=2)
        print(f"Created {path} with {len(entries)} cards")

    archive_path = os.path.join(args.content_dir, 'archive', 'filtered_vocabulary.json')
    os.makedirs(os.path.dirname(archive_path), exist_ok=True)
    with open(archive_path, 'w', encoding='utf-8') as f:
        json.dump(filtered, f, ensure_ascii=False, indent=2)
    print(f"Filtered: {len(filtered)} entries -> {archive_path}")
