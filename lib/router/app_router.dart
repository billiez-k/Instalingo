import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/screens/chill/chill_screen.dart';
import 'package:instalingo/screens/chill/post_detail_screen.dart';
import 'package:instalingo/screens/learn/lesson_complete_screen.dart';
import 'package:instalingo/screens/learn/lesson_screen.dart';
import 'package:instalingo/screens/learn/learn_screen.dart';
import 'package:instalingo/screens/main_shell.dart';
import 'package:instalingo/screens/onboarding/account_creation_screen.dart';
import 'package:instalingo/screens/onboarding/commitment_screen.dart';
import 'package:instalingo/screens/onboarding/learning_goal_screen.dart';
import 'package:instalingo/screens/onboarding/learning_language_screen.dart';
import 'package:instalingo/screens/onboarding/exam_type_screen.dart';
import 'package:instalingo/screens/onboarding/motivation_screen.dart';
import 'package:instalingo/screens/onboarding/native_language_screen.dart';
import 'package:instalingo/screens/onboarding/onboarding_screen.dart';
import 'package:instalingo/screens/onboarding/proficiency_screen.dart';
import 'package:instalingo/screens/onboarding/welcome_screen.dart';
import 'package:instalingo/screens/profile/achievements_screen.dart';
import 'package:instalingo/screens/profile/course_screen.dart';
import 'package:instalingo/screens/profile/profile_screen.dart';
import 'package:instalingo/screens/profile/settings_screen.dart';
import 'package:instalingo/screens/profile/stats_screen.dart';
import 'package:instalingo/screens/profile/subscription_screen.dart';
import 'package:instalingo/screens/profile/study_plan_screen.dart';
import 'package:instalingo/screens/ai/ai_conversation_screen.dart';
import 'package:instalingo/screens/force_update_screen.dart';
import 'package:instalingo/screens/learn/mock_test_screen.dart';
import 'package:instalingo/screens/learn/post_learning_screen.dart';
import 'package:instalingo/screens/learn/vocabulary_review_screen.dart';
import 'package:instalingo/data/exam_content.dart';
import 'package:instalingo/screens/paywall/paywall_modal.dart';
import 'package:instalingo/screens/reference/kana_screen.dart';
import 'package:instalingo/screens/reference/kanji_screen.dart';
import 'package:instalingo/screens/profile/edit_profile_screen.dart';
import 'package:instalingo/screens/profile/help_support_screen.dart';
import 'package:instalingo/screens/profile/super_screen.dart';
import 'package:instalingo/screens/splash_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: '/splash',
        routes: [
          // Splash
          GoRoute(
            path: '/splash',
            builder: (_, __) => const SplashScreen(),
          ),
          // Onboarding
          GoRoute(
            path: '/onboarding',
            pageBuilder: (_, __) => _fadePage(const OnboardingScreen()),
          ),
          GoRoute(
            path: '/onboarding/welcome',
            pageBuilder: (_, __) => _slidePage(WelcomeScreen()),
          ),
          GoRoute(
            path: '/onboarding/native-language',
            pageBuilder: (_, __) => _slidePage(const NativeLanguageScreen()),
          ),
          GoRoute(
            path: '/onboarding/learning-language',
            pageBuilder: (_, __) => _slidePage(const LearningLanguageScreen()),
          ),
          GoRoute(
            path: '/onboarding/learning-goal',
            pageBuilder: (_, __) => _slidePage(const LearningGoalScreen()),
          ),
          GoRoute(
            path: '/onboarding/exam-type',
            pageBuilder: (_, __) => _slidePage(const ExamTypeScreen()),
          ),
          GoRoute(
            path: '/onboarding/proficiency',
            pageBuilder: (_, __) => _slidePage(const ProficiencyScreen()),
          ),
          GoRoute(
            path: '/onboarding/motivation',
            pageBuilder: (_, __) => _slidePage(const MotivationScreen()),
          ),
          GoRoute(
            path: '/onboarding/commitment',
            pageBuilder: (_, __) => _slidePage(const CommitmentScreen()),
          ),
          GoRoute(
            path: '/onboarding/account',
            pageBuilder: (_, __) => _slidePage(const AccountCreationScreen()),
          ),
          GoRoute(
            path: '/mock-test/:examType',
            pageBuilder: (_, state) {
              final examType = state.pathParameters['examType']!;
              final test = ExamContent.allTests.firstWhere(
                (t) => t.examName.toLowerCase().replaceAll(' ', '_') == examType ||
                       t.language == examType,
                orElse: () => ExamContent.jlptN5,
              );
              return _slidePage(MockTestScreen(test: test));
            },
          ),
          GoRoute(
            path: '/reference/kana',
            pageBuilder: (_, __) => _slidePage(const KanaScreen()),
          ),
          GoRoute(
            path: '/reference/kanji',
            pageBuilder: (_, __) => _slidePage(const KanjiScreen()),
          ),
          // Main shell with tabs
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (_, __, child) => MainShell(child: child),
            routes: [
              GoRoute(
                path: '/learn',
                builder: (_, __) => const LearnScreen(),
              ),
              GoRoute(
                path: '/chill',
                builder: (_, __) => const ChillScreen(),
              ),
              GoRoute(
                path: '/profile',
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
          // Deep routes
          GoRoute(
            path: '/lesson/:id',
            builder: (_, state) => LessonScreen(
              lessonId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/lesson/complete',
            builder: (_, state) {
              final extra = state.extra as Map?;
              return LessonCompleteScreen(
                xpEarned: extra?['xpEarned'] ?? 10,
                gemsEarned: extra?['gemsEarned'] ?? 5,
                stars: extra?['stars'],
                correctCount: extra?['correctCount'],
                totalExercises: extra?['totalExercises'],
                courseCompleted: extra?['courseCompleted'] ?? false,
              );
            },
          ),
          GoRoute(
            path: '/post/:id',
            builder: (_, state) => PostDetailScreen(
              postId: state.pathParameters['id']!,
            ),
          ),
          // Profile sub-screens
          GoRoute(
            path: '/profile/stats',
            builder: (_, __) => const StatsScreen(),
          ),
          GoRoute(
            path: '/profile/achievements',
            builder: (_, __) => const AchievementsScreen(),
          ),
          GoRoute(
            path: '/profile/course',
            builder: (_, __) => const CourseScreen(),
          ),
          GoRoute(
            path: '/profile/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/profile/subscription',
            builder: (_, __) => const SubscriptionScreen(),
          ),
          GoRoute(
            path: '/profile/super',
            builder: (_, __) => const SuperScreen(),
          ),
          GoRoute(
            path: '/profile/study-plan',
            builder: (_, __) => const StudyPlanScreen(),
          ),
          GoRoute(
            path: '/profile/edit',
            builder: (_, __) => const EditProfileScreen(),
          ),
          GoRoute(
            path: '/profile/help',
            builder: (_, __) => const HelpSupportScreen(),
          ),
          GoRoute(
            path: '/post-learning',
            builder: (_, __) => const PostLearningScreen(),
          ),
          GoRoute(
            path: '/vocabulary-review',
            builder: (_, __) => const VocabularyReviewScreen(),
          ),
          GoRoute(
            path: '/ai-conversation',
            builder: (_, __) => const AiConversationScreen(),
          ),
          GoRoute(
            path: '/force-update',
            builder: (_, __) => const ForceUpdateScreen(),
          ),
          // Paywall
          GoRoute(
            path: '/paywall',
            pageBuilder: (_, state) => CustomTransitionPage(
              child: const PaywallModal(),
              transitionsBuilder: (_, animation, __, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                );
              },
            ),
          ),
        ],
      );

  static CustomTransitionPage _slidePage(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          )),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage _fadePage(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
