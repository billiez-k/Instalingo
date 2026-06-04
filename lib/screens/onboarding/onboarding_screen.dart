import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Busan Harbor — Onboarding intro.
///
/// A navy hero panel hosts the compass logo and the brand wordmark.
/// Below, a cream paper sheet offers two clear actions (Get Started /
/// I have an account) in editorial typography.
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Navy hero
              Container(
                width: double.infinity,
                color: appTheme.harborIconFill,
                padding: EdgeInsets.fromLTRB(24.w, 80.h, 24.w, 56.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appTitle.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 3.0,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary, width: 1.6),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          alignment: Alignment.center,
                          child: PhosphorIcon(
                            PhosphorIcons.compass(PhosphorIconsStyle.regular),
                            size: 30.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            l10n.onboardingTitle,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: appTheme.harborInkOnNavy,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
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
                      _OnboardingBullet(
                        icon: PhosphorIcons.graduationCap(PhosphorIconsStyle.bold),
                        title: l10n.featureStructuredCourses,
                        desc: l10n.featureStructuredCoursesDesc,
                      ),
                      SizedBox(height: 12.h),
                      _OnboardingBullet(
                        icon: PhosphorIcons.chatCircleText(PhosphorIconsStyle.bold),
                        title: l10n.featureAICharacters,
                        desc: l10n.featureAICharactersDesc,
                      ),
                      SizedBox(height: 12.h),
                      _OnboardingBullet(
                        icon: PhosphorIcons.trophy(PhosphorIconsStyle.bold),
                        title: l10n.featureMotivation,
                        desc: l10n.featureMotivationDesc,
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: () => context.push('/onboarding/welcome'),
                          child: Text(l10n.getStarted.toUpperCase()),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 52.h,
                        child: OutlinedButton(
                          onPressed: () => context.go('/learn'),
                          child: Text(l10n.iAlreadyHaveAccount),
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

class _OnboardingBullet extends StatelessWidget {
  final PhosphorIconData icon;
  final String title;
  final String desc;
  const _OnboardingBullet({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: appTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(2.r),
              border: Border.all(color: appTheme.border, width: 1),
            ),
            alignment: Alignment.center,
            child: PhosphorIcon(icon, size: 16.sp, color: appTheme.harborIconFill),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(color: appTheme.harborNavy),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  desc,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: appTheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
