import 'package:dartz/dartz.dart';
import 'package:weather_offline_app/core/error/exceptions.dart';
import 'package:weather_offline_app/core/error/failures.dart';
import 'package:weather_offline_app/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weather_offline_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_offline_app/features/weather/domain/entities/search_result_entity.dart';
import 'package:weather_offline_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_offline_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getWeatherWithForecast(
    String city,
  ) async {
    try {
      final model = await remoteDataSource.getWeatherWithForecast(city);
      await localDataSource.cacheWeather(model);
      return Right(model.toEntity());
    } on InvalidCityException catch (e) {
      return Left(InvalidCityFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SearchResultEntity>>> searchCities(
    String query,
  ) async {
    try {
      final models = await remoteDataSource.searchCities(query);
      return Right(models.map((m) => m.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Search failed: $e'));
    }
  }

  @override
  WeatherEntity? getLastCachedWeather() {
    final model = localDataSource.getLastCachedWeather();
    return model?.toEntity();
  }

  @override
  List<String> getRecentSearches() {
    return localDataSource.getRecentSearches();
  }

  @override
  Future<void> saveRecentSearch(String city) {
    return localDataSource.saveRecentSearch(city);
  }

  @override
  String? getSelectedCity() {
    return localDataSource.getSelectedCity();
  }

  @override
  Future<void> setSelectedCity(String city) {
    return localDataSource.setSelectedCity(city);
  }

  @override
  List<String> getSavedLocations() {
    return localDataSource.getSavedLocations();
  }

  @override
  Future<void> saveFavoriteLocation(String city) {
    return localDataSource.saveFavoriteLocation(city);
  }

  @override
  Future<void> removeFavoriteLocation(String city) {
    return localDataSource.removeFavoriteLocation(city);
  }

  @override
  Future<void> clearCache() {
    return localDataSource.clearCache();
  }
}
