// Balancing configuration for MG-0007: Pixel Farm Idle RPG
// TODO: Implement when balancing system is available

const Map<String, dynamic> kDefaultBalancingConfig = {
  'gameId': 'mg-0007',
  'version': 1,
  'currencies': [
    {'id': 'gold', 'baseEarnRate': 8.0},
    {'id': 'gems', 'baseEarnRate': 0.5},
  ],
  'xpCurve': {'baseXp': 100, 'maxLevel': 100},
  'difficultyScaling': {'scalingFactor': 0.1},
  'customParams': {
    'reward_multiplier': 1.0,
  },
};
