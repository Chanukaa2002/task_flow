import 'package:flutter/material.dart';

/// Placeholder ViewModel for Weather screen
class WeatherViewModel extends ChangeNotifier {
  bool _isLoading = true;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  WeatherViewModel() {
    fetchWeather();
  }

  /// Fetch weather data - placeholder for future API implementation
  Future<void> fetchWeather() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Implement weather API integration
    // For now, keep loading state for demonstration
    _isLoading = true;
    notifyListeners();
  }

  /// Get user location - placeholder for future implementation
  Future<void> getLocation() async {
    // TODO: Implement location services
  }
}
