#!/usr/bin/env python3
"""
Generate AI character posts for the Chill Corner feed.

Output: instalingo_content/shared/posts.json

Each post is authored by a fictional character and references a real vocab word.

Usage: python3 generate_chill_posts.py [--cards-dir CARDS_DIR] [--output OUTPUT]
"""
import json
import os
import argparse
import random
from datetime import datetime, timedelta

CHARACTERS = [
    {"name": "Sakura-chan", "handle": "sakura_study", "level": "N3", "style": "artistic"},
    {"name": "Kenji-san", "handle": "kenji_office", "level": "N2", "style": "practical"},
    {"name": "Yuki", "handle": "yuki_art", "level": "N3", "style": "creative"},
    {"name": "Yamada-sensei", "handle": "yamada_sensei", "level": "N1", "style": "teacher"},
    {"name": "Hiro-kun", "handle": "hiro_travels", "level": "N5", "style": "adventurous"},
    {"name": "Mika-chan", "handle": "mika_drama", "level": "N4", "style": "lively"},
]

POST_TEMPLATES = {
    "artistic": [
        "Learned a beautiful word today: {word} ({reading}) - {meaning}. The characters are so elegant!",
        "Found this gem: {word}. It sounds like poetry.",
    ],
    "practical": [
        "Today's business word: {word} ({reading}). Hear this every day at the office.",
        "Essential JLPT vocab: {word} - {meaning}. Making progress!",
    ],
    "creative": [
        "Drawing {word} ({reading}) to help memorize it. Visual learning works!",
        "Made an illustration for {word}. Art + Japanese = perfect combo.",
    ],
    "teacher": [
        "Teaching tip: {word} ({reading}) - {meaning}. Try using it in a sentence today!",
        "Word of the day: {word}. Remember the reading: {reading}. Practice makes perfect!",
    ],
    "adventurous": [
        "Discovered {word} ({reading}) while traveling! Learning through experience is the best.",
        "Every trip teaches a new word. Today: {word} - {meaning}.",
    ],
    "lively": [
        "Heard {word} ({reading}) in a drama today! So satisfying to recognize it!",
        "My favorite way to learn: hearing {word} in anime. Context is everything!",
    ],
}


def load_cards(cards_dir):
    all_cards = []
    for level in ['n5', 'n4', 'n3']:
        path = os.path.join(cards_dir, 'japanese', level, 'cards.json')
        if os.path.exists(path):
            with open(path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                all_cards.extend(data.get('cards', []))
    return all_cards


def generate_posts(cards, num_posts=50):
    posts = []
    random.shuffle(cards)
    base_date = datetime(2026, 6, 1)

    for i in range(min(num_posts, len(cards))):
        card = cards[i]
        char = CHARACTERS[i % len(CHARACTERS)]
        templates = POST_TEMPLATES.get(char['style'], POST_TEMPLATES['practical'])
        template = templates[i % len(templates)]

        content = template.format(
            word=card['word'],
            reading=card.get('reading', ''),
            meaning=card.get('meaning', ''),
        )

        post_date = base_date + timedelta(days=i % 30, hours=random.randint(8, 22))

        posts.append({
            "id": f"post_{i+1:03d}",
            "author_name": char['name'],
            "author_handle": char['handle'],
            "author_avatar_url": None,
            "content": content,
            "target_word": card['word'],
            "target_word_id": card['id'],
            "tags": [
                f"#JLPT_{card.get('level', 'N5')}",
                f"#{card.get('topic', 'learning')}"
            ],
            "likes": random.randint(10, 300),
            "comments": [
                {
                    "author_name": CHARACTERS[(i+1) % len(CHARACTERS)]['name'],
                    "content": "Great post! Keep learning!"
                }
            ],
            "created_at": post_date.isoformat() + 'Z',
        })

    return posts


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate Chill Corner posts')
    parser.add_argument('--cards-dir', default='instalingo_content')
    parser.add_argument('--output', default='instalingo_content/shared/posts.json')
    parser.add_argument('--count', type=int, default=50)
    args = parser.parse_args()

    cards = load_cards(args.cards_dir)
    print(f"Loaded {len(cards)} cards")

    posts = generate_posts(cards, args.count)

    os.makedirs(os.path.dirname(args.output), exist_ok=True)
    with open(args.output, 'w', encoding='utf-8') as f:
        json.dump(posts, f, ensure_ascii=False, indent=2)

    print(f"Generated {len(posts)} posts -> {args.output}")
