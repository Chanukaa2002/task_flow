import 'package:flutter/material.dart';
import 'package:task_flow/data/models/task_model.dart';
import 'package:task_flow/presentation/auth/login/login_screen.dart';
import 'package:task_flow/presentation/auth/register/register_screen.dart';
import 'package:task_flow/presentation/home/home_screen.dart';
import 'package:task_flow/presentation/task/add_edit_task_screen.dart';

/// App route names
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
}

/// Route generator
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
