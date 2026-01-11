import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_flow/core/errors/exceptions.dart';
import 'package:task_flow/data/models/task_model.dart';
import 'package:task_flow/domain/entities/task_entity.dart';
import 'package:task_flow/domain/repositories/task_repository.dart';

class FirestoreTaskRepository implements TaskRepository {
  final FirebaseFirestore _firestore;

  FirestoreTaskRepository(this._firestore);

  CollectionReference _getTasksCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  @override
  Future<void> createTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await _getTasksCollection(
        task.userId,
      ).doc(task.id).set(taskModel.toFirestore());
    } on FirebaseException catch (e) {
      throw TaskException(_getFirestoreErrorMessage(e.code), code: e.code);
    } catch (e) {
      throw TaskException('Failed to create task: ${e.toString()}');
    }
  }

  @override
  Stream<List<TaskEntity>> getTasks(String userId) {
    try {
      return _getTasksCollection(
        userId,
      ).orderBy('createdAt', descending: true).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return TaskModel.fromFirestore(doc).toEntity();
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw TaskException(_getFirestoreErrorMessage(e.code), code: e.code);
    } catch (e) {
      throw TaskException('Failed to get tasks: ${e.toString()}');
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await _getTasksCollection(
        task.userId,
      ).doc(task.id).update(taskModel.toFirestore());
    } on FirebaseException catch (e) {
      throw TaskException(_getFirestoreErrorMessage(e.code), code: e.code);
    } catch (e) {
      throw TaskException('Failed to update task: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTask(String taskId, String userId) async {
    try {
      await _getTasksCollection(userId).doc(taskId).delete();
    } on FirebaseException catch (e) {
      throw TaskException(_getFirestoreErrorMessage(e.code), code: e.code);
    } catch (e) {
      throw TaskException('Failed to delete task: ${e.toString()}');
    }
  }

  /// Get user-friendly error message from Firestore error code
  String _getFirestoreErrorMessage(String code) {
    switch (code) {
      case 'permission-denied':
        return "You don't have permission to perform this action";
      case 'not-found':
        return 'Task not found';
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again';
      case 'deadline-exceeded':
        return 'Request timeout. Please check your connection';
      default:
        return 'An error occurred. Please try again';
    }
  }
}
