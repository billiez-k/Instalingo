import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/models/user.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/streak_calendar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.statsTitle),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          // Weekly XP Chart
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: appTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 18.w, height: 3, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Text(
                      l10n.xpThisWeek.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: appTheme.harborIconFill,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  height: 200.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Bar(label: l10n.mon, value: 0.3, xp: 30),
                      _Bar(label: l10n.tue, value: 0.6, xp: 60),
                      _Bar(label: l10n.wed, value: 0.9, xp: 90),
                      _Bar(label: l10n.thu, value: 0.5, xp: 50),
                      _Bar(label: l10n.fri, value: 0.7, xp: 70),
                      _Bar(label: l10n.sat, value: 1.0, xp: 100, isToday: true),
                      _Bar(label: l10n.sun, value: 0.2, xp: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Stats grid
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: PhosphorIcons.flame(PhosphorIconsStyle.fill),
                  value: '${user.streak}',
                  label: l10n.dayStreak,
                  color: AppColors.streak,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatBox(
                  icon: PhosphorIcons.lightning(PhosphorIconsStyle.fill),
                  value: '${user.xp}',
                  label: l10n.totalXP,
                  color: AppColors.xp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                  value: '${user.totalCardsSwiped}',
                  label: l10n.lessons,
                  color: AppColors.success,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatBox(
                  icon: PhosphorIcons.bookOpen(PhosphorIconsStyle.fill),
                  value: '${user.savedWords.length}',
                  label: l10n.wordsLearned,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Time spent
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
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
                    border: Border.all(color: appTheme.border, width: 1),
                  ),
                  child: PhosphorIcon(
                    PhosphorIcons.clock(PhosphorIconsStyle.fill),
                    size: 18.sp,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.timeSpent,
                        style: theme.textTheme.titleLarge,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        l10n.timeSpentHoursMinutes(4, 32),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Streak Calendar
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: appTheme.border),
            ),
            child: StreakCalendar(
              currentStreak: user.streak,
              streakShields: user.streakShields,
              isTodayPending: !user.activeDays.any((d) =>
                  d.year == DateTime.now().year &&
                  d.month == DateTime.now().month &&
                  d.day == DateTime.now().day),
              dayRecords: {
                for (final day in user.activeDays)
                  day: StreakRecord.completed,
              },
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double value;
  final int xp;
  final bool isToday;

  const _Bar({
    required this.label,
    required this.value,
    required this.xp,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$xp',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isToday ? AppColors.primary : theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: 24.w,
          height: 100.h * value,
          decoration: BoxDecoration(
            color: isToday ? AppColors.primary : context.appTheme.harborNavy.withValues(alpha: 0.55),
            borderRadius: BorderRadius.vertical(top: Radius.circular(2.r)),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: isToday ? AppColors.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final PhosphorIconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: appTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16.w, height: 3, color: color),
              SizedBox(width: 6.w),
              PhosphorIcon(icon, size: 16.sp, color: color),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            value,
            style: theme.textTheme.displaySmall?.copyWith(
              color: appTheme.harborNavy,
              fontSize: 26.sp,
              height: 1.0,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              color: appTheme.onSurfaceVariant,
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
