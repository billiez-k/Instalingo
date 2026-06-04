import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class GrammarTipOverlay {
  static void show(BuildContext context, {
    required String rule,
    required String example,
    String? explanation,
  }) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _GrammarTipSheet(
        rule: rule,
        example: example,
        explanation: explanation,
      ),
    );
  }
}

class _GrammarTipSheet extends StatelessWidget {
  final String rule;
  final String example;
  final String? explanation;

  const _GrammarTipSheet({
    required this.rule,
    required this.example,
    this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: PhosphorIcon(
                  PhosphorIcons.bookOpen(PhosphorIconsStyle.fill),
                  size: 24.sp,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.grammarTip,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      l10n.learnRuleToImprove,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: PhosphorIcon(
                  PhosphorIcons.x(),
                  size: 24.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          FadeSlide(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                rule,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          FadeSlide(
            delayMs: 100,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.exampleLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.secondary,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    example,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (explanation != null) ...[
            SizedBox(height: 16.h),
            FadeSlide(
              delayMs: 200,
              child: Text(
                explanation!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
            ),
          ],
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              child: Text(
                l10n.gotIt,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
