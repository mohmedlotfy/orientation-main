import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dio_client.dart';
import '../../models/user_model.dart';

class AuthApi {
  final DioClient _dioClient = DioClient();

  AuthApi() {
    _dioClient.init();
  }

  // TODO: Set to false when backend is ready
  static const bool _devMode = true;

  /// Set the API base URL dynamically
  void setBaseUrl(String url) {
    _dioClient.setBaseUrl(url);
  }

  /// Login with email and password
  Future<AuthResponse> login(String email, String password) async {
    // Dev mode: bypass backend and login directly
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockUser = UserModel(
        id: 'dev-user-001',
        username: email.split('@').first,
        email: email,
        role: 'developer',
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'dev-token-12345');
      await prefs.setString('user_id', mockUser.id);
      await prefs.setString('user_email', mockUser.email);
      await prefs.setString('user_name', mockUser.username);
      await prefs.setString('user_role', mockUser.role);
      
      return AuthResponse(user: mockUser, token: 'dev-token-12345');
    }

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
    // Dev mode: bypass backend and register directly
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockUser = UserModel(
        id: 'dev-user-${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        role: 'user',
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'dev-token-${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString('user_id', mockUser.id);
      await prefs.setString('user_email', mockUser.email);
      await prefs.setString('user_name', mockUser.username);
      await prefs.setString('user_role', mockUser.role);
      if (phoneNumber.isNotEmpty) {
        await prefs.setString('user_phone', phoneNumber);
      }
      
      return AuthResponse(user: mockUser, token: 'dev-token-${DateTime.now().millisecondsSinceEpoch}');
    }

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
    };
  }

  /// Send OTP to email for password reset
  Future<bool> forgotPassword(String email) async {
    // Dev mode: simulate sending OTP
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Store email for later verification
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('reset_email', email);
      await prefs.setString('reset_otp', '1234'); // Dev OTP code
      
      return true;
    }

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
    // Dev mode: verify against stored OTP
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final prefs = await SharedPreferences.getInstance();
      final storedOtp = prefs.getString('reset_otp');
      
      // In dev mode, accept "1234" as valid OTP
      if (otp == '1234' || otp == storedOtp) {
        await prefs.setBool('otp_verified', true);
        return true;
      }
      throw 'Invalid OTP code. Use 1234 for testing.';
    }

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
    // Dev mode: simulate password reset
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final prefs = await SharedPreferences.getInstance();
      final isVerified = prefs.getBool('otp_verified') ?? false;
      
      if (!isVerified) {
        throw 'Please verify OTP first.';
      }
      
      // Clear reset data
      await prefs.remove('reset_email');
      await prefs.remove('reset_otp');
      await prefs.remove('otp_verified');
      
      return true;
    }

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
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      final prefs = await SharedPreferences.getInstance();
      return {
        'firstName': prefs.getString('user_first_name') ?? '',
        'lastName': prefs.getString('user_last_name') ?? '',
        'email': prefs.getString('user_email') ?? '',
        'phoneNumber': prefs.getString('user_phone') ?? '',
        'username': prefs.getString('user_name') ?? '',
      };
    }

    try {
      final response = await _dioClient.dio.get('/auth/profile');
      return {
        'firstName': response.data['firstName'] ?? '',
        'lastName': response.data['lastName'] ?? '',
        'email': response.data['email'] ?? '',
        'phoneNumber': response.data['phoneNumber'] ?? '',
        'username': response.data['username'] ?? '',
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
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_first_name', firstName);
      await prefs.setString('user_last_name', lastName);
      await prefs.setString('user_email', email);
      await prefs.setString('user_phone', phoneNumber);
      
      // Update username to reflect first name and last name
      await prefs.setString('user_name', '$firstName $lastName');
      
      return true;
    }

    try {
      await _dioClient.dio.put(
        '/auth/profile',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phoneNumber': phoneNumber,
        },
      );
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update password (for logged-in users)
  Future<bool> updatePassword({
    required String newPassword,
  }) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      // In dev mode, just simulate success
      return true;
    }

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
