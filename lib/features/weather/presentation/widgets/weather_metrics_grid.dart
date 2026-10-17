import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_offline_app/core/design_system/app_spacing.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/weather/domain/entities/weather_entity.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherMetricsGrid({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'Weather Details',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Row(
          children: [
            _MetricCard(
              icon: Icons.water_drop_outlined,
              label: 'Humidity',
              value: '${weather.humidity}%',
            ),
            AppSpacing.horizontalSm,
            _MetricCard(
              icon: Icons.air_rounded,
              label: 'Wind',
              value: settings.formatWind(weather.windKph, weather.windMph),
              subtitle: weather.windDirection,
            ),
          ],
        ),
        AppSpacing.verticalSm,
        Row(
          children: [
            _MetricCard(
              icon: Icons.wb_sunny_outlined,
              label: 'UV Index',
              value: weather.uvIndex.toStringAsFixed(0),
              subtitle: _uvDescription(weather.uvIndex),
            ),
            AppSpacing.horizontalSm,
            _MetricCard(
              icon: Icons.compress_rounded,
              label: 'Pressure',
              value: '${weather.pressureMb.toStringAsFixed(0)} mb',
            ),
          ],
        ),
        AppSpacing.verticalSm,
        Row(
          children: [
            _MetricCard(
              icon: Icons.visibility_outlined,
              label: 'Visibility',
              value: settings.isKmh
                  ? '${weather.visibilityKm.toStringAsFixed(0)} km'
                  : '${weather.visibilityMiles.toStringAsFixed(0)} mi',
            ),
            AppSpacing.horizontalSm,
            _MetricCard(
              icon: Icons.cloud_outlined,
              label: 'Cloud Cover',
              value: '${weather.cloudCover}%',
            ),
          ],
        ),
      ],
    );
  }

  String _uvDescription(double uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'Very High';
    return 'Extreme';
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: theme.colorScheme.primary),
              ),
              AppSpacing.horizontalMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            value,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
