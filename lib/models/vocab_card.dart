/// The atomic unit of the entire InstaLingo v2 experience.
/// Every card a user swipes through is a VocabCard.
class VocabCard {
  final String id;
  final String word;
  final String reading;
  final String meaning;
  final String meaningZh;
  final String pos;
  final String level;
  final String topic;
  final String? imageUrl;
  final String? audioUrl;
  final String? exampleText;
  final String? exampleReading;
  final String? exampleTranslation;
  final String? exampleAudioUrl;
  final String source;

  const VocabCard({
    required this.id,
    required this.word,
    required this.reading,
    required this.meaning,
    required this.meaningZh,
    required this.pos,
    required this.level,
    required this.topic,
    this.imageUrl,
    this.audioUrl,
    this.exampleText,
    this.exampleReading,
    this.exampleTranslation,
    this.exampleAudioUrl,
    required this.source,
  });

  factory VocabCard.fromJson(Map<String, dynamic> json) {
    return VocabCard(
      id: json['id'] as String,
      word: json['word'] as String,
      reading: json['reading'] as String,
      meaning: json['meaning'] as String,
      meaningZh: json['meaning_zh'] as String? ?? '',
      pos: json['pos'] as String,
      level: json['level'] as String,
      topic: json['topic'] as String? ?? 'general',
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      exampleText: json['example_text'] as String?,
      exampleReading: json['example_reading'] as String?,
      exampleTranslation: json['example_translation'] as String?,
      exampleAudioUrl: json['example_audio_url'] as String?,
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'reading': reading,
        'meaning': meaning,
        'meaning_zh': meaningZh,
        'pos': pos,
        'level': level,
        'topic': topic,
        'image_url': imageUrl,
        'audio_url': audioUrl,
        'example_text': exampleText,
        'example_reading': exampleReading,
        'example_translation': exampleTranslation,
        'example_audio_url': exampleAudioUrl,
        'source': source,
      };
}

/// A deck of vocabulary cards, e.g. "JLPT N5 — 800 Words"
class CardDeck {
  final String id;
  final String language;
  final String level;
  final String displayName;
  final String displayNameZh;
  final int totalCards;
  final List<VocabCard> cards;

  const CardDeck({
    required this.id,
    required this.language,
    required this.level,
    required this.displayName,
    required this.displayNameZh,
    required this.totalCards,
    required this.cards,
  });

  factory CardDeck.fromJson(Map<String, dynamic> json) {
    final deckData = json['deck'] as Map<String, dynamic>;
    final cardsData = json['cards'] as List<dynamic>;
    return CardDeck(
      id: deckData['id'] as String,
      language: deckData['language'] as String,
      level: deckData['level'] as String,
      displayName: deckData['display_name'] as String,
      displayNameZh: deckData['display_name_zh'] as String,
      totalCards: deckData['total_cards'] as int,
      cards: cardsData.map((c) => VocabCard.fromJson(c as Map<String, dynamic>)).toList(),
    );
  }
}

/// FSRS scheduling data. One entry per saved (collected) word.
class SRSData {
  final String cardId;
  final String state;
  final int step;
  final double stability;
  final double difficulty;
  final DateTime due;
  final DateTime lastReview;
  final int reviewCount;
  final int lapseCount;

  SRSData({
    required this.cardId,
    this.state = 'learning',
    this.step = 0,
    this.stability = 0,
    this.difficulty = 0,
    DateTime? due,
    DateTime? lastReview,
    this.reviewCount = 0,
    this.lapseCount = 0,
  })  : due = due ?? DateTime.now(),
        lastReview = lastReview ?? DateTime.now();

  factory SRSData.fromJson(Map<String, dynamic> json) => SRSData(
        cardId: json['card_id'] as String,
        state: json['state'] as String? ?? 'learning',
        step: json['step'] as int? ?? 0,
        stability: (json['stability'] as num?)?.toDouble() ?? 0,
        difficulty: (json['difficulty'] as num?)?.toDouble() ?? 0,
        due: json['due'] != null ? DateTime.parse(json['due'] as String) : null,
        lastReview: json['last_review'] != null
            ? DateTime.parse(json['last_review'] as String)
            : null,
        reviewCount: json['review_count'] as int? ?? 0,
        lapseCount: json['lapse_count'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'card_id': cardId,
        'state': state,
        'step': step,
        'stability': stability,
        'difficulty': difficulty,
        'due': due.toIso8601String(),
        'last_review': lastReview.toIso8601String(),
        'review_count': reviewCount,
        'lapse_count': lapseCount,
      };
}
