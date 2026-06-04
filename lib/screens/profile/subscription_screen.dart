import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.subscription),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: AppColors.gold, width: 1.4),
                      ),
                      child: PhosphorIcon(
                        PhosphorIcons.crown(PhosphorIconsStyle.fill),
                        size: 22.sp,
                        color: AppColors.gold,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        l10n.paywallTitle,
                        style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  l10n.profile_unlockFullExperience,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          _PlanCard(
            title: l10n.monthly,
            price: r'$9.99',
            period: l10n.profile_perMonthDesc,
            features: [
              l10n.profile_unlimitedAIConversations,
              l10n.profile_allChillCornerContent,
              l10n.profile_advancedSpeakingFeedback,
              l10n.profile_offlineMode,
              l10n.noAds,
            ],
            isPopular: false,
          ),
          SizedBox(height: 12.h),
          _PlanCard(
            title: l10n.annual,
            price: r'$59.99',
            period: l10n.profile_perYearDesc,
            features: [
              l10n.profile_everythingInMonthly,
              l10n.profile_saveFiftyVsMonthly,
              l10n.profile_priorityAIResponses,
              l10n.profile_exclusiveStudyPlans,
            ],
            isPopular: true,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.push('/paywall');
              },
              child: Text(
                l10n.startFreeTrial,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              l10n.profile_cancelAnytime,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isPopular ? AppColors.gold : appTheme.border,
          width: isPopular ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall,
              ),
              if (isPopular)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: Text(
                    l10n.profile_bestValue,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: theme.textTheme.displayLarge?.copyWith(fontSize: 36.sp),
              ),
              SizedBox(width: 6.w),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  period,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...features.map((f) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                  size: 18.sp,
                  color: AppColors.success,
                ),
                SizedBox(width: 10.w),
                Text(
                  f,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
