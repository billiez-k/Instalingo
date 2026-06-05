import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/vocab_card.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Individual word card widget used in the swipe interface.
///
/// Front side: large Japanese word, reading, placeholder image area,
/// level badge. Tap to flip to the back side.
class WordCard extends StatefulWidget {
  final VocabCard card;
  final bool showBack;
  final VoidCallback? onTap;
  final String nativeCode;

  const WordCard({
    super.key,
    required this.card,
    this.showBack = false,
    this.onTap,
    required this.nativeCode,
  });

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _showingBack = false;

  @override
  void initState() {
    super.initState();
    _showingBack = widget.showBack;
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    if (_showingBack) {
      _flipController.value = 1;
    }
  }

  @override
  void didUpdateWidget(WordCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBack != _showingBack) {
      _showingBack = widget.showBack;
      if (_showingBack) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (_, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * 3.14159),
            child: _flipAnimation.value < 0.5
                ? _buildFront(appTheme, l10n)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159),
                    child: _buildBack(appTheme, l10n),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFront(AppThemeExtension appTheme, AppLocalizations l10n) {
    final card = widget.card;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.harborNavy,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: BusanHarborTokens.orange.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Level badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
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
                letterSpacing: 1.6,
              ),
            ),
          ),
          SizedBox(height: 40.h),

          // Image placeholder area
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              color: BusanHarborTokens.navyMid.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.3),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PhosphorIcon(
                    _iconForPos(card.pos),
                    size: 40.sp,
                    color: appTheme.harborInkOnNavyMuted,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    card.pos.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: appTheme.harborInkOnNavyMuted,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40.h),

          // Japanese word
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              card.word,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42.sp,
                fontWeight: FontWeight.w800,
                color: appTheme.harborInkOnNavy,
                letterSpacing: 1.0,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Reading
          Text(
            card.reading,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: appTheme.harborInkOnNavyMuted,
            ),
          ),
          SizedBox(height: 40.h),

          // Topic tag
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.3)),
            ),
            child: Text(
              card.topic.toUpperCase(),
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: appTheme.harborInkOnNavyMuted,
                letterSpacing: 1.4,
              ),
            ),
          ),

          SizedBox(height: 24.h),
          // Tap hint
          Text(
            l10n.tapToFlip,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.5),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(AppThemeExtension appTheme, AppLocalizations l10n) {
    final card = widget.card;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.harborNavy,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: BusanHarborTokens.orange.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Word
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    card.word,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w800,
                      color: appTheme.harborInkOnNavy,
                    ),
                  ),
                ),
                Text(
                  card.reading,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: appTheme.harborInkOnNavyMuted,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Container(width: 24.w, height: 2, color: BusanHarborTokens.orange),
            SizedBox(height: 20.h),

            // Meaning in user's native language
            _infoRow(l10n.nativeLanguage, card.meaningFor(widget.nativeCode), appTheme),
            SizedBox(height: 20.h),

            // Part of Speech & Level
            Row(
              children: [
                _badge(card.pos.toUpperCase(), BusanHarborTokens.sea, appTheme),
                SizedBox(width: 8.w),
                _badge(card.level.toUpperCase(), BusanHarborTokens.orange, appTheme),
              ],
            ),
            SizedBox(height: 20.h),

            // Example sentence
            if (card.exampleText != null && card.exampleText!.isNotEmpty) ...[
              Text(
                l10n.exampleSectionLabel,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: appTheme.harborInkOnNavyMuted,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: BusanHarborTokens.navyMid.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.exampleText!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: appTheme.harborInkOnNavy,
                        height: 1.5,
                      ),
                    ),
                    if (card.exampleReading != null &&
                        card.exampleReading!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        card.exampleReading!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: appTheme.harborInkOnNavyMuted,
                        ),
                      ),
                    ],
                    if (card.exampleTranslationFor(widget.nativeCode).isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        card.exampleTranslationFor(widget.nativeCode),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontStyle: FontStyle.italic,
                          color: appTheme.harborInkOnNavyMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            SizedBox(height: 24.h),

            // Source
            Text(
              l10n.sourceLabel(card.source),
              style: TextStyle(
                fontSize: 10.sp,
                color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.5),
              ),
            ),

            SizedBox(height: 16.h),
            // Tap hint
            Center(
              child: Text(
                l10n.tapToFlipBack,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: appTheme.harborInkOnNavyMuted.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, AppThemeExtension appTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: appTheme.harborInkOnNavyMuted,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: appTheme.harborInkOnNavy,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _badge(String text, Color color, AppThemeExtension appTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  PhosphorIconData _iconForPos(String pos) {
    switch (pos.toLowerCase()) {
      case 'noun':
        return PhosphorIcons.cube(PhosphorIconsStyle.regular);
      case 'verb':
        return PhosphorIcons.arrowRight(PhosphorIconsStyle.regular);
      case 'adj':
        return PhosphorIcons.paintBrush(PhosphorIconsStyle.regular);
      default:
        return PhosphorIcons.bookOpen(PhosphorIconsStyle.regular);
    }
  }
}
