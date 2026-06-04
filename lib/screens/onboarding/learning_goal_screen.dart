import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/providers/onboarding_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LearningGoalScreen extends ConsumerStatefulWidget {
  const LearningGoalScreen({super.key});

  @override
  ConsumerState<LearningGoalScreen> createState() => _LearningGoalScreenState();
}

class _LearningGoalScreenState extends ConsumerState<LearningGoalScreen> {
  LearningGoal? _selectedGoal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Text(
                l10n.profile_stepXofY(3, ref.watch(onboardingDataProvider).totalSteps),
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 2.4),
              ),
              SizedBox(height: 6.h),
              Text(l10n.onboarding_learningGoalTitle, style: theme.textTheme.displayMedium?.copyWith(fontSize: 28.sp)),
              SizedBox(height: 10.h),
              Container(width: 24.w, height: 3, color: AppColors.primary),
              SizedBox(height: 14.h),
              Text(l10n.onboarding_learningGoalSubtitle, style: theme.textTheme.bodyLarge?.copyWith(color: context.appTheme.onSurfaceVariant)),
              SizedBox(height: 32.h),
              _GoalCard(
                icon: PhosphorIcon(PhosphorIcons.trophy(PhosphorIconsStyle.fill)),
                title: l10n.onboarding_examPrep,
                subtitle: l10n.onboarding_examPrepDesc,
                isSelected: _selectedGoal == LearningGoal.exam,
                onTap: () => setState(() => _selectedGoal = LearningGoal.exam),
              ),
              SizedBox(height: 16.h),
              _GoalCard(
                icon: PhosphorIcon(PhosphorIcons.smiley(PhosphorIconsStyle.fill)),
                title: l10n.onboarding_justForFun,
                subtitle: l10n.onboarding_justForFunDesc,
                isSelected: _selectedGoal == LearningGoal.fun,
                onTap: () => setState(() => _selectedGoal = LearningGoal.fun),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _selectedGoal != null
                      ? () {
                          ref.read(onboardingDataProvider.notifier).setLearningGoal(_selectedGoal!);
                          if (_selectedGoal == LearningGoal.exam) {
                            context.push('/onboarding/exam-type');
                          } else {
                            context.push('/onboarding/proficiency');
                          }
                        }
                      : null,
                  child: Text(l10n.continueText, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({required this.icon, required this.title, required this.subtitle, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: isSelected ? AppColors.primary : theme.dividerColor, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: isSelected ? AppColors.primary : theme.colorScheme.onSurface)),
                  SizedBox(height: 4.h),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                ],
              ),
            ),
            if (isSelected) PhosphorIcon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), color: AppColors.primary, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
