import 'dart:async';
import 'package:flutter/material.dart';
import 'package:instalingo/data/exam_content.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/theme/app_theme.dart';

class MockTestScreen extends StatefulWidget {
  final MockTest test;
  const MockTestScreen({super.key, required this.test});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  int _currentIndex = 0;
  int _score = 0;
  final Map<int, String?> _answers = {};
  final Map<int, bool> _results = {};
  bool _showResult = false;
  bool _finished = false;
  Timer? _timer;
  int _secondsElapsed = 0;

  List<MockQuestion> get _questions => widget.test.questions;
  MockQuestion get _currentQ => _questions[_currentIndex];
  int get _totalQuestions => _questions.length;
  int get _answered => _answers.length;
  String? get _selectedAnswer => _answers[_currentIndex];
  bool? get _isCorrect => _results[_currentIndex];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _secondsElapsed++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _answer(String answer) {
    if (_showResult) return;
    final correct = answer == _currentQ.correctAnswer;
    setState(() {
      _answers[_currentIndex] = answer;
      _results[_currentIndex] = correct;
      if (correct) _score++;
      _showResult = true;
    });
  }

  void _next() {
    if (_currentIndex < _totalQuestions - 1) {
      setState(() {
        _currentIndex++;
        _showResult = false;
      });
    } else {
      setState(() => _finished = true);
      _timer?.cancel();
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    if (_finished) return _buildResults(l10n, theme);

    final section = widget.test.sections.firstWhere(
      (s) => s.sectionId == _currentQ.section,
      orElse: () => widget.test.sections.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.test.examName, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Text(_formatTime(_secondsElapsed), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: appTheme.harborInkOnNavy)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            _ProgressBar(current: _answered, total: _totalQuestions, section: section.title),
            // Question
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: _currentQ.type == MockQuestionType.fill_in_blank
                    ? _FillInBlankQuestion(question: _currentQ, selected: _selectedAnswer, showResult: _showResult, onSelect: _answer)
                    : _MultipleChoiceQuestion(question: _currentQ, selected: _selectedAnswer, showResult: _showResult, onSelect: _answer),
              ),
            ),
            // Explanation + Next button
            if (_showResult) _ExplanationBar(question: _currentQ, isCorrect: _isCorrect ?? false, onNext: _next, l10n: l10n, isLast: _currentIndex == _totalQuestions - 1),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(AppLocalizations l10n, ThemeData theme) {
    final appTheme = context.appTheme;
    final pct = (_score / _totalQuestions * 100).round();
    final passed = pct >= 60;
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop())),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(passed ? Icons.emoji_events : Icons.school, size: 80.sp, color: passed ? Colors.amber : appTheme.harborInkOnNavyMuted),
              SizedBox(height: 24.h),
              Text(passed ? l10n.examCompleteTitle : l10n.courseCompleteTitle, style: theme.textTheme.displayMedium, textAlign: TextAlign.center),
              SizedBox(height: 16.h),
              Text('${l10n.yourScore}: $_score / $_totalQuestions ($pct%)', style: theme.textTheme.titleLarge),
              SizedBox(height: 8.h),
              Text(passed ? '✅ ${l10n.predictedLevel}' : l10n.keepPracticing, style: theme.textTheme.bodyLarge?.copyWith(color: appTheme.onSurfaceVariant)),
              SizedBox(height: 32.h),
              SizedBox(width: double.infinity, height: 56.h, child: ElevatedButton(onPressed: () => context.pop(), child: Text(l10n.continueText, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)))),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current, total;
  final String section;
  const _ProgressBar({required this.current, required this.total, required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${current + 1}/$total', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
              Text(section, style: TextStyle(fontSize: 11.sp, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(value: current / total, minHeight: 6.h, backgroundColor: Theme.of(context).dividerColor, valueColor: const AlwaysStoppedAnimation(AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _MultipleChoiceQuestion extends StatelessWidget {
  final MockQuestion question;
  final String? selected;
  final bool showResult;
  final Function(String) onSelect;

  const _MultipleChoiceQuestion({required this.question, required this.selected, this.showResult = false, required this.onSelect});

  List<String> get _allOptions {
    final opts = [...question.distractors, question.correctAnswer];
    opts.shuffle();
    return opts;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question, style: theme.textTheme.titleLarge?.copyWith(fontSize: 20.sp, height: 1.5)),
        SizedBox(height: 24.h),
        ..._allOptions.map((opt) {
          Color? bgColor;
          Color? borderColor;
          if (showResult) {
            if (opt == question.correctAnswer) {
              bgColor = Colors.green.withValues(alpha: 0.1);
              borderColor = Colors.green;
            } else if (opt == selected && opt != question.correctAnswer) {
              bgColor = Colors.red.withValues(alpha: 0.1);
              borderColor = Colors.red;
            }
          } else if (opt == selected) {
            bgColor = AppColors.primary.withValues(alpha: 0.1);
            borderColor = AppColors.primary;
          }
          return GestureDetector(
            onTap: showResult ? null : () => onSelect(opt),
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: bgColor ?? theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: borderColor ?? theme.dividerColor, width: borderColor != null ? 2 : 1),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(opt, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16.sp))),
                  if (showResult && opt == question.correctAnswer) const Icon(Icons.check_circle, color: Colors.green),
                  if (showResult && opt == selected && opt != question.correctAnswer) const Icon(Icons.cancel, color: Colors.red),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _FillInBlankQuestion extends StatefulWidget {
  final MockQuestion question;
  final String? selected;
  final bool showResult;
  final Function(String) onSelect;

  const _FillInBlankQuestion({required this.question, required this.selected, this.showResult = false, required this.onSelect});

  @override
  State<_FillInBlankQuestion> createState() => _FillInBlankQuestionState();
}

class _FillInBlankQuestionState extends State<_FillInBlankQuestion> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selected != null) _controller.text = widget.selected!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allOpts = [...widget.question.distractors, widget.question.correctAnswer]..shuffle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question.question, style: theme.textTheme.titleLarge?.copyWith(fontSize: 20.sp, height: 1.5)),
        SizedBox(height: 24.h),
        TextField(
          controller: _controller,
          enabled: !widget.showResult,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.exTypeWhatYouHear,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
            suffixIcon: widget.showResult
                ? Icon(_controller.text.trim() == widget.question.correctAnswer ? Icons.check_circle : Icons.cancel,
                      color: _controller.text.trim() == widget.question.correctAnswer ? Colors.green : Colors.red)
                : IconButton(icon: const Icon(Icons.check), onPressed: () => widget.onSelect(_controller.text.trim())),
          ),
        ),
        if (widget.showResult) ...[
          SizedBox(height: 8.h),
          Text('${AppLocalizations.of(context)!.correct}: ${widget.question.correctAnswer}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
        ],
        SizedBox(height: 16.h),
        Wrap(spacing: 8.w, runSpacing: 8.h, children: allOpts.map((opt) => ActionChip(
          label: Text(opt),
          onPressed: widget.showResult ? null : () {
            _controller.text = opt;
            widget.onSelect(opt);
          },
        )).toList()),
      ],
    );
  }
}

class _ExplanationBar extends StatelessWidget {
  final MockQuestion question;
  final bool isCorrect;
  final VoidCallback onNext;
  final AppLocalizations l10n;
  final bool isLast;

  const _ExplanationBar({required this.question, required this.isCorrect, required this.onNext, required this.l10n, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final expl = question.explanation.resolve(locale);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withValues(alpha: 0.08) : Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isCorrect ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(isCorrect ? Icons.check_circle : Icons.info_outline, color: isCorrect ? Colors.green : Colors.red, size: 20.sp),
            SizedBox(width: 8.w),
            Text(isCorrect ? l10n.correct : l10n.incorrect, style: theme.textTheme.titleSmall?.copyWith(color: isCorrect ? Colors.green : Colors.red, fontWeight: FontWeight.w700)),
          ]),
          if (expl.isNotEmpty) ...[SizedBox(height: 8.h), Text(expl, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)))],
          SizedBox(height: 12.h),
          SizedBox(width: double.infinity, height: 44.h, child: ElevatedButton(onPressed: onNext, child: Text(isLast ? l10n.seeResults : l10n.continueText))),
        ],
      ),
    );
  }
}
