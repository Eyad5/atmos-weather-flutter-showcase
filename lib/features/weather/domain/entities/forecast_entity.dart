import 'package:equatable/equatable.dart';

class ForecastDayEntity extends Equatable {
  final DateTime date;
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final double avgTempC;
  final double avgTempF;
  final double maxWindKph;
  final double maxWindMph;
  final double totalPrecipMm;
  final int avgHumidity;
  final int dailyChanceOfRain;
  final String condition;
  final String conditionIcon;
  final double uvIndex;
  final List<HourlyForecastEntity> hours;

  const ForecastDayEntity({
    required this.date,
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.maxWindKph,
    required this.maxWindMph,
    required this.totalPrecipMm,
    required this.avgHumidity,
    required this.dailyChanceOfRain,
    required this.condition,
    required this.conditionIcon,
    required this.uvIndex,
    this.hours = const [],
  });

  @override
  List<Object?> get props => [
    date,
    maxTempC,
    maxTempF,
    minTempC,
    minTempF,
    avgTempC,
    avgTempF,
    maxWindKph,
    maxWindMph,
    totalPrecipMm,
    avgHumidity,
    dailyChanceOfRain,
    condition,
    conditionIcon,
    uvIndex,
    hours,
  ];
}

class HourlyForecastEntity extends Equatable {
  final DateTime time;
  final double tempC;
  final double tempF;
  final String condition;
  final String conditionIcon;
  final double windKph;
  final double windMph;
  final int humidity;
  final int chanceOfRain;
  final double feelsLikeC;
  final double feelsLikeF;
  final double uvIndex;
  final int cloud;

  const HourlyForecastEntity({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.conditionIcon,
    required this.windKph,
    required this.windMph,
    required this.humidity,
    required this.chanceOfRain,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.uvIndex,
    required this.cloud,
  });

  @override
  List<Object?> get props => [
    time,
    tempC,
    tempF,
    condition,
    conditionIcon,
    windKph,
    windMph,
    humidity,
    chanceOfRain,
    feelsLikeC,
    feelsLikeF,
    uvIndex,
    cloud,
  ];
}
