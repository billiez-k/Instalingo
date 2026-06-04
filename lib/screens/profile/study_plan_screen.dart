import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StudyPlanScreen extends StatefulWidget {
  const StudyPlanScreen({super.key});

  @override
  State<StudyPlanScreen> createState() => _StudyPlanScreenState();
}

class _StudyPlanScreenState extends State<StudyPlanScreen> {
  int _currentStep = 0;

  List<_StudyPlanStep> _buildSteps(AppLocalizations l10n) => [
    _StudyPlanStep(
      title: l10n.profile_goal,
      desc: l10n.profile_goalDesc,
      options: [
        l10n.profile_dailyConversation,
        l10n.profile_businessEnglish,
        l10n.profile_academicEnglish,
        l10n.profile_travelBasics,
        l10n.profile_examPreparation,
      ],
    ),
    _StudyPlanStep(
      title: l10n.profile_level,
      desc: l10n.profile_levelDesc,
      options: [
        l10n.profile_completeBeginner,
        l10n.profile_someBasics,
        l10n.profile_intermediate,
        l10n.profile_advanced,
      ],
    ),
    _StudyPlanStep(
      title: l10n.profile_schedule,
      desc: l10n.profile_scheduleDesc,
      options: [
        l10n.profile_morning,
        l10n.profile_daytime,
        l10n.profile_evening,
        l10n.profile_night,
      ],
    ),
    _StudyPlanStep(
      title: l10n.profile_intensity,
      desc: l10n.profile_intensityDesc,
      options: [
        l10n.profile_everyDay,
        l10n.profile_fiveDaysAWeek,
        l10n.profile_threeDaysAWeek,
        l10n.profile_weekendsOnly,
      ],
    ),
    _StudyPlanStep(
      title: l10n.profile_duration,
      desc: l10n.profile_durationDesc,
      options: [
        l10n.profile_fiveMinutes,
        l10n.profile_tenMinutes,
        l10n.profile_fifteenMinutes,
        l10n.profile_twentyPlusMinutes,
      ],
    ),
  ];

  final Map<int, String?> _selections = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final steps = _buildSteps(l10n);
    final step = steps[_currentStep];
    final progress = (_currentStep + 1) / steps.length;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.studyPlan),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              // Editorial step eyebrow
              Row(
                children: [
                  Container(width: 18.w, height: 3, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Text(
                    l10n.profile_stepXofY(_currentStep + 1, steps.length),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4.h,
                  backgroundColor: context.appTheme.border,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                step.title,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 30.sp,
                  color: context.appTheme.harborNavy,
                  height: 1.05,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                step.desc,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: context.appTheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: ListView.builder(
                  itemCount: step.options.length,
                  itemBuilder: (_, index) {
                    final option = step.options[index];
                    final isSelected = _selections[_currentStep] == option;

                    final ordinal = (index + 1).toString().padLeft(2, '0');
                    return GestureDetector(
                      onTap: () => setState(() => _selections[_currentStep] = option),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: isSelected ? context.appTheme.harborNavy : context.appTheme.border,
                            width: isSelected ? 1.6 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              ordinal,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w800,
                                color: context.appTheme.onSurfaceVariant,
                                letterSpacing: 1.4,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Text(
                                option,
                                style: theme.textTheme.titleLarge?.copyWith(color: context.appTheme.harborNavy),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              width: 24.w,
                              height: 24.w,
                              decoration: BoxDecoration(
                                color: isSelected ? context.appTheme.harborNavy : Colors.transparent,
                                borderRadius: BorderRadius.circular(2.r),
                                border: Border.all(
                                  color: isSelected ? context.appTheme.harborNavy : context.appTheme.border,
                                  width: 1.2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: isSelected
                                  ? PhosphorIcon(
                                      PhosphorIcons.check(PhosphorIconsStyle.bold),
                                      size: 14.sp,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: Text(l10n.back),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 12.w),
                  Expanded(
                    flex: _currentStep > 0 ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: _selections[_currentStep] != null
                          ? () {
                              if (_currentStep < steps.length - 1) {
                                setState(() => _currentStep++);
                              } else {
                                // Complete
                                context.pop();
                                SharedPreferences.getInstance().then((prefs) => prefs.setBool('study_plan_complete', true));
              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.profile_studyPlanCreated,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    backgroundColor: AppColors.success,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Text(
                        _currentStep < steps.length - 1 ? l10n.continueText : l10n.profile_createPlan,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyPlanStep {
  final String title;
  final String desc;
  final List<String> options;
  const _StudyPlanStep({required this.title, required this.desc, required this.options});
}
