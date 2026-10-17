import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_offline_app/core/design_system/app_spacing.dart';
import 'package:weather_offline_app/core/widgets/shimmer_box.dart';
import 'package:weather_offline_app/features/forecast/presentation/widgets/daily_forecast_card.dart';
import 'package:weather_offline_app/features/forecast/presentation/widgets/hourly_forecast_list.dart';
import 'package:weather_offline_app/features/forecast/presentation/widgets/temperature_chart.dart';
import 'package:weather_offline_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_offline_app/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:weather_offline_app/features/weather/presentation/cubit/weather_state.dart';

class ForecastPage extends StatelessWidget {
  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Forecast')),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoaded) {
            final days = state.weather.forecastDays;
            if (days.isEmpty) {
              return _buildEmptyForecast(theme);
            }
            return _ForecastContent(days: days);
          }

          if (state is WeatherLoading) {
            return const _ForecastShimmer();
          }

          return _buildDefaultState(theme);
        },
      ),
    );
  }

  Widget _buildEmptyForecast(ThemeData theme) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingAllXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
            ),
            AppSpacing.verticalLg,
            Text(
              'Forecast Unavailable',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.verticalSm,
            Text(
              'Forecast data is not available for this location.\nTry searching for a different city.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingAllXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
            ),
            AppSpacing.verticalLg,
            Text(
              'No Forecast Yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.verticalSm,
            Text(
              'Search for a city on the Home tab to see the forecast.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastContent extends StatelessWidget {
  final List<ForecastDayEntity> days;

  const _ForecastContent({required this.days});

  @override
  Widget build(BuildContext context) {
    final allHoursToday = days.isNotEmpty
        ? days.first.hours
        : <HourlyForecastEntity>[];

    return ListView(
      padding: AppSpacing.paddingAllLg,
      children: [
        if (allHoursToday.isNotEmpty) ...[
          TemperatureChart(hours: allHoursToday),
          AppSpacing.verticalXl,
          HourlyForecastList(hours: allHoursToday),
          AppSpacing.verticalXl,
        ],
        DailyForecastCard(days: days),
        AppSpacing.verticalXl,
      ],
    );
  }
}

class _ForecastShimmer extends StatelessWidget {
  const _ForecastShimmer();

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: AppSpacing.paddingAllLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: 120, height: 16),
            AppSpacing.verticalSm,
            const ShimmerBox(
              width: double.infinity,
              height: 230,
              borderRadius: 20,
            ),
            AppSpacing.verticalXl,
            const ShimmerBox(width: 100, height: 16),
            AppSpacing.verticalSm,
            ...List.generate(
              5,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: ShimmerBox(
                  width: double.infinity,
                  height: 52,
                  borderRadius: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
