import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/weather_service.dart';
import 'viewmodels/weather_view_model.dart';
import 'views/weather_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => WeatherViewModel(WeatherService()),
    child: MaterialApp(
      title: 'Cuaca',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const WeatherScreen(),
    ),
  );
}
