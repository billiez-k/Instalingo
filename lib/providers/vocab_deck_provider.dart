import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/data/card_data_loader.dart';
import 'package:instalingo/models/vocab_card.dart';
import 'package:instalingo/providers/user_provider.dart';

/// Provides vocab card decks loaded from bundled JSON assets.
final vocabDeckProvider = FutureProvider.family<CardDeck, String>((ref, level) {
  return CardDataLoader.loadDeck(level);
});

/// Returns all available cards for the user's current level.
final currentDeckProvider = FutureProvider<CardDeck>((ref) {
  final user = ref.watch(userProvider);
  return CardDataLoader.loadDeck(user.currentLevel);
});

/// Lookup a specific card by id from the current deck.
final cardByIdProvider = FutureProvider.family<VocabCard?, String>((ref, cardId) async {
  final user = ref.watch(userProvider);
  final deck = await CardDataLoader.loadDeck(user.currentLevel);
  final i = deck.cards.indexWhere((c) => c.id == cardId);
  return i >= 0 ? deck.cards[i] : null;
});

/// Lookup a card by id across all levels (for chill posts that link to words).
final cardByIdGlobalProvider = FutureProvider.family<VocabCard?, String>((ref, cardId) async {
  // Try the user's current level first
  final user = ref.watch(userProvider);
  final deck = await CardDataLoader.loadDeck(user.currentLevel);
  final i = deck.cards.indexWhere((c) => c.id == cardId);
  if (i >= 0) return deck.cards[i];

  // Try other levels
  for (final level in ['n5', 'n4', 'n3', 'n2', 'n1']) {
    if (level.toLowerCase() == user.currentLevel.toLowerCase()) continue;
    try {
      final otherDeck = await CardDataLoader.loadDeck(level);
      final j = otherDeck.cards.indexWhere((c) => c.id == cardId);
      if (j >= 0) return otherDeck.cards[j];
    } catch (_) {
      // CardDataLoader may throw if deck JSON is missing — skip this level
    }
  }
  return null;
});
