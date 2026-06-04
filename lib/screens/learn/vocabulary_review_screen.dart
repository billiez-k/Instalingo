import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/providers/course_provider.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VocabularyReviewScreen extends StatefulWidget {
  const VocabularyReviewScreen({super.key});

  @override
  State<VocabularyReviewScreen> createState() => _VocabularyReviewScreenState();
}

class _VocabularyReviewScreenState extends State<VocabularyReviewScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with course vocabulary from provider
  // final course = ref.watch(courseProvider);
  // final _words = course.sections.expand((s) => s.lessons).expand((l) => l.vocabulary).toList();
  final _words = [
    _WordCardData(
      word: 'Fragrance',
      phonetic: '/ˈfreɪɡrəns/',
      translation: '香味',
      explanation: 'A sweet or pleasant smell, especially from flowers or perfume.',
      example: 'The fragrance of roses filled the garden.',
    ),
    _WordCardData(
      word: 'Aroma',
      phonetic: '/əˈroʊmə/',
      translation: '芳香',
      explanation: 'A distinctive, typically pleasant smell.',
      example: 'The aroma of freshly ground coffee woke everyone up.',
    ),
    _WordCardData(
      word: 'Dough',
      phonetic: '/doʊ/',
      translation: '面团',
      explanation: 'A thick mixture of flour and liquid used for baking.',
      example: 'She kneaded the dough for ten minutes.',
    ),
    _WordCardData(
      word: 'Harvest',
      phonetic: '/ˈhɑːrvɪst/',
      translation: '收获',
      explanation: 'The process or period of gathering crops.',
      example: 'The harvest season begins in September.',
    ),
    _WordCardData(
      word: 'Bouquet',
      phonetic: '/buːˈkeɪ/',
      translation: '花束',
      explanation: 'An attractively arranged bunch of flowers.',
      example: 'He brought her a beautiful bouquet of roses.',
    ),
  ];

  int _currentIndex = 0;
  bool _isFlipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    HapticFeedback.lightImpact();
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  void _nextCard() {
    HapticFeedback.mediumImpact();
    if (_isFlipped) {
      _flipController.reverse();
      _isFlipped = false;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _words.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final current = _words[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.vocabularyReview),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: Text(
                '${_currentIndex + 1}/${_words.length}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Progress
              ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _words.length,
                  minHeight: 6.h,
                  backgroundColor: context.appTheme.border,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              SizedBox(height: 32.h),
              // Flashcard
              Expanded(
                child: GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (_, child) {
                      final angle = _flipAnimation.value * pi;
                      final isFront = angle < pi / 2;

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        alignment: Alignment.center,
                        child: isFront
                            ? _CardFront(word: current)
                            : Transform(
                                transform: Matrix4.identity()..rotateY(pi),
                                alignment: Alignment.center,
                                child: _CardBack(word: current),
                              ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              // Controls
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: PhosphorIcons.arrowUUpLeft(),
                      label: l10n.flashcardHard,
                      color: AppColors.error,
                      onTap: _nextCard,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _ActionButton(
                      icon: PhosphorIcons.check(),
                      label: l10n.flashcardGood,
                      color: AppColors.primary,
                      onTap: _nextCard,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _ActionButton(
                      icon: PhosphorIcons.star(PhosphorIconsStyle.fill),
                      label: l10n.flashcardEasy,
                      color: AppColors.gold,
                      onTap: _nextCard,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordCardData {
  final String word;
  final String phonetic;
  final String translation;
  final String explanation;
  final String example;

  _WordCardData({
    required this.word,
    required this.phonetic,
    required this.translation,
    required this.explanation,
    required this.example,
  });
}

class _CardFront extends StatelessWidget {
  final _WordCardData word;
  const _CardFront({required this.word});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: appTheme.border),
        boxShadow: [
          BoxShadow(
            color: appTheme.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.primary, width: 1.4),
            ),
            child: PhosphorIcon(
              PhosphorIcons.cards(),
              size: 26.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            word.word,
            style: theme.textTheme.displayLarge?.copyWith(fontSize: 36.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            word.phonetic,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(2.r),
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: Text(
              l10n.tapToFlip.toUpperCase(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final _WordCardData word;
  const _CardBack({required this.word});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.primary, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: appTheme.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.word,
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: Text(
                    word.phonetic,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              word.translation,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              word.explanation,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            SizedBox(height: 16.h),
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
                    l10n.exampleLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '"${word.example}"',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.5,
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

class _ActionButton extends StatelessWidget {
  final PhosphorIconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            PhosphorIcon(icon, size: 24.sp, color: color),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
