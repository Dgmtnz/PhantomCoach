import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phantom_coach/config/app_config.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _useMetricSystem = true;
  ThemeMode _themeMode = ThemeMode.light;
  bool _showCalories = true;
  int _restTimerSoundLevel = 7;
  
  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get useMetricSystem => _useMetricSystem;
  ThemeMode get themeMode => _themeMode;
  bool get showCalories => _showCalories;
  int get restTimerSoundLevel => _restTimerSoundLevel;
  
  // Constructor
  SettingsProvider() {
    _loadSettings();
  }
  
  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _isDarkMode = prefs.getBool(AppConfig.themeKey) ?? false;
      _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
      _useMetricSystem = prefs.getBool('use_metric_system') ?? true;
      _showCalories = prefs.getBool('show_calories') ?? true;
      _restTimerSoundLevel = prefs.getInt('rest_timer_sound_level') ?? 7;
      
      notifyListeners();
    } catch (e) {
      // Handle error - continue with defaults
      print('Error loading settings: $e');
    }
  }
  
  // Toggle theme mode
  Future<void> toggleThemeMode() async {
    try {
      _isDarkMode = !_isDarkMode;
      _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConfig.themeKey, _isDarkMode);
      
      notifyListeners();
    } catch (e) {
      print('Error saving theme mode: $e');
    }
  }
  
  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode = mode;
      _isDarkMode = mode == ThemeMode.dark;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConfig.themeKey, _isDarkMode);
      
      notifyListeners();
    } catch (e) {
      print('Error saving theme mode: $e');
    }
  }
  
  // Toggle metric system
  Future<void> toggleMetricSystem() async {
    try {
      _useMetricSystem = !_useMetricSystem;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('use_metric_system', _useMetricSystem);
      
      notifyListeners();
    } catch (e) {
      print('Error saving metric system setting: $e');
    }
  }
  
  // Set metric system
  Future<void> setMetricSystem(bool useMetric) async {
    try {
      _useMetricSystem = useMetric;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('use_metric_system', _useMetricSystem);
      
      notifyListeners();
    } catch (e) {
      print('Error saving metric system setting: $e');
    }
  }
  
  // Toggle calories display
  Future<void> toggleCaloriesDisplay() async {
    try {
      _showCalories = !_showCalories;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('show_calories', _showCalories);
      
      notifyListeners();
    } catch (e) {
      print('Error saving calories display setting: $e');
    }
  }
  
  // Set calories display
  Future<void> setCaloriesDisplay(bool show) async {
    try {
      _showCalories = show;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('show_calories', _showCalories);
      
      notifyListeners();
    } catch (e) {
      print('Error saving calories display setting: $e');
    }
  }
  
  // Set rest timer sound level
  Future<void> setRestTimerSoundLevel(int level) async {
    try {
      if (level < 0) level = 0;
      if (level > 10) level = 10;
      
      _restTimerSoundLevel = level;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('rest_timer_sound_level', _restTimerSoundLevel);
      
      notifyListeners();
    } catch (e) {
      print('Error saving rest timer sound level: $e');
    }
  }
  
  // Convenience method to convert weight between metric and imperial
  double convertWeight(double weight, {bool toMetric = true}) {
    if (toMetric) {
      // Convert lbs to kg
      return weight * 0.45359237;
    } else {
      // Convert kg to lbs
      return weight * 2.2046226218;
    }
  }
  
  // Convenience method to convert height between metric and imperial
  double convertHeight(double height, {bool toMetric = true}) {
    if (toMetric) {
      // Convert inches to cm
      return height * 2.54;
    } else {
      // Convert cm to inches
      return height * 0.393701;
    }
  }
  
  // Reset all settings to default
  Future<void> resetSettings() async {
    try {
      _isDarkMode = false;
      _themeMode = ThemeMode.light;
      _useMetricSystem = true;
      _showCalories = true;
      _restTimerSoundLevel = 7;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConfig.themeKey, _isDarkMode);
      await prefs.setBool('use_metric_system', _useMetricSystem);
      await prefs.setBool('show_calories', _showCalories);
      await prefs.setInt('rest_timer_sound_level', _restTimerSoundLevel);
      
      notifyListeners();
    } catch (e) {
      print('Error resetting settings: $e');
    }
  }
} 