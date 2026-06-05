#!/usr/bin/env python3
"""
Match vocabulary words against Tatoeba corpus for example sentences.

Input: vocabulary_with_definitions.json + Tatoeba sentences CSV
Output: vocabulary_with_sentences.json

Tatoeba data is CC-BY 2.0 licensed.
Download from: https://tatoeba.org/en/downloads

Usage: python3 match_tatoeba_sentences.py --vocab VOCAB_JSON --tatoeba TATOEBA_CSV
"""
import json
import csv
import argparse


def load_vocab(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def build_sentence_index(csv_path):
    index = {}
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f, delimiter='\t')
        for row in reader:
            if row.get('lang') != 'jpn':
                continue
            text = row.get('text', '')
            for token in text.split():
                if token not in index:
                    index[token] = []
                if len(index[token]) < 3:
                    index[token].append({
                        "text": text,
                        "translation": row.get('translation', ''),
                        "id": row.get('id', ''),
                    })
    return index


def match_sentences(vocab, sentence_index):
    for entry in vocab:
        word = entry['word']
        sentences = sentence_index.get(word, [])
        if sentences:
            s = sentences[0]
            entry['example_text'] = s['text']
            entry['example_translation'] = s['translation']
            entry['example_source'] = f"Tatoeba #{s['id']} (CC-BY 2.0)"
    return vocab


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Match vocab against Tatoeba')
    parser.add_argument('--vocab', required=True)
    parser.add_argument('--tatoeba', required=True)
    parser.add_argument('--output', default='vocabulary_with_sentences.json')
    args = parser.parse_args()

    vocab = load_vocab(args.vocab)
    index = build_sentence_index(args.tatoeba)
    result = match_sentences(vocab, index)

    with open(args.output, 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=2)

    has_examples = sum(1 for e in result if 'example_text' in e)
    print(f"Total: {len(result)}, With examples: {has_examples} -> {args.output}")
