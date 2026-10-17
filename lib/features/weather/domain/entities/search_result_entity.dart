import 'package:equatable/equatable.dart';

class SearchResultEntity extends Equatable {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;

  const SearchResultEntity({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
  });

  String get displayName {
    final parts = <String>[name];
    if (region.isNotEmpty) parts.add(region);
    parts.add(country);
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [name, region, country, lat, lon];
}
