import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:instalingo/models/grammar_card.dart';

/// Loads JLPT grammar patterns from bundled JSON assets.
class GrammarLoader {
  GrammarLoader._();

  static const _assetPath = 'instalingo_content/japanese/grammar';

  static List<GrammarCard>? _cache;

  /// Load all grammar cards. Results are cached in-memory.
  static Future<List<GrammarCard>> loadAll() async {
    if (_cache != null) return _cache!;

    try {
      final jsonString = await rootBundle.loadString('$_assetPath/grammar_n5.json');
      final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;
      _cache = data
          .map((e) => GrammarCard.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cache!;
    } catch (_) {
      _cache = [];
      return _cache!;
    }
  }

  /// Load grammar cards for a specific JLPT level.
  static Future<List<GrammarCard>> loadByLevel(String level) async {
    final all = await loadAll();
    return all.where((g) => g.level.toUpperCase() == level.toUpperCase()).toList();
  }

  /// Clear the in-memory cache.
  static void clearCache() {
    _cache = null;
  }
}
