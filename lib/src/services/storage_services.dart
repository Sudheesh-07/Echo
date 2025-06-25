import 'package:get_storage/get_storage.dart';

/// This class is used to store the token in the local storage
class StorageService {
  static final GetStorage _storage = GetStorage();
  static const String _tokenKey = 'auth_token';

/// This function Stores the token in the local storage
  static Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

/// This function returns the token from the local storage
  static String? getToken() => _storage.read(_tokenKey);

/// This function clears the token from the local storage
  static Future<void> clearToken() async {
    await _storage.remove(_tokenKey);
  }
}
