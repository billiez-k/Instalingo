import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/providers/onboarding_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ExamTypeScreen extends ConsumerStatefulWidget {
  const ExamTypeScreen({super.key});

  @override
  ConsumerState<ExamTypeScreen> createState() => _ExamTypeScreenState();
}

class _ExamTypeScreenState extends ConsumerState<ExamTypeScreen> {
  String? _selectedExam;

  List<_ExamOption> _examsForLanguage(String lang, AppLocalizations l10n) {
    switch (lang) {
      case 'ja':
        return [
          _ExamOption(id: 'jlpt_n5', name: 'JLPT N5', level: l10n.onboarding_examLevelBeginner, words: l10n.onboarding_examWordsCount('~800'), sections: l10n.onboarding_examSectionsJLPT),
          _ExamOption(id: 'jlpt_n4', name: 'JLPT N4', level: l10n.onboarding_examLevelElementary, words: l10n.onboarding_examWordsCount('~1,500'), sections: l10n.onboarding_examSectionsJLPT),
          _ExamOption(id: 'jlpt_n3', name: 'JLPT N3', level: l10n.onboarding_examLevelIntermediate, words: l10n.onboarding_examWordsCount('~3,700'), sections: l10n.onboarding_examSectionsJLPT),
          _ExamOption(id: 'jlpt_n2', name: 'JLPT N2', level: l10n.onboarding_examLevelUpperIntermediate, words: l10n.onboarding_examWordsCount('~6,000'), sections: l10n.onboarding_examSectionsJLPT),
          _ExamOption(id: 'jlpt_n1', name: 'JLPT N1', level: l10n.onboarding_examLevelAdvanced, words: l10n.onboarding_examWordsCount('~10,000'), sections: l10n.onboarding_examSectionsJLPT),
        ];
      case 'ko':
        return [
          _ExamOption(id: 'topik1', name: 'TOPIK I', level: l10n.onboarding_examLevelBeginnerElementary, words: l10n.onboarding_examWordsCount('~1,500'), sections: l10n.onboarding_examSectionsTOPIK),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final lang = ref.watch(onboardingDataProvider).learningLanguage;
    // Should never be null — user must pick a language before reaching this screen.
    if (lang == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: Center(child: Text(l10n.onboarding_learningGoalTitle, style: theme.textTheme.bodyLarge)),
      );
    }
    final exams = _examsForLanguage(lang, l10n);
    final langName = lang == 'ja' ? l10n.onboarding_japanese : l10n.onboarding_korean;

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Text(l10n.profile_stepXofY(4, ref.watch(onboardingDataProvider).totalSteps), style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 2.4)),
              SizedBox(height: 6.h),
              Text(l10n.onboarding_examTypeTitle, style: theme.textTheme.displayMedium?.copyWith(fontSize: 28.sp)),
              SizedBox(height: 10.h),
              Container(width: 24.w, height: 3, color: AppColors.primary),
              SizedBox(height: 14.h),
              Text(l10n.onboarding_examTypeSubtitle(langName), style: theme.textTheme.bodyLarge?.copyWith(color: context.appTheme.onSurfaceVariant)),
              SizedBox(height: 32.h),
              Expanded(
                child: ListView.builder(
                  itemCount: exams.length,
                  itemBuilder: (_, i) => _ExamCard(
                    exam: exams[i],
                    isSelected: _selectedExam == exams[i].id,
                    onTap: () => setState(() => _selectedExam = exams[i].id),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _selectedExam != null
                      ? () {
                          ref.read(onboardingDataProvider.notifier).setExamType(_selectedExam!);
                          context.push('/onboarding/proficiency');
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

class _ExamOption {
  final String id;
  final String name;
  final String level;
  final String words;
  final String sections;

  const _ExamOption({required this.id, required this.name, required this.level, required this.words, required this.sections});
}

class _ExamCard extends StatelessWidget {
  final _ExamOption exam;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExamCard({required this.exam, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: isSelected ? AppColors.primary : theme.dividerColor, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w, height: 48.w,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.r)),
              child: Center(child: Text(exam.name.substring(0, 1), style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: AppColors.primary))),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exam.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: 4.h),
                  Text('${exam.level} · ${exam.words}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                  SizedBox(height: 2.h),
                  Text(exam.sections, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
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
