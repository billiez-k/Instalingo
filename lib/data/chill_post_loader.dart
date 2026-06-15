import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:instalingo/models/chill_post.dart';

/// Loads chill posts and characters from bundled JSON assets.
///
/// Falls back to demo data when JSON files are unavailable.
class ChillPostLoader {
  ChillPostLoader._();

  static const _assetPath = 'instalingo_content/shared';

  /// Load chill posts from assets/shared/posts.json.
  /// Handles both wrapped {"posts": [...]} and plain array [...] formats.
  static Future<List<ChillPost>> loadPosts() async {
    const path = '$_assetPath/posts.json';
    try {
      final jsonString = await rootBundle.loadString(path);
      final decoded = jsonDecode(jsonString);
      List<dynamic> list;
      if (decoded is Map<String, dynamic> && decoded.containsKey('posts')) {
        list = decoded['posts'] as List<dynamic>;
      } else if (decoded is List) {
        list = decoded;
      } else {
        throw const FormatException('Unexpected posts.json format');
      }
      return list
          .map((p) => ChillPost.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _generateDemoPosts();
    }
  }

  /// Load a single chill post by ID. Falls back to demo posts if assets
  /// aren't available.
  static Future<ChillPost?> loadPost(String id) async {
    final posts = await loadPosts();
    return posts.where((p) => p.id == id).firstOrNull;
  }

  /// Load chill characters from assets/shared/characters.json.
  /// Handles both wrapped {"characters": [...]} and plain array [...] formats.
  static Future<List<ChillCharacter>> loadCharacters() async {
    const path = '$_assetPath/characters.json';
    try {
      final jsonString = await rootBundle.loadString(path);
      final decoded = jsonDecode(jsonString);
      List<dynamic> list;
      if (decoded is Map<String, dynamic> && decoded.containsKey('characters')) {
        list = decoded['characters'] as List<dynamic>;
      } else if (decoded is List) {
        list = decoded;
      } else {
        throw const FormatException('Unexpected characters.json format');
      }
      return list
          .map((c) => ChillCharacter.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _generateDemoCharacters();
    }
  }

  static List<ChillPost> _generateDemoPosts() {
    final now = DateTime.now();
    return [
      ChillPost.fromEnglishContent(
        id: 'chill_1',
        authorName: 'Maya',
        authorHandle: '@cafe_maya',
        content:
            'Today I learned a really useful word at the cafe! When a customer asked for something I finally understood without checking my dictionary. Progress feels good.',
        targetWord: '猫',
        targetWordId: 'n5_demo_0',
        tags: ['daily', 'cafe', 'beginner'],
        likes: 42,
        comments: [
          const ChillComment(
            authorName: 'Hiro',
            content: 'That word is super useful! Keep it up.',
          ),
        ],
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      ChillPost.fromEnglishContent(
        id: 'chill_2',
        authorName: 'Kenji',
        authorHandle: '@kenji_study',
        content:
            'Just finished my first week of JLPT N5 prep. The kanji still look like mysterious symbols but I am starting to recognize a few. Small wins!',
        tags: ['JLPT', 'motivation', 'beginner'],
        likes: 28,
        comments: [],
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      ChillPost.fromEnglishContent(
        id: 'chill_3',
        authorName: 'Yuna',
        authorHandle: '@yuna_tokyo',
        content:
            'Went to the convenience store and ordered entirely in Japanese today. The clerk understood me. This is not a drill.',
        targetWord: '水',
        targetWordId: 'n5_demo_4',
        tags: ['irl', 'success', 'speaking'],
        likes: 67,
        comments: [
          const ChillComment(
            authorName: 'Maya',
            content: 'That is amazing! First of many victories.',
          ),
          const ChillComment(
            authorName: 'Takeshi',
            content: 'Which combini? I need to practice there too.',
          ),
        ],
        createdAt: now.subtract(const Duration(hours: 10)),
      ),
      ChillPost.fromEnglishContent(
        id: 'chill_4',
        authorName: 'Takeshi',
        authorHandle: '@takeshi_learns',
        content:
            'Question for the group: how do you remember the difference between onyomi and kunyomi readings? I keep mixing them up and it is slowing me down.',
        tags: ['question', 'kanji', 'tips'],
        likes: 15,
        comments: [
          const ChillComment(
            authorName: 'Kenji',
            content:
                'I use color-coded flashcards. Blue for onyomi, orange for kunyomi.',
          ),
        ],
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      ChillPost.fromEnglishContent(
        id: 'chill_5',
        authorName: 'Hana',
        authorHandle: '@hana_osaka',
        content:
            'Found this fantastic ramen shop near Namba. The owner only speaks Japanese so it was a real test. I ordered correctly and the ramen was incredible. Learning pays off in delicious ways.',
        targetWord: '食べる',
        targetWordId: 'n5_demo_1',
        tags: ['food', 'osaka', 'irl'],
        likes: 89,
        comments: [],
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  static List<ChillCharacter> _generateDemoCharacters() {
    return [
      const ChillCharacter(
        id: 'char_1',
        name: 'Maya',
        handle: '@cafe_maya',
        bio: 'Working at a cafe in Shimokitazawa. Learning Japanese one coffee order at a time.',
        level: 'N4',
        personality: 'warm',
        colorHex: '#EE6C2C',
      ),
      const ChillCharacter(
        id: 'char_2',
        name: 'Kenji',
        handle: '@kenji_study',
        bio: 'Self-studying for JLPT. Sharing the journey with all its ups and downs.',
        level: 'N5',
        personality: 'curious',
        colorHex: '#3E7CB1',
      ),
      const ChillCharacter(
        id: 'char_3',
        name: 'Yuna',
        handle: '@yuna_tokyo',
        bio: 'Living in Tokyo. Documenting my language learning adventures in the city.',
        level: 'N3',
        personality: 'energetic',
        colorHex: '#D04B43',
      ),
      const ChillCharacter(
        id: 'char_4',
        name: 'Takeshi',
        handle: '@takeshi_learns',
        bio: 'Tech worker studying Japanese during lunch breaks. Efficiency is my thing.',
        level: 'N5',
        personality: 'analytical',
        colorHex: '#2D9C5A',
      ),
      const ChillCharacter(
        id: 'char_5',
        name: 'Hana',
        handle: '@hana_osaka',
        bio: 'Food lover in Osaka. Learning Japanese through restaurant conversations.',
        level: 'N4',
        personality: 'friendly',
        colorHex: '#C9A227',
      ),
    ];
  }
}
