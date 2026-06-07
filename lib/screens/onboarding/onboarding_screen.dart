import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Busan Harbor -- Onboarding intro.
///
/// A navy hero panel hosts the compass logo and the "Discover Japanese"
/// headline. Below, a cream paper sheet offers feature bullets and a
/// "Get Started" CTA.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Navy hero — compact
              Container(
                width: double.infinity,
                color: appTheme.harborNavy,
                padding: EdgeInsets.fromLTRB(24.w, 56.h, 24.w, 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Compass logo
                    Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: BusanHarborTokens.orange,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      alignment: Alignment.center,
                      child: PhosphorIcon(
                        PhosphorIcons.compass(PhosphorIconsStyle.regular),
                        size: 32.sp,
                        color: BusanHarborTokens.orange,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      l10n.appTitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: BusanHarborTokens.orange,
                        letterSpacing: 3.0,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.onboardingDiscoverJapanese,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: appTheme.harborInkOnNavy,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Cream paper sheet
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FeatureBullet(
                        icon: PhosphorIcons.cards(PhosphorIconsStyle.bold),
                        title: l10n.onboardingSwipeLearn,
                        description:
                            l10n.onboardingSwipeLearnDesc,
                      ),
                      SizedBox(height: 12.h),
                      _FeatureBullet(
                        icon: PhosphorIcons.clockCounterClockwise(
                            PhosphorIconsStyle.bold),
                        title: l10n.onboardingSmartReview,
                        description:
                            l10n.onboardingSmartReviewDesc,
                      ),
                      SizedBox(height: 12.h),
                      _FeatureBullet(
                        icon: PhosphorIcons.chartLineUp(PhosphorIconsStyle.bold),
                        title: l10n.onboardingTrackProgress,
                        description:
                            l10n.onboardingTrackProgressDesc,
                      ),
                      SizedBox(height: 40.h),
                      SizedBox(
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            context.push('/onboarding/native-language');
                          },
                          child: Text(
                            l10n.onboardingGetStarted,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 48.h,
                        child: OutlinedButton(
                          onPressed: () => context.go('/home'),
                          child: Text(
                            l10n.onboardingAlreadyHaveAccount,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  final PhosphorIconData icon;
  final String title;
  final String description;

  const _FeatureBullet({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: appTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: BusanHarborTokens.orangeWash,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: BusanHarborTokens.orange.withValues(alpha: 0.2),
              ),
            ),
            alignment: Alignment.center,
            child: PhosphorIcon(
              icon,
              size: 18.sp,
              color: BusanHarborTokens.orange,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: appTheme.harborNavy,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: appTheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
