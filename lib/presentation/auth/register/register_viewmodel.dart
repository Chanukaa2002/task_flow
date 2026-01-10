import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool get isLoading => _isLoading;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  /// Validate if passwords match
  bool validatePasswords() {
    return _password == _confirmPassword;
  }

  /// Register method - placeholder for future Firebase auth
  Future<void> register(BuildContext context) async {
    if (!validatePasswords()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // TODO: Implement Firebase authentication
    // For now, navigate back to login
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please login.')),
      );
    }
  }
}
