import 'dart:math';

import 'package:instalingo/models/vocab_card.dart';

/// FSRS-5 spaced repetition scheduler.
///
/// Implements the Free Spaced Repetition Scheduler v5 algorithm
/// for adaptive vocabulary review scheduling.
class FSRSScheduler {
  FSRSScheduler._();

  // FSRS-5 weights
  static const List<double> _w = [
    0.4, 0.6, 2.4, 5.8, 4.93, 0.94, 0.86, 0.01,
    1.49, 0.14, 0.94, 2.18, 0.05, 0.34, 1.26, 0.29, 2.61,
  ];

  static const double _decay = -0.5;
  static const double _factor = 19.0 / 81.0;

  /// Schedule a review and return updated SRSData.
  ///
  /// [state] — current state: 'new', 'learning', 'review', 'relearning'
  /// [stability] — current stability value
  /// [difficulty] — current difficulty value
  /// [rating] — user rating: 1=Again, 2=Hard, 3=Good, 4=Easy
  /// [lapseCount] — current lapse count
  static SRSData schedule({
    required String cardId,
    required String state,
    required double stability,
    required double difficulty,
    required int rating,
    required int lapseCount,
  }) {
    final now = DateTime.now();
    int newLapseCount = lapseCount;
    int newReviewCount = 1;
    String newState = state;
    double newStability = stability;
    double newDifficulty = difficulty;

    if (rating == 1) {
      // Again
      newLapseCount += 1;
      newState = 'relearning';
      newStability = _stabilityAfterFailure(stability, newLapseCount);
      newDifficulty = (difficulty + 1.0).clamp(1.0, 10.0);
    } else {
      // Hard / Good / Easy
      newState = 'review';

      if (state == 'new' || state == 'learning') {
        // First-time learning to review transition
        newStability = _initialStability(rating);
        newDifficulty = _initialDifficulty(rating);
      } else {
        // Relearning to review transition
        if (state == 'relearning') {
          newStability = _stabilityShortTerm(stability, rating);
          newDifficulty = (difficulty + _deltaD(rating)).clamp(1.0, 10.0);
        } else {
          // Normal review
          newStability = _nextStability(stability, difficulty, rating);
          newDifficulty = (difficulty + _deltaD(rating)).clamp(1.0, 10.0);
        }
      }
    }

    final interval = _nextInterval(newStability);
    final due = now.add(Duration(days: interval.ceil()));

    return SRSData(
      cardId: cardId,
      state: newState,
      stability: newStability,
      difficulty: newDifficulty,
      due: due,
      lastReview: now,
      reviewCount: newReviewCount,
      lapseCount: newLapseCount,
    );
  }

  /// Calculate retrievability at a given elapsed time.
  static double retrievability(double stability, double elapsedDays) {
    return pow(1 + _factor * elapsedDays / stability, _decay).toDouble();
  }

  // --- Private helpers ---

  static double _initialStability(int rating) {
    switch (rating) {
      case 2:
        return _w[0];
      case 3:
        return _w[1];
      case 4:
        return _w[2];
      default:
        return _w[0];
    }
  }

  static double _initialDifficulty(int rating) {
    switch (rating) {
      case 2:
        return 5.0;
      case 3:
        return 4.0;
      case 4:
        return 3.0;
      default:
        return 5.0;
    }
  }

  static double _deltaD(int rating) {
    switch (rating) {
      case 2:
        return _w[6];
      case 3:
        return _w[7];
      case 4:
        return _w[8];
      default:
        return 0;
    }
  }

  static double _nextStability(double s, double d, int rating) {
    final hardPenalty = rating == 2 ? _w[15] : 1.0;
    final easyBonus = rating == 4 ? _w[16] : 1.0;
    return s *
        (1 +
            _w[10] *
                (11 - d) *
                pow(s, -_w[11]) *
                ((1 - retrievability(s, 1)) * _w[12] + 1) *
                hardPenalty *
                easyBonus);
  }

  static double _stabilityAfterFailure(double s, int lapses) {
    return s * _w[13] * pow(_w[14], lapses - 1);
  }

  static double _stabilityShortTerm(double s, int rating) {
    switch (rating) {
      case 2:
        return s * _w[3];
      case 3:
        return s * _w[4];
      case 4:
        return s * _w[5];
      default:
        return s * _w[3];
    }
  }

  static double _nextInterval(double stability) {
    return stability * 9.0 * (pow(1.0 / _factor, 1.0 / _decay) - 1);
  }
}
