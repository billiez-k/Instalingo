import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PostLearningScreen extends StatelessWidget {
  final String lessonId;
  final int xpEarned;
  final int gemsEarned;
  final int stars;

  const PostLearningScreen({
    super.key,
    this.lessonId = 'lesson_1',
    this.xpEarned = 10,
    this.gemsEarned = 5,
    this.stars = 2,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              // Header
              FadeSlide(
                child: Column(
                  children: [
                    Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: AppColors.success, width: 1.6),
                      ),
                      child: Center(
                        child: PhosphorIcon(
                          PhosphorIcons.trophy(PhosphorIconsStyle.fill),
                          size: 32.sp,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      l10n.whatNext.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.success,
                        letterSpacing: 3.0,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.lessonComplete,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontSize: 26.sp,
                        color: context.appTheme.harborNavy,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      l10n.whatNext,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: context.appTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              // Rewards row
              FadeSlide(
                delayMs: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RewardPill(
                      icon: PhosphorIcons.lightning(PhosphorIconsStyle.fill),
                      value: '+$xpEarned',
                      color: AppColors.xp,
                    ),
                    SizedBox(width: 12.w),
                    _RewardPill(
                      icon: PhosphorIcons.diamond(PhosphorIconsStyle.fill),
                      value: '+$gemsEarned',
                      color: AppColors.gems,
                    ),
                    SizedBox(width: 12.w),
                    Row(
                      children: List.generate(3, (index) {
                        return PhosphorIcon(
                          PhosphorIcons.star(PhosphorIconsStyle.fill),
                          size: 20.sp,
                          color: index < stars ? AppColors.gold : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              // Action cards
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    FadeSlide(
                      delayMs: 300,
                      child: _ActionCard(
                        icon: PhosphorIcons.arrowRight(PhosphorIconsStyle.fill),
                        iconColor: AppColors.primary,
                        title: l10n.continueLearning,
                        subtitle: l10n.startNextLesson,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.go('/learn');
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),
                    FadeSlide(
                      delayMs: 400,
                      child: _ActionCard(
                        icon: PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.fill),
                        iconColor: AppColors.secondary,
                        title: l10n.reviewVocabulary,
                        subtitle: l10n.practiceWords,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.push('/vocabulary-review');
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),
                    FadeSlide(
                      delayMs: 500,
                      child: _ActionCard(
                        icon: PhosphorIcons.chatCircleText(PhosphorIconsStyle.fill),
                        iconColor: AppColors.chillPrimary,
                        title: l10n.aiPractice,
                        subtitle: l10n.chatWithAI,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.push('/ai-conversation');
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),
                    FadeSlide(
                      delayMs: 600,
                      child: _ActionCard(
                        icon: PhosphorIcons.snowflake(PhosphorIconsStyle.fill),
                        iconColor: AppColors.accent,
                        title: l10n.visitChillCorner,
                        subtitle: l10n.seeWordsInContext,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.go('/chill');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardPill extends StatelessWidget {
  final PhosphorIconData icon;
  final String value;
  final Color color;

  const _RewardPill({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(icon, size: 14.sp, color: color),
          SizedBox(width: 6.w),
          Text(
            value.toUpperCase(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final PhosphorIconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: appTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: iconColor, width: 1.2),
              ),
              child: PhosphorIcon(icon, size: 20.sp, color: iconColor),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(color: appTheme.harborIconFill),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: appTheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            PhosphorIcon(
              PhosphorIcons.caretRight(),
              size: 18.sp,
              color: appTheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
