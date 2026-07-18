import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/config/points_config.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/vocab_card.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/providers/srs_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Production exercise mode — user types the Japanese word from English meaning.
///
/// This is the counterpart to swipe/recognition mode. Instead of seeing the word
/// and revealing the meaning, users see the meaning and must TYPE the word.
/// This tests active recall (production) rather than passive recognition.
class TypeModeScreen extends ConsumerStatefulWidget {
  final List<VocabCard> cards;
  final int startIndex;
  final VoidCallback onComplete;

  const TypeModeScreen({
    super.key,
    required this.cards,
    this.startIndex = 0,
    required this.onComplete,
  });

  @override
  ConsumerState<TypeModeScreen> createState() => _TypeModeScreenState();
}

class _TypeModeScreenState extends ConsumerState<TypeModeScreen> {
  late int _currentIndex;
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  int _correctCount = 0;
  int _totalAttempted = 0;
  bool _showResult = false;
  bool _lastAnswerCorrect = false;
  String _lastCorrectAnswer = '';

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitAnswer(String userInput) {
    if (_showResult) {
      // User is advancing to next card
      _nextCard();
      return;
    }

    final card = widget.cards[_currentIndex];
    final correctAnswer = card.reading;
    final correctWord = card.word;

    // Accept either the reading (kana) or the word (kanji) as correct
    // Also normalize: remove spaces, lowercase
    final normalizedInput = userInput.trim();
    final isCorrect = normalizedInput == correctAnswer ||
        normalizedInput == correctWord ||
        normalizedInput == _toRomaji(correctAnswer);

    setState(() {
      _totalAttempted++;
      _lastAnswerCorrect = isCorrect;
      _lastCorrectAnswer = correctWord;
      _showResult = true;

      if (isCorrect) {
        _correctCount++;
        HapticFeedback.heavyImpact();
        // Award XP and update SRS
        ref.read(userProvider.notifier).addXp(PointsConfig.smartReviewWorth);
        try {
          ref.read(srsProvider.notifier).scheduleReview(card.id, 3); // Good
        } catch (_) {}
        ref.read(userProvider.notifier).saveWord(card.id);
      } else {
        HapticFeedback.mediumImpact();
        try {
          ref.read(srsProvider.notifier).scheduleReview(card.id, 1); // Again
        } catch (_) {}
      }
    });
  }

  void _nextCard() {
    if (_currentIndex + 1 >= widget.cards.length) {
      widget.onComplete();
      return;
    }
    setState(() {
      _currentIndex++;
      _showResult = false;
      _lastAnswerCorrect = false;
      _lastCorrectAnswer = '';
    });
    _textController.clear();
    _focusNode.requestFocus();
  }

  /// Crude romaji conversion — handles common kana patterns.
  String _toRomaji(String kana) {
    const map = {
      'あ': 'a', 'い': 'i', 'う': 'u', 'え': 'e', 'お': 'o',
      'か': 'ka', 'き': 'ki', 'く': 'ku', 'け': 'ke', 'こ': 'ko',
      'さ': 'sa', 'し': 'shi', 'す': 'su', 'せ': 'se', 'そ': 'so',
      'た': 'ta', 'ち': 'chi', 'つ': 'tsu', 'て': 'te', 'と': 'to',
      'な': 'na', 'に': 'ni', 'ぬ': 'nu', 'ね': 'ne', 'の': 'no',
      'は': 'ha', 'ひ': 'hi', 'ふ': 'fu', 'へ': 'he', 'ほ': 'ho',
      'ま': 'ma', 'み': 'mi', 'む': 'mu', 'め': 'me', 'も': 'mo',
      'や': 'ya', 'ゆ': 'yu', 'よ': 'yo',
      'ら': 'ra', 'り': 'ri', 'る': 'ru', 'れ': 're', 'ろ': 'ro',
      'わ': 'wa', 'を': 'wo', 'ん': 'n',
      'が': 'ga', 'ぎ': 'gi', 'ぐ': 'gu', 'げ': 'ge', 'ご': 'go',
      'ざ': 'za', 'じ': 'ji', 'ず': 'zu', 'ぜ': 'ze', 'ぞ': 'zo',
      'だ': 'da', 'ぢ': 'ji', 'づ': 'zu', 'で': 'de', 'ど': 'do',
      'ば': 'ba', 'び': 'bi', 'ぶ': 'bu', 'べ': 'be', 'ぼ': 'bo',
      'ぱ': 'pa', 'ぴ': 'pi', 'ぷ': 'pu', 'ぺ': 'pe', 'ぽ': 'po',
      'きゃ': 'kya', 'きゅ': 'kyu', 'きょ': 'kyo',
      'しゃ': 'sha', 'しゅ': 'shu', 'しょ': 'sho',
      'ちゃ': 'cha', 'ちゅ': 'chu', 'ちょ': 'cho',
      'にゃ': 'nya', 'にゅ': 'nyu', 'にょ': 'nyo',
      'ひゃ': 'hya', 'ひゅ': 'hyu', 'ひょ': 'hyo',
      'みゃ': 'mya', 'みゅ': 'myu', 'みょ': 'myo',
      'りゃ': 'rya', 'りゅ': 'ryu', 'りょ': 'ryo',
      'ぎゃ': 'gya', 'ぎゅ': 'gyu', 'ぎょ': 'gyo',
      'じゃ': 'ja', 'じゅ': 'ju', 'じょ': 'jo',
      'びゃ': 'bya', 'びゅ': 'byu', 'びょ': 'byo',
      'ぴゃ': 'pya', 'ぴゅ': 'pyu', 'ぴょ': 'pyo',
      'っ': '', 'ー': '-',
    };
    String result = kana;
    // Check exact matches first
    if (map.containsKey(result.toLowerCase())) return map[result.toLowerCase()]!;
    // Try character-by-character conversion
    final buf = StringBuffer();
    int i = 0;
    while (i < result.length) {
      if (i + 1 < result.length && map.containsKey(result.substring(i, i + 2))) {
        buf.write(map[result.substring(i, i + 2)]);
        i += 2;
      } else if (map.containsKey(result[i])) {
        buf.write(map[result[i]]);
        i++;
      } else {
        buf.write(result[i]);
        i++;
      }
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appTheme = context.appTheme;

    if (widget.cards.isEmpty) {
      return Center(
        child: Text(l10n.collectionsEmptyMessage,
            style: TextStyle(color: appTheme.onSurfaceVariant)),
      );
    }

    final card = widget.cards[_currentIndex];
    final progress = (_currentIndex + 1) / widget.cards.length;

    return Scaffold(
      backgroundColor: appTheme.harborCream,
      appBar: AppBar(
        backgroundColor: appTheme.harborNavy,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
              color: appTheme.harborInkOnNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${l10n.swipeFlipLabel} — ${_currentIndex + 1}/${widget.cards.length}',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700,
              color: appTheme.harborInkOnNavy),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: Text(
                '✅$_correctCount/$_totalAttempted',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700,
                    color: BusanHarborTokens.mint),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: appTheme.border,
                valueColor: const AlwaysStoppedAnimation(BusanHarborTokens.orange),
              ),
            ),
          ),

          // Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show the meaning — user types the Japanese word
                  Text(
                    card.meaning,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: appTheme.harborNavy,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    card.pos.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: appTheme.onSurfaceVariant,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Result display
                  if (_showResult) ...[
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: _lastAnswerCorrect
                            ? BusanHarborTokens.mint.withValues(alpha: 0.1)
                            : BusanHarborTokens.coral.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: _lastAnswerCorrect
                              ? BusanHarborTokens.mint.withValues(alpha: 0.3)
                              : BusanHarborTokens.coral.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          PhosphorIcon(
                            _lastAnswerCorrect
                                ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                                : PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
                            size: 32.sp,
                            color: _lastAnswerCorrect
                                ? BusanHarborTokens.mint
                                : BusanHarborTokens.coral,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            _lastCorrectAnswer,
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w800,
                              color: appTheme.harborNavy,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            card.reading,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: appTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],

                  // Input field
                  if (!_showResult) ...[
                    TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: appTheme.harborNavy,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.swipeFlipLabel,
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: appTheme.onSurfaceVariant.withValues(alpha: 0.4),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: appTheme.border, width: 1.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: BusanHarborTokens.orange, width: 2),
                        ),
                      ),
                      onSubmitted: _submitAnswer,
                    ),
                    SizedBox(height: 24.h),
                    // Submit button
                    SizedBox(
                      width: 200.w,
                      height: 48.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BusanHarborTokens.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () => _submitAnswer(_textController.text),
                        child: Text(
                          'CHECK',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Continue button
                    SizedBox(
                      width: 200.w,
                      height: 48.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appTheme.harborNavy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: _nextCard,
                        child: Text(
                          _currentIndex + 1 >= widget.cards.length ? 'FINISH' : 'NEXT',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
