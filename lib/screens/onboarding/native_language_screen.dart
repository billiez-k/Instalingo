import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/locale_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NativeLanguageScreen extends ConsumerStatefulWidget {
  const NativeLanguageScreen({super.key});

  @override
  ConsumerState<NativeLanguageScreen> createState() => _NativeLanguageScreenState();
}

class _NativeLanguageScreenState extends ConsumerState<NativeLanguageScreen> {
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appTheme = context.appTheme;

    return Scaffold(
      backgroundColor: appTheme.harborCream,
      appBar: AppBar(
        backgroundColor: appTheme.harborCream,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold), color: appTheme.harborNavy),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Text(
                l10n.onboardingSelectNativeLanguage,
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: appTheme.harborNavy),
              ),
              SizedBox(height: 8.h),
              Container(width: 24.w, height: 3, color: BusanHarborTokens.orange),
              SizedBox(height: 32.h),
              _LanguageTile(
                name: l10n.langNameEn,
                code: 'en',
                isSelected: _selectedLanguage == 'en',
                onTap: () => setState(() => _selectedLanguage = 'en'),
              ),
              SizedBox(height: 8.h),
              _LanguageTile(
                name: l10n.langNameZhTw,
                code: 'zh_TW',
                isSelected: _selectedLanguage == 'zh_TW',
                onTap: () => setState(() => _selectedLanguage = 'zh_TW'),
              ),
              SizedBox(height: 8.h),
              _LanguageTile(
                name: l10n.langNameZhCn,
                code: 'zh_CN',
                isSelected: _selectedLanguage == 'zh_CN',
                onTap: () => setState(() => _selectedLanguage = 'zh_CN'),
              ),
              SizedBox(height: 8.h),
              _LanguageTile(
                name: l10n.langNameKo,
                code: 'ko',
                isSelected: _selectedLanguage == 'ko',
                onTap: () => setState(() => _selectedLanguage = 'ko'),
              ),
              SizedBox(height: 8.h),
              _LanguageTile(
                name: l10n.langNameMs,
                code: 'ms',
                isSelected: _selectedLanguage == 'ms',
                onTap: () => setState(() => _selectedLanguage = 'ms'),
              ),
              SizedBox(height: 8.h),
              _LanguageTile(
                name: l10n.langNameAr,
                code: 'ar',
                isSelected: _selectedLanguage == 'ar',
                onTap: () => setState(() => _selectedLanguage = 'ar'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BusanHarborTokens.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onPressed: () {
                    ref.read(localeProvider.notifier).setLocale(_selectedLanguage);
                    ref.read(userProvider.notifier).updateProfile(nativeLanguage: _selectedLanguage);
                    context.push('/onboarding/learning-language');
                  },
                  child: Text(
                    l10n.onboardingGetStarted,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
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

class _LanguageTile extends StatelessWidget {
  final String name;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.name,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? BusanHarborTokens.orange : appTheme.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? BusanHarborTokens.orange : Colors.transparent,
                border: Border.all(
                  color: isSelected ? BusanHarborTokens.orange : appTheme.borderLight,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? PhosphorIcon(PhosphorIcons.check(PhosphorIconsStyle.bold), size: 14.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 14.w),
            Text(
              name,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: appTheme.harborNavy),
            ),
          ],
        ),
      ),
    );
  }
}
