/// VFX Manager for MG-0007 Endless Runner
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:mg_common_game/core/engine/effects/flame_effects.dart';

class VfxManager extends Component {
  VfxManager();

  Component? _gameRef;

  void setGame(Component game) {
    _gameRef = game;
  }

  void _addEffect(Component effect) {
    _gameRef?.add(effect);
  }

  /// Show coin collect effect
  void showCoinCollect(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.yellow,
          radius: 25.0,
        ),
    );
  }

  /// Show jump effect
  void showJump(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.white,
          radius: 20.0,
        ),
    );
  }

  /// Show double jump effect
  void showDoubleJump(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.cyan,
          radius: 30.0,
        ),
    );
  }

  /// Show obstacle crash effect
  void showCrash(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.red,
          radius: 40.0,
        ),
    );
  }

  /// Show score milestone celebration
  void showMilestone(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.amber,
          radius: 50.0,
        ),
    );
  }

  /// Show power-up collect effect
  void showPowerUp(Vector2 position, Color color) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: color,
          radius: 35.0,
        ),
    );
  }

  /// Show speed boost effect
  void showSpeedBoost(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.orange,
          radius: 30.0,
        ),
    );
  }
}
