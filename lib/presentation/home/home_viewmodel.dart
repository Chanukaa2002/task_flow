import 'package:flutter/material.dart';
import 'package:task_flow/data/models/task_model.dart';

/// Placeholder ViewModel for Home screen
class HomeViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  DateTime _lastAppOpen = DateTime.now();

  List<Task> get tasks => _tasks;
  DateTime get lastAppOpen => _lastAppOpen;

  List<Task> get upcomingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  HomeViewModel() {
    _loadMockData();
  }

  /// Load mock data for UI demonstration
  void _loadMockData() {
    _tasks = [
      Task(
        id: '1',
        title: 'Exercise for 30 minutes',
        description: 'Go for a run or do a home workout.',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: 'Low',
        isCompleted: false,
      ),
      Task(
        id: '2',
        title: 'Grocery Shopping',
        description: 'Buy milk, eggs, bread, and vegetables for the week.',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        priority: 'None',
        isCompleted: false,
      ),
      Task(
        id: '3',
        title: 'Finish Project Report',
        description:
            'Complete the final report for the Q2 project, including data analysis and conclusions.',
        dueDate: DateTime.now().add(const Duration(days: 4)),
        priority: 'High',
        isCompleted: false,
      ),
      Task(
        id: '4',
        title: 'Pay electricity bill',
        description: '',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        priority: 'High',
        isCompleted: false,
      ),
      Task(
        id: '5',
        title: 'Read Chapter 3 of book',
        description: 'Read "The Lean Startup" chapter 3.',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: 'Low',
        isCompleted: false,
      ),
      Task(
        id: '6',
        title: 'Call John about meeting',
        description: 'Confirm the meeting details and agenda for next Tuesday.',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        priority: 'Medium',
        isCompleted: true,
      ),
    ];

    // Set last app open time (mock - from shared preferences in real app)
    _lastAppOpen = DateTime(2023, 11, 6, 10, 30);

    notifyListeners();
  }

  /// Toggle task completion status
  void toggleTaskComplete(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }

  /// Delete task
  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  /// Navigate to add task screen
  void navigateToAddTask(BuildContext context) {
    Navigator.pushNamed(context, '/add-task');
  }

  /// Navigate to edit task screen
  void navigateToEditTask(BuildContext context, Task task) {
    Navigator.pushNamed(context, '/edit-task', arguments: task);
  }
}
