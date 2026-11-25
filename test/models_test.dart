import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_flutter/models/location.dart';
import 'package:responsi_flutter/models/weather.dart';

void main() {
  test(
    'location survives local storage round trip without optional region',
    () {
      final location = Location.fromJson({
        'id': 1,
        'name': 'Bandung',
        'latitude': -6.9,
        'longitude': 107,
      });
      final restored = Location.fromJson(location.toJson());
      expect(restored.name, 'Bandung');
      expect(restored.latitude, -6.9);
      expect(restored.longitude, 107.0);
      expect(restored.country, isNull);
    },
  );

  test('weather parses current values and aligns daily forecast arrays', () {
    final weather = Weather.fromJson({
      'current': {
        'temperature_2m': 28,
        'apparent_temperature': 30.5,
        'relative_humidity_2m': 80,
        'precipitation': 0,
        'weather_code': 3,
        'wind_speed_10m': 5.4,
      },
      'daily': {
        'time': ['2026-11-25', '2026-11-26'],
        'weather_code': [3, 61],
        'temperature_2m_max': [30, 27.5],
        'temperature_2m_min': [22, 21],
        'precipitation_probability_max': [null, 85],
      },
    });
    expect(weather.current.apparentTemperature, 30.5);
    expect(weather.current.relativeHumidity, 80);
    expect(weather.daily[0].precipitationProbabilityMax, isNull);
    expect(weather.daily[1].date, DateTime(2026, 11, 26));
    expect(weather.daily[1].weatherCode, 61);
    expect(weather.daily[1].maximumTemperature, 27.5);
    expect(weather.daily[1].minimumTemperature, 21);
    expect(weather.daily[1].precipitationProbabilityMax, 85);
  });

  test('daily forecast rejects mismatched arrays', () {
    expect(
      () => DailyForecast.fromJson({
        'time': ['2026-11-25'],
        'weather_code': [],
        'temperature_2m_max': [30],
        'temperature_2m_min': [22],
        'precipitation_probability_max': [80],
      }),
      throwsFormatException,
    );
  });
}
