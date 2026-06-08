import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/onboarding_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProficiencyScreen extends ConsumerStatefulWidget {
  const ProficiencyScreen({super.key});

  @override
  ConsumerState<ProficiencyScreen> createState() => _ProficiencyScreenState();
}

class _ProficiencyScreenState extends ConsumerState<ProficiencyScreen> {
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final levels = [
      _LevelOption(code: 'N5', name: 'Beginner', desc: 'I know a few words'),
      _LevelOption(code: 'N4', name: 'Elementary', desc: 'I can form simple sentences'),
      _LevelOption(code: 'N3', name: 'Intermediate', desc: 'I can hold a conversation'),
      _LevelOption(code: 'N2', name: 'Upper-Intermediate', desc: 'I can discuss various topics'),
      _LevelOption(code: 'N1', name: 'Advanced', desc: 'I speak fluently'),
    ];

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
                l10n.onboardingStepCount(3, 6),
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 2.4),
              ),
              SizedBox(height: 6.h),
              Text(l10n.onboardingProficiencyQuestion, style: theme.textTheme.displayMedium?.copyWith(fontSize: 32.sp)),
              SizedBox(height: 10.h),
              Container(width: 24.w, height: 3, color: AppColors.primary),
              SizedBox(height: 14.h),
              Text("We'll start you at the right difficulty.", style: theme.textTheme.bodyLarge?.copyWith(color: context.appTheme.onSurfaceVariant)),
              SizedBox(height: 32.h),
              Expanded(
                child: ListView.builder(
                  itemCount: levels.length,
                  itemBuilder: (_, index) => _LevelTile(
                    level: levels[index],
                    isSelected: _selectedLevel == levels[index].code,
                    onTap: () => setState(() => _selectedLevel = levels[index].code),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _selectedLevel != null
                      ? () {
                          ref.read(onboardingDataProvider.notifier).setProficiencyLevel(_selectedLevel!);
                          context.push('/onboarding/learning-goal');
                        }
                      : null,
                  child: Text(l10n.onboardingContinue, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
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

class _LevelOption {
  final String code;
  final String name;
  final String desc;
  const _LevelOption({required this.code, required this.name, required this.desc});
}

class _LevelTile extends StatelessWidget {
  final _LevelOption level;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelTile({required this.level, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: isSelected ? appTheme.harborNavy : appTheme.border, width: isSelected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w, height: 44.w,
              decoration: BoxDecoration(
                color: isSelected ? appTheme.harborNavy : Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
                border: Border.all(color: isSelected ? appTheme.harborNavy : appTheme.border, width: 1.2),
              ),
              child: Center(
                child: Text(level.code, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: isSelected ? Colors.white : appTheme.harborNavy, letterSpacing: 1.0)),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(level.name, style: theme.textTheme.titleLarge?.copyWith(color: appTheme.harborIconFill), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 2.h),
                  Text(level.desc, style: theme.textTheme.bodySmall?.copyWith(color: appTheme.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 24.w, height: 24.w,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
                border: Border.all(color: isSelected ? AppColors.primary : appTheme.border, width: 1.2),
              ),
              alignment: Alignment.center,
              child: isSelected ? PhosphorIcon(PhosphorIcons.check(PhosphorIconsStyle.bold), size: 14.sp, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
