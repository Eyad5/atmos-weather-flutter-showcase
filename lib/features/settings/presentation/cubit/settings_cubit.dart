import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_offline_app/core/constants/app_constants.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;

  SettingsCubit({required SharedPreferences prefs})
    : _prefs = prefs,
      super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final tempUnit = _prefs.getString(AppConstants.temperatureUnitKey);
    final windUnit = _prefs.getString(AppConstants.windUnitKey);

    emit(
      SettingsState(
        temperatureUnit: tempUnit == 'fahrenheit'
            ? TemperatureUnit.fahrenheit
            : TemperatureUnit.celsius,
        windSpeedUnit: windUnit == 'mph'
            ? WindSpeedUnit.mph
            : WindSpeedUnit.kmh,
      ),
    );
  }

  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    emit(state.copyWith(temperatureUnit: unit));
    await _prefs.setString(
      AppConstants.temperatureUnitKey,
      unit == TemperatureUnit.fahrenheit ? 'fahrenheit' : 'celsius',
    );
  }

  Future<void> setWindSpeedUnit(WindSpeedUnit unit) async {
    emit(state.copyWith(windSpeedUnit: unit));
    await _prefs.setString(
      AppConstants.windUnitKey,
      unit == WindSpeedUnit.mph ? 'mph' : 'kmh',
    );
  }
}
