import 'package:flutter_test/flutter_test.dart';
import 'package:instalingo/models/chill_post.dart';

void main() {
  group('ChillPost', () {
    test('fromJson parses full post with comments', () {
      final json = {
        'id': 'post_001',
        'author_name': 'Tanaka',
        'author_handle': '@tanaka_n5',
        'author_avatar_url': 'https://example.com/avatar.png',
        'content': '今日は新しい単語を習いました！',
        'target_word': '習う',
        'target_word_id': 'ja_n5_0042',
        'tags': ['n5', 'verb'],
        'likes': 42,
        'comments': [
          {
            'author_name': 'Yuki',
            'content': 'すごい！',
          },
        ],
        'created_at': '2026-06-04T10:00:00.000',
      };

      final post = ChillPost.fromJson(json);

      expect(post.id, 'post_001');
      expect(post.authorName, 'Tanaka');
      expect(post.authorHandle, '@tanaka_n5');
      expect(post.authorAvatarUrl, 'https://example.com/avatar.png');
      expect(post.content, '今日は新しい単語を習いました！');
      expect(post.targetWord, '習う');
      expect(post.targetWordId, 'ja_n5_0042');
      expect(post.tags, ['n5', 'verb']);
      expect(post.likes, 42);
      expect(post.comments.length, 1);
      expect(post.comments[0].authorName, 'Yuki');
      expect(post.comments[0].content, 'すごい！');
      expect(post.createdAt, DateTime(2026, 6, 4, 10));
    });

    test('fromJson provides defaults for optional fields', () {
      final json = {
        'id': 'post_min',
        'author_name': 'Minimal',
        'author_handle': '@min',
        'content': 'Hello',
        'created_at': '2026-01-01T00:00:00.000',
      };

      final post = ChillPost.fromJson(json);

      expect(post.authorAvatarUrl, isNull);
      expect(post.targetWord, isNull);
      expect(post.targetWordId, isNull);
      expect(post.tags, isEmpty);
      expect(post.likes, 0);
      expect(post.comments, isEmpty);
    });

    test('toJson round-trips correctly', () {
      final post = ChillPost(
        id: 'test',
        authorName: 'Test',
        authorHandle: '@test',
        content: 'Test content',
        targetWord: 'テスト',
        targetWordId: 'ja_0001',
        tags: const ['test'],
        likes: 5,
        comments: const [
          ChillComment(authorName: 'Commenter', content: 'Nice!'),
        ],
        createdAt: DateTime(2026, 1, 1),
      );

      final json = post.toJson();

      expect(json['id'], 'test');
      expect(json['author_name'], 'Test');
      expect(json['target_word'], 'テスト');
      expect(json['likes'], 5);
      expect((json['comments'] as List).length, 1);
    });
  });

  group('ChillComment', () {
    test('fromJson parses comment', () {
      final json = {
        'author_name': 'Commenter',
        'content': 'Great post!',
      };

      final comment = ChillComment.fromJson(json);

      expect(comment.authorName, 'Commenter');
      expect(comment.content, 'Great post!');
    });

    test('toJson round-trips', () {
      final comment = const ChillComment(
        authorName: 'Test',
        content: 'Hello',
      );

      final json = comment.toJson();
      expect(json['author_name'], 'Test');
      expect(json['content'], 'Hello');
    });
  });

  group('ChillCharacter', () {
    test('fromJson parses character', () {
      final json = {
        'id': 'char_001',
        'name': 'Tanaka',
        'handle': '@tanaka',
        'bio': 'Learning Japanese!',
        'avatar_url': 'https://example.com/avatar.png',
        'level': 'N5',
        'personality': 'Cheerful',
        'color_hex': '#FF5733',
      };

      final character = ChillCharacter.fromJson(json);

      expect(character.id, 'char_001');
      expect(character.name, 'Tanaka');
      expect(character.handle, '@tanaka');
      expect(character.bio, 'Learning Japanese!');
      expect(character.avatarUrl, 'https://example.com/avatar.png');
      expect(character.level, 'N5');
      expect(character.personality, 'Cheerful');
      expect(character.colorHex, '#FF5733');
    });

    test('fromJson handles null avatar', () {
      final json = {
        'id': 'char_002',
        'name': 'NoAvatar',
        'handle': '@noav',
        'bio': 'No avatar',
        'level': 'N4',
        'personality': 'Quiet',
        'color_hex': '#000000',
      };

      final character = ChillCharacter.fromJson(json);

      expect(character.avatarUrl, isNull);
    });
  });
}
