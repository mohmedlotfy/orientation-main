import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api/auth_api.dart';
import '../services/firebase/google_auth_service.dart';
import '../utils/local_storage.dart';

class AuthController extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  // State variables
  bool _isLoading = false;
  AppUser? _user;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  AppUser? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Set error message
  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _authApi.login(
        email: email,
        password: password,
      );

      if (response['success'] == true) {
        final userData = response['data']['user'];
        final token = response['data']['token'];

        // Create user model
        _user = AppUser.fromJson(userData);

        // Save token and user data to local storage
        await LocalStorage.saveToken(token);
        await LocalStorage.saveUserId(_user!.id);
        await LocalStorage.saveUserEmail(_user!.email);

        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Login with Google
  Future<bool> loginWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      // Sign in with Google
      final appUser = await _googleAuthService.signInWithGoogle();

      _user = appUser;

      // Save user data to local storage
      // Note: For Firebase Auth, token management is handled by Firebase
      await LocalStorage.saveUserId(appUser.id);
      await LocalStorage.saveUserEmail(appUser.email);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Google sign-in failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _authApi.register(
        username: username,
        email: email,
        password: password,
        phone: phone,
      );

      if (response['success'] == true) {
        final userData = response['data']['user'];
        final token = response['data']['token'];

        // Create user model
        _user = AppUser.fromJson(userData);

        // Save token and user data to local storage
        await LocalStorage.saveToken(token);
        await LocalStorage.saveUserId(_user!.id);
        await LocalStorage.saveUserEmail(_user!.email);

        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Registration failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _setLoading(true);

      // Logout from API
      await _authApi.logout();

      // Sign out from Google if signed in
      if (_googleAuthService.isSignedIn()) {
        await _googleAuthService.signOut();
      }

      // Clear local storage
      await LocalStorage.clear();

      // Clear user state
      _user = null;
      _setError(null);

      _setLoading(false);
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Check and restore session on app start
  Future<bool> checkAuthStatus() async {
    try {
      _setLoading(true);

      // Check if user is logged in via Google
      if (_googleAuthService.isSignedIn()) {
        _user = _googleAuthService.getCurrentAppUser();
        _setLoading(false);
        return true;
      }

      // Check if token exists in local storage
      final token = await LocalStorage.getToken();
      if (token != null && token.isNotEmpty) {
        final userId = await LocalStorage.getUserId();
        final userEmail = await LocalStorage.getUserEmail();

        if (userId != null && userEmail != null) {
          _user = AppUser(id: userId, email: userEmail);
          _setLoading(false);
          return true;
        }
      }

      _setLoading(false);
      return false;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  /// Request password reset
  Future<bool> forgotPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _authApi.forgotPassword(email: email);

      _setLoading(false);
      return response['success'] == true;
    } catch (e) {
      _setError('Failed to send reset email: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Verify OTP code
  Future<String?> verifyOtp(String email, String otp) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _authApi.verifyOtp(email: email, otp: otp);

      _setLoading(false);

      if (response['success'] == true) {
        return response['data']['reset_token'];
      }
      return null;
    } catch (e) {
      _setError('OTP verification failed: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }

  /// Reset password
  Future<bool> resetPassword(String resetToken, String newPassword) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _authApi.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
      );

      _setLoading(false);
      return response['success'] == true;
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
}

