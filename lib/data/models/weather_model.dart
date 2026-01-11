import 'package:task_flow/domain/entities/weather_entity.dart';

class WeatherModel {
  final double temperature;
  final double feelsLike;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final String cityName;
  final String icon;

  WeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.cityName,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      condition: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      cityName: json['name'] as String,
      icon: json['weather'][0]['icon'] as String,
    );
  }

  WeatherEntity toEntity() {
    return WeatherEntity(
      temperature: temperature,
      feelsLike: feelsLike,
      condition: condition,
      description: description,
      humidity: humidity,
      windSpeed: windSpeed,
      cityName: cityName,
      icon: icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
      },
      'weather': [
        {'main': condition, 'description': description, 'icon': icon},
      ],
      'wind': {'speed': windSpeed},
      'name': cityName,
    };
  }
}
