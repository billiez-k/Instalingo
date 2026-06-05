

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/models/vocab_card.dart';
import 'package:instalingo/providers/settings_provider.dart';
import 'package:instalingo/services/srs/fsrs_scheduler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

final srsProvider = AsyncNotifierProvider<SRSNotifier, List<SRSData>>(
  SRSNotifier.new,
);

class SRSNotifier extends AsyncNotifier<List<SRSData>> {
  Database? _db;

  @override
  Future<List<SRSData>> build() async {
    await ref.read(sharedPrefsProvider.future);
    final dbPath = p.join(await getDatabasesPath(), 'instalingo_srs.db');
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE srs_data (
            card_id TEXT PRIMARY KEY,
            state TEXT NOT NULL DEFAULT 'learning',
            stability REAL NOT NULL DEFAULT 0,
            difficulty REAL NOT NULL DEFAULT 0,
            due TEXT NOT NULL,
            last_review TEXT NOT NULL,
            review_count INTEGER NOT NULL DEFAULT 0,
            lapse_count INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
    return _loadAll();
  }

  Future<List<SRSData>> _loadAll() async {
    if (_db == null) return [];
    final rows = await _db!.query('srs_data');
    return rows.map((row) => SRSData(
      cardId: row['card_id'] as String,
      state: row['state'] as String,
      stability: (row['stability'] as num).toDouble(),
      difficulty: (row['difficulty'] as num).toDouble(),
      due: DateTime.parse(row['due'] as String),
      lastReview: DateTime.parse(row['last_review'] as String),
      reviewCount: row['review_count'] as int,
      lapseCount: row['lapse_count'] as int,
    )).toList();
  }

  /// Schedule a review for the given card with the given rating (1-4).
  Future<SRSData> scheduleReview(String cardId, int rating) async {
    final all = state.value ?? [];
    final existing = all.where((s) => s.cardId == cardId).toList();
    SRSData current;

    if (existing.isNotEmpty) {
      current = existing.first;
    } else {
      current = SRSData(cardId: cardId);
    }

    final result = FSRSScheduler.schedule(
      cardId: cardId,
      state: current.state,
      stability: current.stability,
      difficulty: current.difficulty,
      rating: rating,
      lapseCount: current.lapseCount,
    );

    // Upsert
    await _db?.insert(
      'srs_data',
      {
        'card_id': result.cardId,
        'state': result.state,
        'stability': result.stability,
        'difficulty': result.difficulty,
        'due': result.due.toIso8601String(),
        'last_review': result.lastReview.toIso8601String(),
        'review_count': result.reviewCount,
        'lapse_count': result.lapseCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Refresh state
    state = AsyncData(await _loadAll());
    return result;
  }

  /// Get cards due for review (due date <= now).
  List<SRSData> getDueCards() {
    final now = DateTime.now();
    return (state.value ?? []).where((s) => s.due.isBefore(now) || s.due.isAtSameMomentAs(now)).toList();
  }

  /// Get count of cards due for review.
  int getReviewCount() {
    return getDueCards().length;
  }

  /// Get SRS data for a specific card.
  SRSData? getCardData(String cardId) {
    try {
      return (state.value ?? []).firstWhere((s) => s.cardId == cardId);
    } catch (_) {
      return null;
    }
  }
}
