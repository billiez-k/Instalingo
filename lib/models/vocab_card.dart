/// The atomic unit of the entire InstaLingo v2 experience.
/// Every card a user swipes through is a VocabCard.
class VocabCard {
  final String id;
  final String word;
  final String reading;
  final String pos;
  final String level;
  final String topic;
  final String? imageUrl;
  final String? audioUrl;
  final String? exampleText;
  final String? exampleReading;
  final String? exampleAudioUrl;
  final String source;

  /// Register tier: textbook, real_life, slang, vulgar.
  /// Used for content filtering and tier-based gating.
  final String register;

  /// Localized meanings keyed by locale code (en, zh_TW, zh_CN, ja, ko, ms, ar).
  final Map<String, String> meanings;

  /// Localized example translations keyed by locale code.
  final Map<String, String> exampleTranslations;

  const VocabCard({
    required this.id,
    required this.word,
    required this.reading,
    required this.pos,
    required this.level,
    required this.topic,
    this.imageUrl,
    this.audioUrl,
    this.exampleText,
    this.exampleReading,
    this.exampleAudioUrl,
    required this.source,
    this.register = 'textbook',
    this.meanings = const {},
    this.exampleTranslations = const {},
  });

  /// Backward-compatible getters.
  String get meaning => meanings['en'] ?? '';
  String get meaningZh => meanings['zh_TW'] ?? '';

  /// Look up meaning for a locale code. Falls back to English.
  String meaningFor(String localeCode) =>
      meanings[localeCode] ?? meanings['en'] ?? '';

  /// Look up example translation for a locale code. Falls back to English.
  String exampleTranslationFor(String localeCode) =>
      exampleTranslations[localeCode] ?? exampleTranslations['en'] ?? '';

  factory VocabCard.fromJson(Map<String, dynamic> json) {
    // Backward-compatible: old format with meaning/meaning_zh
    Map<String, String> meanings = {};
    if (json['meanings'] is Map) {
      meanings = Map<String, String>.from(
        (json['meanings'] as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
      );
    } else {
      if (json['meaning'] != null) meanings['en'] = json['meaning'].toString();
      if (json['meaning_zh'] != null) meanings['zh_TW'] = json['meaning_zh'].toString();
    }

    Map<String, String> examples = {};
    if (json['example_translations'] is Map) {
      examples = Map<String, String>.from(
        (json['example_translations'] as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
      );
    } else if (json['example_translation'] != null) {
      examples['en'] = json['example_translation'].toString();
    }

    return VocabCard(
      id: json['id'] as String,
      word: json['word'] as String,
      reading: json['reading'] as String,
      pos: json['pos'] as String,
      level: json['level'] as String,
      topic: json['topic'] as String? ?? 'general',
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      exampleText: json['example_text'] as String?,
      exampleReading: json['example_reading'] as String?,
      exampleAudioUrl: json['example_audio_url'] as String?,
      source: json['source'] as String,
      register: json['register'] as String? ?? 'textbook',
      meanings: meanings,
      exampleTranslations: examples,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'reading': reading,
        'meanings': meanings,
        'pos': pos,
        'level': level,
        'topic': topic,
        'image_url': imageUrl,
        'audio_url': audioUrl,
        'example_text': exampleText,
        'example_reading': exampleReading,
        'example_translations': exampleTranslations,
        'example_audio_url': exampleAudioUrl,
        'source': source,
        'register': register,
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

  /// Computed mastery level for UI display.
  /// 0 = new (grey), 1 = learning (amber), 2 = mastered (mint)
  int get masteryLevel {
    switch (state) {
      case 'new':
        return 0;
      case 'learning':
        return 0;
      case 'relearning':
        return 1;
      case 'review':
        return stability >= 5.0 ? 2 : 1;
      default:
        return 0;
    }
  }

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
