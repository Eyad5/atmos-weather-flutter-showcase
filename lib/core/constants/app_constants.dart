class AppConstants {
  AppConstants._();

  // API Configuration
  static const String weatherApiBaseUrl = 'https://api.weatherapi.com/v1/';

  // API key provided at build time: --dart-define=WEATHER_API_KEY=your_key
  static const String weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');

  // Endpoints
  static const String forecastEndpoint = 'forecast.json';
  static const String searchEndpoint = 'search.json';

  // Forecast
  static const int forecastDays = 3;

  // Timeouts (milliseconds)
  static const int connectionTimeout = 15000;
  static const int receiveTimeout = 15000;

  // Cache Keys
  static const String cachedWeatherKey = 'cached_weather';
  static const String recentSearchesKey = 'recent_searches';
  static const String savedLocationsKey = 'saved_locations';
  static const String selectedCityKey = 'selected_city';
  static const String themePreferenceKey = 'theme_preference';
  static const String temperatureUnitKey = 'temperature_unit';
  static const String windUnitKey = 'wind_unit';

  // Limits
  static const int maxRecentSearches = 5;
  static const int maxSavedLocations = 10;

  // App Info
  static const String appName = 'Atmos Weather';
  static const String appVersion = '2.0.0';
  static const String developerName = 'Eyad Taha';
  static const String githubUrl = 'https://github.com/Eyad5';
}
