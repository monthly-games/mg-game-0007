import 'package:mg_common_game/systems/balancing/balancing.dart';

/// Default balancing configuration for MG-0007: Pixel Farm Idle RPG.
///
/// Placeholder values — override via RemoteConfig using
/// [BalancingManager.loadFromRemote] in production.
const kDefaultBalancingConfig = BalancingConfig(
  gameId: 'mg-0007',
  version: 1,
  currencies: [
    CurrencyConfig(id: 'gold', baseEarnRate: 8.0),
    CurrencyConfig(
      id: 'gems',
      baseEarnRate: 0.5,
    ),
  ],
  xpCurve: XpCurveConfig(baseXp: 100, maxLevel: 100),
  difficultyScaling: DifficultyScalingConfig(scalingFactor: 0.1),
  customParams: {
    'reward_multiplier': 1.0,
  },
);
