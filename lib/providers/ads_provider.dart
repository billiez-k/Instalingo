import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Minimal ad management placeholder.
///
/// Returns false for now (ads disabled).
/// Will show an ad every 5-7 cards once AdMob is integrated.
final adsProvider = Provider<bool>((ref) {
  return false;
});

/// Whether an ad should be shown after the current card.
// TODO: Step 2 -- AdMob card ads
final shouldShowAdProvider = Provider<bool>((ref) {
  // AdMob integration will replace this logic:
  // - Track cards swiped since last ad
  // - Show ad every 5-7 cards
  // - Respect isPro (no ads for Pro users)
  return false;
});
