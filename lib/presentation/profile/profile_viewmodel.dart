import 'package:flutter/material.dart';
import 'package:task_flow/core/errors/exceptions.dart';
import 'package:task_flow/domain/repositories/auth_repository.dart';
import 'package:task_flow/domain/repositories/local_storage_repository.dart';

/// ViewModel for Profile screen with Firebase Auth
class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LocalStorageRepository _localStorage;

  ProfileViewModel({
    required AuthRepository authRepository,
    required LocalStorageRepository localStorage,
  }) : _authRepository = authRepository,
       _localStorage = localStorage;

  String _userEmail = '';
  bool _isLoading = false;

  String get userEmail => _userEmail;
  bool get isLoading => _isLoading;

  /// Get user email from Firebase
  Future<void> getUserEmail() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _userEmail = user.email;
        notifyListeners();
      }
    } catch (e) {
      _userEmail = 'Error loading email';
      notifyListeners();
    }
  }

  /// Logout user
  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Sign out from Firebase
      await _authRepository.signOut();

      // Clear local storage
      await _localStorage.clearAll();

      _isLoading = false;
      notifyListeners();

      // Navigate to login screen
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on AuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
