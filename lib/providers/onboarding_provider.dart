import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LearningGoal { examPrep, casual }

class OnboardingData {
  final String? nativeLanguage;
  final String? learningLanguage;
  final String? targetLevel; // jlpt_n5, jlpt_n4, etc.
  final String? proficiencyLevel; // A1–C2 CEFR
  final List<String> motivations;
  final int? dailyGoalMinutes;
  final LearningGoal? learningGoal;

  const OnboardingData({
    this.nativeLanguage,
    this.learningLanguage,
    this.targetLevel,
    this.proficiencyLevel,
    this.motivations = const [],
    this.dailyGoalMinutes,
    this.learningGoal,
  });

  int get totalSteps => 7;

  OnboardingData copyWith({
    String? nativeLanguage,
    String? learningLanguage,
    String? targetLevel,
    String? proficiencyLevel,
    List<String>? motivations,
    int? dailyGoalMinutes,
    LearningGoal? learningGoal,
  }) =>
      OnboardingData(
        nativeLanguage: nativeLanguage ?? this.nativeLanguage,
        learningLanguage: learningLanguage ?? this.learningLanguage,
        targetLevel: targetLevel ?? this.targetLevel,
        proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
        motivations: motivations ?? this.motivations,
        dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
        learningGoal: learningGoal ?? this.learningGoal,
      );
}

final onboardingDataProvider =
    StateNotifierProvider<OnboardingDataNotifier, OnboardingData>((ref) {
  return OnboardingDataNotifier();
});

class OnboardingDataNotifier extends StateNotifier<OnboardingData> {
  OnboardingDataNotifier() : super(const OnboardingData());

  void setNativeLanguage(String code) =>
      state = state.copyWith(nativeLanguage: code);

  void setLearningLanguage(String code) =>
      state = state.copyWith(learningLanguage: code);

  void setTargetLevel(String level) =>
      state = state.copyWith(targetLevel: level);

  void setProficiencyLevel(String level) =>
      state = state.copyWith(proficiencyLevel: level);

  void setMotivations(List<String> values) =>
      state = state.copyWith(motivations: values);

  void setDailyGoalMinutes(int minutes) =>
      state = state.copyWith(dailyGoalMinutes: minutes);

  void setLearningGoal(LearningGoal goal) =>
      state = state.copyWith(learningGoal: goal);
}
