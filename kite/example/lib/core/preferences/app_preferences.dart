abstract interface class AppPreferences {
  String? getString(String key);

  bool? getBool(String key);

  int? getInt(String key);

  double? getDouble(String key);

  Future<bool> setString(String key, String value);

  Future<bool> setBool(String key, bool value);

  Future<bool> setInt(String key, int value);

  Future<bool> setDouble(String key, double value);

  Future<bool> remove(String key);
}
