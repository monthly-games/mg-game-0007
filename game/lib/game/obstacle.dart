import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'platformer_game.dart';
import 'player.dart';
import 'effects/particle_effects.dart';
import 'package:flame/sprite.dart';

enum ObstacleType { box, spike, enemy }

class Obstacle extends PositionComponent
    with HasGameReference<PlatformerGame>, CollisionCallbacks {
  final ObstacleType type;

  Obstacle({
    required super.position,
    required super.size,
    this.type = ObstacleType.box,
  }) : super(anchor: Anchor.topLeft);

  Sprite? _sprite;
  SpriteAnimationTicker? _animationTicker;

  @override
  Future<void> onLoad() async {
    // Hitbox adjustment based on type
    if (type == ObstacleType.spike) {
      add(
        RectangleHitbox(
          position: Vector2(0, size.y * 0.5),
          size: Vector2(size.x, size.y * 0.5),
        ),
      );
    } else {
      add(RectangleHitbox());
    }

    try {
      if (type == ObstacleType.enemy) {
        // Load animated sprite for enemy (3 frames on a strip)
        final image = await game.images.load('enemy_slime.png');
        final spriteSheet = SpriteSheet(
          image: image,
          srcSize: Vector2(image.width / 3, image.height.toDouble()),
        );
        final animation = spriteSheet.createAnimation(
          row: 0,
          stepTime: 0.2,
          to: 3,
        );
        _animationTicker = animation.createTicker();
      } else if (type == ObstacleType.spike) {
        _sprite = await game.loadSprite('spike_trap.png');
      } else {
        _sprite = await game.loadSprite('obstacle.png');
      }
    } catch (e) {
      debugPrint('Failed to load asset for obstacle type $type: $e');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_animationTicker != null) {
      _animationTicker!.update(dt);
    }

    // Simple patrol/bobbing could be added here
    if (type == ObstacleType.enemy) {
      // Just move with the scroll, maybe bob up and down later?
      // Current game logic moves the obstacle via PlatformerGame update loop.
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      if (other.hasShield) {
        other.hasShield = false;
        game.add(
          CollisionParticleEffect(
            position: intersectionPoints.isNotEmpty
                ? intersectionPoints.first
                : position,
          ),
        );
        removeFromParent();
        return;
      }

      final collisionPoint = intersectionPoints.isNotEmpty
          ? intersectionPoints.first
          : Vector2(position.x + size.x / 2, position.y + size.y / 2);
      game.add(CollisionParticleEffect(position: collisionPoint));

      game.endGame();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_animationTicker != null) {
      _animationTicker!.getSprite().render(canvas, size: size);
    } else if (_sprite != null) {
      _sprite!.render(canvas, size: size);
    } else {
      // Fallback rendering
      final paint = Paint()
        ..color = type == ObstacleType.spike
            ? Colors.grey
            : (type == ObstacleType.enemy ? Colors.purple : Colors.red);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    }
  }
}
