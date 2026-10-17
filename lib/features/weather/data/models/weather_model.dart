import 'package:weather_offline_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_offline_app/features/weather/domain/entities/weather_entity.dart';

class WeatherModel {
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
  final List<ForecastDayModel> forecastDays;

  const WeatherModel({
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

  /// Parses a WeatherAPI.com forecast.json (or current.json) response.
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>;
    final conditionData = current['condition'] as Map<String, dynamic>;

    final forecastDays = <ForecastDayModel>[];
    final forecast = json['forecast'] as Map<String, dynamic>?;
    if (forecast != null) {
      final dayList = forecast['forecastday'] as List<dynamic>? ?? [];
      for (final day in dayList) {
        forecastDays.add(
          ForecastDayModel.fromJson(day as Map<String, dynamic>),
        );
      }
    }

    return WeatherModel(
      city: location['name'] as String? ?? '',
      region: location['region'] as String? ?? '',
      country: location['country'] as String? ?? '',
      temperatureC: (current['temp_c'] as num?)?.toDouble() ?? 0,
      temperatureF: (current['temp_f'] as num?)?.toDouble() ?? 0,
      feelsLikeC: (current['feelslike_c'] as num?)?.toDouble() ?? 0,
      feelsLikeF: (current['feelslike_f'] as num?)?.toDouble() ?? 0,
      condition: conditionData['text'] as String? ?? '',
      conditionIcon: 'https:${conditionData['icon'] as String? ?? ''}',
      conditionCode: (conditionData['code'] as num?)?.toInt() ?? 0,
      humidity: (current['humidity'] as num?)?.toInt() ?? 0,
      windKph: (current['wind_kph'] as num?)?.toDouble() ?? 0,
      windMph: (current['wind_mph'] as num?)?.toDouble() ?? 0,
      windDirection: current['wind_dir'] as String? ?? '',
      pressureMb: (current['pressure_mb'] as num?)?.toDouble() ?? 0,
      pressureIn: (current['pressure_in'] as num?)?.toDouble() ?? 0,
      visibilityKm: (current['vis_km'] as num?)?.toDouble() ?? 0,
      visibilityMiles: (current['vis_miles'] as num?)?.toDouble() ?? 0,
      uvIndex: (current['uv'] as num?)?.toDouble() ?? 0,
      cloudCover: (current['cloud'] as num?)?.toInt() ?? 0,
      lastUpdated:
          DateTime.tryParse(current['last_updated'] as String? ?? '') ??
          DateTime.now(),
      forecastDays: forecastDays,
    );
  }

  /// Restores from the flat cache format stored in SharedPreferences.
  factory WeatherModel.fromCacheJson(Map<String, dynamic> json) {
    final forecastDays = <ForecastDayModel>[];
    final dayList = json['forecastDays'] as List<dynamic>? ?? [];
    for (final day in dayList) {
      forecastDays.add(
        ForecastDayModel.fromCacheJson(day as Map<String, dynamic>),
      );
    }

    return WeatherModel(
      city: json['city'] as String? ?? '',
      region: json['region'] as String? ?? '',
      country: json['country'] as String? ?? '',
      temperatureC: (json['temperatureC'] as num?)?.toDouble() ?? 0,
      temperatureF: (json['temperatureF'] as num?)?.toDouble() ?? 0,
      feelsLikeC: (json['feelsLikeC'] as num?)?.toDouble() ?? 0,
      feelsLikeF: (json['feelsLikeF'] as num?)?.toDouble() ?? 0,
      condition: json['condition'] as String? ?? '',
      conditionIcon: json['conditionIcon'] as String? ?? '',
      conditionCode: (json['conditionCode'] as num?)?.toInt() ?? 0,
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      windKph: (json['windKph'] as num?)?.toDouble() ?? 0,
      windMph: (json['windMph'] as num?)?.toDouble() ?? 0,
      windDirection: json['windDirection'] as String? ?? '',
      pressureMb: (json['pressureMb'] as num?)?.toDouble() ?? 0,
      pressureIn: (json['pressureIn'] as num?)?.toDouble() ?? 0,
      visibilityKm: (json['visibilityKm'] as num?)?.toDouble() ?? 0,
      visibilityMiles: (json['visibilityMiles'] as num?)?.toDouble() ?? 0,
      uvIndex: (json['uvIndex'] as num?)?.toDouble() ?? 0,
      cloudCover: (json['cloudCover'] as num?)?.toInt() ?? 0,
      lastUpdated:
          DateTime.tryParse(json['lastUpdated'] as String? ?? '') ??
          DateTime.now(),
      forecastDays: forecastDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'region': region,
      'country': country,
      'temperatureC': temperatureC,
      'temperatureF': temperatureF,
      'feelsLikeC': feelsLikeC,
      'feelsLikeF': feelsLikeF,
      'condition': condition,
      'conditionIcon': conditionIcon,
      'conditionCode': conditionCode,
      'humidity': humidity,
      'windKph': windKph,
      'windMph': windMph,
      'windDirection': windDirection,
      'pressureMb': pressureMb,
      'pressureIn': pressureIn,
      'visibilityKm': visibilityKm,
      'visibilityMiles': visibilityMiles,
      'uvIndex': uvIndex,
      'cloudCover': cloudCover,
      'lastUpdated': lastUpdated.toIso8601String(),
      'forecastDays': forecastDays.map((d) => d.toJson()).toList(),
    };
  }

  WeatherEntity toEntity() {
    return WeatherEntity(
      city: city,
      region: region,
      country: country,
      temperatureC: temperatureC,
      temperatureF: temperatureF,
      feelsLikeC: feelsLikeC,
      feelsLikeF: feelsLikeF,
      condition: condition,
      conditionIcon: conditionIcon,
      conditionCode: conditionCode,
      humidity: humidity,
      windKph: windKph,
      windMph: windMph,
      windDirection: windDirection,
      pressureMb: pressureMb,
      pressureIn: pressureIn,
      visibilityKm: visibilityKm,
      visibilityMiles: visibilityMiles,
      uvIndex: uvIndex,
      cloudCover: cloudCover,
      lastUpdated: lastUpdated,
      forecastDays: forecastDays.map((d) => d.toEntity()).toList(),
    );
  }
}
