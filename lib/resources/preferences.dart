import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const PREFS_DARK_MODE = "preferencesDarkMode";

class PreferencesProvider extends ChangeNotifier {
  Box _box;

  bool get darkMode => _box.get(PREFS_DARK_MODE, defaultValue: false);

  /// Initialize This application's Hive Database directory, and open the corresponding box.
  Future<PreferencesProvider> initialize() async {
    Hive.init('FlutterDB');
    _box = await Hive.openBox("preferencesBox");
    return this;
  }
  
  void putSetting(String key, dynamic value) {
    _box.put(key, value);
    notifyListeners();
  }
}