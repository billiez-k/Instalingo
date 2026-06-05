import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Bottom navigation shell with 4 tabs.
///
/// Home, Review, Collections, Profile -- using Phosphor icons
/// with outline/fill variants for active state.
class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: appTheme.harborNavy,
          border: Border(
            top: BorderSide(
              color: BusanHarborTokens.navySoft.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _NavItem(
                  icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
                  activeIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
                  label: l10n.navHome,
                  isActive: currentIndex == 0,
                  onTap: () => context.go('/home'),
                ),
                _NavItem(
                  icon: PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.regular),
                  activeIcon: PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.fill),
                  label: l10n.navReview,
                  isActive: currentIndex == 1,
                  onTap: () => context.go('/review'),
                ),
                _NavItem(
                  icon: PhosphorIcons.bookmarks(PhosphorIconsStyle.regular),
                  activeIcon: PhosphorIcons.bookmarks(PhosphorIconsStyle.fill),
                  label: l10n.navCollections,
                  isActive: currentIndex == 2,
                  onTap: () => context.go('/collections'),
                ),
                _NavItem(
                  icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
                  activeIcon: PhosphorIcons.user(PhosphorIconsStyle.fill),
                  label: l10n.navProfile,
                  isActive: currentIndex == 3,
                  onTap: () => context.go('/profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/review')) return 1;
    if (location.startsWith('/collections')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }
}

class _NavItem extends StatelessWidget {
  final PhosphorIconData icon;
  final PhosphorIconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final activeColor = BusanHarborTokens.orange;
    final inactiveColor = appTheme.harborInkOnNavyMuted;
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 24.w : 0,
              height: 3,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 6.h),
            PhosphorIcon(
              isActive ? activeIcon : icon,
              size: 22.sp,
              color: color,
            ),
            SizedBox(height: 4.h),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
