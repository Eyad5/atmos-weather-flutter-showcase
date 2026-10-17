import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_offline_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_offline_app/features/locations/presentation/cubit/locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  final WeatherRepository _repository;

  LocationsCubit({required WeatherRepository repository})
    : _repository = repository,
      super(const LocationsInitial()) {
    _loadLocations();
  }

  void _loadLocations() {
    final saved = _repository.getSavedLocations();
    final recent = _repository.getRecentSearches();
    emit(LocationsInitial(savedLocations: saved, recentSearches: recent));
  }

  Future<void> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return;

    emit(
      LocationsSearching(
        savedLocations: state.savedLocations,
        recentSearches: state.recentSearches,
      ),
    );

    final result = await _repository.searchCities(trimmed);

    result.fold(
      (failure) => emit(
        LocationsSearchError(
          message: failure.message,
          savedLocations: state.savedLocations,
          recentSearches: state.recentSearches,
        ),
      ),
      (results) => emit(
        LocationsSearchResults(
          results: results,
          savedLocations: state.savedLocations,
          recentSearches: state.recentSearches,
        ),
      ),
    );
  }

  Future<void> addFavorite(String city) async {
    await _repository.saveFavoriteLocation(city);
    _refreshLocations();
  }

  Future<void> removeFavorite(String city) async {
    await _repository.removeFavoriteLocation(city);
    _refreshLocations();
  }

  bool isFavorite(String city) {
    return state.savedLocations.any(
      (l) => l.toLowerCase() == city.toLowerCase(),
    );
  }

  void clearSearch() {
    _refreshLocations();
  }

  void _refreshLocations() {
    final saved = _repository.getSavedLocations();
    final recent = _repository.getRecentSearches();
    emit(LocationsInitial(savedLocations: saved, recentSearches: recent));
  }
}
