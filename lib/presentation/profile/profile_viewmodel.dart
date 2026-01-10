import 'package:flutter/material.dart';

/// Placeholder ViewModel for Profile screen
class ProfileViewModel extends ChangeNotifier {
  String _userEmail = 'user@taskflow.com';

  String get userEmail => _userEmail;

  /// Get user email - placeholder for future Firebase implementation
  Future<void> getUserEmail() async {
    // TODO: Implement Firebase get user email
    await Future.delayed(const Duration(milliseconds: 500));
    _userEmail = 'user@taskflow.com';
    notifyListeners();
  }

  /// Logout - placeholder for future Firebase implementation
  Future<void> logout(BuildContext context) async {
    // TODO: Implement Firebase logout
    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
