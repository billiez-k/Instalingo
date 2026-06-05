import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LearningLanguageScreen extends ConsumerStatefulWidget {
  const LearningLanguageScreen({super.key});

  @override
  ConsumerState<LearningLanguageScreen> createState() => _LearningLanguageScreenState();
}

class _LearningLanguageScreenState extends ConsumerState<LearningLanguageScreen> {
  String _selectedLanguage = 'ja';

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
                l10n.onboardingSelectLearningLanguage,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: appTheme.harborNavy,
                ),
              ),
              SizedBox(height: 8.h),
              Container(width: 24.w, height: 3, color: BusanHarborTokens.orange),
              SizedBox(height: 32.h),
              // Japanese option
              _LanguageTile(
                name: l10n.onboardingJapanese,
                subtitle: l10n.onboardingJlptLevels,
                isSelected: _selectedLanguage == 'ja',
                enabled: true,
                onTap: () => setState(() => _selectedLanguage = 'ja'),
              ),
              SizedBox(height: 8.h),
              // Korean option (grayed out)
              _LanguageTile(
                name: l10n.onboardingKorean,
                subtitle: l10n.onboardingComingSoon,
                isSelected: false,
                enabled: false,
                onTap: () {},
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
                    ref.read(onboardingCompleteProvider.notifier).complete();
                    context.go('/home');
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
  final String subtitle;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.name,
    required this.subtitle,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: appTheme.harborNavy)),
                    SizedBox(height: 2.h),
                    Text(subtitle, style: TextStyle(fontSize: 12.sp, color: appTheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
