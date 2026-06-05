import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:instalingo/models/vocab_card.dart';

class CardDataLoader {
  CardDataLoader._();
  static const _assetBase = 'instalingo_content/japanese';

  /// Loads a card deck for the given JLPT level (N5-N1).
  /// Throws if the asset cannot be loaded — no silent fallback to demo data.
  static Future<CardDeck> loadDeck(String level) async {
    final levelLower = level.toLowerCase();
    final path = '$_assetBase/$levelLower/cards.json';
    final jsonString = await rootBundle.loadString(path);
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    return CardDeck.fromJson(data);
  }
}