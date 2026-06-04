import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/data/demo_data.dart';
import 'package:instalingo/models/user.dart';
import 'package:instalingo/providers/onboarding_provider.dart';
import 'package:instalingo/services/offline_service.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserProfile>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserProfile> {
  UserNotifier() : super(DemoData.user) {
    _loadOffline();
  }

  Future<void> _loadOffline() async {
    final offline = await OfflineService.loadUser(DemoData.user);
    if (offline != null) {
      state = offline;
    }
  }

  Future<void> _save() async {
    await OfflineService.saveUser(state);
  }

  void updateProfile({
    String? displayName,
    String? email,
    String? nativeLanguage,
    String? learningLanguage,
    String? proficiencyLevel,
    LearningGoal? learningGoal,
    String? examType,
    int? dailyGoal,
    List<String>? motivations,
    bool? notificationsEnabled,
    bool? reminderEnabled,
    String? reminderTime,
  }) {
    state = state.copyWith(
      displayName: displayName,
      email: email,
      nativeLanguage: nativeLanguage,
      learningLanguage: learningLanguage,
      proficiencyLevel: proficiencyLevel,
      learningGoal: learningGoal,
      examType: examType,
      dailyGoal: dailyGoal,
      motivations: motivations,
      notificationsEnabled: notificationsEnabled,
      reminderEnabled: reminderEnabled,
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

  void unlockAchievement(String achievementId) {
    if (!state.achievements.contains(achievementId)) {
      state = state.copyWith(
        achievements: [...state.achievements, achievementId],
      );
      _save();
    }
  }

  void upgradeToPro() {
    state = state.copyWith(
      isPro: true,
      proExpiry: DateTime.now().add(const Duration(days: 365)),
    );
    _save();
  }

  /// Adds vocabulary words to the user's learned-words set.
  /// Called by [CourseNotifier] when a lesson is completed.
  void addLearnedWords(List<String> words) {
    if (words.isEmpty) return;
    final updated = Set<String>.from(state.learnedWords)..addAll(words);
    state = state.copyWith(learnedWords: updated);
    _save();
  }
}
