import 'package:shared_preferences/shared_preferences.dart';

class HighScoreManager {
  static const String _prefix = 'highscore_';

  static Future<int> getHighScore(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_prefix$mode') ?? 0;
  }

  static Future<bool> saveHighScore(String modeName, int newScore) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'highscore_$modeName';
    final currentHighScore = prefs.getInt(key) ?? 0;

    if (newScore > currentHighScore) {
      await prefs.setInt(key, newScore);
      return true;
    }
    return false;
  }

  static Future<void> resetAllHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_prefix)) {
        await prefs.remove(key);
      }
    }
  }
}
