import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/data/demo_data.dart';
import 'package:instalingo/models/post.dart';
import 'package:instalingo/providers/user_provider.dart';

final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>((ref) {
  return PostsNotifier(ref);
});

class PostsNotifier extends StateNotifier<List<Post>> {
  final Ref _ref;

  PostsNotifier(this._ref) : super([]) {
    _init();
  }

  void _init() {
    _load();
    // Auto-react to learning-language changes so Chill Corner content
    // always matches the user's target language.
    _ref.listen(
      userProvider.select((u) => u.learningLanguage),
      (prevLang, nextLang) {
        if (prevLang != nextLang) {
          _load();
        }
      },
    );
    // Auto-react to learned-words changes so newly completed lessons
    // unlock matching Chill Corner posts immediately.
    _ref.listen(
      userProvider.select((u) => u.learnedWords),
      (prevWords, nextWords) {
        if (prevWords != nextWords) {
          _load();
        }
      },
    );
  }

  void _load() {
    final user = _ref.read(userProvider);
    final allPosts = DemoData.postsForLanguage(user.learningLanguage);
    state = _filterPosts(allPosts, user.learnedWords);
  }

  /// Returns posts the user is ready to see.
  /// A post is visible if:
  ///   - It has no prerequisites, OR
  ///   - All its [requiredLessonIds] are in the user's completed lessons, OR
  ///   - All its [requiredWords] are in [learnedWords].
  List<Post> _filterPosts(List<Post> posts, Set<String> learnedWords) {
    return posts.where((post) {
      if (post.requiredWords.isEmpty && post.requiredLessonIds.isEmpty) {
        return true;
      }
      final knowsWords = post.requiredWords.every(learnedWords.contains);
      return knowsWords;
    }).toList();
  }

  void toggleLike(String postId) {
    state = state.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          isLiked: !post.isLiked,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        );
      }
      return post;
    }).toList();
  }

  void toggleBookmark(String postId) {
    state = state.map((post) {
      if (post.id == postId) {
        return post.copyWith(isBookmarked: !post.isBookmarked);
      }
      return post;
    }).toList();
  }

  void addComment(String postId, String content) {
    state = state.map((post) {
      if (post.id == postId) {
        final newComment = PostComment(
          id: 'c_${DateTime.now().millisecondsSinceEpoch}',
          authorName: 'You',
          content: content,
          createdAt: DateTime.now(),
        );
        return post.copyWith(
          comments: [...post.comments, newComment],
        );
      }
      return post;
    }).toList();
  }

  Post? getPostById(String id) {
    try {
      return state.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
