import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_offline_app/core/design_system/app_spacing.dart';
import 'package:weather_offline_app/core/widgets/weather_icon.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/weather/domain/entities/forecast_entity.dart';

class DailyForecastCard extends StatelessWidget {
  final List<ForecastDayEntity> days;

  const DailyForecastCard({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final settings = context.watch<SettingsCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'Daily Forecast',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ...days.map((day) => _DayCard(day: day, settings: settings)),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  final ForecastDayEntity day;
  final dynamic settings;

  const _DayCard({required this.day, required this.settings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = DateUtils.isSameDay(day.date, DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isToday
                        ? 'Today'
                        : DateFormat('EEEE, MMM d').format(day.date),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                WeatherIcon(iconUrl: day.conditionIcon, size: 36),
              ],
            ),
            AppSpacing.verticalXs,
            Text(
              day.condition,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.verticalMd,
            Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.orange.shade400],
                ),
              ),
            ),
            AppSpacing.verticalMd,
            Row(
              children: [
                _DayDetail(
                  label: 'High',
                  value: settings.formatTemperature(day.maxTempC, day.maxTempF),
                ),
                _DayDetail(
                  label: 'Low',
                  value: settings.formatTemperature(day.minTempC, day.minTempF),
                ),
                _DayDetail(label: 'Rain', value: '${day.dailyChanceOfRain}%'),
                _DayDetail(label: 'Humidity', value: '${day.avgHumidity}%'),
                _DayDetail(
                  label: 'Wind',
                  value: settings.formatWind(day.maxWindKph, day.maxWindMph),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayDetail extends StatelessWidget {
  final String label;
  final String value;

  const _DayDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
