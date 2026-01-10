import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_flow/core/config/app_theme.dart';
import 'package:task_flow/core/routes/app_routes.dart';
import 'package:task_flow/data/repositories/firebase_auth_repository.dart';
import 'package:task_flow/data/repositories/firestore_task_repository.dart';
import 'package:task_flow/data/repositories/shared_prefs_repository.dart';
import 'package:task_flow/domain/repositories/auth_repository.dart';
import 'package:task_flow/domain/repositories/local_storage_repository.dart';
import 'package:task_flow/domain/repositories/task_repository.dart';
import 'package:task_flow/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repository providers
        Provider<AuthRepository>(
          create: (_) => FirebaseAuthRepository(FirebaseAuth.instance),
        ),
        Provider<TaskRepository>(
          create: (_) => FirestoreTaskRepository(FirebaseFirestore.instance),
        ),
        Provider<LocalStorageRepository>(
          create: (_) => SharedPrefsRepository(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'TaskFlow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
