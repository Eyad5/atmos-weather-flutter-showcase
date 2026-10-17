import 'package:equatable/equatable.dart';
import 'package:weather_offline_app/features/weather/domain/entities/search_result_entity.dart';

abstract class LocationsState extends Equatable {
  final List<String> savedLocations;
  final List<String> recentSearches;

  const LocationsState({
    this.savedLocations = const [],
    this.recentSearches = const [],
  });

  @override
  List<Object?> get props => [savedLocations, recentSearches];
}

class LocationsInitial extends LocationsState {
  const LocationsInitial({super.savedLocations, super.recentSearches});
}

class LocationsSearching extends LocationsState {
  const LocationsSearching({super.savedLocations, super.recentSearches});
}

class LocationsSearchResults extends LocationsState {
  final List<SearchResultEntity> results;

  const LocationsSearchResults({
    required this.results,
    super.savedLocations,
    super.recentSearches,
  });

  @override
  List<Object?> get props => [results, savedLocations, recentSearches];
}

class LocationsSearchError extends LocationsState {
  final String message;

  const LocationsSearchError({
    required this.message,
    super.savedLocations,
    super.recentSearches,
  });

  @override
  List<Object?> get props => [message, savedLocations, recentSearches];
}
