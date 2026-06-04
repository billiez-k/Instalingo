import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/providers/locale_provider.dart';
import 'package:instalingo/providers/onboarding_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NativeLanguageScreen extends ConsumerStatefulWidget {
  const NativeLanguageScreen({super.key});

  @override
  ConsumerState<NativeLanguageScreen> createState() => _NativeLanguageScreenState();
}

class _NativeLanguageScreenState extends ConsumerState<NativeLanguageScreen> {
  String? _selectedLanguage;

  final List<_LanguageOption> languages = const [
    _LanguageOption(code: 'zh', name: '中文（简体）', flag: 'CN'),
    _LanguageOption(code: 'zh_TW', name: '中文（繁體）', flag: 'TW'),
    _LanguageOption(code: 'en', name: 'English', flag: 'US'),
    _LanguageOption(code: 'ja', name: '日本語', flag: 'JP'),
    _LanguageOption(code: 'ko', name: '한국어', flag: 'KR'),
    _LanguageOption(code: 'es', name: 'Español', flag: 'ES'),
    _LanguageOption(code: 'fr', name: 'Français', flag: 'FR'),
    _LanguageOption(code: 'de', name: 'Deutsch', flag: 'DE'),
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
                l10n.profile_stepXofY(1, ref.watch(onboardingDataProvider).totalSteps),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 2.4,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                l10n.nativeLanguage,
                style: theme.textTheme.displayMedium?.copyWith(fontSize: 32.sp),
              ),
              SizedBox(height: 10.h),
              Container(width: 24.w, height: 3, color: AppColors.primary),
              SizedBox(height: 14.h),
              Text(
                l10n.onboarding_nativeLangSubtitle,
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
                          final code = _selectedLanguage!;
                          ref.read(onboardingDataProvider.notifier).setNativeLanguage(code);
                          ref.read(localeProvider.notifier).setLocale(code);
                          context.push('/onboarding/learning-language');
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
  const _LanguageOption({required this.code, required this.name, required this.flag});
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
              child: Text(
                language.name,
                style: theme.textTheme.titleLarge?.copyWith(color: appTheme.harborIconFill),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
