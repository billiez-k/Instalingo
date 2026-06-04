#!/usr/bin/env python3
"""
fix_translations.py — Fix translation_zh in Manus-acquired vocab CSVs.
Uses DeepL API (free tier) to translate Korean/Japanese words to Chinese.

Without API key: flags untranslated words for manual review.
With API key: batch-translates all missing/wrong translations.

Usage:
  # Without API (just audit):
  python3 tools/fix_translations.py --lang ko --audit
  
  # With API:
  python3 tools/fix_translations.py --lang ko,ja --api-key YOUR_KEY
  
  # Then regenerate:
  python3 tools/build_courses_from_raw.py --all
"""

import csv, json, os, sys, argparse, re
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent.resolve()
RAW_DIR = PROJECT_ROOT / "manus_output" / "instalingo_raw_data"
OUT_DIR = RAW_DIR  # Write fixed CSVs back to same location

def load_vocab(lang):
    path = RAW_DIR / f"{lang}_vocab.csv"
    if not path.exists():
        return []
    with open(path, encoding='utf-8') as f:
        return list(csv.DictReader(f))

def save_vocab(lang, rows):
    path = RAW_DIR / f"{lang}_vocab.csv"
    fieldnames = list(rows[0].keys()) if rows else []
    with open(path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
    print(f"  Saved: {path} ({len(rows)} rows)")

def audit_translations(lang):
    """Audit translation_zh quality and flag issues."""
    rows = load_vocab(lang)
    issues = []
    
    for r in rows:
        w = r.get('word', '').strip()
        zh = r.get('translation_zh', '').strip()
        en = r.get('example_translation', '').strip()
        
        if not zh:
            issues.append(f"MISSING: {w} (en={en})")
        elif all(c < '\u0080' for c in zh):
            issues.append(f"NOT_CHINESE: {w} → zh='{zh}' (en={en})")
        elif len(zh) > 20:
            issues.append(f"TOO_LONG: {w} → zh='{zh[:30]}...'")
    
    print(f"\n{lang.upper()} translation audit: {len(rows)} words, {len(issues)} issues")
    for i in issues[:20]:
        print(f"  {i}")
    if len(issues) > 20:
        print(f"  ... and {len(issues) - 20} more")
    
    return rows, issues

def translate_deepl(text, source_lang, target_lang, api_key):
    """Translate text using DeepL API."""
    import urllib.request, urllib.parse
    
    url = "https://api-free.deepl.com/v2/translate" if ":fx" not in api_key else "https://api.deepl.com/v2/translate"
    
    data = urllib.parse.urlencode({
        'text': text,
        'source_lang': source_lang.upper(),
        'target_lang': target_lang.upper(),
    }).encode()
    
    req = urllib.request.Request(url, data=data)
    req.add_header('Authorization', f'DeepL-Auth-Key {api_key}')
    req.add_header('Content-Type', 'application/x-www-form-urlencoded')
    
    try:
        with urllib.request.urlopen(req) as resp:
            result = json.loads(resp.read())
            return result['translations'][0]['text']
    except Exception as e:
        print(f"  DeepL error: {e}")
        return None

def fix_translations_deepl(lang, api_key):
    """Fix translations using DeepL API."""
    rows = load_vocab(lang)
    fixed = 0
    failed = 0
    
    # Build batch of words to translate
    to_translate = []
    for r in rows:
        zh = r.get('translation_zh', '').strip()
        en = r.get('example_translation', '').strip()
        word = r.get('word', '').strip()
        
        # Determine if translation needs fixing
        needs_fix = (
            not zh or                          # Missing
            all(c < '\u0080' for c in zh) or   # Not Chinese
            len(zh) > 20                       # Too long (probably a sentence)
        )
        
        if needs_fix and word:
            # Use English translation as context for better accuracy
            context = f"{word} ({en})" if en else word
            to_translate.append((r, context, word))
    
    print(f"\n{lang.upper()}: {len(to_translate)} words need translation")
    
    if not to_translate:
        return rows
    
    # Translate in batches
    BATCH_SIZE = 50
    for i in range(0, len(to_translate), BATCH_SIZE):
        batch = to_translate[i:i+BATCH_SIZE]
        texts = [b[1] for b in batch]
        
        # DeepL free tier: text param with newline separation
        combined = '\n'.join(texts)
        
        # Map source language
        lang_map = {'ko': 'KO', 'ja': 'JA', 'zh': 'ZH', 'fr': 'FR', 'es': 'ES', 'de': 'DE'}
        src = lang_map.get(lang, lang.upper())
        
        print(f"  Translating batch {i//BATCH_SIZE + 1}/{(len(to_translate)-1)//BATCH_SIZE + 1} ({len(batch)} words)...")
        result = translate_deepl(combined, src, 'ZH', api_key)
        
        if result:
            translations = result.split('\n')
            for j, (row, _, word) in enumerate(batch):
                if j < len(translations):
                    trans = translations[j].strip()
                    # Clean: take first phrase, remove parentheses
                    trans = re.sub(r'\s*\(.*?\)', '', trans).strip()
                    row['translation_zh'] = trans
                    fixed += 1
                    print(f"    {word} → {trans}")
        else:
            failed += len(batch)
    
    print(f"\n  Fixed: {fixed}, Failed: {failed}")
    
    if fixed > 0:
        save_vocab(lang, rows)
    
    return rows

def fix_translations_manual(lang):
    """Manual fix: flag issues for review without API."""
    rows, issues = audit_translations(lang)
    
    # For words with English "translations" that look like translations, 
    # just use the English as a placeholder
    manual_fixes = 0
    for r in rows:
        zh = r.get('translation_zh', '').strip()
        en = r.get('example_translation', '').strip()
        
        if not zh and en:
            # Use English as placeholder with marker
            r['translation_zh'] = f"[EN] {en}"
            manual_fixes += 1
    
    if manual_fixes:
        print(f"\n  Added {manual_fixes} placeholder translations (English as fallback)")
        save_vocab(lang, rows)
    
    return rows


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Fix translations in vocab CSVs')
    parser.add_argument('--lang', default='ko', help='Language codes, comma-separated (ko,ja,fr,es,zh,de)')
    parser.add_argument('--audit', action='store_true', help='Audit only, no fixes')
    parser.add_argument('--api-key', help='DeepL API key (free: ends with :fx)')
    args = parser.parse_args()
    
    langs = [l.strip() for l in args.lang.split(',')]
    
    for lang in langs:
        if args.audit:
            audit_translations(lang)
        elif args.api_key:
            fix_translations_deepl(lang, args.api_key)
        else:
            print(f"\n{lang.upper()}: No API key — using manual fallback")
            fix_translations_manual(lang)
    
    if not args.api_key and not args.audit:
        print("\n" + "=" * 60)
        print("NO API KEY PROVIDED")
        print("=" * 60)
        print("To properly fix translations, get a free DeepL API key:")
        print("  1. Sign up at https://www.deepl.com/pro-api")
        print("  2. Get your API key (free tier: 500,000 chars/month)")
        print("  3. Run: python3 tools/fix_translations.py --lang ko,ja --api-key YOUR_KEY")
        print("\nCurrent fix: English placeholders added for missing translations.")
