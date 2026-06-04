import 'package:instalingo/providers/onboarding_provider.dart';

enum StreakRecord {
  completed,      // User completed a lesson this day
  missed,         // No lesson completed, streak at risk
  shielded,       // Streak protected (premium feature)
  todayPending,   // Current day, lesson not yet done
  repaired,       // Streak restored via gem purchase
}

class UserProfile {
  final String id;
  final String displayName;
  final String? email;
  final String nativeLanguage;
  final String learningLanguage;
  final String proficiencyLevel;
  final LearningGoal? learningGoal;
  final String? examType;
  final int dailyGoal;
  final int streak;
  final int xp;
  final int gems;
  final String? avatarUrl;
  final List<String> motivations;
  final DateTime joinedAt;
  final bool isPro;
  final DateTime? proExpiry;
  final List<String> achievements;
  final List<String> following;
  final List<String> followers;
  final Map<String, int> languageProgress;
  final bool notificationsEnabled;
  final bool reminderEnabled;
  final String? reminderTime;
  final List<DateTime> activeDays;     // Days with completed lessons
  final int streakShields;             // Number of streak freeze shields remaining
  final int streakRepairCost;          // Current gem cost to repair streak
  final DateTime? lastStreakRepairDate;
  final int streakRepairCount;         // How many times streak has been repaired
  /// Vocabulary words the user has learned (across all languages).
  /// Used to filter Chill Corner posts so only "known" words are shown.
  final Set<String> learnedWords;

  const UserProfile({
    required this.id,
    required this.displayName,
    this.email,
    required this.nativeLanguage,
    required this.learningLanguage,
    required this.proficiencyLevel,
    this.learningGoal,
    this.examType,
    required this.dailyGoal,
    this.streak = 0,
    this.xp = 0,
    this.gems = 0,
    this.avatarUrl,
    this.motivations = const [],
    required this.joinedAt,
    this.isPro = false,
    this.proExpiry,
    this.achievements = const [],
    this.following = const [],
    this.followers = const [],
    this.languageProgress = const {},
    this.notificationsEnabled = true,
    this.reminderEnabled = true,
    this.reminderTime,
    this.activeDays = const [],
    this.streakShields = 0,
    this.streakRepairCost = 50,
    this.lastStreakRepairDate,
    this.streakRepairCount = 0,
    this.learnedWords = const {},
  });

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? nativeLanguage,
    String? learningLanguage,
    String? proficiencyLevel,
    LearningGoal? learningGoal,
    String? examType,
    int? dailyGoal,
    int? streak,
    int? xp,
    int? gems,
    String? avatarUrl,
    List<String>? motivations,
    bool? isPro,
    DateTime? proExpiry,
    List<String>? achievements,
    List<String>? following,
    List<String>? followers,
    Map<String, int>? languageProgress,
    bool? notificationsEnabled,
    bool? reminderEnabled,
    String? reminderTime,
    List<DateTime>? activeDays,
    int? streakShields,
    int? streakRepairCost,
    DateTime? lastStreakRepairDate,
    int? streakRepairCount,
    Set<String>? learnedWords,
  }) =>
      UserProfile(
        id: id,
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        nativeLanguage: nativeLanguage ?? this.nativeLanguage,
        learningLanguage: learningLanguage ?? this.learningLanguage,
        proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
      learningGoal: learningGoal ?? this.learningGoal,
      examType: examType ?? this.examType,
        dailyGoal: dailyGoal ?? this.dailyGoal,
        streak: streak ?? this.streak,
        xp: xp ?? this.xp,
        gems: gems ?? this.gems,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        motivations: motivations ?? this.motivations,
        joinedAt: joinedAt,
        isPro: isPro ?? this.isPro,
        proExpiry: proExpiry ?? this.proExpiry,
        achievements: achievements ?? this.achievements,
        following: following ?? this.following,
        followers: followers ?? this.followers,
        languageProgress: languageProgress ?? this.languageProgress,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        reminderEnabled: reminderEnabled ?? this.reminderEnabled,
        reminderTime: reminderTime ?? this.reminderTime,
        activeDays: activeDays ?? this.activeDays,
        streakShields: streakShields ?? this.streakShields,
        streakRepairCost: streakRepairCost ?? this.streakRepairCost,
        lastStreakRepairDate: lastStreakRepairDate ?? this.lastStreakRepairDate,
        streakRepairCount: streakRepairCount ?? this.streakRepairCount,
        learnedWords: learnedWords ?? this.learnedWords,
      );
}
