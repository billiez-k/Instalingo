import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LearningLanguageScreen extends ConsumerStatefulWidget {
  const LearningLanguageScreen({super.key});

  @override
  ConsumerState<LearningLanguageScreen> createState() => _LearningLanguageScreenState();
}

class _LearningLanguageScreenState extends ConsumerState<LearningLanguageScreen> {
  String _selectedLevel = 'N5';

  static const _jlptLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Text(
                l10n.onboardingSelectLearningLanguage,
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: appTheme.harborNavy),
              ),
              SizedBox(height: 8.h),
              Container(width: 24.w, height: 3, color: BusanHarborTokens.orange),
              SizedBox(height: 32.h),
              // Learning language: Japanese (only option)
              Text(
                l10n.learningLanguageLabel,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: appTheme.harborInkOnNavyMuted),
              ),
              SizedBox(height: 8.h),
              _LanguageTile(
                name: l10n.onboardingJapanese,
                subtitle: l10n.onboardingJlptLevels,
                isSelected: true,
                enabled: true,
                onTap: () {},
              ),
              SizedBox(height: 24.h),
              // JLPT level picker
              Text(
                l10n.onboardingStartLevel,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: appTheme.harborInkOnNavyMuted),
              ),
              SizedBox(height: 8.h),
              ..._jlptLevels.map((level) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: _LevelTile(
                      level: level,
                      isSelected: _selectedLevel == level,
                      onTap: () => setState(() => _selectedLevel = level),
                      appTheme: appTheme,
                    ),
                  )),
              SizedBox(height: 24.h),
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
                    ref.read(userProvider.notifier).updateProfile(
                          learningLanguage: 'ja',
                          currentLevel: _selectedLevel,
                        );
                    ref.read(onboardingCompleteProvider.notifier).complete();
                    context.go('/home');
                  },
                  child: Text(
                    l10n.onboardingGetStarted,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  final String level;
  final bool isSelected;
  final VoidCallback onTap;
  final AppThemeExtension appTheme;

  const _LevelTile({
    required this.level,
    required this.isSelected,
    required this.onTap,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    final descriptions = {
      'N5': '~800 words • Total beginner',
      'N4': '~1,500 words • Upper beginner',
      'N3': '~3,700 words • Intermediate',
      'N2': '~6,000 words • Upper intermediate',
      'N1': '~10,000 words • Advanced',
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
                  Text(
                    'JLPT $level',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: appTheme.harborNavy),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    descriptions[level] ?? '',
                    style: TextStyle(fontSize: 12.sp, color: appTheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
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
