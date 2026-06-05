import 'package:instalingo/models/vocab_card.dart';
import 'package:share_plus/share_plus.dart';

/// Social sharing service for InstaLingo cards and app invites.
class ShareService {
  ShareService();

  /// Share a vocabulary card to social media or messaging apps.
  Future<void> shareCard(VocabCard card) async {
    final text = [
      '${card.word} (${card.reading})',
      card.meaning,
      '',
      'Learn Japanese with InstaLingo!',
      'https://instalingo.app',
    ].join('\n');

    await Share.share(
      text,
      subject: '${card.word} - Learn with InstaLingo',
    );
  }

  /// Share the app with friends.
  Future<void> shareApp() async {
    await Share.share(
      'Learn Japanese vocabulary with InstaLingo!\n'
      'Swipe, learn, and chill.\n'
      'https://instalingo.app',
      subject: 'InstaLingo - Discover Japanese',
    );
  }
}
