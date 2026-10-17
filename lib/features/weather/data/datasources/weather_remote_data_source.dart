import 'package:dio/dio.dart';
import 'package:weather_offline_app/core/constants/app_constants.dart';
import 'package:weather_offline_app/core/error/exceptions.dart';
import 'package:weather_offline_app/core/network/dio_client.dart';
import 'package:weather_offline_app/features/weather/data/models/search_result_model.dart';
import 'package:weather_offline_app/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeatherWithForecast(String city);
  Future<List<SearchResultModel>> searchCities(String query);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final DioClient dioClient;

  WeatherRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<WeatherModel> getWeatherWithForecast(String city) async {
    if (AppConstants.weatherApiKey.isEmpty) {
      throw const ServerException(
        message:
            'API key not configured. Run with --dart-define=WEATHER_API_KEY=your_key',
      );
    }

    try {
      final response = await dioClient.dio.get(
        AppConstants.forecastEndpoint,
        queryParameters: {
          'key': AppConstants.weatherApiKey,
          'q': city,
          'days': AppConstants.forecastDays,
          'aqi': 'no',
          'alerts': 'no',
        },
      );
      return WeatherModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException(
          message: 'No internet connection. Please check your network.',
        );
      }

      final statusCode = e.response?.statusCode;
      if (statusCode == 400) {
        throw InvalidCityException(
          message: 'City "$city" not found. Please check the city name.',
        );
      }
      if (statusCode == 401 || statusCode == 403) {
        throw const ServerException(
          message: 'Invalid API key. Please check your configuration.',
        );
      }

      throw ServerException(
        message:
            e.response?.statusMessage ?? 'An unexpected server error occurred.',
      );
    }
  }

  @override
  Future<List<SearchResultModel>> searchCities(String query) async {
    if (AppConstants.weatherApiKey.isEmpty) {
      throw const ServerException(
        message:
            'API key not configured. Run with --dart-define=WEATHER_API_KEY=your_key',
      );
    }

    try {
      final response = await dioClient.dio.get(
        AppConstants.searchEndpoint,
        queryParameters: {'key': AppConstants.weatherApiKey, 'q': query},
      );
      final results = response.data as List<dynamic>;
      return results
          .map((r) => SearchResultModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection.');
      }
      throw ServerException(
        message: e.response?.statusMessage ?? 'Search failed.',
      );
    }
  }
}
