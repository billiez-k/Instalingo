import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:instalingo/models/vocab_card.dart';

class CardDataLoader {
  CardDataLoader._();
  static const _assetBase = 'instalingo_content/japanese';

  /// In-memory cache of parsed decks, keyed by normalized level name.
  /// Avoids redundant rootBundle I/O and JSON decoding — a single deck can
  /// be up to ~1000 cards and is requested by multiple providers.
  static final Map<String, CardDeck> _cache = {};

  /// Valid register tier filter values.
  static const validRegisters = ['all', 'textbook', 'real_life', 'slang', 'vulgar'];

  /// Loads a card deck for the given JLPT level (N5-N1) or special deck (Slang, Vulgar).
  /// Cards are sorted by difficulty (easy→hard) for progressive learning.
  /// Results are cached in-memory; subsequent calls for the same level
  /// return the cached deck instantly.
  /// Pass [registerFilter] to filter cards by register tier (e.g., 'slang', 'vulgar').
  /// Pass 'all' or null for no filtering.
  /// Throws if the asset cannot be loaded — no silent fallback to demo data.
  static Future<CardDeck> loadDeck(String level, {String? registerFilter}) async {
    final levelLower = level.toLowerCase();
    final cacheKey = registerFilter != null && registerFilter != 'all'
        ? '$levelLower:$registerFilter'
        : levelLower;
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    final path = '$_assetBase/$levelLower/cards.json';
    final jsonString = await rootBundle.loadString(path);
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final deck = CardDeck.fromJson(data);

    // Sort cards by computed difficulty for progressive learning
    final allCards = List<VocabCard>.from(deck.cards)
      ..sort((a, b) => _cardDifficulty(a).compareTo(_cardDifficulty(b)));

    // Apply register filter if specified
    final filteredCards = (registerFilter != null && registerFilter != 'all')
        ? allCards.where((c) => c.register == registerFilter).toList()
        : allCards;

    final result = CardDeck(
      id: deck.id,
      level: deck.level,
      language: deck.language,
      displayName: deck.displayName,
      displayNameZh: deck.displayNameZh,
      totalCards: filteredCards.length,
      cards: filteredCards,
    );
    _cache[cacheKey] = result;
    return result;
  }

  /// Clears the in-memory deck cache. Useful for testing or if decks are
  /// hot-reloaded during development.
  static void clearCache() {
    _cache.clear();
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