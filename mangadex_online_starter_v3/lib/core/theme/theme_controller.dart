import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const _kNeonKey = 'appearance_neon';
  bool _neon = false; // gold by default

  bool get neon => _neon;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _neon = prefs.getBool(_kNeonKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleNeon(bool value) async {
    _neon = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNeonKey, _neon);
  }
}