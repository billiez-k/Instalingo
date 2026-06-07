import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:instalingo/models/vocab_card.dart';

class CardDataLoader {
  CardDataLoader._();
  static const _assetBase = 'instalingo_content/japanese';

  /// Loads a card deck for the given JLPT level (N5-N1).
  /// Cards are sorted by difficulty (easy→hard) for progressive learning.
  /// Throws if the asset cannot be loaded — no silent fallback to demo data.
  static Future<CardDeck> loadDeck(String level) async {
    final levelLower = level.toLowerCase();
    final path = '$_assetBase/$levelLower/cards.json';
    final jsonString = await rootBundle.loadString(path);
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final deck = CardDeck.fromJson(data);

    // Sort cards by computed difficulty for progressive learning
    final sorted = List<VocabCard>.from(deck.cards)
      ..sort((a, b) => _cardDifficulty(a).compareTo(_cardDifficulty(b)));

    return CardDeck(
      id: deck.id,
      level: deck.level,
      language: deck.language,
      displayName: deck.displayName,
      displayNameZh: deck.displayNameZh,
      totalCards: deck.totalCards,
      cards: sorted,
    );
  }

  /// Computes a difficulty score for progressive card ordering.
  /// Lower = easier. Based on word length, kanji presence, and reading length.
  static double _cardDifficulty(VocabCard card) {
    double score = 0;
    // Base: word character count (longer words are harder)
    score += card.word.length * 2.0;
    // Kanji presence: words with kanji are harder
    final kanjiCount = RegExp(r'[\u4e00-\u9faf\u3400-\u4dbf]').allMatches(card.word).length;
    score += kanjiCount * 8.0;
    // Reading length contributes slightly
    score += card.reading.length * 0.5;
    // Kana-only words (no kanji) are easier — give them a bonus
    if (kanjiCount == 0) score -= 3.0;
    return score;
  }
}