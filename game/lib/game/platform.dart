import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'theme_manager.dart';

class Platform extends PositionComponent {
  Platform({required super.position, required super.size})
    : super(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

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
