import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/services/tts_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/providers/locale_provider.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/services/language_service.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _localeCode(Locale locale) {
    if (locale.languageCode == 'zh' && locale.countryCode == 'TW') return 'zh_TW';
    return locale.languageCode;
  }

  TimeOfDay _parseTimeOrDefault(String? hhmm) {
    if (hhmm == null || hhmm.isEmpty) return const TimeOfDay(hour: 9, minute: 0);
    final parts = hhmm.split(':');
    if (parts.length != 2) return const TimeOfDay(hour: 9, minute: 0);
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return const TimeOfDay(hour: 9, minute: 0);
    return TimeOfDay(hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
  }

  String _formatTime(BuildContext context, TimeOfDay time) {
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final isDark = ref.watch(darkModeProvider);
    final soundEnabled = ref.watch(soundEnabledProvider);
    final user = ref.watch(userProvider);
    final locale = ref.watch(localeProvider);
    final localeCode = _localeCode(locale);

    final _langNames = {
      'zh': l10n.langNameZhCn,
      'zh_TW': l10n.langNameZhTw,
      'en': l10n.langNameEn,
      'ja': l10n.langNameJa,
      'ko': l10n.langNameKo,
      'es': l10n.langNameEs,
      'fr': l10n.langNameFr,
      'de': l10n.langNameDe,
      'ar': l10n.langNameAr,
    };

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          FadeSlide(child: _SectionTitle(l10n.profile_appearance)),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.moon(),
              iconColor: AppColors.primary,
              label: l10n.darkMode,
              trailing: Switch(
                value: isDark,
                onChanged: (_) {
                  HapticFeedback.lightImpact();
                  ref.read(darkModeProvider.notifier).toggle();
                },
              ),
            ),
          ),
          FadeSlide(
            child: Column(children: [
              _SettingsTile(
                icon: PhosphorIcons.speakerHigh(),
                iconColor: AppColors.secondary,
                label: l10n.profile_soundEffects,
                trailing: Switch(
                  value: soundEnabled,
                  onChanged: (_) {
                    HapticFeedback.lightImpact();
                    ref.read(soundEnabledProvider.notifier).toggle();
                  },
                ),
              ),
              _SettingsTile(
                icon: PhosphorIcons.megaphone(PhosphorIconsStyle.regular),
                iconColor: AppColors.secondary,
                label: l10n.profile_tts,
                subtitle: l10n.profile_ttsDesc,
                trailing: Switch(
                  value: ref.watch(ttsEnabledProvider),
                  onChanged: (v) {
                    HapticFeedback.lightImpact();
                    ref.read(ttsEnabledProvider.notifier).state = v;
                  },
                ),
              ),
            ]),
          ),
          SizedBox(height: 24.h),
          FadeSlide(child: _SectionTitle(l10n.notifications)),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.bell(),
              iconColor: AppColors.accent,
              label: l10n.profile_enableNotifications,
              subtitle: l10n.profile_lessonRemindersStreakAlerts,
              trailing: Switch(
                value: user.notificationsEnabled,
                onChanged: (v) {
                  HapticFeedback.lightImpact();
                  ref.read(userProvider.notifier).updateProfile(notificationsEnabled: v);
                },
              ),
            ),
          ),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.clock(),
              iconColor: AppColors.chillPrimary,
              label: l10n.profile_lessonRemindersStreakAlerts,
              subtitle: _formatTime(context, _parseTimeOrDefault(user.reminderTime)),
              trailing: PhosphorIcon(PhosphorIcons.caretRight(), size: 18.sp, color: appTheme.onSurfaceVariant),
              onTap: () async {
                HapticFeedback.selectionClick();
                final current = _parseTimeOrDefault(user.reminderTime);
                final picked = await showTimePicker(context: context, initialTime: current);
                if (picked == null) return;
                final value = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                ref.read(userProvider.notifier).updateProfile(reminderTime: value);
              },
            ),
          ),
          SizedBox(height: 24.h),
          FadeSlide(child: _SectionTitle(l10n.profile_learning)),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.target(),
              iconColor: AppColors.primary,
              label: l10n.dailyGoal,
              subtitle: l10n.profile_minutesCount(user.dailyGoal),
              trailing: PhosphorIcon(PhosphorIcons.caretRight(), size: 18.sp, color: appTheme.onSurfaceVariant),
              onTap: () => _showDailyGoalPicker(context, ref, user.dailyGoal, l10n),
            ),
          ),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.translate(),
              iconColor: AppColors.secondary,
              label: l10n.nativeLanguage,
              subtitle: _langNames[localeCode] ?? localeCode.toUpperCase(),
              trailing: PhosphorIcon(PhosphorIcons.caretRight(), size: 18.sp, color: appTheme.onSurfaceVariant),
              onTap: () => _showLanguagePicker(context, ref, isNative: true, l10n: l10n),
            ),
          ),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.globe(),
              iconColor: AppColors.accent,
              label: l10n.learningLanguage,
              subtitle: _langNames[user.learningLanguage] ?? user.learningLanguage.toUpperCase(),
              trailing: PhosphorIcon(PhosphorIcons.caretRight(), size: 18.sp, color: appTheme.onSurfaceVariant),
              onTap: () => _showLanguagePicker(context, ref, isNative: false, l10n: l10n),
            ),
          ),
          SizedBox(height: 24.h),
          FadeSlide(child: _SectionTitle(l10n.profile_account)),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.envelope(),
              iconColor: appTheme.onSurfaceVariant,
              label: l10n.profile_email,
              subtitle: l10n.profile_notSet,
              onTap: () => HapticFeedback.selectionClick(),
            ),
          ),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.arrowClockwise(),
              iconColor: appTheme.onSurfaceVariant,
              label: l10n.profile_checkForUpdates,
              trailing: PhosphorIcon(PhosphorIcons.caretRight(), size: 18.sp, color: appTheme.onSurfaceVariant),
              onTap: () {
                HapticFeedback.selectionClick();
                context.push('/force-update');
              },
            ),
          ),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.trash(),
              iconColor: AppColors.error,
              label: l10n.profile_resetProgress,
              labelColor: AppColors.error,
              onTap: () => HapticFeedback.heavyImpact(),
            ),
          ),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.question(),
              iconColor: appTheme.onSurfaceVariant,
              label: l10n.helpSupport,
              trailing: PhosphorIcon(PhosphorIcons.caretRight(), size: 18.sp, color: appTheme.onSurfaceVariant),
              onTap: () {
                HapticFeedback.selectionClick();
                context.push('/profile/help');
              },
            ),
          ),
          FadeSlide(
            child: _SettingsTile(
              icon: PhosphorIcons.signOut(),
              iconColor: AppColors.error,
              label: l10n.logout,
              labelColor: AppColors.error,
              onTap: () => HapticFeedback.heavyImpact(),
            ),
          ),
          SizedBox(height: 24.h),
          Center(
            child: Text(
              l10n.profile_version('1.0.0'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: appTheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
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
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.dailyGoal,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
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

  void _showLanguagePicker(BuildContext context, WidgetRef ref, {required bool isNative, required AppLocalizations l10n}) {
    HapticFeedback.selectionClick();
    final languages = isNative
        ? [
            _LangOpt(code: 'zh', name: l10n.langNameZhCn),
            _LangOpt(code: 'zh_TW', name: l10n.langNameZhTw),
            _LangOpt(code: 'en', name: l10n.langNameEn),
            _LangOpt(code: 'ja', name: l10n.langNameJa),
            _LangOpt(code: 'ko', name: l10n.langNameKo),
            _LangOpt(code: 'es', name: l10n.langNameEs),
            _LangOpt(code: 'fr', name: l10n.langNameFr),
            _LangOpt(code: 'de', name: l10n.langNameDe),
            _LangOpt(code: 'ar', name: l10n.langNameAr),
          ]
        : [
            _LangOpt(code: 'en', name: l10n.langNameEn),
            _LangOpt(code: 'ja', name: l10n.langNameJa),
            _LangOpt(code: 'ko', name: l10n.langNameKo),
            _LangOpt(code: 'es', name: l10n.langNameEs),
            _LangOpt(code: 'fr', name: l10n.langNameFr),
            _LangOpt(code: 'de', name: l10n.langNameDe),
            _LangOpt(code: 'ar', name: l10n.langNameAr),
          ];
    final locale = ref.read(localeProvider);
    final current = isNative
        ? (locale.languageCode == 'zh' && locale.countryCode == 'TW' ? 'zh_TW' : locale.languageCode)
        : ref.read(userProvider).learningLanguage;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: isNative ? 0.62 : 0.42,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (_, scrollController) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isNative ? l10n.nativeLanguage : l10n.learningLanguage,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: languages.map((lang) => ListTile(
                    title: Text(lang.name),
                    trailing: lang.code == current
                        ? PhosphorIcon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), color: AppColors.primary)
                        : null,
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      final service = LanguageService(ref);
                      if (isNative) {
                        await service.setNativeLanguage(lang.code);
                      } else {
                        service.setLearningLanguage(lang.code);
                      }
                      if (context.mounted) Navigator.pop(context);
                    },
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _LangOpt {
  final String code;
  final String name;
  const _LangOpt({required this.code, required this.name});
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
      child: Row(
        children: [
          Container(width: 18, height: 3, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: appTheme.harborIconFill,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final PhosphorIconData icon;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final Color? labelColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.subtitle,
    this.trailing,
    this.labelColor,
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
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
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
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: appTheme.border, width: 1),
              ),
              child: PhosphorIcon(icon, size: 16.sp, color: appTheme.harborIconFill),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: labelColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: appTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
