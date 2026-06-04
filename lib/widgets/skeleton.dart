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

class ChillSkeleton extends StatelessWidget {
  const ChillSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      children: [
        // Header skeleton
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: 160.w, height: 28),
              SizedBox(height: 6.h),
              SkeletonLine(width: 220.w, height: 16),
            ],
          ),
        ),
        // Post skeletons
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: appTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        SkeletonCircle(size: 40),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonLine(width: 100.w, height: 16),
                              SizedBox(height: 4.h),
                              SkeletonLine(width: 80.w, height: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 220.h,
                    color: appTheme.skeleton,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 0.4.sw, height: 20),
                        SizedBox(height: 8.h),
                        SkeletonLine(width: double.infinity, height: 14),
                        SizedBox(height: 4.h),
                        SkeletonLine(width: 0.8.sw, height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LessonSkeleton extends StatelessWidget {
  const LessonSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          SkeletonLine(width: double.infinity, height: 24),
          SizedBox(height: 8.h),
          SkeletonLine(width: 0.6.sw, height: 16),
          SizedBox(height: 32.h),
          ...List.generate(4, (_) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: appTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: SkeletonLine(width: double.infinity, height: 20),
          )),
        ],
      ),
    );
  }
}
