import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_offline_app/core/design_system/app_spacing.dart';
import 'package:weather_offline_app/core/widgets/shimmer_box.dart';
import 'package:weather_offline_app/core/widgets/weather_illustration.dart';
import 'package:weather_offline_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_offline_app/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:weather_offline_app/features/weather/presentation/cubit/weather_state.dart';
import 'package:weather_offline_app/features/weather/presentation/widgets/daily_forecast_preview.dart';
import 'package:weather_offline_app/features/weather/presentation/widgets/hourly_forecast_strip.dart';
import 'package:weather_offline_app/features/weather/presentation/widgets/weather_hero_section.dart';
import 'package:weather_offline_app/features/weather/presentation/widgets/weather_metrics_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final text = _searchController.text.trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    context.read<WeatherCubit>().searchWeather(text);
    setState(() => _showSearch = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search city...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _onSearch(),
              )
            : const Text('Atmos Weather'),
        actions: [
          if (_showSearch)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
                setState(() => _showSearch = false);
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => setState(() => _showSearch = true),
            ),
        ],
      ),
      body: BlocListener<WeatherCubit, WeatherState>(
        listener: (context, state) {
          if (state is WeatherLoaded) {
            _searchController.text = state.weather.city;
          }
        },
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial) {
              return _buildInitialState(state, theme);
            }
            if (state is WeatherLoading) {
              return const _HomeShimmer();
            }
            if (state is WeatherLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<WeatherCubit>().refreshWeather(),
                child: _buildWeatherContent(state),
              );
            }
            if (state is WeatherError) {
              return _buildErrorState(state, theme);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInitialState(WeatherInitial state, ThemeData theme) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingAllXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WeatherIllustration(conditionCode: 1003, size: 100),
            AppSpacing.verticalXl,
            Text(
              'Welcome to Atmos Weather',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalSm,
            Text(
              'Search for a city to get started',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (state.recentSearches.isNotEmpty) ...[
              AppSpacing.verticalXxl,
              Text(
                'Recent searches',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              AppSpacing.verticalSm,
              Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: state.recentSearches
                    .map(
                      (city) => ActionChip(
                        label: Text(city),
                        onPressed: () =>
                            context.read<WeatherCubit>().searchWeather(city),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(WeatherLoaded state) {
    final weather = state.weather;
    final todayHours = weather.forecastDays.isNotEmpty
        ? weather.forecastDays.first.hours
        : const <HourlyForecastEntity>[];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.paddingAllLg,
      children: [
        WeatherHeroSection(weather: weather, isFromCache: state.isFromCache),
        AppSpacing.verticalXl,
        if (todayHours.isNotEmpty) ...[
          HourlyForecastStrip(hours: todayHours),
          AppSpacing.verticalXl,
        ],
        WeatherMetricsGrid(weather: weather),
        AppSpacing.verticalXl,
        if (weather.forecastDays.isNotEmpty) ...[
          DailyForecastPreview(days: weather.forecastDays),
          AppSpacing.verticalXl,
        ],
      ],
    );
  }

  Widget _buildErrorState(WeatherError state, ThemeData theme) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingAllXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
            ),
            AppSpacing.verticalLg,
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.verticalXl,
            FilledButton.icon(
              onPressed: () => setState(() => _showSearch = true),
              icon: const Icon(Icons.search_rounded),
              label: const Text('Try another city'),
            ),
            if (state.recentSearches.isNotEmpty) ...[
              AppSpacing.verticalXl,
              Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: state.recentSearches
                    .map(
                      (city) => ActionChip(
                        label: Text(city),
                        onPressed: () =>
                            context.read<WeatherCubit>().searchWeather(city),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HomeShimmer extends StatelessWidget {
  const _HomeShimmer();

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: AppSpacing.paddingAllLg,
        child: Column(
          children: [
            const ShimmerBox(
              width: double.infinity,
              height: 340,
              borderRadius: 24,
            ),
            AppSpacing.verticalXl,
            const ShimmerBox(width: 80, height: 16),
            AppSpacing.verticalSm,
            SizedBox(
              height: 130,
              child: Row(
                children: List.generate(
                  4,
                  (_) => const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: ShimmerBox(width: double.infinity, height: 130),
                    ),
                  ),
                ),
              ),
            ),
            AppSpacing.verticalXl,
            const ShimmerBox(width: 100, height: 16),
            AppSpacing.verticalSm,
            ...List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ShimmerBox(width: double.infinity, height: 64),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ShimmerBox(width: double.infinity, height: 64),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
