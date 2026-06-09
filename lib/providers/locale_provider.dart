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
    try {
      final prefs = await SharedPreferences.getInstance();
      // If user already set a preference, use it
      final savedCode = prefs.getString('app_locale');
      if (savedCode != null) {
        state = _parseLocale(savedCode);
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
    } catch (_) {
      // Keep the default locale (en) if SharedPreferences is unavailable.
      // The app remains functional; locale preference will be persisted
      // on the next successful setLocale() call.
    } finally {
      if (!_readyCompleter.isCompleted) _readyCompleter.complete();
    }
  }

  /// Detect the best locale from the platform/browser language.
  Locale _detectLocale() {
    try {
      final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final full = '${platformLocale.languageCode}_${platformLocale.countryCode ?? ''}';
      if (full.startsWith('zh_HK') || full.startsWith('zh_TW') || full.startsWith('zh_MO')) {
        return const Locale('zh', 'TW');
      }
      if (full.startsWith('zh')) {
        return const Locale('zh', 'CN');
      }
      if (full.startsWith('ja')) return const Locale('ja');
      if (full.startsWith('ko')) return const Locale('ko');
      if (full.startsWith('ms')) return const Locale('ms');
      if (full.startsWith('ar')) return const Locale('ar');
    } catch (_) {
      // silently fall back to default locale — platform detection unavailable
    }
    return const Locale('en');
  }

  String _localeCode(Locale locale) {
    final lang = locale.languageCode;
    final country = locale.countryCode;
    if (lang == 'zh') {
      if (country == 'TW' || country == 'HK' || country == 'MO') return 'zh_TW';
      return 'zh_CN';
    }
    if (lang == 'ja') return 'ja';
    if (lang == 'ko') return 'ko';
    if (lang == 'ms') return 'ms';
    if (lang == 'ar') return 'ar';
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
    if (code == 'zh' || code == 'zh_Hans' || code == 'zh_Hans_CN') return const Locale('zh', 'CN');
    if (code == 'zh_CN') return const Locale('zh', 'CN');
    if (code == 'zh_TW' || code == 'zh_Hant' || code == 'zh_Hant_TW') return const Locale('zh', 'TW');
    return Locale(code);
  }

  bool get isRtl {
    return ['ar', 'he', 'fa', 'ur'].contains(state.languageCode);
  }
}
