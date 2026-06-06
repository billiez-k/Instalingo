import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/services/language_service.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user.displayName.isEmpty ? '' : user.displayName);
    _emailController = TextEditingController(text: user.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final user = ref.watch(userProvider);
    final displayName = user.displayName.isEmpty ? l10n.defaultDisplayName : user.displayName;
    final initials = displayName.split(' ').where((s) => s.isNotEmpty).map((s) => s[0]).take(2).join('');

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.editProfile),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              ref.read(userProvider.notifier).updateProfile(
                    displayName: _nameController.text.trim(),
                    email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
                  );
              context.pop();
            },
            child: Text(
              l10n.save,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          // Avatar
          Center(
            child: Stack(
              children: [
                Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: AppColors.primary, width: 1.6),
                  ),
                  child: Center(
                    child: Text(
                      initials.toUpperCase(),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    child: PhosphorIcon(
                      PhosphorIcons.camera(),
                      size: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          // Name field
          _TextFieldLabel(l10n.profile_displayName),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: l10n.profile_enterYourName,
              prefixIcon: PhosphorIcon(PhosphorIcons.user()),
            ),
          ),
          SizedBox(height: 20.h),
          // Email field
          _TextFieldLabel(l10n.profile_email),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: l10n.profile_enterYourEmail,
              prefixIcon: PhosphorIcon(PhosphorIcons.envelope()),
            ),
          ),
          SizedBox(height: 20.h),
          // Learning language
          _TextFieldLabel(l10n.learningLanguage),
          _InfoCard(
            icon: PhosphorIcons.translate(),
            label: user.learningLanguage.toUpperCase(),
            value: _langName(user.learningLanguage),
            onTap: () => _showLearningLanguagePicker(context, ref, user.learningLanguage, l10n),
          ),
          SizedBox(height: 20.h),
          // Proficiency
          _TextFieldLabel(l10n.profile_proficiencyLevel),
          _InfoCard(
            icon: PhosphorIcons.chartBar(),
            label: user.proficiencyLevel,
            value: '${_proficiencyName(user.proficiencyLevel, l10n)} ${l10n.profile_levelSuffix}',
            onTap: () => _showProficiencyPicker(context, ref, user.proficiencyLevel, l10n),
          ),
          SizedBox(height: 20.h),
          // Daily goal
          _TextFieldLabel(l10n.dailyGoal),
          _InfoCard(
            icon: PhosphorIcons.target(),
            label: l10n.profile_minutesCount(user.dailyGoal),
            value: l10n.profile_minPerDay(user.dailyGoal),
            onTap: () => _showDailyGoalPicker(context, ref, user.dailyGoal, l10n),
          ),
        ],
      ),
    );
  }

  void _showLearningLanguagePicker(BuildContext context, WidgetRef ref, String current, AppLocalizations l10n) {
    HapticFeedback.selectionClick();
    final languages = [
      _LangOpt(code: 'en', name: l10n.langNameEn),
      _LangOpt(code: 'ja', name: l10n.langNameJa),
      _LangOpt(code: 'ko', name: l10n.langNameKo),
      _LangOpt(code: 'es', name: l10n.langNameEs),
      _LangOpt(code: 'fr', name: l10n.langNameFr),
      _LangOpt(code: 'de', name: l10n.langNameDe),
          _LangOpt(code: 'ar', name: l10n.langNameAr),
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.learningLanguage, style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 16.h),
              ...languages.map((lang) => ListTile(
                title: Text(lang.name),
                trailing: lang.code == current
                    ? PhosphorIcon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), color: AppColors.primary)
                    : null,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  LanguageService(ref).setLearningLanguage(lang.code);
                  if (context.mounted) Navigator.pop(context);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showProficiencyPicker(BuildContext context, WidgetRef ref, String current, AppLocalizations l10n) {
    HapticFeedback.selectionClick();
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.profile_proficiencyLevel, style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 16.h),
              ...levels.map((level) => ListTile(
                title: Text(level),
                trailing: level == current
                    ? PhosphorIcon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), color: AppColors.primary)
                    : null,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ref.read(userProvider.notifier).updateProfile(proficiencyLevel: level);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showDailyGoalPicker(BuildContext context, WidgetRef ref, int current, AppLocalizations l10n) {
    HapticFeedback.selectionClick();
    final options = [5, 10, 15, 20];
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.dailyGoal, style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 16.h),
              ...options.map((min) => ListTile(
                title: Text(l10n.profile_minPerDay(min)),
                trailing: min == current
                    ? PhosphorIcon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), color: AppColors.primary)
                    : null,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ref.read(userProvider.notifier).updateProfile(dailyGoal: min);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  static String _langName(String code) => switch (code) {
    'en' => 'English',
    'ja' => '日本語',
    'ko' => '한국어',
    'es' => 'Español',
    'fr' => 'Français',
    'de' => 'Deutsch',
    'zh' => '中文',
    _ => code.toUpperCase(),
  };

  String _proficiencyName(String level, AppLocalizations l10n) => switch (level) {
    'A1' => l10n.profile_beginner,
    'A2' => l10n.profile_elementary,
    'B1' => l10n.profile_intermediate,
    'B2' => l10n.profile_upperIntermediate,
    'C1' => l10n.profile_advanced,
    'C2' => l10n.profile_proficient,
    _ => level,
  };
}

class _LangOpt {
  final String code;
  final String name;
  const _LangOpt({required this.code, required this.name});
}

class _TextFieldLabel extends StatelessWidget {
  final String text;
  const _TextFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final PhosphorIconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: appTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
                border: Border.all(color: appTheme.border, width: 1),
              ),
              child: PhosphorIcon(icon, size: 16.sp, color: appTheme.harborIconFill),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(color: appTheme.harborIconFill),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              value.toUpperCase(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: appTheme.onSurfaceVariant,
                letterSpacing: 1.4,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: 8.w),
            PhosphorIcon(
              PhosphorIcons.caretRight(),
              size: 16.sp,
              color: appTheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
