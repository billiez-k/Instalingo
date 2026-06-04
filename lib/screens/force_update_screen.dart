import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animated illustration container
                PulseContainer(
                  child: Container(
                    width: 88.w,
                    height: 88.w,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: AppColors.primary, width: 1.6),
                    ),
                    child: PhosphorIcon(
                      PhosphorIcons.downloadSimple(PhosphorIconsStyle.fill),
                      size: 38.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  l10n.forceUpdateTitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 3.0,
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  l10n.forceUpdateTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 24.sp),
                ),
                SizedBox(height: 12.h),
                Text(
                  l10n.forceUpdateBody,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 32.h),
                // Feature highlights
                _FeatureRow(icon: PhosphorIcons.bugBeetle(), label: l10n.forceUpdateBugFixes),
                SizedBox(height: 12.h),
                _FeatureRow(icon: PhosphorIcons.lightning(), label: l10n.forceUpdatePerformance),
                SizedBox(height: 12.h),
                _FeatureRow(icon: PhosphorIcons.sparkle(), label: l10n.forceUpdateNewContent),
                SizedBox(height: 32.h),
                // Update button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _openStore();
                    },
                    icon: PhosphorIcon(PhosphorIcons.downloadSimple()),
                    label: Text(
                      l10n.updateNow,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    l10n.notNow,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
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

  Future<void> _openStore() async {
    // For demo purposes, open the app website.
    final uri = Uri.parse('https://instalingo.app/download');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _FeatureRow extends StatelessWidget {
  final PhosphorIconData icon;
  final String label;

  const _FeatureRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PhosphorIcon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 10.w),
        Text(
          label,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
