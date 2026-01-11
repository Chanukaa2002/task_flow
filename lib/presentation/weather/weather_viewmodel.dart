import 'package:flutter/material.dart';
import 'package:task_flow/core/errors/exceptions.dart';
import 'package:task_flow/domain/entities/weather_entity.dart';
import 'package:task_flow/domain/repositories/weather_repository.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _weatherRepository;

  WeatherViewModel({required WeatherRepository weatherRepository})
    : _weatherRepository = weatherRepository {
    fetchWeather('Colombo');
  }

  WeatherEntity? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  WeatherEntity? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(String cityName) async {
    if (cityName.trim().isEmpty) {
      _errorMessage = 'Please enter a city name';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weather = await _weatherRepository.getWeatherByCity(cityName);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } on WeatherException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      _weather = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _weather = null;
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    if (_weather != null) {
      await fetchWeather(_weather!.cityName);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  IconData getWeatherIcon() {
    if (_weather == null) return Icons.wb_sunny;

    switch (_weather!.condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.cloud_queue;
      default:
        return Icons.wb_sunny;
    }
  }

  Color getWeatherIconColor() {
    if (_weather == null) return Colors.orange;

    switch (_weather!.condition.toLowerCase()) {
      case 'clear':
        return Colors.orange;
      case 'clouds':
        return Colors.grey;
      case 'rain':
        return Colors.blue;
      case 'drizzle':
        return Colors.lightBlue;
      case 'thunderstorm':
        return Colors.deepOrange;
      case 'snow':
        return Colors.lightBlue.shade200;
      case 'mist':
      case 'fog':
      case 'haze':
        return Colors.grey.shade400;
      default:
        return Colors.orange;
    }
  }
}
