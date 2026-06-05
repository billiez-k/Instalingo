#!/usr/bin/env python3
"""
Match JLPT vocabulary against JMdict for rich dictionary data.

Input: vocabulary_raw.json + JMdict XML
Output: vocabulary_with_definitions.json

JMdict is CC-BY-SA 4.0 licensed.
Download from: http://www.edrdg.org/jmdict/j_jmdict.html

Usage: python3 match_jmdict.py --vocab VOCAB_JSON --jmdict JMDICT_XML
"""
import json
import argparse
import xml.etree.ElementTree as ET


def load_vocab(path: str):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def parse_jmdict(xml_path: str):
    tree = ET.parse(xml_path)
    root = tree.getroot()
    lookup = {}

    for entry in root.findall('entry'):
        keb = entry.find('.//keb')
        reb = entry.find('.//reb')
        word = keb.text if keb is not None else (reb.text if reb is not None else None)
        if not word:
            continue

        readings = [r.text for r in entry.findall('.//reb') if r.text]
        pos_list = []
        glosses = []
        for sense in entry.findall('sense'):
            for pos in sense.findall('pos'):
                if pos.text and pos.text not in pos_list:
                    pos_list.append(pos.text)
            for gloss in sense.findall('gloss'):
                if gloss.text:
                    glosses.append(gloss.text)

        if word not in lookup:
            lookup[word] = []
        lookup[word].append({
            "reading": readings[0] if readings else "",
            "readings": readings,
            "pos": pos_list,
            "meanings": glosses,
        })

    return lookup


def match_vocab(vocab, jmdict_lookup):
    matched = []
    unmatched = []

    for entry in vocab:
        word = entry['word']
        if word in jmdict_lookup:
            dict_data = jmdict_lookup[word][0]
            entry['pos'] = dict_data['pos'][0] if dict_data['pos'] else 'unknown'
            entry['all_readings'] = dict_data['readings']
            entry['all_meanings'] = dict_data['meanings']
            matched.append(entry)
        else:
            unmatched.append(entry)

    return matched, unmatched


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Match JLPT vocab against JMdict')
    parser.add_argument('--vocab', required=True)
    parser.add_argument('--jmdict', required=True)
    parser.add_argument('--output', default='vocabulary_with_definitions.json')
    args = parser.parse_args()

    vocab = load_vocab(args.vocab)
    jmdict = parse_jmdict(args.jmdict)
    matched, unmatched = match_vocab(vocab, jmdict)

    with open(args.output, 'w', encoding='utf-8') as f:
        json.dump(matched, f, ensure_ascii=False, indent=2)

    unmatched_path = args.output.replace('.json', '_unmatched.json')
    with open(unmatched_path, 'w', encoding='utf-8') as f:
        json.dump(unmatched, f, ensure_ascii=False, indent=2)

    print(f"Matched: {len(matched)}, Unmatched: {len(unmatched)} -> {args.output}")
