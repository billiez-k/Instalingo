import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instalingo/models/course.dart';
import 'package:instalingo/models/user.dart';

class OfflineService {
  static const _courseKey = 'offline_course';
  static const _userKey = 'offline_user';
  static const _lastSyncKey = 'last_sync';

  static Future<void> saveCourse(Course course) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'completedLessons': course.completedLessons,
      'sections': course.sections.map((s) => {
        'id': s.id,
        'isLocked': s.isLocked,
        'lessons': s.lessons.map((l) => {
          'id': l.id,
          'isCompleted': l.isCompleted,
          'isLocked': l.isLocked,
          'isCurrent': l.isCurrent,
          'progress': l.progress,
          'vocabulary': l.vocabulary,
        }).toList(),
      }).toList(),
    };
    await prefs.setString(_courseKey, jsonEncode(data));
    await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<Course?> loadCourse(Course defaultCourse) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_courseKey);
    if (raw == null) return null;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final sectionsData = data['sections'] as List<dynamic>;

      final updatedSections = defaultCourse.sections.asMap().entries.map((entry) {
        final section = entry.value;
        final sectionData = sectionsData.firstWhere(
          (s) => s['id'] == section.id,
          orElse: () => null,
        );
        if (sectionData == null) return section;

        final lessonsData = sectionData['lessons'] as List<dynamic>;
        final updatedLessons = section.lessons.map((lesson) {
          final lessonData = lessonsData.firstWhere(
            (l) => l['id'] == lesson.id,
            orElse: () => null,
          );
          if (lessonData == null) return lesson;

          final vocabData = lessonData['vocabulary'];
          return Lesson(
            id: lesson.id,
            title: lesson.title,
            description: lesson.description,
            order: lesson.order,
            xpReward: lesson.xpReward,
            gemsReward: lesson.gemsReward,
            exercises: lesson.exercises,
            isCompleted: lessonData['isCompleted'] ?? lesson.isCompleted,
            isLocked: lessonData['isLocked'] ?? lesson.isLocked,
            isCurrent: lessonData['isCurrent'] ?? lesson.isCurrent,
            progress: lessonData['progress'] != null
                ? (lessonData['progress'] as num).toDouble()
                : lesson.progress,
            vocabulary: vocabData != null ? List<String>.from(vocabData) : lesson.vocabulary,
          );
        }).toList();

        return Section(
          id: section.id,
          title: section.title,
          order: section.order,
          lessons: updatedLessons,
          isLocked: sectionData['isLocked'] ?? section.isLocked,
        );
      }).toList();

      return Course(
        id: defaultCourse.id,
        title: defaultCourse.title,
        subtitle: defaultCourse.subtitle,
        level: defaultCourse.level,
        language: defaultCourse.language,
        totalLessons: defaultCourse.totalLessons,
        completedLessons: data['completedLessons'] ?? defaultCourse.completedLessons,
        sections: updatedSections,
        imageUrl: defaultCourse.imageUrl,
        description: defaultCourse.description,
        isLocked: defaultCourse.isLocked,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveUser(UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'displayName': user.displayName,
      'email': user.email,
      'nativeLanguage': user.nativeLanguage,
      'learningLanguage': user.learningLanguage,
      'proficiencyLevel': user.proficiencyLevel,
      'dailyGoal': user.dailyGoal,
      'streak': user.streak,
      'xp': user.xp,
      'gems': user.gems,
      'isPro': user.isPro,
      'achievements': user.achievements,
      'languageProgress': user.languageProgress,
      'notificationsEnabled': user.notificationsEnabled,
      'reminderEnabled': user.reminderEnabled,
      'reminderTime': user.reminderTime,
      'learnedWords': user.learnedWords.toList(),
    };
    await prefs.setString(_userKey, jsonEncode(data));
  }

  static Future<UserProfile?> loadUser(UserProfile defaultUser) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final progress = data['languageProgress'];
      final Map<String, int> langProgress = progress is Map
          ? progress.map((k, v) => MapEntry(k.toString(), (v as num).toInt()))
          : defaultUser.languageProgress;

      return defaultUser.copyWith(
        displayName: data['displayName'],
        email: data['email'],
        nativeLanguage: data['nativeLanguage'],
        learningLanguage: data['learningLanguage'],
        proficiencyLevel: data['proficiencyLevel'],
        dailyGoal: data['dailyGoal'],
        streak: data['streak'],
        xp: data['xp'],
        gems: data['gems'],
        isPro: data['isPro'],
        achievements: data['achievements'] != null
            ? List<String>.from(data['achievements'])
            : null,
        languageProgress: langProgress,
        notificationsEnabled: data['notificationsEnabled'],
        reminderEnabled: data['reminderEnabled'],
        reminderTime: data['reminderTime'],
        learnedWords: data['learnedWords'] != null
            ? Set<String>.from(data['learnedWords'])
            : null,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_lastSyncKey);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  static Future<bool> isOfflineDataAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_courseKey) || prefs.containsKey(_userKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_courseKey);
    await prefs.remove(_userKey);
    await prefs.remove(_lastSyncKey);
  }
}
