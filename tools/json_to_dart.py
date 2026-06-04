#!/usr/bin/env python3
"""Convert golden course JSON to Dart code."""
import json, sys

def dart_str(s):
    return json.dumps(s, ensure_ascii=False)

def lt_to_dart(d):
    parts = []
    for lang in ['en','zh','zh_TW','ko','ja','es','fr','de']:
        parts.append(f"'{lang}': {dart_str(d[lang])}")
    return f'const LocalizedText({{{", ".join(parts)}}})'

def convert(input_json, output_dart_line_prefix=""):
    with open(input_json) as f:
        data = json.load(f)

    lines = []
    def emit(indent, text):
        lines.append("  " * indent + text)

    emit(0, '// Auto-generated from golden en_a1.json')
    emit(0, '// Regenerate: python3 tools/generate_content.py --lang en')
    emit(0, '')
    emit(0, f'static Course get englishA1 => const Course(')
    emit(1, f"id: {dart_str(data['id'])},")
    emit(1, f"title: {lt_to_dart(data['title'])},")
    emit(1, f"subtitle: {lt_to_dart(data['subtitle'])},")
    emit(1, f"description: {lt_to_dart(data['description'])},")
    emit(1, f"level: {dart_str(data['level'])},")
    emit(1, f"language: {dart_str(data['language'])},")
    emit(1, f"totalLessons: {data['totalLessons']},")
    emit(1, f"completedLessons: 0,")
    emit(1, f"sections: const [")

    for sec in data['sections']:
        emit(2, f"Section(")
        emit(3, f"id: {dart_str(sec['id'])},")
        emit(3, f"title: {lt_to_dart(sec['title'])},")
        emit(3, f"order: {sec['order']},")
        emit(3, f"lessons: const [")

        for i, lesson in enumerate(sec['lessons']):
            emit(4, f"Lesson(")
            emit(5, f"id: {dart_str(lesson['id'])},")
            emit(5, f"title: {lt_to_dart(lesson['title'])},")
            emit(5, f"description: {lt_to_dart(lesson['description'])},")
            emit(5, f"order: {lesson['order']},")
            emit(5, f"xpReward: {lesson['xpReward']},")
            emit(5, f"gemsReward: {lesson['gemsReward']},")
            emit(5, f"vocabulary: const {dart_str(lesson['vocabulary'])},")
            emit(5, f"exercises: const [")

            for ex in lesson['exercises']:
                emit(6, f"Exercise(")
                emit(7, f"id: {dart_str(ex['id'])},")
                emit(7, f"type: ExerciseType.{ex['type']},")
                emit(7, f"contentLang: {dart_str(ex.get('contentLang','en'))},")
                emit(7, f"question: {dart_str(ex.get('question',''))},")

                if ex.get('instruction'):
                    # instruction is String?, not LocalizedText
                    if isinstance(ex['instruction'], dict):
                        emit(7, f"instruction: {dart_str(ex['instruction'].get('en', ''))},")
                    else:
                        emit(7, f"instruction: {dart_str(ex['instruction'])},")
                if 'options' in ex and ex['options']:
                    emit(7, f"options: const {dart_str(ex['options'])},")
                if ex.get('correctAnswer'):
                    emit(7, f"correctAnswer: {dart_str(ex['correctAnswer'])},")
                if ex.get('correctAnswerList'):
                    emit(7, f"correctAnswerList: const {dart_str(ex['correctAnswerList'])},")
                if ex.get('explanation') and isinstance(ex['explanation'], dict):
                    emit(7, f"explanation: {lt_to_dart(ex['explanation'])},")
                if ex.get('pairs'):
                    pair_strs = []
                    for p in ex['pairs']:
                        pair_strs.append(f"const WordPair(left: {dart_str(p['left'])}, right: {dart_str(p['right'])})")
                    emit(7, f"pairs: const [{', '.join(pair_strs)}],")
                if ex.get('dialogue'):
                    dial_strs = []
                    for d in ex['dialogue']:
                        is_user = str(d.get('isUser', False)).lower()
                        dial_strs.append(f"const DialogueTurn(speaker: {dart_str(d['speaker'])}, text: {dart_str(d['text'])}, isUser: {is_user})")
                    emit(7, f"dialogue: const [{', '.join(dial_strs)}],")
                if ex.get('grammarRule') and isinstance(ex['grammarRule'], dict):
                    emit(7, f"grammarRule: {lt_to_dart(ex['grammarRule'])},")
                if ex.get('grammarExample') and isinstance(ex['grammarExample'], dict):
                    emit(7, f"grammarExample: {lt_to_dart(ex['grammarExample'])},")
                if ex.get('wordBank'):
                    emit(7, f"wordBank: const {dart_str(ex['wordBank'])},")
                if ex.get('passage'):
                    emit(7, f"passage: {dart_str(ex['passage'])},")
                if ex.get('questions'):
                    emit(7, f"questions: const {dart_str(ex['questions'])},")
                if 'isTrue' in ex and ex['isTrue'] is not None:
                    emit(7, f"isTrue: {str(ex['isTrue']).lower()},")
                if ex.get('writingPrompt') and isinstance(ex['writingPrompt'], dict):
                    emit(7, f"writingPrompt: {lt_to_dart(ex['writingPrompt'])},")
                if ex.get('sampleAnswer') and isinstance(ex['sampleAnswer'], dict):
                    emit(7, f"sampleAnswer: {lt_to_dart(ex['sampleAnswer'])},")
                if ex.get('audioUrl'):
                    emit(7, f"audioUrl: {dart_str(ex['audioUrl'])},")
                if ex.get('imageUrl'):
                    emit(7, f"imageUrl: {dart_str(ex['imageUrl'])},")
                emit(6, f"),")

            emit(5, f"],"),
            is_first = lesson['order'] == 1
            emit(5, f"isCompleted: false,")
            emit(5, f"isLocked: {str(not is_first).lower()},")
            emit(5, f"isCurrent: {str(is_first).lower()},")
            emit(4, f"),")

        emit(3, f"],"),
        emit(2, f"),")

    emit(1, f"],")
    emit(0, f");")

    return "\n".join(lines)


if __name__ == '__main__':
    dart_code = convert('manus_output/golden/en_a1.json')
    with open('manus_output/golden/en_a1_course.dart', 'w') as f:
        f.write(dart_code)
    print(f'Generated {len(dart_code.splitlines())} lines of Dart code')
    print(f'Output: manus_output/golden/en_a1_course.dart')
