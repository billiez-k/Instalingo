import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:instalingo/models/vocab_card.dart';

/// Loads vocabulary card decks from bundled JSON assets.
///
/// Falls back to auto-generated demo cards when JSON files are unavailable.
class CardDataLoader {
  CardDataLoader._();

  static const _assetBase = 'instalingo_content/japanese';

  /// Load a deck for the given [level] (e.g. 'n5', 'n4', 'n3', 'n2', 'n1').
  static Future<CardDeck> loadDeck(String level) async {
    final levelLower = level.toLowerCase();
    final path = '$_assetBase/$levelLower/cards.json';

    try {
      final jsonString = await rootBundle.loadString(path);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return CardDeck.fromJson(data);
    } catch (_) {
      return _generateDemoDeck(levelLower);
    }
  }

  /// Generate 10 sample demo cards for the given level.
  static CardDeck _generateDemoDeck(String level) {
    final levelUpper = level.toUpperCase();
    final cards = List.generate(10, (i) {
      final wordData = _demoWords[(i) % _demoWords.length];
      return VocabCard(
        id: '${level}_demo_$i',
        word: '${wordData.word}$i',
        reading: '${wordData.reading}$i',
        meaning: '${wordData.meaning} ($i)',
        meaningZh: '${wordData.meaningZh} ($i)',
        pos: wordData.pos,
        level: levelUpper,
        topic: wordData.topic,
        exampleText: wordData.exampleText,
        exampleReading: wordData.exampleReading,
        exampleTranslation: wordData.exampleTranslation,
        source: 'demo',
      );
    });

    return CardDeck(
      id: '${level}_demo',
      language: 'ja',
      level: levelUpper,
      displayName: 'JLPT $levelUpper',
      displayNameZh: 'JLPT $levelUpper',
      totalCards: cards.length,
      cards: cards,
    );
  }
}

class _DemoWord {
  final String word;
  final String reading;
  final String meaning;
  final String meaningZh;
  final String pos;
  final String topic;
  final String exampleText;
  final String exampleReading;
  final String exampleTranslation;
  const _DemoWord({
    required this.word,
    required this.reading,
    required this.meaning,
    required this.meaningZh,
    required this.pos,
    required this.topic,
    required this.exampleText,
    required this.exampleReading,
    required this.exampleTranslation,
  });
}

const _demoWords = [
  _DemoWord(
    word: '猫',
    reading: 'ねこ',
    meaning: 'cat',
    meaningZh: '貓',
    pos: 'noun',
    topic: 'animals',
    exampleText: '猫が好きです。',
    exampleReading: 'ねこがすきです。',
    exampleTranslation: 'I like cats.',
  ),
  _DemoWord(
    word: '食べる',
    reading: 'たべる',
    meaning: 'to eat',
    meaningZh: '吃',
    pos: 'verb',
    topic: 'food',
    exampleText: '朝ごはんを食べる。',
    exampleReading: 'あさごはんをたべる。',
    exampleTranslation: 'I eat breakfast.',
  ),
  _DemoWord(
    word: '学校',
    reading: 'がっこう',
    meaning: 'school',
    meaningZh: '學校',
    pos: 'noun',
    topic: 'education',
    exampleText: '学校へ行きます。',
    exampleReading: 'がっこうへいきます。',
    exampleTranslation: 'I go to school.',
  ),
  _DemoWord(
    word: '大きい',
    reading: 'おおきい',
    meaning: 'big',
    meaningZh: '大的',
    pos: 'adj',
    topic: 'descriptions',
    exampleText: '大きい犬です。',
    exampleReading: 'おおきいいぬです。',
    exampleTranslation: 'It is a big dog.',
  ),
  _DemoWord(
    word: '水',
    reading: 'みず',
    meaning: 'water',
    meaningZh: '水',
    pos: 'noun',
    topic: 'nature',
    exampleText: '水をください。',
    exampleReading: 'みずをください。',
    exampleTranslation: 'Water, please.',
  ),
  _DemoWord(
    word: '行く',
    reading: 'いく',
    meaning: 'to go',
    meaningZh: '去',
    pos: 'verb',
    topic: 'travel',
    exampleText: '東京に行く。',
    exampleReading: 'とうきょうにいく。',
    exampleTranslation: 'I go to Tokyo.',
  ),
  _DemoWord(
    word: '本',
    reading: 'ほん',
    meaning: 'book',
    meaningZh: '書',
    pos: 'noun',
    topic: 'education',
    exampleText: '本を読む。',
    exampleReading: 'ほんをよむ。',
    exampleTranslation: 'I read a book.',
  ),
  _DemoWord(
    word: '話す',
    reading: 'はなす',
    meaning: 'to speak',
    meaningZh: '說',
    pos: 'verb',
    topic: 'communication',
    exampleText: '日本語を話す。',
    exampleReading: 'にほんごをはなす。',
    exampleTranslation: 'I speak Japanese.',
  ),
  _DemoWord(
    word: '天気',
    reading: 'てんき',
    meaning: 'weather',
    meaningZh: '天氣',
    pos: 'noun',
    topic: 'nature',
    exampleText: '今日はいい天気ですね。',
    exampleReading: 'きょうはいいてんきですね。',
    exampleTranslation: 'The weather is nice today.',
  ),
  _DemoWord(
    word: '新しい',
    reading: 'あたらしい',
    meaning: 'new',
    meaningZh: '新的',
    pos: 'adj',
    topic: 'descriptions',
    exampleText: '新しい車です。',
    exampleReading: 'あたらしいくるまです。',
    exampleTranslation: 'It is a new car.',
  ),
];
