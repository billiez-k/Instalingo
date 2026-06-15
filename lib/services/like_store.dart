import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists liked post IDs to SharedPreferences so likes survive scroll and restart.
final likeStoreProvider = StateNotifierProvider<LikeStoreNotifier, Set<String>>((ref) {
  return LikeStoreNotifier(ref);
});

class LikeStoreNotifier extends StateNotifier<Set<String>> {
  final Ref _ref;
  LikeStoreNotifier(this._ref) : super({}) { _load(); }

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    final raw = prefs.getStringList('liked_posts');
    if (raw != null) state = raw.toSet();
  }

  Future<void> _save() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setStringList('liked_posts', state.toList());
  }

  void toggle(String postId) {
    final updated = Set<String>.from(state);
    if (updated.contains(postId)) {
      updated.remove(postId);
    } else {
      updated.add(postId);
    }
    state = updated;
    _save();
  }

  bool isLiked(String postId) => state.contains(postId);
}
