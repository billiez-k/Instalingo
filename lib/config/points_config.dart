/// Points and rewards configuration for InstaLingo v2.
///
/// Centralized values for XP, gems, streaks, and shields.
/// In production this would be server-configured.
class PointsConfig {
  const PointsConfig._();

  // Swipe rewards
  static const int cardSwipedWorth = 5;     // XP per card swiped
  static const int cardsSavedWorth = 3;     // XP per card saved/collected
  static const int dailyGoalWorth = 50;     // XP bonus for hitting daily goal
  static const int streakDayWorth = 10;     // XP per streak day
  static const int gemPerDay = 5;           // Gems awarded for daily goal

  // SRS review rewards
  static const int smartReviewWorth = 3;    // XP per vocab review card

  // Streak
  static const int streakShieldCost = 100;  // Gems to buy a streak shield

  // Star thresholds (percentage of correct answers)
  static int starsFor(double correctRatio) {
    if (correctRatio >= 1.0) return 3;
    if (correctRatio >= 0.5) return 2;
    return 1;
  }
}
