import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_data.dart';

class ThemeManager extends ChangeNotifier {
  static const String _selectedThemeKey = 'selected_theme_id';

  String _selectedThemeId = 'farm';

  String get selectedThemeId => _selectedThemeId;
  GameTheme get currentTheme => GameTheme.getById(_selectedThemeId);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedThemeId = prefs.getString(_selectedThemeKey) ?? 'farm';
    notifyListeners();
  }

  Future<void> selectTheme(String themeId) async {
    if (_selectedThemeId == themeId) return;

    _selectedThemeId = themeId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedThemeKey, themeId);
    notifyListeners();
  }
}
