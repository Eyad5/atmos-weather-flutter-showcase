import 'package:flutter/material.dart';
import 'package:weather_offline_app/app/app.dart';
import 'package:weather_offline_app/config/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const AtmosWeatherApp());
}
