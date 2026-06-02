import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MissionType { daily, weekly }
enum MissionDifficulty { easy, medium, hard }

class Mission {
  final String id;
  final String title;
  final String description;
  final MissionType type;
  final MissionDifficulty difficulty;
  final int targetValue;
  int currentProgress;
  final int rewardCoins;
  final int rewardXP;
  bool isCompleted;
  bool isClaimed;
  final DateTime createdAt;
  DateTime? lastRefreshTime;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.targetValue,
    this.currentProgress = 0,
    required this.rewardCoins,
    required this.rewardXP,
    this.isCompleted = false,
    this.isClaimed = false,
    required this.createdAt,
    this.lastRefreshTime,
  });

  double get progressPercentage =>
      targetValue > 0 ? currentProgress / targetValue : 0;

  bool get isExpired {
    final now = DateTime.now();
    final lastRefresh = lastRefreshTime ?? createdAt;

    if (type == MissionType.daily) {
      // Daily missions expire after 24 hours
      return now.difference(lastRefresh).inHours >= 24;
    } else {
      // Weekly missions expire after 7 days
      return now.difference(lastRefresh).inDays >= 7;
    }
  }

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    MissionType? type,
    MissionDifficulty? difficulty,
    int? targetValue,
    int? currentProgress,
    int? rewardCoins,
    int? rewardXP,
    bool? isCompleted,
    bool? isClaimed,
    DateTime? createdAt,
    DateTime? lastRefreshTime,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      targetValue: targetValue ?? this.targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      rewardXP: rewardXP ?? this.rewardXP,
      isCompleted: isCompleted ?? this.isCompleted,
      isClaimed: isClaimed ?? this.isClaimed,
      createdAt: createdAt ?? this.createdAt,
      lastRefreshTime: lastRefreshTime ?? this.lastRefreshTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'difficulty': difficulty.name,
      'targetValue': targetValue,
      'currentProgress': currentProgress,
      'rewardCoins': rewardCoins,
      'rewardXP': rewardXP,
      'isCompleted': isCompleted,
      'isClaimed': isClaimed,
      'createdAt': createdAt.toIso8601String(),
      'lastRefreshTime': lastRefreshTime?.toIso8601String(),
    };
  }

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: MissionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MissionType.daily,
      ),
      difficulty: MissionDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => MissionDifficulty.easy,
      ),
      targetValue: json['targetValue'] as int,
      currentProgress: json['currentProgress'] as int? ?? 0,
      rewardCoins: json['rewardCoins'] as int,
      rewardXP: json['rewardXP'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isClaimed: json['isClaimed'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastRefreshTime: json['lastRefreshTime'] != null
          ? DateTime.parse(json['lastRefreshTime'] as String)
          : null,
    );
  }
}

class MissionSystem extends ChangeNotifier {
  final List<Mission> _dailyMissions = [];
  final List<Mission> _weeklyMissions = [];

  List<Mission> get dailyMissions => _dailyMissions;
  List<Mission> get weeklyMissions => _weeklyMissions;

  int totalCoinsEarned = 0;
  int totalXPEarned = 0;

  MissionSystem() {
    _initializeMissions();
  }

  void _initializeMissions() {
    _generateDailyMissions();
    _generateWeeklyMissions();
  }

  void _generateDailyMissions() {
    final now = DateTime.now();
    _dailyMissions.clear();
    _dailyMissions.addAll([
      Mission(
        id: 'daily_score_500',
        title: '점수 달성 (500점)',
        description: '한 게임에서 500점 이상 획득',
        type: MissionType.daily,
        difficulty: MissionDifficulty.easy,
        targetValue: 500,
        rewardCoins: 50,
        rewardXP: 25,
        createdAt: now,
      ),
      Mission(
        id: 'daily_coins_50',
        title: '코인 수집가 (50개)',
        description: '한 게임에서 50개 이상의 코인 수집',
        type: MissionType.daily,
        difficulty: MissionDifficulty.easy,
        targetValue: 50,
        rewardCoins: 40,
        rewardXP: 20,
        createdAt: now,
      ),
      Mission(
        id: 'daily_jumps_100',
        title: '점프 마스터 (100회)',
        description: '게임 플레이 중 100회 점프',
        type: MissionType.daily,
        difficulty: MissionDifficulty.medium,
        targetValue: 100,
        rewardCoins: 60,
        rewardXP: 30,
        createdAt: now,
      ),
      Mission(
        id: 'daily_distance_2000',
        title: '장거리 러너 (2000m)',
        description: '한 게임에서 2000m 이상 이동',
        type: MissionType.daily,
        difficulty: MissionDifficulty.medium,
        targetValue: 2000,
        rewardCoins: 70,
        rewardXP: 35,
        createdAt: now,
      ),
      Mission(
        id: 'daily_powerups_10',
        title: '파워업 수집가 (10개)',
        description: '10개의 파워업 아이템 수집',
        type: MissionType.daily,
        difficulty: MissionDifficulty.hard,
        targetValue: 10,
        rewardCoins: 80,
        rewardXP: 40,
        createdAt: now,
      ),
    ]);
  }

  void _generateWeeklyMissions() {
    final now = DateTime.now();
    _weeklyMissions.clear();
    _weeklyMissions.addAll([
      Mission(
        id: 'weekly_games_20',
        title: '열정적 플레이어 (20게임)',
        description: '일주일간 20게임 플레이',
        type: MissionType.weekly,
        difficulty: MissionDifficulty.medium,
        targetValue: 20,
        rewardCoins: 200,
        rewardXP: 100,
        createdAt: now,
      ),
      Mission(
        id: 'weekly_total_coins_1000',
        title: '코인 부자 (1000코인)',
        description: '일주일간 총 1000코인 수집',
        type: MissionType.weekly,
        difficulty: MissionDifficulty.medium,
        targetValue: 1000,
        rewardCoins: 250,
        rewardXP: 125,
        createdAt: now,
      ),
      Mission(
        id: 'weekly_high_score_2000',
        title: '고수 플레이어 (2000점)',
        description: '최고 점수 2000점 달성',
        type: MissionType.weekly,
        difficulty: MissionDifficulty.hard,
        targetValue: 2000,
        rewardCoins: 300,
        rewardXP: 150,
        createdAt: now,
      ),
      Mission(
        id: 'weekly_powerups_50',
        title: '파워업 마스터 (50개)',
        description: '일주일간 50개 파워업 아이템 수집',
        type: MissionType.weekly,
        difficulty: MissionDifficulty.hard,
        targetValue: 50,
        rewardCoins: 350,
        rewardXP: 175,
        createdAt: now,
      ),
      Mission(
        id: 'weekly_total_distance_20000',
        title: '마라톤 러너 (20000m)',
        description: '일주일간 총 20000m 이동',
        type: MissionType.weekly,
        difficulty: MissionDifficulty.hard,
        targetValue: 20000,
        rewardCoins: 400,
        rewardXP: 200,
        createdAt: now,
      ),
    ]);
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Load daily missions
    final dailyJson = prefs.getStringList('daily_missions');
    if (dailyJson != null) {
      _dailyMissions.clear();
      for (var json in dailyJson) {
        try {
          final mission = Mission.fromJson(
            jsonDecode(json) as Map<String, dynamic>,
          );
          if (!mission.isExpired) {
            _dailyMissions.add(mission);
          }
        } catch (e) {
          debugPrint('Error loading mission: $e');
        }
      }
    }

    // If all daily missions expired, regenerate
    if (_dailyMissions.isEmpty || _dailyMissions.every((m) => m.isExpired)) {
      _generateDailyMissions();
    }

    // Load weekly missions
    final weeklyJson = prefs.getStringList('weekly_missions');
    if (weeklyJson != null) {
      _weeklyMissions.clear();
      for (var json in weeklyJson) {
        try {
          final mission = Mission.fromJson(
            jsonDecode(json) as Map<String, dynamic>,
          );
          if (!mission.isExpired) {
            _weeklyMissions.add(mission);
          }
        } catch (e) {
          debugPrint('Error loading mission: $e');
        }
      }
    }

    // If all weekly missions expired, regenerate
    if (_weeklyMissions.isEmpty || _weeklyMissions.every((m) => m.isExpired)) {
      _generateWeeklyMissions();
    }

    totalCoinsEarned = prefs.getInt('total_mission_coins') ?? 0;
    totalXPEarned = prefs.getInt('total_mission_xp') ?? 0;

    notifyListeners();
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Save daily missions
    final dailyJson = _dailyMissions.map((m) => _missionToJson(m)).toList();
    await prefs.setStringList('daily_missions', dailyJson);

    // Save weekly missions
    final weeklyJson = _weeklyMissions.map((m) => _missionToJson(m)).toList();
    await prefs.setStringList('weekly_missions', weeklyJson);

    await prefs.setInt('total_mission_coins', totalCoinsEarned);
    await prefs.setInt('total_mission_xp', totalXPEarned);
  }

  String _missionToJson(Mission mission) {
    return jsonEncode(mission.toJson());
  }

  (int coins, int xp) updateProgress(String missionId, int delta) {
    Mission? mission = _dailyMissions.firstWhere(
      (m) => m.id == missionId,
      orElse: () => _weeklyMissions.firstWhere(
        (m) => m.id == missionId,
        orElse: () => _dailyMissions.first,
      ),
    );

    if (mission.isCompleted) return (0, 0);

    mission.currentProgress =
        (mission.currentProgress + delta).clamp(0, mission.targetValue);

    int coinsEarned = 0;
    int xpEarned = 0;

    if (mission.currentProgress >= mission.targetValue && !mission.isCompleted) {
      mission.isCompleted = true;
    }

    saveProgress();
    notifyListeners();
    return (coinsEarned, xpEarned);
  }

  (int coins, int xp) claimReward(String missionId) {
    Mission? mission = _dailyMissions.firstWhere(
      (m) => m.id == missionId,
      orElse: () => _weeklyMissions.firstWhere(
        (m) => m.id == missionId,
        orElse: () => _dailyMissions.first,
      ),
    );

    if (!mission.isCompleted || mission.isClaimed) return (0, 0);

    mission.isClaimed = true;
    final coinsEarned = mission.rewardCoins;
    final xpEarned = mission.rewardXP;

    totalCoinsEarned += coinsEarned;
    totalXPEarned += xpEarned;

    saveProgress();
    notifyListeners();
    return (coinsEarned, xpEarned);
  }

  List<Mission> getActiveDailyMissions() {
    return _dailyMissions.where((m) => !m.isExpired).toList();
  }

  List<Mission> getActiveWeeklyMissions() {
    return _weeklyMissions.where((m) => !m.isExpired).toList();
  }

  List<Mission> getCompletedMissions() {
    return [..._dailyMissions, ..._weeklyMissions]
        .where((m) => m.isCompleted && !m.isClaimed)
        .toList();
  }

  int getTotalProgress() {
    int total = 0;
    for (var mission in [..._dailyMissions, ..._weeklyMissions]) {
      total += mission.currentProgress;
    }
    return total;
  }

  int getMaxTotalProgress() {
    int total = 0;
    for (var mission in [..._dailyMissions, ..._weeklyMissions]) {
      total += mission.targetValue;
    }
    return total;
  }

  double getCompletionPercentage() {
    final allMissions = [..._dailyMissions, ..._weeklyMissions];
    if (allMissions.isEmpty) return 0.0;
    final completed = allMissions.where((m) => m.isCompleted).length;
    return (completed / allMissions.length) * 100;
  }

  void refreshDailyMissions() {
    _generateDailyMissions();
    saveProgress();
    notifyListeners();
  }

  void refreshWeeklyMissions() {
    _generateWeeklyMissions();
    saveProgress();
    notifyListeners();
  }

  // Helper methods for game events
  void onGameEnd(int score, int coins, int distance) {
    updateProgress('daily_score_500', score);
    updateProgress('weekly_high_score_2000', score);
    updateProgress('daily_coins_50', coins);
    updateProgress('weekly_total_coins_1000', coins);
    updateProgress('daily_distance_2000', distance);
    updateProgress('weekly_total_distance_20000', distance);
  }

  void onJump() {
    updateProgress('daily_jumps_100', 1);
  }

  void onPowerupCollected() {
    updateProgress('daily_powerups_10', 1);
    updateProgress('weekly_powerups_50', 1);
  }

  void onGamePlayed() {
    updateProgress('weekly_games_20', 1);
  }
}
