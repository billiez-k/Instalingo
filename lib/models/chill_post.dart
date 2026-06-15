/// A social-media-style post for the Chill Corner feed.
/// Each post is authored by a fictional AI character studying Japanese.
class ChillPost {
  final String id;
  final String authorName;
  final String authorHandle;
  final String? authorAvatarUrl;
  final String? imageUrl;
  final Map<String, String> _content;
  final String? targetWord;
  final String? targetWordId;
  final List<String> tags;
  final int likes;
  final List<ChillComment> comments;
  final DateTime createdAt;

  const ChillPost({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    this.authorAvatarUrl,
    this.imageUrl,
    required Map<String, String> content,
    this.targetWord,
    this.targetWordId,
    this.tags = const [],
    this.likes = 0,
    this.comments = const [],
    required this.createdAt,
  }) : _content = content;

  /// Returns the post content for [localeCode] (e.g. 'en', 'zh_TW').
  /// Falls back to English if the requested locale is unavailable.
  String contentFor(String localeCode) {
    return _content[localeCode] ?? _content['en'] ?? '';
  }

  /// Legacy accessor — returns English content.
  String get content => contentFor('en');

  /// Convenience constructor for English-only demo / fallback posts.
  factory ChillPost.fromEnglishContent({
    required String id,
    required String authorName,
    required String authorHandle,
    String? authorAvatarUrl,
    String? imageUrl,
    required String content,
    String? targetWord,
    String? targetWordId,
    List<String> tags = const [],
    int likes = 0,
    List<ChillComment> comments = const [],
    required DateTime createdAt,
  }) {
    return ChillPost(
      id: id,
      authorName: authorName,
      authorHandle: authorHandle,
      authorAvatarUrl: authorAvatarUrl,
      imageUrl: imageUrl,
      content: {'en': content},
      targetWord: targetWord,
      targetWordId: targetWordId,
      tags: tags,
      likes: likes,
      comments: comments,
      createdAt: createdAt,
    );
  }

  factory ChillPost.fromJson(Map<String, dynamic> json) {
    final content = <String, String>{};
    // Read multi-locale fields: content_en, content_zh, etc.
    if (json['content_en'] is String && (json['content_en'] as String).isNotEmpty) {
      content['en'] = json['content_en'] as String;
    }
    if (json['content_zh'] is String && (json['content_zh'] as String).isNotEmpty) {
      content['zh_TW'] = json['content_zh'] as String;
    }
    // Fallback: old single 'content' field (English)
    if (!content.containsKey('en') && json['content'] is String) {
      content['en'] = json['content'] as String;
    }

    return ChillPost(
      id: json['id'] as String,
      authorName: json['author_name'] as String,
      authorHandle: json['author_handle'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      imageUrl: json['image_url'] as String?,
      content: content,
      targetWord: json['target_word'] as String?,
      targetWordId: json['target_word_id'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      likes: json['likes'] as int? ?? 0,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((c) => ChillComment.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'author_name': authorName,
        'author_handle': authorHandle,
        'author_avatar_url': authorAvatarUrl,
        'image_url': imageUrl,
        'content_en': _content['en'],
        if (_content.containsKey('zh_TW')) 'content_zh': _content['zh_TW'],
        'content': _content['en'], // backward compat
        'target_word': targetWord,
        'target_word_id': targetWordId,
        'tags': tags,
        'likes': likes,
        'comments': comments.map((c) => c.toJson()).toList(),
        'created_at': createdAt.toIso8601String(),
      };
}

class ChillComment {
  final String authorName;
  final String content;

  const ChillComment({
    required this.authorName,
    required this.content,
  });

  factory ChillComment.fromJson(Map<String, dynamic> json) => ChillComment(
        authorName: json['author_name'] as String,
        content: json['content'] as String,
      );

  Map<String, dynamic> toJson() => {
        'author_name': authorName,
        'content': content,
      };
}

/// A fictional AI character in the Chill Corner community.
class ChillCharacter {
  final String id;
  final String name;
  final String handle;
  final String bio;
  final String? avatarUrl;
  final String level;
  final String personality;
  final String colorHex;

  const ChillCharacter({
    required this.id,
    required this.name,
    required this.handle,
    required this.bio,
    this.avatarUrl,
    required this.level,
    required this.personality,
    required this.colorHex,
  });

  factory ChillCharacter.fromJson(Map<String, dynamic> json) => ChillCharacter(
        id: json['id'] as String,
        name: json['name'] as String,
        handle: json['handle'] as String,
        bio: json['bio'] as String,
        avatarUrl: json['avatar_url'] as String?,
        level: json['level'] as String,
        personality: json['personality'] as String,
        colorHex: json['color_hex'] as String,
      );
}
