import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_offline_app/core/design_system/app_spacing.dart';
import 'package:weather_offline_app/core/widgets/weather_icon.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/weather/domain/entities/forecast_entity.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecastEntity> hours;

  const HourlyForecastList({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    if (hours.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final settings = context.watch<SettingsCubit>().state;
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'Hourly Breakdown',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: List.generate(hours.length, (index) {
                final hour = hours[index];
                final isCurrent =
                    hour.time.hour == now.hour && hour.time.day == now.day;
                return _HourRow(
                  hour: hour,
                  isCurrent: isCurrent,
                  settings: settings,
                  showDivider: index < hours.length - 1,
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _HourRow extends StatelessWidget {
  final HourlyForecastEntity hour;
  final bool isCurrent;
  final dynamic settings;
  final bool showDivider;

  const _HourRow({
    required this.hour,
    required this.isCurrent,
    required this.settings,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          color: isCurrent
              ? theme.colorScheme.primaryContainer.withAlpha(80)
              : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  DateFormat('h a').format(hour.time),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              WeatherIcon(iconUrl: hour.conditionIcon, size: 28),
              AppSpacing.horizontalSm,
              Expanded(
                child: Text(
                  hour.condition,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hour.chanceOfRain > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 12,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${hour.chanceOfRain}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.blue.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                settings.formatTemperature(hour.tempC, hour.tempF),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: theme.colorScheme.outlineVariant.withAlpha(50),
          ),
      ],
    );
  }
}
