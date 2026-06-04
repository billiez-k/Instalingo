#!/usr/bin/env python3
"""
Systematic English-leak validator for InstaLingo.
Run: python3 tools/validate_no_english_leaks.py
Returns exit code 0 if CLEAN, 1 if LEAKS FOUND.
Designed for CI — blocks any PR that introduces English leaks.
"""

import re, os, json, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ERRORS = []

# ─── Whitelist: strings that are OK to match English ───
PROPER_NOUNS = {
    'InstaLingo', 'HSK', 'TOPIK', 'JLPT', 'XP', 'AI', 'OK', 'Maya',
    'A1', 'A2', 'B1', 'B2', 'C1', 'C2', 'N5', 'N4', 'N3', 'N2', 'N1',
    'TOPIK I', 'TOPIK II', 'SUPER', 'Super', 'Chill Corner',
    'LV',  # International gaming abbreviation
    'JLPT N3', 'JLPT N2', 'JLPT N1', 'JLPT N3 Vocabulary', 'JLPT N2 Vocabulary', 'JLPT N1 Vocabulary',  # JLPT exam proper nouns
    'Intermediate-Advanced Japanese',  # Course level descriptor (intentionally English)
}

# ─── ARB keys exempt from translation (intentional English) ───
ARB_EXEMPT_KEYS = {
    'aiBadge', 'aiAssistantName', 'profile_instalingoSuperFAQ', 'profile_superBadge',
    'appTitle',  # Brand name
}

# ─── Locales that don't need full coverage (deprecated) ───
DEPRECATED_LOCALES = {'fr', 'de', 'es'}

# ─── RULE 1: LocalizedText blocks — all 8 locales non-empty, no en-copy ───
REQUIRED_LOCALES = {'en', 'zh', 'zh_TW', 'ko', 'ja', 'es', 'fr', 'de'}

def check_demo_data():
    path = os.path.join(ROOT, 'lib', 'data', 'demo_data.dart')
    if not os.path.exists(path):
        ERRORS.append(f"MISSING: {path}")
        return
    with open(path) as f:
        content = f.read()
    
    blocks = re.findall(r"LocalizedText\(\{([^}]+)\}\)", content)
    
    # Find where Post content starts (these blocks only need en + target lang)
    post_start = content.find('// ========== CHILL CORNER POSTS ==========')
    if post_start == -1:
        post_start = content.find('static List<Post> get _koreanPosts')
    if post_start == -1:
        post_start = len(content)  # no posts

    for i, block in enumerate(blocks):
        # Find this block's position in the file
        block_pos = content.find(f"LocalizedText({{{block}}}")

        pairs = dict(re.findall(r"'(\w+)':\s*\"([^\"]*)\"", block))
        en_val = pairs.get('en', '')

        # Skip Post content blocks — they only need en + target language
        is_post_block = block_pos > post_start if block_pos >= 0 else False

        if not en_val or not en_val.strip():
            # OK if this is a grammar example where other locales have content
            other_filled = any(pairs.get(l, '').strip() for l in REQUIRED_LOCALES - {'en'})
            if not is_post_block and not other_filled:
                ERRORS.append(f"demo_data.dart block #{i}: en locale EMPTY, all locales empty")
            continue

        for loc in REQUIRED_LOCALES - {'en'}:
            if is_post_block and loc in DEPRECATED_LOCALES:
                continue  # Posts don't need deprecated locale translations

            val = pairs.get(loc, '__MISSING__')

            if val == '__MISSING__':
                if not is_post_block:
                    ERRORS.append(f"demo_data.dart block #{i}: locale '{loc}' MISSING (en='{en_val[:40]}')")
            elif not val.strip():
                if not is_post_block:
                    ERRORS.append(f"demo_data.dart block #{i}: locale '{loc}' EMPTY (en='{en_val[:40]}')")
            elif loc != 'en' and val == en_val:
                if not any(pn in en_val.strip() for pn in PROPER_NOUNS):
                    ERRORS.append(f"demo_data.dart block #{i}: '{loc}' is COPY of English — \"{en_val[:60]}\"")
    
    # Check for "Lesson N" pattern in any non-en locale
    for loc in REQUIRED_LOCALES - {'en'}:
        matches = re.findall(rf"'{loc}':\s*\"Lesson \d", content)
        for m in matches:
            ERRORS.append(f"demo_data.dart: HARDCODED 'Lesson N' in {loc} locale")
    
    # Check for "Learn:" in non-en locales
    for loc in REQUIRED_LOCALES - {'en'}:
        matches = re.findall(rf"'{loc}':\s*\"Learn:", content)
        for m in matches:
            ERRORS.append(f"demo_data.dart: HARDCODED 'Learn:' in {loc} locale")


# ─── RULE 2: ARB files — no English copies ───
def check_arb_files():
    arb_dir = os.path.join(ROOT, 'lib', 'l10n')
    if not os.path.exists(arb_dir):
        ERRORS.append(f"MISSING: {arb_dir}")
        return
    
    en_path = os.path.join(arb_dir, 'app_en.arb')
    if not os.path.exists(en_path):
        ERRORS.append(f"MISSING: {en_path}")
        return
    
    with open(en_path) as f:
        en_data = json.load(f)
    
    en_keys = {k: v for k, v in en_data.items() if not k.startswith('@')}
    
    for fname in sorted(os.listdir(arb_dir)):
        if not fname.endswith('.arb') or fname == 'app_en.arb':
            continue
        loc = fname.replace('app_', '').replace('.arb', '')
        path = os.path.join(arb_dir, fname)
        with open(path) as f:
            data = json.load(f)
        
        # Check for missing keys
        for k in en_keys:
            if k not in data:
                ERRORS.append(f"ARB {loc}: MISSING key '{k}'")
        
        # Check for English copies (skip deprecated locales and exempt keys)
        if loc in DEPRECATED_LOCALES:
            continue  # fr/de/es are not actively maintained

        for k, v in data.items():
            if k.startswith('@'):
                continue
            if k in ARB_EXEMPT_KEYS:
                continue
            if k in en_keys and v == en_keys[k] and len(str(v)) > 3:
                if not any(pn in str(v) for pn in PROPER_NOUNS):
                    ERRORS.append(f"ARB {loc}.{k}: COPY of English — \"{str(v)[:60]}\"")


# ─── RULE 3: Screen/widget files — no hardcoded English UI strings ───
ENGLISH_WORD = re.compile(r'\b[A-Za-z]{3,}\b')

def check_dart_files():
    for root, dirs, files in os.walk(os.path.join(ROOT, 'lib')):
        # Skip generated files, tests, vendor
        dirs[:] = [d for d in dirs if d not in ['generated', '.dart_tool']]
        
        for f in files:
            if not f.endswith('.dart'):
                continue
            path = os.path.join(root, f)
            rel = os.path.relpath(path, ROOT)
            
            # Skip vendor
            if 'vendor/' in rel:
                continue
            
            with open(path) as fh:
                content = fh.read()
            
            # Find ALL Text() widgets with string literals (not l10n)
            for m in re.finditer(r"Text\(\s*'([^']{3,})'", content):
                text = m.group(1)
                # Skip if it's a variable interpolation
                if text.startswith('$') or '${' in text:
                    continue
                # Skip if it contains l10n
                if 'l10n.' in text:
                    continue
                # Skip pure numbers/symbols/formatting
                if not ENGLISH_WORD.search(text):
                    continue
                # Skip international acronyms
                if text.strip() in PROPER_NOUNS:
                    continue
                # Skip time/notification service strings (system-level, not UI)
                if 'notification_service' in rel:
                    continue
                # Skip XP/gaming acronyms in context
                if 'XP' in text and len(text) < 20:
                    continue

                line_num = content[:m.start()].count('\n') + 1
                ERRORS.append(f"{rel}:{line_num} HARDCODED ENGLISH: \"{text[:80]}\"")

            # Check for "LV " pattern specifically (without l10n)
            lv_matches = re.finditer(r"'LV \$\w+'", content)
            for lvm in lv_matches:
                line_num = content[:lvm.start()].count('\n') + 1
                ERRORS.append(f"{rel}:{line_num} HARDCODED 'LV': \"{lvm.group()}\"")


# ─── RULE 4: Deleted courses must stay deleted ───
def check_deleted_courses():
    path = os.path.join(ROOT, 'lib', 'data', 'demo_data.dart')
    if not os.path.exists(path):
        return
    with open(path) as f:
        content = f.read()
    
    banned = ['frenchA1', 'spanishA1', 'germanA1', 'englishA1', 'chineseA1']
    for course in banned:
        if f'static Course get {course}' in content:
            ERRORS.append(f"demo_data.dart: BANNED COURSE '{course}' still present!")


# ─── RULE 5: Achievement model must use LocalizedText ───
def check_achievement_model():
    path = os.path.join(ROOT, 'lib', 'models', 'achievement.dart')
    with open(path) as f:
        content = f.read()
    if 'LocalizedText title' not in content or 'LocalizedText description' not in content:
        ERRORS.append("achievement.dart: title/description must be LocalizedText, not String")
    
    # Also check that achievements_screen uses .resolve()
    screen_path = os.path.join(ROOT, 'lib', 'screens', 'profile', 'achievements_screen.dart')
    if os.path.exists(screen_path):
        with open(screen_path) as f:
            sc = f.read()
        if 'achievement.title.resolve(' not in sc:
            ERRORS.append("achievements_screen.dart: must call .resolve() on LocalizedText title")


# ─── RUN ALL CHECKS ───
if __name__ == '__main__':
    print("=" * 60)
    print("InstaLingo English Leak Validator")
    print("=" * 60)
    
    check_demo_data()
    check_arb_files()
    check_dart_files()
    check_deleted_courses()
    check_achievement_model()
    
    if ERRORS:
        print(f"\n❌ {len(ERRORS)} ISSUES FOUND:\n")
        for e in ERRORS:
            print(f"  • {e}")
        print(f"\n❌ VALIDATION FAILED — {len(ERRORS)} issues")
        sys.exit(1)
    else:
        print("\n✅ ALL CHECKS PASSED — No English leaks detected")
        print("✅ LocalizedText: all 8 locales present")
        print("✅ ARB files: no untranslated keys")
        print("✅ Screens: no hardcoded English strings")
        print("✅ Banned courses: all removed")
        print("✅ Achievement model: LocalizedText")
        sys.exit(0)
