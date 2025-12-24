import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'character_data.dart';

class CharacterManager extends ChangeNotifier {
  String _selectedCharacterId = 'blue';
  final List<String> _unlockedCharacterIds = ['blue'];

  String get selectedCharacterId => _selectedCharacterId;
  List<String> get unlockedCharacterIds => _unlockedCharacterIds;

  CharacterData get selectedCharacter =>
      CharacterData.getById(_selectedCharacterId);

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCharacterId = prefs.getString('selected_character') ?? 'blue';
    final unlocked = prefs.getStringList('unlocked_characters');
    if (unlocked != null) {
      _unlockedCharacterIds.clear();
      _unlockedCharacterIds.addAll(unlocked);
    }
    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_character', _selectedCharacterId);
    await prefs.setStringList('unlocked_characters', _unlockedCharacterIds);
  }

  void selectCharacter(String id) {
    if (_unlockedCharacterIds.contains(id)) {
      _selectedCharacterId = id;
      saveData();
      notifyListeners();
    }
  }

  bool unlockCharacter(String id, int currentCoins) {
    if (_unlockedCharacterIds.contains(id)) return true;

    final character = CharacterData.getById(id);
    if (currentCoins >= character.cost) {
      _unlockedCharacterIds.add(id);
      saveData();
      notifyListeners();
      return true;
    }
    return false;
  }

  bool isUnlocked(String id) {
    return _unlockedCharacterIds.contains(id);
  }
}
