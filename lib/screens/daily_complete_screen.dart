import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// Celebration screen shown after completing the daily goal.
///
/// Displays stats, confetti, and a share achievement button.
class DailyCompleteScreen extends ConsumerStatefulWidget {
  final int cardsSwiped;
  final int cardsSaved;
  final int xpEarned;
  final int gemsEarned;

  const DailyCompleteScreen({
    super.key,
    this.cardsSwiped = 0,
    this.cardsSaved = 0,
    this.xpEarned = 0,
    this.gemsEarned = 0,
  });

  @override
  ConsumerState<DailyCompleteScreen> createState() =>
      _DailyCompleteScreenState();
}

class _DailyCompleteScreenState extends ConsumerState<DailyCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.elasticOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );
    _entranceController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      HapticFeedback.heavyImpact();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(userProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: appTheme.harborNavyDeep,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Success icon
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        color: BusanHarborTokens.mint.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: BusanHarborTokens.mint.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: PhosphorIcon(
                          PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                          size: 50.sp,
                          color: BusanHarborTokens.mint,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // Headline
                    Text(
                      l10n.dailyCompleteTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        color: appTheme.harborInkOnNavy,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.dailyCompleteTitle,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: appTheme.harborInkOnNavyMuted,
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Stats grid
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatBox(
                              icon: PhosphorIcons.cards(PhosphorIconsStyle.fill),
                              value: '${widget.cardsSwiped}',
                              label: l10n.dailyCompleteCardsLabel,
                              color: BusanHarborTokens.orange,
                              appTheme: appTheme,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _StatBox(
                              icon: PhosphorIcons.heart(PhosphorIconsStyle.fill),
                              value: '${widget.cardsSaved}',
                              label: l10n.dailyCompleteSavedLabel,
                              color: BusanHarborTokens.coral,
                              appTheme: appTheme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatBox(
                              icon: PhosphorIcons.lightning(PhosphorIconsStyle.fill),
                              value: '+${widget.xpEarned}',
                              label: l10n.swipeXp,
                              color: BusanHarborTokens.sea,
                              appTheme: appTheme,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _StatBox(
                              icon: PhosphorIcons.coin(PhosphorIconsStyle.fill),
                              value: '+${widget.gemsEarned}',
                              label: l10n.dailyCompleteGemsLabel,
                              color: BusanHarborTokens.brass,
                              appTheme: appTheme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Streak
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: BusanHarborTokens.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: BusanHarborTokens.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PhosphorIcon(
                            PhosphorIcons.fire(PhosphorIconsStyle.fill),
                            size: 22.sp,
                            color: BusanHarborTokens.orange,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            l10n.dayStreakCount(user.streak),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: BusanHarborTokens.orange,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () => context.go('/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BusanHarborTokens.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          l10n.dailyCompleteContinue,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Share achievement button
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: OutlinedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          final l10n = AppLocalizations.of(context);
                          Share.share(
                            '🎯 ${l10n.dailyCompleteTitle}! '
                            '${l10n.dailyCompleteCardsSwiped}: ${widget.cardsSwiped} | '
                            '+${widget.xpEarned} XP | '
                            '+${widget.gemsEarned} ${l10n.dailyCompleteGemsLabel}\n\n'
                            '${l10n.viaInstalingo}',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: appTheme.harborInkOnNavy,
                          side: BorderSide(
                            color: appTheme.harborInkOnNavyMuted
                                .withValues(alpha: 0.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PhosphorIcon(
                              PhosphorIcons.shareNetwork(
                                  PhosphorIconsStyle.regular),
                              size: 18.sp,
                              color: appTheme.harborInkOnNavy,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              l10n.dailyCompleteShare,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                color: appTheme.harborInkOnNavy,
                                letterSpacing: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final PhosphorIconData icon;
  final String value;
  final String label;
  final Color color;
  final AppThemeExtension appTheme;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: PhosphorIcon(icon, size: 26.sp, color: color),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: appTheme.harborInkOnNavy,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: appTheme.harborInkOnNavyMuted,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
