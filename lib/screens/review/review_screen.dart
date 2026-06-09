import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/config/points_config.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/vocab_card.dart';
import 'package:instalingo/providers/srs_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/providers/vocab_deck_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// SRS review screen for saved words.
///
/// Shows due cards and rating buttons (Again, Hard, Good, Easy).
class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context);
    final srsAsync = ref.watch(srsProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: appTheme.harborCream,
      appBar: AppBar(
        backgroundColor: appTheme.harborNavy,
        elevation: 0,
        title: Text(
          l10n.reviewTitle,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: appTheme.harborInkOnNavy,
            letterSpacing: 2.4,
          ),
        ),
      ),
      body: srsAsync.when(
        loading: () => _buildLoading(appTheme),
        error: (error, _) => _buildError(appTheme, l10n, error.toString()),
        data: (srsData) {
          final dueCards = srsData
              .where((s) =>
                  user.savedWords.contains(s.cardId) &&
                  (s.due.isBefore(DateTime.now()) ||
                      s.due.isAtSameMomentAs(DateTime.now())))
              .toList();

          if (dueCards.isEmpty) {
            return _buildEmpty(appTheme, l10n);
          }

          return _ReviewCardList(
            dueCards: dueCards,
            appTheme: appTheme,
          );
        },
      ),
    );
  }

  Widget _buildLoading(AppThemeExtension appTheme) {
    return Center(
      child: SizedBox(
        width: 36.w,
        height: 36.w,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(BusanHarborTokens.orange),
        ),
      ),
    );
  }

  Widget _buildError(AppThemeExtension appTheme, AppLocalizations l10n, String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIcons.warningCircle(PhosphorIconsStyle.regular),
            size: 44.sp,
            color: appTheme.onSurfaceVariant,
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.errorLoadingReviews,
            style: TextStyle(
              fontSize: 14.sp,
              color: appTheme.onSurfaceVariant,
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
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: BusanHarborTokens.mint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: BusanHarborTokens.mint.withValues(alpha: 0.3),
              ),
            ),
            child: Center(
              child: PhosphorIcon(
                PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                size: 40.sp,
                color: BusanHarborTokens.mint,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            l10n.reviewAllCaughtUp,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: appTheme.harborNavy,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.reviewEmptyTitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: appTheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.reviewEmptyMessage,
            style: TextStyle(
              fontSize: 13.sp,
              color: appTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCardList extends ConsumerStatefulWidget {
  final List<SRSData> dueCards;
  final AppThemeExtension appTheme;

  const _ReviewCardList({
    required this.dueCards,
    required this.appTheme,
  });

  @override
  ConsumerState<_ReviewCardList> createState() => _ReviewCardListState();
}

class _ReviewCardListState extends ConsumerState<_ReviewCardList> {
  int _currentIndex = 0;
  bool _showBack = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_currentIndex >= widget.dueCards.length) {
      return _ReviewComplete(appTheme: widget.appTheme);
    }

    final srsItem = widget.dueCards[_currentIndex];
    final cardAsync = ref.watch(cardByIdProvider(srsItem.cardId));

    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.dueCards.length} ${l10n.reviewCardsDue}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: widget.appTheme.harborNavy,
                ),
              ),
              Text(
                '${_currentIndex + 1} / ${widget.dueCards.length}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.appTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Progress bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.r),
            child: LinearProgressIndicator(
              value: (_currentIndex) / widget.dueCards.length,
              minHeight: 3,
              backgroundColor: widget.appTheme.border,
              valueColor:
                  const AlwaysStoppedAnimation(BusanHarborTokens.orange),
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Card
        Expanded(
          child: cardAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (card) {
              if (card == null) {
                return Center(
                  child: Text(
                    l10n.cardNotFound,
                    style: TextStyle(color: widget.appTheme.onSurfaceVariant),
                  ),
                );
              }
              final nativeCode = ref.read(userProvider).nativeLanguage;
              return _ReviewCard(
                card: card,
                srsData: srsItem,
                showBack: _showBack,
                appTheme: widget.appTheme,
                onFlip: () => setState(() => _showBack = !_showBack),
                nativeCode: nativeCode,
              );
            },
          ),
        ),

        // Rating buttons
        _buildRatingButtons(srsItem, l10n),
      ],
    );
  }

  Widget _buildRatingButtons(SRSData srsItem, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _RatingButton(
            label: l10n.reviewAgain,
            rating: 1,
            color: BusanHarborTokens.coral,
            icon: PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.bold),
            onPressed: () => _rateAndNext(srsItem.cardId, 1),
          ),
          _RatingButton(
            label: l10n.reviewHard,
            rating: 2,
            color: BusanHarborTokens.amber,
            icon: PhosphorIcons.handFist(PhosphorIconsStyle.bold),
            onPressed: () => _rateAndNext(srsItem.cardId, 2),
          ),
          _RatingButton(
            label: l10n.reviewGood,
            rating: 3,
            color: BusanHarborTokens.mint,
            icon: PhosphorIcons.check(PhosphorIconsStyle.bold),
            onPressed: () => _rateAndNext(srsItem.cardId, 3),
          ),
          _RatingButton(
            label: l10n.reviewEasy,
            rating: 4,
            color: BusanHarborTokens.sea,
            icon: PhosphorIcons.lightning(PhosphorIconsStyle.fill),
            onPressed: () => _rateAndNext(srsItem.cardId, 4),
          ),
        ],
      ),
    );
  }

  void _rateAndNext(String cardId, int rating) {
    HapticFeedback.selectionClick();
    ref.read(srsProvider.notifier).scheduleReview(cardId, rating);
    ref.read(userProvider.notifier).addXp(PointsConfig.smartReviewWorth);
    setState(() {
      _showBack = false;
      _currentIndex++;
    });
  }
}

class _ReviewCard extends StatelessWidget {
  final VocabCard card;
  final SRSData srsData;
  final bool showBack;
  final AppThemeExtension appTheme;
  final VoidCallback onFlip;
  final String nativeCode;

  const _ReviewCard({
    required this.card,
    required this.srsData,
    required this.showBack,
    required this.appTheme,
    required this.onFlip,
    required this.nativeCode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onFlip,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: appTheme.harborNavy,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: BusanHarborTokens.orange.withValues(alpha: 0.3),
            width: 1.2,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Level badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: BusanHarborTokens.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: BusanHarborTokens.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    card.level.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: BusanHarborTokens.orange,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                if (!showBack) ...[
                  // Front: word + reading
                  Text(
                    card.word,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w800,
                      color: appTheme.harborInkOnNavy,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    card.reading,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: appTheme.harborInkOnNavyMuted,
                    ),
                  ),
                ] else ...[
                  // Back: meaning in user's native language
                  Text(
                    card.meaningFor(nativeCode),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: appTheme.harborInkOnNavy,
                    ),
                  ),
                  // Show English reference if native language is not English
                  if (nativeCode != 'en' && card.meaning.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      card.meaning,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: appTheme.harborInkOnNavyMuted,
                      ),
                    ),
                  ],
                  if (card.exampleText != null &&
                      card.exampleText!.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color:
                            BusanHarborTokens.navyMid.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        card.exampleText!,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: appTheme.harborInkOnNavyMuted,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ],

                SizedBox(height: 24.h),
                // SRS stats
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.reviewsCount(srsData.reviewCount),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      l10n.lapsesCount(srsData.lapseCount),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  l10n.tapToFlip,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.4),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final int rating;
  final Color color;
  final PhosphorIconData icon;
  final VoidCallback onPressed;

  const _RatingButton({
    required this.label,
    required this.rating,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Semantics(
        label: label,
        button: true,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1.2),
            ),
            child: Center(
              child: PhosphorIcon(icon, size: 24.sp, color: color),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _ReviewComplete extends StatelessWidget {
  final AppThemeExtension appTheme;

  const _ReviewComplete({required this.appTheme});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: BusanHarborTokens.mint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: BusanHarborTokens.mint.withValues(alpha: 0.3),
              ),
            ),
            child: Center(
              child: PhosphorIcon(
                PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                size: 40.sp,
                color: BusanHarborTokens.mint,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            l10n.reviewCompleteTitle,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: appTheme.harborNavy,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.reviewCompleteMessage,
            style: TextStyle(
              fontSize: 14.sp,
              color: appTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
