import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/providers/onboarding_provider.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/services/language_service.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AccountCreationScreen extends ConsumerStatefulWidget {
  const AccountCreationScreen({super.key});

  @override
  ConsumerState<AccountCreationScreen> createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends ConsumerState<AccountCreationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    // Set locale + profile FIRST so the next page loads with correct language
    await _flushOnboardingData();
    
    await ref.read(onboardingCompleteProvider.notifier).complete();
    if (mounted) {
      context.go('/learn');
    }
  }

  Future<void> _flushOnboardingData() async {
    final data = ref.read(onboardingDataProvider);
    final name = _nameController.text.trim();
    final email = _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null;
    final langService = LanguageService(ref);

    ref.read(userProvider.notifier).updateProfile(
      displayName: name,
      email: email,
      proficiencyLevel: data.proficiencyLevel ?? 'A1',
      dailyGoal: data.dailyGoal ?? 15,
      motivations: data.motivations.isNotEmpty ? data.motivations : null,
      learningGoal: data.learningGoal,
      examType: data.examType,
    );

    final native = data.nativeLanguage ?? 'en';
    await langService.setNativeLanguage(native);

    final target = data.learningLanguage ?? 'ko';
    langService.setLearningLanguage(target);

    ref.read(onboardingDataProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.profile_stepXofY(ref.watch(onboardingDataProvider).learningGoal == LearningGoal.exam ? 8 : 7, ref.watch(onboardingDataProvider).totalSteps),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 2.4,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                l10n.createProfile,
                style: theme.textTheme.displayMedium?.copyWith(fontSize: 28.sp),
              ),
              SizedBox(height: 10.h),
              Container(width: 24.w, height: 3, color: AppColors.primary),
              SizedBox(height: 14.h),
              Text(
                l10n.createProfileDesc,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: context.appTheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 28.h),
              Center(
                child: Container(
                  width: 84.w,
                  height: 84.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: AppColors.primary, width: 1.6),
                  ),
                  child: Center(
                    child: PhosphorIcon(
                      PhosphorIcons.user(PhosphorIconsStyle.fill),
                      size: 36.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.onboarding_displayNameLabel,
                  hintText: l10n.onboarding_enterNameHint,
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.onboarding_emailOptionalLabel,
                  hintText: l10n.onboarding_enterEmailHint,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _createAccount(),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _nameController.text.trim().isNotEmpty && !_isLoading
                      ? _createAccount
                      : null,
                  child: _isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.getStarted,
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await _flushOnboardingData();
                    await ref.read(onboardingCompleteProvider.notifier).complete();
                    if (mounted) context.go('/learn');
                  },
                  child: Text(
                    l10n.onboarding_skipForNow,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
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
