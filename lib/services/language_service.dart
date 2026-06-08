import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/providers/locale_provider.dart';
import 'package:instalingo/providers/user_provider.dart';

/// Centralized language switching service.
///
/// Busuu separates three language dimensions:
///   - `instructions_language`  → UI / instruction text (native language)
///   - `learningLanguage`         → target language being studied
///   - `answersDisplayLanguage`   → usually same as native language
///
/// This service ensures all three are updated in a single transaction
/// so the UI, course content, and exercise instructions stay in sync.
class LanguageService {
  final WidgetRef _ref;

  LanguageService(this._ref);

  /// Change the user's native / interface language.
  /// Updates both the app locale (UI text) and the user profile.
  /// Sets state synchronously so UI updates immediately; persistence happens async.
  Future<void> setNativeLanguage(String languageCode) async {
    // Fire locale update (state set synchronously inside, persistence is fire-and-forget)
    _ref.read(localeProvider.notifier).setLocale(languageCode);
    // Update user profile immediately
    _ref.read(userProvider.notifier).updateProfile(
      nativeLanguage: languageCode,
    );
  }

  /// Change the user's target / learning language.
  /// Updates the user profile; the course provider auto-reacts via
  /// `ref.listen(userProvider.select(...))` and reloads the course content.
  void setLearningLanguage(String languageCode) {
    _ref.read(userProvider.notifier).updateProfile(
      learningLanguage: languageCode,
    );
  }
}
