import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:instalingo/providers/settings_provider.dart';


/// Device TTS service — uses the phone's built-in voice engine.
/// Korean and Japanese voices are built into iOS (excellent) and Android (decent).
/// Zero cost, works offline, zero latency.
class TtsService {
  final FlutterTts _tts;
  final Ref _ref;

  TtsService(this._ref) : _tts = FlutterTts();

  bool get _enabled => _ref.read(ttsEnabledProvider);

  String _currentLang = '';
  Future<void> _ensureLanguage(String lang) async {
    if (_currentLang == lang) return;
    _currentLang = lang;
    try {
      await _tts.setLanguage(lang == 'ja' ? 'ja-JP' : 'ko-KR');
    } catch (_) {
      // Language not available on device — TTS will be silent
      return;
    }
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
  }

  /// Speak text in Korean.
  Future<void> speakKorean(String text) async {
    if (!_enabled || text.isEmpty) return;
    await _ensureLanguage('ko');
    await _tts.speak(text);
  }

  /// Speak text in Japanese.
  Future<void> speakJapanese(String text) async {
    if (!_enabled || text.isEmpty) return;
    await _ensureLanguage('ja');
    await _tts.speak(text);
  }

  /// Speak text — auto-detect language from character set.
  Future<void> speak(String text, String languageCode) async {
    if (!_enabled || text.isEmpty) return;
    // Auto-detect: kana = Japanese, hangul = Korean
    if (languageCode == 'ko' || RegExp(r'[가-힣]').hasMatch(text)) {
      await _ensureLanguage('ko');
    } else if (languageCode == 'ja' || RegExp(r'[ぁ-ゟ]').hasMatch(text)) {
      await _ensureLanguage('ja');
    }
    await _tts.speak(text);
  }

  /// Stop any ongoing speech.
  Future<void> stop() async {
    await _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }
}

/// Provider for the TTS service.
final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService(ref);
});
