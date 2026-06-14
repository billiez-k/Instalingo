import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/providers/onboarding_provider.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CommitmentScreen extends ConsumerStatefulWidget {
  const CommitmentScreen({super.key});

  @override
  ConsumerState<CommitmentScreen> createState() => _CommitmentScreenState();
}

class _CommitmentScreenState extends ConsumerState<CommitmentScreen> {
  int? _selectedMinutes;
  bool _completing = false;

  Future<void> _completeOnboarding() async {
    if (_selectedMinutes == null) return;
    setState(() => _completing = true);

    final data = ref.read(onboardingDataProvider);
    ref.read(onboardingDataProvider.notifier).setDailyGoalMinutes(_selectedMinutes!);

    final userNotifier = ref.read(userProvider.notifier);
    userNotifier.updateProfile(
      nativeLanguage: data.nativeLanguage,
      learningLanguage: data.learningLanguage,
      currentLevel: data.targetLevel,
      dailyGoal: _selectedMinutes!,
    );

    await ref.read(onboardingCompleteProvider.notifier).complete();
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final options = [
      _CommitmentOption(minutes: 5, label: 'Casual', desc: '5 min / day'),
      _CommitmentOption(minutes: 10, label: 'Regular', desc: '10 min / day'),
      _CommitmentOption(minutes: 15, label: 'Serious', desc: '15 min / day'),
      _CommitmentOption(minutes: 20, label: 'Intense', desc: '20 min / day'),
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
              Text(l10n.onboardingStepCount(6, 6), style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 2.4)),
              SizedBox(height: 6.h),
              Text(l10n.onboardingCommitmentQuestion, style: theme.textTheme.displayMedium?.copyWith(fontSize: 32.sp)),
              SizedBox(height: 10.h),
              Container(width: 24.w, height: 3, color: AppColors.primary),
              SizedBox(height: 14.h),
              Text('You can always change this later in settings.', style: theme.textTheme.bodyLarge?.copyWith(color: context.appTheme.onSurfaceVariant)),
              SizedBox(height: 32.h),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (_, index) => _CommitmentTile(
                    option: options[index],
                    isSelected: _selectedMinutes == options[index].minutes,
                    onTap: () => setState(() => _selectedMinutes = options[index].minutes),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity, height: 56.h,
                child: ElevatedButton(
                  onPressed: _selectedMinutes != null && !_completing ? _completeOnboarding : null,
                  child: _completing
                      ? SizedBox(width: 20.w, height: 20.w, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(l10n.onboardingContinue, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
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

class _CommitmentOption {
  final int minutes;
  final String label;
  final String desc;
  const _CommitmentOption({required this.minutes, required this.label, required this.desc});
}

class _CommitmentTile extends StatelessWidget {
  final _CommitmentOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _CommitmentTile({required this.option, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Semantics(label: option.label, button: true, child: GestureDetector(
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
                child: Text(option.minutes.toString(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: isSelected ? Colors.white : appTheme.harborNavy, letterSpacing: 0.6)),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.label, style: theme.textTheme.titleLarge?.copyWith(color: appTheme.harborIconFill), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 2.h),
                  Text(option.desc.toUpperCase(), style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: appTheme.onSurfaceVariant, letterSpacing: 1.6)),
                ],
              ),
            ),
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
      ),
    );
  }
}
