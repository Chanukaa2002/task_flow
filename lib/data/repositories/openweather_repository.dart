import 'package:task_flow/core/errors/exceptions.dart';
import 'package:task_flow/data/models/weather_model.dart';
import 'package:task_flow/data/services/weather_api_service.dart';
import 'package:task_flow/domain/entities/weather_entity.dart';
import 'package:task_flow/domain/repositories/weather_repository.dart';

class OpenWeatherRepository implements WeatherRepository {
  final WeatherApiService _apiService;

  OpenWeatherRepository(this._apiService);

  @override
  Future<WeatherEntity> getWeatherByCity(String cityName) async {
    try {
      final json = await _apiService.getWeatherByCity(cityName);
      final model = WeatherModel.fromJson(json);
      return model.toEntity();
    } on WeatherException {
      rethrow;
    } catch (e) {
      throw WeatherException('Failed to fetch weather data: ${e.toString()}');
    }
  }

  @override
  Future<WeatherEntity> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final json = await _apiService.getWeatherByCoordinates(lat, lon);
      final model = WeatherModel.fromJson(json);
      return model.toEntity();
    } on WeatherException {
      rethrow;
    } catch (e) {
      throw WeatherException('Failed to fetch weather data: ${e.toString()}');
    }
  }
}
