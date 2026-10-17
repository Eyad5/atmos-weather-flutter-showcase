import 'package:weather_offline_app/features/weather/domain/entities/search_result_entity.dart';

class SearchResultModel {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;

  const SearchResultModel({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      name: json['name'] as String? ?? '',
      region: json['region'] as String? ?? '',
      country: json['country'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0,
    );
  }

  SearchResultEntity toEntity() {
    return SearchResultEntity(
      name: name,
      region: region,
      country: country,
      lat: lat,
      lon: lon,
    );
  }
}
