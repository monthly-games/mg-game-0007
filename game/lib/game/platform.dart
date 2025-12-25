import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'platformer_game.dart';
import 'theme_manager.dart';

class Platform extends PositionComponent with HasGameReference<PlatformerGame> {
  Platform({required super.position, required super.size})
    : super(anchor: Anchor.topLeft);

  Sprite? _platformSprite;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    try {
      _platformSprite = await game.loadSprite('platform.png');
    } catch (e) {
      // Debug print or ignore
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_platformSprite != null) {
      // Tile the sprite across the width
      // Assuming sprite is square-ish or tileable.
      // Let's assume standard tile size 50x50 or similar.
      // We'll just draw it stretched for now or tiled if we want to be fancy.
      // Stretched is safer if we don't know aspect ratio.
      // But preserving aspect ratio is better.
      // Let's just draw it across the whole rect.
      _platformSprite!.render(
        canvas,
        size: size,
        overridePaint: Paint()
          ..color = GetIt.I<ThemeManager>().currentTheme.platformColor,
      );
    } else {
      final theme = GetIt.I<ThemeManager>().currentTheme;
      final platformColor = theme.platformColor;
      // Darker shade for border
      final borderColor = HSVColor.fromColor(platformColor)
          .withValue(
            (HSVColor.fromColor(platformColor).value - 0.2).clamp(0.0, 1.0),
          )
          .toColor();

      // Platform body
      final paint = Paint()..color = platformColor;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

      // Border
      final borderPaint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), borderPaint);
    }
  }
}
