import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/data/models/task_model.dart';
import 'package:task_flow/domain/repositories/auth_repository.dart';
import 'package:task_flow/domain/repositories/local_storage_repository.dart';
import 'package:task_flow/presentation/auth/login/login_screen.dart';
import 'package:task_flow/presentation/auth/register/register_screen.dart';
import 'package:task_flow/presentation/home/home_screen.dart';
import 'package:task_flow/presentation/splash/splash_screen.dart';
import 'package:task_flow/presentation/task/add_edit_task_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(
            authRepository: context.read<AuthRepository>(),
            localStorage: context.read<LocalStorageRepository>(),
          ),
        );

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.addTask:
        return MaterialPageRoute(builder: (_) => const AddEditTaskScreen());

      case AppRoutes.editTask:
        final task = settings.arguments as Task?;
        return MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
