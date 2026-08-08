import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.dart';

final class SharedPreferencesAppPreferences implements AppPreferences {
  const SharedPreferencesAppPreferences(this._preferences);

  final SharedPreferences _preferences;

  @override
  String? getString(String key) => _preferences.getString(key);

  @override
  bool? getBool(String key) => _preferences.getBool(key);

  @override
  int? getInt(String key) => _preferences.getInt(key);

  @override
  double? getDouble(String key) => _preferences.getDouble(key);

  @override
  Future<bool> setString(String key, String value) =>
      _preferences.setString(key, value);

  @override
  Future<bool> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  @override
  Future<bool> setInt(String key, int value) => _preferences.setInt(key, value);

  @override
  Future<bool> setDouble(String key, double value) =>
      _preferences.setDouble(key, value);

  @override
  Future<bool> remove(String key) => _preferences.remove(key);
}
