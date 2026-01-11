abstract class LocalStorageRepository {
  Future<void> saveLoginState(bool isLoggedIn);
  Future<bool> getLoginState();
  Future<void> saveLastAppOpenTime(DateTime time);
  Future<DateTime?> getLastAppOpenTime();
  Future<void> clearAll();
}
