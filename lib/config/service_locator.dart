import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_offline_app/core/network/dio_client.dart';
import 'package:weather_offline_app/core/theme/theme_cubit.dart';
import 'package:weather_offline_app/features/locations/presentation/cubit/locations_cubit.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weather_offline_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_offline_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_offline_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_offline_app/features/weather/presentation/cubit/weather_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Data Sources
  getIt.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: getIt<WeatherRemoteDataSource>(),
      localDataSource: getIt<WeatherLocalDataSource>(),
    ),
  );

  // Cubits
  getIt.registerSingleton<ThemeCubit>(
    ThemeCubit(prefs: getIt<SharedPreferences>()),
  );
  getIt.registerSingleton<SettingsCubit>(
    SettingsCubit(prefs: getIt<SharedPreferences>()),
  );
  getIt.registerFactory<WeatherCubit>(
    () => WeatherCubit(repository: getIt<WeatherRepository>()),
  );
  getIt.registerFactory<LocationsCubit>(
    () => LocationsCubit(repository: getIt<WeatherRepository>()),
  );
}
