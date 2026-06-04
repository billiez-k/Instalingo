import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/data/demo_data.dart';
import 'package:instalingo/models/achievement.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/error_states.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final achievements = DemoData.achievements;

    final unlocked = achievements.where((a) => a.isUnlocked).toList();
    final locked = achievements.where((a) => !a.isUnlocked).toList();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.achievementsTitle),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          // Summary slab
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: appTheme.harborNavy,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: AppColors.primary, width: 1.4),
                  ),
                  child: PhosphorIcon(
                    PhosphorIcons.trophy(PhosphorIconsStyle.fill),
                    size: 22.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.profile_achievementsUnlocked.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 2.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${unlocked.length}/${achievements.length}',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: 28.sp,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          if (achievements.isEmpty)
            EmptyState(
              title: l10n.profile_noAchievementsYet,
              message: l10n.profile_noAchievementsMessage,
              icon: PhosphorIcons.trophy(),
            )
          else ...[
            if (unlocked.isNotEmpty) ...[
            Row(
              children: [
                Container(width: 18.w, height: 3, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  l10n.profile_unlocked.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: appTheme.harborIconFill,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ...unlocked.asMap().entries.map((e) => _AchievementCard(achievement: e.value, index: e.key)),
            SizedBox(height: 24.h),
          ],
          if (locked.isNotEmpty) ...[
            Row(
              children: [
                Container(width: 18.w, height: 3, color: appTheme.harborNavy),
                SizedBox(width: 8.w),
                Text(
                  l10n.profile_inProgress.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: appTheme.harborIconFill,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ...locked.asMap().entries.map((e) => _AchievementCard(achievement: e.value, index: e.key)),
          ],
          ],
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final int index;
  const _AchievementCard({required this.achievement, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    final tierColor = _tierColor(achievement.tier);
    final ordinal = (index + 1).toString().padLeft(2, '0');

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: achievement.isUnlocked ? tierColor : appTheme.border,
          width: achievement.isUnlocked ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            ordinal,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: appTheme.onSurfaceVariant,
              letterSpacing: 1.4,
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: achievement.isUnlocked ? tierColor : appTheme.border, width: 1),
            ),
            child: PhosphorIcon(
              _iconFor(achievement.iconName),
              size: 20.sp,
              color: achievement.isUnlocked ? tierColor : appTheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title.resolve(Localizations.localeOf(context).toString()),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: appTheme.harborIconFill,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (achievement.isUnlocked) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: tierColor,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: Text(
                          achievement.tier.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  achievement.description.resolve(Localizations.localeOf(context).toString()),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (!achievement.isUnlocked) ...[
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: achievement.progressRatio,
                      minHeight: 6.h,
                      backgroundColor: appTheme.border,
                      valueColor: AlwaysStoppedAnimation(tierColor),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${achievement.currentValue}/${achievement.targetValue}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: appTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (achievement.isUnlocked)
            PhosphorIcon(
              PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
              size: 24.sp,
              color: tierColor,
            ),
        ],
      ),
    );
  }

  Color _tierColor(String tier) {
    switch (tier) {
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return AppColors.gold;
      default:
        return AppColors.primary;
    }
  }

  PhosphorIconData _iconFor(String name) {
    switch (name) {
      case 'footprints':
        return PhosphorIcons.footprints();
      case 'fire':
        return PhosphorIcons.flame();
      case 'book-open':
        return PhosphorIcons.bookOpen();
      case 'heart':
        return PhosphorIcons.heart();
      case 'flame':
        return PhosphorIcons.flame();
      case 'trophy':
        return PhosphorIcons.trophy();
      default:
        return PhosphorIcons.star();
    }
  }
}
