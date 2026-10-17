import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_offline_app/app/app_shell.dart';
import 'package:weather_offline_app/config/service_locator.dart';
import 'package:weather_offline_app/core/theme/app_theme.dart';
import 'package:weather_offline_app/core/theme/theme_cubit.dart';
import 'package:weather_offline_app/core/theme/theme_state.dart';
import 'package:weather_offline_app/features/locations/presentation/cubit/locations_cubit.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/weather/presentation/cubit/weather_cubit.dart';

class AtmosWeatherApp extends StatelessWidget {
  const AtmosWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<SettingsCubit>.value(value: getIt<SettingsCubit>()),
        BlocProvider<WeatherCubit>(
          create: (_) => getIt<WeatherCubit>()..initialize(),
        ),
        BlocProvider<LocationsCubit>(create: (_) => getIt<LocationsCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Atmos Weather',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeState.themeMode,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
