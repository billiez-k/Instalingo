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

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    _prefs = prefs;
    final json = prefs.getString('user_profile');
    if (json != null) {
      try {
        state = UserProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    if (_prefs == null) return;
    await _prefs!.setString('user_profile', jsonEncode(state.toJson()));
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
    _save();
  }

  void addXp(int amount) {
    state = state.copyWith(xp: state.xp + amount);
    _save();
  }

  void addGems(int amount) {
    state = state.copyWith(gems: state.gems + amount);
    _save();
  }

  void incrementStreak() {
    state = state.copyWith(streak: state.streak + 1);
    _save();
  }

  void saveWord(String cardId) {
    if (state.savedWords.contains(cardId)) return;
    final updated = Set<String>.from(state.savedWords)..add(cardId);
    state = state.copyWith(savedWords: updated);
    _save();
  }

  void markAlreadyKnew(String cardId) {
    if (state.alreadyKnewWords.contains(cardId)) return;
    final updated = Set<String>.from(state.alreadyKnewWords)..add(cardId);
    state = state.copyWith(alreadyKnewWords: updated);
    _save();
  }

  void incrementCardsSwiped() {
    state = state.copyWith(totalCardsSwiped: state.totalCardsSwiped + 1);
    _save();
  }

  void unlockAchievement(String id) {
    if (state.achievements.contains(id)) return;
    state = state.copyWith(achievements: [...state.achievements, id]);
    _save();
  }

  void upgradeToPro() {
    state = state.copyWith(
      isPro: true,
      proExpiry: DateTime.now().add(const Duration(days: 365)),
    );
    _save();
  }

  bool isWordSaved(String cardId) {
    return state.savedWords.contains(cardId);
  }

  bool isWordAlreadyKnew(String cardId) {
    return state.alreadyKnewWords.contains(cardId);
  }
}
