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
  try {
    return deck.cards.firstWhere((c) => c.id == cardId);
  } catch (_) {
    return null;
  }
});

/// Lookup a card by id across all levels (for chill posts that link to words).
final cardByIdGlobalProvider = FutureProvider.family<VocabCard?, String>((ref, cardId) async {
  // Try the user's current level first
  final user = ref.watch(userProvider);
  final deck = await CardDataLoader.loadDeck(user.currentLevel);
  try {
    return deck.cards.firstWhere((c) => c.id == cardId);
  } catch (_) {
      // silently fall back — card not found in deck
    }

  // Try other levels
  for (final level in ['n5', 'n4', 'n3', 'n2', 'n1']) {
    if (level.toLowerCase() == user.currentLevel.toLowerCase()) continue;
    try {
      final otherDeck = await CardDataLoader.loadDeck(level);
      return otherDeck.cards.firstWhere((c) => c.id == cardId);
    } catch (_) {
      // silently fall back — card not found in deck
    }
  }
  return null;
});
