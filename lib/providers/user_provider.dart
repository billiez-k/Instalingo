import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/models/user.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserProfile>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<UserProfile> {
  final Ref _ref;

  UserNotifier(this._ref)
      : super(UserProfile(
          id: 'user_1',
          displayName: 'Learner',
          nativeLanguage: 'zh_TW',
          learningLanguage: 'ja',
          currentLevel: 'N5',
          dailyGoal: 20,
          joinedAt: DateTime(2026, 6, 1),
        )) {
    _load();
  }

  SharedPreferences? _prefs;
  final Completer<void> _loadCompleter = Completer<void>();

  Future<void> _load() async {
    try {
      final prefs = await _ref.read(sharedPrefsProvider.future);
      _prefs = prefs;
      final json = prefs.getString('user_profile');
      if (json != null) {
        try {
          state = UserProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
        } catch (_) {
          // Corrupted data — clear it to prevent infinite fallback
          await prefs.remove('user_profile');
        }
      }
    } finally {
      _loadCompleter.complete();
    }
  }

  Future<void> _save() async {
    // Wait for _load() to finish before writing, so _prefs is initialized.
    // If _load completes before this line, the completer resolves instantly.
    await _loadCompleter.future;
    if (_prefs == null) return;
    try {
      await _prefs!.setString('user_profile', jsonEncode(state.toJson()));
    } catch (_) {
      // SharedPreferences write failed; state is already updated in memory
      // and will be retried on next mutation.
    }
  }

  void updateProfile({
    String? displayName,
    String? email,
    String? nativeLanguage,
    String? learningLanguage,
    String? currentLevel,
    String? proficiencyLevel,
    int? dailyGoal,
    bool? notificationsEnabled,
    String? reminderTime,
  }) {
    state = state.copyWith(
      displayName: displayName,
      email: email,
      nativeLanguage: nativeLanguage,
      learningLanguage: learningLanguage,
      currentLevel: currentLevel,
      proficiencyLevel: proficiencyLevel,
      dailyGoal: dailyGoal,
      notificationsEnabled: notificationsEnabled,
      reminderTime: reminderTime,
    );
    unawaited(_save());
  }

  void addXp(int amount) {
    final now = DateTime.now();
    final weekKey = _weekKey(now);
    final updatedXp = Map<String, int>.from(state.weeklyXp);
    updatedXp[weekKey] = (updatedXp[weekKey] ?? 0) + amount;
    state = state.copyWith(
      xp: state.xp + amount,
      weeklyXp: updatedXp,
      lastActiveDate: now,
    );
    unawaited(_save());
  }

  String _weekKey(DateTime d) {
    final monday = d.subtract(Duration(days: d.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  void addGems(int amount) {
    state = state.copyWith(gems: state.gems + amount);
    unawaited(_save());
  }

  void incrementStreak() {
    final now = DateTime.now();
    final last = state.lastActiveDate;
    if (last == null) {
      state = state.copyWith(streak: 1, lastActiveDate: now);
    } else {
      final lastDay = DateTime(last.year, last.month, last.day);
      final today = DateTime(now.year, now.month, now.day);
      final diff = today.difference(lastDay).inDays;
      if (diff == 0) return; // Already active today
      if (diff == 1) {
        state = state.copyWith(streak: state.streak + 1, lastActiveDate: now);
      } else {
        state = state.copyWith(streak: 1, lastActiveDate: now); // Streak broken
      }
    }
    unawaited(_save());
  }

  void saveWord(String cardId) {
    if (state.savedWords.contains(cardId)) return;
    final updated = Set<String>.from(state.savedWords)..add(cardId);
    state = state.copyWith(savedWords: updated);
    unawaited(_save());
  }

  void markAlreadyKnew(String cardId) {
    if (state.alreadyKnewWords.contains(cardId)) return;
    final updated = Set<String>.from(state.alreadyKnewWords)..add(cardId);
    state = state.copyWith(alreadyKnewWords: updated);
    unawaited(_save());
  }

  void incrementCardsSwiped() {
    state = state.copyWith(totalCardsSwiped: state.totalCardsSwiped + 1);
    unawaited(_save());
  }

  void unlockAchievement(String id) {
    if (state.achievements.contains(id)) return;
    state = state.copyWith(achievements: [...state.achievements, id]);
    unawaited(_save());
  }

  void upgradeToPro() {
    state = state.copyWith(
      isPro: true,
      proExpiry: DateTime.now().add(const Duration(days: 365)),
    );
    unawaited(_save());
  }

  void resetProgress() {
    state = UserProfile(
      id: state.id,
      displayName: state.displayName,
      email: state.email,
      nativeLanguage: state.nativeLanguage,
      learningLanguage: state.learningLanguage,
      currentLevel: state.currentLevel,
      proficiencyLevel: state.proficiencyLevel,
      dailyGoal: state.dailyGoal,
      notificationsEnabled: state.notificationsEnabled,
      reminderTime: state.reminderTime,
      joinedAt: state.joinedAt,
    );
    unawaited(_save());
  }

  bool isWordSaved(String cardId) {
    return state.savedWords.contains(cardId);
  }

  bool isWordAlreadyKnew(String cardId) {
    return state.alreadyKnewWords.contains(cardId);
  }
}
