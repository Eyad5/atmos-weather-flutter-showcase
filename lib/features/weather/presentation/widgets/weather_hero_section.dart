import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_offline_app/core/design_system/app_colors.dart';
import 'package:weather_offline_app/core/design_system/app_spacing.dart';
import 'package:weather_offline_app/core/design_system/weather_theme.dart';
import 'package:weather_offline_app/core/widgets/weather_illustration.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/weather/domain/entities/weather_entity.dart';

class WeatherHeroSection extends StatelessWidget {
  final WeatherEntity weather;
  final bool isFromCache;

  const WeatherHeroSection({
    super.key,
    required this.weather,
    this.isFromCache = false,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>().state;
    final gradientColors = WeatherTheme.gradient(
      weather.conditionCode,
      iconUrl: weather.conditionIcon,
    );
    final useLightText = WeatherTheme.isLightContent(
      weather.conditionCode,
      iconUrl: weather.conditionIcon,
    );

    final primaryColor = useLightText
        ? AppColors.onGradient
        : const Color(0xFF1E293B);
    final secondaryColor = useLightText
        ? AppColors.onGradientSecondary
        : const Color(0xFF475569);
    final tertiaryColor = useLightText
        ? AppColors.onGradientTertiary
        : const Color(0xFF64748B);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          children: [
            WeatherIllustration(
              conditionCode: weather.conditionCode,
              iconUrl: weather.conditionIcon,
              size: 100,
            ),
            AppSpacing.verticalSm,
            Text(
              weather.condition,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: secondaryColor,
                letterSpacing: 0.3,
              ),
            ),
            AppSpacing.verticalXs,
            Text(
              settings.formatTemperature(
                weather.temperatureC,
                weather.temperatureF,
              ),
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w200,
                color: primaryColor,
                height: 1.1,
                letterSpacing: -3,
              ),
            ),
            Text(
              'Feels like ${settings.formatTemperature(weather.feelsLikeC, weather.feelsLikeF)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: tertiaryColor,
              ),
            ),
            AppSpacing.verticalLg,
            Text(
              weather.city,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
                letterSpacing: -0.3,
              ),
            ),
            if (weather.country.isNotEmpty)
              Text(
                weather.country,
                style: TextStyle(fontSize: 13, color: tertiaryColor),
              ),
            AppSpacing.verticalXs,
            Text(
              'Updated ${DateFormat('MMM d, h:mm a').format(weather.lastUpdated)}',
              style: TextStyle(fontSize: 11, color: tertiaryColor),
            ),
            if (isFromCache) ...[
              AppSpacing.verticalMd,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 13, color: primaryColor),
                    const SizedBox(width: 5),
                    Text(
                      'Offline data',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
