import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';
import '../game/platformer_game.dart';
import 'tutorial_overlay.dart';
import 'pause_overlay.dart';
import 'hud/mg_runner_hud.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import '../utils/high_score_manager.dart';
import 'package:mg_common_game/core/ui/screens/leaderboard_screen.dart';
import 'package:mg_common_game/core/models/score_entry.dart';
import 'package:mg_common_game/systems/progression/prestige_manager.dart';
import 'package:mg_common_game/systems/progression/progression_manager.dart';
import 'package:mg_common_game/core/ui/screens/prestige_screen.dart';
import 'package:mg_common_game/systems/quests/daily_quest.dart';
import 'package:mg_common_game/core/ui/screens/daily_quest_screen.dart';
import 'package:mg_common_game/systems/quests/weekly_challenge.dart';
import 'package:mg_common_game/core/ui/screens/weekly_challenge_screen.dart';
import 'package:mg_common_game/systems/stats/statistics_manager.dart';
import 'package:mg_common_game/core/ui/screens/statistics_screen.dart';
import 'package:mg_common_game/systems/progression/achievement_manager.dart';
import 'package:mg_common_game/systems/settings/settings_manager.dart';
import 'package:mg_common_game/core/ui/screens/settings_screen.dart' as common;
import '../game/character_manager.dart';
import '../game/character_data.dart';
import '../game/theme_manager.dart';
import '../game/theme_data.dart';
import 'shop_screen.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6B35), // Orange
              Color(0xFFAA4465), // Purple
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Game Title
                        const Text(
                          'ENDLESS',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(4, 4),
                                blurRadius: 8,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'RUNNER',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                            shadows: [
                              Shadow(
                                offset: Offset(4, 4),
                                blurRadius: 8,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),

                        const Text(
                          'SELECT MODE',
                          style: TextStyle(
                            color: Colors.white70,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Game Mode Cards
                        GameModeCard(
                          title: 'ENDLESS RUN',
                          description: 'Run as far as you can!',
                          icon: Icons.directions_run,
                          color: Colors.green,
                          onTap: () =>
                              _startGame(context, PlatformerGameMode.endless),
                          highScoreFuture: HighScoreManager.getHighScore(
                            PlatformerGameMode.endless.name,
                          ),
                        ),
                        GameModeCard(
                          title: 'TIME ATTACK',
                          description: 'Race against the clock!',
                          icon: Icons.timer,
                          color: Colors.red,
                          onTap: () => _startGame(
                            context,
                            PlatformerGameMode.timeAttack,
                          ),
                          highScoreFuture: HighScoreManager.getHighScore(
                            PlatformerGameMode.timeAttack.name,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Utilities Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    // Character Selection Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildUtilityButton(
                        context,
                        Icons.person,
                        'Characters',
                        () => _showCharacterSelection(context),
                      ),
                    ),

                    // First row: Game utilities
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildUtilityButton(
                          context,
                          Icons.image,
                          'Theme',
                          () => _showThemeSelection(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.emoji_events,
                          'Leaderboard',
                          () => _showLeaderboard(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.assignment_turned_in,
                          'Daily',
                          () => _showDailyQuestsScreen(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Second row: More utilities
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildUtilityButton(
                          context,
                          Icons.stars,
                          'Weekly',
                          () => _showWeeklyChallengesScreen(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.auto_awesome,
                          'Prestige',
                          () => _showPrestigeScreen(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.shopping_cart,
                          'Shop',
                          () => _showShopScreen(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Second row: Settings and stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildUtilityButton(
                          context,
                          Icons.bar_chart,
                          'Stats',
                          () => _showStatisticsScreen(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.settings,
                          'Settings',
                          () => _showSettingsScreen(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.help_outline,
                          'How to Play',
                          () => _showHowToPlay(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUtilityButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white, size: 32),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _startGame(BuildContext context, PlatformerGameMode mode) async {
    final hasSeenTutorial = await TutorialOverlay.hasSeenTutorial();

    if (!context.mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            GameScreen(showTutorial: !hasSeenTutorial, mode: mode),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text('How to Play'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎮 Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Tap to jump'),
            Text('• Jump while in air to double jump'),
            Text('• Avoid red obstacles'),
            Text('• Don\'t fall off platforms'),
            SizedBox(height: 16),
            Text(
              '🎯 Goal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Endless: Run as far as possible!'),
            Text('Time Attack: Max distance in 60s!'),
            SizedBox(height: 16),
            Text(
              '⚠️ Game Over',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Hit an obstacle'),
            Text('• Fall off the screen'),
            Text('• Time runs out (Time Attack)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('GOT IT!'),
          ),
        ],
      ),
    );
  }

  Future<void> _showLeaderboard(BuildContext context) async {
    final endlessScore = await HighScoreManager.getHighScore(
      PlatformerGameMode.endless.name,
    );
    final timeAttackScore = await HighScoreManager.getHighScore(
      PlatformerGameMode.timeAttack.name,
    );

    if (!context.mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LeaderboardScreen(
          title: 'Platformer High Scores',
          onClose: () => Navigator.of(context).pop(),
          onReset: () async {
            await HighScoreManager.resetAllHighScores();
          },
          scores: [
            ScoreEntry(
              label: 'Endless Run',
              score: endlessScore,
              iconAsset: 'assets/images/icon_runner.png',
            ),
            ScoreEntry(
              label: 'Time Attack',
              score: timeAttackScore,
              iconAsset: 'assets/images/icon_timer.png',
            ),
          ],
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _showPrestigeScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PrestigeScreen(
          prestigeManager: GetIt.I<PrestigeManager>(),
          progressionManager: GetIt.I<ProgressionManager>(),
          title: 'Endless Runner Prestige',
          accentColor: const Color(0xFFFF6B35),
          onClose: () => Navigator.of(context).pop(),
          onPrestige: () => _performPrestige(context),
        ),
      ),
    );
  }

  void _performPrestige(BuildContext context) {
    final prestigeManager = GetIt.I<PrestigeManager>();
    final progressionManager = GetIt.I<ProgressionManager>();

    final pointsGained = prestigeManager.performPrestige(
      progressionManager.currentLevel,
    );

    progressionManager.reset();

    final goldManager = GetIt.I<GoldManager>();
    goldManager.trySpendGold(goldManager.currentGold);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Prestige successful! Gained $pointsGained prestige points!',
        ),
        backgroundColor: Colors.amber,
        duration: const Duration(seconds: 3),
      ),
    );

    setState(() {});
  }

  void _showDailyQuestsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DailyQuestScreen(
          questManager: GetIt.I<DailyQuestManager>(),
          title: 'Daily Quests',
          accentColor: const Color(0xFFFF6B35),
          onClaimReward: (questId, goldReward, xpReward) {
            final goldManager = GetIt.I<GoldManager>();
            final progressionManager = GetIt.I<ProgressionManager>();

            goldManager.addGold(goldReward);
            progressionManager.addXp(xpReward);
          },
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showWeeklyChallengesScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WeeklyChallengeScreen(
          challengeManager: GetIt.I<WeeklyChallengeManager>(),
          title: 'Weekly Challenges',
          accentColor: Colors.amber,
          onClaimReward: (challengeId, goldReward, xpReward, prestigeReward) {
            final goldManager = GetIt.I<GoldManager>();
            final progressionManager = GetIt.I<ProgressionManager>();
            final prestigeManager = GetIt.I<PrestigeManager>();

            goldManager.addGold(goldReward);
            progressionManager.addXp(xpReward);
            if (prestigeReward > 0) {
              prestigeManager.addPrestigePoints(prestigeReward);
            }
          },
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showStatisticsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StatisticsScreen(
          statisticsManager: GetIt.I<StatisticsManager>(),
          progressionManager: GetIt.I<ProgressionManager>(),
          prestigeManager: GetIt.I<PrestigeManager>(),
          questManager: GetIt.I<DailyQuestManager>(),
          achievementManager: GetIt.I<AchievementManager>(),
          title: 'Statistics',
          accentColor: const Color(0xFFFF6B35),
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showSettingsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => common.SettingsScreen(
          settingsManager: GetIt.I<SettingsManager>(),
          title: 'Settings',
          accentColor: const Color(0xFFFF6B35),
          onClose: () => Navigator.of(context).pop(),
          version: '1.0.0',
        ),
      ),
    );
  }

  void _showCharacterSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Select Character',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListenableBuilder(
                  listenable: GetIt.I<CharacterManager>(),
                  builder: (context, _) {
                    final charManager = GetIt.I<CharacterManager>();
                    final goldManager = GetIt.I<GoldManager>();

                    return GridView.builder(
                      controller: controller,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: CharacterData.defaultCharacters.length,
                      itemBuilder: (context, index) {
                        final character =
                            CharacterData.defaultCharacters[index];
                        final isUnlocked = charManager.isUnlocked(character.id);
                        final isSelected =
                            charManager.selectedCharacterId == character.id;

                        return GestureDetector(
                          onTap: () {
                            if (isUnlocked) {
                              charManager.selectCharacter(character.id);
                            } else {
                              if (goldManager.currentGold >= character.cost) {
                                // Purchase logic
                                if (charManager.unlockCharacter(
                                  character.id,
                                  goldManager.currentGold,
                                )) {
                                  goldManager.trySpendGold(character.cost);
                                  charManager.selectCharacter(character.id);
                                  // SFX
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Not enough coins!'),
                                  ),
                                );
                              }
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? character.color.withValues(alpha: 0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? character.color
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Character Preview
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isUnlocked
                                        ? character.color
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            (isUnlocked
                                                    ? character.color
                                                    : Colors.grey)
                                                .withValues(alpha: 0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 32,
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  character.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!isUnlocked) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.monetization_on,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${character.cost}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Select Theme',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListenableBuilder(
                  listenable: GetIt.I<ThemeManager>(),
                  builder: (context, _) {
                    final themeManager = GetIt.I<ThemeManager>();

                    return ListView.separated(
                      controller: controller,
                      itemCount: GameTheme.defaultThemes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final theme = GameTheme.defaultThemes[index];
                        final isSelected =
                            themeManager.selectedThemeId == theme.id;

                        return GestureDetector(
                          onTap: () {
                            themeManager.selectTheme(theme.id);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.platformColor.withValues(alpha: 0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? theme.platformColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: theme.skyColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    theme.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShopScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ShopScreen(onClose: () => Navigator.of(context).pop()),
      ),
    );
  }
}

class GameModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Future<int>? highScoreFuture;

  const GameModeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    this.highScoreFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                // High Score
                if (highScoreFuture != null)
                  FutureBuilder<int>(
                    future: highScoreFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data! > 0) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                size: 16,
                                color: Colors.orange,
                              ),
                              Text(
                                '${snapshot.data}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final bool showTutorial;
  final PlatformerGameMode mode;

  const GameScreen({super.key, required this.showTutorial, required this.mode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late PlatformerGame _game;
  bool _showTutorial = false;
  bool _showPause = false;
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _game = PlatformerGame(mode: widget.mode);
    _showTutorial = widget.showTutorial;
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    _highScore = await HighScoreManager.getHighScore(widget.mode.name);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),

          // MG Runner HUD
          if (!_showTutorial && !_showPause && !_game.gameOver)
            StreamBuilder<int>(
              stream: GetIt.I<GoldManager>().onGoldChanged,
              initialData: GetIt.I<GoldManager>().currentGold,
              builder: (context, snapshot) {
                return MGRunnerHud(
                  score: _game.score,
                  highScore: _highScore,
                  distance: _game.distance.toInt(),
                  coins: snapshot.data ?? 0,
                  isPaused: false,
                  onPause: () {
                    _game.togglePause();
                    setState(() => _showPause = true);
                  },
                  onResume: null,
                );
              },
            ),

          // 일시정지 오버레이
          if (_showPause)
            PauseOverlay(
              onResume: () {
                _game.resume();
                setState(() => _showPause = false);
              },
              onRestart: () {
                _game.restart();
                setState(() => _showPause = false);
              },
              onMainMenu: () {
                Navigator.of(context).pop();
              },
            ),

          // 튜토리얼 오버레이
          if (_showTutorial)
            TutorialOverlay(
              onComplete: () {
                setState(() => _showTutorial = false);
              },
            ),
        ],
      ),
    );
  }
}
