import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_flow/core/errors/exceptions.dart';
import 'package:task_flow/data/models/task_model.dart';
import 'package:task_flow/domain/entities/task_entity.dart';
import 'package:task_flow/domain/repositories/auth_repository.dart';
import 'package:task_flow/domain/repositories/local_storage_repository.dart';
import 'package:task_flow/domain/repositories/task_repository.dart';


class HomeViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final AuthRepository _authRepository;
  final LocalStorageRepository _localStorage;

  HomeViewModel({
    required TaskRepository taskRepository,
    required AuthRepository authRepository,
    required LocalStorageRepository localStorage,
  }) : _taskRepository = taskRepository,
       _authRepository = authRepository,
       _localStorage = localStorage {
    _initialize();
  }

  List<Task> _tasks = [];
  DateTime? _lastAppOpen;
  String? _userId;
  StreamSubscription<List<TaskEntity>>? _tasksSubscription;
  bool _isLoading = true;
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  DateTime? get lastAppOpen => _lastAppOpen;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Task> get upcomingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  Future<void> _initialize() async {
    try {
      // Get current user
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        _errorMessage = 'User not authenticated';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _userId = user.uid;

      _lastAppOpen = await _localStorage.getLastAppOpenTime();

      _tasksSubscription = _taskRepository
          .getTasks(_userId!)
          .listen(
            (taskEntities) {
              _tasks = taskEntities.map((entity) {
                return Task(
                  id: entity.id,
                  title: entity.title,
                  description: entity.description,
                  dueDate: entity.dueDate,
                  priority: entity.priority,
                  isCompleted: entity.isCompleted,
                );
              }).toList();

              _isLoading = false;
              notifyListeners();
            },
            onError: (error) {
              _errorMessage = 'Failed to load tasks: ${error.toString()}';
              _isLoading = false;
              notifyListeners();
            },
          );
    } catch (e) {
      _errorMessage = 'Failed to initialize: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTaskComplete(String taskId) async {
    if (_userId == null) return;

    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) return;

      final task = _tasks[taskIndex];
      final updatedEntity = TaskEntity(
        id: task.id,
        userId: _userId!,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        isCompleted: !task.isCompleted,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _taskRepository.updateTask(updatedEntity);
    } on TaskException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update task: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    if (_userId == null) return;

    try {
      await _taskRepository.deleteTask(taskId, _userId!);
    } on TaskException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete task: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Navigate to add task screen
  void navigateToAddTask(BuildContext context) {
    Navigator.pushNamed(context, '/add-task');
  }

  /// Navigate to edit task screen
  void navigateToEditTask(BuildContext context, Task task) {
    Navigator.pushNamed(context, '/edit-task', arguments: task);
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }
}
