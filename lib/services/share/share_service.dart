import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/vocab_card.dart';
import 'package:share_plus/share_plus.dart';

/// Social sharing service for InstaLingo cards and app invites.
class ShareService {
  ShareService();

  /// Share a vocabulary card to social media or messaging apps.
  Future<void> shareCard(VocabCard card, AppLocalizations l10n, String localeCode) async {
    final text = [
      '${card.word} (${card.reading})',
      card.meaningFor(localeCode),
      '',
      l10n.shareCardText,
      'https://instalingo.app',
    ].join('\n');

    await Share.share(
      text,
      subject: l10n.shareCardSubject.replaceAll(RegExp(r'\{word\}'), card.word),
    );
  }

  /// Share the app with friends.
  Future<void> shareApp(AppLocalizations l10n) async {
    await Share.share(
      l10n.shareAppText,
      subject: l10n.shareAppSubject,
    );
  }
}
