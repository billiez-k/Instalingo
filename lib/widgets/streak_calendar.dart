import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/user.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StreakCalendar extends StatelessWidget {
  final int currentStreak;
  final Map<DateTime, StreakRecord> dayRecords;
  final bool isTodayPending;
  final VoidCallback? onRepairStreak;
  final int streakShields;

  const StreakCalendar({
    super.key,
    required this.currentStreak,
    required this.dayRecords,
    this.isTodayPending = false,
    this.onRepairStreak,
    this.streakShields = 0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstWeekday = DateTime(now.year, now.month, 1).weekday % 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.streakCalendar,
              style: theme.textTheme.titleLarge,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.streak.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_fire_department, size: 16.sp, color: AppColors.streak),
                  SizedBox(width: 4.w),
                  Text(
                    l10n.dayStreakCount(currentStreak),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.streak,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isTodayPending) ...[
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.streak.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.streak.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.flame(PhosphorIconsStyle.fill),
                  size: 20.sp,
                  color: AppColors.streak,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    l10n.streakKeepStreak,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.streak,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: 16.h),
        // Day labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [l10n.sun, l10n.mon, l10n.tue, l10n.wed, l10n.thu, l10n.fri, l10n.sat].map((day) {
            return SizedBox(
              width: 36.w,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 8.h),
        // Calendar grid
        Wrap(
          spacing: 0,
          runSpacing: 8.h,
          children: [
            // Empty cells for padding
            ...List.generate(firstWeekday, (_) => SizedBox(width: 36.w)),
            // Day cells
            ...List.generate(daysInMonth, (index) {
              final day = index + 1;
              final date = DateTime(now.year, now.month, day);
              final record = dayRecords.entries
                  .firstWhere(
                    (e) => e.key.year == date.year && e.key.month == date.month && e.key.day == date.day,
                    orElse: () => MapEntry(date, StreakRecord.missed),
                  )
                  .value;
              final isToday = day == now.day;

              // Determine cell appearance based on record
              Color bgColor;
              Color? borderColor;
              Color textColor;
              Widget? badge;

              switch (record) {
                case StreakRecord.completed:
                  bgColor = AppColors.streak;
                  textColor = Colors.white;
                case StreakRecord.shielded:
                  bgColor = AppColors.streak.withValues(alpha: 0.4);
                  textColor = AppColors.streak;
                  badge = PhosphorIcon(
                    PhosphorIcons.shield(PhosphorIconsStyle.fill),
                    size: 10.sp,
                    color: AppColors.streak,
                  );
                case StreakRecord.repaired:
                  bgColor = AppColors.streak.withValues(alpha: 0.7);
                  textColor = Colors.white;
                  badge = PhosphorIcon(
                    PhosphorIcons.wrench(PhosphorIconsStyle.fill),
                    size: 10.sp,
                    color: Colors.white,
                  );
                case StreakRecord.todayPending:
                  bgColor = Colors.transparent;
                  borderColor = AppColors.streak;
                  textColor = AppColors.streak;
                case StreakRecord.missed:
                  bgColor = Colors.transparent;
                  textColor = theme.colorScheme.onSurface.withValues(alpha: 0.3);
              }

              // Override for today
              if (isToday && record != StreakRecord.completed) {
                borderColor = AppColors.primary;
                textColor = AppColors.primary;
              }

              return Container(
                width: 36.w,
                height: 36.w,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(4.r),
                  border: borderColor != null
                      ? Border.all(color: borderColor, width: 2)
                      : null,
                ),
                child: Center(
                  child: badge != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$day',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            badge,
                          ],
                        )
                      : Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isToday || record == StreakRecord.completed
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
        SizedBox(height: 12.h),
        // Legend
        Wrap(
          spacing: 12.w,
          runSpacing: 8.h,
          children: [
            _LegendItem(color: AppColors.streak, label: l10n.active),
            _LegendItem(
              borderColor: AppColors.primary,
              label: l10n.today,
            ),
            _LegendItem(
              color: AppColors.streak.withValues(alpha: 0.4),
              icon: PhosphorIcons.shield(PhosphorIconsStyle.fill),
              label: l10n.streakShielded,
            ),
            _LegendItem(
              color: AppColors.streak.withValues(alpha: 0.7),
              icon: PhosphorIcons.wrench(PhosphorIconsStyle.fill),
              label: l10n.streakRepaired,
            ),
          ],
        ),
        if (streakShields > 0) ...[
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.shield(PhosphorIconsStyle.fill),
                  size: 18.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    l10n.streakShieldsRemaining(streakShields),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (onRepairStreak != null) ...[
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRepairStreak,
              icon: PhosphorIcon(PhosphorIcons.wrench()),
              label: Text(l10n.streakRepair),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.streak,
                side: BorderSide(color: AppColors.streak),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color? color;
  final Color? borderColor;
  final PhosphorIconData? icon;
  final String label;

  const _LegendItem({
    this.color,
    this.borderColor,
    this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color ?? Colors.transparent,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 2)
                : color == null
                    ? Border.all(color: Colors.grey, width: 1)
                    : null,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: icon != null
              ? Center(
                  child: PhosphorIcon(
                    icon!,
                    size: 8.sp,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
