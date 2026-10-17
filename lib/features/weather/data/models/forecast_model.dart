import 'package:weather_offline_app/features/weather/domain/entities/forecast_entity.dart';

class ForecastDayModel {
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
  final List<HourlyForecastModel> hours;

  const ForecastDayModel({
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

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) {
    final day = json['day'] as Map<String, dynamic>;
    final conditionData = day['condition'] as Map<String, dynamic>;

    final hourList = json['hour'] as List<dynamic>? ?? [];
    final hours = hourList
        .map((h) => HourlyForecastModel.fromJson(h as Map<String, dynamic>))
        .toList();

    return ForecastDayModel(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      maxTempC: (day['maxtemp_c'] as num?)?.toDouble() ?? 0,
      maxTempF: (day['maxtemp_f'] as num?)?.toDouble() ?? 0,
      minTempC: (day['mintemp_c'] as num?)?.toDouble() ?? 0,
      minTempF: (day['mintemp_f'] as num?)?.toDouble() ?? 0,
      avgTempC: (day['avgtemp_c'] as num?)?.toDouble() ?? 0,
      avgTempF: (day['avgtemp_f'] as num?)?.toDouble() ?? 0,
      maxWindKph: (day['maxwind_kph'] as num?)?.toDouble() ?? 0,
      maxWindMph: (day['maxwind_mph'] as num?)?.toDouble() ?? 0,
      totalPrecipMm: (day['totalprecip_mm'] as num?)?.toDouble() ?? 0,
      avgHumidity: (day['avghumidity'] as num?)?.toInt() ?? 0,
      dailyChanceOfRain: (day['daily_chance_of_rain'] as num?)?.toInt() ?? 0,
      condition: conditionData['text'] as String? ?? '',
      conditionIcon: 'https:${conditionData['icon'] as String? ?? ''}',
      uvIndex: (day['uv'] as num?)?.toDouble() ?? 0,
      hours: hours,
    );
  }

  factory ForecastDayModel.fromCacheJson(Map<String, dynamic> json) {
    final hourList = json['hours'] as List<dynamic>? ?? [];
    final hours = hourList
        .map(
          (h) => HourlyForecastModel.fromCacheJson(h as Map<String, dynamic>),
        )
        .toList();

    return ForecastDayModel(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      maxTempC: (json['maxTempC'] as num?)?.toDouble() ?? 0,
      maxTempF: (json['maxTempF'] as num?)?.toDouble() ?? 0,
      minTempC: (json['minTempC'] as num?)?.toDouble() ?? 0,
      minTempF: (json['minTempF'] as num?)?.toDouble() ?? 0,
      avgTempC: (json['avgTempC'] as num?)?.toDouble() ?? 0,
      avgTempF: (json['avgTempF'] as num?)?.toDouble() ?? 0,
      maxWindKph: (json['maxWindKph'] as num?)?.toDouble() ?? 0,
      maxWindMph: (json['maxWindMph'] as num?)?.toDouble() ?? 0,
      totalPrecipMm: (json['totalPrecipMm'] as num?)?.toDouble() ?? 0,
      avgHumidity: (json['avgHumidity'] as num?)?.toInt() ?? 0,
      dailyChanceOfRain: (json['dailyChanceOfRain'] as num?)?.toInt() ?? 0,
      condition: json['condition'] as String? ?? '',
      conditionIcon: json['conditionIcon'] as String? ?? '',
      uvIndex: (json['uvIndex'] as num?)?.toDouble() ?? 0,
      hours: hours,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'maxTempC': maxTempC,
      'maxTempF': maxTempF,
      'minTempC': minTempC,
      'minTempF': minTempF,
      'avgTempC': avgTempC,
      'avgTempF': avgTempF,
      'maxWindKph': maxWindKph,
      'maxWindMph': maxWindMph,
      'totalPrecipMm': totalPrecipMm,
      'avgHumidity': avgHumidity,
      'dailyChanceOfRain': dailyChanceOfRain,
      'condition': condition,
      'conditionIcon': conditionIcon,
      'uvIndex': uvIndex,
      'hours': hours.map((h) => h.toJson()).toList(),
    };
  }

  ForecastDayEntity toEntity() {
    return ForecastDayEntity(
      date: date,
      maxTempC: maxTempC,
      maxTempF: maxTempF,
      minTempC: minTempC,
      minTempF: minTempF,
      avgTempC: avgTempC,
      avgTempF: avgTempF,
      maxWindKph: maxWindKph,
      maxWindMph: maxWindMph,
      totalPrecipMm: totalPrecipMm,
      avgHumidity: avgHumidity,
      dailyChanceOfRain: dailyChanceOfRain,
      condition: condition,
      conditionIcon: conditionIcon,
      uvIndex: uvIndex,
      hours: hours.map((h) => h.toEntity()).toList(),
    );
  }
}

class HourlyForecastModel {
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

  const HourlyForecastModel({
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

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    final conditionData = json['condition'] as Map<String, dynamic>;
    return HourlyForecastModel(
      time: DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now(),
      tempC: (json['temp_c'] as num?)?.toDouble() ?? 0,
      tempF: (json['temp_f'] as num?)?.toDouble() ?? 0,
      condition: conditionData['text'] as String? ?? '',
      conditionIcon: 'https:${conditionData['icon'] as String? ?? ''}',
      windKph: (json['wind_kph'] as num?)?.toDouble() ?? 0,
      windMph: (json['wind_mph'] as num?)?.toDouble() ?? 0,
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      chanceOfRain: (json['chance_of_rain'] as num?)?.toInt() ?? 0,
      feelsLikeC: (json['feelslike_c'] as num?)?.toDouble() ?? 0,
      feelsLikeF: (json['feelslike_f'] as num?)?.toDouble() ?? 0,
      uvIndex: (json['uv'] as num?)?.toDouble() ?? 0,
      cloud: (json['cloud'] as num?)?.toInt() ?? 0,
    );
  }

  factory HourlyForecastModel.fromCacheJson(Map<String, dynamic> json) {
    return HourlyForecastModel(
      time: DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now(),
      tempC: (json['tempC'] as num?)?.toDouble() ?? 0,
      tempF: (json['tempF'] as num?)?.toDouble() ?? 0,
      condition: json['condition'] as String? ?? '',
      conditionIcon: json['conditionIcon'] as String? ?? '',
      windKph: (json['windKph'] as num?)?.toDouble() ?? 0,
      windMph: (json['windMph'] as num?)?.toDouble() ?? 0,
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      chanceOfRain: (json['chanceOfRain'] as num?)?.toInt() ?? 0,
      feelsLikeC: (json['feelsLikeC'] as num?)?.toDouble() ?? 0,
      feelsLikeF: (json['feelsLikeF'] as num?)?.toDouble() ?? 0,
      uvIndex: (json['uvIndex'] as num?)?.toDouble() ?? 0,
      cloud: (json['cloud'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'tempC': tempC,
      'tempF': tempF,
      'condition': condition,
      'conditionIcon': conditionIcon,
      'windKph': windKph,
      'windMph': windMph,
      'humidity': humidity,
      'chanceOfRain': chanceOfRain,
      'feelsLikeC': feelsLikeC,
      'feelsLikeF': feelsLikeF,
      'uvIndex': uvIndex,
      'cloud': cloud,
    };
  }

  HourlyForecastEntity toEntity() {
    return HourlyForecastEntity(
      time: time,
      tempC: tempC,
      tempF: tempF,
      condition: condition,
      conditionIcon: conditionIcon,
      windKph: windKph,
      windMph: windMph,
      humidity: humidity,
      chanceOfRain: chanceOfRain,
      feelsLikeC: feelsLikeC,
      feelsLikeF: feelsLikeF,
      uvIndex: uvIndex,
      cloud: cloud,
    );
  }
}
