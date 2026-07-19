import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/theme/app_theme.dart';

/// Minimal splash screen — static, no animations.
/// Routes to onboarding or main shell once preferences are loaded.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await ref.read(onboardingReadyProvider.future).timeout(
        const Duration(seconds: 5),
      );
    } catch (_) {
      // Preferences failed or timed out — proceed anyway
    }
    if (!mounted) return;
    try {
      final onboarded = ref.read(onboardingCompleteProvider);
      if (onboarded) {
        context.go('/swipe');
        return;
      }
    } catch (_) {}
    if (mounted) context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F1F2E),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.translate, size: 64, color: Color(0xFFEE6C2C)),
            SizedBox(height: 16),
            Text(
              'InstaLingo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Discover Japanese',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFA3ABB4),
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFEE6C2C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
