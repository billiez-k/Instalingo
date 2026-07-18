import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:instalingo/services/sound_service.dart';

final sharedPrefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Emits true once the dark mode preference has been loaded from SharedPreferences.
/// Gate on this to prevent a light-theme flash before the saved preference is read.
final darkModeReadyProvider = FutureProvider<bool>((ref) async {
  await ref.read(darkModeProvider.notifier).ready;
  return ref.read(darkModeProvider);
});

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier(ref);
});

class DarkModeNotifier extends StateNotifier<bool> {
  final Ref _ref;
  final Completer<void> _readyCompleter = Completer<void>();
  Future<void> get ready => _readyCompleter.future;

  DarkModeNotifier(this._ref) : super(false) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await _ref.read(sharedPrefsProvider.future);
      state = prefs.getBool('dark_mode') ?? false;
    } catch (_) {
      // Keep default (false/light) if SharedPreferences fails
    } finally {
      if (!_readyCompleter.isCompleted) _readyCompleter.complete();
    }
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setBool('dark_mode', state);
  }
}

final soundEnabledProvider = StateNotifierProvider<SoundNotifier, bool>((ref) {
  return SoundNotifier(ref);
});

class SoundNotifier extends StateNotifier<bool> {
  final Ref _ref;

  SoundNotifier(this._ref) : super(true) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    state = prefs.getBool('sound_enabled') ?? true;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setBool('sound_enabled', state);
  }
}

final onboardingCompleteProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier(ref);
});

/// Emits true once the onboarding state has been loaded from SharedPreferences.
/// The splash screen MUST await this before reading [onboardingCompleteProvider]
/// to avoid routing to /onboarding for every app launch.
final onboardingReadyProvider = FutureProvider<bool>((ref) async {
  await ref.read(onboardingCompleteProvider.notifier).ready;
  return ref.read(onboardingCompleteProvider);
});

class OnboardingNotifier extends StateNotifier<bool> {
  final Ref _ref;
  final Completer<void> _readyCompleter = Completer<void>();
  Future<void> get ready => _readyCompleter.future;

  OnboardingNotifier(this._ref) : super(false) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await _ref.read(sharedPrefsProvider.future);
      state = prefs.getBool('onboarding_complete') ?? false;
    } catch (_) {
      // Keep default (false/not completed) if SharedPreferences fails.
      // User will go through onboarding; preference persists on next save.
    } finally {
      if (!_readyCompleter.isCompleted) _readyCompleter.complete();
    }
  }

  Future<void> complete() async {
    state = true;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setBool('onboarding_complete', true);
  }
}

final soundServiceProvider = Provider<SoundService>((ref) {
  return SoundService(ref);
});

final ttsEnabledProvider = StateNotifierProvider<TtsNotifier, bool>((ref) {
  return TtsNotifier(ref);
});

class TtsNotifier extends StateNotifier<bool> {
  final Ref _ref;

  TtsNotifier(this._ref) : super(true) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    state = prefs.getBool('tts_enabled') ?? true;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setBool('tts_enabled', state);
  }
}

/// Controls whether 🔥 Spicy (slang) content appears in swipe/collections.
/// On by default for adult audiences.
final spicyEnabledProvider = StateNotifierProvider<SpicyNotifier, bool>((ref) {
  return SpicyNotifier(ref);
});

class SpicyNotifier extends StateNotifier<bool> {
  final Ref _ref;

  SpicyNotifier(this._ref) : super(true) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    state = prefs.getBool('spicy_enabled') ?? true;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setBool('spicy_enabled', state);
  }
}

/// Controls whether 💀 Wild (vulgar/adult) content appears.
/// OFF by default — requires explicit user opt-in.
final wildEnabledProvider = StateNotifierProvider<WildNotifier, bool>((ref) {
  return WildNotifier(ref);
});

class WildNotifier extends StateNotifier<bool> {
  final Ref _ref;

  WildNotifier(this._ref) : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    state = prefs.getBool('wild_enabled') ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setBool('wild_enabled', state);
  }
}

/// Tracks whether the user has completed their first swipe session.
/// Used to show spicy/interesting cards first on initial open
/// (the "aha" moment that prevents 60-second deletion).
final firstSessionProvider = StateNotifierProvider<FirstSessionNotifier, bool>((ref) {
  return FirstSessionNotifier(ref);
});

class FirstSessionNotifier extends StateNotifier<bool> {
  final Ref _ref;

  FirstSessionNotifier(this._ref) : super(true) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    state = prefs.getBool('first_session') ?? true;
  }

  Future<void> markComplete() async {
    state = false;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setBool('first_session', false);
  }
}
