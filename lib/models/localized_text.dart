/// Busuu-style localized text.
///
/// Course metadata (titles, section names, lesson names, descriptions) must be
/// shown in the user's native/interface language, never hardcoded in English.
/// Learning content (vocabulary, sentences) stays in the target language.
class LocalizedText {
  final Map<String, String> _values;

  const LocalizedText(this._values);

  /// Get text in the specified language, falling back to base language (e.g. zh for zh_TW),
  /// then English, then first available.
  String resolve(String languageCode) {
    if (_values.containsKey(languageCode)) return _values[languageCode]!;
    // For zh_TW, do NOT fall back to zh (Simplified) — return zh_TW only if available,
    // otherwise fall back to English rather than mixing scripts.
    if (_values.containsKey('en')) return _values['en']!;
    return _values.values.first;
  }

  String get en => _values['en'] ?? _values.values.first;
}
