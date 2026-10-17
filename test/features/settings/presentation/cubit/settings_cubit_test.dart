import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_state.dart';

void main() {
  group('SettingsCubit', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('initial state has celsius and kmh defaults', () {
      final cubit = SettingsCubit(prefs: prefs);
      expect(cubit.state.temperatureUnit, TemperatureUnit.celsius);
      expect(cubit.state.windSpeedUnit, WindSpeedUnit.kmh);
      cubit.close();
    });

    blocTest<SettingsCubit, SettingsState>(
      'setTemperatureUnit emits new state and persists',
      build: () => SettingsCubit(prefs: prefs),
      act: (cubit) => cubit.setTemperatureUnit(TemperatureUnit.fahrenheit),
      expect: () => [
        isA<SettingsState>().having(
          (s) => s.temperatureUnit,
          'temperatureUnit',
          TemperatureUnit.fahrenheit,
        ),
      ],
      verify: (_) {
        expect(prefs.getString('temperature_unit'), 'fahrenheit');
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'setWindSpeedUnit emits new state and persists',
      build: () => SettingsCubit(prefs: prefs),
      act: (cubit) => cubit.setWindSpeedUnit(WindSpeedUnit.mph),
      expect: () => [
        isA<SettingsState>().having(
          (s) => s.windSpeedUnit,
          'windSpeedUnit',
          WindSpeedUnit.mph,
        ),
      ],
      verify: (_) {
        expect(prefs.getString('wind_unit'), 'mph');
      },
    );

    test('loads persisted values on construction', () async {
      await prefs.setString('temperature_unit', 'fahrenheit');
      await prefs.setString('wind_unit', 'mph');

      final cubit = SettingsCubit(prefs: prefs);
      // _loadSettings runs in constructor so state is already updated
      await Future.delayed(Duration.zero);
      expect(cubit.state.temperatureUnit, TemperatureUnit.fahrenheit);
      expect(cubit.state.windSpeedUnit, WindSpeedUnit.mph);
      cubit.close();
    });
  });

  group('SettingsState', () {
    test('formatTemperature shows celsius', () {
      const state = SettingsState();
      expect(state.formatTemperature(25.0, 77.0), '25\u00B0C');
    });

    test('formatTemperature shows fahrenheit', () {
      const state = SettingsState(temperatureUnit: TemperatureUnit.fahrenheit);
      expect(state.formatTemperature(25.0, 77.0), '77\u00B0F');
    });

    test('formatWind shows km/h', () {
      const state = SettingsState();
      expect(state.formatWind(20.0, 12.4), '20.0 km/h');
    });

    test('formatWind shows mph', () {
      const state = SettingsState(windSpeedUnit: WindSpeedUnit.mph);
      expect(state.formatWind(20.0, 12.4), '12.4 mph');
    });

    test('copyWith works correctly', () {
      const state = SettingsState();
      final copied = state.copyWith(
        temperatureUnit: TemperatureUnit.fahrenheit,
      );
      expect(copied.temperatureUnit, TemperatureUnit.fahrenheit);
      expect(copied.windSpeedUnit, WindSpeedUnit.kmh);
    });
  });
}
