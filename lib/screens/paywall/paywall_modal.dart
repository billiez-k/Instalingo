import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PaywallModal extends ConsumerStatefulWidget {
  const PaywallModal({super.key});

  @override
  ConsumerState<PaywallModal> createState() => _PaywallModalState();
}

class _PaywallModalState extends ConsumerState<PaywallModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      )),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
          border: Border(top: BorderSide(color: context.appTheme.harborNavy, width: 1.4)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Header
                Text(
                  l10n.unlockSuper.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: BusanHarborTokens.orange,
                    letterSpacing: 3.0,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.getUnlimitedLearning,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: context.appTheme.harborNavy,
                  ),
                ),
                SizedBox(height: 20.h),

                // --- PRO Tier (8 HKD) ---
                _TierCard(
                  tier: 'Pro',
                  price: 'HK\$8',
                  period: l10n.perMonth,
                  badge: l10n.mostPopular,
                  features: [
                    _Feature(PhosphorIcons.books(PhosphorIconsStyle.fill), l10n.allJlptLevels),
                    _Feature(PhosphorIcons.chatCircle(PhosphorIconsStyle.fill), l10n.realJapaneseDeck),
                    _Feature(PhosphorIcons.fire(PhosphorIconsStyle.fill), l10n.spicySlangDeck),
                    _Feature(PhosphorIcons.bookmarks(PhosphorIconsStyle.fill), l10n.unlimitedSavedWords),
                    _Feature(PhosphorIcons.fileArrowDown(PhosphorIconsStyle.fill), l10n.exportAnkiCsv),
                    _Feature(PhosphorIcons.xCircle(PhosphorIconsStyle.fill), l10n.noAds),
                  ],
                  isHighlighted: true,
                  onTap: () => _purchase('pro_monthly'),
                ),
                SizedBox(height: 10.h),

                // --- Lifetime (188 HKD) ---
                _TierCard(
                  tier: l10n.lifetimeOption,
                  price: 'HK\$188',
                  period: l10n.onceOnly,
                  features: [
                    _Feature(PhosphorIcons.infinity(PhosphorIconsStyle.fill), l10n.everythingInPro),
                    _Feature(PhosphorIcons.crown(PhosphorIconsStyle.fill), l10n.lifetimeProAccess),
                    _Feature(PhosphorIcons.gift(PhosphorIconsStyle.fill), l10n.allFutureFeatures),
                    _Feature(PhosphorIcons.trendUp(PhosphorIconsStyle.fill), l10n.bestValueLongTerm),
                  ],
                  onTap: () => _purchase('lifetime'),
                ),
                SizedBox(height: 12.h),

                // --- PRO+ Tier (38 HKD) ---
                _TierCard(
                  tier: 'Pro+',
                  price: 'HK\$38',
                  period: l10n.perMonth,
                  features: [
                    _Feature(PhosphorIcons.crown(PhosphorIconsStyle.fill), l10n.everythingInPro),
                    _Feature(PhosphorIcons.skull(PhosphorIconsStyle.fill), l10n.wildDeckAdults),
                    _Feature(PhosphorIcons.brain(PhosphorIconsStyle.fill), l10n.aiWordExplanations),
                    _Feature(PhosphorIcons.speakerHigh(PhosphorIconsStyle.fill), l10n.enhancedAudioPron),
                    _Feature(PhosphorIcons.star(PhosphorIconsStyle.fill), l10n.earlyAccessFeatures),
                  ],
                  onTap: () => _purchase('pro_plus_monthly'),
                ),
                SizedBox(height: 16.h),

                // One-time purchases
                Text(
                  l10n.oneTimePurchases.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: context.appTheme.onSurfaceVariant,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _IAPChip(
                      icon: PhosphorIcons.shieldCheck(PhosphorIconsStyle.fill),
                      label: l10n.streakShieldPurchase,
                      price: 'HK\$8',
                      onTap: () => _purchase('streak_shield'),
                    ),
                    _IAPChip(
                      icon: PhosphorIcons.flame(PhosphorIconsStyle.fill),
                      label: l10n.spicyPackPurchase,
                      price: 'HK\$8',
                      onTap: () => _purchase('spicy_pack'),
                    ),
                    _IAPChip(
                      icon: PhosphorIcons.paintBrush(PhosphorIconsStyle.fill),
                      label: l10n.customThemePurchase,
                      price: 'HK\$8',
                      onTap: () => _purchase('theme_pack'),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Dismiss
                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      l10n.maybeLater,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _purchase(String offering) {
    HapticFeedback.mediumImpact();
    try {
      if (offering.startsWith('pro')) {
        ref.read(userProvider.notifier).upgradeToPro();
      }
      // Additional IAP handling via RevenueCat would go here
    } catch (_) {
      // Purchase failed
    }
    if (context.mounted) context.pop();
  }
}

class _TierCard extends StatelessWidget {
  final String tier;
  final String price;
  final String period;
  final String? badge;
  final List<_Feature> features;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _TierCard({
    required this.tier,
    required this.price,
    required this.period,
    this.badge,
    required this.features,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isHighlighted
              ? BusanHarborTokens.orange.withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isHighlighted
                ? BusanHarborTokens.orange.withValues(alpha: 0.4)
                : appTheme.border,
            width: isHighlighted ? 1.4 : 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tier,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: appTheme.harborNavy,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: appTheme.harborNavy,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Text(
                            period,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: appTheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                ...features,
              ],
            ),
            if (badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: BusanHarborTokens.orange,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Text(
                    badge!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final PhosphorIconData icon;
  final String text;

  const _Feature(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          PhosphorIcon(icon, size: 14.sp, color: BusanHarborTokens.mint),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: context.appTheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IAPChip extends StatelessWidget {
  final PhosphorIconData icon;
  final String label;
  final String price;
  final VoidCallback onTap;

  const _IAPChip({
    required this.icon,
    required this.label,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: context.appTheme.border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(icon, size: 14.sp, color: BusanHarborTokens.orange),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: context.appTheme.harborNavy,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              price,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: BusanHarborTokens.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
