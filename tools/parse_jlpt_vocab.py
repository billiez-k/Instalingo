#!/usr/bin/env python3
"""
Parse JLPT vocabulary lists from open-anki-jlpt-decks (MIT license).

Input: Raw JLPT word lists (CSV or TSV format)
Output: vocabulary_raw.json

Usage: python3 parse_jlpt_vocab.py [--input INPUT_DIR] [--output OUTPUT_FILE]
"""
import json
import csv
import os
import argparse


def parse_vocab(input_dir: str, output_file: str):
    vocab = []
    levels = ['n5', 'n4', 'n3', 'n2', 'n1']

    for level in levels:
        csv_path = os.path.join(input_dir, f'{level}.csv')
        if not os.path.exists(csv_path):
            print(f"Warning: {csv_path} not found, skipping {level}")
            continue

        with open(csv_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                vocab.append({
                    "word": row.get("word", "").strip(),
                    "reading": row.get("reading", "").strip(),
                    "meaning": row.get("meaning", "").strip(),
                    "level": level.upper(),
                })

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(vocab, f, ensure_ascii=False, indent=2)

    print(f"Parsed {len(vocab)} vocabulary entries -> {output_file}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parse JLPT vocabulary lists')
    parser.add_argument('--input', default='raw_data/jlpt_lists')
    parser.add_argument('--output', default='vocabulary_raw.json')
    args = parser.parse_args()
    parse_vocab(args.input, args.output)
