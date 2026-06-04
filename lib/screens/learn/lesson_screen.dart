import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instalingo/config/points_config.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/models/course.dart';
import 'package:instalingo/providers/course_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/services/tts_service.dart';
import 'package:instalingo/widgets/error_states.dart';
import 'package:instalingo/widgets/grammar_tip_overlay.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final String lessonId;
  const LessonScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int _currentIndex = 0;
  String? _selectedAnswer;
  List<String> _selectedWords = [];
  bool _showResult = false;
  bool _isCorrect = false;
  int _correctCount = 0;
  bool _isLoading = true;
  bool _matchPairsComplete = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nativeLang = ref.watch(userProvider).nativeLanguage;
    if (_isLoading) {
      return Scaffold(
        body: LessonLoader(title: l10n.loadingLesson),
      );
    }

    final course = ref.watch(courseProvider);
    final lesson = course.getLessonById(widget.lessonId);

    if (lesson == null) {
      // If the lesson isn't found, navigate back to learn instead of showing error
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/learn');
      });
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.go('/learn'))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final exercises = lesson.exercises;
    if (exercises.isEmpty) return Scaffold(appBar: AppBar(title: Text(l10n.loadingLesson)), body: const Center(child: CircularProgressIndicator()));
    final current = exercises[_currentIndex];
    final progress = (_currentIndex + 1) / exercises.length;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: LinearProgressIndicator(
          value: progress,
          backgroundColor: context.appTheme.border,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          minHeight: 8.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
        titleSpacing: 16.w,
        actions: [
          if (current.explanation != null || current.grammarRule != null)
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                GrammarTipOverlay.show(
                  context,
                  rule: current.grammarRule?.resolve(nativeLang) ??
                      l10n.grammarRuleFallback,
                  example: current.grammarExample?.resolve(nativeLang) ??
                      current.explanation?.resolve(nativeLang) ??
                      l10n.grammarExampleFallback,
                  explanation: current.explanation?.resolve(nativeLang),
                );
              },
              icon: PhosphorIcon(PhosphorIcons.lightbulb()),
            ),
          IconButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              context.push('/profile/help');
            },
            icon: PhosphorIcon(PhosphorIcons.flag()),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  Text(
                    l10n.exercisesProgress(_currentIndex + 1, exercises.length).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 2.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Container(width: 22.w, height: 3, color: AppColors.primary),
              SizedBox(height: 14.h),
              // Native-language instruction as headline — NEVER English
              Text(
                current.instruction ?? _exerciseInstruction(current, l10n),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 22.sp,
                  height: 1.4,
                ),
              ),
              // Question as subtitle — only shown when it has actual learning content
              // (not empty after clearing English instructions)
              if (current.question.isNotEmpty && current.question != current.instruction) ...[
                SizedBox(height: 8.h),
                Text(
                  current.question,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
              SizedBox(height: 24.h),
              Expanded(
                child: _buildExerciseContent(current, nativeLang),
              ),
              if (_showResult) ...[
                _ResultBanner(isCorrect: _isCorrect, explanation: current.explanation?.resolve(nativeLang)),
                SizedBox(height: 16.h),
              ],
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: (_selectedAnswer != null || _matchPairsComplete || current.type == ExerciseType.grammarTip || current.type == ExerciseType.flashCard)
                    ? () {
                        HapticFeedback.mediumImpact();
                        _onCheckOrContinue();
                      }
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showResult
                        ? _isCorrect
                            ? AppColors.primary
                            : AppColors.error
                        : AppColors.primary,
                  ),
                  child: Text(
                    _showResult
                        ? _currentIndex < exercises.length - 1
                            ? l10n.continueText
                            : l10n.finishLesson
                        : l10n.check,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseContent(Exercise exercise, String nativeLang) {
    switch (exercise.type) {
      case ExerciseType.vocabularyMultipleChoice:
      case ExerciseType.translateSentence:
        return _MultipleChoiceOptions(
          options: exercise.options ?? [],
          selected: _selectedAnswer,
          showResult: _showResult,
          correctAnswer: exercise.correctAnswer,
          onSelect: _showResult ? null : (v) => setState(() => _selectedAnswer = v),
        );
      case ExerciseType.fillInBlank:
        if (exercise.wordBank != null && exercise.wordBank!.isNotEmpty) {
          return _WordBankFillBlank(
            wordBank: exercise.wordBank!,
            selectedWords: _selectedWords,
            showResult: _showResult,
            correctAnswer: exercise.correctAnswer ?? '',
            onWordTap: _showResult
                ? null
                : (word) {
                    setState(() {
                      if (_selectedWords.contains(word)) {
                        _selectedWords.remove(word);
                      } else {
                        _selectedWords.add(word);
                      }
                      _selectedAnswer = _selectedWords.join(' ');
                    });
                  },
          onClear: _showResult
              ? null
              : () => setState(() {
                    _selectedWords.clear();
                    _selectedAnswer = null;
                  }),
          onRemoveLast: _showResult
              ? null
              : () => setState(() {
                    if (_selectedWords.isNotEmpty) {
                      _selectedWords.removeLast();
                    }
                    _selectedAnswer =
                        _selectedWords.isEmpty ? null : _selectedWords.join(' ');
                  }),
          onReorder: _showResult
              ? null
              : (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final word = _selectedWords.removeAt(oldIndex);
                    _selectedWords.insert(newIndex, word);
                    _selectedAnswer = _selectedWords.join(' ');
                  });
                },
          question: exercise.question,
        );
        }
        return _MultipleChoiceOptions(
          options: exercise.options ?? [],
          selected: _selectedAnswer,
          showResult: _showResult,
          correctAnswer: exercise.correctAnswer,
          onSelect: _showResult ? null : (v) => setState(() => _selectedAnswer = v),
        );
      case ExerciseType.wordSorting:
        return _ReorderExercise(
          words: exercise.options ?? [],
          selectedWords: _selectedWords,
          showResult: _showResult,
          correctAnswerList: exercise.correctAnswerList ?? [],
          onWordTap: _showResult
              ? null
              : (word) {
                  setState(() {
                    if (_selectedWords.contains(word)) {
                      _selectedWords.remove(word);
                    } else {
                      _selectedWords.add(word);
                    }
                    _selectedAnswer = _selectedWords.join(' ');
                  });
                },
          onReorder: _showResult
              ? null
              : (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final word = _selectedWords.removeAt(oldIndex);
                    _selectedWords.insert(newIndex, word);
                    _selectedAnswer = _selectedWords.join(' ');
                  });
                },
          onClear: _showResult
              ? null
              : () => setState(() {
                    _selectedWords.clear();
                    _selectedAnswer = null;
                  }),
        );
      case ExerciseType.grammarTip:
        return _GrammarTipContent(exercise: exercise, nativeLang: nativeLang);
      case ExerciseType.matchPairs:
        return _MatchPairsContent(
          pairs: exercise.pairs ?? [],
          onComplete: _matchPairsComplete
              ? null
              : () => setState(() {
                    _matchPairsComplete = true;
                    _isCorrect = true;
                  }),
        );
      case ExerciseType.dialogueComplete:
        return _DialogueCompletionContent(
          dialogue: exercise.dialogue ?? [],
          selectedAnswer: _selectedAnswer,
          showResult: _showResult,
          correctAnswer: exercise.correctAnswer ?? '',
          onSelect: _showResult
              ? null
              : (v) => setState(() => _selectedAnswer = v),
        );
      case ExerciseType.imageIdentification:
        return _ImageIdentificationContent(
          imageUrl: exercise.imageUrl,
          options: exercise.options ?? [],
          selected: _selectedAnswer,
          showResult: _showResult,
          correctAnswer: exercise.correctAnswer,
          onSelect: _showResult ? null : (v) => setState(() => _selectedAnswer = v),
        );
      case ExerciseType.listenAndType:
        return _ListenAndTypeContent(
          audioUrl: exercise.audioUrl,
          selectedAnswer: _selectedAnswer,
          showResult: _showResult,
          correctAnswer: exercise.correctAnswer ?? '',
          onAnswerChanged: _showResult
              ? null
              : (v) => setState(() => _selectedAnswer = v),
        );
      case ExerciseType.speaking:
        return _SpeakingContent(
          prompt: exercise.question,
          showResult: _showResult,
          correctAnswer: exercise.correctAnswer ?? '',
          onSubmit: (v) => setState(() => _selectedAnswer = v),
        );
      case ExerciseType.flashCard:
        return _FlashCardContent(
          word: exercise.question,
          translation: exercise.correctAnswer ?? '',
          explanation: exercise.explanation?.resolve(nativeLang),
          onFlip: () => setState(() => _selectedAnswer = 'flipped'),
        );
      case ExerciseType.comprehensionText:
        return _ComprehensionContent(
          passage: exercise.passage ?? '',
          question: exercise.question,
          options: exercise.options ?? [],
          selected: _selectedAnswer,
          showResult: _showResult,
          correctAnswer: exercise.correctAnswer,
          onSelect: _showResult ? null : (v) => setState(() => _selectedAnswer = v),
        );
      case ExerciseType.grammarTrueFalse:
        return _TrueFalseContent(
          statement: exercise.question,
          isTrue: exercise.isTrue ?? true,
          selected: _selectedAnswer,
          showResult: _showResult,
          onSelect: _showResult ? null : (v) => setState(() => _selectedAnswer = v),
        );
      case ExerciseType.phraseBuilderPrefilled:
        return _PhraseBuilderPrefilledContent(
          options: exercise.options ?? [],
          preFilledWords: exercise.wordBank ?? [],
          selectedWords: _selectedWords,
          showResult: _showResult,
          correctAnswerList: exercise.correctAnswerList ?? [],
          onWordTap: _showResult
              ? null
              : (word) {
                  setState(() {
                    if (_selectedWords.contains(word)) {
                      _selectedWords.remove(word);
                    } else {
                      _selectedWords.add(word);
                    }
                    _selectedAnswer = _selectedWords.join(' ');
                  });
                },
          onClear: _showResult
              ? null
              : () => setState(() {
                    _selectedWords.clear();
                    _selectedAnswer = null;
                  }),
        );
      case ExerciseType.writing:
        return _WritingContent(
          prompt: exercise.writingPrompt?.resolve(nativeLang) ?? exercise.question,
          sampleAnswer: exercise.sampleAnswer?.resolve(nativeLang) ?? '',
          showResult: _showResult,
          onSubmit: (v) => setState(() => _selectedAnswer = v),
        );
    }
  }

  /// Returns a native-language instruction for the exercise type.
  /// NEVER falls back to English — always returns properly translated text.
  String _exerciseInstruction(Exercise ex, AppLocalizations l10n) {
    switch (ex.type) {
      case ExerciseType.vocabularyMultipleChoice:
        final vocabQ = ex.question.isNotEmpty ? ex.question : (ex.correctAnswer ?? '');
        return l10n.exVocabMultipleChoice(vocabQ);
      case ExerciseType.translateSentence:
        return l10n.exVocabMultipleChoice(ex.question);
      case ExerciseType.matchPairs:
        return l10n.exMatchWords;
      case ExerciseType.wordSorting:
        return l10n.exArrangeWords;
      case ExerciseType.grammarTip:
        return l10n.exGrammarTip;
      case ExerciseType.listenAndType:
        return l10n.exTypeWhatYouHear;
      case ExerciseType.fillInBlank:
        return l10n.exFillInBlank;
      case ExerciseType.dialogueComplete:
        return l10n.exDialogueComplete;
      case ExerciseType.imageIdentification:
        return l10n.exImageIdentify;
      case ExerciseType.speaking:
        return l10n.exSpeaking;
      case ExerciseType.flashCard:
        return l10n.exFlashCard;
      case ExerciseType.comprehensionText:
        return l10n.exComprehension;
      case ExerciseType.grammarTrueFalse:
        return l10n.exTrueFalse;
      case ExerciseType.phraseBuilderPrefilled:
        return l10n.exPhraseBuilder;
      case ExerciseType.writing:
        return l10n.exWriting;
      default:
        return l10n.exTranslate;
    }
  }

  void _onCheckOrContinue() {
    final lesson = ref.read(courseProvider).getLessonById(widget.lessonId)!;
    final exercises = lesson.exercises;
    final currentExercise = exercises[_currentIndex];

    if (_showResult) {
      if (_currentIndex < exercises.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedAnswer = null;
          _selectedWords = [];
          _showResult = false;
          _isCorrect = false;
          _matchPairsComplete = false;
        });
      } else {
        final correctRatio = _correctCount / exercises.length;
        final stars = PointsConfig.starsFor(correctRatio);

        // Award XP / gems / streak before navigating (Busuu-style reward pipeline)
        ref.read(userProvider.notifier).addXp(lesson.xpReward);
        ref.read(userProvider.notifier).addGems(lesson.gemsReward);
        ref.read(userProvider.notifier).incrementStreak();

        ref.read(courseProvider.notifier).completeLesson(widget.lessonId);
        // Check if this was the last lesson in the course
        final currentCourse = ref.read(courseProvider);
        final hasRemainingLessons = currentCourse.sections.any((s) =>
            s.lessons.any((l) => !l.isCompleted && !l.isLocked));

        if (!mounted) return;
        // Delay navigation to next frame to avoid race with provider state rebuild
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context.pushReplacement(
            '/lesson/complete',
            extra: {
              'xpEarned': lesson.xpReward,
              'gemsEarned': lesson.gemsReward,
              'stars': stars,
              'correctCount': _correctCount,
              'totalExercises': exercises.length,
              'courseCompleted': !hasRemainingLessons,
            },
          );
        });
      }
    } else {
      bool correct;
      bool skipResult = false; // grammarTip/flashCard don't show correct/wrong
      if (currentExercise.type == ExerciseType.matchPairs) {
        correct = _matchPairsComplete;
      } else if (currentExercise.type == ExerciseType.grammarTip ||
                 currentExercise.type == ExerciseType.flashCard) {
        // Read-only exercises — always correct, skip result banner
        correct = true;
        skipResult = true;
      } else if (currentExercise.correctAnswerList != null &&
          currentExercise.correctAnswerList!.isNotEmpty) {
        correct = _selectedWords.length == currentExercise.correctAnswerList!.length &&
            _selectedWords
                .asMap()
                .entries
                .every((e) => e.value == currentExercise.correctAnswerList![e.key]);
      } else if (currentExercise.correctAnswer != null) {
        correct = _selectedAnswer == currentExercise.correctAnswer;
      } else {
        correct = _selectedAnswer != null;
      }
      if (correct) _correctCount++;
      
      if (skipResult) {
        // Teaching exercises: skip result, advance directly to next
        if (_currentIndex < exercises.length - 1) {
          setState(() {
            _currentIndex++;
            _selectedAnswer = null;
            _selectedWords = [];
            _showResult = false;
            _isCorrect = false;
            _matchPairsComplete = false;
          });
        } else {
          // Last exercise was a teaching one — go to completion
          final correctRatio = _correctCount / exercises.length;
          final stars = PointsConfig.starsFor(correctRatio);
          ref.read(userProvider.notifier).addXp(lesson.xpReward);
          ref.read(userProvider.notifier).addGems(lesson.gemsReward);
          ref.read(userProvider.notifier).incrementStreak();
          ref.read(courseProvider.notifier).completeLesson(widget.lessonId);
          final currentCourse = ref.read(courseProvider);
          final hasRemaining = currentCourse.sections.any((s) =>
              s.lessons.any((l) => !l.isCompleted && !l.isLocked));
          if (!mounted) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.pushReplacement(
              '/lesson/complete',
              extra: {
                'xpEarned': lesson.xpReward,
                'gemsEarned': lesson.gemsReward,
                'stars': stars,
                'correctCount': _correctCount,
                'totalExercises': exercises.length,
                'courseCompleted': !hasRemaining,
              },
            );
          });
        }
      } else {
        setState(() {
          _showResult = true;
          _isCorrect = correct;
        });
      }
    }
  }
}

class _MultipleChoiceOptions extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final bool showResult;
  final String? correctAnswer;
  final ValueChanged<String>? onSelect;

  const _MultipleChoiceOptions({
    required this.options,
    this.selected,
    this.showResult = false,
    this.correctAnswer,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return ListView.builder(
      itemCount: options.length,
      padding: EdgeInsets.zero,
      itemBuilder: (_, index) {
        final option = options[index];
        final isSelected = selected == option;
        final isCorrect = option == correctAnswer;

        Color borderColor = appTheme.border;
        Color textColor = appTheme.harborNavy;
        Color boxBg = Colors.transparent;
        Color boxFill = Colors.transparent;
        Widget? trailing;

        if (showResult) {
          if (isCorrect) {
            borderColor = AppColors.success;
            boxFill = AppColors.success;
            trailing = PhosphorIcon(
              PhosphorIcons.check(PhosphorIconsStyle.bold),
              size: 14.sp,
              color: Colors.white,
            );
          } else if (isSelected && !isCorrect) {
            borderColor = AppColors.error;
            boxFill = AppColors.error;
            trailing = PhosphorIcon(
              PhosphorIcons.x(PhosphorIconsStyle.bold),
              size: 14.sp,
              color: Colors.white,
            );
          }
        } else if (isSelected) {
          borderColor = appTheme.harborNavy;
          boxFill = appTheme.harborNavy;
          trailing = PhosphorIcon(
            PhosphorIcons.check(PhosphorIconsStyle.bold),
            size: 14.sp,
            color: Colors.white,
          );
        }

        final letterLabel = String.fromCharCode('A'.codeUnitAt(0) + index);

        return GestureDetector(
          onTap: onSelect != null
              ? () {
                  HapticFeedback.selectionClick();
                  onSelect!(option);
                }
              : null,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: boxBg,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: borderColor, width: isSelected || showResult ? 1.6 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(
                    color: boxFill,
                    borderRadius: BorderRadius.circular(2.r),
                    border: Border.all(
                      color: boxFill == Colors.transparent ? appTheme.border : Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: trailing ?? Text(
                    letterLabel,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: appTheme.onSurfaceVariant,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    option,
                    style: theme.textTheme.titleLarge?.copyWith(color: textColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GrammarTipContent extends StatelessWidget {
  final Exercise exercise;
  final String nativeLang;
  const _GrammarTipContent({required this.exercise, required this.nativeLang});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.bookOpen(PhosphorIconsStyle.fill),
                  size: 24.sp,
                  color: AppColors.secondary,
                ),
                SizedBox(width: 10.w),
                Text(
                  AppLocalizations.of(context)!.grammarTip,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              exercise.grammarRule?.resolve(nativeLang) ?? '',
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: appTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.exampleLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.secondary,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    exercise.grammarExample?.resolve(nativeLang) ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchPairsContent extends StatefulWidget {
  final List<WordPair> pairs;
  final VoidCallback? onComplete;
  const _MatchPairsContent({required this.pairs, this.onComplete});

  @override
  State<_MatchPairsContent> createState() => _MatchPairsContentState();
}

class _MatchPairsContentState extends State<_MatchPairsContent> with SingleTickerProviderStateMixin {
  String? _selectedLeft;
  final Set<String> _matchedLeft = {};
  final Set<String> _matchedRight = {};
  late final List<WordPair> _shuffledRight;
  String? _wrongRight; // Which right item was just matched wrong
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shuffledRight = List<WordPair>.from(widget.pairs)..shuffle();
    _shakeController = AnimationController(
      duration: Duration.zero,
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: 0), weight: 1),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  bool get _allMatched => _matchedLeft.length == widget.pairs.length;

  void _onTapLeft(String left) {
    if (_matchedLeft.contains(left)) return;
    setState(() {
      if (_selectedLeft == left) {
        _selectedLeft = null;
      } else if (_selectedLeft != null) {
        // Already have a left selected, tapping another left swaps selection
        _selectedLeft = left;
      } else {
        _selectedLeft = left;
      }
    });
  }

  void _onTapRight(String left, String right) {
    if (_matchedRight.contains(right)) return;
    if (_selectedLeft == null) return;
    final pair = widget.pairs.firstWhere(
      (p) => p.left == _selectedLeft,
      orElse: () => const WordPair(left: '', right: ''),
    );
    if (pair.right == right) {
      setState(() {
        _matchedLeft.add(_selectedLeft!);
        _matchedRight.add(right);
        _selectedLeft = null;
      });
      if (_matchedLeft.length == widget.pairs.length) {
        widget.onComplete?.call();
      }
    } else {
      // Wrong match: shake animation + clear after delay
      setState(() {
        _wrongRight = right;
      });
      _shakeController.forward(from: 0);
      HapticFeedback.heavyImpact();
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            _wrongRight = null;
            _selectedLeft = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      children: [
        Text(
          l10n.matchPairsInstruction,
          style: theme.textTheme.bodySmall?.copyWith(color: appTheme.onSurfaceVariant),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: Row(
            children: [
              // Left column (original order)
              Expanded(
                child: ListView(
                  children: widget.pairs.map((pair) {
                    final isSelected = _selectedLeft == pair.left;
                    final isMatched = _matchedLeft.contains(pair.left);
                    return GestureDetector(
                      onTap: () => _onTapLeft(pair.left),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: isMatched
                              ? appTheme.harborOrangeWash
                              : isSelected
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: isMatched
                                ? AppColors.primary
                                : isSelected
                                    ? AppColors.primary
                                    : appTheme.border,
                            width: isSelected || isMatched ? 1.6 : 1,
                          ),
                        ),
                        child: Text(
                          pair.left,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isMatched ? AppColors.primary : appTheme.harborIconFill,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 8.w),
              PhosphorIcon(PhosphorIcons.arrowsLeftRight(), size: 20.sp, color: appTheme.onSurfaceVariant),
              SizedBox(width: 8.w),
              // Right column (shuffled — build once in state, not on every rebuild)
              Expanded(
                child: ListView(
                  children: _shuffledRight.map((pair) {
                    final isMatched = _matchedRight.contains(pair.right);
                    final isWrong = _wrongRight == pair.right;
                    final child = GestureDetector(
                      onTap: () => _onTapRight(pair.left, pair.right),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: isMatched
                              ? appTheme.harborOrangeWash
                              : isWrong
                                  ? AppColors.error.withValues(alpha: 0.15)
                                  : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: isMatched
                                ? AppColors.primary
                                : isWrong
                                    ? AppColors.error
                                    : appTheme.border,
                            width: isMatched || isWrong ? 1.6 : 1,
                          ),
                        ),
                        child: Text(
                          pair.right,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isMatched
                                ? AppColors.primary
                                : isWrong
                                    ? AppColors.error
                                    : appTheme.harborIconFill,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    return isWrong
                        ? AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_shakeAnimation.value, 0),
                                child: child,
                              );
                            },
                            child: child,
                          )
                        : child;
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WordBankFillBlank extends StatelessWidget {
  final List<String> wordBank;
  final List<String> selectedWords;
  final bool showResult;
  final String correctAnswer;
  final ValueChanged<String>? onWordTap;
  final VoidCallback? onClear;
  final VoidCallback? onRemoveLast;
  final Function(int oldIndex, int newIndex)? onReorder;
  final String question;

  const _WordBankFillBlank({
    required this.wordBank,
    required this.selectedWords,
    required this.showResult,
    required this.correctAnswer,
    this.onWordTap,
    this.onClear,
    this.onRemoveLast,
    this.onReorder,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Answer display area
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: appTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: showResult
                  ? (selectedWords.join(' ') == correctAnswer)
                      ? AppColors.success
                      : AppColors.error
                  : appTheme.border,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: selectedWords.isEmpty
                    ? Text(
                        AppLocalizations.of(context)!.tapWordsToBuildAnswer,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: appTheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: selectedWords.asMap().entries.map((entry) {
                          final word = entry.value;
                          final index = entry.key;
                          final isCorrect = showResult &&
                              index < correctAnswer.split(' ').length &&
                              word == correctAnswer.split(' ')[index];
                          final isWrong = showResult && !isCorrect;

                          return GestureDetector(
                            onTap: showResult
                                ? null
                                : () {
                                    HapticFeedback.selectionClick();
                                    onWordTap?.call(word);
                                  },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? AppColors.successLight
                                    : isWrong
                                        ? AppColors.errorLight
                                        : AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: isCorrect
                                      ? AppColors.success
                                      : isWrong
                                          ? AppColors.error
                                          : AppColors.primary,
                                ),
                              ),
                              child: Text(
                                word,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: isCorrect
                                      ? AppColors.success
                                      : isWrong
                                          ? AppColors.error
                                          : AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
              if (selectedWords.isNotEmpty && !showResult) ...[
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onRemoveLast?.call();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: PhosphorIcon(
                      PhosphorIcons.backspace(),
                      size: 20.sp,
                      color: AppColors.error,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onClear?.call();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: appTheme.border,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: PhosphorIcon(
                      PhosphorIcons.eraser(),
                      size: 20.sp,
                      color: appTheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 24.h),
        // Word bank
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: wordBank.map((word) {
            final isUsed = selectedWords.contains(word);
            return GestureDetector(
              onTap: isUsed || showResult
                  ? null
                  : () {
                      HapticFeedback.selectionClick();
                      onWordTap?.call(word);
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isUsed
                      ? appTheme.border.withValues(alpha: 0.5)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: isUsed ? appTheme.border : appTheme.border,
                    width: isUsed ? 1 : 2,
                  ),
                  boxShadow: isUsed
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  word,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isUsed
                        ? appTheme.onSurfaceVariant
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ReorderExercise extends StatelessWidget {
  final List<String> words;
  final List<String> selectedWords;
  final bool showResult;
  final List<String> correctAnswerList;
  final ValueChanged<String>? onWordTap;
  final VoidCallback? onClear;
  final Function(int oldIndex, int newIndex)? onReorder;

  const _ReorderExercise({
    required this.words,
    required this.selectedWords,
    required this.showResult,
    required this.correctAnswerList,
    this.onWordTap,
    this.onClear,
    this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected words display with drag reorder
        if (selectedWords.isNotEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: appTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: showResult
                    ? (selectedWords.length == correctAnswerList.length &&
                            selectedWords.asMap().entries.every(
                              (e) => e.value == correctAnswerList[e.key],
                            ))
                        ? AppColors.success
                        : AppColors.error
                    : appTheme.border,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: selectedWords.asMap().entries.map((entry) {
                    final word = entry.value;
                    final index = entry.key;
                    final isCorrect = showResult &&
                        index < correctAnswerList.length &&
                        word == correctAnswerList[index];
                    final isWrong = showResult && !isCorrect;

                    return GestureDetector(
                      onTap: showResult
                          ? null
                          : () {
                              HapticFeedback.selectionClick();
                              onWordTap?.call(word);
                            },
                      child: Container(
                        key: ValueKey('${word}_$index'),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? AppColors.successLight
                              : isWrong
                                  ? AppColors.errorLight
                                  : AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: isCorrect
                                ? AppColors.success
                                : isWrong
                                    ? AppColors.error
                                    : AppColors.primary,
                          ),
                        ),
                        child: Text(
                          word,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isCorrect
                                ? AppColors.success
                                : isWrong
                                    ? AppColors.error
                                    : AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (!showResult && selectedWords.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onClear?.call();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.clearAll,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        SizedBox(height: 24.h),
        // Available words
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: words.map((word) {
            final isUsed = selectedWords.contains(word);
            return GestureDetector(
              onTap: isUsed || showResult
                  ? null
                  : () {
                      HapticFeedback.selectionClick();
                      onWordTap?.call(word);
                    },
              child: AnimatedScale(
                duration: const Duration(milliseconds: 150),
                scale: isUsed ? 0.95 : 1.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isUsed
                        ? appTheme.border.withValues(alpha: 0.3)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: isUsed ? appTheme.border : AppColors.primary.withValues(alpha: 0.3),
                      width: isUsed ? 1 : 2,
                    ),
                    boxShadow: isUsed
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Text(
                    word,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isUsed
                          ? appTheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DialogueCompletionContent extends StatelessWidget {
  final List<DialogueTurn> dialogue;
  final String? selectedAnswer;
  final bool showResult;
  final String correctAnswer;
  final ValueChanged<String>? onSelect;

  const _DialogueCompletionContent({
    required this.dialogue,
    this.selectedAnswer,
    required this.showResult,
    required this.correctAnswer,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return ListView.builder(
      itemCount: dialogue.length,
      padding: EdgeInsets.zero,
      itemBuilder: (_, index) {
        final turn = dialogue[index];
        final isLast = index == dialogue.length - 1 && turn.isUser;

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: turn.isUser
                ? AppColors.primary.withValues(alpha: 0.08)
                : appTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: isLast && showResult
                  ? (selectedAnswer == correctAnswer)
                      ? AppColors.success
                      : AppColors.error
                  : appTheme.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: turn.isUser
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Center(
                      child: PhosphorIcon(
                        turn.isUser
                            ? PhosphorIcons.user()
                            : PhosphorIcons.robot(),
                        size: 16.sp,
                        color: turn.isUser ? AppColors.primary : AppColors.secondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    turn.speaker,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (turn.isUser) ...[
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.youLabel,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12.h),
              if (turn.isUser && isLast)
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: (turn.text.split('___').first.split(' ') +
                          ['___'] +
                          turn.text.split('___').last.split(' '))
                      .where((s) => s.trim().isNotEmpty)
                      .map((word) {
                    if (word == '___') {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: showResult
                              ? (selectedAnswer == correctAnswer)
                                  ? AppColors.successLight
                                  : AppColors.errorLight
                              : AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: showResult
                                ? (selectedAnswer == correctAnswer)
                                    ? AppColors.success
                                    : AppColors.error
                                : AppColors.primary,
                          ),
                        ),
                        child: Text(
                          selectedAnswer?.isNotEmpty == true ? selectedAnswer! : '____',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: showResult
                                ? (selectedAnswer == correctAnswer)
                                    ? AppColors.success
                                    : AppColors.error
                                : AppColors.primary,
                          ),
                        ),
                      );
                    }
                    return Text(word, style: theme.textTheme.bodyLarge);
                  }).toList(),
                )
              else
                Text(turn.text, style: theme.textTheme.bodyLarge),
            ],
          ),
        );
      },
    );
  }
}

class _ImageIdentificationContent extends StatelessWidget {
  final String? imageUrl;
  final List<String> options;
  final String? selected;
  final bool showResult;
  final String? correctAnswer;
  final ValueChanged<String>? onSelect;

  const _ImageIdentificationContent({
    this.imageUrl,
    required this.options,
    this.selected,
    required this.showResult,
    this.correctAnswer,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: appTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: appTheme.border),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhosphorIcon(
                  PhosphorIcons.image(),
                  size: 64.sp,
                  color: appTheme.onSurfaceVariant,
                ),
                SizedBox(height: 12.h),
                Text(
                  AppLocalizations.of(context)!.chill_aiGeneratedImage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: options.map((option) {
            final isSelected = selected == option;
            final isCorrect = option == correctAnswer;

            Color borderColor = appTheme.border;
            Color? bgColor;
            if (showResult) {
              if (isCorrect) {
                borderColor = AppColors.success;
                bgColor = AppColors.successLight;
              } else if (isSelected && !isCorrect) {
                borderColor = AppColors.error;
                bgColor = AppColors.errorLight;
              }
            } else if (isSelected) {
              borderColor = AppColors.primary;
              bgColor = AppColors.primary.withValues(alpha: 0.1);
            }

            return GestureDetector(
              onTap: onSelect != null
                  ? () {
                      HapticFeedback.selectionClick();
                      onSelect!(option);
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: bgColor ?? theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: borderColor,
                    width: isSelected || showResult ? 2 : 1,
                  ),
                ),
                child: Text(
                  option,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: showResult && isCorrect
                        ? AppColors.success
                        : showResult && isSelected && !isCorrect
                            ? AppColors.error
                            : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ListenAndTypeContent extends StatefulWidget {
  final String? audioUrl;
  final String? selectedAnswer;
  final bool showResult;
  final String correctAnswer;
  final ValueChanged<String>? onAnswerChanged;

  const _ListenAndTypeContent({
    this.audioUrl,
    this.selectedAnswer,
    required this.showResult,
    required this.correctAnswer,
    this.onAnswerChanged,
  });

  @override
  State<_ListenAndTypeContent> createState() => _ListenAndTypeContentState();
}

class _ListenAndTypeContentState extends State<_ListenAndTypeContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _waveController.repeat();
        // Speak the correct answer using device TTS
        final tts = ProviderScope.containerOf(context).read(ttsServiceProvider);
        final lang = widget.correctAnswer.contains(RegExp(r'[぀-ゟ゠-ヿ]')) ? 'ja' : 'ko';
        tts.speak(widget.correctAnswer, lang);
      } else {
        _waveController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Audio player card
        GestureDetector(
          onTap: _togglePlay,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (_, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final value = _isPlaying
                            ? (0.5 +
                                0.5 *
                                    sin(_waveController.value * 2 * pi +
                                        index * 0.8))
                            : 0.3;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: 6.w,
                          height: (20 + value * 40).h,
                          decoration: BoxDecoration(
                            color: _isPlaying
                                ? AppColors.secondary
                                : appTheme.onSurfaceVariant,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        );
                      }),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PhosphorIcon(
                      _isPlaying
                          ? PhosphorIcons.pauseCircle(PhosphorIconsStyle.fill)
                          : PhosphorIcons.playCircle(PhosphorIconsStyle.fill),
                      size: 48.sp,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  _isPlaying ? AppLocalizations.of(context)!.playing : AppLocalizations.of(context)!.tapToPlay,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.h),
        // Text input
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: appTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: widget.showResult
                  ? (widget.selectedAnswer?.toLowerCase().trim() ==
                          widget.correctAnswer.toLowerCase().trim())
                      ? AppColors.success
                      : AppColors.error
                  : appTheme.border,
              width: 2,
            ),
          ),
          child: TextField(
            enabled: !widget.showResult,
            onChanged: widget.onAnswerChanged,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.typeWhatYouHear,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: appTheme.onSurfaceVariant,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _SpeakingContent extends StatefulWidget {
  final String prompt;
  final bool showResult;
  final String correctAnswer;
  final ValueChanged<String>? onSubmit;

  const _SpeakingContent({
    required this.prompt,
    required this.showResult,
    required this.correctAnswer,
    this.onSubmit,
  });

  @override
  State<_SpeakingContent> createState() => _SpeakingContentState();
}

class _SpeakingContentState extends State<_SpeakingContent>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _waveController.repeat(reverse: true);
      } else {
        _waveController.stop();
        widget.onSubmit?.call(widget.correctAnswer);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.prompt,
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          AppLocalizations.of(context)!.tapAndHoldMicrophone,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        // Waveform visualization
        if (_isRecording)
          AnimatedBuilder(
            animation: _waveController,
            builder: (_, child) {
              return Container(
                height: 80.h,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(20, (index) {
                    final value = 0.3 +
                        0.7 *
                            sin(_waveController.value * 2 * pi +
                                index * 0.5 +
                                index * 0.3);
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      width: 4.w,
                      height: (20 + value * 50).h,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.6 + value * 0.4),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    );
                  }),
                ),
              );
            },
          )
        else
          Container(
            height: 80.h,
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.holdToSpeak,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: appTheme.onSurfaceVariant,
              ),
            ),
          ),
        SizedBox(height: 40.h),
        // Record button
        GestureDetector(
          onTapDown: (_) => _toggleRecording(),
          onTapUp: (_) => _toggleRecording(),
          onTapCancel: () => _toggleRecording(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isRecording ? 100.w : 80.w,
            height: _isRecording ? 100.w : 80.w,
            decoration: BoxDecoration(
              color: _isRecording ? AppColors.error : AppColors.primary,
              borderRadius: BorderRadius.circular(50.r),
              boxShadow: [
                BoxShadow(
                  color: (_isRecording ? AppColors.error : AppColors.primary)
                      .withValues(alpha: 0.4),
                  blurRadius: _isRecording ? 30 : 20,
                  spreadRadius: _isRecording ? 4 : 0,
                ),
              ],
            ),
            child: Center(
              child: PhosphorIcon(
                _isRecording
                    ? PhosphorIcons.microphone(PhosphorIconsStyle.fill)
                    : PhosphorIcons.microphone(),
                size: 36.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }
}

class _ResultBanner extends StatelessWidget {
  final bool isCorrect;
  final String? explanation;

  const _ResultBanner({required this.isCorrect, this.explanation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final c = isCorrect ? AppColors.success : AppColors.error;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: c, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 18.w, height: 3, color: c),
              SizedBox(width: 8.w),
              Text(
                (isCorrect ? l10n.correct : l10n.incorrect).toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: c,
                  letterSpacing: 2.2,
                ),
              ),
            ],
          ),
          if ((explanation ?? '').isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              explanation!,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

// ===================== NEW EXERCISE TYPES (Busuu-inspired) =====================

class _FlashCardContent extends StatefulWidget {
  final String word;
  final String translation;
  final String? explanation;
  final VoidCallback? onFlip;

  const _FlashCardContent({
    required this.word,
    required this.translation,
    this.explanation,
    this.onFlip,
  });

  @override
  State<_FlashCardContent> createState() => _FlashCardContentState();
}

class _FlashCardContentState extends State<_FlashCardContent>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration.zero,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    HapticFeedback.lightImpact();
    widget.onFlip?.call();
    setState(() {
      _isFlipped = !_isFlipped;
      if (_isFlipped) {
        _controller.forward();
        // Speak the word when card is flipped to front
        final tts = ProviderScope.containerOf(context).read(ttsServiceProvider);
        final lang = widget.word.contains(RegExp(r'[぀-ゟ゠-ヿ]')) ? 'ja' : 'ko';
        tts.speak(widget.word, lang);
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          final angle = _controller.value * pi;
          final isFront = angle < pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? _buildFront(theme)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildBack(theme),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFront(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PhosphorIcon(
            PhosphorIcons.cards(),
            size: 40.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 16.h),
          Text(
            widget.word,
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context)!.tapToReveal,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.translation,
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppColors.success,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.explanation != null) ...[
            SizedBox(height: 8.h),
            Text(
              widget.explanation!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context)!.tapToFlipBack,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComprehensionContent extends StatelessWidget {
  final String passage;
  final String question;
  final List<String> options;
  final String? selected;
  final bool showResult;
  final String? correctAnswer;
  final ValueChanged<String>? onSelect;

  const _ComprehensionContent({
    required this.passage,
    required this.question,
    required this.options,
    this.selected,
    required this.showResult,
    this.correctAnswer,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: appTheme.border),
          ),
          child: Text(
            passage,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          question,
          style: theme.textTheme.titleLarge,
        ),
        SizedBox(height: 16.h),
        _MultipleChoiceOptions(
          options: options,
          selected: selected,
          showResult: showResult,
          correctAnswer: correctAnswer,
          onSelect: onSelect,
        ),
      ],
    );
  }
}

class _TrueFalseContent extends StatelessWidget {
  final String statement;
  final bool isTrue;
  final String? selected;
  final bool showResult;
  final ValueChanged<String>? onSelect;

  const _TrueFalseContent({
    required this.statement,
    required this.isTrue,
    this.selected,
    required this.showResult,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            statement,
            style: theme.textTheme.headlineSmall?.copyWith(height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 32.h),
        Row(
          children: [
            Expanded(
              child: _TrueFalseButton(
                label: AppLocalizations.of(context)!.trueLabel,
                value: 'true',
                isCorrect: isTrue,
                isSelected: selected == 'true',
                showResult: showResult,
                onTap: onSelect != null ? () => onSelect!('true') : null,
                color: AppColors.success,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _TrueFalseButton(
                label: AppLocalizations.of(context)!.falseLabel,
                value: 'false',
                isCorrect: !isTrue,
                isSelected: selected == 'false',
                showResult: showResult,
                onTap: onSelect != null ? () => onSelect!('false') : null,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrueFalseButton extends StatelessWidget {
  final String label;
  final String value;
  final bool isCorrect;
  final bool isSelected;
  final bool showResult;
  final VoidCallback? onTap;
  final Color color;

  const _TrueFalseButton({
    required this.label,
    required this.value,
    required this.isCorrect,
    required this.isSelected,
    required this.showResult,
    this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color bgColor = theme.colorScheme.surface;
    Color borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.2);

    if (showResult) {
      if (isCorrect) {
        bgColor = AppColors.success.withValues(alpha: 0.1);
        borderColor = AppColors.success;
      } else if (isSelected && !isCorrect) {
        bgColor = AppColors.error.withValues(alpha: 0.1);
        borderColor = AppColors.error;
      }
    } else if (isSelected) {
      bgColor = color.withValues(alpha: 0.1);
      borderColor = color;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          children: [
            PhosphorIcon(
              value == 'true'
                  ? PhosphorIcons.checkCircle()
                  : PhosphorIcons.xCircle(),
              size: 32.sp,
              color: isSelected || (showResult && isCorrect) ? color : null,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: theme.textTheme.titleLarge?.copyWith(
                color: isSelected || (showResult && isCorrect) ? color : null,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhraseBuilderPrefilledContent extends StatelessWidget {
  final List<String> options;
  final List<String> preFilledWords;
  final List<String> selectedWords;
  final bool showResult;
  final List<String> correctAnswerList;
  final ValueChanged<String>? onWordTap;
  final VoidCallback? onClear;

  const _PhraseBuilderPrefilledContent({
    required this.options,
    required this.preFilledWords,
    required this.selectedWords,
    required this.showResult,
    required this.correctAnswerList,
    this.onWordTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      children: [
        // Pre-filled words display
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: appTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: appTheme.border),
          ),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: [
              ...preFilledWords.map((word) => _buildChip(word, theme, isPrefilled: true)),
              ...selectedWords.map((word) => _buildChip(word, theme)),
              if (selectedWords.isEmpty && preFilledWords.isEmpty)
                Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.tapWordsToBuildSentence,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (onClear != null) ...[
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: onClear,
            child: Text(
              AppLocalizations.of(context)!.clear,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        SizedBox(height: 24.h),
        // Word bank
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          alignment: WrapAlignment.center,
          children: options.map((word) {
            final isUsed = preFilledWords.contains(word) || selectedWords.contains(word);
            return GestureDetector(
              onTap: isUsed ? null : () => onWordTap?.call(word),
              child: Opacity(
                opacity: isUsed ? 0.4 : 1.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: isUsed
                          ? appTheme.border
                          : AppColors.primary.withValues(alpha: 0.5),
                      width: isUsed ? 1 : 2,
                    ),
                  ),
                  child: Text(
                    word,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isUsed
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String word, ThemeData theme, {bool isPrefilled = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isPrefilled
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isPrefilled
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        word,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isPrefilled
              ? theme.colorScheme.primary
              : AppColors.primary,
        ),
      ),
    );
  }
}

class _WritingContent extends StatefulWidget {
  final String prompt;
  final String sampleAnswer;
  final bool showResult;
  final ValueChanged<String>? onSubmit;

  const _WritingContent({
    required this.prompt,
    required this.sampleAnswer,
    required this.showResult,
    this.onSubmit,
  });

  @override
  State<_WritingContent> createState() => _WritingContentState();
}

class _WritingContentState extends State<_WritingContent> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.prompt,
          style: theme.textTheme.headlineSmall,
        ),
        SizedBox(height: 24.h),
        TextField(
          controller: _controller,
          maxLines: 5,
          enabled: !widget.showResult,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.typeYourAnswerHere,
            filled: true,
            fillColor: appTheme.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(16.w),
          ),
        ),
        if (widget.showResult) ...[
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.sampleAnswer,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.sampleAnswer,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ] else ...[
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                widget.onSubmit?.call(_controller.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Text(
                AppLocalizations.of(context)!.submit,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
