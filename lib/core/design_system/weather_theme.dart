import 'package:flutter/material.dart';
import 'package:weather_offline_app/core/design_system/app_colors.dart';

class WeatherTheme {
  WeatherTheme._();

  /// Returns gradient colors for a given weather condition code.
  /// Pass the icon URL to detect night conditions.
  static List<Color> gradient(int conditionCode, {String iconUrl = ''}) {
    final isNight = iconUrl.contains('/night/');
    if (isNight) return AppColors.nightGradient;

    // Sunny / Clear
    if (conditionCode == 1000) return AppColors.sunnyGradient;
    // Partly cloudy
    if (conditionCode == 1003) return AppColors.partlyCloudyGradient;
    // Cloudy / Overcast
    if (conditionCode == 1006 || conditionCode == 1009) {
      return AppColors.cloudyGradient;
    }
    // Mist / Fog / Freezing fog
    if (conditionCode == 1030 ||
        conditionCode == 1135 ||
        conditionCode == 1147) {
      return AppColors.foggyGradient;
    }
    // Thunder
    if (conditionCode == 1087 ||
        conditionCode >= 1273 && conditionCode <= 1282) {
      return AppColors.stormyGradient;
    }
    // Snow / Sleet / Ice
    if (_snowCodes.contains(conditionCode)) return AppColors.snowyGradient;
    // Rain / Drizzle
    if (_rainCodes.contains(conditionCode)) return AppColors.rainyGradient;

    return AppColors.defaultGradient;
  }

  /// Returns an appropriate Material icon for the weather condition.
  static IconData conditionIcon(int conditionCode, {String iconUrl = ''}) {
    final isNight = iconUrl.contains('/night/');

    if (conditionCode == 1000) {
      return isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded;
    }
    if (conditionCode == 1003) {
      return isNight ? Icons.nights_stay_rounded : Icons.cloud_queue_rounded;
    }
    if (conditionCode == 1006 || conditionCode == 1009) {
      return Icons.cloud_rounded;
    }
    if (conditionCode == 1030 ||
        conditionCode == 1135 ||
        conditionCode == 1147) {
      return Icons.foggy;
    }
    if (conditionCode == 1087 ||
        conditionCode >= 1273 && conditionCode <= 1282) {
      return Icons.thunderstorm_rounded;
    }
    if (_snowCodes.contains(conditionCode)) return Icons.ac_unit_rounded;
    if (_rainCodes.contains(conditionCode)) return Icons.grain_rounded;

    return Icons.cloud_rounded;
  }

  /// Whether text on this gradient should use light or dark foreground.
  static bool isLightContent(int conditionCode, {String iconUrl = ''}) {
    final isNight = iconUrl.contains('/night/');
    if (isNight) return true;
    // Snow and fog gradients are light-colored
    if (_snowCodes.contains(conditionCode)) return false;
    if (conditionCode == 1030 ||
        conditionCode == 1135 ||
        conditionCode == 1147) {
      return false;
    }
    return true;
  }

  static const Set<int> _snowCodes = {
    1066,
    1069,
    1072,
    1114,
    1117,
    1204,
    1207,
    1210,
    1213,
    1216,
    1219,
    1222,
    1225,
    1237,
    1249,
    1252,
    1255,
    1258,
    1261,
    1264,
  };

  static const Set<int> _rainCodes = {
    1063,
    1150,
    1153,
    1168,
    1171,
    1180,
    1183,
    1186,
    1189,
    1192,
    1195,
    1198,
    1201,
    1240,
    1243,
    1246,
  };
}
