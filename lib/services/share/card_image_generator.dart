import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:instalingo/models/vocab_card.dart';

/// Generates shareable card images for social media.
///
/// // TODO: Step 2 -- Image generation
/// For now returns a colored placeholder.
class CardImageGenerator {
  CardImageGenerator();

  /// Generate a shareable image for the given [card].
  Future<Uint8List> generateCardImage(VocabCard card) async {
    // TODO: Step 2 -- Image generation
    // Generate a beautiful share card with:
    // - Navy background with gradient
    // - Large Japanese word
    // - Reading + meaning
    // - InstaLingo watermark
    // - QR code link to app
    final recorder = ui.PictureRecorder();
    const size = ui.Size(1080, 1080);
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, size.width, size.height));

    // Navy background (#0F1F2E)
    final bgPaint = ui.Paint()..color = const ui.Color(0xFF0F1F2E);
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Orange accent bar (#EE6C2C)
    final accentPaint = ui.Paint()..color = const ui.Color(0xFFEE6C2C);
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, size.width, 8), accentPaint);
    canvas.drawRect(ui.Rect.fromLTWH(0, size.height - 8, size.width, 8), accentPaint);

    // Placeholder text rendered via ParagraphBuilder
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: ui.TextAlign.center,
      fontSize: 64,
      textDirection: ui.TextDirection.ltr,
    ))
      ..pushStyle(ui.TextStyle(color: const ui.Color(0xFFF2EFE9)))
      ..addText(card.word);
    final paragraph = builder.build()..layout(ui.ParagraphConstraints(width: size.width));
    canvas.drawParagraph(paragraph, ui.Offset(0, size.height / 2 - 64));

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
