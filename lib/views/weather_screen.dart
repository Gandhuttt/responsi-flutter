import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../models/weather.dart';
import '../models/weather_condition.dart';
import '../viewmodels/weather_view_model.dart';
import 'location_search_screen.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  Future<void> _chooseLocation(BuildContext context) async {
    final location = await Navigator.of(context).push<Location>(
      MaterialPageRoute(builder: (_) => const LocationSearchScreen()),
    );
    if (context.mounted && location != null) {
      context.read<WeatherViewModel>().load(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca'),
        actions: [
          IconButton(
            tooltip: 'Cari lokasi',
            onPressed: () => _chooseLocation(context),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (vm.status) {
          WeatherStatus.initial => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Cari lokasi untuk melihat cuaca.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _chooseLocation(context),
                    icon: const Icon(Icons.search),
                    label: const Text('Cari lokasi'),
                  ),
                ],
              ),
            ),
          ),
          WeatherStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
          WeatherStatus.empty => const Center(
            child: Text('Prakiraan cuaca tidak tersedia.'),
          ),
          WeatherStatus.error => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Gagal mengambil data cuaca.'),
                TextButton(
                  onPressed: () => vm.load(vm.location!),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
          WeatherStatus.success => _WeatherDetails(
            location: vm.location!,
            weather: vm.weather!,
          ),
        },
      ),
    );
  }
}

class _WeatherDetails extends StatelessWidget {
  const _WeatherDetails({required this.location, required this.weather});

  final Location location;
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final condition = WeatherCondition.fromCode(current.weatherCode);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(location.name, style: theme.textTheme.headlineMedium),
        Text(
          [
            location.admin1,
            location.country,
          ].whereType<String>().where((part) => part.isNotEmpty).join(', '),
        ),
        const SizedBox(height: 24),
        Center(
          child: Icon(
            condition.icon,
            size: 72,
            color: theme.colorScheme.primary,
          ),
        ),
        Center(
          child: Text(
            '${current.temperature.toStringAsFixed(1)} °C',
            style: theme.textTheme.displayMedium,
          ),
        ),
        Center(
          child: Text(condition.description, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _detail(
                  'Terasa seperti',
                  '${current.apparentTemperature.toStringAsFixed(1)} °C',
                ),
                _detail('Kelembapan', '${current.relativeHumidity}%'),
                _detail(
                  'Kecepatan angin',
                  '${current.windSpeed.toStringAsFixed(1)} km/jam',
                ),
                _detail(
                  'Curah hujan',
                  '${current.precipitation.toStringAsFixed(1)} mm',
                ),
                _detail(
                  'Peluang hujan hari ini',
                  _probability(weather.daily.first.precipitationProbabilityMax),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Prakiraan harian', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        ...weather.daily.map((day) {
          final forecastCondition = WeatherCondition.fromCode(day.weatherCode);
          return Card(
            child: ListTile(
              leading: Icon(forecastCondition.icon),
              title: Text(
                '${day.date.day}/${day.date.month}/${day.date.year} · ${forecastCondition.description}',
              ),
              subtitle: Text(
                'Peluang hujan: ${_probability(day.precipitationProbabilityMax)}',
              ),
              trailing: Text(
                '${day.minimumTemperature.toStringAsFixed(0)}° / ${day.maximumTemperature.toStringAsFixed(0)}°',
              ),
            ),
          );
        }),
      ],
    );
  }

  static String _probability(int? value) =>
      value == null ? 'Tidak tersedia' : '$value%';

  Widget _detail(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value),
      ],
    ),
  );
}
