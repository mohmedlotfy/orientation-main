import '../dio_client.dart';
import '../../models/user_model.dart';

class AuthApi {
  final DioClient _dioClient = DioClient.instance;

  // API Endpoints
  static const String _loginEndpoint = '/auth/login';
  static const String _registerEndpoint = '/auth/register';
  static const String _logoutEndpoint = '/auth/logout';
  static const String _forgotPasswordEndpoint = '/auth/forgot-password';
  static const String _resetPasswordEndpoint = '/auth/reset-password';
  static const String _verifyOtpEndpoint = '/auth/verify-otp';
  static const String _profileEndpoint = '/auth/profile';

  /// Login with email and password
  /// Returns a map containing user data and token
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // TODO: Implement actual API call when backend is ready
    // final response = await _dioClient.post(
    //   _loginEndpoint,
    //   data: {
    //     'email': email,
    //     'password': password,
    //   },
    // );
    // return response.data;

    // Placeholder response - simulating successful login
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    return {
      'success': true,
      'message': 'Login successful',
      'data': {
        'user': {
          'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
          'email': email,
        },
        'token': 'placeholder_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      },
    };
  }

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    // TODO: Implement actual API call when backend is ready
    // final response = await _dioClient.post(
    //   _registerEndpoint,
    //   data: {
    //     'username': username,
    //     'email': email,
    //     'password': password,
    //     'phone': phone,
    //   },
    // );
    // return response.data;

    // Placeholder response - simulating successful registration
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    return {
      'success': true,
      'message': 'Registration successful',
      'data': {
        'user': {
          'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
          'email': email,
        },
        'token': 'placeholder_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      },
    };
  }

  /// Logout user
  Future<Map<String, dynamic>> logout() async {
    // TODO: Implement actual API call when backend is ready
    // final response = await _dioClient.post(_logoutEndpoint);
    // return response.data;

    // Placeholder response
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'success': true,
      'message': 'Logout successful',
    };
  }

  /// Request password reset
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    // TODO: Implement actual API call when backend is ready
    // final response = await _dioClient.post(
    //   _forgotPasswordEndpoint,
    //   data: {'email': email},
    // );
    // return response.data;

    // Placeholder response
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'message': 'Password reset email sent',
    };
  }

  /// Verify OTP code
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    // TODO: Implement actual API call when backend is ready
    // final response = await _dioClient.post(
    //   _verifyOtpEndpoint,
    //   data: {
    //     'email': email,
    //     'otp': otp,
    //   },
    // );
    // return response.data;

    // Placeholder response
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'message': 'OTP verified successfully',
      'data': {
        'reset_token': 'reset_token_${DateTime.now().millisecondsSinceEpoch}',
      },
    };
  }

  /// Reset password with new password
  Future<Map<String, dynamic>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    // TODO: Implement actual API call when backend is ready
    // final response = await _dioClient.post(
    //   _resetPasswordEndpoint,
    //   data: {
    //     'reset_token': resetToken,
    //     'new_password': newPassword,
    //   },
    // );
    // return response.data;

    // Placeholder response
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'message': 'Password reset successful',
    };
  }

  /// Get user profile
  Future<AppUser> getProfile() async {
    // TODO: Implement actual API call when backend is ready
    // final response = await _dioClient.get(_profileEndpoint);
    // return AppUser.fromJson(response.data['data']);

    // Placeholder response
    await Future.delayed(const Duration(milliseconds: 500));

    return AppUser(
      id: 'placeholder_user_id',
      email: 'user@example.com',
    );
  }
}

