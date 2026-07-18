import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/config/points_config.dart';
import 'package:instalingo/data/card_data_loader.dart';
import 'package:instalingo/data/grammar_loader.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/user.dart';
import 'package:instalingo/models/feed_card.dart';
import 'package:instalingo/models/grammar_card.dart';
import 'package:instalingo/models/vocab_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/providers/vocab_deck_provider.dart';
import 'package:instalingo/screens/swipe/tutorial_overlay.dart';
import 'package:instalingo/screens/swipe/type_mode.dart';
import 'package:instalingo/services/tts_service.dart';
import 'package:instalingo/services/share/card_image_generator.dart';
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
  late List<FeedCard> _cards;
  int _currentIndex = 0;
  int _todayCount = 0;
  int _savedCount = 0;
  int _xpEarned = 0;
  int _gemsEarned = 0;
  bool _isLoading = true;
  bool _hasError = false;
  bool _showTutorial = false;
  final Set<int> _flippedCards = {};
  final Set<int> _savedCards = {};
  final Set<int> _skippedCards = {};
  final Set<int> _xpAwardedCards = {};  // Prevent XP farming from reverse-swiping
  bool _isTypeMode = false;  // Toggle between swipe recognition and type production
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
      // Only award XP once per card to prevent farming via reverse-swiping
      if (!_xpAwardedCards.contains(_currentIndex)) {
        _xpAwardedCards.add(_currentIndex);
        un.addXp(PointsConfig.cardSwipedWorth);
        _xpEarned += PointsConfig.cardSwipedWorth;
      }
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
    final card = _cards[index];
    if (!card.isVocab || _savedCards.contains(index)) return;
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
    final card = _cards[_currentIndex];
    if (!card.isVocab || _skippedCards.contains(_currentIndex)) return;
    final un = ref.read(userProvider.notifier);
    un.markAlreadyKnew(card.id);
    setState(() => _skippedCards.add(_currentIndex));
    HapticFeedback.mediumImpact();
    _goNext();
  }

  void _flipCard() {
    final card = _cards[_currentIndex];
    if (!card.isVocab) return; // Grammar cards don't flip
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
    // Mark first session as complete — future sessions use normal card ordering
    ref.read(firstSessionProvider.notifier).markComplete();
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
            setState(() { _isLoading = false; _hasError = true; });
          }
        },
        data: (deck) async {
          if (mounted) {
            // Merge slang/vulgar cards if content toggles enabled
            var allCards = List<VocabCard>.from(deck.cards);
            try {
              if (ref.read(spicyEnabledProvider)) {
                final slangDeck = await CardDataLoader.loadDeck('slang');
                allCards.addAll(slangDeck.cards);
              }
            } catch (_) { /* Slang deck not available */ }
            try {
              if (ref.read(wildEnabledProvider)) {
                final vulgarDeck = await CardDataLoader.loadDeck('vulgar');
                allCards.addAll(vulgarDeck.cards);
              }
            } catch (_) { /* Vulgar deck not available */ }

            final filteredVocab = _filterCards(allCards, user);

            // Load grammar cards and interleave (1 grammar per 10 vocab)
            List<GrammarCard> grammarCards = [];
            try {
              grammarCards = await GrammarLoader.loadByLevel(user.currentLevel);
            } catch (_) { /* Grammar cards not available */ }

            // Build FeedCard list with interleaved grammar
            final List<FeedCard> feedCards = [];
            for (int i = 0; i < filteredVocab.length; i++) {
              feedCards.add(FeedCard.vocab(filteredVocab[i]));
              // Insert grammar card every 10 vocab cards
              if ((i + 1) % 10 == 0 && grammarCards.isNotEmpty) {
                final gIdx = (i ~/ 10) % grammarCards.length;
                feedCards.add(FeedCard.grammar(grammarCards[gIdx]));
              }
            }
            int startIndex = 0;
            if (widget.targetWordId != null) {
              final idx = feedCards.indexWhere((c) => c.id == widget.targetWordId);
              if (idx >= 0) startIndex = idx;
            }
            setState(() {
              _cards = feedCards;
              _currentIndex = startIndex;
              _flippedCards.clear();
              _savedCards.clear();
              _skippedCards.clear();
              _xpAwardedCards.clear();
              _isLoading = false;
              _hasError = false;
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
            : _hasError
                ? _buildError(appTheme, l10n)
                : _cards.isEmpty
                    ? _buildEmpty(appTheme, l10n)
                    : _isTypeMode
                        ? TypeModeScreen(
                            cards: _cards
                                .where((c) => c.isVocab)
                                .map((c) => c.vocab!)
                                .toList(),
                            startIndex: _currentIndex,
                            onComplete: () => setState(() => _isTypeMode = false),
                          )
                        : _buildFeed(appTheme, l10n, user),
      ),
    );
  }

  List<VocabCard> _filterCards(List<VocabCard> cards, UserProfile user) {
    final spicyEnabled = ref.read(spicyEnabledProvider);
    final wildEnabled = ref.read(wildEnabledProvider);

    // Content gating: free users get limited spicy/real-life words per day
    // Pro users get unlimited access to all tiers
    final isPro = user.isPro;
    const freeSpicyPerDay = 3;
    const freeRealLifePerDay = 5;

    var filtered = cards
        .where((c) => !user.alreadyKnewWords.contains(c.id))
        .where((c) {
          switch (c.register) {
            case 'vulgar':
              return wildEnabled && isPro; // Wild = Pro+ only
            case 'slang':
              return spicyEnabled; // Spicy available but limited for free
            default:
              return true;
          }
        })
        .toList();

    // For free users: limit spicy/real-life cards per session
    if (!isPro) {
      final spicyCards = filtered.where((c) => c.register == 'slang').toList();
      final realLifeCards = filtered.where((c) => c.register == 'real_life').toList();
      final textbookCards = filtered.where((c) => c.register == 'textbook').toList();

      filtered = [
        ...textbookCards,
        ...realLifeCards.take(freeRealLifePerDay),
        ...spicyCards.take(freeSpicyPerDay),
      ];
    }

    // First session: put spicy/real-life cards FIRST for the "whoa" moment
    // Users who came from a TikTok want to see interesting words immediately
    final isFirstSession = ref.read(firstSessionProvider);
    if (isFirstSession) {
      final spicy = filtered.where((c) => c.register == 'slang').toList()..shuffle();
      final realLife = filtered.where((c) => c.register == 'real_life').toList()..shuffle();
      final textbook = filtered.where((c) => c.register == 'textbook').toList()..shuffle();

      // Order: 5 spicy first, then 5 real-life, then textbook
      filtered = [...spicy.take(5), ...realLife.take(5), ...textbook];
    } else {
      // Normal mode: shuffle everything
      filtered.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
    }

    return filtered;
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
            onPressed: () => context.go('/swipe'),
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
                  onTap: () => context.go('/swipe'),
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
                // Mode toggle: Swipe ↔ Type
                GestureDetector(
                  onTap: () => setState(() => _isTypeMode = !_isTypeMode),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: _isTypeMode
                          ? BusanHarborTokens.orange.withValues(alpha: 0.3)
                          : Colors.black26,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: _isTypeMode
                            ? BusanHarborTokens.orange.withValues(alpha: 0.5)
                            : Colors.white24,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PhosphorIcon(
                          _isTypeMode
                              ? PhosphorIcons.keyboard(PhosphorIconsStyle.fill)
                              : PhosphorIcons.arrowsDownUp(PhosphorIconsStyle.bold),
                          size: 14.sp,
                          color: _isTypeMode ? BusanHarborTokens.orange : Colors.white70,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          _isTypeMode ? 'TYPE' : 'SWIPE',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                            color: _isTypeMode ? BusanHarborTokens.orange : Colors.white70,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
    final feedCard = _cards[index];

    // Grammar card — render differently from vocab cards
    if (feedCard.type == FeedCardType.grammar && feedCard.grammar != null) {
      return _GrammarSwipeCard(grammar: feedCard.grammar!, appTheme: appTheme);
    }

    final card = feedCard.vocab!;
    final nCode = user.nativeLanguage;
    final flipped = _flippedCards.contains(index);
    final saved = _savedCards.contains(index);
    final skipped = _skippedCards.contains(index);

    final grads = PostCardGradients.values;
    final g = grads[index % grads.length];
    final pi = _posIcon(card);

    return GestureDetector(
      onTap: _flipCard,
      onDoubleTap: () => _saveCard(index),
      child: Semantics(
        label: card.word,
        button: true,
        hint: l10n.swipeFlipHint,
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
                    // Top badges: JLPT level + register tier
                    Positioned(
                      right: 10, top: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: Colors.black26, borderRadius: BorderRadius.circular(4.r)),
                            child: Text(card.level.toUpperCase(),
                                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800,
                                    color: BusanHarborTokens.orange, letterSpacing: 1)),
                          ),
                          SizedBox(height: 4.h),
                          _RegisterBadge(register: card.register),
                        ],
                      ),
                    ),
                    // Audio pronunciation button
                    Positioned(
                      left: 10, top: 10,
                      child: _AudioButton(card: card),
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
                    _act(PhosphorIcons.share(PhosphorIconsStyle.bold), Colors.white,
                        skipped ? null : () {
                          final card = _cards[index];
                          _shareCard(card, l10n);
                        }, l10n.swipeShareLabel),
                    const Spacer(),
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
      ),
    );
  }

  Widget _act(PhosphorIconData i, Color c, VoidCallback? t, String l) => GestureDetector(
        onTap: t,
        child: Semantics(
          label: l,
          button: true,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
          PhosphorIcon(i, size: 26.sp, color: c),
          if (l.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(l, style: TextStyle(fontSize: 10.sp, color: c, fontWeight: FontWeight.w600)),
          ],
        ]),
        ),
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

  Future<void> _shareCard(FeedCard feedCard, AppLocalizations l10n) async {
    if (!feedCard.isVocab || feedCard.vocab == null) return;
    final card = feedCard.vocab!;
    final locale = Localizations.localeOf(context).toString();
    final meaning = card.meaningFor(locale);
    final shareText = '${card.word} (${card.reading})\n$meaning\n\n'
        '${l10n.viaInstalingo} https://instalingo.app?ref=share_card';

    try {
      // Generate share image
      final generator = CardImageGenerator();
      final imageBytes = await generator.generateCardImage(card);

      // Write to temp file for XFile sharing
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/instalingo_${card.id}.png');
      await file.writeAsBytes(imageBytes);

      // Share image + text
      await Share.shareXFiles(
        [XFile(file.path)],
        text: shareText,
        subject: '${card.word} - ${l10n.shareAppSubject}',
      );
    } catch (_) {
      // Image share failed — fall back to text-only
      try {
        await Share.share(shareText, subject: card.word);
      } catch (_) {
        // Share completely failed
      }
    }
  }

  PhosphorIconData _posIcon(VocabCard c) {
    final p = c.pos.toLowerCase();
    if (p.contains('verb') || p.contains('\u52d5')) return PhosphorIcons.arrowRight(PhosphorIconsStyle.bold);
    if (p.contains('noun') || p.contains('\u540d')) return PhosphorIcons.cube(PhosphorIconsStyle.bold);
    if (p.contains('adj')) return PhosphorIcons.paintBrush(PhosphorIconsStyle.bold);
    if (p.contains('adv')) return PhosphorIcons.lightning(PhosphorIconsStyle.bold);
    return PhosphorIcons.circle(PhosphorIconsStyle.bold);
  }
}

/// Register tier badge displayed on swipe cards.
/// Maps register to emoji + human-readable label with tier-appropriate color.
/// Grammar pattern card displayed in the swipe feed.
/// Shows pattern, title, explanation, and example sentences.
class _GrammarSwipeCard extends StatelessWidget {
  final GrammarCard grammar;
  final AppThemeExtension appTheme;

  const _GrammarSwipeCard({required this.grammar, required this.appTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B3349), Color(0xFF0F1F2E)],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: BusanHarborTokens.orange.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grammar badge
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: BusanHarborTokens.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '📖 GRAMMAR',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: BusanHarborTokens.orange,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        grammar.level.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.6),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Pattern (large, prominent)
                Text(
                  grammar.pattern,
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 8.h),

                // Title / meaning
                Text(
                  grammar.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: BusanHarborTokens.orange,
                  ),
                ),
                SizedBox(height: 16.h),

                // Explanation
                Text(
                  grammar.explanation,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20.h),

                // Example sentences
                ...grammar.examples.asMap().entries.map((e) {
                  final i = e.key;
                  final ex = e.value;
                  final reading = i < grammar.exampleReadings.length
                      ? grammar.exampleReadings[i] : '';
                  final translation = i < grammar.exampleTranslations.length
                      ? grammar.exampleTranslations[i] : '';

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.4,
                            ),
                          ),
                          if (reading.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(
                              reading,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                          if (translation.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(
                              translation,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white.withValues(alpha: 0.5),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterBadge extends StatelessWidget {
  final String register;
  const _RegisterBadge({required this.register});

  @override
  Widget build(BuildContext context) {
    final (emoji, label, color) = switch (register) {
      'vulgar' => ('\u{1F480}', 'Wild', const Color(0xFFD04B43)),  // 💀 skull + coral red
      'slang' => ('\u{1F525}', 'Spicy', const Color(0xFFE89A22)),  // 🔥 fire + amber
      'real_life' => ('\u{1F5E3}\u{FE0F}', 'Real Life', const Color(0xFF3E7CB1)),  // 🗣️ + sea blue
      _ => ('\u{1F4DA}', 'Textbook', const Color(0xFF2D9C5A)),  // 📚 + mint green
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 0.5),
      ),
      child: Text(
        '$emoji $label',
        style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.5),
      ),
    );
  }
}

/// Audio pronunciation button for swipe cards.
/// Uses device TTS to speak the card's word.
class _AudioButton extends ConsumerWidget {
  final VocabCard card;
  const _AudioButton({required this.card});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsEnabled = ref.watch(ttsEnabledProvider);
    final tts = ref.watch(ttsServiceProvider);

    return GestureDetector(
      onTap: ttsEnabled
          ? () {
              HapticFeedback.selectionClick();
              tts.speakJapanese(card.word);
            }
          : null,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: ttsEnabled ? Colors.white24 : Colors.white10,
            width: 0.5,
          ),
        ),
        child: Icon(
          Icons.volume_up_rounded,
          size: 16.sp,
          color: ttsEnabled ? Colors.white70 : Colors.white24,
        ),
      ),
    );
  }
}
