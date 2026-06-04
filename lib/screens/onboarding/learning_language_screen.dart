import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/providers/onboarding_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LearningLanguageScreen extends ConsumerStatefulWidget {
  const LearningLanguageScreen({super.key});

  @override
  ConsumerState<LearningLanguageScreen> createState() => _LearningLanguageScreenState();
}

class _LearningLanguageScreenState extends ConsumerState<LearningLanguageScreen> {
  String? _selectedLanguage;

  final List<_LanguageOption> languages = const [
    _LanguageOption(code: 'ja', name: '日本語', flag: 'JP', subtitle: 'JLPT N5–N1'),
    _LanguageOption(code: 'ko', name: '한국어', flag: 'KR', subtitle: 'TOPIK I–II'),
  ];

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
                l10n.profile_stepXofY(2, ref.watch(onboardingDataProvider).totalSteps),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 2.4,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                l10n.learningLanguage,
                style: theme.textTheme.displayMedium?.copyWith(fontSize: 32.sp),
              ),
              SizedBox(height: 10.h),
              Container(width: 24.w, height: 3, color: AppColors.primary),
              SizedBox(height: 14.h),
              Text(
                l10n.onboarding_learningLangSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: context.appTheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (_, index) => _LanguageTile(
                    language: languages[index],
                    index: index,
                    isSelected: _selectedLanguage == languages[index].code,
                    onTap: () => setState(() => _selectedLanguage = languages[index].code),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _selectedLanguage != null
                      ? () {
                          ref.read(onboardingDataProvider.notifier).setLearningLanguage(_selectedLanguage!);
                          context.push('/onboarding/learning-goal');
                        }
                      : null,
                  child: Text(
                    l10n.continueText,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                  ),
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

class _LanguageOption {
  final String code;
  final String name;
  final String flag;
  final String subtitle;
  const _LanguageOption({required this.code, required this.name, required this.flag, required this.subtitle});
}

class _LanguageTile extends StatelessWidget {
  final _LanguageOption language;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.language,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final ordinal = (index + 1).toString().padLeft(2, '0');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isSelected ? appTheme.harborNavy : appTheme.border,
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
                color: appTheme.onSurfaceVariant,
                letterSpacing: 1.4,
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 38.w,
              padding: EdgeInsets.symmetric(vertical: 4.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
                border: Border.all(color: appTheme.border, width: 1),
              ),
              child: Text(
                language.flag,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: appTheme.harborIconFill,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.name,
                    style: theme.textTheme.titleLarge?.copyWith(color: appTheme.harborNavy),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    language.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: appTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: isSelected ? appTheme.harborNavy : Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
                border: Border.all(color: isSelected ? appTheme.harborNavy : appTheme.border, width: 1.2),
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
  }
}
