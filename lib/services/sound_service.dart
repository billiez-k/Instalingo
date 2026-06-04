import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/providers/settings_provider.dart';

/// Lightweight sound-effect service.
///
/// Uses platform system sounds (no asset files required) so the app
/// has audio feedback immediately.  Swap in `audioplayers` with real
/// `.mp3` files under `assets/sounds/` for richer feedback later.
///
/// Every public method checks [soundEnabledProvider] before playing
/// so the Settings toggle actually controls audio output.
class SoundService {
  final Ref _ref;

  const SoundService(this._ref);

  bool get _enabled => _ref.read(soundEnabledProvider);

  /// Button / tile tap.
  void tap() {
    if (!_enabled) return;
    SystemSound.play(SystemSoundType.click);
    try { HapticFeedback.lightImpact(); } catch (_) {}
  }

  /// Correct answer (lesson exercise).
  void correct() {
    if (!_enabled) return;
    try { HapticFeedback.mediumImpact(); } catch (_) {}
  }

  /// Wrong answer (lesson exercise).
  void wrong() {
    if (!_enabled) return;
    try { HapticFeedback.heavyImpact(); } catch (_) {}
  }

  /// Lesson or checkpoint completed.
  void complete() {
    if (!_enabled) return;
    try { HapticFeedback.heavyImpact(); } catch (_) {}
  }

  /// Level-up or achievement unlocked.
  void levelUp() {
    if (!_enabled) return;
    try { HapticFeedback.heavyImpact(); } catch (_) {}
  }

  /// Toggle / switch changed.
  void toggle() {
    if (!_enabled) return;
    try { HapticFeedback.lightImpact(); } catch (_) {}
  }

  /// Selection (picker, dropdown).
  void select() {
    if (!_enabled) return;
    SystemSound.play(SystemSoundType.click);
    try { HapticFeedback.selectionClick(); } catch (_) {}
  }
}
