/// Busuu-style points configuration.
///
/// In production this would be server-configured (PointsConfigDomainModel).
/// For the demo, values are centralized here so they can be changed in one place
/// rather than hardcoded across lesson constructors and completion logic.
class PointsConfig {
  const PointsConfig._();

  // Base lesson rewards
  static const int unitWorth = 10;          // XP per lesson completed
  static const int activityWorth = 5;       // Gems per lesson completed
  static const int smartReviewWorth = 3;    // XP per vocab review card
  static const int checkpointWorth = 50;    // XP for checkpoint/placement test
  static const int correctionWorth = 2;     // Gems for peer correction (future)

  // Streak
  static const int streakFreezeCost = 50;   // Gems to repair streak
  static const int streakShieldCost = 100; // Gems to buy a freeze shield

  // Star thresholds (percentage of correct answers)
  static int starsFor(double correctRatio) {
    if (correctRatio >= 1.0) return 3;
    if (correctRatio >= 0.5) return 2;
    return 1;
  }
}
