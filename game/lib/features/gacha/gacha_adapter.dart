/// 가챠 시스템 어댑터 - MG-0007 Pixel Farm Tycoon
library;

import 'package:flutter/foundation.dart';
import 'package:mg_common_game/systems/gacha/gacha_pool.dart';
import 'package:mg_common_game/systems/gacha/gacha_manager.dart';

/// 게임 내 Seed 모델
class Seed {
  final String id;
  final String name;
  final GachaRarity rarity;
  final Map<String, dynamic> stats;

  const Seed({
    required this.id,
    required this.name,
    required this.rarity,
    this.stats = const {},
  });
}

/// Pixel Farm Tycoon 가챠 어댑터
class SeedGachaAdapter extends ChangeNotifier {
  final GachaManager _gachaManager = GachaManager(
    pityConfig: const PityConfig(
      softPityStart: 70,
      hardPity: 80,
      softPityBonus: 6.0,
    ),
    multiPullGuarantee: const MultiPullGuarantee(
      minRarity: GachaRarity.rare,
    ),
  );

  static const String _poolId = 'farm_pool';

  SeedGachaAdapter() {
    _initPool();
  }

  void _initPool() {
    final pool = GachaPool(
      id: _poolId,
      nameKr: 'Pixel Farm Tycoon 가챠',
      items: _generateItems(),
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 365)),
    );
    _gachaManager.registerPool(pool);
  }

  List<GachaItem> _generateItems() {
    return [
      // UR (0.6%)
      GachaItem(id: 'ur_farm_001', nameKr: '전설의 Seed', rarity: GachaRarity.ultraRare),
      GachaItem(id: 'ur_farm_002', nameKr: '신화의 Seed', rarity: GachaRarity.ultraRare),
      // SSR (2.4%)
      GachaItem(id: 'ssr_farm_001', nameKr: '영웅의 Seed', rarity: GachaRarity.superRare),
      GachaItem(id: 'ssr_farm_002', nameKr: '고대의 Seed', rarity: GachaRarity.superRare),
      GachaItem(id: 'ssr_farm_003', nameKr: '황금의 Seed', rarity: GachaRarity.superRare),
      // SR (12%)
      GachaItem(id: 'sr_farm_001', nameKr: '희귀한 Seed A', rarity: GachaRarity.superRare),
      GachaItem(id: 'sr_farm_002', nameKr: '희귀한 Seed B', rarity: GachaRarity.superRare),
      GachaItem(id: 'sr_farm_003', nameKr: '희귀한 Seed C', rarity: GachaRarity.superRare),
      GachaItem(id: 'sr_farm_004', nameKr: '희귀한 Seed D', rarity: GachaRarity.superRare),
      // R (35%)
      GachaItem(id: 'r_farm_001', nameKr: '우수한 Seed A', rarity: GachaRarity.rare),
      GachaItem(id: 'r_farm_002', nameKr: '우수한 Seed B', rarity: GachaRarity.rare),
      GachaItem(id: 'r_farm_003', nameKr: '우수한 Seed C', rarity: GachaRarity.rare),
      GachaItem(id: 'r_farm_004', nameKr: '우수한 Seed D', rarity: GachaRarity.rare),
      GachaItem(id: 'r_farm_005', nameKr: '우수한 Seed E', rarity: GachaRarity.rare),
      // N (50%)
      GachaItem(id: 'n_farm_001', nameKr: '일반 Seed A', rarity: GachaRarity.normal),
      GachaItem(id: 'n_farm_002', nameKr: '일반 Seed B', rarity: GachaRarity.normal),
      GachaItem(id: 'n_farm_003', nameKr: '일반 Seed C', rarity: GachaRarity.normal),
      GachaItem(id: 'n_farm_004', nameKr: '일반 Seed D', rarity: GachaRarity.normal),
      GachaItem(id: 'n_farm_005', nameKr: '일반 Seed E', rarity: GachaRarity.normal),
      GachaItem(id: 'n_farm_006', nameKr: '일반 Seed F', rarity: GachaRarity.normal),
    ];
  }

  /// 단일 뽑기
  Seed? pullSingle() {
    final result = _gachaManager.pull(_poolId);
    if (result == null) return null;
    notifyListeners();
    return _convertToItem(result.item);
  }

  /// 10연차
  List<Seed> pullTen() {
    final results = _gachaManager.multiPull(_poolId, count: 10);
    notifyListeners();
    return results.map((r) => _convertToItem(r.item)).toList();
  }

  Seed _convertToItem(GachaItem item) {
    return Seed(
      id: item.id,
      name: item.nameKr,
      rarity: item.rarity,
    );
  }

  /// 천장까지 남은 횟수
  int get pullsUntilPity => _gachaManager.remainingPity(_poolId);

  /// 총 뽑기 횟수
  int get totalPulls => _gachaManager.getPityState(_poolId)?.totalPulls ?? 0;

  /// 통계
  GachaStats get stats => _gachaManager.getStats(_poolId);

  Map<String, dynamic> toJson() => _gachaManager.toJson();
  void loadFromJson(Map<String, dynamic> json) {
    _gachaManager.loadFromJson(json);
    notifyListeners();
  }
}
