import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:task_flow/core/errors/exceptions.dart';

class WeatherApiService {
  final String _baseUrl;
  final String _apiKey;

  WeatherApiService()
    : _baseUrl =
          dotenv.env['WEATHER_API_BASE_URL'] ??
          'https://api.openweathermap.org/data/2.5',
      _apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  Future<Map<String, dynamic>> getWeatherByCity(String cityName) async {
    if (_apiKey.isEmpty) {
      throw WeatherException(
        'API key not configured. Please add WEATHER_API_KEY to .env file',
      );
    }

    final url = Uri.parse(
      '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw WeatherException('City not found. Please check the city name.');
      } else if (response.statusCode == 401) {
        throw WeatherException(
          'Invalid API key. Please check your configuration.',
        );
      } else {
        throw WeatherException(
          'Failed to fetch weather data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is WeatherException) {
        rethrow;
      }
      throw WeatherException(
        'Network error. Please check your internet connection.',
      );
    }
  }

  Future<Map<String, dynamic>> getWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    if (_apiKey.isEmpty) {
      throw WeatherException(
        'API key not configured. Please add WEATHER_API_KEY to .env file',
      );
    }

    final url = Uri.parse(
      '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        throw WeatherException(
          'Invalid API key. Please check your configuration.',
        );
      } else {
        throw WeatherException(
          'Failed to fetch weather data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is WeatherException) {
        rethrow;
      }
      throw WeatherException(
        'Network error. Please check your internet connection.',
      );
    }
  }
}
