import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_offline_app/core/constants/app_constants.dart';
import 'package:weather_offline_app/core/design_system/app_spacing.dart';
import 'package:weather_offline_app/core/theme/theme_cubit.dart';
import 'package:weather_offline_app/core/theme/theme_state.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:weather_offline_app/features/settings/presentation/cubit/settings_state.dart';
import 'package:weather_offline_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_offline_app/config/service_locator.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: AppSpacing.paddingAllLg,
        children: [
          _SectionHeader(icon: Icons.palette_outlined, title: 'APPEARANCE'),
          _buildThemeSection(context, theme),
          AppSpacing.verticalXl,
          _SectionHeader(icon: Icons.straighten_outlined, title: 'UNITS'),
          _buildUnitsSection(context, theme),
          AppSpacing.verticalXl,
          _SectionHeader(icon: Icons.storage_outlined, title: 'DATA'),
          _buildDataSection(context, theme),
          AppSpacing.verticalXl,
          _SectionHeader(icon: Icons.info_outline, title: 'ABOUT'),
          _buildAboutSection(context, theme),
          AppSpacing.verticalXxl,
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, ThemeData theme) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Card(
          child: Column(
            children: [
              _ThemeOption(
                title: 'System default',
                icon: Icons.settings_brightness,
                selected: state.themeMode == ThemeMode.system,
                onTap: () =>
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.system),
              ),
              _divider(theme),
              _ThemeOption(
                title: 'Light',
                icon: Icons.light_mode_outlined,
                selected: state.themeMode == ThemeMode.light,
                onTap: () =>
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.light),
              ),
              _divider(theme),
              _ThemeOption(
                title: 'Dark',
                icon: Icons.dark_mode_outlined,
                selected: state.themeMode == ThemeMode.dark,
                onTap: () =>
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.dark),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnitsSection(BuildContext context, ThemeData theme) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.thermostat_outlined),
                title: const Text('Temperature'),
                trailing: SegmentedButton<TemperatureUnit>(
                  segments: const [
                    ButtonSegment(
                      value: TemperatureUnit.celsius,
                      label: Text('\u00B0C'),
                    ),
                    ButtonSegment(
                      value: TemperatureUnit.fahrenheit,
                      label: Text('\u00B0F'),
                    ),
                  ],
                  selected: {state.temperatureUnit},
                  onSelectionChanged: (selection) {
                    context.read<SettingsCubit>().setTemperatureUnit(
                      selection.first,
                    );
                  },
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              _divider(theme),
              ListTile(
                leading: const Icon(Icons.air),
                title: const Text('Wind speed'),
                trailing: SegmentedButton<WindSpeedUnit>(
                  segments: const [
                    ButtonSegment(
                      value: WindSpeedUnit.kmh,
                      label: Text('km/h'),
                    ),
                    ButtonSegment(value: WindSpeedUnit.mph, label: Text('mph')),
                  ],
                  selected: {state.windSpeedUnit},
                  onSelectionChanged: (selection) {
                    context.read<SettingsCubit>().setWindSpeedUnit(
                      selection.first,
                    );
                  },
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataSection(BuildContext context, ThemeData theme) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.cached_rounded),
            title: const Text('Clear cached weather'),
            subtitle: const Text('Remove locally stored weather data'),
            onTap: () => _showClearCacheDialog(context),
          ),
          _divider(theme),
          const ListTile(
            leading: Icon(Icons.wifi_off_rounded),
            title: Text('Offline mode'),
            subtitle: Text(
              'When offline, the app shows the last successfully loaded weather data with a visual indicator.',
            ),
            enabled: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, ThemeData theme) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: const Text(AppConstants.appName),
            subtitle: Text('Version ${AppConstants.appVersion}'),
          ),
          _divider(theme),
          const ListTile(
            leading: Icon(Icons.code_rounded),
            title: Text('Built with'),
            subtitle: Text('Flutter, BLoC/Cubit, Dio, Clean Architecture'),
          ),
          _divider(theme),
          const ListTile(
            leading: Icon(Icons.person_outline_rounded),
            title: Text('Developer'),
            subtitle: Text(AppConstants.developerName),
          ),
          _divider(theme),
          const ListTile(
            leading: Icon(Icons.api_rounded),
            title: Text('Weather data'),
            subtitle: Text('Powered by WeatherAPI.com'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cache?'),
        content: const Text(
          'This will remove all locally stored weather data. '
          'You will need an internet connection to load weather again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              getIt<WeatherRepository>().clearCache();
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Cache cleared')));
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _divider(ThemeData theme) {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: theme.colorScheme.outlineVariant.withAlpha(60),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: selected ? theme.colorScheme.primaryContainer.withAlpha(40) : null,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: selected
            ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
            : null,
        onTap: onTap,
      ),
    );
  }
}
