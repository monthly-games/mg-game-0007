import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'platformer_game.dart';
import 'player.dart';
import 'effects/particle_effects.dart';

class Obstacle extends PositionComponent
    with HasGameReference<PlatformerGame>, CollisionCallbacks {
  Obstacle({required super.position, required super.size})
    : super(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      if (other.hasShield) {
        // Shield blocks collision
        other.hasShield = false;
        game.add(
          CollisionParticleEffect(
            position: intersectionPoints.isNotEmpty
                ? intersectionPoints.first
                : position,
          ),
        );
        removeFromParent();
        // Play shield break sound? Using 'jump.wav' as placeholder or 'land.wav'
        // Better to have unique sound.
        return;
      }

      // Add collision particle effect
      final collisionPoint = intersectionPoints.isNotEmpty
          ? intersectionPoints.first
          : Vector2(position.x + size.x / 2, position.y + size.y / 2);
      game.add(CollisionParticleEffect(position: collisionPoint));

      // 플레이어와 충돌 시 게임 오버
      game.endGame();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 장애물 그리기 (빨간 사각형)
    final paint = Paint()..color = Colors.red;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

    // 테두리
    final borderPaint = Paint()
      ..color = Colors.red.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), borderPaint);

    // 위험 표시 (X)
    final xPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(size.x * 0.2, size.y * 0.2),
      Offset(size.x * 0.8, size.y * 0.8),
      xPaint,
    );
    canvas.drawLine(
      Offset(size.x * 0.8, size.y * 0.2),
      Offset(size.x * 0.2, size.y * 0.8),
      xPaint,
    );
  }
}
