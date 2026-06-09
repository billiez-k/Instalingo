#!/usr/bin/env python3
"""
Production translation script for InstaLingo v2.

Translates ALL card meanings and example translations to all 7 target languages.
Supports Google Cloud Translation API (fast) or deep_translator (slow, free).

Usage:
  # With Google Cloud API key (fast, ~5 min for all 8,054 cards):
  export GOOGLE_API_KEY="your-key-here"
  python3 translate_all_cards.py

  # Without API key (slow, ~60+ min via free Google Translate):
  python3 translate_all_cards.py --free

  # Translate specific level only:
  python3 translate_all_cards.py --level n5
"""
import json, os, sys, time, argparse
from pathlib import Path

BASE = Path('instalingo_content/japanese')
ALL_LEVELS = ['n5', 'n4', 'n3', 'n2', 'n1']
TARGETS = [
    ('ko', 'ko'), ('ms', 'ms'), ('ar', 'ar'),
    ('ja', 'ja'), ('zh_CN', 'zh-CN'),
]


def translate_via_cloud(texts, target_lang, api_key):
    """Google Cloud Translation API — fast, production quality."""
    import requests
    url = 'https://translation.googleapis.com/language/translate/v2'
    result = {}
    for i in range(0, len(texts), 100):
        chunk = texts[i:i+100]
        resp = requests.post(url, params={'key': api_key}, json={
            'q': chunk, 'source': 'en', 'target': target_lang,
            'format': 'text',
        })
        resp.raise_for_status()
        translations = resp.json()['data']['translations']
        for orig, tr in zip(chunk, translations):
            result[orig] = tr['translatedText']
        sys.stdout.write('.')
        sys.stdout.flush()
        time.sleep(0.1)
    return result


def translate_via_free(texts, target_lang):
    """deep-translator (free Google Translate) — slower but no API key needed."""
    from deep_translator import GoogleTranslator
    result = {}
    for i in range(0, len(texts), 50):
        chunk = texts[i:i+50]
        for attempt in range(3):
            try:
                t = GoogleTranslator(source='en', target=target_lang)
                translations = t.translate_batch(chunk)
                for orig, tr in zip(chunk, translations):
                    result[orig] = tr
                sys.stdout.write('.')
                sys.stdout.flush()
                time.sleep(0.5)
                break
            except Exception:
                if attempt == 2:
                    for text in chunk:
                        try:
                            result[text] = GoogleTranslator(
                                source='en', target=target_lang
                            ).translate(text)
                            time.sleep(0.5)
                        except Exception:
                            result[text] = text
                time.sleep(3)
    return result


def process_level(level, translate_fn):
    path = BASE / level / 'cards.json'
    checkpoint = Path(f'/tmp/xlate_{level}_ckpt.json')

    if not path.exists():
        print(f'  ERROR: {path} not found — skipping level {level}')
        return
    try:
        with open(path) as f:
            data = json.load(f)
    except (json.JSONDecodeError, FileNotFoundError) as e:
        print(f'  ERROR: Failed to load {path}: {e}')
        return
    if 'cards' not in data:
        print(f'  ERROR: {path} has no "cards" key — skipping')
        return
    cards = data['cards']
    print(f'\n{"="*50}\n{level.upper()}: {len(cards)} cards')

    # Resume from checkpoint
    done = set()
    if checkpoint.exists():
        try:
            done = set(json.loads(checkpoint.read_text()))
            print(f'  Resume: {sorted(done)} already done')
        except (json.JSONDecodeError, FileNotFoundError):
            print(f'  Warning: checkpoint corrupted, starting fresh')
            checkpoint.unlink(missing_ok=True)

    # Collect unique texts
    meanings = list(dict.fromkeys(
        c.get('meaning', '') or '' for c in cards if (c.get('meaning', '') or '').strip()
    ))
    examples = list(dict.fromkeys(
        c.get('example_translation', '') or '' for c in cards
        if (c.get('example_translation', '') or '').strip()
    ))
    print(f'  Meanings: {len(meanings)}, Examples: {len(examples)}')

    for lang_key, lang_code in TARGETS:
        if lang_key in done:
            print(f'  SKIP {lang_key} (already done)')
            continue

        print(f'  [{lang_key}] Meanings...', end='', flush=True)
        m_map = translate_fn(meanings, lang_code)
        print(f' {len(m_map)}')

        print(f'  [{lang_key}] Examples...', end='', flush=True)
        e_map = translate_fn(examples, lang_code)
        print(f' {len(e_map)}')

        # Apply to cards
        for card in cards:
            en_m = card.get('meaning', '') or ''
            en_ex = card.get('example_translation', '') or ''
            if 'meanings' not in card:
                card['meanings'] = {
                    'en': en_m,
                    'zh_TW': card.get('meaning_zh', '') or '',
                }
            if 'example_translations' not in card:
                card['example_translations'] = {
                    'en': en_ex,
                    'zh_TW': card.get('example_translation_zh', '') or '',
                }
            card['meanings'][lang_key] = m_map.get(en_m, en_m) or en_m
            card['example_translations'][lang_key] = e_map.get(en_ex, en_ex) or en_ex

        # Save data before updating checkpoint, so a crash during save doesn't
        # cause the checkpoint to claim this language is done.
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

        done.add(lang_key)
        checkpoint.write_text(json.dumps(list(done)))
        print(f'  ✓ Saved (checkpoint: {sorted(done)})')

    checkpoint.unlink(missing_ok=True)
    print(f'  {level.upper()} COMPLETE!')


def main():
    parser = argparse.ArgumentParser(description='Translate InstaLingo cards')
    parser.add_argument('--free', action='store_true',
                        help='Use free Google Translate (slow)')
    parser.add_argument('--level', type=str,
                        help='Process specific level only (n5-n1)')
    args = parser.parse_args()

    api_key = os.environ.get('GOOGLE_API_KEY', '')

    if args.level and args.level not in ALL_LEVELS:
        print(f'Error: Invalid level "{args.level}". Must be one of: {ALL_LEVELS}')
        sys.exit(1)
    levels = [args.level] if args.level else ALL_LEVELS

    if api_key and not args.free:
        print(f'Using Google Cloud Translation API (fast)')
        translate_fn = lambda texts, lang: translate_via_cloud(texts, lang, api_key)
    else:
        print('Using free Google Translate (slower)')
        translate_fn = translate_via_free

    for level in levels:
        process_level(level, translate_fn)

    print('\n🎉 ALL DONE! Run "flutter build web" to rebuild with translated data.')


if __name__ == '__main__':
    main()
