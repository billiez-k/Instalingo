import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Emits true once the locale has been loaded from SharedPreferences.
/// Use this to gate UI rendering — prevents ☒ tofu characters and English
/// flash by waiting until the correct locale is resolved.
final localeReadyProvider = FutureProvider<bool>((ref) async {
  // Wait for the locale to stabilize (initial _load completes)
  final notifier = ref.read(localeProvider.notifier);
  await notifier._ready;
  return true;
});

class LocaleNotifier extends StateNotifier<Locale> {
  final Completer<void> _readyCompleter = Completer<void>();
  Future<void> get _ready => _readyCompleter.future;

  LocaleNotifier() : super(const Locale('en')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    // If user already set a preference, use it
    final savedCode = prefs.getString('app_locale');
    if (savedCode != null) {
      state = _parseLocale(savedCode);
      if (!_readyCompleter.isCompleted) _readyCompleter.complete();
      return;
    }
    // Auto-detect from device/browser region so onboarding pages show
    // in the user's native language before they even choose a language.
    // Taiwan (zh-TW, zh-HK) → Traditional Chinese
    // China (zh-CN, zh-SG) → Simplified Chinese
    // Japan (ja) → Japanese, etc.
    final detected = _detectLocale();
    state = detected;
    await prefs.setString('app_locale', _localeCode(detected));
    if (!_readyCompleter.isCompleted) _readyCompleter.complete();
  }

  /// Detect the best locale from the platform/browser language.
  /// v2 only supports en and zh_TW.
  Locale _detectLocale() {
    try {
      final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final full = '${platformLocale.languageCode}_${platformLocale.countryCode ?? ''}';
      if (full.startsWith('zh_HK') || full.startsWith('zh_TW') || full.startsWith('zh_MO')) {
        return const Locale('zh', 'TW');
      }
      if (full.startsWith('zh')) {
        return const Locale('zh', 'TW');
      }
    } catch (_) {}
    return const Locale('en');
  }

  String _localeCode(Locale locale) {
    if (locale.languageCode == 'zh' && locale.countryCode == 'TW') return 'zh_TW';
    return 'en';
  }

  Future<void> setLocale(String languageCode) async {
    // Set state synchronously so UI updates immediately.
    // Persistence happens asynchronously in the background.
    state = _parseLocale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', languageCode);
  }

  Locale _parseLocale(String code) {
    if (code == 'zh_CN') return const Locale('zh', 'CN');
    if (code == 'zh_TW') return const Locale('zh', 'TW');
    return Locale(code);
  }

  bool get isRtl {
    return ['ar', 'he', 'fa', 'ur'].contains(state.languageCode);
  }
}
