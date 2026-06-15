enum StreakRecord {
  completed,
  missed,
  shielded,
  todayPending,
  repaired,
}

class UserProfile {
  final String id;
  final String displayName;
  final String? email;
  final String nativeLanguage;
  final String learningLanguage;
  final String currentLevel;
  final String proficiencyLevel;
  final int dailyGoal;
  final int streak;
  final int xp;
  final int gems;
  final int totalCardsSwiped;
  final bool isPro;
  final DateTime? proExpiry;
  final List<String> achievements;
  final Set<String> savedWords;
  final Set<String> alreadyKnewWords;
  final List<DateTime> activeDays;
  final Map<String, int> weeklyXp;
  final DateTime? lastActiveDate;
  final int streakShields;
  final bool notificationsEnabled;
  final String? reminderTime;
  final DateTime joinedAt;

  const UserProfile({
    required this.id,
    this.displayName = 'Learner',
    this.email,
    this.nativeLanguage = 'zh_TW',
    this.learningLanguage = 'ja',
    this.currentLevel = 'N5',
    this.proficiencyLevel = 'A1',
    this.dailyGoal = 20,
    this.streak = 0,
    this.xp = 0,
    this.gems = 0,
    this.totalCardsSwiped = 0,
    this.isPro = false,
    this.proExpiry,
    this.achievements = const [],
    this.savedWords = const {},
    this.alreadyKnewWords = const {},
    this.activeDays = const [],
    this.weeklyXp = const {},
    this.lastActiveDate,
    this.streakShields = 0,
    this.notificationsEnabled = true,
    this.reminderTime = '20:00',
    required this.joinedAt,
  });

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? nativeLanguage,
    String? learningLanguage,
    String? currentLevel,
    String? proficiencyLevel,
    int? dailyGoal,
    int? streak,
    int? xp,
    int? gems,
    int? totalCardsSwiped,
    bool? isPro,
    DateTime? proExpiry,
    List<String>? achievements,
    Set<String>? savedWords,
    Set<String>? alreadyKnewWords,
    List<DateTime>? activeDays,
    Map<String, int>? weeklyXp,
    DateTime? lastActiveDate,
    int? streakShields,
    bool? notificationsEnabled,
    String? reminderTime,
  }) =>
      UserProfile(
        id: id,
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        nativeLanguage: nativeLanguage ?? this.nativeLanguage,
        learningLanguage: learningLanguage ?? this.learningLanguage,
        currentLevel: currentLevel ?? this.currentLevel,
        proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
        dailyGoal: dailyGoal ?? this.dailyGoal,
        streak: streak ?? this.streak,
        xp: xp ?? this.xp,
        gems: gems ?? this.gems,
        totalCardsSwiped: totalCardsSwiped ?? this.totalCardsSwiped,
        isPro: isPro ?? this.isPro,
        proExpiry: proExpiry ?? this.proExpiry,
        achievements: achievements ?? this.achievements,
        savedWords: savedWords ?? this.savedWords,
        alreadyKnewWords: alreadyKnewWords ?? this.alreadyKnewWords,
        activeDays: activeDays ?? this.activeDays,
        weeklyXp: weeklyXp ?? this.weeklyXp,
        lastActiveDate: lastActiveDate ?? this.lastActiveDate,
        streakShields: streakShields ?? this.streakShields,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        reminderTime: reminderTime ?? this.reminderTime,
        joinedAt: joinedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'display_name': displayName,
        'email': email,
        'native_language': nativeLanguage,
        'learning_language': learningLanguage,
        'current_level': currentLevel,
        'proficiency_level': proficiencyLevel,
        'daily_goal': dailyGoal,
        'streak': streak,
        'xp': xp,
        'gems': gems,
        'total_cards_swiped': totalCardsSwiped,
        'is_pro': isPro,
        'pro_expiry': proExpiry?.toIso8601String(),
        'achievements': achievements,
        'saved_words': savedWords.toList(),
        'already_knew_words': alreadyKnewWords.toList(),
        'active_days': activeDays.map((d) => d.toIso8601String()).toList(),
        'weekly_xp': weeklyXp,
        'last_active_date': lastActiveDate?.toIso8601String(),
        'streak_shields': streakShields,
        'notifications_enabled': notificationsEnabled,
        'reminder_time': reminderTime,
        'joined_at': joinedAt.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        displayName: json['display_name'] as String? ?? 'Learner',
        email: json['email'] as String?,
        nativeLanguage: json['native_language'] as String? ?? 'zh_TW',
        learningLanguage: json['learning_language'] as String? ?? 'ja',
        currentLevel: json['current_level'] as String? ?? 'N5',
        proficiencyLevel: json['proficiency_level'] as String? ?? 'A1',
        dailyGoal: json['daily_goal'] as int? ?? 20,
        streak: json['streak'] as int? ?? 0,
        xp: json['xp'] as int? ?? 0,
        gems: json['gems'] as int? ?? 0,
        totalCardsSwiped: json['total_cards_swiped'] as int? ?? 0,
        isPro: json['is_pro'] as bool? ?? false,
        proExpiry: json['pro_expiry'] != null
            ? DateTime.parse(json['pro_expiry'] as String)
            : null,
        achievements:
            (json['achievements'] as List<dynamic>?)?.cast<String>() ?? [],
        savedWords:
            Set<String>.from((json['saved_words'] as List<dynamic>?) ?? []),
        alreadyKnewWords:
            Set<String>.from((json['already_knew_words'] as List<dynamic>?) ?? []),
        activeDays: (json['active_days'] as List<dynamic>?)
                ?.map((d) => DateTime.parse(d as String))
                .toList() ??
            [],
        weeklyXp: (json['weekly_xp'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
            {},
        lastActiveDate: json['last_active_date'] != null
            ? DateTime.parse(json['last_active_date'] as String)
            : null,
        streakShields: json['streak_shields'] as int? ?? 0,
        notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
        reminderTime: json['reminder_time'] as String? ?? '20:00',
        joinedAt: DateTime.parse(json['joined_at'] as String),
      );
}
