import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/providers/user_provider.dart';

/// Notification & reminder service for InstaLingo.
///
/// Two notification types:
/// 1. "Word of the Day" — a spicy/fun word delivered at 8pm daily
/// 2. Study reminder — fires at user's configured reminder time
class NotificationService {
  final WidgetRef _ref;
  final BuildContext _context;
  Timer? _timer;

  NotificationService(this._ref, this._context);

  bool get _notificationsOn => _ref.read(userProvider).notificationsEnabled;
  String? get _reminderTime => _ref.read(userProvider).reminderTime;

  /// Start the notification scheduler.
  void start() {
    stop();
    if (!_notificationsOn) return;

    // Check every 30 seconds whether it's time for a notification
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _checkAndFire());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void refresh() {
    if (_notificationsOn) {
      start();
    } else {
      stop();
    }
  }

  // Track last notification times to prevent spam
  DateTime? _lastReminder;
  DateTime? _lastWordOfDay;

  void _checkAndFire() {
    final now = DateTime.now();

    // Study reminder — fire at user's configured time
    if (_reminderTime != null) {
      final parts = _reminderTime!.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null &&
            now.hour == hour && now.minute == minute) {
          // Only fire once per minute window
          if (_lastReminder == null ||
              now.difference(_lastReminder!).inMinutes > 1) {
            _lastReminder = now;
            _fireReminder();
          }
        }
      }
    }

    // Word of the Day — fire at 8pm
    if (now.hour == 20 && now.minute == 0) {
      if (_lastWordOfDay == null ||
          now.difference(_lastWordOfDay!).inHours > 12) {
        _lastWordOfDay = now;
        _fireWordOfDay();
      }
    }
  }

  void _fireReminder() {
    if (!_context.mounted) return;
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(_context).notificationPracticeReminder),
        duration: const Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _fireWordOfDay() {
    if (!_context.mounted) return;

    // Pick a random spicy/real-life word as the daily prompt
    final words = [
      '\u{1F525} やばい — awesome, terrible, crazy',
      '\u{1F525} マジで — seriously? for real?',
      '\u{1F525} めっちゃ — super, extremely',
      '\u{1F5E3}\u{FE0F} おっす — hey! (casual greeting)',
      '\u{1F5E3}\u{FE0F} うざい — annoying!',
      '\u{1F525} だるい — I can\'t be bothered',
      '\u{1F5E3}\u{FE0F} ウケる — that\'s hilarious',
      '\u{1F525} ちょう — super (slang)',
      '\u{1F5E3}\u{FE0F} サボる — to slack off',
      '\u{1F525} イケメン — hot guy',
    ];

    final today = DateTime.now();
    // Pick a word based on day of year (consistent within a day)
    final idx = (today.difference(DateTime(today.year, 1, 1)).inDays) % words.length;
    final word = words[idx];

    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(_context).notificationPracticeReminder}\n$word'),
        duration: const Duration(seconds: 8),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: AppLocalizations.of(_context).gotIt,
          onPressed: () {},
        ),
      ),
    );
  }

  void dispose() {
    stop();
  }
}
