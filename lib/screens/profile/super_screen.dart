import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SuperScreen extends StatelessWidget {
  const SuperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(
              PhosphorIcons.sparkle(PhosphorIconsStyle.fill),
              size: 24.sp,
              color: AppColors.gold,
            ),
            SizedBox(width: 8.w),
            Text(l10n.profile_superTitle),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: context.appTheme.harborNavy,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 18.w, height: 3, color: AppColors.gold),
                    SizedBox(width: 8.w),
                    Text(
                      l10n.paywallTitle.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.gold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: AppColors.gold, width: 1.6),
                      ),
                      child: PhosphorIcon(
                        PhosphorIcons.crown(PhosphorIconsStyle.fill),
                        size: 28.sp,
                        color: AppColors.gold,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.paywallTitle,
                            style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            l10n.profile_superSubtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          _FeatureItem(
            icon: PhosphorIcons.chatCircleText(PhosphorIconsStyle.fill),
            title: l10n.profile_unlimitedAIConversations,
            desc: l10n.profile_unlimitedAIDesc,
            color: AppColors.chillPrimary,
          ),
          _FeatureItem(
            icon: PhosphorIcons.microphone(PhosphorIconsStyle.fill),
            title: l10n.profile_advancedSpeakingFeedback,
            desc: l10n.profile_advancedSpeakingDesc,
            color: AppColors.primary,
          ),
          _FeatureItem(
            icon: PhosphorIcons.downloadSimple(PhosphorIconsStyle.fill),
            title: l10n.profile_offlineMode,
            desc: l10n.profile_offlineModeDesc,
            color: AppColors.secondary,
          ),
          _FeatureItem(
            icon: PhosphorIcons.brain(PhosphorIconsStyle.fill),
            title: l10n.profile_personalizedStudyPlans,
            desc: l10n.profile_personalizedStudyPlansDesc,
            color: AppColors.accent,
          ),
          _FeatureItem(
            icon: PhosphorIcons.heart(PhosphorIconsStyle.fill),
            title: l10n.profile_adFreeExperience,
            desc: l10n.profile_adFreeExperienceDesc,
            color: AppColors.streak,
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.push('/paywall');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
              ),
              child: Text(
                l10n.profile_upgradeToSuper,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final PhosphorIconData icon;
  final String title;
  final String desc;
  final Color color;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
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
              border: Border.all(color: color, width: 1.2),
            ),
            child: PhosphorIcon(icon, size: 20.sp, color: color),
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
                SizedBox(height: 4.h),
                Text(
                  desc,
                  style: theme.textTheme.bodyMedium?.copyWith(
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
