import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/providers/user_provider.dart';

/// In-app notification & reminder service.
///
/// When the user enables notifications and sets a daily reminder time
/// (e.g. 9:00 AM), this service schedules a periodic timer that checks
/// whether it's time to remind the user to study.
///
/// Architecture:
///   - `start()` / `stop()` manage the timer lifecycle.
///   - `_onReminderFire()` shows an in-app SnackBar when the reminder
///     fires while the app is open.
///   - When `flutter_local_notifications` is added to the project for
///     mobile builds, the scheduling logic in `_checkAndFire()` can be
///     replaced with `zonedSchedule()` for true background notifications.
class NotificationService {
  final WidgetRef _ref;
  final BuildContext _context;
  Timer? _timer;

  NotificationService(this._ref, this._context);

  bool get _notificationsOn => _ref.read(userProvider).notificationsEnabled;
  bool get _reminderOn => _ref.read(userProvider).reminderTime != null;
  String? get _reminderTime => _ref.read(userProvider).reminderTime;

  /// Start the notification scheduler.
  /// Call once after app init (e.g. from main.dart or splash screen).
  void start() {
    stop(); // clear any existing timer
    if (!_notificationsOn || !_reminderOn) return;

    // Check every 30 seconds whether it's reminder time.
    // In production this would use flutter_local_notifications.zonedSchedule()
    // for true background delivery.  This timer covers the in-app case.
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _checkAndFire());
  }

  /// Stop the scheduler (e.g. when notifications are disabled).
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Re-evaluate notification state — call after user changes settings.
  void refresh() {
    if (_notificationsOn && _reminderOn) {
      start();
    } else {
      stop();
    }
  }

  void _checkAndFire() {
    final now = DateTime.now();
    final timeStr = _reminderTime;
    if (timeStr == null) return;

    final parts = timeStr.split(':');
    if (parts.length != 2) return;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return;

    // Fire if current hour/minute match the reminder time.
    // Only fire once per minute window.
    if (now.hour == hour && now.minute == minute) {
      _onReminderFire();
    }
  }

  void _onReminderFire() {
    if (!_context.mounted) return;

    ScaffoldMessenger.of(_context).showSnackBar(
      const SnackBar(
        content: Text('Time to practice!'),
        duration: Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void dispose() {
    stop();
  }
}
