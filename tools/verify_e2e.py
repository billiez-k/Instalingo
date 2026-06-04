#!/usr/bin/env python3
"""
InstaLingo End-to-End Verification Script
==========================================

Statically verifies the integrity of the learning content pipeline:
  1. Every Lesson has non-empty vocabulary
  2. Completing a lesson would add actual words to learnedWords
  3. Every Post's requiredWords exist in some lesson's vocabulary
  4. All translatable fields use LocalizedText (no raw English strings)
  5. UI screens read .get(nativeLang) for LocalizedText fields
  6. No emojis in learning content (per project policy)

Usage:
  python tools/verify_e2e.py
"""

import re
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent.resolve()
DATA_FILE = PROJECT_ROOT / "lib" / "data" / "demo_data.dart"
MODELS_DIR = PROJECT_ROOT / "lib" / "models"
SCREENS_DIR = PROJECT_ROOT / "lib" / "screens"
PROVIDERS_DIR = PROJECT_ROOT / "lib" / "providers"


def parse_lesson_vocab(text: str) -> dict:
    """Extract lesson IDs and their vocabulary lists from demo_data.dart."""
    lessons = {}
    # Match: vocabulary: const ["word1", "word2"] with double quotes (new courses)
    for m in re.finditer(r'id:\s*["\']([^"\']+?)["\'].*?vocabulary:\s*const\s*\[(.*?)\]', text, re.DOTALL):
        lid = m.group(1)
        vocab_str = m.group(2)
        vocab = [v.strip().strip('"') for v in vocab_str.split(',') if v.strip()]
        if vocab and lid:
            lessons[lid] = vocab
    
    # Match old helper function pattern: _lessonXx(..., vocabulary: ['word1', ...])
    for m in re.finditer(r'_lesson[a-zA-Z_]+\(\s*[^,]+,\s*[^,]+,\s*[^,]+,.*?vocabulary:\s*(?:const\s*)?\[(.*?)\]', text, re.DOTALL):
        before = text[:m.start()]
        id_match = list(re.finditer(r"id:\s*'([^']+)'", before))[-1] if re.findall(r"id:\s*'([^']+)'", before) else None
        if id_match:
            lid = id_match.group(1)
            vocab_str = m.group(1)
            vocab = [v.strip().strip("'\"") for v in vocab_str.split(',') if v.strip()]
            if lid not in lessons:
                lessons[lid] = vocab
    return lessons


def parse_post_required_words(text: str) -> dict:
    """Extract post IDs and their requiredWords lists."""
    posts = {}
    for m in re.finditer(r"Post\(\s*id:\s*'([^']+)'.*?requiredWords:\s*(?:const\s*)?\[(.*?)\]", text, re.DOTALL):
        pid = m.group(1)
        rw_str = m.group(2)
        words = [w.strip().strip("'\"") for w in rw_str.split(",") if w.strip()]
        posts[pid] = words
    return posts


def extract_balanced_blocks(text: str, class_name: str) -> list:
    """Extract Dart constructor blocks with balanced parentheses."""
    blocks = []
    pattern = re.compile(rf"\b{class_name}\(")
    for m in pattern.finditer(text):
        start = m.end()
        depth = 1
        i = start
        while i < len(text) and depth > 0:
            if text[i] == '(':
                depth += 1
            elif text[i] == ')':
                depth -= 1
            i += 1
        # Include the closing ) but not the trailing ,
        block = text[start:i-1]
        blocks.append(block)
    return blocks


def check_lesson_vocabulary(text: str) -> list:
    """Check that every lesson has non-empty vocabulary."""
    issues = []
    lesson_blocks = extract_balanced_blocks(text, "Lesson")
    for block in lesson_blocks:
        id_match = re.search(r"id:\s*'([^']+)'", block)
        if not id_match:
            continue
        lid = id_match.group(1)
        # Skip if this looks like an exercise (shouldn't happen with balanced)
        if lid.startswith("ex_"):
            continue
        vocab_match = re.search(r"vocabulary:\s*(?:const\s*)?\[(.*?)\]", block, re.DOTALL)
        if not vocab_match:
            issues.append(f"Lesson {lid} has NO vocabulary field")
        else:
            vocab_str = vocab_match.group(1)
            vocab = [v.strip().strip("'") for v in vocab_str.split(",") if v.strip()]
            if not vocab:
                issues.append(f"Lesson {lid} has EMPTY vocabulary")
    return issues


def check_post_prerequisites(text: str, lessons: dict) -> list:
    """Check that every post's requiredWords exist in lesson vocabulary."""
    issues = []
    all_vocab = set()
    for vocab in lessons.values():
        all_vocab.update(vocab)

    post_blocks = extract_balanced_blocks(text, "Post")
    for block in post_blocks:
        id_match = re.search(r"id:\s*'([^']+)'", block)
        if not id_match:
            continue
        pid = id_match.group(1)
        rw_match = re.search(r"requiredWords:\s*(?:const\s*)?\[(.*?)\]", block, re.DOTALL)
        if not rw_match:
            issues.append(f"Post {pid} has NO requiredWords field")
            continue
        rw_str = rw_match.group(1)
        words = [w.strip().strip("'") for w in rw_str.split(",") if w.strip()]
        if not words:
            # Empty requiredWords means no prerequisites — that's fine
            continue
        for word in words:
            if word not in all_vocab:
                issues.append(f"Post {pid} requires word '{word}' which is NOT in any lesson vocabulary")
    return issues


def check_localized_text_completeness(text: str) -> list:
    """Check all LocalizedText objects have all 8 languages."""
    issues = []
    all_langs = {"en", "zh", "zh_TW", "ko", "ja", "fr", "es", "de"}
    for m in re.finditer(r"LocalizedText\(\{(.*?)\}\)", text, re.DOTALL):
        inner = m.group(1)
        found_langs = set(re.findall(r"'([^']+)':", inner))
        missing = all_langs - found_langs
        if missing:
            # Get context (id field before this)
            before = text[:m.start()]
            id_match = list(re.finditer(r"id:\s*'([^']+)'", before))[-1] if re.findall(r"id:\s*'([^']+)'", before) else None
            ctx = id_match.group(1) if id_match else "unknown"
            issues.append(f"{ctx} LocalizedText missing languages: {missing}")
    return issues


def check_no_raw_english_in_learning_content(text: str) -> list:
    """Check that translatable fields are wrapped in LocalizedText."""
    issues = []
    # In Post blocks, wordTranslation/wordExplanation should NOT be raw strings
    post_blocks = extract_balanced_blocks(text, "Post")
    for block in post_blocks:
        id_match = re.search(r"id:\s*'([^']+)'", block)
        if not id_match:
            continue
        pid = id_match.group(1)
        for field in ["wordTranslation", "wordExplanation", "wordExampleTranslation"]:
            # Check if field exists but is NOT a LocalizedText
            m = re.search(rf"{field}:\s*'(?!const LocalizedText)", block)
            if m:
                issues.append(f"Post {pid} has raw string for {field}")
    return issues


def check_ui_reads_localized_text() -> list:
    """Check that UI screens use .get(nativeLang) or .get(context, ...)."""
    issues = []
    screen_files = list(SCREENS_DIR.rglob("*.dart"))
    for f in screen_files:
        text = f.read_text(encoding="utf-8")
        # Look for direct access to LocalizedText fields without .get()
        # wordTranslation.value or wordTranslation.toString() would be wrong
        bad_patterns = [
            (r"wordTranslation\s*[^.\n]*\n", "wordTranslation without .get()"),
            (r"wordExplanation\s*[^.\n]*\n", "wordExplanation without .get()"),
            (r"wordExampleTranslation\s*[^.\n]*\n", "wordExampleTranslation without .get()"),
        ]
        for pattern, msg in bad_patterns:
            if re.search(pattern, text):
                # Check if it's actually a .get() call
                for m in re.finditer(pattern, text):
                    line = text[m.start():m.end()]
                    if ".get(" not in line:
                        issues.append(f"{f.name}: {msg} near '{line.strip()}'")
    return issues


def check_no_emojis(text: str) -> list:
    """Check for emoji characters in learning content."""
    issues = []
    # Only actual emoji pictographs (not CJK characters)
    emoji_pattern = re.compile(
        "["
        "\U0001F600-\U0001F64F"  # emoticons
        "\U0001F300-\U0001F5FF"  # symbols & pictographs
        "\U0001F680-\U0001F6FF"  # transport & map
        "\U0001F1E0-\U0001F1FF"  # flags
        "\U00002702-\U000027B0"   # dingbats
        "\U0001F900-\U0001F9FF"   # supplemental symbols
        "\U0001FA00-\U0001FA6F"   # chess / sports symbols
        "\U0001FA70-\U0001FAFF"   # symbols and shapes extended
        "\U00002600-\U000026FF"   # misc symbols
        "]+"
    )
    # Only check inside Post and Exercise blocks
    for block_type in ["Post", "Exercise"]:
        blocks = extract_balanced_blocks(text, block_type)
        for block in blocks:
            id_match = re.search(r"id:\s*'([^']+)'", block)
            entity_id = id_match.group(1) if id_match else "unknown"
            for m in emoji_pattern.finditer(block):
                issues.append(f"{block_type} {entity_id} contains emoji: {m.group()}")
    return issues


def check_providers_logic() -> list:
    """Check that providers correctly wire vocabulary tracking and post filtering."""
    issues = []
    
    # Check UserNotifier has addLearnedWords
    user_notifier = PROVIDERS_DIR / "user_provider.dart"
    if user_notifier.exists():
        text = user_notifier.read_text(encoding="utf-8")
        if "addLearnedWords" not in text:
            issues.append("UserNotifier missing addLearnedWords method")
    else:
        issues.append("user_provider.dart not found")

    # Check CourseNotifier.completeLesson calls addLearnedWords
    course_notifier = PROVIDERS_DIR / "course_provider.dart"
    if course_notifier.exists():
        text = course_notifier.read_text(encoding="utf-8")
        if "addLearnedWords" not in text:
            issues.append("CourseNotifier.completeLesson does not call addLearnedWords")
        if "lesson.vocabulary" not in text and "lessonVocab" not in text:
            issues.append("CourseNotifier.completeLesson does not extract lesson vocabulary")
    else:
        issues.append("course_provider.dart not found")

    # Check PostNotifier filters by learnedWords
    posts_notifier = PROVIDERS_DIR / "post_provider.dart"
    if posts_notifier.exists():
        text = posts_notifier.read_text(encoding="utf-8")
        if "learnedWords" not in text:
            issues.append("PostsNotifier does not reference learnedWords")
        if "requiredWords" not in text:
            issues.append("PostsNotifier does not filter by requiredWords")
    else:
        issues.append("post_provider.dart not found")

    return issues


def main():
    text = DATA_FILE.read_text(encoding="utf-8")
    all_issues = []

    print("=" * 60)
    print("InstaLingo End-to-End Verification")
    print("=" * 60)

    # 1. Lesson vocabulary
    print("\n[1] Checking lesson vocabulary...")
    issues = check_lesson_vocabulary(text)
    if issues:
        print(f"  FAIL: {len(issues)} issues")
        for i in issues[:10]:
            print(f"    - {i}")
    else:
        print("  PASS: All lessons have non-empty vocabulary")
    all_issues.extend(issues)

    # 2. Post prerequisites
    print("\n[2] Checking post prerequisite words...")
    lessons = parse_lesson_vocab(text)
    issues = check_post_prerequisites(text, lessons)
    if issues:
        print(f"  FAIL: {len(issues)} issues")
        for i in issues[:10]:
            print(f"    - {i}")
    else:
        print("  PASS: All post requiredWords exist in lesson vocabulary")
    all_issues.extend(issues)

    # 3. LocalizedText completeness
    print("\n[3] Checking LocalizedText completeness...")
    issues = check_localized_text_completeness(text)
    if issues:
        print(f"  FAIL: {len(issues)} issues")
        for i in issues[:10]:
            print(f"    - {i}")
    else:
        print("  PASS: All LocalizedText objects have all 8 languages")
    all_issues.extend(issues)

    # 4. No raw strings
    print("\n[4] Checking no raw English in translatable fields...")
    issues = check_no_raw_english_in_learning_content(text)
    if issues:
        print(f"  FAIL: {len(issues)} issues")
        for i in issues[:10]:
            print(f"    - {i}")
    else:
        print("  PASS: All translatable fields use LocalizedText")
    all_issues.extend(issues)

    # 5. UI reads .get()
    print("\n[5] Checking UI screens read LocalizedText with .get()...")
    issues = check_ui_reads_localized_text()
    if issues:
        print(f"  FAIL: {len(issues)} issues")
        for i in issues[:10]:
            print(f"    - {i}")
    else:
        print("  PASS: UI screens correctly use .get() for LocalizedText")
    all_issues.extend(issues)

    # 6. No emojis
    print("\n[6] Checking for emojis in learning content...")
    issues = check_no_emojis(text)
    if issues:
        print(f"  FAIL: {len(issues)} issues")
        for i in issues[:10]:
            print(f"    - {i}")
    else:
        print("  PASS: No emojis found in learning content")
    all_issues.extend(issues)

    # 7. Provider logic
    print("\n[7] Checking provider vocabulary tracking logic...")
    issues = check_providers_logic()
    if issues:
        print(f"  FAIL: {len(issues)} issues")
        for i in issues:
            print(f"    - {i}")
    else:
        print("  PASS: Provider logic correctly wires vocabulary tracking")
    all_issues.extend(issues)

    # Summary
    print("\n" + "=" * 60)
    if all_issues:
        print(f"OVERALL: FAILED ({len(all_issues)} issues total)")
        return 1
    else:
        print("OVERALL: PASSED — All checks green!")
        return 0


if __name__ == "__main__":
    sys.exit(main())
