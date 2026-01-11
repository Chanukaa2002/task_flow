import 'package:task_flow/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getWeatherByCity(String cityName);
  Future<WeatherEntity> getWeatherByCoordinates(double lat, double lon);
}
