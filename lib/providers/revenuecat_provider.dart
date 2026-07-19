import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/providers/user_provider.dart';

/// Purchase status provider.
///
/// Currently uses local SharedPreferences for demo mode.
/// To add real payments later: add `purchases_flutter` dependency
/// and wire RevenueCat SDK in this file.

/// Tracks whether a purchase is in progress (for loading UI state).
final purchaseInProgressProvider = StateProvider<bool>((ref) => false);

/// Provider: is the user Pro?
final isProProvider = Provider<bool>((ref) {
  return ref.watch(userProvider).isPro;
});
