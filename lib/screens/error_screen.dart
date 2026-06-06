import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:instalingo/theme/app_theme.dart';

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({super.key, this.message = 'Page not found'});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
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
                'Oops!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: appTheme.harborInkOnNavy,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: appTheme.harborInkOnNavyMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
