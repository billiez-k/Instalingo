#!/usr/bin/env python3
"""Image URL replacement script for InstaLingo posts.json.

Usage:
    # Initialize placeholder image_url fields for all posts (first run)
    python3 scripts/replace_images.py --input instalingo_content/shared/posts.json --init

    # Replace image_url values using a CSV mapping from AI generation
    python3 scripts/replace_images.py --input instalingo_content/shared/posts.json --mapping images.csv

    # Set author avatar URLs from a CSV mapping
    python3 scripts/replace_images.py --input instalingo_content/shared/posts.json --avatars avatars.csv

    # Export current mapping for editing
    python3 scripts/replace_images.py --input instalingo_content/shared/posts.json --export current.csv

CSV format for --mapping:
    post_id,image_url
    chill_001,https://cdn.example.com/images/word_ja_n5_0001.png

CSV format for --avatars:
    author_name,avatar_url
    Sakura-chan,https://cdn.example.com/avatars/sakura.png

Workflow:
    1. python3 scripts/replace_images.py --input posts.json --init
       → Adds placeholder image_url + author_avatar_url to all posts

    2. python3 scripts/replace_images.py --input posts.json --export urls.csv
       → Export current mapping to CSV for editing

    3. Generate AI images for each word, fill in the CSV

    4. python3 scripts/replace_images.py --input posts.json --mapping urls.csv
       → Apply real image URLs from the CSV

    The script creates a .bak backup before each modification.
"""

import argparse
import csv
import json
import shutil
import sys
from pathlib import Path


def load_posts(path: str) -> list:
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    if isinstance(data, dict) and 'posts' in data:
        return data['posts']
    if isinstance(data, list):
        return data
    raise ValueError(f"Unrecognized JSON structure in {path}")


def save_posts(path: str, posts: list):
    with open(path, 'r', encoding='utf-8') as f:
        original = json.load(f)

    if isinstance(original, dict) and 'posts' in original:
        original['posts'] = posts
    else:
        original = posts

    backup = Path(path).with_suffix('.json.bak')
    shutil.copy2(path, backup)
    print(f'Backup saved to {backup}')

    with open(path, 'w', encoding='utf-8') as f:
        json.dump(original, f, indent=2, ensure_ascii=False)
    print(f'Updated {path} ({len(posts)} posts)')


def cmd_init(posts: list) -> list:
    """Initialize image_url fields with placeholder paths."""
    for post in posts:
        if 'image_url' not in post or post['image_url'] is None:
            word_id = post.get('target_word_id', post.get('id', 'unknown'))
            post['image_url'] = f'assets/images/cards/{word_id}.png'
        if 'author_avatar_url' not in post or post['author_avatar_url'] is None:
            author_slug = post.get('author_name', 'unknown').lower().replace(' ', '_')
            post['author_avatar_url'] = f'assets/images/avatars/{author_slug}.png'
    return posts


def cmd_mapping(posts: list, mapping_csv: str) -> list:
    url_map = {}
    with open(mapping_csv, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            url_map[row['post_id']] = row['image_url']

    count = 0
    for post in posts:
        pid = post.get('id', '')
        if pid in url_map:
            post['image_url'] = url_map[pid]
            count += 1

    print(f'Applied {count} image URLs from {mapping_csv}')
    return posts


def cmd_avatars(posts: list, avatars_csv: str) -> list:
    avatar_map = {}
    with open(avatars_csv, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            avatar_map[row['author_name']] = row['avatar_url']

    count = 0
    for post in posts:
        author = post.get('author_name', '')
        if author in avatar_map:
            post['author_avatar_url'] = avatar_map[author]
            count += 1

    print(f'Applied {count} avatar URLs from {avatars_csv}')
    return posts


def cmd_export(posts: list, output_csv: str):
    with open(output_csv, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['post_id', 'target_word', 'image_url'])
        for post in posts:
            writer.writerow([
                post.get('id', ''),
                post.get('target_word', ''),
                post.get('image_url', ''),
            ])
    print(f'Exported {len(posts)} entries to {output_csv}')


def main():
    parser = argparse.ArgumentParser(
        description='Replace image URLs in InstaLingo posts.json'
    )
    parser.add_argument('--input', required=True, help='Path to posts.json')
    parser.add_argument('--init', action='store_true',
                        help='Initialize image_url fields with placeholders')
    parser.add_argument('--mapping', help='CSV: post_id,image_url')
    parser.add_argument('--avatars', help='CSV: author_name,avatar_url')
    parser.add_argument('--export', help='Export current mapping to CSV')

    args = parser.parse_args()
    posts = load_posts(args.input)

    if args.init:
        posts = cmd_init(posts)
    if args.mapping:
        posts = cmd_mapping(posts, args.mapping)
    if args.avatars:
        posts = cmd_avatars(posts, args.avatars)
    if args.export:
        cmd_export(posts, args.export)
        return

    if not (args.init or args.mapping or args.avatars):
        print('Error: specify --init, --mapping, --avatars, or --export')
        sys.exit(1)

    save_posts(args.input, posts)


if __name__ == '__main__':
    main()
