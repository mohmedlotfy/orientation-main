import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ============ TOKEN METHODS ============

  /// Save authentication token
  static Future<bool> saveToken(String token) async {
    final prefs = await _instance;
    return prefs.setString(_tokenKey, token);
  }

  /// Get stored authentication token
  static Future<String?> getToken() async {
    final prefs = await _instance;
    return prefs.getString(_tokenKey);
  }

  /// Check if user is logged in (has token)
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ============ USER DATA METHODS ============

  /// Save user ID
  static Future<bool> saveUserId(String userId) async {
    final prefs = await _instance;
    return prefs.setString(_userIdKey, userId);
  }

  /// Get stored user ID
  static Future<String?> getUserId() async {
    final prefs = await _instance;
    return prefs.getString(_userIdKey);
  }

  /// Save user email
  static Future<bool> saveUserEmail(String email) async {
    final prefs = await _instance;
    return prefs.setString(_userEmailKey, email);
  }

  /// Get stored user email
  static Future<String?> getUserEmail() async {
    final prefs = await _instance;
    return prefs.getString(_userEmailKey);
  }

  // ============ CLEAR METHODS ============

  /// Clear all stored data (logout)
  static Future<bool> clear() async {
    final prefs = await _instance;
    return prefs.clear();
  }

  /// Clear only authentication data
  static Future<void> clearAuth() async {
    final prefs = await _instance;
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
  }
}

