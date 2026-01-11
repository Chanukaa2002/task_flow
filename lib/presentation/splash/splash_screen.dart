import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_flow/core/config/app_colors.dart';
import 'package:task_flow/domain/repositories/auth_repository.dart';
import 'package:task_flow/domain/repositories/local_storage_repository.dart';

/// Splash screen for app initialization and auth state checking
class SplashScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final LocalStorageRepository localStorage;

  const SplashScreen({
    super.key,
    required this.authRepository,
    required this.localStorage,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      // Check if user is logged in
      final isLoggedIn = await widget.localStorage.getLoginState();
      final currentUser = await widget.authRepository.getCurrentUser();

      if (isLoggedIn && currentUser != null) {
        // Save current time as last app open
        await widget.localStorage.saveLastAppOpenTime(DateTime.now());

        // Navigate to home
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Clear login state if user is not authenticated
        await widget.localStorage.saveLoginState(false);

        // Navigate to login
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      // On error, navigate to login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.list_alt,
                size: 80,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 24),

            // App Name
            const Text(
              'TaskFlow',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            const Text(
              'Manage your tasks efficiently',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textWhite,
                fontWeight: FontWeight.w300,
              ),
            ),

            const SizedBox(height: 48),

            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
            ),
          ],
        ),
      ),
    );
  }
}
