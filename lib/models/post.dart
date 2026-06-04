import 'package:instalingo/models/localized_text.dart';

class Post {
  final String id;
  final String authorName;
  final String? authorHandle;
  final String? authorAvatarUrl;
  final String? imageUrl;
  /// Post body text — must be localized (NOT hardcoded English).
  /// Key = native language code (e.g. 'zh', 'ko', 'ja').
  final LocalizedText content;
  /// English fallback caption (used if captionLocalized is null).
  final String? caption;
  /// Native-language translations of the post caption.
  /// Key = native language code (e.g. 'zh', 'ko').
  final LocalizedText? captionLocalized;
  final String? targetWord;
  /// Translation of [targetWord] in the user's native language.
  /// Must NOT be hardcoded English — every supported native language
  /// should have an entry so Chinese users see Chinese, etc.
  final LocalizedText? wordTranslation;
  /// Explanation of [targetWord] in the user's native language.
  final LocalizedText? wordExplanation;
  final String? wordPhonetic;
  /// Example sentence in the target language ONLY (no translation).
  final String? wordExample;
  /// Translation of [wordExample] in the user's native language.
  final LocalizedText? wordExampleTranslation;
  final List<ExampleSentence> exampleSentences;
  final DateTime createdAt;
  final List<PostComment> comments;
  final int likes;
  final bool isLiked;
  final bool isBookmarked;
  final List<String> tags;
  final String? location;
  final String? characterType;
  final String? characterBio;
  /// Which lesson IDs the user must complete before seeing this post.
  /// Empty = no prerequisites (show immediately).
  final List<String> requiredLessonIds;
  /// Which vocabulary words the user must know before seeing this post.
  /// Empty = no prerequisite words.
  final List<String> requiredWords;

  const Post({
    required this.id,
    required this.authorName,
    this.authorHandle,
    this.authorAvatarUrl,
    this.imageUrl,
    required this.content,
    this.caption,
    this.captionLocalized,
    this.targetWord,
    this.wordTranslation,
    this.wordExplanation,
    this.wordPhonetic,
    this.wordExample,
    this.wordExampleTranslation,
    this.exampleSentences = const [],
    required this.createdAt,
    this.comments = const [],
    this.likes = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    this.tags = const [],
    this.location,
    this.characterType,
    this.characterBio,
    this.requiredLessonIds = const [],
    this.requiredWords = const [],
  });

  Post copyWith({
    bool? isLiked,
    bool? isBookmarked,
    int? likes,
    List<PostComment>? comments,
  }) =>
      Post(
        id: id,
        authorName: authorName,
        authorHandle: authorHandle,
        authorAvatarUrl: authorAvatarUrl,
        imageUrl: imageUrl,
        content: content,
        caption: caption,
        captionLocalized: captionLocalized,
        targetWord: targetWord,
        wordTranslation: wordTranslation,
        wordExplanation: wordExplanation,
        wordPhonetic: wordPhonetic,
        wordExample: wordExample,
        wordExampleTranslation: wordExampleTranslation,
        exampleSentences: exampleSentences,
        createdAt: createdAt,
        comments: comments ?? this.comments,
        likes: likes ?? this.likes,
        isLiked: isLiked ?? this.isLiked,
        isBookmarked: isBookmarked ?? this.isBookmarked,
        tags: tags,
        location: location,
        characterType: characterType,
        characterBio: characterBio,
        requiredLessonIds: requiredLessonIds,
        requiredWords: requiredWords,
      );
}

class ExampleSentence {
  /// The example sentence in the target language.
  final String sentence;
  /// Translation of [sentence] in the user's native language.
  /// Must provide entries for every supported native language.
  final LocalizedText translation;
  final String? context;

  const ExampleSentence({
    required this.sentence,
    required this.translation,
    this.context,
  });
}

class PostComment {
  final String id;
  final String authorName;
  final String? authorAvatarUrl;
  final String? avatarColor;
  final String content;
  final DateTime createdAt;
  final int likes;
  final bool isLiked;
  final bool isAiReply;
  final List<PostComment>? replies;

  const PostComment({
    required this.id,
    required this.authorName,
    this.authorAvatarUrl,
    this.avatarColor,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
    this.isAiReply = false,
    this.replies,
  });
}
