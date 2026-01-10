import 'package:flutter/material.dart';
import 'package:task_flow/data/models/task_model.dart';

/// Placeholder ViewModel for Add/Edit Task screen
class AddEditTaskViewModel extends ChangeNotifier {
  Task? _task;
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _dueTime = const TimeOfDay(hour: 18, minute: 30);
  String _priority = 'None';

  Task? get task => _task;
  String get title => _title;
  String get description => _description;
  DateTime get dueDate => _dueDate;
  TimeOfDay get dueTime => _dueTime;
  String get priority => _priority;

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

  /// Save task - placeholder for future Firebase implementation
  Future<void> saveTask(BuildContext context) async {
    // TODO: Implement Firebase save
    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditMode ? 'Task updated!' : 'Task created!')),
      );
    }
  }

  /// Delete task - placeholder for future Firebase implementation
  Future<void> deleteTask(BuildContext context) async {
    // TODO: Implement Firebase delete
    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task deleted!')));
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
