import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'platformer_game.dart';
import 'platform.dart';
import 'effects/particle_effects.dart';

import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'character_data.dart';

class Player extends PositionComponent
    with HasGameReference<PlatformerGame>, CollisionCallbacks {
  final CharacterData characterData;
  AudioManager get _audioManager => GetIt.I<AudioManager>();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;

  static const double moveSpeed = 200.0;
  static const double jumpSpeed = -500.0;

  Player({required super.position, required this.characterData})
    : super(size: Vector2(40, 60), anchor: Anchor.center);

  Sprite? _displaySprite;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    try {
      _displaySprite = await game.loadSprite('player.png');
    } catch (e) {
      debugPrint('Failed to load player sprite: $e');
    }
  }

  void jump() {
    if (isOnGround) {
      velocity.y = jumpSpeed;
      isOnGround = false;
      _audioManager.playSfx('jump.wav');

      // Add jump particle effect
      game.add(
        JumpParticleEffect(
          position: Vector2(position.x, position.y + size.y / 2),
        ),
      );
    }
  }

  void handleKeyEvent(Set<LogicalKeyboardKey> keysPressed) {
    // 엔드리스 러너에서는 좌우 이동 없음 (점프만 가능)
    // 점프는 Space 키
    if ((keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
            keysPressed.contains(LogicalKeyboardKey.space) ||
            keysPressed.contains(LogicalKeyboardKey.keyW)) &&
        isOnGround) {
      jump();
    }
  }

  void reset(Vector2 newPosition) {
    position = newPosition;
    velocity = Vector2.zero();
    isOnGround = false;
  }

  // Boosters
  bool hasShield = false;
  double magnetTimer = 0;
  double doubleCoinTimer = 0;

  @override
  void update(double dt) {
    super.update(dt);

    // Timers
    if (magnetTimer > 0) magnetTimer -= dt;
    if (doubleCoinTimer > 0) doubleCoinTimer -= dt;

    // 중력 적용
    if (!isOnGround) {
      velocity.y += PlatformerGame.gravity * dt;
    }

    // 위치 업데이트 (Y축만, X축은 고정)
    position.y += velocity.y * dt;

    // 떨어지면 게임 오버
    if (position.y > game.size.y + 100) {
      game.endGame();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Platform) {
      // 플랫폼 위에 있는지 확인
      if (velocity.y > 0 && position.y < other.position.y) {
        final wasInAir = !isOnGround;
        position.y = other.position.y - size.y / 2;
        velocity.y = 0;
        isOnGround = true;

        // Add landing particle effect when landing from air
        if (wasInAir) {
          _audioManager.playSfx('land.wav');
          game.add(
            LandingParticleEffect(
              position: Vector2(position.x, position.y + size.y / 2),
            ),
          );
        }
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Platform) {
      isOnGround = false;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_displaySprite != null) {
      _displaySprite!.render(
        canvas,
        size: size,
        overridePaint: Paint()
          ..color = characterData.color.withValues(alpha: 0.9),
      );
      // Overlay eyes over sprite if needed, or assume sprite has eyes.
      // Keeping eyes for now as "character data color" might tint the sprite.
    } else {
      // Fallback: Blue Rectangle
      final paint = Paint()..color = characterData.color;
      canvas.drawRect(
        Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y),
        paint,
      );
      // Eyes
      final eyePaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(-size.x / 4, -size.y / 4), 5, eyePaint);
      canvas.drawCircle(Offset(size.x / 4, -size.y / 4), 5, eyePaint);
    }

    // Shield Visual
    if (hasShield) {
      final shieldPaint = Paint()
        ..color = Colors.cyan.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(Offset.zero, size.x * 0.8, shieldPaint);
    }

    // Magnet Visual
    if (magnetTimer > 0) {
      final magPaint = Paint()
        ..color = Colors.red.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset.zero, size.x, magPaint);
    }
  }
}
