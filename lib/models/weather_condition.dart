import 'package:flutter/material.dart';

class WeatherCondition {
  const WeatherCondition(this.description, this.icon);

  final String description;
  final IconData icon;

  factory WeatherCondition.fromCode(int code) => switch (code) {
    0 => const WeatherCondition('Cerah', Icons.wb_sunny),
    1 => const WeatherCondition(
      'Sebagian besar cerah',
      Icons.wb_sunny_outlined,
    ),
    2 => const WeatherCondition('Berawan sebagian', Icons.cloud_queue),
    3 => const WeatherCondition('Berawan', Icons.cloud),
    45 || 48 => const WeatherCondition('Berkabut', Icons.foggy),
    51 || 53 || 55 => const WeatherCondition('Gerimis', Icons.grain),
    56 || 57 => const WeatherCondition('Gerimis beku', Icons.ac_unit),
    61 || 63 || 65 => const WeatherCondition('Hujan', Icons.water_drop),
    66 || 67 => const WeatherCondition('Hujan beku', Icons.ac_unit),
    71 || 73 || 75 || 77 => const WeatherCondition('Salju', Icons.ac_unit),
    80 || 81 || 82 => const WeatherCondition('Hujan deras', Icons.water_drop),
    85 || 86 => const WeatherCondition('Hujan salju', Icons.ac_unit),
    95 => const WeatherCondition('Badai petir', Icons.thunderstorm),
    96 || 99 => const WeatherCondition(
      'Badai petir dan hujan es',
      Icons.thunderstorm,
    ),
    _ => const WeatherCondition('Kondisi tidak diketahui', Icons.help_outline),
  };
}
