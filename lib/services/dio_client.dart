import 'package:dio/dio.dart';
import '../utils/local_storage.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;

  // Base URL - replace with your actual API base URL
  static const String baseUrl = 'https://api.example.com/v1';

  // Private constructor
  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_loggingInterceptor());
  }

  /// Get singleton instance
  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  /// Get Dio instance
  Dio get dio => _dio;

  /// Auth interceptor to add token to requests
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get token from local storage
        final token = await LocalStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 unauthorized - token expired
        if (error.response?.statusCode == 401) {
          // Clear local storage and redirect to login
          await LocalStorage.clearAuth();
          // You can add navigation to login screen here
        }
        return handler.next(error);
      },
    );
  }

  /// Logging interceptor for debugging
  InterceptorsWrapper _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('┌──────────────────────────────────────────');
        print('│ REQUEST: ${options.method} ${options.uri}');
        print('│ Headers: ${options.headers}');
        if (options.data != null) {
          print('│ Body: ${options.data}');
        }
        print('└──────────────────────────────────────────');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('┌──────────────────────────────────────────');
        print('│ RESPONSE: ${response.statusCode}');
        print('│ Data: ${response.data}');
        print('└──────────────────────────────────────────');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('┌──────────────────────────────────────────');
        print('│ ERROR: ${error.message}');
        print('│ Response: ${error.response?.data}');
        print('└──────────────────────────────────────────');
        return handler.next(error);
      },
    );
  }

  // ============ HTTP METHODS ============

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(path, data: data, queryParameters: queryParameters, options: options);
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(path, data: data, queryParameters: queryParameters, options: options);
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch(path, data: data, queryParameters: queryParameters, options: options);
  }
}

