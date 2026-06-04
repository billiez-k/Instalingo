import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:instalingo/theme/app_theme.dart';

/// Shared Busan Harbor primitives — reused across screens so that the
/// editorial maritime language stays consistent.

/// A flat, centred navy header used as the masthead on secondary screens.
class HarborAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? overline;
  final String title;
  final List<Widget> actions;
  final VoidCallback? onBack;
  final bool showBack;

  const HarborAppBar({
    super.key,
    this.overline,
    required this.title,
    this.actions = const [],
    this.onBack,
    this.showBack = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(96.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    return Material(
      color: appTheme.harborNavy,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBack)
                IconButton(
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  icon: PhosphorIcon(
                    PhosphorIcons.caretLeft(PhosphorIconsStyle.bold),
                    color: appTheme.harborInkOnNavy,
                    size: 20.sp,
                  ),
                )
              else
                SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (overline != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Text(
                          overline!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                            color: appTheme.harborInkOnNavyMuted,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    Text(
                      title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: appTheme.harborInkOnNavy,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}

/// A flat outlined card with an accent border — used for stat tiles.
class HarborOutlinedTile extends StatelessWidget {
  final Color accent;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const HarborOutlinedTile({
    super.key,
    required this.accent,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: accent, width: 1.4),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(borderRadius: BorderRadius.circular(4.r), onTap: onTap, child: card);
  }
}

/// A solid eyebrow / pill label.
class HarborEyebrow extends StatelessWidget {
  final String text;
  final Color? color;
  final double letterSpacing;

  const HarborEyebrow({super.key, required this.text, this.color, this.letterSpacing = 2.0});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w800,
        color: color ?? appTheme.onSurfaceVariant,
        letterSpacing: letterSpacing,
      ),
    );
  }
}

/// A small horizontal accent strip — used to underline section headers
/// like a ship hull line.
class HarborAccentBar extends StatelessWidget {
  final double width;
  final Color? color;
  const HarborAccentBar({super.key, this.width = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: 3,
      color: color ?? AppColors.primary,
    );
  }
}

/// A pill button used on dark navy surfaces.
class HarborGhostButton extends StatelessWidget {
  final String label;
  final PhosphorIconData? icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? background;

  const HarborGhostButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final fg = color ?? appTheme.harborInkOnNavy;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: background ?? Colors.transparent,
          borderRadius: BorderRadius.circular(2.r),
          border: Border.all(color: fg.withValues(alpha: 0.5), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              PhosphorIcon(icon!, size: 14.sp, color: fg),
              SizedBox(width: 6.w),
            ],
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: fg,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
