import 'package:mg_common_game/core/assets/asset_types.dart';

/// Spine 통합 플래그. `--dart-define=SPINE_ENABLED=true`로 활성화.
const kSpineEnabled = bool.fromEnvironment(
  'SPINE_ENABLED',
  defaultValue: false,
);

// ── Blue Hero ────────────────────────────────────────────────

const kBlueHeroMeta = SpineAssetMeta(
  key: 'blue_hero',
  path: 'spine/characters/blue_hero',
  atlasPath: 'assets/spine/characters/blue_hero/blue_hero.atlas',
  skeletonPath: 'assets/spine/characters/blue_hero/blue_hero.json',
  animations: ['idle', 'jump', 'fall', 'run'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);

// ── Red Hero ─────────────────────────────────────────────────

const kRedHeroMeta = SpineAssetMeta(
  key: 'red_hero',
  path: 'spine/characters/red_hero',
  atlasPath: 'assets/spine/characters/red_hero/red_hero.atlas',
  skeletonPath: 'assets/spine/characters/red_hero/red_hero.json',
  animations: ['idle', 'jump', 'fall', 'run'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);

// ── Green Hero ───────────────────────────────────────────────

const kGreenHeroMeta = SpineAssetMeta(
  key: 'green_hero',
  path: 'spine/characters/green_hero',
  atlasPath: 'assets/spine/characters/green_hero/green_hero.atlas',
  skeletonPath: 'assets/spine/characters/green_hero/green_hero.json',
  animations: ['idle', 'jump', 'fall', 'run'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);

// ── Yellow Hero ──────────────────────────────────────────────

const kYellowHeroMeta = SpineAssetMeta(
  key: 'yellow_hero',
  path: 'spine/characters/yellow_hero',
  atlasPath: 'assets/spine/characters/yellow_hero/yellow_hero.atlas',
  skeletonPath: 'assets/spine/characters/yellow_hero/yellow_hero.json',
  animations: ['idle', 'jump', 'fall', 'run'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);

// ── Purple Hero ──────────────────────────────────────────────

const kPurpleHeroMeta = SpineAssetMeta(
  key: 'purple_hero',
  path: 'spine/characters/purple_hero',
  atlasPath: 'assets/spine/characters/purple_hero/purple_hero.atlas',
  skeletonPath: 'assets/spine/characters/purple_hero/purple_hero.json',
  animations: ['idle', 'jump', 'fall', 'run'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);
