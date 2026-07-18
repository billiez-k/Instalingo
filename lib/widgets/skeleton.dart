import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';

class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Shimmer(
      baseColor: appTheme.skeleton,
      highlightColor: appTheme.skeletonHighlight,
      child: Container(
        width: width ?? double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          color: appTheme.skeleton,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Shimmer(
      baseColor: appTheme.skeleton,
      highlightColor: appTheme.skeletonHighlight,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: appTheme.skeleton,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double height;

  const SkeletonCard({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: appTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: 0.3.sw, height: 20, borderRadius: 8),
          SizedBox(height: 8.h),
          SkeletonLine(width: 0.6.sw, height: 16, borderRadius: 6),
          SizedBox(height: 16.h),
          SkeletonLine(width: double.infinity, height: height - 80, borderRadius: 12),
        ],
      ),
    );
  }
}

