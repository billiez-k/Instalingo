import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/achievement.dart';
import 'package:instalingo/models/localized_text.dart';
import 'package:instalingo/models/user.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

List<Achievement> _buildAchievements(UserProfile user) {
  return [
    Achievement(
      id: 'first_swipe',
      title: const LocalizedText({'en': 'First Steps', 'zh_TW': '\u7b2c\u4e00\u6b65'}),
      description: const LocalizedText({'en': 'Swipe your first card', 'zh_TW': '\u6ed1\u52d5\u7b2c\u4e00\u5f35\u5361\u7247'}),
      iconName: 'footprints',
      targetValue: 1,
      currentValue: user.totalCardsSwiped.clamp(0, 1),
      isUnlocked: user.totalCardsSwiped >= 1,
      tier: 'bronze',
    ),
    Achievement(
      id: 'streak_7',
      title: const LocalizedText({'en': '7 Day Streak', 'zh_TW': '7\u5929\u9023\u7e8c'}),
      description: const LocalizedText({'en': 'Maintain a 7-day learning streak', 'zh_TW': '\u7dad\u63017\u5929\u5b78\u7fd2\u9023\u7e8c'}),
      iconName: 'fire',
      targetValue: 7,
      currentValue: user.streak.clamp(0, 7),
      isUnlocked: user.streak >= 7,
      tier: 'silver',
    ),
    Achievement(
      id: 'words_50',
      title: const LocalizedText({'en': 'Word Collector', 'zh_TW': '\u55ae\u5b57\u6536\u96c6\u5bb6'}),
      description: const LocalizedText({'en': 'Save 50 words to your collection', 'zh_TW': '\u6536\u85cf50\u500b\u55ae\u5b57'}),
      iconName: 'book-open',
      targetValue: 50,
      currentValue: user.savedWords.length.clamp(0, 50),
      isUnlocked: user.savedWords.length >= 50,
      tier: 'bronze',
    ),
    Achievement(
      id: 'cards_100',
      title: const LocalizedText({'en': 'Card Master', 'zh_TW': '\u5361\u7247\u5927\u5e2b'}),
      description: const LocalizedText({'en': 'Swipe 100 cards', 'zh_TW': '\u6ed1\u52d5100\u5f35\u5361\u7247'}),
      iconName: 'flame',
      targetValue: 100,
      currentValue: user.totalCardsSwiped.clamp(0, 100),
      isUnlocked: user.totalCardsSwiped >= 100,
      tier: 'silver',
    ),
    Achievement(
      id: 'streak_30',
      title: const LocalizedText({'en': 'Monthly Warrior', 'zh_TW': '\u6bcf\u6708\u52c7\u58eb'}),
      description: const LocalizedText({'en': 'Maintain a 30-day streak', 'zh_TW': '\u7dad\u630130\u5929\u9023\u7e8c'}),
      iconName: 'trophy',
      targetValue: 30,
      currentValue: user.streak.clamp(0, 30),
      isUnlocked: user.streak >= 30,
      tier: 'gold',
    ),
  ];
}

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final appTheme = context.appTheme;
    final achievements = _buildAchievements(ref.watch(userProvider));

    final unlocked = achievements.where((a) => a.isUnlocked).toList();
    final locked = achievements.where((a) => !a.isUnlocked).toList();

    return Scaffold(
      backgroundColor: appTheme.harborCream,
      appBar: AppBar(
        backgroundColor: appTheme.harborCream,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold), color: appTheme.harborNavy),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.achievementsTitle, style: TextStyle(color: appTheme.harborNavy, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: appTheme.harborNavy,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                PhosphorIcon(PhosphorIcons.trophy(PhosphorIconsStyle.fill), size: 28.sp, color: BusanHarborTokens.orange),
                SizedBox(width: 14.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${unlocked.length}/${achievements.length}',
                      style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                    Text(l10n.achievementsUnlocked.toUpperCase(),
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: BusanHarborTokens.orange, letterSpacing: 1.5)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          if (unlocked.isNotEmpty) ...[
            _sectionHeader(l10n.achievementsUnlocked, BusanHarborTokens.orange, appTheme),
            SizedBox(height: 12.h),
            ...unlocked.asMap().entries.map((e) => _AchievementCard(achievement: e.value)),
            SizedBox(height: 24.h),
          ],
          if (locked.isNotEmpty) ...[
            _sectionHeader(l10n.achievementsInProgress, appTheme.harborNavy, appTheme),
            SizedBox(height: 12.h),
            ...locked.asMap().entries.map((e) => _AchievementCard(achievement: e.value)),
          ],
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, Color color, AppThemeExtension appTheme) {
    return Row(
      children: [
        Container(width: 18.w, height: 3, color: color),
        SizedBox(width: 8.w),
        Text(title.toUpperCase(),
          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: appTheme.onSurfaceVariant, letterSpacing: 2.0)),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = context.appTheme;
    final tierColor = _tierColor(achievement.tier);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: achievement.isUnlocked ? tierColor : appTheme.borderLight,
          width: achievement.isUnlocked ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          PhosphorIcon(_iconFor(achievement.iconName), size: 20.sp, color: achievement.isUnlocked ? tierColor : appTheme.onSurfaceVariant),
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
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: appTheme.harborNavy),
                      ),
                    ),
                    if (achievement.isUnlocked)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(color: tierColor, borderRadius: BorderRadius.circular(4.r)),
                        child: Text(achievement.tier.toUpperCase(),
                          style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.0)),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(achievement.description.resolve(Localizations.localeOf(context).toString()),
                  style: TextStyle(fontSize: 11.sp, color: appTheme.onSurfaceVariant)),
                if (!achievement.isUnlocked) ...[
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: achievement.progressRatio,
                      minHeight: 6.h,
                      backgroundColor: appTheme.borderLight,
                      valueColor: AlwaysStoppedAnimation(tierColor),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text('${achievement.currentValue}/${achievement.targetValue}',
                    style: TextStyle(fontSize: 10.sp, color: appTheme.onSurfaceVariant)),
                ],
              ],
            ),
          ),
          if (achievement.isUnlocked)
            PhosphorIcon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), size: 24.sp, color: tierColor),
        ],
      ),
    );
  }

  Color _tierColor(String tier) {
    switch (tier) {
      case 'bronze': return BusanHarborTokens.bronze;
      case 'silver': return BusanHarborTokens.silver;
      case 'gold': return BusanHarborTokens.brass;
      default: return BusanHarborTokens.orange;
    }
  }

  PhosphorIconData _iconFor(String name) {
    switch (name) {
      case 'footprints': return PhosphorIcons.footprints(PhosphorIconsStyle.regular);
      case 'fire': return PhosphorIcons.flame(PhosphorIconsStyle.regular);
      case 'book-open': return PhosphorIcons.bookOpen(PhosphorIconsStyle.regular);
      case 'heart': return PhosphorIcons.heart(PhosphorIconsStyle.regular);
      case 'flame': return PhosphorIcons.flame(PhosphorIconsStyle.regular);
      case 'trophy': return PhosphorIcons.trophy(PhosphorIconsStyle.regular);
      default: return PhosphorIcons.star(PhosphorIconsStyle.regular);
    }
  }
}
