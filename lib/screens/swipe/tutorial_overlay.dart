import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// First-time tutorial overlay showing swipe gesture hints.
///
/// Shows on first 3 cards for new users. Uses SharedPreferences to
/// persist whether the tutorial has been completed.
class TutorialOverlay extends ConsumerStatefulWidget {
  final VoidCallback onDismiss;

  const TutorialOverlay({super.key, required this.onDismiss});

  @override
  ConsumerState<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends ConsumerState<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    HapticFeedback.mediumImpact();
    await _controller.reverse();
    if (!mounted) return;
    try {
      final prefs = await ref.read(sharedPrefsProvider.future);
      await prefs.setBool('swipe_tutorial_shown', true);
    } catch (_) {
      // Tutorial dismissed regardless of persistence
    }
    if (mounted) widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.appTheme;
    final l10n = AppLocalizations.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: _dismiss,
        child: Container(
          color: BusanHarborTokens.navyDeep.withValues(alpha: 0.85),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Tap to flip
              _GestureHint(
                icon: PhosphorIcons.handTap(PhosphorIconsStyle.bold),
                label: l10n.tutorialTapToFlip,
                description: l10n.tutorialTapToFlipDesc,
                color: BusanHarborTokens.sea,
              ),
              SizedBox(height: 24.h),

              // Save button
              _GestureHint(
                icon: PhosphorIcons.heart(PhosphorIconsStyle.fill),
                label: l10n.tutorialSave,
                description: l10n.tutorialSaveDesc,
                color: BusanHarborTokens.coral,
              ),
              SizedBox(height: 24.h),

              // Already Knew button
              _GestureHint(
                icon: PhosphorIcons.check(PhosphorIconsStyle.bold),
                label: l10n.tutorialSkip,
                description: l10n.tutorialSkipDesc,
                color: BusanHarborTokens.mint,
              ),
              SizedBox(height: 24.h),

              // Next card
              _GestureHint(
                icon: PhosphorIcons.arrowUp(PhosphorIconsStyle.bold),
                label: l10n.tutorialNextCard,
                description: l10n.tutorialNextCardDesc,
                color: Colors.white,
              ),

              const Spacer(flex: 2),

              // Tap hint
              GestureDetector(
                onTap: _dismiss,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: BusanHarborTokens.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: BusanHarborTokens.orange.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    l10n.gotIt,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: BusanHarborTokens.orange,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _GestureHint extends StatelessWidget {
  final PhosphorIconData icon;
  final String label;
  final String description;
  final Color color;

  const _GestureHint({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.2),
          ),
          child: Center(
            child: PhosphorIcon(
              icon,
              size: 28.sp,
              color: color,
            ),
          ),
        ),
        SizedBox(width: 16.w),

        SizedBox(
          width: 200.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: appTheme.harborInkOnNavy,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: appTheme.harborInkOnNavyMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
