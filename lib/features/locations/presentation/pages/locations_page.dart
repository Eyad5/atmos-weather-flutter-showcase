import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_offline_app/core/design_system/app_spacing.dart';
import 'package:weather_offline_app/features/locations/presentation/cubit/locations_cubit.dart';
import 'package:weather_offline_app/features/locations/presentation/cubit/locations_state.dart';
import 'package:weather_offline_app/features/weather/presentation/cubit/weather_cubit.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().length >= 2) {
      context.read<LocationsCubit>().searchCities(query);
    } else if (query.isEmpty) {
      context.read<LocationsCubit>().clearSearch();
    }
  }

  void _selectCity(String cityName) {
    _searchController.clear();
    setState(() => _isSearching = false);
    context.read<LocationsCubit>().clearSearch();
    context.read<WeatherCubit>().searchWeather(cityName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search cities...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: _onSearchChanged,
              )
            : const Text('Locations'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search_rounded),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<LocationsCubit>().clearSearch();
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<LocationsCubit, LocationsState>(
        builder: (context, state) {
          if (state is LocationsSearching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LocationsSearchResults) {
            return _buildSearchResults(state, theme);
          }

          if (state is LocationsSearchError) {
            return Center(
              child: Padding(
                padding: AppSpacing.paddingAllXl,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 40,
                      color: theme.colorScheme.error,
                    ),
                    AppSpacing.verticalMd,
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return _buildLocationsList(state, theme);
        },
      ),
    );
  }

  Widget _buildSearchResults(LocationsSearchResults state, ThemeData theme) {
    if (state.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
            ),
            AppSpacing.verticalMd,
            Text(
              'No cities found',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppSpacing.paddingHorizontalLg,
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final result = state.results[index];
        final isSaved = context.read<LocationsCubit>().isFavorite(result.name);
        return ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: Text(result.name),
          subtitle: Text(
            [
              result.region,
              result.country,
            ].where((s) => s.isNotEmpty).join(', '),
            style: theme.textTheme.bodySmall,
          ),
          trailing: IconButton(
            icon: Icon(
              isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isSaved ? theme.colorScheme.primary : null,
            ),
            onPressed: () {
              if (isSaved) {
                context.read<LocationsCubit>().removeFavorite(result.name);
              } else {
                context.read<LocationsCubit>().addFavorite(result.name);
              }
            },
          ),
          onTap: () => _selectCity(result.name),
        );
      },
    );
  }

  Widget _buildLocationsList(LocationsState state, ThemeData theme) {
    final saved = state.savedLocations;
    final recent = state.recentSearches;
    final currentCity = context.read<WeatherCubit>().lastSearchedCity;

    if (saved.isEmpty && recent.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingAllXl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.explore_outlined,
                size: 64,
                color: theme.colorScheme.onSurfaceVariant.withAlpha(80),
              ),
              AppSpacing.verticalLg,
              Text(
                'Explore Cities',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.verticalSm,
              Text(
                'Search and save your favorite locations\nfor quick access.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: AppSpacing.paddingAllLg,
      children: [
        if (saved.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Saved Locations',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ...saved.map((city) {
            final isActive = city.toLowerCase() == currentCity.toLowerCase();
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: isActive ? theme.colorScheme.primaryContainer : null,
              child: ListTile(
                leading: Icon(
                  isActive
                      ? Icons.location_on_rounded
                      : Icons.location_on_outlined,
                  color: isActive ? theme.colorScheme.onPrimaryContainer : null,
                ),
                title: Text(
                  city,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.w600 : null,
                    color: isActive
                        ? theme.colorScheme.onPrimaryContainer
                        : null,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: isActive
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () =>
                      context.read<LocationsCubit>().removeFavorite(city),
                ),
                onTap: () => _selectCity(city),
              ),
            );
          }),
          AppSpacing.verticalXl,
        ],
        if (recent.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Recent Searches',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: recent
                .map(
                  (city) => ActionChip(
                    label: Text(city),
                    onPressed: () => _selectCity(city),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
