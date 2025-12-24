import 'package:flutter/material.dart';

class CharacterData {
  final String id;
  final String name;
  final Color color;
  final int cost;

  const CharacterData({
    required this.id,
    required this.name,
    required this.color,
    required this.cost,
  });

  static const List<CharacterData> defaultCharacters = [
    CharacterData(
      id: 'blue',
      name: 'Original Blue',
      color: Colors.blue,
      cost: 0,
    ),
    CharacterData(id: 'red', name: 'Speedy Red', color: Colors.red, cost: 100),
    CharacterData(
      id: 'green',
      name: 'Lucky Green',
      color: Colors.green,
      cost: 250,
    ),
    CharacterData(
      id: 'yellow',
      name: 'Golden Sun',
      color: Colors.amber,
      cost: 500,
    ),
    CharacterData(
      id: 'purple',
      name: 'Void Walker',
      color: Colors.purple,
      cost: 1000,
    ),
  ];

  static CharacterData getById(String id) {
    return defaultCharacters.firstWhere(
      (c) => c.id == id,
      orElse: () => defaultCharacters.first,
    );
  }
}
