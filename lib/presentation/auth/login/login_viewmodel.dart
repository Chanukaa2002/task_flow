import 'package:flutter/material.dart';
import 'package:task_flow/core/errors/exceptions.dart';
import 'package:task_flow/domain/repositories/auth_repository.dart';
import 'package:task_flow/domain/repositories/local_storage_repository.dart';

/// ViewModel for Login screen with Firebase Auth
class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LocalStorageRepository _localStorage;

  LoginViewModel({
    required AuthRepository authRepository,
    required LocalStorageRepository localStorage,
  }) : _authRepository = authRepository,
       _localStorage = localStorage;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Login with email and password
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Sign in with Firebase
      await _authRepository.signIn(email, password);

      // Save login state
      await _localStorage.saveLoginState(true);

      // Save last app open time
      await _localStorage.saveLastAppOpenTime(DateTime.now());

      _isLoading = false;
      notifyListeners();

      // Navigate to home screen
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on AuthException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred';
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Navigate to register screen
  void navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
