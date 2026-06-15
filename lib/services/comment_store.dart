import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/models/chill_post.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists user comments per post to SharedPreferences.
final commentStoreProvider = StateNotifierProvider<CommentStoreNotifier, Map<String, List<ChillComment>>>((ref) {
  return CommentStoreNotifier(ref);
});

class CommentStoreNotifier extends StateNotifier<Map<String, List<ChillComment>>> {
  final Ref _ref;
  CommentStoreNotifier(this._ref) : super({}) { _load(); }

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    final raw = prefs.getString('user_comments');
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        state = decoded.map((k, v) => MapEntry(
              k,
              (v as List).map((c) => ChillComment.fromJson(c as Map<String, dynamic>)).toList(),
            ));
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    final encoded = state.map((k, v) => MapEntry(k, v.map((c) => c.toJson()).toList()));
    await prefs.setString('user_comments', jsonEncode(encoded));
  }

  void addComment(String postId, ChillComment comment) {
    final updated = Map<String, List<ChillComment>>.from(state);
    updated[postId] = [...(updated[postId] ?? []), comment];
    state = updated;
    _save();
  }

  List<ChillComment> forPost(String postId) => state[postId] ?? [];
}
