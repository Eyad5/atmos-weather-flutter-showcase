import 'package:equatable/equatable.dart';
import 'package:weather_offline_app/features/weather/domain/entities/forecast_entity.dart';

class WeatherEntity extends Equatable {
  final String city;
  final String region;
  final String country;
  final double temperatureC;
  final double temperatureF;
  final double feelsLikeC;
  final double feelsLikeF;
  final String condition;
  final String conditionIcon;
  final int conditionCode;
  final int humidity;
  final double windKph;
  final double windMph;
  final String windDirection;
  final double pressureMb;
  final double pressureIn;
  final double visibilityKm;
  final double visibilityMiles;
  final double uvIndex;
  final int cloudCover;
  final DateTime lastUpdated;
  final List<ForecastDayEntity> forecastDays;

  const WeatherEntity({
    required this.city,
    required this.region,
    required this.country,
    required this.temperatureC,
    required this.temperatureF,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.condition,
    required this.conditionIcon,
    required this.conditionCode,
    required this.humidity,
    required this.windKph,
    required this.windMph,
    required this.windDirection,
    required this.pressureMb,
    required this.pressureIn,
    required this.visibilityKm,
    required this.visibilityMiles,
    required this.uvIndex,
    required this.cloudCover,
    required this.lastUpdated,
    this.forecastDays = const [],
  });

  @override
  List<Object?> get props => [
    city,
    region,
    country,
    temperatureC,
    temperatureF,
    feelsLikeC,
    feelsLikeF,
    condition,
    conditionIcon,
    conditionCode,
    humidity,
    windKph,
    windMph,
    windDirection,
    pressureMb,
    pressureIn,
    visibilityKm,
    visibilityMiles,
    uvIndex,
    cloudCover,
    lastUpdated,
    forecastDays,
  ];
}
