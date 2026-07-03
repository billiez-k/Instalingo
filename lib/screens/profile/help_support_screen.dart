import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final sections = [
      _HelpSection(
        title: l10n.profile_gettingStarted,
        items: [
          _HelpItem(
            icon: PhosphorIcons.rocketLaunch(),
            title: l10n.profile_howDoIStart,
            description: l10n.profile_howDoIStartAnswer,
          ),
          _HelpItem(
            icon: PhosphorIcons.target(),
            title: l10n.profile_settingDailyGoals,
            description: l10n.profile_settingDailyGoalsAnswer,
          ),
          _HelpItem(
            icon: PhosphorIcons.bell(),
            title: l10n.profile_enableNotifications,
            description: l10n.profile_enableNotificationsAnswer,
          ),
        ],
      ),
      _HelpSection(
        title: l10n.profile_learningFeatures,
        items: [
          _HelpItem(
            icon: PhosphorIcons.chatCircleText(),
            title: l10n.profile_whatIsChillCorner,
            description: l10n.profile_whatIsChillCornerAnswer,
          ),
          _HelpItem(
            icon: PhosphorIcons.brain(),
            title: l10n.profile_aiConversationPractice,
            description: l10n.profile_aiConversationPracticeAnswer,
          ),
          _HelpItem(
            icon: PhosphorIcons.trophy(),
            title: l10n.profile_earningXPGems,
            description: l10n.profile_earningXPGemsAnswer,
          ),
        ],
      ),
      _HelpSection(
        title: l10n.profile_account,
        items: [
          _HelpItem(
            icon: PhosphorIcons.crown(),
            title: l10n.profile_instalingoSuperFAQ,
            description: l10n.profile_instalingoSuperFAQAnswer,
          ),
          _HelpItem(
            icon: PhosphorIcons.arrowsClockwise(),
            title: l10n.profile_resetProgressFAQ,
            description: l10n.profile_resetProgressFAQAnswer,
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.helpSupport),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          // Editorial search banner
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.primary, width: 1.4),
            ),
            child: Row(
              children: [
                Container(width: 18.w, height: 3, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  l10n.helpSupport.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    l10n.profile_browseTopics,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: context.appTheme.harborNavy,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          ...sections.map((section) => _SectionWidget(section: section)),
          SizedBox(height: 24.h),
          // Contact buttons
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                _launchEmail();
              },
              icon: PhosphorIcon(PhosphorIcons.envelope()),
              label: Text(
                l10n.profile_contactSupport,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                _launchUrl('https://instalingo.app/faq');
              },
              icon: PhosphorIcon(PhosphorIcons.globe()),
              label: Text(
                l10n.profile_visitHelpCenter,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Future<void> _launchEmail() async {
    try {
      final uri = Uri.parse('mailto:support@instalingo.app');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {
      // Silently handle — email client may not be available
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // Silently handle — browser may not be available
    }
  }
}

class _HelpSection {
  final String title;
  final List<_HelpItem> items;

  const _HelpSection({required this.title, required this.items});
}

class _HelpItem {
  final PhosphorIconData icon;
  final String title;
  final String description;

  const _HelpItem({required this.icon, required this.title, required this.description});
}

class _SectionWidget extends StatelessWidget {
  final _HelpSection section;

  const _SectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
          child: Row(
            children: [
              Container(width: 16.w, height: 3, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                section.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: appTheme.harborNavy,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
        ...section.items.map((item) => _HelpItemWidget(item: item)),
        SizedBox(height: 8.h),
      ],
    );
  }
}

class _HelpItemWidget extends StatelessWidget {
  final _HelpItem item;

  const _HelpItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Semantics(
      label: item.title,
      button: true,
      child: GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _showExplanation(context, item);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
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
              child: PhosphorIcon(item.icon, size: 16.sp, color: appTheme.harborIconFill),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                item.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appTheme.harborNavy,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            PhosphorIcon(
              PhosphorIcons.caretRight(),
              size: 16.sp,
              color: appTheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _showExplanation(BuildContext context, _HelpItem item) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PhosphorIcon(item.icon, size: 24.sp, color: AppColors.primary),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Semantics(
                  label: l10n.closeLabel,
                  button: true,
                  child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: PhosphorIcon(
                    PhosphorIcons.x(),
                    size: 24.sp,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.profile_gotIt,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
