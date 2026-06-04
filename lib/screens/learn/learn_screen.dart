import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/course.dart';
import 'package:instalingo/models/user.dart';
import 'package:instalingo/providers/course_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';
import 'package:instalingo/widgets/skeleton.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Busan Harbor — Learn screen.
///
/// The masthead is a deep navy block that anchors the page like a harbor
/// horizon. A sunrise-orange progress strip runs along its base. The
/// continue card mirrors the screenshot's two-zone composition (navy
/// header + white body + bold orange CTA). The course path uses flat
/// editorial rows with small status indicators rather than oversized
/// gamified circles.
class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final course = ref.watch(courseProvider);
    final user = ref.watch(userProvider);

    if (_isLoading) {
      return const _LearnSkeleton();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HarborMasthead(user: user, course: course)),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _ContinueCard(course: course, nativeLang: user.nativeLanguage),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _DailyGoalCard(user: user),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.coursePath.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: appTheme.onSurfaceVariant,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  _QuickActionButton(
                    icon: PhosphorIcons.cards(),
                    label: l10n.review,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.push('/vocabulary-review');
                    },
                  ),
                  SizedBox(width: 8.w),
                  _QuickActionButton(
                    icon: PhosphorIcons.robot(),
                    label: l10n.aiChat,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.push('/ai-conversation');
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, sectionIndex) {
                final section = course.sections[sectionIndex];
                return FadeSlide(
                  delayMs: sectionIndex * 100,
                  child: _SectionCard(
                    section: section,
                    isFirst: sectionIndex == 0,
                    nativeLang: user.nativeLanguage,
                  ),
                );
              },
              childCount: course.sections.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
              child: _HarborStatsRow(user: user),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnSkeleton extends StatelessWidget {
  const _LearnSkeleton();

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: appTheme.harborNavy,
              padding: EdgeInsets.fromLTRB(20.w, 56.h, 20.w, 28.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 100.w, height: 12, borderRadius: 4),
                        SizedBox(height: 12.h),
                        SkeletonLine(width: 200.w, height: 28, borderRadius: 6),
                      ],
                    ),
                  ),
                  SkeletonLine(width: 70.w, height: 32, borderRadius: 8),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
              child: SkeletonCard(height: 200),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, __) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: SkeletonCard(height: 80),
              ),
              childCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _HarborMasthead extends StatelessWidget {
  final UserProfile user;
  final Course course;
  const _HarborMasthead({required this.user, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;

    // Aggregate completion across the entire course to feed the masthead
    // progress strip.
    int total = 0;
    int done = 0;
    for (final s in course.sections) {
      for (final l in s.lessons) {
        total++;
        if (l.isCompleted) done++;
      }
    }
    final progress = total == 0 ? 0.0 : done / total;

    final hour = DateTime.now().hour;
    final String greeting;
    if (hour < 12) {
      greeting = l10n.greetingMorning;
    } else if (hour < 17) {
      greeting = l10n.greetingAfternoon;
    } else {
      greeting = l10n.greetingEvening;
    }

    final level = 1 + (user.xp / 200).floor();

    return Container(
      decoration: BoxDecoration(
        color: appTheme.harborNavy,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(22.w, 56.h, 22.w, 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.learn.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: appTheme.harborInkOnNavyMuted,
                        letterSpacing: 2.4,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(width: 4, height: 4, decoration: BoxDecoration(color: appTheme.harborInkOnNavyMuted, shape: BoxShape.circle)),
                    SizedBox(width: 8.w),
                    Text(
                      greeting.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: appTheme.harborInkOnNavyMuted,
                        letterSpacing: 2.4,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  user.displayName.isEmpty
                      ? l10n.appTitle
                      : user.displayName,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: appTheme.harborInkOnNavy,
                    height: 1.05,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    _StreakPill(value: user.streak),
                    SizedBox(width: 8.w),
                    _LevelPill(value: level),
                  ],
                ),
              ],
            ),
          ),
          _HarborProgressStrip(progress: progress),
        ],
      ),
    );
  }
}

class _HarborProgressStrip extends StatelessWidget {
  final double progress;
  const _HarborProgressStrip({required this.progress});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final p = progress.clamp(0.0, 1.0);
    return SizedBox(
      height: 4,
      child: Stack(
        children: [
          Container(color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.25)),
          FractionallySizedBox(
            widthFactor: p == 0 ? 0.08 : p,
            child: Container(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _StreakPill extends StatelessWidget {
  final int value;
  const _StreakPill({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIcons.flame(PhosphorIconsStyle.fill),
            size: 14.sp,
            color: Colors.white,
          ),
          SizedBox(width: 6.w),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelPill extends StatelessWidget {
  final int value;
  const _LevelPill({required this.value});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appTheme = context.appTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(2.r),
        border: Border.all(color: appTheme.harborInkOnNavyMuted, width: 1.2),
      ),
      child: Text(
        '${l10n.levelAbbreviation} $value',
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w800,
          color: appTheme.harborInkOnNavy,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final PhosphorIconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(2.r),
          border: Border.all(color: appTheme.border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(icon, size: 14.sp, color: appTheme.harborIconFill),
            SizedBox(width: 6.w),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: appTheme.harborIconFill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  final UserProfile user;
  const _DailyGoalCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final progress = ((user.xp % (user.dailyGoal * 10)) / (user.dailyGoal * 10)).clamp(0.0, 1.0);
    final xpNeeded = ((user.dailyGoal * 10) - (user.xp % (user.dailyGoal * 10))).clamp(0, user.dailyGoal * 10);
    final isCompleted = progress >= 1.0;
    final accent = isCompleted ? AppColors.success : AppColors.primary;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: appTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dailyGoalCardTitle.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appTheme.onSurfaceVariant,
                    letterSpacing: 1.6,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  isCompleted ? l10n.dailyGoalReached : l10n.xpToGoal(xpNeeded),
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 14.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6.h,
                    backgroundColor: appTheme.border,
                    valueColor: AlwaysStoppedAnimation(accent),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            width: 56.w,
            height: 56.w,
            child: CustomPaint(
              painter: _RingPainter(
                progress: progress,
                color: accent,
                backgroundColor: appTheme.border,
              ),
              child: Center(
                child: Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class _ContinueCard extends StatelessWidget {
  final Course course;
  final String nativeLang;
  const _ContinueCard({required this.course, required this.nativeLang});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    Lesson? currentLesson;
    Section? currentSection;
    for (final section in course.sections) {
      for (final lesson in section.lessons) {
        if (lesson.isCurrent) {
          currentLesson = lesson;
          currentSection = section;
          break;
        }
      }
      if (currentLesson != null) break;
    }

    if (currentLesson == null) return const SizedBox.shrink();

    final lesson = currentLesson;
    final section = currentSection!;
    final xpReward = lesson.exercises.length * 5;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: appTheme.border),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Navy strip — unit / lesson meta + XP pill
            Container(
              color: appTheme.harborNavy,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${l10n.section} ${section.order + 1} · ${l10n.lessons} ${lesson.order + 1}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: appTheme.harborInkOnNavyMuted,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: Text(
                      '+$xpReward XP',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // White body — title, subtitle, progress, CTA
            Padding(
              padding: EdgeInsets.all(18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title.resolve(nativeLang),
                    style: theme.textTheme.displaySmall,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    lesson.description.resolve(nativeLang),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: appTheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2.r),
                    child: LinearProgressIndicator(
                      value: 0.35,
                      minHeight: 4.h,
                      backgroundColor: appTheme.border,
                      valueColor: AlwaysStoppedAnimation(appTheme.harborNavy),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        context.push('/lesson/${lesson.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.continueText,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          PhosphorIcon(
                            PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
                            size: 16.sp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Section section;
  final bool isFirst;
  final String nativeLang;

  const _SectionCard({required this.section, required this.isFirst, required this.nativeLang});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(2.w, 4.h, 2.w, 10.h),
            child: Row(
              children: [
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    color: section.isLocked
                        ? Colors.transparent
                        : appTheme.harborNavy,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: section.isLocked ? appTheme.border : appTheme.harborNavy,
                      width: 1.4,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${section.order + 1}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: section.isLocked
                          ? appTheme.onSurfaceVariant
                          : appTheme.harborInkOnNavy,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    section.title.resolve(nativeLang),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: section.isLocked
                          ? appTheme.onSurfaceVariant
                          : appTheme.harborNavy,
                    ),
                  ),
                ),
                if (section.isLocked)
                  PhosphorIcon(
                    PhosphorIcons.lockKey(),
                    size: 16.sp,
                    color: appTheme.onSurfaceVariant,
                  )
                else
                  Text(
                    '${section.lessons.where((l) => l.isCompleted).length}/${section.lessons.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: appTheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              for (int i = 0; i < section.lessons.length; i++) ...[
                Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: appTheme.border),
                  ),
                  child: _LessonRow(lesson: section.lessons[i], nativeLang: nativeLang),
                ),
              ],
            ],
          ),
        ],
      ),
    );
    // l10n & isFirst are referenced for backward compatibility / future
    // analytics, suppress unused warnings.
    // ignore: dead_code
  }
}

class _LessonRow extends StatelessWidget {
  final Lesson lesson;
  final String nativeLang;
  const _LessonRow({required this.lesson, required this.nativeLang});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final isCompleted = lesson.isCompleted;
    final isCurrent = lesson.isCurrent;
    final isLocked = lesson.isLocked;

    return InkWell(
      onTap: isLocked
          ? null
          : () {
              HapticFeedback.lightImpact();
              context.push('/lesson/${lesson.id}');
            },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Row(
          children: [
            _LessonStatusBox(
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              isLocked: isLocked,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title.resolve(nativeLang),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isLocked
                          ? appTheme.onSurfaceVariant
                          : appTheme.harborNavy,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    lesson.description.resolve(nativeLang),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: appTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isCurrent && !isLocked) ...[
              SizedBox(width: 8.w),
              PhosphorIcon(
                PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                size: 16.sp,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LessonStatusBox extends StatelessWidget {
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  const _LessonStatusBox({
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final size = 28.0;
    if (isCompleted) {
      return Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: appTheme.harborNavy,
          borderRadius: BorderRadius.circular(2.r),
        ),
        alignment: Alignment.center,
        child: PhosphorIcon(
          PhosphorIcons.check(PhosphorIconsStyle.bold),
          size: 16.sp,
          color: Colors.white,
        ),
      );
    }
    if (isCurrent) {
      return Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(2.r),
        ),
        alignment: Alignment.center,
        child: PhosphorIcon(
          PhosphorIcons.play(PhosphorIconsStyle.fill),
          size: 14.sp,
          color: Colors.white,
        ),
      );
    }
    if (isLocked) {
      return Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(2.r),
          border: Border.all(color: appTheme.border, width: 1.4),
        ),
        alignment: Alignment.center,
        child: PhosphorIcon(
          PhosphorIcons.lockKey(),
          size: 12.sp,
          color: appTheme.onSurfaceVariant,
        ),
      );
    }
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(2.r),
        border: Border.all(color: appTheme.border, width: 1.4),
      ),
    );
  }
}

class _HarborStatsRow extends StatelessWidget {
  final UserProfile user;
  const _HarborStatsRow({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OutlinedStatCard(
            icon: PhosphorIcons.flame(PhosphorIconsStyle.fill),
            value: '${user.streak}',
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _OutlinedStatCard(
            icon: PhosphorIcons.diamond(PhosphorIconsStyle.fill),
            value: '${user.gems}',
            color: AppColors.secondary,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _OutlinedStatCard(
            icon: PhosphorIcons.heart(PhosphorIconsStyle.fill),
            value: '${user.streakShields + 5}',
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}

class _OutlinedStatCard extends StatelessWidget {
  final PhosphorIconData icon;
  final String value;
  final Color color;
  const _OutlinedStatCard({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        children: [
          PhosphorIcon(icon, size: 22.sp, color: color),
          SizedBox(height: 10.h),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
