import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'platformer_game.dart';
import 'player.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'package:get_it/get_it.dart';

enum CollectibleType { coin, magnet, shield, doubleCoin }

class Collectible extends PositionComponent
    with HasGameReference<PlatformerGame>, CollisionCallbacks {
  final CollectibleType type;
  AudioManager get _audioManager => GetIt.I<AudioManager>();

  Collectible({required super.position, required this.type})
    : super(size: Vector2(30, 30), anchor: Anchor.center);

  Sprite? _sprite;

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    try {
      if (type == CollectibleType.coin || type == CollectibleType.doubleCoin) {
        _sprite = await game.loadSprite('icon_star.png');
      }
      // Keep using shapes for Magnet/Shield for now, or use Star with color?
      // Let's use Star for all for consistency, but tinted.
      if (_sprite == null) {
        _sprite = await game.loadSprite('icon_star.png');
      }
    } catch (e) {
      debugPrint('Failed to load collectible sprite: $e');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Magnet Logic (Pull towards player)
    if (game.player.magnetTimer > 0 && type == CollectibleType.coin) {
      // Only coins are magnetic usually
      double dist = position.distanceTo(game.player.position);
      if (dist < 300) {
        // Magnet Range
        Vector2 dir = (game.player.position - position).normalized();
        position += dir * 400 * dt; // Speed
      }
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      _collect();
    }
  }

  void _collect() {
    removeFromParent();

    switch (type) {
      case CollectibleType.coin:
        int amount = 1;
        if (game.player.doubleCoinTimer > 0) amount = 2;
        game.coins += amount;
        _audioManager.playSfx('coin.wav');
        break;
      case CollectibleType.magnet:
        game.player.magnetTimer = 10.0; // 10 seconds
        _audioManager.playSfx('powerup.wav');
        break;
      case CollectibleType.shield:
        game.player.hasShield = true;
        _audioManager.playSfx('powerup.wav');
        break;
      case CollectibleType.doubleCoin:
        game.player.doubleCoinTimer = 10.0;
        _audioManager.playSfx('powerup.wav');
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_sprite != null) {
      final paint = Paint()..color = Colors.white;

      switch (type) {
        case CollectibleType.coin:
          paint.color = Colors.white; // Original color
          break;
        case CollectibleType.magnet:
          paint.color = Colors.red;
          break;
        case CollectibleType.shield:
          paint.color = Colors.cyan;
          break;
        case CollectibleType.doubleCoin:
          paint.color = Colors.green;
          break;
      }

      // Render sprite with tint
      _sprite!.render(canvas, size: size, overridePaint: paint);
    } else {
      // Fallback
      final paint = Paint()..style = PaintingStyle.fill;
      paint.color = Colors.amber;
      canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
    }
  }
}
