import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/config/points_config.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/user.dart';
import 'package:instalingo/models/vocab_card.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/providers/vocab_deck_provider.dart';
import 'package:instalingo/screens/swipe/tutorial_overlay.dart';
import 'package:instalingo/screens/swipe/word_card.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Full-screen swipe interface for vocabulary cards.
///
/// TikTok-style card swiper with Busan Harbor dark navy theme.
/// Right = save, Left = already knew, Up = next/skip.
class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});

  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen>
    with TickerProviderStateMixin {
  final CardSwiperController _swiperController = CardSwiperController();
  late List<VocabCard> _cards;
  int _currentIndex = 0;
  int _todayCount = 0;
  int _savedCount = 0;
  int _xpEarned = 0;
  int _gemsEarned = 0;
  bool _isLoading = true;
  bool _showTutorial = false;
  bool _isFlipped = false;

  late AnimationController _heartController;
  late AnimationController _skipController;

  @override
  void initState() {
    super.initState();
    _cards = [];
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _skipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _checkTutorial();
  }

  Future<void> _checkTutorial() async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    final shown = prefs.getBool('swipe_tutorial_shown') ?? false;
    if (!shown && mounted) {
      setState(() => _showTutorial = true);
    }
  }

  @override
  void dispose() {
    _swiperController.dispose();
    _heartController.dispose();
    _skipController.dispose();
    super.dispose();
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (previousIndex >= _cards.length) return false;

    final card = _cards[previousIndex];
    final user = ref.read(userProvider.notifier);

    HapticFeedback.mediumImpact();

    switch (direction) {
      case CardSwiperDirection.right:
        // Save card
        user.saveWord(card.id);
        user.addXp(PointsConfig.cardsSavedWorth);
        _xpEarned += PointsConfig.cardsSavedWorth;
        _savedCount++;
        _heartController.forward(from: 0);
        break;

      case CardSwiperDirection.left:
        // Already knew
        user.markAlreadyKnew(card.id);
        _skipController.forward(from: 0);
        break;

      case CardSwiperDirection.top:
        // Next / skip
        break;

      default:
        break;
    }

    user.incrementCardsSwiped();
    user.addXp(PointsConfig.cardSwipedWorth);
    _xpEarned += PointsConfig.cardSwipedWorth;
    _todayCount++;
    _currentIndex = currentIndex ?? _cards.length;
    _isFlipped = false;

    if (_currentIndex >= _cards.length) {
      _onComplete();
    }

    return true;
  }

  void _onComplete() {
    final user = ref.read(userProvider.notifier);
    user.addXp(PointsConfig.dailyGoalWorth);
    user.addGems(PointsConfig.gemPerDay);
    user.incrementStreak();
    _xpEarned += PointsConfig.dailyGoalWorth;
    _gemsEarned += PointsConfig.gemPerDay;

    context.pushReplacement('/swipe/complete', extra: {
      'cardsSwiped': _todayCount,
      'xpEarned': _xpEarned,
      'gemsEarned': _gemsEarned,
    });
  }

  void _onFlip() {
    HapticFeedback.selectionClick();
    setState(() => _isFlipped = !_isFlipped);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    final _ = ref.watch(currentDeckProvider);
    final user = ref.watch(userProvider);

    // Load deck
    ref.listen(currentDeckProvider, (_, next) {
      next.whenData((deck) {
        if (_isLoading && mounted) {
          setState(() {
            _cards = _filterCards(deck.cards, user);
            _isLoading = false;
          });
        }
      });
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: appTheme.harborNavyDeep,
        body: SafeArea(
          child: _isLoading
              ? _buildLoading(appTheme, l10n)
              : _cards.isEmpty
                  ? _buildEmpty(appTheme, l10n)
                  : _buildSwiper(appTheme, l10n, user),
        ),
      ),
    );
  }

  List<VocabCard> _filterCards(List<VocabCard> cards, UserProfile user) {
    return cards
        .where((c) =>
            !user.alreadyKnewWords.contains(c.id))
        .toList()
      ..shuffle(Random(DateTime.now().millisecondsSinceEpoch));
  }

  Widget _buildLoading(AppThemeExtension appTheme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 44.w,
            height: 44.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(BusanHarborTokens.orange),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            l10n.swipeLoadingCards,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: appTheme.harborInkOnNavyMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(AppThemeExtension appTheme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
            size: 56.sp,
            color: BusanHarborTokens.mint,
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.swipeAllCaughtUp,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: appTheme.harborInkOnNavy,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.swipeSeenAllCards,
            style: TextStyle(
              fontSize: 13.sp,
              color: appTheme.harborInkOnNavyMuted,
            ),
          ),
          SizedBox(height: 24.h),
          OutlinedButton(
            onPressed: () => context.go('/home'),
            child: Text(
              l10n.swipeBackToHome,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwiper(AppThemeExtension appTheme, AppLocalizations l10n, UserProfile user) {
    final remaining = _cards.length - _currentIndex;
    final progress = _cards.isNotEmpty ? _currentIndex / _cards.length : 0.0;

    return Stack(
      children: [
        // Card swiper
        Column(
          children: [
            // Stats bar
            _buildStatsBar(appTheme, l10n, user, remaining),
            // Progress indicator
            _buildProgressBar(appTheme, l10n, progress),

            // Swiper
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: CardSwiper(
                  controller: _swiperController,
                  cardsCount: _cards.length,
                  allowedSwipeDirection: AllowedSwipeDirection.only(
                    left: true,
                    right: true,
                    up: true,
                  ),
                  onSwipe: _onSwipe,
                  numberOfCardsDisplayed: 3,
                  backCardOffset: Offset(0, 28.h),
                  padding: EdgeInsets.zero,
                  cardBuilder: (context, index, horizontalOffset, verticalOffset) {
                    if (index >= _cards.length) {
                      return const SizedBox.shrink();
                    }
                    return WordCard(
                      card: _cards[index],
                      showBack: index == _currentIndex && _isFlipped,
                      onTap: index == _currentIndex ? _onFlip : null,
                    );
                  },
                ),
              ),
            ),

            // Bottom counter bar
            _buildBottomBar(appTheme, l10n, user, remaining),
          ],
        ),

        // Heart animation overlay (right swipe)
        AnimatedBuilder(
          animation: _heartController,
          builder: (_, __) {
            if (_heartController.value == 0) return const SizedBox.shrink();
            return Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Opacity(
                    opacity: 1 - _heartController.value,
                    child: Transform.scale(
                      scale: 1 + _heartController.value * 1.5,
                      child: PhosphorIcon(
                        PhosphorIcons.heart(PhosphorIconsStyle.fill),
                        size: 80.sp,
                        color: BusanHarborTokens.coral,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Check animation overlay (left swipe)
        AnimatedBuilder(
          animation: _skipController,
          builder: (_, __) {
            if (_skipController.value == 0) return const SizedBox.shrink();
            return Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Opacity(
                    opacity: 1 - _skipController.value,
                    child: Transform.scale(
                      scale: 1 + _skipController.value * 1.5,
                      child: PhosphorIcon(
                        PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                        size: 80.sp,
                        color: BusanHarborTokens.mint,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Tutorial overlay
        if (_showTutorial)
          TutorialOverlay(
            onDismiss: () => setState(() => _showTutorial = false),
          ),
      ],
    );
  }

  Widget _buildStatsBar(
      AppThemeExtension appTheme, AppLocalizations l10n, UserProfile user, int remaining) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          GestureDetector(
            onTap: () => context.go('/home'),
            child: PhosphorIcon(
              PhosphorIcons.x(PhosphorIconsStyle.bold),
              size: 22.sp,
              color: appTheme.harborInkOnNavyMuted,
            ),
          ),
          // Today count
          Text(
            '${l10n.swipeToday} $_todayCount',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: appTheme.harborInkOnNavy,
              letterSpacing: 0.5,
            ),
          ),
          // Right spacer
          SizedBox(width: 22.w),
        ],
      ),
    );
  }

  Widget _buildProgressBar(AppThemeExtension appTheme, AppLocalizations l10n, double progress) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              backgroundColor: BusanHarborTokens.navyMid,
              valueColor:
                  const AlwaysStoppedAnimation(BusanHarborTokens.orange),
            ),
          ),
          SizedBox(height: 4.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_cards.length - _currentIndex} ${l10n.swipeRemaining}',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: appTheme.harborInkOnNavyMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
      AppThemeExtension appTheme, AppLocalizations l10n, UserProfile user, int remaining) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 7-day streak
          _statItem(
            icon: PhosphorIcons.fire(PhosphorIconsStyle.fill),
            label: '${user.streak}${l10n.swipeDayStreak}',
            color: BusanHarborTokens.orange,
            appTheme: appTheme,
          ),
          // Saved count
          _statItem(
            icon: PhosphorIcons.heart(PhosphorIconsStyle.fill),
            label: '${_savedCount + user.savedWords.length} ${l10n.swipeSaved}',
            color: BusanHarborTokens.coral,
            appTheme: appTheme,
          ),
          // XP
          _statItem(
            icon: PhosphorIcons.lightning(PhosphorIconsStyle.fill),
            label: '${user.xp} ${l10n.swipeXp}',
            color: BusanHarborTokens.sea,
            appTheme: appTheme,
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required PhosphorIconData icon,
    required String label,
    required Color color,
    required AppThemeExtension appTheme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PhosphorIcon(icon, size: 16.sp, color: color),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: appTheme.harborInkOnNavyMuted,
          ),
        ),
      ],
    );
  }
}
