import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/services/notification_service.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  NotificationService? _notificationService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initNotifications();
    });
  }

  void _initNotifications() {
    _notificationService = NotificationService(ref, context);
    _notificationService!.start();
  }

  @override
  void dispose() {
    _notificationService?.dispose();
    super.dispose();
  }
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/learn')) return 0;
    if (location.startsWith('/chill')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/learn');
      case 1:
        context.go('/chill');
      case 2:
        context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final currentIndex = _getCurrentIndex(context);

    // React to notification/reminder setting changes
    ref.listen(userProvider.select((u) => u.notificationsEnabled), (_, __) {
      _notificationService?.refresh();
    });
    ref.listen(userProvider.select((u) => u.reminderEnabled), (_, __) {
      _notificationService?.refresh();
    });

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: appTheme.border, width: 1),
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
                  icon: PhosphorIcons.bookOpen(),
                  activeIcon: PhosphorIcons.bookOpen(PhosphorIconsStyle.fill),
                  label: l10n.learn,
                  isActive: currentIndex == 0,
                  onTap: () => _onItemTapped(context, 0),
                ),
                _NavItem(
                  icon: PhosphorIcons.waves(),
                  activeIcon: PhosphorIcons.waves(PhosphorIconsStyle.fill),
                  label: l10n.chill,
                  isActive: currentIndex == 1,
                  onTap: () => _onItemTapped(context, 1),
                ),
                _NavItem(
                  icon: PhosphorIcons.user(),
                  activeIcon: PhosphorIcons.user(PhosphorIconsStyle.fill),
                  label: l10n.profile,
                  isActive: currentIndex == 2,
                  onTap: () => _onItemTapped(context, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    final activeColor = AppColors.primary;
    final inactiveColor = appTheme.onSurfaceVariant;
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 88.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicator strip above the active item — harbor sunrise marker
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 28.w : 0,
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
