import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'player.dart';
import 'platform.dart';
import 'obstacle.dart';
import 'collectible.dart';
import 'effects/screen_shake.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'character_manager.dart';
import 'theme_manager.dart';
import '../utils/high_score_manager.dart';

enum PlatformerGameMode { endless, timeAttack }

class PlatformerGame extends FlameGame
    with KeyboardEvents, TapCallbacks, HasCollisionDetection {
  final PlatformerGameMode mode;
  PlatformerGame({this.mode = PlatformerGameMode.endless});

  AudioManager get _audioManager => GetIt.I<AudioManager>();
  late Player player;
  static const double gravity = 980.0;
  static const double scrollSpeed = 200.0; // 자동 스크롤 속도

  double distance = 0; // 이동 거리 (점수)
  int score = 0;
  bool gameOver = false;
  bool gameStarted = false;
  bool isNewRecord = false;

  // Time Attack logic
  double remainingTime = 60.0; // 60 seconds

  @override
  bool paused = false;

  final Random _random = Random();
  double _platformSpawnTimer = 0;
  double _obstacleSpawnTimer = 0;
  static const double platformSpawnInterval = 1.5; // 플랫폼 생성 간격
  static const double obstacleSpawnInterval = 2.5; // 장애물 생성 간격

  @override
  Color backgroundColor() => GetIt.I<ThemeManager>().currentTheme.skyColor;

  @override
  Future<void> onLoad() async {
    // Background (Parallax)
    final theme = GetIt.I<ThemeManager>().currentTheme;
    try {
      final parallax = await ParallaxComponent.load(
        [ParallaxImageData(theme.backgroundAsset)],
        baseVelocity: Vector2(20, 0),
        velocityMultiplierDelta: Vector2(1.5, 0),
        repeat: ImageRepeat.repeatX,
        fill: LayerFill.height,
      );
      add(parallax);
    } catch (e) {
      debugPrint('Failed to load parallax background: $e');
    }

    // 플레이어 생성 (화면 왼쪽 1/4 지점)
    final charData = GetIt.I<CharacterManager>().selectedCharacter;
    player = Player(
      position: Vector2(size.x * 0.25, size.y - 200),
      characterData: charData,
    );
    add(player);

    // 초기 바닥 플랫폼
    _createInitialPlatforms();
  }

  void _createInitialPlatforms() {
    // 긴 시작 플랫폼
    add(
      Platform(
        position: Vector2(0, size.y - 50),
        size: Vector2(size.x * 1.5, 50),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameOver || !gameStarted || paused) return;

    // Time Attack Timer
    if (mode == PlatformerGameMode.timeAttack) {
      remainingTime -= dt;
      if (remainingTime <= 0) {
        remainingTime = 0;
        endGame();
      }
    }

    // 거리 증가
    distance += scrollSpeed * dt;
    score = (distance / 10).floor();

    // 모든 플랫폼과 장애물을 왼쪽으로 이동
    for (final component in children) {
      if (component is Platform) {
        component.position.x -= scrollSpeed * dt;
        if (component.position.x + component.size.x < 0) {
          component.removeFromParent();
        }
      } else if (component is Obstacle) {
        component.position.x -= scrollSpeed * dt;
        if (component.position.x + component.size.x < 0) {
          component.removeFromParent();
        }
      } else if (component is Collectible) {
        component.position.x -= scrollSpeed * dt;
        if (component.position.x + component.size.x < 0) {
          component.removeFromParent();
        }
      }
    }

    // 플랫폼 생성
    _platformSpawnTimer += dt;
    if (_platformSpawnTimer >= platformSpawnInterval) {
      _platformSpawnTimer = 0;
      _spawnPlatform();
    }

    // 장애물 생성
    _obstacleSpawnTimer += dt;
    if (_obstacleSpawnTimer >= obstacleSpawnInterval) {
      _obstacleSpawnTimer = 0;
      _spawnObstacle();
    }
  }

  int coins = 0; // Collected coins

  // ... (Lines 30-115 omitted)

  void _spawnPlatform() {
    final platformWidth = 100.0 + _random.nextDouble() * 150; // 100~250
    const platformHeight = 20.0;
    final minY = size.y * 0.4; // 화면 40% 위치
    final maxY = size.y - 100; // 화면 하단
    final platformY = minY + _random.nextDouble() * (maxY - minY);

    add(
      Platform(
        position: Vector2(size.x + 50, platformY),
        size: Vector2(platformWidth, platformHeight),
      ),
    );

    // Spawn Collectible?
    // 60% chance for Coin
    // 5% chance for Booster
    final rand = _random.nextDouble();
    if (rand < 0.6) {
      // Coin
      add(
        Collectible(
          position: Vector2(
            size.x + 50 + _random.nextDouble() * platformWidth,
            platformY - 30,
          ),
          type: CollectibleType.coin,
        ),
      );
    } else if (rand > 0.95) {
      // Booster
      final boosterType = [
        CollectibleType.magnet,
        CollectibleType.shield,
        CollectibleType.doubleCoin,
      ][_random.nextInt(3)];
      add(
        Collectible(
          position: Vector2(size.x + 50 + platformWidth / 2, platformY - 40),
          type: boosterType,
        ),
      );
    }
  }

  void _spawnObstacle() {
    // 바닥 위의 장애물만 생성
    final groundY = size.y - 50;

    add(
      Obstacle(
        position: Vector2(size.x + 50, groundY - 40), // 장애물 높이 40
        size: Vector2(30, 40),
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (paused) return;

    if (gameOver) {
      _restart();
      return;
    }

    if (!gameStarted) {
      gameStarted = true;
    }

    player.jump();
  }

  void togglePause() {
    paused = !paused;
  }

  void resume() {
    paused = false;
  }

  void restart() {
    _restart();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (paused) return KeyEventResult.handled;

    if (!gameStarted || gameOver) {
      if (keysPressed.contains(LogicalKeyboardKey.space)) {
        if (gameOver) {
          _restart();
        } else {
          gameStarted = true;
          player.jump();
        }
      }
      return KeyEventResult.handled;
    }

    player.handleKeyEvent(keysPressed);
    return KeyEventResult.handled;
  }

  Future<void> endGame() async {
    if (gameOver) return;
    gameOver = true;
    _audioManager.playSfx('collision.wav');

    // Add screen shake effect on collision
    add(ScreenShakeEffect(game: this, intensity: 12.0, duration: 0.35));

    // Save high score
    final newRecord = await HighScoreManager.saveHighScore(mode.name, score);
    if (newRecord) {
      isNewRecord = true;
      _audioManager.playSfx('score.wav'); // Reuse score sound or another one
    }
  }

  void _restart() {
    isNewRecord = false;
    // 모든 플랫폼과 장애물 제거
    children.whereType<Platform>().toList().forEach(
      (p) => p.removeFromParent(),
    );
    children.whereType<Obstacle>().toList().forEach(
      (o) => o.removeFromParent(),
    );
    children.whereType<Collectible>().toList().forEach(
      (c) => c.removeFromParent(),
    );

    // 플레이어 리셋
    player.reset(Vector2(size.x * 0.25, size.y - 200));

    // 상태 리셋
    distance = 0;
    score = 0;
    coins = 0;
    remainingTime = 60.0; // Reset timer
    gameOver = false;
    gameStarted = false;
    _platformSpawnTimer = 0;
    _obstacleSpawnTimer = 0;

    // 초기 플랫폼 생성
    _createInitialPlatforms();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 점수 표시
    final textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(offset: Offset(2, 2), blurRadius: 3, color: Colors.black),
        ],
      ),
    );

    textPaint.render(canvas, 'Distance: $score', Vector2(20, 20));

    // Coin Display
    final coinPaint = TextPaint(
      style: const TextStyle(
        color: Colors.amber,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black),
        ],
      ),
    );
    coinPaint.render(canvas, 'Coins: $coins', Vector2(20, 60));

    // Booster Status
    String buffText = "";
    if (player.magnetTimer > 0) {
      buffText += "MAG (${player.magnetTimer.toInt()}) ";
    }
    if (player.doubleCoinTimer > 0) {
      buffText += "x2 (${player.doubleCoinTimer.toInt()}) ";
    }
    if (player.hasShield) {
      buffText += "[SHIELD] ";
    }

    if (buffText.isNotEmpty) {
      coinPaint.render(canvas, buffText, Vector2(20, 90));
    }

    // Time Attack Timer Display
    if (mode == PlatformerGameMode.timeAttack) {
      final timerPaint = TextPaint(
        style: TextStyle(
          color: remainingTime <= 10 ? Colors.red : Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(offset: Offset(2, 2), blurRadius: 3, color: Colors.black),
          ],
        ),
      );
      timerPaint.render(
        canvas,
        'Time: ${remainingTime.toStringAsFixed(1)}',
        Vector2(size.x - 220, 20),
      );
    }

    // 게임 오버 표시
    if (gameOver) {
      final gameOverPaint = TextPaint(
        style: const TextStyle(
          color: Colors.red,
          fontSize: 64,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(offset: Offset(3, 3), blurRadius: 5, color: Colors.black),
          ],
        ),
      );

      final gameOverText =
          mode == PlatformerGameMode.timeAttack && remainingTime <= 0
          ? 'TIME UP'
          : 'GAME OVER';

      gameOverPaint.render(
        canvas,
        gameOverText,
        Vector2(size.x / 2 - 180, size.y / 2 - 50),
      );

      final scorePaint = TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          shadows: [
            Shadow(offset: Offset(2, 2), blurRadius: 3, color: Colors.black),
          ],
        ),
      );

      scorePaint.render(
        canvas,
        'Score: $score',
        Vector2(size.x / 2 - 80, size.y / 2 + 20),
      );

      final tapPaint = TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          shadows: [
            Shadow(offset: Offset(2, 2), blurRadius: 3, color: Colors.black),
          ],
        ),
      );

      tapPaint.render(
        canvas,
        'Tap to restart',
        Vector2(size.x / 2 - 80, size.y / 2 + 70),
      );

      if (isNewRecord) {
        final newRecordPaint = TextPaint(
          style: const TextStyle(
            color: Colors.yellow,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(offset: Offset(3, 3), blurRadius: 5, color: Colors.black),
            ],
          ),
        );
        newRecordPaint.render(
          canvas,
          'NEW HIGH SCORE!',
          Vector2(size.x / 2 - 160, size.y / 2 - 100),
        );
      }
    }

    // 시작 전 안내
    if (!gameStarted && !gameOver) {
      final startPaint = TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          shadows: [
            Shadow(offset: Offset(2, 2), blurRadius: 3, color: Colors.black),
          ],
        ),
      );

      startPaint.render(
        canvas,
        'Tap to jump',
        Vector2(size.x / 2 - 80, size.y / 2),
      );
    }
  }
}
