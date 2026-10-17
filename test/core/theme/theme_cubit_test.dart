import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_offline_app/core/theme/theme_cubit.dart';
import 'package:weather_offline_app/core/theme/theme_state.dart';

void main() {
  group('ThemeCubit', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('initial state defaults to system theme mode', () {
      final cubit = ThemeCubit(prefs: prefs);
      expect(cubit.state.themeMode, ThemeMode.system);
      cubit.close();
    });

    blocTest<ThemeCubit, ThemeState>(
      'setThemeMode(dark) emits dark mode and persists',
      build: () => ThemeCubit(prefs: prefs),
      act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
      expect: () => [const ThemeState(themeMode: ThemeMode.dark)],
      verify: (_) {
        expect(prefs.getString('theme_preference'), 'dark');
      },
    );

    blocTest<ThemeCubit, ThemeState>(
      'setThemeMode(light) emits light mode and persists',
      build: () => ThemeCubit(prefs: prefs),
      act: (cubit) => cubit.setThemeMode(ThemeMode.light),
      expect: () => [const ThemeState(themeMode: ThemeMode.light)],
      verify: (_) {
        expect(prefs.getString('theme_preference'), 'light');
      },
    );

    test('loads persisted dark theme on construction', () async {
      await prefs.setString('theme_preference', 'dark');

      final cubit = ThemeCubit(prefs: prefs);
      await Future.delayed(Duration.zero);
      expect(cubit.state.themeMode, ThemeMode.dark);
      cubit.close();
    });

    test('loads persisted light theme on construction', () async {
      await prefs.setString('theme_preference', 'light');

      final cubit = ThemeCubit(prefs: prefs);
      await Future.delayed(Duration.zero);
      expect(cubit.state.themeMode, ThemeMode.light);
      cubit.close();
    });

    test('defaults to system for unknown persisted value', () async {
      await prefs.setString('theme_preference', 'unknown');

      final cubit = ThemeCubit(prefs: prefs);
      await Future.delayed(Duration.zero);
      expect(cubit.state.themeMode, ThemeMode.system);
      cubit.close();
    });
  });

  group('ThemeState', () {
    test('isSystem getter works correctly', () {
      const state = ThemeState(themeMode: ThemeMode.system);
      expect(state.isSystem, isTrue);

      const darkState = ThemeState(themeMode: ThemeMode.dark);
      expect(darkState.isSystem, isFalse);
    });

    test('equatable props work correctly', () {
      const state1 = ThemeState(themeMode: ThemeMode.dark);
      const state2 = ThemeState(themeMode: ThemeMode.dark);
      const state3 = ThemeState(themeMode: ThemeMode.light);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });
}
