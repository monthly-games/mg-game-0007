import 'package:flutter/material.dart';

class GameTheme {
  final String id;
  final String name;
  final String backgroundAsset;
  final Color platformColor;
  final Color skyColor;

  const GameTheme({
    required this.id,
    required this.name,
    required this.backgroundAsset,
    required this.platformColor,
    this.skyColor = Colors.blue,
  });

  static const List<GameTheme> defaultThemes = [
    GameTheme(
      id: 'farm',
      name: 'Sunny Farm',
      backgroundAsset: 'bg_farm.png',
      platformColor: Color(0xFF8B4513), // Saddle Brown
      skyColor: Color(0xFF87CEEB),
    ),
    GameTheme(
      id: 'forest',
      name: 'Mystic Forest',
      backgroundAsset: 'bg_forest.png',
      platformColor: Color(0xFF2F4F4F), // Dark Slate Gray
      skyColor: Color(0xFF191970), // Midnight Blue
    ),
    GameTheme(
      id: 'sunset',
      name: 'Golden Sunset',
      backgroundAsset: 'bg_sunset.png',
      platformColor: Color(0xFF8B0000), // Dark Red
      skyColor: Color(0xFFFF4500), // Orange Red
    ),
  ];

  static GameTheme getById(String id) {
    return defaultThemes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => defaultThemes[0],
    );
  }
}
