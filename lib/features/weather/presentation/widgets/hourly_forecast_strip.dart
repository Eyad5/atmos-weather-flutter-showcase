import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_offline_app/core/widgets/weather_icon.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/weather/domain/entities/forecast_entity.dart';

class HourlyForecastStrip extends StatelessWidget {
  final List<HourlyForecastEntity> hours;

  const HourlyForecastStrip({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    if (hours.isEmpty) return const SizedBox.shrink();

    final now = DateTime.now();
    final upcoming = hours
        .where((h) => h.time.isAfter(now.subtract(const Duration(hours: 1))))
        .toList();

    if (upcoming.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final settings = context.watch<SettingsCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'Hourly',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: upcoming.length.clamp(0, 24),
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final hour = upcoming[index];
              final isNow = index == 0;
              return _HourlyItem(hour: hour, isNow: isNow, settings: settings);
            },
          ),
        ),
      ],
    );
  }
}

class _HourlyItem extends StatelessWidget {
  final HourlyForecastEntity hour;
  final bool isNow;
  final dynamic settings;

  const _HourlyItem({
    required this.hour,
    required this.isNow,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: isNow ? theme.colorScheme.primaryContainer : null,
      child: SizedBox(
        width: 72,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isNow ? 'Now' : DateFormat('ha').format(hour.time),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isNow ? FontWeight.w600 : FontWeight.w500,
                  color: isNow
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              WeatherIcon(iconUrl: hour.conditionIcon, size: 28),
              if (hour.chanceOfRain > 0)
                Text(
                  '${hour.chanceOfRain}%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade400,
                  ),
                ),
              Text(
                settings.formatTemperature(hour.tempC, hour.tempF),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isNow ? theme.colorScheme.onPrimaryContainer : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
