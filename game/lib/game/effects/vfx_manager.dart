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
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.yellow,
        particleCount: 12,
        duration: 0.4,
        spreadRadius: 25.0,
      ),
    );
  }

  /// Show jump effect
  void showJump(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.white,
        particleCount: 8,
        duration: 0.3,
        spreadRadius: 20.0,
      ),
    );
  }

  /// Show double jump effect
  void showDoubleJump(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.cyan,
        particleCount: 15,
        duration: 0.4,
        spreadRadius: 30.0,
      ),
    );
  }

  /// Show obstacle crash effect
  void showCrash(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.red,
        particleCount: 25,
        duration: 0.6,
        spreadRadius: 40.0,
      ),
    );
  }

  /// Show score milestone celebration
  void showMilestone(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.amber,
        particleCount: 30,
        duration: 0.8,
        spreadRadius: 50.0,
      ),
    );
  }

  /// Show power-up collect effect
  void showPowerUp(Vector2 position, Color color) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: color,
        particleCount: 20,
        duration: 0.5,
        spreadRadius: 35.0,
      ),
    );
  }

  /// Show speed boost effect
  void showSpeedBoost(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.orange,
        particleCount: 15,
        duration: 0.4,
        spreadRadius: 30.0,
      ),
    );
  }
}
