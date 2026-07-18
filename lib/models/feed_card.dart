import 'package:instalingo/models/vocab_card.dart';
import 'package:instalingo/models/grammar_card.dart';

/// A unified card type for the swipe feed.
/// Cards can be either vocabulary or grammar, interleaved.
enum FeedCardType { vocab, grammar }

class FeedCard {
  final FeedCardType type;
  final VocabCard? vocab;
  final GrammarCard? grammar;

  const FeedCard.vocab(this.vocab)
      : type = FeedCardType.vocab,
        grammar = null;

  const FeedCard.grammar(this.grammar)
      : type = FeedCardType.grammar,
        vocab = null;

  String get id => vocab?.id ?? grammar?.id ?? '';
  String get word => vocab?.word ?? grammar?.pattern ?? '';
  String get reading => vocab?.reading ?? '';
  bool get isVocab => type == FeedCardType.vocab;
  bool get isGrammar => type == FeedCardType.grammar;
}
