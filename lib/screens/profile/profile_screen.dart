import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/user.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Busan Harbor — Profile screen.
///
/// Navy masthead slab with eyebrow, headline, identity row, and a navy
/// stat strip flush against its bottom. Body is a series of editorial
/// menu sections — each section opens with an orange accent rail +
/// allcaps eyebrow, then a column of bordered list rows separated by
/// hairline rules.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _ProfileHeader(user: user)),
          SliverToBoxAdapter(child: SizedBox(height: 22.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  _MenuSection(
                    title: l10n.statsTitle,
                    items: [
                      _MenuItem(
                        icon: PhosphorIcons.chartBar(PhosphorIconsStyle.bold),
                        label: l10n.statsTitle,
                        onTap: () => context.push('/profile/stats'),
                      ),
                      _MenuItem(
                        icon: PhosphorIcons.trophy(PhosphorIconsStyle.bold),
                        label: l10n.achievementsTitle,
                        onTap: () => context.push('/profile/achievements'),
                      ),
                      _MenuItem(
                        icon: PhosphorIcons.graduationCap(PhosphorIconsStyle.bold),
                        label: l10n.coursePath,
                        onTap: () => context.push('/collections'),
                      ),
                      _MenuItem(
                        icon: PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                        label: l10n.studyPlan,
                        onTap: () => context.push('/profile/stats'),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                SizedBox(height: 22.h),
                  _MenuSection(
                    title: l10n.settingsTitle,
                    items: [
                      _MenuItem(
                        icon: PhosphorIcons.crown(PhosphorIconsStyle.fill),
                        label: l10n.paywallTitle,
                        badge: l10n.profile_proBadge,
                        accent: true,
                        onTap: () => context.push('/paywall'),
                      ),
                      _MenuItem(
                        icon: PhosphorIcons.creditCard(PhosphorIconsStyle.bold),
                        label: l10n.subscription,
                        onTap: () => context.push('/paywall'),
                      ),
                      _MenuItem(
                        icon: PhosphorIcons.gear(PhosphorIconsStyle.bold),
                        label: l10n.settingsTitle,
                        onTap: () => context.push('/profile/settings'),
                      ),
                      _MenuItem(
                        icon: PhosphorIcons.question(PhosphorIconsStyle.bold),
                        label: l10n.helpSupport,
                        onTap: () => context.push('/profile/help'),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserProfile user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final displayName = user.displayName.isEmpty ? l10n.defaultDisplayName : user.displayName;
    final initials = displayName.split(' ').where((s) => s.isNotEmpty).map((s) => s[0]).take(2).join('').toUpperCase();
    final level = 1 + (user.xp / 200).floor();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: appTheme.harborNavy),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(22.w, 56.h, 22.w, 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.profile.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: appTheme.harborInkOnNavyMuted,
                        letterSpacing: 2.6,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(width: 4, height: 4, decoration: BoxDecoration(color: appTheme.harborInkOnNavyMuted, shape: BoxShape.circle)),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        l10n.profile_learningStatus(
                          user.learningLanguage.toUpperCase(),
                          user.totalCardsSwiped.toString(),
                        ).toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: appTheme.harborInkOnNavyMuted,
                          letterSpacing: 2.4,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: AppColors.primary, width: 1.6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        displayName,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: appTheme.harborInkOnNavy,
                          height: 1.05,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    _ActionPill(
                      label: l10n.editProfile,
                      icon: PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
                      filled: true,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        context.push('/profile/edit');
                      },
                    ),
                    if (user.isPro) ...[
                      SizedBox(width: 8.w),
                      _ActionPill(
                        label: l10n.profile_superBadge,
                        icon: PhosphorIcons.crown(PhosphorIconsStyle.fill),
                        filled: false,
                        accent: AppColors.gold,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Stat strip — pinned to bottom of masthead like a deck rail.
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.18), width: 1),
              ),
            ),
            child: Row(
              children: [
                _MastheadStat(
                  icon: PhosphorIcons.flame(PhosphorIconsStyle.fill),
                  value: '${user.streak}',
                  label: l10n.dayStreak,
                  color: AppColors.primary,
                  isLast: false,
                ),
                _MastheadStat(
                  icon: PhosphorIcons.lightning(PhosphorIconsStyle.fill),
                  value: '${user.xp}',
                  label: l10n.totalXP,
                  color: appTheme.harborInkOnNavy,
                  isLast: false,
                ),
                _MastheadStat(
                  icon: PhosphorIcons.diamond(PhosphorIconsStyle.fill),
                  value: '${user.gems}',
                  label: l10n.gems,
                  color: appTheme.harborInkOnNavy,
                  isLast: false,
                ),
                _MastheadStat(
                  icon: PhosphorIcons.star(PhosphorIconsStyle.fill),
                  value: '${l10n.levelAbbreviation} $level',
                  label: l10n.profile_level,
                  color: appTheme.harborInkOnNavy,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final PhosphorIconData icon;
  final bool filled;
  final Color? accent;
  final VoidCallback? onTap;
  const _ActionPill({
    required this.label,
    required this.icon,
    required this.filled,
    this.accent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = accent ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: filled ? c : Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: filled ? null : Border.all(color: c, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(icon, size: 12.sp, color: filled ? Colors.white : c),
            SizedBox(width: 6.w),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: filled ? Colors.white : c,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MastheadStat extends StatelessWidget {
  final PhosphorIconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isLast;
  const _MastheadStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  right: BorderSide(color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.18), width: 1),
                ),
        ),
        child: Column(
          children: [
            PhosphorIcon(icon, size: 16.sp, color: color),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: appTheme.harborInkOnNavy,
                letterSpacing: 0.4,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w800,
                color: appTheme.harborInkOnNavyMuted,
                letterSpacing: 1.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 10.h),
          child: Row(
            children: [
              Container(width: 22.w, height: 3, color: AppColors.primary),
              SizedBox(width: 10.w),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: appTheme.harborIconFill,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: appTheme.border),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                items[i],
                if (i != items.length - 1)
                  Divider(height: 1, color: appTheme.borderLight, indent: 18.w, endIndent: 18.w),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final PhosphorIconData icon;
  final String label;
  final String? badge;
  final bool accent;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.badge,
    this.accent = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final iconColor = accent ? AppColors.primary : appTheme.harborNavy;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
              alignment: Alignment.center,
              child: PhosphorIcon(icon, size: 16.sp, color: iconColor == appTheme.harborNavy ? appTheme.harborIconFill : iconColor),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: appTheme.harborNavy,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(3.r),
                ),
                child: Text(
                  badge!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
            PhosphorIcon(
              PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
              size: 14.sp,
              color: appTheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
