import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/mission_system.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';

class MissionScreen extends StatelessWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MGColors.background,
      appBar: AppBar(
        title: const Text('미션'),
        backgroundColor: MGColors.primary,
        foregroundColor: MGColors.textHighEmphasis,
      ),
      body: Consumer<MissionSystem>(
        builder: (context, missionSystem, child) {
          final dailyMissions = missionSystem.getActiveDailyMissions();
          final weeklyMissions = missionSystem.getActiveWeeklyMissions();
          final completedMissions = missionSystem.getCompletedMissions();

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  labelColor: MGColors.primary,
                  unselectedLabelColor: MGColors.textMediumEmphasis,
                  indicatorColor: MGColors.primary,
                  tabs: const [
                    Tab(text: '일일 미션'),
                    Tab(text: '주간 미션'),
                    Tab(text: '완료된 미션'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildMissionList(dailyMissions, missionSystem, context),
                      _buildMissionList(weeklyMissions, missionSystem, context),
                      _buildMissionList(completedMissions, missionSystem, context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMissionList(List<Mission> missions, MissionSystem missionSystem, BuildContext context) {
    if (missions.isEmpty) {
      return const Center(
        child: Text(
          '미션이 없습니다',
          style: TextStyle(color: MGColors.textMediumEmphasis, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final mission = missions[index];
        return _MissionCard(mission: mission, missionSystem: missionSystem);
      },
    );
  }
}

class _MissionCard extends StatelessWidget {
  final Mission mission;
  final MissionSystem missionSystem;

  const _MissionCard({
    required this.mission,
    required this.missionSystem,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = mission.isCompleted;
    final isClaimed = mission.isClaimed;
    final progress = mission.progressPercentage;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isClaimed ? MGColors.surface : MGColors.card,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.title,
                        style: TextStyle(
                          color: isClaimed
                              ? MGColors.textMediumEmphasis
                              : MGColors.textHighEmphasis,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mission.description,
                        style: const TextStyle(
                          color: MGColors.textMediumEmphasis,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted && !isClaimed)
                  ElevatedButton(
                    onPressed: () {
                      final (coins, xp) = missionSystem.claimReward(mission.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('보상 획득: $coins 코인, $xp XP'),
                          backgroundColor: MGColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MGColors.primary,
                      foregroundColor: MGColors.textHighEmphasis,
                    ),
                    child: const Text('보상 받기'),
                  )
                else if (isClaimed)
                  const Icon(
                    Icons.check_circle,
                    color: MGColors.success,
                    size: 32,
                  )
                else
                  _DifficultyBadge(difficulty: mission.difficulty),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: MGColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? MGColors.success : MGColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${mission.currentProgress} / ${mission.targetValue}',
                  style: const TextStyle(
                    color: MGColors.textMediumEmphasis,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.monetization_on, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '+${mission.rewardCoins}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, size: 16, color: MGColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '+${mission.rewardXP}',
                      style: const TextStyle(
                        color: MGColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final MissionDifficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (difficulty) {
      case MissionDifficulty.easy:
        color = MGColors.success;
        label = '쉬움';
        break;
      case MissionDifficulty.medium:
        color = Colors.orange;
        label = '보통';
        break;
      case MissionDifficulty.hard:
        color = MGColors.error;
        label = '어려움';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
