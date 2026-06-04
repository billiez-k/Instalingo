import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/models/course.dart';
import 'package:instalingo/providers/course_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CourseScreen extends ConsumerWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final course = ref.watch(courseProvider);
    final user = ref.watch(userProvider);
    final nativeLang = user.nativeLanguage;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.coursePath),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          // Course masthead slab
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: appTheme.harborNavy,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: AppColors.primary, width: 1.4),
                      ),
                      child: PhosphorIcon(
                        PhosphorIcons.globe(PhosphorIconsStyle.fill),
                        size: 20.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.coursePath.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 2.0,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            course.title.resolve(nativeLang),
                            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            course.subtitle.resolve(nativeLang),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.r),
                  child: LinearProgressIndicator(
                    value: course.completedLessons / course.totalLessons,
                    minHeight: 4.h,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  l10n.profile_lessonsCompleted(course.completedLessons, course.totalLessons).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // Sections
          Row(
            children: [
              Container(width: 18.w, height: 3, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                l10n.sections.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: appTheme.harborIconFill,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...course.sections.asMap().entries.map((e) => _SectionItem(section: e.value, index: e.key, nativeLang: nativeLang)),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class _SectionItem extends StatelessWidget {
  final Section section;
  final int index;
  final String nativeLang;
  const _SectionItem({required this.section, required this.index, required this.nativeLang});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    final completed = section.lessons.where((l) => l.isCompleted).length;
    final total = section.lessons.length;
    final ordinal = (index + 1).toString().padLeft(2, '0');

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: appTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                ordinal,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: appTheme.onSurfaceVariant,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(width: 10.w),
              PhosphorIcon(
                section.isLocked ? PhosphorIcons.lockKey() : PhosphorIcons.folderOpen(PhosphorIconsStyle.fill),
                size: 18.sp,
                color: section.isLocked ? appTheme.onSurfaceVariant : AppColors.primary,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  section.title.resolve(nativeLang),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: section.isLocked ? appTheme.onSurfaceVariant : appTheme.harborNavy,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$completed/$total',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: appTheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(2.r),
            child: LinearProgressIndicator(
              value: total > 0 ? completed / total : 0,
              minHeight: 3.h,
              backgroundColor: appTheme.border,
              valueColor: AlwaysStoppedAnimation(
                section.isLocked ? appTheme.onSurfaceVariant : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
