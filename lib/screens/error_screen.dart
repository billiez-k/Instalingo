import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/theme/app_theme.dart';

class ErrorScreen extends StatelessWidget {
  final String? message;

  const ErrorScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: appTheme.harborNavyDeep,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PhosphorIcon(
                PhosphorIcons.warningCircle(PhosphorIconsStyle.regular),
                size: 64.r,
                color: BusanHarborTokens.orange,
              ),
              SizedBox(height: 24.h),
              Text(
                l10n.errorGenericTitle,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: appTheme.harborInkOnNavy,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message ?? l10n.errorGenericMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: appTheme.harborInkOnNavyMuted,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context.go('/swipe'),
                    child: Text(
                      l10n.swipeBackToHome,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: BusanHarborTokens.orange,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  SizedBox(width: 24.w),
                  TextButton(
                    onPressed: () => context.go('/swipe'),
                    child: Text(
                      l10n.retry,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: BusanHarborTokens.coral,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
