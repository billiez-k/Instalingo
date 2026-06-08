import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/config/points_config.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/user.dart';
import 'package:instalingo/models/vocab_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/providers/vocab_deck_provider.dart';
import 'package:instalingo/screens/swipe/tutorial_overlay.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Instagram Reels-style vertical feed for vocabulary discovery.
///
/// Full-screen vertical scroll through word cards. Each card looks like
/// an Instagram post: image area with word overlay, caption area with
/// meaning + action buttons. Heart to save, Skip to mark as known.
/// Tap card body to flip for example sentences and tags.
class SwipeScreen extends ConsumerStatefulWidget {
  final String? targetWordId;
  const SwipeScreen({super.key, this.targetWordId});
  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late List<VocabCard> _cards;
  int _currentIndex = 0;
  int _todayCount = 0;
  int _savedCount = 0;
  int _xpEarned = 0;
  int _gemsEarned = 0;
  bool _isLoading = true;
  String? _loadError;
  bool _showTutorial = false;
  final Set<int> _flippedCards = {};
  final Set<int> _savedCards = {};
  final Set<int> _skippedCards = {};
  late AnimationController _heartController;

  @override
  void initState() {
    super.initState();
    _cards = [];
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pageController.addListener(_onPageChange);
    _checkTutorial();
  }

  void _onPageChange() {
    final newIndex = _pageController.page?.round() ?? _currentIndex;
    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
        _flippedCards.remove(_currentIndex);
      });
      _todayCount++;
      final un = ref.read(userProvider.notifier);
      un.incrementCardsSwiped();
      un.addXp(PointsConfig.cardSwipedWorth);
      _xpEarned += PointsConfig.cardSwipedWorth;
      if (_currentIndex >= _cards.length) _onComplete();
    }
  }

  Future<void> _checkTutorial() async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    final shown = prefs.getBool('swipe_tutorial_shown') ?? false;
    if (!shown && mounted) setState(() => _showTutorial = true);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChange);
    _pageController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  void _saveCard(int index) {
    if (_savedCards.contains(index)) return;
    final card = _cards[index];
    final un = ref.read(userProvider.notifier);
    un.saveWord(card.id);
    un.addXp(PointsConfig.cardsSavedWorth);
    _xpEarned += PointsConfig.cardsSavedWorth;
    _savedCount++;
    setState(() => _savedCards.add(index));
    HapticFeedback.mediumImpact();
    _heartController.forward(from: 0);
  }

  void _skipCard() {
    if (_skippedCards.contains(_currentIndex)) return;
    final card = _cards[_currentIndex];
    final un = ref.read(userProvider.notifier);
    un.markAlreadyKnew(card.id);
    setState(() => _skippedCards.add(_currentIndex));
    HapticFeedback.mediumImpact();
    _goNext();
  }

  void _flipCard() {
    HapticFeedback.selectionClick();
    setState(() {
      _flippedCards.contains(_currentIndex)
          ? _flippedCards.remove(_currentIndex)
          : _flippedCards.add(_currentIndex);
    });
  }

  void _goNext() {
    if (_currentIndex + 1 < _cards.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _flippedCards.remove(_currentIndex));
    } else {
      _onComplete();
    }
  }

  void _onComplete() {
    final un = ref.read(userProvider.notifier);
    un.addXp(PointsConfig.dailyGoalWorth);
    un.addGems(PointsConfig.gemPerDay);
    un.incrementStreak();
    _xpEarned += PointsConfig.dailyGoalWorth;
    _gemsEarned += PointsConfig.gemPerDay;
    if (mounted) {
      context.pushReplacement('/swipe/complete', extra: {
        'cardsSwiped': _todayCount,
        'cardsSaved': _savedCount,
        'xpEarned': _xpEarned,
        'gemsEarned': _gemsEarned,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context);
    final _ = ref.watch(currentDeckProvider);
    final user = ref.watch(userProvider);

    ref.listen(currentDeckProvider, (_, next) {
      next.when(
        loading: () {},
        error: (error, _) {
          if (mounted) {
            setState(() { _isLoading = false; _loadError = error.toString(); });
          }
        },
        data: (deck) {
          if (mounted) {
            final filtered = _filterCards(deck.cards, user);
            int startIndex = 0;
            if (widget.targetWordId != null) {
              final idx = filtered.indexWhere((c) => c.id == widget.targetWordId);
              if (idx >= 0) startIndex = idx;
            }
            setState(() {
              _cards = filtered;
              _currentIndex = startIndex;
              _flippedCards.clear();
              _savedCards.clear();
              _skippedCards.clear();
              _isLoading = false;
              _loadError = null;
            });
            if (startIndex > 0) {
              _pageController.jumpToPage(startIndex);
            }
          }
        },
      );
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isLoading
            ? _buildLoading(appTheme, l10n)
            : _loadError != null
                ? _buildError(appTheme, l10n)
                : _cards.isEmpty
                    ? _buildEmpty(appTheme, l10n)
                    : _buildFeed(appTheme, l10n, user),
      ),
    );
  }

  List<VocabCard> _filterCards(List<VocabCard> cards, UserProfile user) {
    return cards
        .where((c) => !user.alreadyKnewWords.contains(c.id))
        .toList()
      ..shuffle(Random(DateTime.now().millisecondsSinceEpoch));
  }

  Widget _buildLoading(AppThemeExtension appTheme, AppLocalizations l10n) => Shimmer.fromColors(
        baseColor: Colors.white10,
        highlightColor: Colors.white24,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Shimmer card placeholder mimicking Reels layout
          Container(
            width: 320.w,
            height: 260.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 24.h),
          Container(width: 200.w, height: 14.h, color: Colors.white),
          SizedBox(height: 12.h),
          Container(width: 140.w, height: 14.h, color: Colors.white),
          SizedBox(height: 28.h),
          Text(l10n.swipeLoadingCards,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white38)),
        ]),
      );

  Widget _buildError(AppThemeExtension appTheme, AppLocalizations l10n) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            PhosphorIcon(PhosphorIcons.warningCircle(PhosphorIconsStyle.bold),
                size: 48.sp, color: BusanHarborTokens.orange),
            SizedBox(height: 16.h),
            Text(l10n.errorGenericTitle,
                style: TextStyle(fontSize: 16.sp, color: Colors.white70), textAlign: TextAlign.center),
            SizedBox(height: 24.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: BusanHarborTokens.orange, foregroundColor: Colors.white),
              onPressed: () => ref.invalidate(currentDeckProvider),
              child: Text(l10n.retry, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      );

  Widget _buildEmpty(AppThemeExtension appTheme, AppLocalizations l10n) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          PhosphorIcon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
              size: 64.sp, color: BusanHarborTokens.mint),
          SizedBox(height: 20.h),
          Text(l10n.swipeAllCaughtUp,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white)),
          SizedBox(height: 24.h),
          OutlinedButton(
            onPressed: () => context.go('/home'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: BusanHarborTokens.orange),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.swipeBackToHome,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, letterSpacing: 1.6)),
          ),
        ]),
      );

  Widget _buildFeed(AppThemeExtension appTheme, AppLocalizations l10n, UserProfile user) => Stack(children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _cards.length,
          itemBuilder: (context, index) => _postCard(appTheme, l10n, user, index),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(children: [
              Row(children: [
                GestureDetector(
                  onTap: () => context.go('/home'),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20.r)),
                    child: PhosphorIcon(PhosphorIcons.x(PhosphorIconsStyle.bold), size: 18.sp, color: Colors.white),
                  ),
                ),
                const Spacer(),
                Text('${_currentIndex + 1} / ${_cards.length}',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: Colors.white70)),
                const Spacer(),
                SizedBox(width: 36.w),
              ]),
              SizedBox(height: 6.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(1.r),
                child: LinearProgressIndicator(
                  value: _cards.isNotEmpty ? (_currentIndex + 1) / _cards.length : 0,
                  minHeight: 2,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(BusanHarborTokens.orange),
                ),
              ),
            ]),
          ),
        ),
        AnimatedBuilder(
          animation: _heartController,
          builder: (_, __) {
            if (_heartController.value == 0) return const SizedBox.shrink();
            return Center(
              child: Opacity(
                opacity: 1 - _heartController.value,
                child: Transform.scale(
                  scale: 1 + _heartController.value * 1.8,
                  child: PhosphorIcon(PhosphorIcons.heart(PhosphorIconsStyle.fill),
                      size: 100.sp, color: BusanHarborTokens.coral),
                ),
              ),
            );
          },
        ),
        if (_showTutorial)
          TutorialOverlay(onDismiss: () => setState(() => _showTutorial = false)),
      ]);

  Widget _postCard(AppThemeExtension appTheme, AppLocalizations l10n, UserProfile user, int index) {
    final card = _cards[index];
    final nCode = user.nativeLanguage;
    final flipped = _flippedCards.contains(index);
    final saved = _savedCards.contains(index);
    final skipped = _skippedCards.contains(index);

    final grads = [
      [const Color(0xFF1a1a2e), const Color(0xFF16213e)],
      [const Color(0xFF0f3460), const Color(0xFF1a1a2e)],
      [const Color(0xFF533483), const Color(0xFF16213e)],
      [const Color(0xFF2d3436), const Color(0xFF0f3460)],
      [const Color(0xFF16213e), const Color(0xFF1a1a2e)],
    ];
    final g = grads[index % grads.length];
    final pi = _posIcon(card);

    return GestureDetector(
      onTap: _flipCard,
      onDoubleTap: () => _saveCard(index),
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(children: [
            Expanded(
              flex: 58,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: g),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      right: -30, top: -20,
                      child: Container(
                        width: 160.w, height: 160.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.047), width: 1),
                        ),
                      ),
                    ),
                    Center(
                      child: Opacity(
                        opacity: 0.12,
                        child: PhosphorIcon(pi, size: 110.sp, color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(card.word,
                            style: TextStyle(
                                fontSize: 56.sp, fontWeight: FontWeight.w800,
                                color: Colors.white, letterSpacing: 2,
                                shadows: const [Shadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 3))])),
                        SizedBox(height: 6.h),
                        Text(card.reading,
                            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500,
                                color: Colors.white60, letterSpacing: 1)),
                      ]),
                    ),
                    Positioned(
                      right: 10, top: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(4.r)),
                        child: Text(card.level.toUpperCase(),
                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800,
                                color: BusanHarborTokens.orange, letterSpacing: 1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 42,
              child: Container(
                width: double.infinity,
                color: const Color(0xFF0A0A0A),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    _act(saved ? PhosphorIcons.heart(PhosphorIconsStyle.fill) : PhosphorIcons.heart(PhosphorIconsStyle.bold),
                        saved ? BusanHarborTokens.coral : Colors.white, () => skipped ? null : _saveCard(index), l10n.swipeSaveLabel),
                    SizedBox(width: 16.w),
                    _act(PhosphorIcons.chatCircle(PhosphorIconsStyle.bold), Colors.white, _flipCard, l10n.swipeFlipLabel),
                    SizedBox(width: 16.w),
                    _act(PhosphorIcons.share(PhosphorIconsStyle.bold), Colors.white, () {}, l10n.swipeShareLabel),
                    const Spacer(),
                    _act(saved ? PhosphorIcons.bookmark(PhosphorIconsStyle.fill) : PhosphorIcons.bookmark(PhosphorIconsStyle.bold),
                        saved ? BusanHarborTokens.orange : Colors.white, () => skipped ? null : _saveCard(index), l10n.swipeSaveLabel),
                  ]),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(flipped ? card.meaning : card.meaningFor(nCode),
                            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3)),
                        if (flipped && (card.exampleText ?? '').isNotEmpty) ...[
                          SizedBox(height: 10.h),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.031),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.078)),
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(card.exampleText ?? '', style: TextStyle(fontSize: 16.sp, color: Colors.white, height: 1.5)),
                              SizedBox(height: 4.h),
                              Text(card.exampleTranslationFor(nCode),
                                  style: TextStyle(fontSize: 13.sp, color: Colors.white54)),
                            ]),
                          ),
                        ],
                        if (flipped) ...[
                          SizedBox(height: 8.h),
                          Wrap(spacing: 6.w, runSpacing: 4.h, children: [
                            _chip(card.level.toUpperCase(), BusanHarborTokens.orange),
                            _chip(card.pos, BusanHarborTokens.sea),
                            if (card.topic.isNotEmpty) _chip(card.topic, BusanHarborTokens.coral),
                          ]),
                        ],
                      ]),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(children: [
                    Expanded(
                      child: _btn(skipped ? l10n.swipeSkipped : l10n.swipeAlreadyKnew,
                          Colors.white.withValues(alpha: 0.059), skipped ? Colors.white38 : Colors.white70,
                          onPressed: skipped ? null : _skipCard),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: _btn(saved ? l10n.swipeSavedLabel : l10n.swipeSaveLabel,
                          saved ? BusanHarborTokens.orange : BusanHarborTokens.coral, Colors.white,
                          onPressed: skipped ? null : () => _saveCard(index), isPrimary: true),
                    ),
                  ]),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _act(PhosphorIconData i, Color c, VoidCallback? t, String l) => GestureDetector(
        onTap: t,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          PhosphorIcon(i, size: 26.sp, color: c),
          if (l.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(l, style: TextStyle(fontSize: 10.sp, color: c, fontWeight: FontWeight.w600)),
          ],
        ]),
      );

  Widget _btn(String l, Color bg, Color fg, {VoidCallback? onPressed, bool isPrimary = false}) => SizedBox(
        height: 44.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: isPrimary ? BorderSide.none : BorderSide(color: Colors.white.withAlpha(25)),
            ),
          ),
          child: Text(l, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ),
      );

  Widget _chip(String l, Color c) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: c.withAlpha(30),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: c.withAlpha(60)),
        ),
        child: Text(l, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: c, letterSpacing: 0.5)),
      );

  PhosphorIconData _posIcon(VocabCard c) {
    final p = c.pos.toLowerCase();
    if (p.contains('verb') || p.contains('\u52d5')) return PhosphorIcons.arrowRight(PhosphorIconsStyle.bold);
    if (p.contains('noun') || p.contains('\u540d')) return PhosphorIcons.cube(PhosphorIconsStyle.bold);
    if (p.contains('adj')) return PhosphorIcons.paintBrush(PhosphorIconsStyle.bold);
    if (p.contains('adv')) return PhosphorIcons.lightning(PhosphorIconsStyle.bold);
    return PhosphorIcons.circle(PhosphorIconsStyle.bold);
  }
}
