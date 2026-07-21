import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:instalingo/models/vocab_card.dart';

/// Generates shareable card images for social media promotion.
///
/// Creates 1080x1080 square images with:
/// - Navy gradient background
/// - Large Japanese word + reading
/// - English meaning
/// - Register tier badge (📚/🗣️/🔥/💀)
/// - InstaLingo branding watermark
/// - "Swipe to learn more" CTA
class CardImageGenerator {
  CardImageGenerator();

  static const _size = ui.Size(1080, 1080);
  static const _navy = ui.Color(0xFF0F1F2E);
  static const _cream = ui.Color(0xFFF2EFE9);
  static const _orange = ui.Color(0xFFEE6C2C);

  /// Generate a shareable image for the given [card].
  Future<Uint8List> generateCardImage(VocabCard card) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, _size.width, _size.height));

    // Background
    final bgPaint = ui.Paint()..color = _navy;
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, _size.width, _size.height), bgPaint);

    // Subtle gradient circles in background
    final circlePaint = ui.Paint()
      ..color = const ui.Color(0xFF1B3349)
      ..style = ui.PaintingStyle.fill;
    canvas.drawCircle(const ui.Offset(900, 200), 180, circlePaint);
    canvas.drawCircle(const ui.Offset(200, 800), 220, circlePaint);

    // Top accent bar
    final accentPaint = ui.Paint()..color = _orange;
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, _size.width, 8), accentPaint);

    // Register badge
    final (badgeText, badgeColor) = _registerBadge(card.register);
    final badgeBg = ui.Paint()..color = badgeColor.withAlpha(50);
    final badgeBorder = ui.Paint()
      ..color = badgeColor.withAlpha(100)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 2;
    const badgeRect = ui.Rect.fromLTWH(40, 60, 240, 56);
    canvas.drawRRect(
        ui.RRect.fromRectAndRadius(badgeRect, const ui.Radius.circular(12)),
        badgeBg);
    canvas.drawRRect(
        ui.RRect.fromRectAndRadius(badgeRect, const ui.Radius.circular(12)),
        badgeBorder);
    _drawText(canvas, badgeText, badgeRect, badgeColor, 28, ui.TextAlign.center);

    // JLPT level badge
    final levelBg = ui.Paint()..color = _orange.withAlpha(40);
    const levelRect = ui.Rect.fromLTWH(300, 60, 140, 56);
    canvas.drawRRect(
        ui.RRect.fromRectAndRadius(levelRect, const ui.Radius.circular(12)),
        levelBg);
    _drawText(canvas, card.level.toUpperCase(), levelRect, _orange, 28,
        ui.TextAlign.center);

    // Main word
    final wordRect = ui.Rect.fromLTWH(40, 220, _size.width - 80, 200);
    _drawText(
        canvas, card.word, wordRect, _cream, 120, ui.TextAlign.center);

    // Reading
    final readingRect = ui.Rect.fromLTWH(40, 400, _size.width - 80, 80);
    _drawText(canvas, card.reading, readingRect,
        const ui.Color(0xFFA3ABB4), 48, ui.TextAlign.center);

    // Divider line
    final dividerPaint = ui.Paint()
      ..color = _orange.withAlpha(80)
      ..strokeWidth = 2;
    canvas.drawLine(
        const ui.Offset(300, 520), const ui.Offset(780, 520), dividerPaint);

    // Meaning
    final meaningRect = ui.Rect.fromLTWH(80, 560, _size.width - 160, 160);
    _drawText(canvas, card.meaning, meaningRect,
        const ui.Color(0xFF6B7785), 40, ui.TextAlign.center);

    // Example if available
    if (card.exampleText != null && card.exampleText!.isNotEmpty) {
      final exRect = ui.Rect.fromLTWH(80, 720, _size.width - 160, 100);
      _drawText(canvas, '"${card.exampleText}"', exRect,
          const ui.Color(0xFF3E5A70), 30, ui.TextAlign.center);
    }

    // Bottom branding
    final brandRect = ui.Rect.fromLTWH(40, _size.height - 140, _size.width - 80, 60);
    _drawText(canvas, 'Learn real Japanese with InstaLingo',
        brandRect, _orange, 32, ui.TextAlign.center);

    final urlRect = ui.Rect.fromLTWH(40, _size.height - 80, _size.width - 80, 40);
    _drawText(canvas, 'instalingo.app',
        urlRect, const ui.Color(0xFF6B7785), 24, ui.TextAlign.center);

    // Bottom accent bar
    canvas.drawRect(
        ui.Rect.fromLTWH(0, _size.height - 8, _size.width, 8), accentPaint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(_size.width.toInt(), _size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _drawText(ui.Canvas canvas, String text, ui.Rect rect, ui.Color color,
      double fontSize, ui.TextAlign align) {
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: align,
      fontSize: fontSize,
      textDirection: ui.TextDirection.ltr,
      maxLines: 5,
      ellipsis: '…',
    ))
      ..pushStyle(ui.TextStyle(color: color, fontWeight: ui.FontWeight.w800))
      ..addText(text);
    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: rect.width));

    // Center vertically in rect
    final yOffset = rect.top + (rect.height - paragraph.height) / 2;
    canvas.drawParagraph(paragraph, ui.Offset(rect.left, yOffset));
  }

  (String, ui.Color) _registerBadge(String register) {
    return switch (register) {
      'vulgar' => ('WILD', const ui.Color(0xFFD04B43)),
      'slang' => ('SPICY', const ui.Color(0xFFE89A22)),
      'real_life' => ('REAL LIFE', const ui.Color(0xFF3E7CB1)),
      _ => ('TEXTBOOK', const ui.Color(0xFF2D9C5A)),
    };
  }
}
