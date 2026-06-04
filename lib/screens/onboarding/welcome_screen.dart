import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final appTheme = context.appTheme;
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  l10n.welcomeTitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 2.6,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  l10n.welcomeTitle,
                  style: theme.textTheme.displayMedium?.copyWith(fontSize: 28.sp),
                ),
                SizedBox(height: 10.h),
                Container(width: 28.w, height: 3, color: AppColors.primary),
                SizedBox(height: 14.h),
                Text(
                  l10n.welcomeSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: appTheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 32.h),
                ...[
                  _Feature(
                    icon: PhosphorIcons.graduationCap(),
                    title: l10n.featureStructuredCourses,
                    desc: l10n.featureStructuredCoursesDesc,
                  ),
                  _Feature(
                    icon: PhosphorIcons.chatCircleText(),
                    title: l10n.featureAICharacters,
                    desc: l10n.featureAICharactersDesc,
                  ),
                  _Feature(
                    icon: PhosphorIcons.trophy(),
                    title: l10n.featureMotivation,
                    desc: l10n.featureMotivationDesc,
                  ),
                ].map((f) => _FeatureCard(feature: f)),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () => context.push('/onboarding/native-language'),
                    child: Text(
                      l10n.continueText.toUpperCase(),
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, letterSpacing: 1.6),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: OutlinedButton(
                    onPressed: () => context.push('/onboarding/native-language'),
                    child: Text(
                      l10n.takePlacementTest.toUpperCase(),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, letterSpacing: 1.4),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Feature {
  final PhosphorIconData icon;
  final String title;
  final String desc;
  const _Feature({required this.icon, required this.title, required this.desc});
}

class _FeatureCard extends StatelessWidget {
  final _Feature feature;
  const _FeatureCard({required this.feature});

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
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(2.r),
              border: Border.all(color: appTheme.border, width: 1),
            ),
            child: PhosphorIcon(
              feature.icon,
              size: 18.sp,
              color: appTheme.harborIconFill,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: theme.textTheme.titleMedium?.copyWith(color: appTheme.harborIconFill),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  feature.desc,
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
