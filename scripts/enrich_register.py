#!/usr/bin/env python3
"""
Content enrichment pipeline for InstaLingo v3.
Adds register tier tags (textbook/real_life/slang/vulgar) to vocabulary cards.

Sources:
  - instalingo_content/japanese/n5-n1/cards.json  (existing JLPT decks)
  - instalingo_content/archive/register_vocabulary.json  (JMdict register-tagged words)

Output:
  - Updated cards.json per level with register field
  - instalingo_content/japanese/slang/cards.json  (new slang deck)
  - instalingo_content/japanese/vulgar/cards.json (new vulgar deck, opt-in)
"""

import json
import os
import sys

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CONTENT_DIR = os.path.join(BASE_DIR, 'instalingo_content', 'japanese')
REGISTER_FILE = os.path.join(BASE_DIR, 'instalingo_content', 'archive', 'register_vocabulary.json')

# Map JMdict tags to our simplified register tiers
TAG_TO_REGISTER = {
    'vulgar expression or word': 'vulgar',
    'vulgar': 'vulgar',
    'derogatory': 'slang',
    'slang': 'slang',
    'colloquial': 'real_life',
    'familiar language': 'real_life',
    'honorific or respectful (sonkeigo) language': 'real_life',
    'humble (kenjougo) language': 'real_life',
    'polite (teineigo) language': 'real_life',
    'children\'s language': 'real_life',
    'male speech': 'real_life',
    'female speech': 'real_life',
    'rude': 'slang',
    'abbreviation': 'real_life',
    'archaic': 'textbook',
}


def resolve_register(tags):
    """Map a list of JMdict tags to our 4-tier register. Most 'severe' wins."""
    best = 'textbook'
    for tag in tags:
        mapped = TAG_TO_REGISTER.get(tag, 'textbook')
        # Priority: vulgar > slang > real_life > textbook
        priority = {'vulgar': 4, 'slang': 3, 'real_life': 2, 'textbook': 1}
        if priority.get(mapped, 0) > priority.get(best, 0):
            best = mapped
    return best


def load_register_words():
    """Load JMdict register-tagged words. Returns {word: {reading, meaning, tags, register}}."""
    if not os.path.exists(REGISTER_FILE):
        print(f"Warning: {REGISTER_FILE} not found. Skipping register enrichment.")
        return {}

    with open(REGISTER_FILE) as f:
        data = json.load(f)

    register_map = {}
    for w in data.get('words', []):
        key = w['word']
        tags = w.get('tags', [])
        register = resolve_register(tags)
        register_map[key] = {
            'reading': w.get('reading', ''),
            'meaning_en': w.get('meaning', ''),
            'tags': tags,
            'register': register,
        }

    print(f"Loaded {len(register_map)} register-tagged words")
    return register_map


def enrich_cards(cards, register_map):
    """Add register field to cards based on register word data."""
    enriched = 0
    for card in cards:
        word = card.get('word', '')
        if word in register_map:
            card['register'] = register_map[word]['register']
            enriched += 1
        elif 'register' not in card:
            card['register'] = 'textbook'
    return enriched


def build_slang_vulgar_decks(register_map):
    """Create separate slang and vulgar card decks from register words
    that aren't already in JLPT decks."""
    slang_cards = []
    vulgar_cards = []

    card_id = 100000  # Start well above JLPT card IDs

    for word, info in sorted(register_map.items()):
        register = info['register']
        if register not in ('slang', 'vulgar'):
            continue

        card = {
            'id': f'register_{card_id}',
            'word': word,
            'reading': info['reading'],
            'pos': 'expression',
            'level': 'slang' if register == 'slang' else 'adult',
            'topic': register,
            'source': 'JMdict/EDRDG via register_vocabulary.json',
            'register': register,
            'meanings': {'en': info['meaning_en']},
            'example_text': '',
            'example_reading': '',
            'example_translations': {'en': ''},
        }
        card_id += 1

        if register == 'vulgar':
            vulgar_cards.append(card)
        else:
            slang_cards.append(card)

    return slang_cards, vulgar_cards


def process_level(level, register_map):
    """Process a single JLPT level's cards.json."""
    level_dir = os.path.join(CONTENT_DIR, level)
    cards_file = os.path.join(level_dir, 'cards.json')

    if not os.path.exists(cards_file):
        print(f"  Skipping {level}: cards.json not found")
        return

    with open(cards_file) as f:
        data = json.load(f)

    cards = data.get('cards', [])
    original_count = len(cards)
    enriched_count = enrich_cards(cards, register_map)

    # Write back
    with open(cards_file, 'w') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"  {level.upper()}: {enriched_count}/{original_count} cards tagged with register")


def write_special_deck(cards, deck_name, output_path):
    """Write a special deck (slang/vulgar) as a cards.json file."""
    if not cards:
        print(f"  {deck_name}: no cards to write")
        return

    deck_data = {
        'deck': {
            'id': f'ja_{deck_name.lower()}',
            'language': 'ja',
            'level': deck_name,
            'display_name': f'{deck_name} - Real Japanese',
            'display_name_zh': f'{deck_name} - 真實日語',
            'total_cards': len(cards),
        },
        'cards': cards,
    }

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'w') as f:
        json.dump(deck_data, f, ensure_ascii=False, indent=2)

    print(f"  {deck_name}: wrote {len(cards)} cards to {output_path}")


def main():
    print("=" * 60)
    print("InstaLingo v3 — Content Register Enrichment Pipeline")
    print("=" * 60)

    # Load register data
    register_map = load_register_words()
    if not register_map:
        print("No register data available. Aborting.")
        sys.exit(1)

    # Print register distribution
    counts = {'vulgar': 0, 'slang': 0, 'real_life': 0, 'textbook': 0}
    for info in register_map.values():
        counts[info['register']] = counts.get(info['register'], 0) + 1
    print(f"Register distribution: {counts}")
    print()

    # Process each JLPT level
    print("Enriching JLPT decks with register tags...")
    for level in ['n5', 'n4', 'n3', 'n2', 'n1']:
        process_level(level, register_map)

    # Build slang and vulgar special decks
    print("\nBuilding slang/vulgar special decks...")
    slang_cards, vulgar_cards = build_slang_vulgar_decks(register_map)

    write_special_deck(slang_cards, 'Slang',
                       os.path.join(CONTENT_DIR, 'slang', 'cards.json'))
    write_special_deck(vulgar_cards, 'Vulgar',
                       os.path.join(CONTENT_DIR, 'vulgar', 'cards.json'))

    print("\n✅ Content pipeline complete!")
    print(f"   Total JLPT cards processed across N5-N1")
    print(f"   Slang deck: {len(slang_cards)} cards")
    print(f"   Vulgar deck: {len(vulgar_cards)} cards")


if __name__ == '__main__':
    main()
