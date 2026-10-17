import 'package:dartz/dartz.dart';
import 'package:weather_offline_app/core/error/failures.dart';
import 'package:weather_offline_app/features/weather/domain/entities/search_result_entity.dart';
import 'package:weather_offline_app/features/weather/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeatherWithForecast(String city);
  Future<Either<Failure, List<SearchResultEntity>>> searchCities(String query);
  WeatherEntity? getLastCachedWeather();
  List<String> getRecentSearches();
  Future<void> saveRecentSearch(String city);
  String? getSelectedCity();
  Future<void> setSelectedCity(String city);
  List<String> getSavedLocations();
  Future<void> saveFavoriteLocation(String city);
  Future<void> removeFavoriteLocation(String city);
  Future<void> clearCache();
}
