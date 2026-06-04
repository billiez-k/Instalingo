import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:instalingo/services/sound_service.dart';

final sharedPrefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier(ref);
});

class DarkModeNotifier extends StateNotifier<bool> {
  final Ref _ref;

  DarkModeNotifier(this._ref) : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    state = prefs.getBool('dark_mode') ?? false;
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

class OnboardingNotifier extends StateNotifier<bool> {
  final Ref _ref;

  OnboardingNotifier(this._ref) : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    state = prefs.getBool('onboarding_complete') ?? false;
  }

  Future<void> complete() async {
    state = true;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setBool('onboarding_complete', true);
  }
}

final soundServiceProvider = Provider.autoDispose<SoundService>((ref) {
  ref.keepAlive();
  return SoundService(ref);
});
