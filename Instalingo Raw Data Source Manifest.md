# Instalingo Raw Data Source Manifest

This package contains **raw acquisition outputs only**. It does not contain generated exercises, generated lesson JSON, or AI-authored practice content. Sentence data was extracted from official Tatoeba exports, vocabulary data was normalized from public word-list sources, and grammar data was compiled as source-linked beginner grammar-point records from web pages and public syllabi.

## Output Summary

| Language | Vocabulary Rows | Sentence Rows | Grammar Points |
|---|---:|---:|---:|
| Korean (`ko`) | 220 | 300 | 16 |
| Japanese (`ja`) | 220 | 300 | 20 |
| French (`fr`) | 201 | 300 | 22 |
| Spanish (`es`) | 220 | 300 | 22 |
| Chinese (`zh`) | 220 | 300 | 22 |
| German (`de`) | 203 | 300 | 20 |

## Sentence Sources

All sentence CSV files use bilingual target-language to English sentence pairs extracted from the official Tatoeba exports. The downloaded source files were the official `sentences.csv` and `links.csv` exports from [Tatoeba Downloads](https://downloads.tatoeba.org/exports/). Rows were filtered for short beginner-appropriate sentence lengths and aligned to English through Tatoeba sentence links.

| Files | Source |
|---|---|
| `ko_sentences.csv`, `ja_sentences.csv`, `fr_sentences.csv`, `es_sentences.csv`, `zh_sentences.csv`, `de_sentences.csv` | [Tatoeba sentence and links exports](https://downloads.tatoeba.org/exports/) |

## Vocabulary Sources

Each vocabulary CSV contains normalized raw vocabulary records with source URLs preserved in the `source_url` column. The target row count was at least 200 rows per language.

| Language | Primary Source(s) |
|---|---|
| Korean | [Learning Korean TOPIK I 1671-word PDF](https://learning-korean.com/DL/TOPIK-I-1671.pdf) and related Learning Korean beginner vocabulary pages |
| Japanese | [Open Anki JLPT decks, N5 CSV](https://github.com/jamsinclair/open-anki-jlpt-decks/blob/main/src/n5.csv) |
| Chinese | [plaktos/hsk_csv](https://github.com/plaktos/hsk_csv) |
| French | [CodingFriends basic-vocabulary-word-lists](https://github.com/CodingFriends/basic-vocabulary-word-lists), supplemented from the extracted public beginner vocabulary source pages where needed |
| Spanish | [CodingFriends basic-vocabulary-word-lists](https://github.com/CodingFriends/basic-vocabulary-word-lists), supplemented from a public beginner Spanish vocabulary article where needed |
| German | [CodingFriends basic-vocabulary-word-lists](https://github.com/CodingFriends/basic-vocabulary-word-lists), supplemented from extracted public beginner vocabulary source pages where needed |

## Grammar Sources

Grammar JSON files are source-linked raw grammar point manifests. The `source_excerpt` and `source_url` fields identify the page or syllabus list from which each point was derived.

| Language | Grammar Source(s) |
|---|---|
| Chinese | [AllSet Learning Chinese Grammar Wiki: A1 grammar points](https://resources.allsetlearning.com/chinese/grammar/A1_grammar_points) |
| Japanese | [Tae Kim / Guide to Japanese: Basic Grammar](https://guidetojapanese.org/learn/category/grammar-guide/basic-grammar/), [JLPT Sensei N5 Grammar List](https://jlptsensei.com/jlpt-n5-grammar-list/), [JapaneseTest4You JLPT N5 Grammar List](https://japanesetest4you.com/jlpt-n5-grammar-list/) |
| Korean | [90 Day Korean: Korean Grammar](https://www.90daykorean.com/korean-grammar/) |
| French | [Lawless French A1 Grammar](https://www.lawlessfrench.com/faq/lessons-by-level/a1-grammar/) |
| Spanish | [Kwiziq Spanish CEFR A1 Grammar](https://spanish.kwiziq.com/revision/grammar/by-cefr-level/cefr-a1) |
| German | [StudyGerman A1 Grammar](https://studygerman.io/grammar/a1), [German Course Vienna A1 grammar basics](https://www.german-course-vienna.com/en/which_grammar_do_you_learn_in_the_a1_german_course,3837,16.html), [Olesen Tuition Goethe A1 Grammar Guide](https://www.olesentuition.co.uk/single-post/german-grammar-guide-for-the-goethe-a1-exam) |

## Validation

The package includes `validation_report.json`. Validation checks confirmed that all expected files exist, CSV schemas match the raw acquisition format, every vocabulary file has at least 200 rows, every sentence file has 300 rows, every grammar file has at least 15 grammar points, and source URLs are present for source-tracked records.
