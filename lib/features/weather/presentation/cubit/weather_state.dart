import 'package:equatable/equatable.dart';
import 'package:weather_offline_app/features/weather/domain/entities/weather_entity.dart';

abstract class WeatherState extends Equatable {
  final List<String> recentSearches;

  const WeatherState({this.recentSearches = const []});

  @override
  List<Object?> get props => [recentSearches];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial({super.recentSearches});
}

class WeatherLoading extends WeatherState {
  const WeatherLoading({super.recentSearches});
}

class WeatherLoaded extends WeatherState {
  final WeatherEntity weather;
  final bool isFromCache;

  const WeatherLoaded({
    required this.weather,
    this.isFromCache = false,
    super.recentSearches,
  });

  @override
  List<Object?> get props => [weather, isFromCache, recentSearches];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError({required this.message, super.recentSearches});

  @override
  List<Object?> get props => [message, recentSearches];
}
