import 'package:diaries/providers/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  static const String _themeKey = 'isDarkTheme';

  //set theme to light mode initially
  ThemeData _themeData = lightmode;

  ThemeChanger() {
    _loadThemePreference(); // Load the saved theme when the class is instantiated
  }

  // ThemeChanger(this._themeData);
  // getter method to access the them in other parts of the app
  ThemeData get themeData => _themeData;

  // getter method that returns the current state of the theme (light or dark)
  bool get isDarkmode => _themeData == darkmode;

  // setter to set the new theme
  set themeData(ThemeData theme) {
    if (_themeData != theme) {
      // Only update if the theme actually changes
      _themeData = theme;
      _saveThemePreference(theme == darkmode); // Save the new preference
      notifyListeners();
    }
  }

  // used to toggle between light and dark mode
  void toggleTheme() {
    if (_themeData == lightmode) {
      themeData = darkmode;
      print("Working on this end");
    } else {
      themeData = lightmode;
      print("Working on this end2");
    }
  }

  // Saves the current theme preference
  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  // Loads the saved theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark =
        prefs.getBool(_themeKey) ??
        false; // Default to light if no preference saved

    if (isDark) {
      _themeData = darkmode;
    } else {
      _themeData = lightmode;
    }
    notifyListeners(); // Notify listeners after loading the initial theme
  }
}
