import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// Jump particle effect
class JumpParticleEffect extends Component {
  final Vector2 position;
  final Random _random = Random();

  JumpParticleEffect({required this.position});

  @override
  Future<void> onLoad() async {
    // Create upward particles
    final particles = List.generate(
      6,
      (i) {
        final angle = pi / 2 + (i / 6 - 0.5) * pi / 3; // Upward cone
        final speed = 80.0 + _random.nextDouble() * 40.0;

        return Particle.generate(
          count: 1,
          lifespan: 0.5,
          generator: (i) {
            return AcceleratedParticle(
              speed: Vector2(
                cos(angle) * speed,
                sin(angle) * speed,
              ),
              acceleration: Vector2(0, 200),
              child: CircleParticle(
                radius: 2.0 + _random.nextDouble() * 2.0,
                paint: Paint()
                  ..color = Color.lerp(
                    Colors.blue.shade200,
                    Colors.white,
                    _random.nextDouble(),
                  )!,
              ),
            );
          },
        );
      },
    );

    add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 1,
          generator: (i) => ComposedParticle(children: particles),
        ),
      ),
    );

    // Remove this component after particles are done
    Future.delayed(const Duration(milliseconds: 600), () {
      removeFromParent();
    });
  }
}

/// Landing particle effect
class LandingParticleEffect extends Component {
  final Vector2 position;
  final Random _random = Random();

  LandingParticleEffect({required this.position});

  @override
  Future<void> onLoad() async {
    // Create outward/downward particles
    final particles = List.generate(
      10,
      (i) {
        final angle = pi / 4 + (i / 10) * pi / 2; // Spread outward from landing point
        final speed = 60.0 + _random.nextDouble() * 40.0;

        return Particle.generate(
          count: 1,
          lifespan: 0.4,
          generator: (i) {
            return AcceleratedParticle(
              speed: Vector2(
                cos(angle) * speed * (i % 2 == 0 ? 1 : -1), // Left and right
                sin(angle) * speed,
              ),
              acceleration: Vector2(0, 300),
              child: CircleParticle(
                radius: 2.0 + _random.nextDouble() * 1.5,
                paint: Paint()
                  ..color = Color.lerp(
                    Colors.grey.shade400,
                    Colors.white,
                    _random.nextDouble(),
                  )!,
              ),
            );
          },
        );
      },
    );

    add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 1,
          generator: (i) => ComposedParticle(children: particles),
        ),
      ),
    );

    // Remove this component after particles are done
    Future.delayed(const Duration(milliseconds: 500), () {
      removeFromParent();
    });
  }
}

/// Collision particle effect
class CollisionParticleEffect extends Component {
  final Vector2 position;
  final Random _random = Random();

  CollisionParticleEffect({required this.position});

  @override
  Future<void> onLoad() async {
    // Create explosion particles
    final particles = List.generate(
      15,
      (i) {
        final angle = _random.nextDouble() * 2 * pi;
        final speed = 100.0 + _random.nextDouble() * 100.0;

        return Particle.generate(
          count: 1,
          lifespan: 0.8,
          generator: (i) {
            return AcceleratedParticle(
              speed: Vector2(
                cos(angle) * speed,
                sin(angle) * speed,
              ),
              acceleration: Vector2(0, 300),
              child: CircleParticle(
                radius: 4.0 + _random.nextDouble() * 3.0,
                paint: Paint()
                  ..color = Color.lerp(
                    Colors.red,
                    Colors.orange,
                    _random.nextDouble(),
                  )!,
              ),
            );
          },
        );
      },
    );

    add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 1,
          generator: (i) => ComposedParticle(children: particles),
        ),
      ),
    );

    // Remove this component after particles are done
    Future.delayed(const Duration(milliseconds: 900), () {
      removeFromParent();
    });
  }
}
