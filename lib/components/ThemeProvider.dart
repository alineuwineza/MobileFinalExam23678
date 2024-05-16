import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  late ThemeData _currentTheme;
  final String _themeKey = "theme";
  late SharedPreferences _prefs;

  ThemeNotifier() {
    _currentTheme = tealTheme; // Set teal as the default theme
    _loadFromPrefs();
  }

  ThemeData get currentTheme => _currentTheme;

  Future<void> toggleTheme() async {
    _currentTheme =
        (_currentTheme == tealTheme) ? ThemeData.light() : tealTheme;
    await _saveToPrefs(_currentTheme == tealTheme ? 'teal' : 'light');
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPrefs() async {
    await _initPrefs();
    final themeStr = _prefs.getString(_themeKey) ?? 'teal';
    _currentTheme = (themeStr == 'light') ? ThemeData.light() : tealTheme;
    notifyListeners();
  }

  Future<void> _saveToPrefs(String themeStr) async {
    await _initPrefs();
    await _prefs.setString(_themeKey, themeStr);
  }
}

final tealTheme = ThemeData(
  primaryColor: Colors.teal,
  hintColor: Colors.white,
  scaffoldBackgroundColor: Colors.teal,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.teal,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.black,
  ),
);
