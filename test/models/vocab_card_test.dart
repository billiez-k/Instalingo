import 'package:flutter_test/flutter_test.dart';
import 'package:instalingo/models/vocab_card.dart';

void main() {
  group('VocabCard', () {
    test('fromJson parses new format with meanings map', () {
      final json = {
        'id': 'ja_n5_0001',
        'word': '会う',
        'reading': 'あう',
        'pos': 'verb',
        'level': 'N5',
        'topic': 'general',
        'source': 'test',
        'meanings': {
          'en': 'to meet',
          'zh_TW': '見面',
          'ja': '会うこと',
        },
        'example_translations': {
          'en': 'I meet my friend.',
          'zh_TW': '我跟朋友見面。',
        },
        'example_text': '友達に会う',
        'example_reading': 'ともだちにあう',
      };

      final card = VocabCard.fromJson(json);

      expect(card.id, 'ja_n5_0001');
      expect(card.word, '会う');
      expect(card.reading, 'あう');
      expect(card.pos, 'verb');
      expect(card.level, 'N5');
      expect(card.topic, 'general');
      expect(card.meaning, 'to meet');
      expect(card.meaningZh, '見面');
      expect(card.meaningFor('en'), 'to meet');
      expect(card.meaningFor('zh_TW'), '見面');
      expect(card.meaningFor('ja'), '会うこと');
      expect(card.exampleTranslationFor('en'), 'I meet my friend.');
      expect(card.exampleTranslationFor('zh_TW'), '我跟朋友見面。');
    });

    test('fromJson parses backward-compatible format (meaning/meaning_zh)', () {
      final json = {
        'id': 'ja_n5_0001',
        'word': 'ありがとう',
        'reading': 'ありがとう',
        'pos': 'expression',
        'level': 'N5',
        'source': 'test',
        'meaning': 'thank you',
        'meaning_zh': '謝謝',
        'example_translation': 'Thank you very much!',
      };

      final card = VocabCard.fromJson(json);

      expect(card.meaning, 'thank you');
      expect(card.meaningZh, '謝謝');
      expect(card.meaningFor('en'), 'thank you');
      expect(card.meaningFor('zh_TW'), '謝謝');
      // Languages without data fall back to English
      expect(card.meaningFor('ja'), 'thank you');
      expect(card.meaningFor('ko'), 'thank you');
      expect(card.exampleTranslationFor('en'), 'Thank you very much!');
      expect(card.exampleTranslationFor('ja'), 'Thank you very much!');
    });

    test('meaningFor returns empty string when no data at all', () {
      final card = VocabCard(
        id: 'test',
        word: 'test',
        reading: 'test',
        pos: 'noun',
        level: 'N5',
        topic: 'general',
        source: 'test',
      );

      expect(card.meaningFor('en'), '');
      expect(card.meaningFor('zh_TW'), '');
      expect(card.meaningFor('ja'), '');
      expect(card.exampleTranslationFor('en'), '');
    });

    test('toJson round-trips correctly', () {
      final card = VocabCard(
        id: 'test',
        word: '猫',
        reading: 'ねこ',
        pos: 'noun',
        level: 'N5',
        topic: 'animals',
        source: 'test',
        meanings: const {'en': 'cat', 'zh_TW': '貓'},
        exampleTranslations: const {'en': 'I like cats.'},
      );

      final json = card.toJson();
      expect(json['id'], 'test');
      expect(json['word'], '猫');
      expect(json['meanings'], {'en': 'cat', 'zh_TW': '貓'});
      expect(json['example_translations'], {'en': 'I like cats.'});
    });

    test('defaults for optional fields', () {
      final json = {
        'id': 'minimal',
        'word': '本',
        'reading': 'ほん',
        'pos': 'noun',
        'level': 'N5',
        'source': 'test',
      };

      final card = VocabCard.fromJson(json);

      expect(card.topic, 'general');
      expect(card.imageUrl, isNull);
      expect(card.audioUrl, isNull);
      expect(card.exampleText, isNull);
      expect(card.exampleReading, isNull);
      expect(card.exampleAudioUrl, isNull);
      expect(card.meanings, isEmpty);
    });
  });

  group('CardDeck', () {
    test('fromJson parses deck with cards', () {
      final json = {
        'deck': {
          'id': 'n5',
          'language': 'ja',
          'level': 'N5',
          'display_name': 'JLPT N5 - 710 Words',
          'display_name_zh': 'JLPT N5 - 710字',
          'total_cards': 710,
        },
        'cards': [
          {
            'id': 'ja_n5_0001',
            'word': '会う',
            'reading': 'あう',
            'pos': 'verb',
            'level': 'N5',
            'source': 'test',
            'meaning': 'to meet',
          },
          {
            'id': 'ja_n5_0002',
            'word': '青い',
            'reading': 'あおい',
            'pos': 'adj',
            'level': 'N5',
            'source': 'test',
            'meaning': 'blue',
          },
        ],
      };

      final deck = CardDeck.fromJson(json);

      expect(deck.id, 'n5');
      expect(deck.language, 'ja');
      expect(deck.level, 'N5');
      expect(deck.displayName, 'JLPT N5 - 710 Words');
      expect(deck.displayNameZh, 'JLPT N5 - 710字');
      expect(deck.totalCards, 710);
      expect(deck.cards.length, 2);
      expect(deck.cards[0].word, '会う');
      expect(deck.cards[1].word, '青い');
    });
  });

  group('SRSData', () {
    test('fromJson parses full SRS data', () {
      final json = {
        'card_id': 'ja_n5_0001',
        'state': 'review',
        'step': 3,
        'stability': 2.5,
        'difficulty': 0.3,
        'due': '2026-06-05T00:00:00.000',
        'last_review': '2026-06-04T00:00:00.000',
        'review_count': 5,
        'lapse_count': 1,
      };

      final srs = SRSData.fromJson(json);

      expect(srs.cardId, 'ja_n5_0001');
      expect(srs.state, 'review');
      expect(srs.step, 3);
      expect(srs.stability, 2.5);
      expect(srs.difficulty, 0.3);
      expect(srs.reviewCount, 5);
      expect(srs.lapseCount, 1);
    });

    test('fromJson provides defaults for missing fields', () {
      final json = {
        'card_id': 'minimal',
      };

      final srs = SRSData.fromJson(json);

      expect(srs.state, 'learning');
      expect(srs.step, 0);
      expect(srs.stability, 0);
      expect(srs.difficulty, 0);
      expect(srs.reviewCount, 0);
      expect(srs.lapseCount, 0);
    });

    test('toJson round-trips correctly', () {
      final srs = SRSData(
        cardId: 'test',
        state: 'learning',
        step: 1,
        stability: 1.5,
        difficulty: 0.2,
        reviewCount: 2,
        lapseCount: 0,
      );

      final json = srs.toJson();
      expect(json['card_id'], 'test');
      expect(json['state'], 'learning');
      expect(json['step'], 1);
      expect(json['stability'], 1.5);
      expect(json['review_count'], 2);
    });
  });
}
