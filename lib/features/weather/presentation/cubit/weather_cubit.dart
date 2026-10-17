import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_offline_app/core/error/failures.dart';
import 'package:weather_offline_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_offline_app/features/weather/presentation/cubit/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _repository;

  String _lastSearchedCity = '';
  bool _isLoading = false;

  WeatherCubit({required WeatherRepository repository})
    : _repository = repository,
      super(const WeatherInitial());

  String get lastSearchedCity => _lastSearchedCity;

  void initialize() {
    final searches = _repository.getRecentSearches();
    final savedCity = _repository.getSelectedCity();
    if (savedCity != null && savedCity.isNotEmpty) {
      _lastSearchedCity = savedCity;
      emit(WeatherInitial(recentSearches: searches));
      searchWeather(savedCity);
    } else {
      emit(WeatherInitial(recentSearches: searches));
    }
  }

  Future<void> searchWeather(String city) async {
    final trimmed = city.trim();
    if (trimmed.isEmpty) {
      emit(
        WeatherError(
          message: 'Please enter a city name.',
          recentSearches: state.recentSearches,
        ),
      );
      return;
    }

    if (_isLoading) return;

    _isLoading = true;
    _lastSearchedCity = trimmed;
    final currentSearches = state.recentSearches;
    emit(WeatherLoading(recentSearches: currentSearches));

    final result = await _repository.getWeatherWithForecast(trimmed);

    _isLoading = false;

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          final cached = _repository.getLastCachedWeather();
          if (cached != null) {
            _lastSearchedCity = cached.city;
            emit(
              WeatherLoaded(
                weather: cached,
                isFromCache: true,
                recentSearches: currentSearches,
              ),
            );
            return;
          }
        }
        emit(
          WeatherError(
            message: failure.message,
            recentSearches: currentSearches,
          ),
        );
      },
      (weather) async {
        await _repository.saveRecentSearch(weather.city);
        await _repository.setSelectedCity(weather.city);
        final updatedSearches = _repository.getRecentSearches();
        emit(WeatherLoaded(weather: weather, recentSearches: updatedSearches));
      },
    );
  }

  Future<void> refreshWeather() async {
    if (_lastSearchedCity.isEmpty) return;
    if (_isLoading) return;

    _isLoading = true;
    final currentSearches = state.recentSearches;

    final result = await _repository.getWeatherWithForecast(_lastSearchedCity);

    _isLoading = false;

    result.fold(
      (failure) {
        emit(
          WeatherError(
            message: failure.message,
            recentSearches: currentSearches,
          ),
        );
      },
      (weather) {
        emit(WeatherLoaded(weather: weather, recentSearches: currentSearches));
      },
    );
  }
}
