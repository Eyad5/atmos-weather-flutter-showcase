import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_offline_app/core/constants/app_constants.dart';
import 'package:weather_offline_app/core/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;

  ThemeCubit({required SharedPreferences prefs})
    : _prefs = prefs,
      super(const ThemeState()) {
    _loadTheme();
  }

  void _loadTheme() {
    final stored = _prefs.getString(AppConstants.themePreferenceKey);
    switch (stored) {
      case 'dark':
        emit(const ThemeState(themeMode: ThemeMode.dark));
      case 'light':
        emit(const ThemeState(themeMode: ThemeMode.light));
      default:
        emit(const ThemeState(themeMode: ThemeMode.system));
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(ThemeState(themeMode: mode));
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(AppConstants.themePreferenceKey, value);
  }
}
