import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/weather/domain/entities/forecast_entity.dart';

class TemperatureChart extends StatelessWidget {
  final List<HourlyForecastEntity> hours;

  const TemperatureChart({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    if (hours.length < 2) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final settings = context.watch<SettingsCubit>().state;
    final isCelsius = settings.isCelsius;

    final temps = hours.map((h) => isCelsius ? h.tempC : h.tempF).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b) - 2;
    final maxTemp = temps.reduce((a, b) => a > b ? a : b) + 2;

    final spots = <FlSpot>[];
    for (int i = 0; i < hours.length && i < 24; i++) {
      spots.add(
        FlSpot(i.toDouble(), isCelsius ? hours[i].tempC : hours[i].tempF),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'Temperature Trend',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 24, 16, 8),
            child: SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: minTemp,
                  maxY: maxTemp,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: (maxTemp - minTemp) / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.outlineVariant.withAlpha(30),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: (maxTemp - minTemp) / 4,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toStringAsFixed(0)}\u00B0',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (spots.length / 6).ceilToDouble().clamp(1, 6),
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= hours.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              DateFormat('ha').format(hours[idx].time),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary.withAlpha(60),
                            theme.colorScheme.primary.withAlpha(5),
                          ],
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                      getTooltipItems: (spots) => spots.map((spot) {
                        final unit = isCelsius ? 'C' : 'F';
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(1)}\u00B0$unit',
                          TextStyle(
                            color: theme.colorScheme.onInverseSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
