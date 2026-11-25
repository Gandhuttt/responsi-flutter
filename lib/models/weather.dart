class CurrentWeather {
  const CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
    temperature: (json['temperature_2m'] as num).toDouble(),
    apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
    relativeHumidity: (json['relative_humidity_2m'] as num).toInt(),
    precipitation: (json['precipitation'] as num).toDouble(),
    weatherCode: (json['weather_code'] as num).toInt(),
    windSpeed: (json['wind_speed_10m'] as num).toDouble(),
  );
}

class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maximumTemperature,
    required this.minimumTemperature,
    required this.precipitationProbabilityMax,
  });

  final DateTime date;
  final int weatherCode;
  final double maximumTemperature;
  final double minimumTemperature;
  final int? precipitationProbabilityMax;

  static List<DailyForecast> fromJson(Map<String, dynamic> json) {
    final dates = json['time'] as List<dynamic>;
    final codes = json['weather_code'] as List<dynamic>;
    final maxima = json['temperature_2m_max'] as List<dynamic>;
    final minima = json['temperature_2m_min'] as List<dynamic>;
    final probabilities =
        json['precipitation_probability_max'] as List<dynamic>;
    if ([
      codes,
      maxima,
      minima,
      probabilities,
    ].any((values) => values.length != dates.length)) {
      throw const FormatException(
        'Daily forecast arrays have different lengths',
      );
    }
    return List.generate(
      dates.length,
      (index) => DailyForecast(
        date: DateTime.parse(dates[index] as String),
        weatherCode: (codes[index] as num).toInt(),
        maximumTemperature: (maxima[index] as num).toDouble(),
        minimumTemperature: (minima[index] as num).toDouble(),
        precipitationProbabilityMax: (probabilities[index] as num?)?.toInt(),
      ),
    );
  }
}

class Weather {
  const Weather({required this.current, required this.daily});

  final CurrentWeather current;
  final List<DailyForecast> daily;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    current: CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
    daily: DailyForecast.fromJson(json['daily'] as Map<String, dynamic>),
  );
}
