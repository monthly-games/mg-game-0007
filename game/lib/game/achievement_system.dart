import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AchievementCategory { exploration, collection, completion, challenges }

class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementCategory category;
  final int rewardCoins;
  final int rewardXP;
  bool isUnlocked;
  int progress;
  final int maxProgress;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.rewardCoins = 100,
    this.rewardXP = 50,
    this.isUnlocked = false,
    this.progress = 0,
    required this.maxProgress,
  });

  double get progressPercentage => maxProgress > 0 ? progress / maxProgress : 0;
}

class AchievementSystem extends ChangeNotifier {
  final List<Achievement> _achievements = [];

  List<Achievement> get achievements => _achievements;
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();

  int totalCoinsEarned = 0;
  int totalXPEarned = 0;

  AchievementSystem() {
    _initializeAchievements();
  }

  void _initializeAchievements() {
    _achievements.addAll([
      // Exploration Achievements
      Achievement(
        id: 'first_steps',
        name: '첫 발걸음',
        description: '첫 레벨 완료',
        category: AchievementCategory.exploration,
        rewardCoins: 50,
        rewardXP: 25,
        maxProgress: 1,
      ),
      Achievement(
        id: 'explorer_10',
        name: '탐험가 (10단계)',
        description: '10개 레벨 완료',
        category: AchievementCategory.exploration,
        rewardCoins: 200,
        rewardXP: 100,
        maxProgress: 10,
      ),
      Achievement(
        id: 'explorer_50',
        name: '숙련된 탐험가',
        description: '50개 레벨 완료',
        category: AchievementCategory.exploration,
        rewardCoins: 1000,
        rewardXP: 500,
        maxProgress: 50,
      ),
      Achievement(
        id: 'world_master',
        name: '세계의 마스터',
        description: '모든 레벨 완료',
        category: AchievementCategory.exploration,
        rewardCoins: 5000,
        rewardXP: 2500,
        maxProgress: 100, // Assuming 100 levels total
      ),

      // Collection Achievements
      Achievement(
        id: 'coin_collector_100',
        name: '동전 수집가',
        description: '게임 내에서 100코인 수집',
        category: AchievementCategory.collection,
        rewardCoins: 100,
        rewardXP: 50,
        maxProgress: 100,
      ),
      Achievement(
        id: 'coin_collector_1000',
        name: '부자',
        description: '게임 내에서 1000코인 수집',
        category: AchievementCategory.collection,
        rewardCoins: 500,
        rewardXP: 250,
        maxProgress: 1000,
      ),
      Achievement(
        id: 'collectible_hunter',
        name: '수집품 사냥꾼',
        description: '50개 수집품 획득',
        category: AchievementCategory.collection,
        rewardCoins: 300,
        rewardXP: 150,
        maxProgress: 50,
      ),
      Achievement(
        id: 'completionist',
        name: '완벽주의자',
        description: '모든 수집품 획득',
        category: AchievementCategory.collection,
        rewardCoins: 2000,
        rewardXP: 1000,
        maxProgress: 100, // Assuming 100 collectibles total
      ),

      // Completion Achievements
      Achievement(
        id: 'no_death_run',
        name: '불사의 몸',
        description: '사망 없이 5개 레벨 완료',
        category: AchievementCategory.completion,
        rewardCoins: 500,
        rewardXP: 250,
        maxProgress: 5,
      ),
      Achievement(
        id: 'speed_runner',
        name: '스피드 러너',
        description: '3분 안에 레벨 완료',
        category: AchievementCategory.completion,
        rewardCoins: 300,
        rewardXP: 150,
        maxProgress: 1,
      ),
      Achievement(
        id: 'perfect_level',
        name: '완벽한 클리어',
        description: '모든 코인을 획득하며 레벨 완료',
        category: AchievementCategory.completion,
        rewardCoins: 200,
        rewardXP: 100,
        maxProgress: 1,
      ),
      Achievement(
        id: 'character_master',
        name: '캐릭터 마스터',
        description: '모든 캐릭터 해금',
        category: AchievementCategory.completion,
        rewardCoins: 1500,
        rewardXP: 750,
        maxProgress: 5, // Assuming 5 characters
      ),

      // Challenge Achievements
      Achievement(
        id: 'obstacle_survivor',
        description: '장애물 없이 100개 플랫폼 통과',
        category: AchievementCategory.challenges,
        rewardCoins: 250,
        rewardXP: 125,
        maxProgress: 100,
      ),
      Achievement(
        id: 'theme_collector',
        name: '테마 컬렉터',
        description: '모든 테마 해금',
        category: AchievementCategory.challenges,
        rewardCoins: 1000,
        rewardXP: 500,
        maxProgress: 5, // Assuming 5 themes
      ),
      Achievement(
        id: 'hardcore_player',
        name: '하드코어 플레이어',
        description: '어려운 난이도에서 20개 레벨 완료',
        category: AchievementCategory.challenges,
        rewardCoins: 2000,
        rewardXP: 1000,
        maxProgress: 20,
      ),
    ]);
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    for (var achievement in _achievements) {
      final unlocked = prefs.getBool('ach_${achievement.id}_unlocked') ?? false;
      final progress = prefs.getInt('ach_${achievement.id}_progress') ?? 0;

      achievement.isUnlocked = unlocked;
      achievement.progress = progress;
    }

    totalCoinsEarned = prefs.getInt('total_ach_coins') ?? 0;
    totalXPEarned = prefs.getInt('total_ach_xp') ?? 0;

    notifyListeners();
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    for (var achievement in _achievements) {
      await prefs.setBool('ach_${achievement.id}_unlocked', achievement.isUnlocked);
      await prefs.setInt('ach_${achievement.id}_progress', achievement.progress);
    }

    await prefs.setInt('total_ach_coins', totalCoinsEarned);
    await prefs.setInt('total_ach_xp', totalXPEarned);
  }

  (int coins, int xp) updateProgress(String achievementId, int delta) {
    final achievement = _achievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => _achievements.first,
    );

    if (achievement.isUnlocked) return (0, 0);

    achievement.progress = (achievement.progress + delta).clamp(0, achievement.maxProgress);

    int coinsEarned = 0;
    int xpEarned = 0;

    if (achievement.progress >= achievement.maxProgress && !achievement.isUnlocked) {
      achievement.isUnlocked = true;
      coinsEarned = achievement.rewardCoins;
      xpEarned = achievement.rewardXP;

      totalCoinsEarned += coinsEarned;
      totalXPEarned += xpEarned;
    }

    saveProgress();
    notifyListeners();
    return (coinsEarned, xpEarned);
  }

  bool isUnlocked(String achievementId) {
    final achievement = _achievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => _achievements.first,
    );
    return achievement.isUnlocked;
  }

  List<Achievement> getAchievementsByCategory(AchievementCategory category) {
    return _achievements.where((a) => a.category == category).toList();
  }

  List<Achievement> getUnlockedAchievements() {
    return _achievements.where((a) => a.isUnlocked).toList();
  }

  List<Achievement> getInProgressAchievements() {
    return _achievements.where((a) => !a.isUnlocked && a.progress > 0).toList();
  }

  List<Achievement> getLockedAchievements() {
    return _achievements.where((a) => !a.isUnlocked && a.progress == 0).toList();
  }

  double getCompletionPercentage() {
    if (_achievements.isEmpty) return 0.0;
    final unlocked = _achievements.where((a) => a.isUnlocked).length;
    return (unlocked / _achievements.length) * 100;
  }

  int getTotalProgress() {
    int total = 0;
    for (var achievement in _achievements) {
      total += achievement.progress;
    }
    return total;
  }

  int getMaxTotalProgress() {
    int total = 0;
    for (var achievement in _achievements) {
      total += achievement.maxProgress;
    }
    return total;
  }
}
