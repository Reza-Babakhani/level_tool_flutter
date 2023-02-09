import 'package:flutter/material.dart';
import '../colors/my_palette.dart';
import 'storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primaryColor: const Color(0xFF212121),
    //brightness: Brightness.dark,
    dividerColor: Colors.black12,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: MyPalette.firstPalette)
        .copyWith(
            background: const Color(0xFF212121), brightness: Brightness.dark),
  );

  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    //brightness: Brightness.light,
    dividerColor: Colors.white54,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: MyPalette.firstPalette)
        .copyWith(
            background: const Color(0xFFE5E5E5), brightness: Brightness.light),
  );

  ThemeData? _themeData;
  bool? _isDarkMode;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
        _isDarkMode = false;
      } else {
        _themeData = darkTheme;
        _isDarkMode = true;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    _isDarkMode = true;
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    _isDarkMode = false;

    notifyListeners();
  }

  ThemeData getTheme() {
    return _themeData ?? lightTheme;
  }

  bool isDarkMode() {
    return _isDarkMode ?? false;
  }
}
