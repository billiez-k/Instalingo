/// A Japanese grammar pattern card for interleaved learning.
///
/// Grammar cards appear in the swipe feed between vocabulary cards
/// at a ratio of approximately 1 grammar card per 10 vocabulary cards.
class GrammarCard {
  final String id;
  final String pattern;       // e.g., "〜てください"
  final String title;         // e.g., "Please do ~ (request)"
  final String explanation;   // Brief English explanation
  final List<String> examples;      // Japanese example sentences
  final List<String> exampleReadings; // Readings for examples
  final List<String> exampleTranslations; // English translations
  final String level;         // JLPT level (N5, N4, etc.)
  final String category;      // particles, verbs, adjectives, etc.

  const GrammarCard({
    required this.id,
    required this.pattern,
    required this.title,
    required this.explanation,
    required this.examples,
    this.exampleReadings = const [],
    this.exampleTranslations = const [],
    required this.level,
    required this.category,
  });

  factory GrammarCard.fromJson(Map<String, dynamic> json) => GrammarCard(
    id: json['id'] as String,
    pattern: json['pattern'] as String,
    title: json['title'] as String,
    explanation: json['explanation'] as String,
    examples: (json['examples'] as List<dynamic>).cast<String>(),
    exampleReadings: (json['example_readings'] as List<dynamic>?)
        ?.cast<String>() ?? [],
    exampleTranslations: (json['example_translations'] as List<dynamic>?)
        ?.cast<String>() ?? [],
    level: json['level'] as String,
    category: json['category'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'pattern': pattern,
    'title': title,
    'explanation': explanation,
    'examples': examples,
    'example_readings': exampleReadings,
    'example_translations': exampleTranslations,
    'level': level,
    'category': category,
  };
}
