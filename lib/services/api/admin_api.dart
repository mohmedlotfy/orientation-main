import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dio_client.dart';

class JoinRequestModel {
  final String id;
  final String userId;
  final String companyName;
  final String headOffice;
  final String projectName;
  final int orientationsCount;
  final String? notes;
  final String status; // pending, approved, rejected
  final DateTime createdAt;

  JoinRequestModel({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.headOffice,
    required this.projectName,
    required this.orientationsCount,
    this.notes,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'headOffice': headOffice,
      'projectName': projectName,
      'orientationsCount': orientationsCount,
      'notes': notes,
    };
  }
}

class AdminApi {
  final DioClient _dioClient = DioClient();

  AdminApi() {
    _dioClient.init();
  }

  static const bool _devMode = true; // Toggle this for API integration

  /// Submit join request (user applying to become developer)
  Future<bool> submitJoinRequest(JoinRequestModel request) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Store join request in SharedPreferences (mock)
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? 'unknown';
      final requestId = 'join-request-${DateTime.now().millisecondsSinceEpoch}';
      
      // Store as JSON string
      await prefs.setString('join_request_$requestId', '''
{
  "id": "$requestId",
  "userId": "$userId",
  "companyName": "${request.companyName}",
  "headOffice": "${request.headOffice}",
  "projectName": "${request.projectName}",
  "orientationsCount": ${request.orientationsCount},
  "notes": "${request.notes ?? ''}",
  "status": "pending",
  "createdAt": "${DateTime.now().toIso8601String()}"
}
''');
      
      print('✅ Join request submitted: $requestId');
      return true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      await _dioClient.dio.post(
        '/admin/join-requests',
        data: request.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all join requests (Admin only)
  Future<List<JoinRequestModel>> getJoinRequests() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Get all join requests from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      final requests = <JoinRequestModel>[];
      
      for (final key in allKeys) {
        if (key.startsWith('join_request_')) {
          // Parse JSON string (simplified - in real app use jsonDecode)
          // For now, return empty list in dev mode
        }
      }
      
      return requests;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      final response = await _dioClient.dio.get(
        '/admin/join-requests',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      
      // TODO: Parse response
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Approve join request (Admin only)
  Future<bool> approveJoinRequest(String requestId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      print('✅ Join request approved: $requestId');
      return true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      await _dioClient.dio.post(
        '/admin/join-requests/$requestId/approve',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Reject join request (Admin only)
  Future<bool> rejectJoinRequest(String requestId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      print('✅ Join request rejected: $requestId');
      return true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      await _dioClient.dio.post(
        '/admin/join-requests/$requestId/reject',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

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
          return 'Unauthorized. Please login again.';
        } else if (statusCode == 403) {
          return 'Access denied. Admin only.';
        }
        return message ?? 'An error occurred. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}

