import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flow/core/errors/exceptions.dart';
import 'package:task_flow/domain/repositories/local_storage_repository.dart';

class SharedPrefsRepository implements LocalStorageRepository {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyLastAppOpen = 'last_app_open_time';

  @override
  Future<void> saveLoginState(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    } catch (e) {
      throw StorageException('Failed to save login state: ${e.toString()}');
    }
  }

  @override
  Future<bool> getLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      throw StorageException('Failed to get login state: ${e.toString()}');
    }
  }

  @override
  Future<void> saveLastAppOpenTime(DateTime time) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLastAppOpen, time.toIso8601String());
    } catch (e) {
      throw StorageException(
        'Failed to save last app open time: ${e.toString()}',
      );
    }
  }

  @override
  Future<DateTime?> getLastAppOpenTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timeString = prefs.getString(_keyLastAppOpen);
      if (timeString == null) return null;
      return DateTime.parse(timeString);
    } catch (e) {
      throw StorageException(
        'Failed to get last app open time: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw StorageException('Failed to clear storage: ${e.toString()}');
    }
  }
}
