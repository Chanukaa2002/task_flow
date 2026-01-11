class WeatherEntity {
  final double temperature;
  final double feelsLike;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final String cityName;
  final String icon;

  WeatherEntity({
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.cityName,
    required this.icon,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeatherEntity &&
        other.temperature == temperature &&
        other.feelsLike == feelsLike &&
        other.condition == condition &&
        other.description == description &&
        other.humidity == humidity &&
        other.windSpeed == windSpeed &&
        other.cityName == cityName &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return temperature.hashCode ^
        feelsLike.hashCode ^
        condition.hashCode ^
        description.hashCode ^
        humidity.hashCode ^
        windSpeed.hashCode ^
        cityName.hashCode ^
        icon.hashCode;
  }
}
