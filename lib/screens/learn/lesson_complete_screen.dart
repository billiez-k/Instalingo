import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LessonCompleteScreen extends StatefulWidget {
  final int xpEarned;
  final int gemsEarned;
  final int? stars;
  final int? correctCount;
  final int? totalExercises;
  final bool courseCompleted;

  const LessonCompleteScreen({
    super.key,
    required this.xpEarned,
    required this.gemsEarned,
    this.stars,
    this.correctCount,
    this.totalExercises,
    this.courseCompleted = false,
  });

  @override
  State<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        HapticFeedback.heavyImpact();
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String _motivationText(AppLocalizations l10n) {
    final starCount = widget.stars ?? 1;
    if (starCount == 3) return l10n.lessonCompletePerfect;
    if (starCount == 2) return l10n.lessonCompleteGreat;
    return l10n.lessonCompleteGood;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final starCount = widget.stars ?? 1;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                maxBlastForce: 8,
                minBlastForce: 3,
                emissionFrequency: 0.08,
                numberOfParticles: 30,
                gravity: 0.4,
                shouldLoop: false,
                colors: const [
                  AppColors.primary,
                  AppColors.xp,
                  AppColors.gems,
                  AppColors.gold,
                  AppColors.secondary,
                  AppColors.accent,
                ],
              ),
            ),
            // Content
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40.h),
                  // Trophy with glow
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 92.w,
                      height: 92.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: AppColors.primary, width: 1.6),
                      ),
                      child: Center(
                        child: PhosphorIcon(
                          PhosphorIcons.trophy(PhosphorIconsStyle.fill),
                          size: 40.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          (widget.courseCompleted ? l10n.courseComplete : l10n.lessonComplete).toUpperCase(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 3.0,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          widget.courseCompleted ? l10n.courseCompleteTitle : l10n.done,
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: 28.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Motivation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      _motivationText(l10n),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Stars row
                  FadeSlide(
                    delayMs: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final isActive = index < starCount;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          child: ScaleTransition(
                            scale: isActive
                                ? CurvedAnimation(
                                    parent: _controller,
                                    curve: Interval(
                                      0.3 + index * 0.15,
                                      0.7 + index * 0.15,
                                      curve: Curves.elasticOut,
                                    ),
                                  )
                                : const AlwaysStoppedAnimation(0.7),
                            child: PhosphorIcon(
                              PhosphorIcons.star(PhosphorIconsStyle.fill),
                              size: 32.sp,
                              color: isActive ? AppColors.gold : appTheme(context).border,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Rewards row
                  FadeSlide(
                    delayMs: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RewardBadge(
                          icon: PhosphorIcons.lightning(PhosphorIconsStyle.fill),
                          value: '+${widget.xpEarned}',
                          label: l10n.xpShort,
                          color: AppColors.xp,
                        ),
                        SizedBox(width: 16.w),
                        _RewardBadge(
                          icon: PhosphorIcons.diamond(PhosphorIconsStyle.fill),
                          value: '+${widget.gemsEarned}',
                          label: l10n.gems,
                          color: AppColors.gems,
                        ),
                        if (widget.correctCount != null &&
                            widget.totalExercises != null) ...[
                          SizedBox(width: 16.w),
                          _RewardBadge(
                            icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                            value: '${widget.correctCount}/${widget.totalExercises}',
                            label: l10n.correct,
                            color: AppColors.success,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Words practiced
                  SizedBox(height: 24.h),
                  FadeSlide(
                    delayMs: 700,
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: appTheme(context).border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.wordsPracticed,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: appTheme(context).onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            alignment: WrapAlignment.center,
                            children: ['hello', 'goodbye', 'name'].map((word) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4.r),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Text(
                                  word,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Buttons
                  FadeSlide(
                    delayMs: 900,
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: () => context.go('/learn'),
                        child: Text(
                          l10n.continueText,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  if (widget.courseCompleted)
                    FadeSlide(
                      delayMs: 1100,
                      child: SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () => context.go('/onboarding/learning-language'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            l10n.pickNewCourse,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 12.h),
                  // Post-lesson review
                  FadeSlide(
                    delayMs: 1000,
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: () => context.push('/post-learning'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          l10n.continueText,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  FadeSlide(
                    delayMs: 1100,
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: OutlinedButton(
                        onPressed: () => context.go('/chill'),
                        child: Text(
                          l10n.visitChillCorner,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AppThemeExtension appTheme(BuildContext context) {
  return Theme.of(context).extension<AppThemeExtension>()!;
}

class _RewardBadge extends StatelessWidget {
  final PhosphorIconData icon;
  final String value;
  final String label;
  final Color color;

  const _RewardBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final appT = appTheme(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: appT.border, width: 1),
      ),
      child: Column(
        children: [
          PhosphorIcon(icon, size: 22.sp, color: color),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: appT.harborNavy,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              color: appT.onSurfaceVariant,
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
