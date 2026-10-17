import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_offline_app/core/constants/app_constants.dart';
import 'package:weather_offline_app/features/weather/data/models/weather_model.dart';

abstract class WeatherLocalDataSource {
  WeatherModel? getLastCachedWeather();
  Future<void> cacheWeather(WeatherModel model);
  List<String> getRecentSearches();
  Future<void> saveRecentSearch(String city);
  String? getSelectedCity();
  Future<void> setSelectedCity(String city);
  List<String> getSavedLocations();
  Future<void> saveFavoriteLocation(String city);
  Future<void> removeFavoriteLocation(String city);
  Future<void> clearCache();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  @override
  WeatherModel? getLastCachedWeather() {
    final jsonString = sharedPreferences.getString(
      AppConstants.cachedWeatherKey,
    );
    if (jsonString == null) return null;
    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return WeatherModel.fromCacheJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheWeather(WeatherModel model) {
    final jsonString = jsonEncode(model.toJson());
    return sharedPreferences.setString(
      AppConstants.cachedWeatherKey,
      jsonString,
    );
  }

  @override
  List<String> getRecentSearches() {
    return sharedPreferences.getStringList(AppConstants.recentSearchesKey) ??
        [];
  }

  @override
  Future<void> saveRecentSearch(String city) {
    final searches = getRecentSearches();
    searches.removeWhere((s) => s.toLowerCase() == city.toLowerCase());
    searches.insert(0, city);
    final trimmed = searches.take(AppConstants.maxRecentSearches).toList();
    return sharedPreferences.setStringList(
      AppConstants.recentSearchesKey,
      trimmed,
    );
  }

  @override
  String? getSelectedCity() {
    return sharedPreferences.getString(AppConstants.selectedCityKey);
  }

  @override
  Future<void> setSelectedCity(String city) {
    return sharedPreferences.setString(AppConstants.selectedCityKey, city);
  }

  @override
  List<String> getSavedLocations() {
    return sharedPreferences.getStringList(AppConstants.savedLocationsKey) ??
        [];
  }

  @override
  Future<void> saveFavoriteLocation(String city) {
    final locations = getSavedLocations();
    if (locations.any((l) => l.toLowerCase() == city.toLowerCase())) {
      return Future.value();
    }
    if (locations.length >= AppConstants.maxSavedLocations) {
      return Future.error('Maximum saved locations reached.');
    }
    locations.add(city);
    return sharedPreferences.setStringList(
      AppConstants.savedLocationsKey,
      locations,
    );
  }

  @override
  Future<void> removeFavoriteLocation(String city) {
    final locations = getSavedLocations();
    locations.removeWhere((l) => l.toLowerCase() == city.toLowerCase());
    return sharedPreferences.setStringList(
      AppConstants.savedLocationsKey,
      locations,
    );
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(AppConstants.cachedWeatherKey);
  }
}
