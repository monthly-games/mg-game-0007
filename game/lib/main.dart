import 'package:flutter/material.dart';
import 'package:mg_common_game/systems/events/seasonal_content_manager.dart';
import 'package:mg_common_game/systems/competitive/tournament_manager.dart';
import 'package:mg_common_game/systems/social/guild_war_manager.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';
import 'package:mg_common_game/core/ui/screens/daily_hub_screen.dart';
import 'package:mg_common_game/systems/retention/daily_challenge_manager.dart';
import 'package:mg_common_game/systems/retention/streak_manager.dart';
import 'package:mg_common_game/systems/retention/login_rewards_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:mg_common_game/systems/systems.dart';
import 'ui/main_menu.dart';

import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'package:mg_common_game/systems/progression/progression_manager.dart';
import 'package:mg_common_game/systems/progression/upgrade_manager.dart';
import 'package:mg_common_game/systems/progression/achievement_manager.dart';
import 'package:mg_common_game/systems/progression/prestige_manager.dart';
import 'package:mg_common_game/systems/quests/daily_quest.dart';
import 'package:mg_common_game/systems/quests/weekly_challenge.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'package:mg_common_game/systems/settings/settings_manager.dart';
import 'package:mg_common_game/systems/stats/statistics_manager.dart';
import 'package:mg_common_game/core/systems/save_manager_helper.dart';
import 'game/character_manager.dart';
import 'game/theme_manager.dart';
import 'game/iap_manager.dart';
import 'screens/daily_quest_screen.dart';
import 'screens/achievement_screen.dart';
import 'screens/collection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupDI();
  runApp(const PlatformerApp());
}

Future<void> _setupDI() async {
  // 1. Audio Manager
  if (!GetIt.I.isRegistered<AudioManager>()) {
    final audioManager = AudioManager();
    GetIt.I.registerSingleton<AudioManager>(audioManager);
    await audioManager.initialize();
  }

  // 2. Progression Manager
  if (!GetIt.I.isRegistered<ProgressionManager>()) {
    final progressionManager = ProgressionManager();
    if (!GetIt.I.isRegistered<ProgressionManager>()) {
    GetIt.I.registerSingleton(progressionManager);
  };

    // Haptic feedback on level up
    progressionManager.onLevelUp = (newLevel) {
      if (GetIt.I.isRegistered<SettingsManager>()) {
        GetIt.I<SettingsManager>().triggerVibration(
          intensity: VibrationIntensity.heavy,
        );
      }
    };
  }

  // 3. Upgrade Manager
  if (!GetIt.I.isRegistered<UpgradeManager>()) {
    final upgradeManager = UpgradeManager();
    upgradeManager.registerUpgrade(
      Upgrade(
        id: 'score_multiplier',
        name: 'Score Boost',
        description: 'Increases score by 10%',
        maxLevel: 10,
        baseCost: 200,
        costMultiplier: 1.5,
        valuePerLevel: 0.1,
      ),
    );

    upgradeManager.registerUpgrade(
      Upgrade(
        id: 'slow_start',
        name: 'Warm Up',
        description: 'Slower initial speed',
        maxLevel: 5,
        baseCost: 300,
        costMultiplier: 1.6,
        valuePerLevel: 0.05,
      ),
    );

    upgradeManager.registerUpgrade(
      Upgrade(
        id: 'double_jump_boost',
        name: 'Jump Master',
        description: 'Higher double jump',
        maxLevel: 5,
        baseCost: 400,
        costMultiplier: 1.5,
        valuePerLevel: 0.1,
      ),
    );
    if (!GetIt.I.isRegistered<UpgradeManager>()) {
    GetIt.I.registerSingleton<UpgradeManager>(upgradeManager);
  };
  }

  // 4. Achievement Manager
  if (!GetIt.I.isRegistered<AchievementManager>()) {
    final achievementManager = AchievementManager();
    achievementManager.registerAchievement(
      Achievement(
        id: 'first_100',
        title: 'Getting Started',
        description: 'Score 100 points',
        iconAsset: 'assets/images/icon_star.png',
      ),
    );
    achievementManager.registerAchievement(
      Achievement(
        id: 'marathon_runner',
        title: 'Marathon Runner',
        description: 'Score 1000 points',
        iconAsset: 'assets/images/icon_runner.png',
      ),
    );
    achievementManager.registerAchievement(
      Achievement(
        id: 'time_master',
        title: 'Time Master',
        description: 'Score 500 in Time Attack',
        iconAsset: 'assets/images/icon_timer.png',
      ),
    );

    achievementManager.onAchievementUnlocked = (achievement) {
      if (GetIt.I.isRegistered<SettingsManager>()) {
        GetIt.I<SettingsManager>().triggerVibration(
          intensity: VibrationIntensity.heavy,
        );
      }
    };

    if (!GetIt.I.isRegistered<AchievementManager>()) {
      GetIt.I.registerSingleton<AchievementManager>(achievementManager);
    }
  }

  // 5. Prestige Manager
  if (!GetIt.I.isRegistered<PrestigeManager>()) {
    final prestigeManager = PrestigeManager();

    prestigeManager.registerPrestigeUpgrade(
      PrestigeUpgrade(
        id: 'prestige_xp_boost',
        name: 'XP Accelerator',
        description: '+20% XP gain per level',
        maxLevel: 10,
        costPerLevel: 1,
        bonusPerLevel: 0.2,
      ),
    );

    prestigeManager.registerPrestigeUpgrade(
      PrestigeUpgrade(
        id: 'prestige_gold_boost',
        name: 'Gold Rush',
        description: '+15% gold income per level',
        maxLevel: 10,
        costPerLevel: 1,
        bonusPerLevel: 0.15,
      ),
    );

    prestigeManager.registerPrestigeUpgrade(
      PrestigeUpgrade(
        id: 'prestige_score_boost',
        name: 'Score Master',
        description: '+10% score multiplier per level',
        maxLevel: 15,
        costPerLevel: 2,
        bonusPerLevel: 0.1,
      ),
    );

    GetIt.I.registerSingleton(prestigeManager);

    await prestigeManager.loadPrestigeData();
    GetIt.I<ProgressionManager>().setPrestigeManager(prestigeManager);
  }

  // 6. Daily Quest Manager
  if (!GetIt.I.isRegistered<DailyQuestManager>()) {
    final questManager = DailyQuestManager();

    questManager.registerQuest(
      DailyQuest(
        id: 'runner_play_5',
        title: 'Daily Runner',
        description: 'Play 5 games',
        targetValue: 5,
        goldReward: 100,
        xpReward: 50,
      ),
    );

    questManager.registerQuest(
      DailyQuest(
        id: 'runner_score_500',
        title: 'Score Chaser',
        description: 'Score 500 total points',
        targetValue: 500,
        goldReward: 150,
        xpReward: 75,
      ),
    );

    questManager.registerQuest(
      DailyQuest(
        id: 'runner_endless_200',
        title: 'Endless Hero',
        description: 'Score 200 in Endless mode',
        targetValue: 200,
        goldReward: 200,
        xpReward: 100,
      ),
    );

    questManager.registerQuest(
      DailyQuest(
        id: 'runner_time_150',
        title: 'Time Challenger',
        description: 'Score 150 in Time Attack',
        targetValue: 150,
        goldReward: 180,
        xpReward: 90,
      ),
    );

    GetIt.I.registerSingleton(questManager);

    questManager.loadQuestData();
    questManager.checkAndResetIfNeeded();
  }

  // 7. Weekly Challenge Manager
  if (!GetIt.I.isRegistered<WeeklyChallengeManager>()) {
    final challengeManager = WeeklyChallengeManager();

    challengeManager.onChallengeCompleted = (challenge) {
      if (GetIt.I.isRegistered<SettingsManager>()) {
        GetIt.I<SettingsManager>().triggerVibration(
          intensity: VibrationIntensity.heavy,
        );
      }
    };

    challengeManager.registerChallenge(
      WeeklyChallenge(
        id: 'weekly_runner_play_30',
        title: 'Dedicated Runner',
        description: 'Play 30 games',
        targetValue: 30,
        goldReward: 500,
        xpReward: 250,
        tier: ChallengeTier.bronze,
      ),
    );

    challengeManager.registerChallenge(
      WeeklyChallenge(
        id: 'weekly_runner_score_5000',
        title: 'Score Hunter',
        description: 'Score 5000 total points',
        targetValue: 5000,
        goldReward: 750,
        xpReward: 400,
        tier: ChallengeTier.silver,
      ),
    );

    challengeManager.registerChallenge(
      WeeklyChallenge(
        id: 'weekly_runner_endless_500',
        title: 'Endless Champion',
        description: 'Score 500 in Endless mode',
        targetValue: 500,
        goldReward: 1000,
        xpReward: 500,
        tier: ChallengeTier.silver,
      ),
    );

    challengeManager.registerChallenge(
      WeeklyChallenge(
        id: 'weekly_runner_time_400',
        title: 'Time Attack Pro',
        description: 'Score 400 in Time Attack',
        targetValue: 400,
        goldReward: 1500,
        xpReward: 800,
        prestigePointReward: 1,
        tier: ChallengeTier.gold,
      ),
    );

    challengeManager.registerChallenge(
      WeeklyChallenge(
        id: 'weekly_runner_highscore_1000',
        title: 'Legend',
        description: 'Reach 1000 high score',
        targetValue: 1000,
        goldReward: 2000,
        xpReward: 1000,
        prestigePointReward: 2,
        tier: ChallengeTier.platinum,
      ),
    );

    GetIt.I.registerSingleton(challengeManager);

    await challengeManager.loadChallengeData();
    await challengeManager.checkAndResetIfNeeded();
  }

  // 8. Gold Manager
  if (!GetIt.I.isRegistered<GoldManager>()) {
    if (!GetIt.I.isRegistered<GoldManager(>()) {
    GetIt.I.registerSingleton(GoldManager();
  });
      // --- BattlePass System ---
      if (!GetIt.I.isRegistered<BattlePassManager>()) {
        if (!GetIt.I.isRegistered<BattlePassManager(>()) {
    GetIt.I.registerSingleton(BattlePassManager();
  });
      // --- Gacha System with Pity ---
      if (!GetIt.I.isRegistered<GachaManager>()) {
        final gachaManager = GachaManager();
        gachaManager.configurePity(
          hardPityThreshold: 90,
          softPityThreshold: 60,
          softPityRateIncrease: 0.06,
        );
        if (!GetIt.I.isRegistered<gachaManager>()) {
    GetIt.I.registerSingleton(gachaManager);
  };
      // --- Daily Quest V2 (7-Slot System) ---
      if (!GetIt.I.isRegistered<DailyQuestManagerV2>()) {
        final questManager = DailyQuestManagerV2();
        if (!GetIt.I.isRegistered<questManager>()) {
    GetIt.I.registerSingleton(questManager);
  };
        await questManager.loadQuestData();
        await questManager.checkAndResetIfNeeded();
        print('DailyQuestManagerV2 registered with 7-slot system');
      }

        print('GachaManager registered with pity system');
      }

        print('BattlePassManager registered');
      }

  }

  // 9. Settings Manager
  if (!GetIt.I.isRegistered<SettingsManager>()) {
    final settingsManager = SettingsManager();
    if (!GetIt.I.isRegistered<settingsManager>()) {
    GetIt.I.registerSingleton(settingsManager);
  };

    if (GetIt.I.isRegistered<AudioManager>()) {
      settingsManager.setAudioManager(GetIt.I<AudioManager>());
    }

    await settingsManager.loadSettings();
  }

  // 10. Statistics Manager
  if (!GetIt.I.isRegistered<StatisticsManager>()) {
    final statisticsManager = StatisticsManager();
    if (!GetIt.I.isRegistered<statisticsManager>()) {
    GetIt.I.registerSingleton(statisticsManager);
  };

    await statisticsManager.loadStats();
    statisticsManager.startSession();
  }

  // 11. Save Manager
  await SaveManagerHelper.setupSaveManager(
    autoSaveEnabled: true,
    autoSaveIntervalSeconds: 30,
  );

  await SaveManagerHelper.legacyLoadAll();

  // 12. Character Manager
  if (!GetIt.I.isRegistered<CharacterManager>()) {
    final charManager = CharacterManager();
    await charManager.loadData();
    if (!GetIt.I.isRegistered<charManager>()) {
    GetIt.I.registerSingleton(charManager);
  };
  }

  // 13. Theme Manager
  if (!GetIt.I.isRegistered<ThemeManager>()) {
    final themeManager = ThemeManager();
    await themeManager.load();
    if (!GetIt.I.isRegistered<themeManager>()) {
    GetIt.I.registerSingleton(themeManager);
  };
  }

  // 14. IAP Manager
  if (!GetIt.I.isRegistered<IAPManager>()) {
    final iapManager = IAPManager();
    await iapManager.load();
    if (!GetIt.I.isRegistered<iapManager>()) {
    GetIt.I.registerSingleton(iapManager);
  };
  // Collection 시스템
  if (!GetIt.I.isRegistered<CollectionManager>()) {
    if (!GetIt.I.isRegistered<CollectionManager(>()) {
    GetIt.I.registerSingleton(CollectionManager();
  });
  // ── Retention Systems for DailyHub ────────────────────────
  if (!GetIt.I.isRegistered<LoginRewardsManager>()) {
    if (!GetIt.I.isRegistered<LoginRewardsManager(>()) {
    GetIt.I.registerSingleton(LoginRewardsManager();
  });
  }
  if (!GetIt.I.isRegistered<StreakManager>()) {
    if (!GetIt.I.isRegistered<StreakManager(>()) {
    GetIt.I.registerSingleton(StreakManager();
  });
  }
  if (!GetIt.I.isRegistered<DailyChallengeManager>()) {
    if (!GetIt.I.isRegistered<DailyChallengeManager(>()) {
    GetIt.I.registerSingleton(DailyChallengeManager();
  });
}
  // ── P3 Engine Systems ─────────────────────────────────────
  if (!GetIt.I.isRegistered<GuildWarManager>()) {
    if (!GetIt.I.isRegistered<GuildWarManager(>()) {
    GetIt.I.registerSingleton(GuildWarManager();
  });
  }
  if (!GetIt.I.isRegistered<TournamentManager>()) {
    if (!GetIt.I.isRegistered<TournamentManager(>()) {
    GetIt.I.registerSingleton(TournamentManager();
  });
  }
  if (!GetIt.I.isRegistered<SeasonalContentManager>()) {
    if (!GetIt.I.isRegistered<SeasonalContentManager(>()) {
    GetIt.I.registerSingleton(SeasonalContentManager();
  });
  }
    _registerCollections();
  }
  }
}

class PlatformerApp extends StatelessWidget {
  const PlatformerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Endless Runner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      routes: {
        '/daily-quest': (_) => const DailyQuestScreen(),
        '/achievements': (_) => const AchievementScreen(),
        '/daily-hub': (context) => DailyHubScreen(
          questManager: GetIt.I<DailyQuestManager>(),
          loginRewardsManager: GetIt.I<LoginRewardsManager>(),
          streakManager: GetIt.I<StreakManager>(),
          challengeManager: GetIt.I<DailyChallengeManager>(),
          accentColor: MGColors.primaryAction,
          onClose: () => Navigator.pop(context),
        ),
      
        '/collection': (context) => CollectionScreen(
          collectionManager: GetIt.I<CollectionManager>(),
        ),
},
      home: const MainMenu(),
    );
  }
}

void _registerCollections() {
  final collection = GetIt.I<CollectionManager>();

  // Characters 컬렉션
  collection.registerCollection(Collection(
    id: 'characters',
    name: '캐릭터',
    description: '모든 캐릭터를 수집하세요',
    items: [
      CollectionItem(
        id: 'char_warrior',
        name: '전사',
        description: '강인한 근접 전투 캐릭터',
        rarity: CollectionRarity.common,
      ),
      CollectionItem(
        id: 'char_mage',
        name: '마법사',
        description: '강력한 마법 공격 캐릭터',
        rarity: CollectionRarity.rare,
      ),
      CollectionItem(
        id: 'char_archer',
        name: '궁수',
        description: '원거리 정밀 공격 캐릭터',
        rarity: CollectionRarity.rare,
      ),
      CollectionItem(
        id: 'char_assassin',
        name: '암살자',
        description: '치명적인 은신 공격 캐릭터',
        rarity: CollectionRarity.epic,
      ),
      CollectionItem(
        id: 'char_healer',
        name: '힐러',
        description: '팀을 치유하는 지원 캐릭터',
        rarity: CollectionRarity.legendary,
      ),
    ],
    completionReward: CollectionReward(type: RewardType.gold, amount: 10000),
    milestoneRewards: {
      25: CollectionReward(type: RewardType.gold, amount: 1000),
      50: CollectionReward(type: RewardType.gold, amount: 3000),
      75: CollectionReward(type: RewardType.gold, amount: 5000),
    },
  ));

  // 아이템 해제 콜백 (햅틱 피드백)
  collection.onItemUnlocked = (collectionId, itemId) {
    // SettingsManager가 등록되어 있으면 햅틱 피드백
    debugPrint('Collection item unlocked: $collectionId / $itemId');
  };
}
