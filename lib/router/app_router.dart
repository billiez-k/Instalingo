import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/screens/splash_screen.dart';
import 'package:instalingo/screens/onboarding/onboarding_screen.dart';
import 'package:instalingo/screens/onboarding/native_language_screen.dart';
import 'package:instalingo/screens/onboarding/learning_language_screen.dart';
import 'package:instalingo/screens/main_shell.dart';
import 'package:instalingo/screens/home/chill_feed_screen.dart';
import 'package:instalingo/screens/swipe/swipe_screen.dart';
import 'package:instalingo/screens/review/review_screen.dart';
import 'package:instalingo/screens/collections/collections_screen.dart';
import 'package:instalingo/screens/daily_complete_screen.dart';
import 'package:instalingo/screens/chill/post_detail_screen.dart';
import 'package:instalingo/screens/profile/profile_screen.dart';
import 'package:instalingo/screens/profile/stats_screen.dart';
import 'package:instalingo/screens/profile/achievements_screen.dart';
import 'package:instalingo/screens/profile/settings_screen.dart';
import 'package:instalingo/screens/profile/edit_profile_screen.dart';
import 'package:instalingo/screens/profile/help_support_screen.dart';
import 'package:instalingo/screens/paywall/paywall_modal.dart';
import 'package:instalingo/screens/error_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    errorBuilder: (_, state) => ErrorScreen(message: state.error.toString()),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (_, __) => _fadePage(const OnboardingScreen()),
      ),
      GoRoute(
        path: '/onboarding/native-language',
        pageBuilder: (_, __) => _slidePage(const NativeLanguageScreen()),
      ),
      GoRoute(
        path: '/onboarding/learning-language',
        pageBuilder: (_, __) => _slidePage(const LearningLanguageScreen()),
      ),
      // Swipe mode (full-screen)
      GoRoute(
        path: '/swipe',
        pageBuilder: (_, __) => _fadePage(const SwipeScreen()),
      ),
      GoRoute(
        path: '/swipe/complete',
        builder: (_, state) {
          final extra = (state.extra is Map<String, dynamic>)
              ? (state.extra as Map<String, dynamic>)
              : <String, dynamic>{};
          return DailyCompleteScreen(
            cardsSwiped: extra['cardsSwiped'] as int? ?? 0,
            xpEarned: extra['xpEarned'] as int? ?? 0,
            gemsEarned: extra['gemsEarned'] as int? ?? 0,
          );
        },
      ),
      // Chill post detail
      GoRoute(
        path: '/post/:id',
        builder: (_, state) => PostDetailScreen(
          postId: state.pathParameters['id']!,
        ),
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
        path: '/profile/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/help',
        builder: (_, __) => const HelpSupportScreen(),
      ),
      // Main shell with tabs
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const ChillFeedScreen(),
          ),
          GoRoute(
            path: '/review',
            builder: (_, __) => const ReviewScreen(),
          ),
          GoRoute(
            path: '/collections',
            builder: (_, __) => const CollectionsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
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
