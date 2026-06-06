import 'package:flutter_test/flutter_test.dart';
import 'package:instalingo/models/user.dart';

void main() {
  group('UserProfile', () {
    test('fromJson parses full user profile', () {
      final json = {
        'id': 'user_001',
        'display_name': 'TestUser',
        'email': 'test@example.com',
        'native_language': 'zh_TW',
        'learning_language': 'ja',
        'current_level': 'N4',
        'proficiency_level': 'A2',
        'daily_goal': 30,
        'streak': 7,
        'xp': 1500,
        'gems': 250,
        'total_cards_swiped': 200,
        'is_pro': true,
        'pro_expiry': '2026-12-31T00:00:00.000',
        'achievements': ['first_streak', '100_cards'],
        'saved_words': ['ja_n5_0001', 'ja_n5_0002'],
        'already_knew_words': ['ja_n5_0099'],
        'active_days': ['2026-06-01T00:00:00.000', '2026-06-02T00:00:00.000'],
        'streak_shields': 2,
        'notifications_enabled': false,
        'reminder_time': '09:00',
        'joined_at': '2026-01-15T00:00:00.000',
      };

      final user = UserProfile.fromJson(json);

      expect(user.id, 'user_001');
      expect(user.displayName, 'TestUser');
      expect(user.email, 'test@example.com');
      expect(user.nativeLanguage, 'zh_TW');
      expect(user.learningLanguage, 'ja');
      expect(user.currentLevel, 'N4');
      expect(user.proficiencyLevel, 'A2');
      expect(user.dailyGoal, 30);
      expect(user.streak, 7);
      expect(user.xp, 1500);
      expect(user.gems, 250);
      expect(user.totalCardsSwiped, 200);
      expect(user.isPro, true);
      expect(user.proExpiry, DateTime(2026, 12, 31));
      expect(user.achievements, ['first_streak', '100_cards']);
      expect(user.savedWords, {'ja_n5_0001', 'ja_n5_0002'});
      expect(user.alreadyKnewWords, {'ja_n5_0099'});
      expect(user.activeDays.length, 2);
      expect(user.streakShields, 2);
      expect(user.notificationsEnabled, false);
      expect(user.reminderTime, '09:00');
      expect(user.joinedAt, DateTime(2026, 1, 15));
    });

    test('fromJson provides defaults for missing fields', () {
      final json = {
        'id': 'minimal',
        'joined_at': '2026-01-01T00:00:00.000',
      };

      final user = UserProfile.fromJson(json);

      expect(user.id, 'minimal');
      expect(user.displayName, 'Learner');
      expect(user.nativeLanguage, 'zh_TW');
      expect(user.learningLanguage, 'ja');
      expect(user.currentLevel, 'N5');
      expect(user.proficiencyLevel, 'A1');
      expect(user.dailyGoal, 20);
      expect(user.streak, 0);
      expect(user.xp, 0);
      expect(user.gems, 0);
      expect(user.totalCardsSwiped, 0);
      expect(user.isPro, false);
      expect(user.proExpiry, isNull);
      expect(user.achievements, isEmpty);
      expect(user.savedWords, isEmpty);
      expect(user.alreadyKnewWords, isEmpty);
      expect(user.activeDays, isEmpty);
      expect(user.streakShields, 0);
      expect(user.notificationsEnabled, true);
      expect(user.reminderTime, '20:00');
    });

    test('toJson round-trips correctly', () {
      final user = UserProfile(
        id: 'test',
        displayName: 'Alice',
        nativeLanguage: 'en',
        learningLanguage: 'ja',
        currentLevel: 'N5',
        proficiencyLevel: 'A1',
        dailyGoal: 25,
        streak: 3,
        xp: 500,
        gems: 100,
        totalCardsSwiped: 50,
        isPro: false,
        achievements: const ['first_card'],
        savedWords: const {'ja_n5_0001'},
        alreadyKnewWords: const {},
        activeDays: const [],
        joinedAt: DateTime(2026, 6, 1),
      );

      final json = user.toJson();

      expect(json['id'], 'test');
      expect(json['display_name'], 'Alice');
      expect(json['native_language'], 'en');
      expect(json['learning_language'], 'ja');
      expect(json['daily_goal'], 25);
      expect(json['streak'], 3);
      expect(json['xp'], 500);
      expect(json['saved_words'], ['ja_n5_0001']);
      expect(json['achievements'], ['first_card']);
      expect(json['is_pro'], false);
      expect(json['notifications_enabled'], true);
    });

    test('copyWith updates fields correctly', () {
      final original = UserProfile(
        id: 'test',
        joinedAt: DateTime(2026, 1, 1),
      );

      final updated = original.copyWith(
        displayName: 'Bob',
        streak: 5,
        xp: 1000,
      );

      expect(updated.id, 'test');
      expect(updated.displayName, 'Bob');
      expect(updated.streak, 5);
      expect(updated.xp, 1000);
      // Unchanged fields preserved
      expect(updated.nativeLanguage, original.nativeLanguage);
      expect(updated.learningLanguage, original.learningLanguage);
      expect(updated.joinedAt, original.joinedAt);
    });

    test('copyWith with null preserves original values', () {
      final original = UserProfile(
        id: 'test',
        displayName: 'Original',
        streak: 3,
        joinedAt: DateTime(2026, 1, 1),
      );

      final updated = original.copyWith();

      expect(updated.displayName, 'Original');
      expect(updated.streak, 3);
    });
  });

  group('StreakRecord', () {
    test('enum values exist', () {
      expect(StreakRecord.values.length, 5);
      expect(StreakRecord.completed, isA<StreakRecord>());
      expect(StreakRecord.missed, isA<StreakRecord>());
      expect(StreakRecord.shielded, isA<StreakRecord>());
      expect(StreakRecord.todayPending, isA<StreakRecord>());
      expect(StreakRecord.repaired, isA<StreakRecord>());
    });
  });
}
