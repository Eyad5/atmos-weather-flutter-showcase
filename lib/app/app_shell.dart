import 'package:flutter/material.dart';
import 'package:weather_offline_app/core/theme/app_theme.dart';
import 'package:weather_offline_app/features/forecast/presentation/pages/forecast_page.dart';
import 'package:weather_offline_app/features/locations/presentation/pages/locations_page.dart';
import 'package:weather_offline_app/features/settings/presentation/pages/settings_page.dart';
import 'package:weather_offline_app/features/weather/presentation/pages/home_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const _pages = <Widget>[
    HomePage(),
    ForecastPage(),
    LocationsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.gradientBackground(context),
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withAlpha(30),
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (i) => setState(() => _currentIndex = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded),
                label: 'Forecast',
              ),
              NavigationDestination(
                icon: Icon(Icons.place_outlined),
                selectedIcon: Icon(Icons.place_rounded),
                label: 'Locations',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
