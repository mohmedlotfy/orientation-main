import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dio_client.dart';
import '../../models/user_model.dart';

class AuthApi {
  final DioClient _dioClient = DioClient();

  AuthApi() {
    _dioClient.init();
  }


  /// Set the API base URL dynamically
  void setBaseUrl(String url) {
    _dioClient.setBaseUrl(url);
  }

  /// Login with email and password
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      // Save token to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', authResponse.token);
      await prefs.setString('user_id', authResponse.user.id);
      await prefs.setString('user_email', authResponse.user.email);
      await prefs.setString('user_name', authResponse.user.username);
      await prefs.setString('user_role', authResponse.user.role);

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Register with username, email, phone number and password
  Future<AuthResponse> register({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      // Save token to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', authResponse.token);
      await prefs.setString('user_id', authResponse.user.id);
      await prefs.setString('user_email', authResponse.user.email);
      await prefs.setString('user_name', authResponse.user.username);
      await prefs.setString('user_role', authResponse.user.role);

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout and clear stored data
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_role');
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  /// Get stored user info
  Future<Map<String, String?>> getStoredUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString('auth_token'),
      'userId': prefs.getString('user_id'),
      'email': prefs.getString('user_email'),
      'username': prefs.getString('user_name'),
      'role': prefs.getString('user_role') ?? 'user',
      'firstName': prefs.getString('user_first_name'),
      'lastName': prefs.getString('user_last_name'),
    };
  }

  /// Send OTP to email for password reset
  Future<bool> forgotPassword(String email) async {
    try {
      await _dioClient.dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Verify OTP code
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      await _dioClient.dio.post(
        '/auth/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Reset password with new password
  Future<bool> resetPassword(String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('reset_email');
      
      await _dioClient.dio.post(
        '/auth/reset-password',
        data: {
          'email': email,
          'newPassword': newPassword,
        },
      );
      
      // Clear reset data
      await prefs.remove('reset_email');
      await prefs.remove('reset_otp');
      await prefs.remove('otp_verified');
      
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get user profile information
  Future<Map<String, String?>> getUserProfile() async {
    try {
      final response = await _dioClient.dio.get('/auth/profile');
      final firstName = response.data['firstName'] ?? '';
      final lastName = response.data['lastName'] ?? '';
      final email = response.data['email'] ?? '';
      final phoneNumber = response.data['phoneNumber'] ?? '';
      final username = response.data['username'] ?? '';
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      if (firstName.isNotEmpty) {
        await prefs.setString('user_first_name', firstName);
      }
      if (lastName.isNotEmpty) {
        await prefs.setString('user_last_name', lastName);
      }
      if (email.isNotEmpty) {
        await prefs.setString('user_email', email);
      }
      if (phoneNumber.isNotEmpty) {
        await prefs.setString('user_phone', phoneNumber);
      }
      // Update username to reflect first name and last name if available
      if (firstName.isNotEmpty || lastName.isNotEmpty) {
        await prefs.setString('user_name', '$firstName $lastName'.trim());
      } else if (username.isNotEmpty) {
        await prefs.setString('user_name', username);
      }
      
      return {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'username': username,
      };
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        '/auth/profile',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phoneNumber': phoneNumber,
        },
      );
      
      // Ensure email contains @ before saving
      if (!email.contains('@')) {
        throw Exception('Email must contain @ symbol');
      }
      
      // Update local storage with new profile data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_first_name', firstName);
      await prefs.setString('user_last_name', lastName);
      await prefs.setString('user_email', email); // Save email with @
      await prefs.setString('user_phone', phoneNumber);
      // Update username to reflect first name and last name
      await prefs.setString('user_name', '$firstName $lastName');
      
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update password (for logged-in users)
  Future<bool> updatePassword({
    required String newPassword,
  }) async {
    try {
      await _dioClient.dio.put(
        '/auth/password',
        data: {
          'newPassword': newPassword,
        },
      );
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and return user-friendly messages
  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'Unable to connect to server. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'];
        
        if (statusCode == 401) {
          return message ?? 'Invalid email or password.';
        } else if (statusCode == 409) {
          return message ?? 'User already exists.';
        } else if (statusCode == 400) {
          // Handle validation errors
          if (message is List) {
            return message.join('\n');
          }
          return message ?? 'Invalid input. Please check your data.';
        }
        return message ?? 'An error occurred. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
