import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Storage service abstraction for local user preferences and cached data.
class LocalStorageService {
  // Simple in-memory fallback cache (can be swapped for Hive/SharedPrefs)
  final Map<String, dynamic> _cache = {};

  Future<void> setString(String key, String value) async {
    _cache[key] = value;
  }

  String? getString(String key) {
    return _cache[key] as String?;
  }

  Future<void> setBool(String key, bool value) async {
    _cache[key] = value;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return (_cache[key] as bool?) ?? defaultValue;
  }

  Future<void> clear() async {
    _cache.clear();
  }
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});
