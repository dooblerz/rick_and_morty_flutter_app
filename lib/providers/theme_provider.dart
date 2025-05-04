import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return _isDarkMode
        ? ThemeData.dark().copyWith(useMaterial3: true)
        : ThemeData.light().copyWith(useMaterial3: true);
  }
}
