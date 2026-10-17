import 'package:equatable/equatable.dart';

enum TemperatureUnit { celsius, fahrenheit }

enum WindSpeedUnit { kmh, mph }

class SettingsState extends Equatable {
  final TemperatureUnit temperatureUnit;
  final WindSpeedUnit windSpeedUnit;

  const SettingsState({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windSpeedUnit = WindSpeedUnit.kmh,
  });

  bool get isCelsius => temperatureUnit == TemperatureUnit.celsius;
  bool get isKmh => windSpeedUnit == WindSpeedUnit.kmh;

  String formatTemperature(double tempC, double tempF) {
    final value = isCelsius ? tempC : tempF;
    final unit = isCelsius ? 'C' : 'F';
    return '${value.toStringAsFixed(0)}\u00B0$unit';
  }

  String formatWind(double kph, double mph) {
    if (isKmh) return '${kph.toStringAsFixed(1)} km/h';
    return '${mph.toStringAsFixed(1)} mph';
  }

  SettingsState copyWith({
    TemperatureUnit? temperatureUnit,
    WindSpeedUnit? windSpeedUnit,
  }) {
    return SettingsState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
    );
  }

  @override
  List<Object?> get props => [temperatureUnit, windSpeedUnit];
}
