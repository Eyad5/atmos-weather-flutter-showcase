import 'package:flutter_test/flutter_test.dart';
import 'package:weather_offline_app/features/weather/data/models/weather_model.dart';

void main() {
  group('WeatherModel', () {
    const apiJson = <String, dynamic>{
      'location': {
        'name': 'London',
        'region': 'City of London',
        'country': 'United Kingdom',
      },
      'current': {
        'temp_c': 15.0,
        'temp_f': 59.0,
        'feelslike_c': 13.0,
        'feelslike_f': 55.4,
        'condition': {
          'text': 'Partly cloudy',
          'icon': '//cdn/icon.png',
          'code': 1003,
        },
        'humidity': 72,
        'wind_kph': 20.0,
        'wind_mph': 12.4,
        'wind_dir': 'SW',
        'pressure_mb': 1012.0,
        'pressure_in': 29.88,
        'vis_km': 10.0,
        'vis_miles': 6.0,
        'uv': 3.0,
        'cloud': 50,
        'last_updated': '2024-01-15 12:00',
      },
      'forecast': {
        'forecastday': [
          {
            'date': '2024-01-15',
            'day': {
              'maxtemp_c': 18.0,
              'maxtemp_f': 64.4,
              'mintemp_c': 10.0,
              'mintemp_f': 50.0,
              'avgtemp_c': 14.0,
              'avgtemp_f': 57.2,
              'maxwind_kph': 25.0,
              'maxwind_mph': 15.5,
              'totalprecip_mm': 2.5,
              'avghumidity': 70,
              'daily_chance_of_rain': 30,
              'condition': {'text': 'Cloudy', 'icon': '//cdn/cloudy.png'},
              'uv': 2.0,
            },
            'hour': [],
          },
        ],
      },
    };

    test('fromJson parses API response correctly', () {
      final model = WeatherModel.fromJson(apiJson);

      expect(model.city, 'London');
      expect(model.region, 'City of London');
      expect(model.country, 'United Kingdom');
      expect(model.temperatureC, 15.0);
      expect(model.temperatureF, 59.0);
      expect(model.feelsLikeC, 13.0);
      expect(model.humidity, 72);
      expect(model.windKph, 20.0);
      expect(model.windDirection, 'SW');
      expect(model.conditionCode, 1003);
      expect(model.conditionIcon, 'https://cdn/icon.png');
      expect(model.forecastDays.length, 1);
    });

    test('toJson and fromCacheJson round-trip preserves data', () {
      final model = WeatherModel.fromJson(apiJson);
      final json = model.toJson();
      final restored = WeatherModel.fromCacheJson(json);

      expect(restored.city, model.city);
      expect(restored.temperatureC, model.temperatureC);
      expect(restored.humidity, model.humidity);
      expect(restored.windDirection, model.windDirection);
      expect(restored.forecastDays.length, model.forecastDays.length);
    });

    test('toEntity converts to domain entity', () {
      final model = WeatherModel.fromJson(apiJson);
      final entity = model.toEntity();

      expect(entity.city, 'London');
      expect(entity.temperatureC, 15.0);
      expect(entity.forecastDays.length, 1);
      expect(entity.forecastDays.first.maxTempC, 18.0);
    });

    test('fromJson handles missing forecast gracefully', () {
      final noForecast = <String, dynamic>{
        'location': {'name': 'Test', 'region': '', 'country': ''},
        'current': {
          'temp_c': 20.0,
          'temp_f': 68.0,
          'feelslike_c': 19.0,
          'feelslike_f': 66.2,
          'condition': {
            'text': 'Sunny',
            'icon': '//cdn/sunny.png',
            'code': 1000,
          },
          'humidity': 50,
          'wind_kph': 10.0,
          'wind_mph': 6.2,
          'wind_dir': 'N',
          'pressure_mb': 1015.0,
          'pressure_in': 29.97,
          'vis_km': 10.0,
          'vis_miles': 6.0,
          'uv': 5.0,
          'cloud': 0,
          'last_updated': '2024-01-15 14:00',
        },
      };
      final model = WeatherModel.fromJson(noForecast);
      expect(model.forecastDays, isEmpty);
      expect(model.city, 'Test');
    });
  });
}
