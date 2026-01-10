import 'package:flutter/material.dart';
import 'package:task_flow/core/errors/exceptions.dart';
import 'package:task_flow/data/models/task_model.dart';
import 'package:task_flow/domain/entities/task_entity.dart';
import 'package:task_flow/domain/repositories/auth_repository.dart';
import 'package:task_flow/domain/repositories/task_repository.dart';

/// ViewModel for Add/Edit Task screen with Firestore integration
class AddEditTaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final AuthRepository _authRepository;

  AddEditTaskViewModel({
    required TaskRepository taskRepository,
    required AuthRepository authRepository,
  }) : _taskRepository = taskRepository,
       _authRepository = authRepository;

  Task? _task;
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _dueTime = const TimeOfDay(hour: 18, minute: 30);
  String _priority = 'None';
  bool _isLoading = false;
  String? _errorMessage;

  Task? get task => _task;
  String get title => _title;
  String get description => _description;
  DateTime get dueDate => _dueDate;
  TimeOfDay get dueTime => _dueTime;
  String get priority => _priority;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isEditMode => _task != null;

  /// Initialize with existing task for edit mode
  void initializeWithTask(Task task) {
    _task = task;
    _title = task.title;
    _description = task.description;
    _dueDate = task.dueDate;
    _dueTime = TimeOfDay(hour: task.dueDate.hour, minute: task.dueDate.minute);
    _priority = task.priority;
    notifyListeners();
  }

  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void setDueDate(DateTime value) {
    _dueDate = value;
    notifyListeners();
  }

  void setDueTime(TimeOfDay value) {
    _dueTime = value;
    notifyListeners();
  }

  void setPriority(String value) {
    _priority = value;
    notifyListeners();
  }

  /// Get combined date and time
  DateTime get combinedDateTime {
    return DateTime(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
      _dueTime.hour,
      _dueTime.minute,
    );
  }

  /// Save task to Firestore
  Future<void> saveTask(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get current user
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        throw AuthException('User not authenticated');
      }

      final now = DateTime.now();
      final taskEntity = TaskEntity(
        id: isEditMode
            ? _task!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        title: _title,
        description: _description,
        dueDate: combinedDateTime,
        priority: _priority,
        isCompleted: isEditMode ? _task!.isCompleted : false,
        createdAt: isEditMode
            ? now
            : now, // Will use existing createdAt in update
        updatedAt: now,
      );

      if (isEditMode) {
        await _taskRepository.updateTask(taskEntity);
      } else {
        await _taskRepository.createTask(taskEntity);
      }

      _isLoading = false;
      notifyListeners();

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditMode ? 'Task updated!' : 'Task created!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on TaskException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
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

  /// Delete task from Firestore
  Future<void> deleteTask(BuildContext context) async {
    if (!isEditMode) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get current user
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        throw AuthException('User not authenticated');
      }

      await _taskRepository.deleteTask(_task!.id, user.uid);

      _isLoading = false;
      notifyListeners();

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task deleted!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on TaskException catch (e) {
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

  /// Select date
  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setDueDate(picked);
    }
  }

  /// Select time
  Future<void> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime,
    );

    if (picked != null) {
      setDueTime(picked);
    }
  }
}
