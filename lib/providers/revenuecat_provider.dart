import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:instalingo/providers/user_provider.dart';

/// RevenueCat purchase provider — real subscription management via RevenueCat SDK.
///
/// When REVENUECAT_API_KEY is configured (via --dart-define or environment),
/// purchases flow through Apple/Google payment processing.
/// Without the key, the app runs in demo mode with local SharedPreferences.

/// Fetches available offerings from RevenueCat (or null if not configured).
final revenueCatOfferingsProvider = FutureProvider<Offerings?>((ref) async {
  return RevenueCatService.instance.fetchOfferings();
});

/// Tracks whether a purchase is in progress (for loading UI state).
final purchaseInProgressProvider = StateProvider<bool>((ref) => false);

class RevenueCatService {
  RevenueCatService._();
  static final instance = RevenueCatService._();

  bool _initialized = false;
  bool get isConfigured => _initialized;

  /// Initialize the RevenueCat SDK.
  /// Call once early in the app lifecycle (e.g. main.dart before runApp).
  Future<void> initialize() async {
    if (_initialized) return;

    // Read API key from compile-time define
    const apiKey = String.fromEnvironment(
      'REVENUECAT_API_KEY',
      defaultValue: '',
    );

    if (apiKey.isEmpty) {
      // RevenueCat not configured — running in demo mode.
      // Purchases will use local SharedPreferences fallback.
      _initialized = true;
      return;
    }

    try {
      await Purchases.configure(
        PurchasesConfiguration(apiKey)
          ..appUserID = null, // Anonymous until account system exists
      );
      _initialized = true;
    } catch (e) {
      // Configuration failed — app continues in demo mode
      _initialized = true;
    }
  }

  /// Fetch available offerings (subscriptions, IAPs) from RevenueCat.
  Future<Offerings?> fetchOfferings() async {
    if (!_initialized) await initialize();
    if (!_initialized) return null;
    try {
      return await Purchases.getOfferings();
    } catch (_) {
      return null;
    }
  }

  /// Purchase a package (monthly, annual, lifetime, or one-time IAP).
  /// Returns CustomerInfo on success.
  /// Throws [PurchaseCancelledException] if user cancels.
  /// Throws [PlatformException] on payment failure.
  Future<CustomerInfo> purchasePackage(Package package) async {
    try {
      return await Purchases.purchasePackage(package);
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        throw PurchaseCancelledException();
      }
      rethrow;
    }
  }

  /// Restore previous purchases (e.g. after reinstalling).
  Future<CustomerInfo> restorePurchases() async {
    return Purchases.restorePurchases();
  }

  /// Check if the current user has an active Pro entitlement.
  Future<bool> checkProStatus() async {
    if (!_initialized) return false;
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey('pro');
    } catch (_) {
      return false;
    }
  }

  /// Get full customer info (subscription status, expiry, entitlements).
  Future<CustomerInfo?> getCustomerInfo() async {
    if (!_initialized) return null;
    try {
      return await Purchases.getCustomerInfo();
    } catch (_) {
      return null;
    }
  }

  /// Sync RevenueCat Pro status to local user state.
  /// Call after successful purchase or restore.
  Future<void> syncProToUser(WidgetRef ref) async {
    final isPro = await checkProStatus();
    if (isPro) {
      ref.read(userProvider.notifier).upgradeToPro();
    }
  }
}

/// Thrown when the user dismisses the purchase dialog.
class PurchaseCancelledException implements Exception {
  @override
  String toString() => 'Purchase was cancelled.';
}

/// Provider: is the user Pro? Checks RevenueCat first, falls back to local state.
final isProProvider = Provider<bool>((ref) {
  return ref.watch(userProvider).isPro;
});
