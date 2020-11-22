import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

const PREFS_THEME = "preferencesTheme";
const PREFS_DEFAULT_SORT_ALPHA = "preferencesDefSortAlpha";

const PREFS_THEME_AUTO = 0;
const PREFS_THEME_DARK = 1;
const PREFS_THEME_LIGHT = 2;

class PreferencesProvider extends ChangeNotifier {
  Box _box;

  int get theme => _box.get(PREFS_THEME, defaultValue: PREFS_THEME_AUTO);

  bool get sortByAlpha =>
      _box.get(PREFS_DEFAULT_SORT_ALPHA, defaultValue: false);

  /// Initialize This application's Hive Database directory, and open the corresponding box.
  Future<PreferencesProvider> initialize() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Hive.init(appDocDirectory.path + 'FlutterDB');
    _box = await Hive.openBox("preferencesBox");
    return this;
  }

  void putSetting(String key, dynamic value) {
    _box.put(key, value);
    notifyListeners();
  }
}
