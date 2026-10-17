import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_offline_app/core/design_system/app_spacing.dart';
import 'package:weather_offline_app/core/widgets/weather_icon.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/weather/domain/entities/forecast_entity.dart';

class DailyForecastPreview extends StatelessWidget {
  final List<ForecastDayEntity> days;

  const DailyForecastPreview({super.key, required this.days});

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
            '${days.length}-Day Forecast',
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
              children: List.generate(days.length, (index) {
                final day = days[index];
                final isToday = index == 0;
                return _DailyRow(
                  day: day,
                  isToday: isToday,
                  settings: settings,
                  showDivider: index < days.length - 1,
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyRow extends StatelessWidget {
  final ForecastDayEntity day;
  final bool isToday;
  final dynamic settings;
  final bool showDivider;

  const _DailyRow({
    required this.day,
    required this.isToday,
    required this.settings,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  isToday ? 'Today' : DateFormat('EEE').format(day.date),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              WeatherIcon(iconUrl: day.conditionIcon, size: 28),
              AppSpacing.horizontalSm,
              if (day.dailyChanceOfRain > 0)
                SizedBox(
                  width: 36,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 10,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(width: 1),
                      Text(
                        '${day.dailyChanceOfRain}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.blue.shade400,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(width: 36),
              const Spacer(),
              Text(
                settings.formatTemperature(day.minTempC, day.minTempF),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.horizontalSm,
              SizedBox(
                width: 60,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade300.withAlpha(120),
                        Colors.orange.shade400,
                      ],
                    ),
                  ),
                ),
              ),
              AppSpacing.horizontalSm,
              Text(
                settings.formatTemperature(day.maxTempC, day.maxTempF),
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
            color: theme.colorScheme.outlineVariant.withAlpha(60),
          ),
      ],
    );
  }
}
