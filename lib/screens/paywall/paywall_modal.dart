import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PaywallModal extends StatefulWidget {
  const PaywallModal({super.key});

  @override
  State<PaywallModal> createState() => _PaywallModalState();
}

class _PaywallModalState extends State<PaywallModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnnual = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      )),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
          border: Border(top: BorderSide(color: context.appTheme.harborNavy, width: 1.4)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Editorial harbor header
              Text(
                l10n.unlockSuper.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 3.0,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      PhosphorIcons.crown(PhosphorIconsStyle.fill),
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
                          l10n.getUnlimitedLearning,
                          style: theme.textTheme.displaySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // Features
              ...[
                _FeatureItem(
                  icon: PhosphorIcons.infinity(),
                  text: l10n.unlimitedLessons,
                ),
                _FeatureItem(
                  icon: PhosphorIcons.brain(),
                  text: l10n.aiConversationPractice,
                ),
                _FeatureItem(
                  icon: PhosphorIcons.chartLineUp(),
                  text: l10n.advancedProgressTracking,
                ),
                _FeatureItem(
                  icon: PhosphorIcons.xCircle(),
                  text: l10n.noAds,
                ),
              ].map((f) => FadeSlide(child: f)),
              SizedBox(height: 24.h),
              // Plan toggle — harbor flat segmented
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: context.appTheme.border, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _isAnnual = true);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: _isAnnual ? context.appTheme.harborNavy : Colors.transparent,
                          ),
                          child: Text(
                            l10n.annual.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: _isAnnual ? Colors.white : context.appTheme.harborNavy,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, height: 40.h, color: context.appTheme.border),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _isAnnual = false);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: !_isAnnual ? context.appTheme.harborNavy : Colors.transparent,
                          ),
                          child: Text(
                            l10n.monthly.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: !_isAnnual ? Colors.white : context.appTheme.harborNavy,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              if (_isAnnual)
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: Text(
                      l10n.savePercent(40).toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 24.h),
              // Price
              FadeSlide(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isAnnual ? '\$59.99' : '\$9.99',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 36.sp,
                      ),
                    ),
                    Text(
                      _isAnnual ? l10n.perYear : l10n.perMonth,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // CTA
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    context.pop();
                  },
                  child: Text(
                    l10n.startFreeTrial.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    l10n.maybeLater,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
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

class _FeatureItem extends StatelessWidget {
  final PhosphorIconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(2.r),
              border: Border.all(color: appTheme.border, width: 1),
            ),
            alignment: Alignment.center,
            child: PhosphorIcon(icon, size: 14.sp, color: appTheme.harborIconFill),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(color: appTheme.harborIconFill),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 6.w),
          PhosphorIcon(
            PhosphorIcons.check(PhosphorIconsStyle.bold),
            size: 14.sp,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
