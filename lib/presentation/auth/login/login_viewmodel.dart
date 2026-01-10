import 'package:flutter/material.dart';
/// Placeholder ViewModel for Login screen
class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String _email = '';
  String _password = '';

  bool get isLoading => _isLoading;
  String get email => _email;
  String get password => _password;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  /// Login method - placeholder for future Firebase auth
  Future<void> login(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // TODO: Implement Firebase authentication
    // For now, navigate to home screen
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  /// Navigate to register screen
  void navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }
}
