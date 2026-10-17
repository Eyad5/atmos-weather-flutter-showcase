import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_offline_app/core/error/failures.dart';
import 'package:weather_offline_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_offline_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_offline_app/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:weather_offline_app/features/weather/presentation/cubit/weather_state.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late MockWeatherRepository mockRepository;
  late WeatherCubit cubit;

  final testWeather = WeatherEntity(
    city: 'London',
    region: 'City of London',
    country: 'United Kingdom',
    temperatureC: 15.0,
    temperatureF: 59.0,
    feelsLikeC: 13.0,
    feelsLikeF: 55.4,
    condition: 'Partly cloudy',
    conditionIcon: 'https://cdn/icon.png',
    conditionCode: 1003,
    humidity: 72,
    windKph: 20.0,
    windMph: 12.4,
    windDirection: 'SW',
    pressureMb: 1012.0,
    pressureIn: 29.88,
    visibilityKm: 10.0,
    visibilityMiles: 6.0,
    uvIndex: 3.0,
    cloudCover: 50,
    lastUpdated: DateTime(2024, 1, 15, 12, 0),
  );

  setUp(() {
    mockRepository = MockWeatherRepository();
    when(() => mockRepository.getRecentSearches()).thenReturn([]);
    when(() => mockRepository.getSelectedCity()).thenReturn(null);
    cubit = WeatherCubit(repository: mockRepository);
  });

  tearDown(() => cubit.close());

  test('initial state is WeatherInitial', () {
    expect(cubit.state, isA<WeatherInitial>());
  });

  blocTest<WeatherCubit, WeatherState>(
    'searchWeather emits [Loading, Loaded] on success',
    build: () {
      when(
        () => mockRepository.getWeatherWithForecast('London'),
      ).thenAnswer((_) async => Right(testWeather));
      when(
        () => mockRepository.saveRecentSearch('London'),
      ).thenAnswer((_) async {});
      when(
        () => mockRepository.setSelectedCity('London'),
      ).thenAnswer((_) async {});
      when(() => mockRepository.getRecentSearches()).thenReturn(['London']);
      return cubit;
    },
    act: (cubit) => cubit.searchWeather('London'),
    expect: () => [
      isA<WeatherLoading>(),
      isA<WeatherLoaded>().having((s) => s.weather.city, 'city', 'London'),
    ],
  );

  blocTest<WeatherCubit, WeatherState>(
    'searchWeather emits [Loading, Error] on failure',
    build: () {
      when(
        () => mockRepository.getWeatherWithForecast('InvalidCity'),
      ).thenAnswer(
        (_) async => const Left(InvalidCityFailure(message: 'City not found')),
      );
      return cubit;
    },
    act: (cubit) => cubit.searchWeather('InvalidCity'),
    expect: () => [
      isA<WeatherLoading>(),
      isA<WeatherError>().having((s) => s.message, 'message', 'City not found'),
    ],
  );

  blocTest<WeatherCubit, WeatherState>(
    'searchWeather emits Error for empty city name',
    build: () => cubit,
    act: (cubit) => cubit.searchWeather('   '),
    expect: () => [
      isA<WeatherError>().having(
        (s) => s.message,
        'message',
        'Please enter a city name.',
      ),
    ],
  );

  blocTest<WeatherCubit, WeatherState>(
    'searchWeather falls back to cache on NetworkFailure',
    build: () {
      when(() => mockRepository.getWeatherWithForecast('London')).thenAnswer(
        (_) async =>
            const Left(NetworkFailure(message: 'No internet connection.')),
      );
      when(() => mockRepository.getLastCachedWeather()).thenReturn(testWeather);
      return cubit;
    },
    act: (cubit) => cubit.searchWeather('London'),
    expect: () => [
      isA<WeatherLoading>(),
      isA<WeatherLoaded>()
          .having((s) => s.isFromCache, 'isFromCache', true)
          .having((s) => s.weather.city, 'city', 'London'),
    ],
  );

  group('initialize', () {
    blocTest<WeatherCubit, WeatherState>(
      'loads saved city on initialize',
      build: () {
        when(() => mockRepository.getSelectedCity()).thenReturn('Tokyo');
        when(
          () => mockRepository.getRecentSearches(),
        ).thenReturn(['Tokyo', 'London']);
        when(
          () => mockRepository.getWeatherWithForecast('Tokyo'),
        ).thenAnswer((_) async => Right(testWeather.copyWith(city: 'Tokyo')));
        when(
          () => mockRepository.saveRecentSearch('Tokyo'),
        ).thenAnswer((_) async {});
        when(
          () => mockRepository.setSelectedCity('Tokyo'),
        ).thenAnswer((_) async {});
        return WeatherCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        isA<WeatherInitial>(),
        isA<WeatherLoading>(),
        isA<WeatherLoaded>(),
      ],
    );
  });
}

extension on WeatherEntity {
  WeatherEntity copyWith({String? city}) {
    return WeatherEntity(
      city: city ?? this.city,
      region: region,
      country: country,
      temperatureC: temperatureC,
      temperatureF: temperatureF,
      feelsLikeC: feelsLikeC,
      feelsLikeF: feelsLikeF,
      condition: condition,
      conditionIcon: conditionIcon,
      conditionCode: conditionCode,
      humidity: humidity,
      windKph: windKph,
      windMph: windMph,
      windDirection: windDirection,
      pressureMb: pressureMb,
      pressureIn: pressureIn,
      visibilityKm: visibilityKm,
      visibilityMiles: visibilityMiles,
      uvIndex: uvIndex,
      cloudCover: cloudCover,
      lastUpdated: lastUpdated,
    );
  }
}
