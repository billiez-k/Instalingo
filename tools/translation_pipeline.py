#!/usr/bin/env python3
"""
InstaLingo Translation Pipeline v2
==================================

A robust tool to export, translate, and import localized content for
InstaLingo's LocalizedText-based learning content.

Supports:
  - ARB file UI strings (lib/l10n/app_*.arb)
  - Chill Corner post content (lib/data/demo_data.dart)
  - Course exercise content (lib/data/demo_data.dart)
  - Translation memory (cache) so unchanged strings are never re-translated
  - Differential export (only missing translations)

Usage:
  # 1. Export all missing / incomplete translations
  python tools/translation_pipeline.py --export --out translation_export.json

  # 2. (Human or AI step) Translate the export file.
  #    Fill in the empty "target" fields for each missing language.

  # 3. Import translated strings back into the codebase
  python tools/translation_pipeline.py --import --in translation_export_translated.json

  # 4. Verify all LocalizedText objects are complete
  python tools/translation_pipeline.py --verify

  # 5. Show stats
  python tools/translation_pipeline.py --stats
"""

import argparse
import json
import os
import re
import sys
from collections import defaultdict
from dataclasses import dataclass, field, asdict
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Set

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
PROJECT_ROOT = Path(__file__).parent.parent.resolve()
L10N_DIR = PROJECT_ROOT / "lib" / "l10n"
DATA_FILE = PROJECT_ROOT / "lib" / "data" / "demo_data.dart"
CACHE_FILE = PROJECT_ROOT / ".translation_cache.json"

SOURCE_CONTENT_LANG = "en"

# Languages we support for UI (ARB files)
UI_LANGUAGES = ["zh", "zh_TW", "ko", "ja", "fr", "es", "de"]

# Languages we support for learning content (post + exercise content)
CONTENT_LANGUAGES = ["ko", "ja", "fr", "es", "zh", "de"]

ALL_LANGS = ["en", "zh", "zh_TW", "ko", "ja", "fr", "es", "de"]

# ---------------------------------------------------------------------------
# Data classes
# ---------------------------------------------------------------------------

@dataclass
class MissingTranslation:
    id: str
    category: str
    source_lang: str
    target_lang: str
    source_text: str
    context: str
    file_path: str
    dart_field: str
    target: str = ""


@dataclass
class TranslationExport:
    generated_at: str
    total_missing: int
    by_category: Dict[str, List[Dict]] = field(default_factory=dict)


# ---------------------------------------------------------------------------
# Cache / Translation Memory
# ---------------------------------------------------------------------------

class TranslationCache:
    def __init__(self, path: Path = CACHE_FILE):
        self.path = path
        self._data: Dict[str, Dict] = {}
        self._load()

    def _load(self):
        if self.path.exists():
            with open(self.path, "r", encoding="utf-8") as f:
                self._data = json.load(f)
        else:
            self._data = {}

    def save(self):
        with open(self.path, "w", encoding="utf-8") as f:
            json.dump(self._data, f, ensure_ascii=False, indent=2)

    def key(self, source: str, source_lang: str, target_lang: str, category: str) -> str:
        import hashlib
        h = hashlib.sha256(f"{source}|{source_lang}|{target_lang}|{category}".encode()).hexdigest()[:16]
        return h

    def get(self, source: str, source_lang: str, target_lang: str, category: str) -> Optional[str]:
        k = self.key(source, source_lang, target_lang, category)
        entry = self._data.get(k)
        if entry and entry.get("source") == source:
            return entry.get("target")
        return None

    def set(self, source: str, source_lang: str, target_lang: str, category: str, target: str):
        k = self.key(source, source_lang, target_lang, category)
        self._data[k] = {
            "source": source,
            "source_lang": source_lang,
            "target": target,
            "target_lang": target_lang,
            "category": category,
            "updated_at": datetime.now().isoformat(),
        }

    def has_changed(self, source: str, source_lang: str, target_lang: str, category: str) -> bool:
        k = self.key(source, source_lang, target_lang, category)
        entry = self._data.get(k)
        if not entry:
            return True
        return entry.get("source") != source


# ---------------------------------------------------------------------------
# LocalizedText Parser
# ---------------------------------------------------------------------------

LOCALIZED_TEXT_RE = re.compile(
    r"LocalizedText\(\{(.*?)\}\)",
    re.DOTALL
)


def parse_localized_text(block: str) -> Dict[str, str]:
    """Parse a LocalizedText({...}) Dart expression into a dict."""
    m = LOCALIZED_TEXT_RE.search(block)
    if not m:
        return {}
    inner = m.group(1)
    result = {}
    # Match 'lang': 'value' pairs
    for pair in re.finditer(r"'([^']+)':\s*'([^']*)", inner):
        result[pair.group(1)] = pair.group(2)
    return result


def build_localized_text(translations: Dict[str, str]) -> str:
    """Build a Dart LocalizedText expression from a dict."""
    parts = []
    for lang in ALL_LANGS:
        val = translations.get(lang, "")
        val = val.replace("'", "\\'")
        parts.append(f"'{lang}': '{val}'")
    return f"const LocalizedText({{{', '.join(parts)}}})"


# ---------------------------------------------------------------------------
# Extractors
# ---------------------------------------------------------------------------

def extract_arb_strings() -> List[MissingTranslation]:
    """Extract UI strings from ARB files that need translation."""
    items = []
    base_arb_path = L10N_DIR / "app_en.arb"
    if not base_arb_path.exists():
        print(f"Warning: {base_arb_path} not found")
        return items

    base_data = json.load(open(base_arb_path, "r", encoding="utf-8"))
    base_keys = {k: v for k, v in base_data.items() if not k.startswith("@") and isinstance(v, str)}

    for lang in UI_LANGUAGES:
        arb_path = L10N_DIR / f"app_{lang}.arb"
        if not arb_path.exists():
            continue
        translated = json.load(open(arb_path, "r", encoding="utf-8"))
        for key, source_text in base_keys.items():
            current_target = translated.get(key, "")
            if not current_target or current_target == source_text:
                items.append(MissingTranslation(
                    id=f"arb:{lang}:{key}",
                    category="arb",
                    source_lang="en",
                    target_lang=lang,
                    source_text=source_text,
                    context=f"UI string key: {key}",
                    file_path=str(arb_path.relative_to(PROJECT_ROOT)),
                    dart_field="",
                ))
    return items


def _find_parent_id(text: str, start_pos: int) -> Optional[str]:
    """Walk backward from a LocalizedText position to find the enclosing Post/Exercise id."""
    before = text[:start_pos]
    # Find the closest id: '...' before this position
    ids = list(re.finditer(r"id:\s*'([^']+)'", before))
    if not ids:
        return None
    return ids[-1].group(1)


def extract_post_content() -> List[MissingTranslation]:
    """Extract Chill Corner post translatable LocalizedText fields and find missing languages."""
    items = []
    text = DATA_FILE.read_text(encoding="utf-8")

    fields_to_check = [
        ("wordTranslation", r"wordTranslation:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("wordExplanation", r"wordExplanation:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("wordExampleTranslation", r"wordExampleTranslation:\s*(const LocalizedText\(\{[^{}]+\}\))"),
    ]

    for field_name, pattern in fields_to_check:
        for m in re.finditer(pattern, text, re.DOTALL):
            lt_block = m.group(1)
            translations = parse_localized_text(lt_block)
            source_text = translations.get("en", "")
            if not source_text:
                continue

            post_id = _find_parent_id(text, m.start())
            if not post_id or not post_id.startswith("p_"):
                continue

            for lang in CONTENT_LANGUAGES:
                existing = translations.get(lang, "")
                if not existing or existing == source_text:
                    items.append(MissingTranslation(
                        id=f"post:{post_id}:{field_name}:{lang}",
                        category=f"post_{field_name}",
                        source_lang="en",
                        target_lang=lang,
                        source_text=source_text,
                        context=f"Chill Corner post {post_id} — {field_name}",
                        file_path="lib/data/demo_data.dart",
                        dart_field=field_name,
                    ))

    return items


def extract_exercise_content() -> List[MissingTranslation]:
    """Extract exercise LocalizedText fields and find missing languages."""
    items = []
    text = DATA_FILE.read_text(encoding="utf-8")

    fields_to_check = [
        ("explanation", r"explanation:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("grammarRule", r"grammarRule:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("grammarExample", r"grammarExample:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("writingPrompt", r"writingPrompt:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("sampleAnswer", r"sampleAnswer:\s*(const LocalizedText\(\{[^{}]+\}\))"),
    ]

    for field_name, pattern in fields_to_check:
        for m in re.finditer(pattern, text, re.DOTALL):
            lt_block = m.group(1)
            translations = parse_localized_text(lt_block)
            source_text = translations.get("en", "")
            if not source_text:
                continue

            ex_id = _find_parent_id(text, m.start())
            if not ex_id or not ex_id.startswith("ex_"):
                continue

            for lang in CONTENT_LANGUAGES:
                existing = translations.get(lang, "")
                if not existing or existing == source_text:
                    items.append(MissingTranslation(
                        id=f"ex:{ex_id}:{field_name}:{lang}",
                        category=f"exercise_{field_name}",
                        source_lang="en",
                        target_lang=lang,
                        source_text=source_text,
                        context=f"Exercise {ex_id} — {field_name}",
                        file_path="lib/data/demo_data.dart",
                        dart_field=field_name,
                    ))

    return items


# ---------------------------------------------------------------------------
# Export / Import logic
# ---------------------------------------------------------------------------

def build_export(only_changed: bool = True) -> TranslationExport:
    cache = TranslationCache()
    all_items: List[MissingTranslation] = []
    all_items.extend(extract_arb_strings())
    all_items.extend(extract_post_content())
    all_items.extend(extract_exercise_content())

    if only_changed:
        filtered = []
        for item in all_items:
            if cache.has_changed(item.source_text, item.source_lang, item.target_lang, item.category):
                filtered.append(item)
        all_items = filtered

    by_cat = defaultdict(list)
    for item in all_items:
        by_cat[item.category].append(asdict(item))

    return TranslationExport(
        generated_at=datetime.now().isoformat(),
        total_missing=len(all_items),
        by_category=dict(by_cat),
    )


def save_export(export: TranslationExport, path: Path):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(asdict(export), f, ensure_ascii=False, indent=2)
    print(f"Exported {export.total_missing} missing translations to {path}")


def import_translations(path: Path, dry_run: bool = False):
    """
    Import translated strings from a JSON file back into the codebase.
    The file should be the export file with 'target' fields filled in.
    """
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)

    cache = TranslationCache()
    updates = []

    for cat, items in data.get("by_category", {}).items():
        for item_data in items:
            source_text = item_data["source_text"]
            target = item_data.get("target", "")
            source_lang = item_data.get("source_lang", "")
            target_lang = item_data.get("target_lang", "")
            category = item_data.get("category", "")
            dart_field = item_data.get("dart_field", "")
            file_path = item_data.get("file_path", "")

            if not target or target == source_text:
                continue

            cache.set(source_text, source_lang, target_lang, category, target)
            updates.append({
                "category": category,
                "dart_field": dart_field,
                "file_path": file_path,
                "source_text": source_text,
                "target_lang": target_lang,
                "target": target,
            })

    if not dry_run:
        cache.save()

    print(f"Import ready: {len(updates)} translations cached.")

    # Apply to demo_data.dart if applicable
    dart_updates = [u for u in updates if u["file_path"] == "lib/data/demo_data.dart" and u["dart_field"]]
    if dart_updates and not dry_run:
        apply_dart_localized_text_updates(dart_updates)

    return len(updates)


def apply_dart_localized_text_updates(updates: List[Dict]):
    """Inject new translations into existing LocalizedText blocks in demo_data.dart."""
    text = DATA_FILE.read_text(encoding="utf-8")
    modified = False

    for u in updates:
        field = u["dart_field"]
        target_lang = u["target_lang"]
        target = u["target"]
        source_text = u["source_text"]

        # Find LocalizedText blocks containing the source text
        pattern = rf"({re.escape(field)}:\s*const LocalizedText\(\{{.*?)('{re.escape(source_text)}')(.*?\}}\))"

        def replacer(m):
            before = m.group(1)
            source = m.group(2)
            after = m.group(3)
            # Check if target_lang already exists
            if f"'{target_lang}':" in before + after:
                return m.group(0)
            # Insert the new translation
            escaped_target = target.replace("'", "\\'")
            new_entry = f"'{target_lang}': '{escaped_target}'"
            return before + source + after.replace("})", ", " + new_entry + "})")

        new_text, count = re.subn(pattern, replacer, text, flags=re.DOTALL)
        if count > 0:
            text = new_text
            modified = True

    if modified:
        DATA_FILE.write_text(text, encoding="utf-8")
        print(f"Applied {len(updates)} translations to {DATA_FILE}")
    else:
        print("No Dart file modifications were needed.")


# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------

def verify():
    """Verify all LocalizedText objects have entries for all supported languages."""
    text = DATA_FILE.read_text(encoding="utf-8")
    issues = []

    post_fields = [
        ("wordTranslation", r"wordTranslation:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("wordExplanation", r"wordExplanation:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("wordExampleTranslation", r"wordExampleTranslation:\s*(const LocalizedText\(\{[^{}]+\}\))"),
    ]

    for field_name, pattern in post_fields:
        for m in re.finditer(pattern, text, re.DOTALL):
            post_id = _find_parent_id(text, m.start())
            if not post_id or not post_id.startswith("p_"):
                continue
            translations = parse_localized_text(m.group(1))
            for lang in ALL_LANGS:
                if lang not in translations or not translations[lang]:
                    issues.append(f"Post {post_id} {field_name} missing '{lang}'")

    ex_fields = [
        ("explanation", r"explanation:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("grammarRule", r"grammarRule:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("grammarExample", r"grammarExample:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("writingPrompt", r"writingPrompt:\s*(const LocalizedText\(\{[^{}]+\}\))"),
        ("sampleAnswer", r"sampleAnswer:\s*(const LocalizedText\(\{[^{}]+\}\))"),
    ]

    for field_name, pattern in ex_fields:
        for m in re.finditer(pattern, text, re.DOTALL):
            ex_id = _find_parent_id(text, m.start())
            if not ex_id or not ex_id.startswith("ex_"):
                continue
            translations = parse_localized_text(m.group(1))
            for lang in ALL_LANGS:
                if lang not in translations or not translations[lang]:
                    issues.append(f"Exercise {ex_id} {field_name} missing '{lang}'")

    if issues:
        print(f"VERIFICATION FAILED: {len(issues)} issues found")
        for issue in issues[:30]:
            print(f"  - {issue}")
        if len(issues) > 30:
            print(f"  ... and {len(issues) - 30} more")
        return False
    else:
        print("VERIFICATION PASSED: All LocalizedText objects are complete")
        return True


def stats():
    """Show statistics about translation coverage."""
    text = DATA_FILE.read_text(encoding="utf-8")

    def count_lt(patterns):
        total = 0
        complete = 0
        for pat in patterns:
            for m in re.finditer(pat, text, re.DOTALL):
                total += 1
                translations = parse_localized_text(m.group(1))
                if all(lang in translations and translations[lang] for lang in ALL_LANGS):
                    complete += 1
        return total, complete

    post_patterns = [
        r"wordTranslation:\s*(const LocalizedText\(\{[^{}]+\}\))",
        r"wordExplanation:\s*(const LocalizedText\(\{[^{}]+\}\))",
        r"wordExampleTranslation:\s*(const LocalizedText\(\{[^{}]+\}\))",
    ]
    post_total, post_complete = count_lt(post_patterns)

    ex_patterns = [
        r"explanation:\s*(const LocalizedText\(\{[^{}]+\}\))",
        r"grammarRule:\s*(const LocalizedText\(\{[^{}]+\}\))",
        r"grammarExample:\s*(const LocalizedText\(\{[^{}]+\}\))",
        r"writingPrompt:\s*(const LocalizedText\(\{[^{}]+\}\))",
        r"sampleAnswer:\s*(const LocalizedText\(\{[^{}]+\}\))",
    ]
    ex_total, ex_complete = count_lt(ex_patterns)

    print("=== Translation Coverage Stats ===")
    print(f"Posts: {post_complete}/{post_total} LocalizedText objects fully translated ({post_complete*100//post_total if post_total else 0}%)")
    print(f"Exercises: {ex_complete}/{ex_total} LocalizedText objects fully translated ({ex_complete*100//ex_total if ex_total else 0}%)")

    # ARB stats
    base_arb_path = L10N_DIR / "app_en.arb"
    if base_arb_path.exists():
        base_data = json.load(open(base_arb_path, "r", encoding="utf-8"))
        base_keys = [k for k, v in base_data.items() if not k.startswith("@") and isinstance(v, str)]
        for lang in UI_LANGUAGES:
            arb_path = L10N_DIR / f"app_{lang}.arb"
            if arb_path.exists():
                translated = json.load(open(arb_path, "r", encoding="utf-8"))
                missing = sum(1 for k in base_keys if not translated.get(k))
                print(f"ARB {lang}: {len(base_keys) - missing}/{len(base_keys)} keys translated")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="InstaLingo Translation Pipeline")
    parser.add_argument("--export", action="store_true", help="Export missing translations")
    parser.add_argument("--out", type=Path, default=Path("translation_export.json"), help="Export output path")
    parser.add_argument("--import", dest="import_", action="store_true", help="Import translations")
    parser.add_argument("--in", dest="in_", type=Path, help="Import input path")
    parser.add_argument("--verify", action="store_true", help="Verify all translations are complete")
    parser.add_argument("--stats", action="store_true", help="Show translation statistics")
    parser.add_argument("--dry-run", action="store_true", help="Dry run import")
    args = parser.parse_args()

    if args.export:
        export = build_export(only_changed=True)
        save_export(export, args.out)
    elif args.import_:
        if not args.in_:
            print("Error: --in is required for --import")
            sys.exit(1)
        count = import_translations(args.in_, dry_run=args.dry_run)
        print(f"Imported {count} translations")
    elif args.verify:
        ok = verify()
        sys.exit(0 if ok else 1)
    elif args.stats:
        stats()
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
