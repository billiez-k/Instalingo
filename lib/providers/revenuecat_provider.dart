import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/providers/user_provider.dart';

/// Placeholder for RevenueCat subscription management.
///
/// Reads isPro status from userProvider for now.
final isProProvider = Provider<bool>((ref) {
  // TODO: Step 2 -- RevenueCat integration
  // - Initialize RevenueCat with API key
  // - Fetch offerings and entitlements
  // - Sync customerInfo with userProvider
  // - Handle promo offers and restore purchases
  return ref.watch(userProvider).isPro;
});
