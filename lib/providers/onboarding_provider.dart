import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LearningGoal { exam, fun }

class OnboardingData {
  final String? nativeLanguage;
  final String? learningLanguage;
  final String? proficiencyLevel;
  final List<String> motivations;
  final int? dailyGoal;
  final LearningGoal? learningGoal;
  final String? examType;

  const OnboardingData({
    this.nativeLanguage,
    this.learningLanguage,
    this.proficiencyLevel,
    this.motivations = const [],
    this.dailyGoal,
    this.learningGoal,
    this.examType,
  });

  /// Total onboarding steps — 8 for exam path, 7 for fun path.
  int get totalSteps => learningGoal == LearningGoal.exam ? 8 : 7;

  OnboardingData copyWith({
    String? nativeLanguage,
    String? learningLanguage,
    String? proficiencyLevel,
    List<String>? motivations,
    int? dailyGoal,
    LearningGoal? learningGoal,
    String? examType,
  }) =>
      OnboardingData(
        nativeLanguage: nativeLanguage ?? this.nativeLanguage,
        learningLanguage: learningLanguage ?? this.learningLanguage,
        proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
        motivations: motivations ?? this.motivations,
        dailyGoal: dailyGoal ?? this.dailyGoal,
        learningGoal: learningGoal ?? this.learningGoal,
        examType: examType ?? this.examType,
      );
}

final onboardingDataProvider =
    StateNotifierProvider<OnboardingDataNotifier, OnboardingData>((ref) {
  return OnboardingDataNotifier();
});

class OnboardingDataNotifier extends StateNotifier<OnboardingData> {
  OnboardingDataNotifier() : super(const OnboardingData());

  void setNativeLanguage(String code) {
    state = state.copyWith(nativeLanguage: code);
  }

  void setLearningLanguage(String code) {
    state = state.copyWith(learningLanguage: code);
  }

  void setProficiencyLevel(String level) {
    state = state.copyWith(proficiencyLevel: level);
  }

  void setMotivations(List<String> values) {
    state = state.copyWith(motivations: values);
  }

  void setDailyGoal(int minutes) {
    state = state.copyWith(dailyGoal: minutes);
  }

  void setLearningGoal(LearningGoal goal) {
    state = state.copyWith(learningGoal: goal);
  }

  void setExamType(String exam) {
    state = state.copyWith(examType: exam);
  }

  void reset() {
    state = const OnboardingData();
  }
}
