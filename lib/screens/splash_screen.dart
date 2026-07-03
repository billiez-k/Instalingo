import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Busan Harbor splash — a dark navy harbor at dawn, with a sunrise-orange
/// compass mark at centre. The wordmark sits below in editorial weight.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _waveController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _logoScale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0, 0.6, curve: Curves.easeOutBack)),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0, 0.5, curve: Curves.easeOut)),
    );
    _entranceController.forward();

    Future.delayed(Duration.zero, () async {
      try {
        if (!mounted) return;
        HapticFeedback.mediumImpact();
        // Wait for SharedPreferences to load before reading onboarding state.
        // Without this, onboardingCompleteProvider always returns false (its
        // initial value) and returning users get routed to /onboarding on every
        // launch.
        await ref.read(onboardingReadyProvider.future);
        if (!mounted) return;
        final onboardingComplete = ref.read(onboardingCompleteProvider);
        if (onboardingComplete) {
          context.go('/home');
        } else {
          context.go('/onboarding');
        }
      } catch (_) {
        if (mounted) {
          context.go('/onboarding');
        }
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appTheme = context.appTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: appTheme.harborNavyDeep,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Subtle horizon gradient
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    appTheme.harborNavyDeep,
                    appTheme.harborNavy,
                  ],
                ),
              ),
            ),
            // Animated wave silhouette
            AnimatedBuilder(
              animation: _waveController,
              builder: (_, __) => CustomPaint(
                painter: _HarborWavePainter(
                  phase: _waveController.value,
                  color: AppColors.primary.withValues(alpha: 0.10),
                ),
                size: Size.infinite,
              ),
            ),
            // Centre wordmark + compass
            Center(
              child: FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 110.w,
                        height: 110.w,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(22.r),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: PhosphorIcon(
                            PhosphorIcons.compass(PhosphorIconsStyle.regular),
                            size: 58.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 28.h),
                      FadeSlide(
                        delayMs: 250,
                        child: Text(
                          l10n.appTitle.toUpperCase(),
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                            color: appTheme.harborInkOnNavy,
                            letterSpacing: 6.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      FadeSlide(
                        delayMs: 450,
                        child: Container(
                          width: 32.w,
                          height: 3,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FadeSlide(
                        delayMs: 600,
                        child: Text(
                          l10n.appTagline,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: appTheme.harborInkOnNavyMuted,
                            letterSpacing: 2.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer loader
            Positioned(
              bottom: 56.h,
              left: 0,
              right: 0,
              child: FadeSlide(
                delayMs: 700,
                child: Center(
                  child: SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HarborWavePainter extends CustomPainter {
  final double phase;
  final Color color;

  _HarborWavePainter({required this.phase, required this.color});

  // Cached to avoid allocating new objects on every animation frame (60 fps).
  // The paint object is reused across frames; color is reassigned on each
  // paint() call since phase (and thus shouldRepaint) changes every frame.
  final Paint _paint = Paint();
  final Path _path = Path();

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = color;
    _path.reset();
    final waveHeight = size.height * 0.06;
    final baseY = size.height * 0.78;
    _path.moveTo(0, size.height);
    _path.lineTo(0, baseY);
    for (double x = 0; x <= size.width; x += 8) {
      final y = baseY +
          waveHeight *
              0.5 *
              (1 - (1 - 2 * ((x / size.width + phase) % 1 - 0.5).abs()));
      _path.lineTo(x, y);
    }
    _path.lineTo(size.width, size.height);
    _path.close();
    canvas.drawPath(_path, _paint);
  }

  @override
  bool shouldRepaint(covariant _HarborWavePainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.color != color;
}
