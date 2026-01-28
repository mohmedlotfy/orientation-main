import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../../models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsApi {
  final DioClient _dioClient = DioClient();

  NewsApi() {
    _dioClient.init();
  }

  /// Get all news
  Future<List<NewsModel>> getAllNews() async {
    try {
      final response = await _dioClient.dio.get('/news');
      return (response.data as List)
          .map((json) => NewsModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Check if news is reminded
  Future<bool> isNewsReminded(String newsId) async {
    try {
      final response = await _dioClient.dio.get('/news/$newsId/remind');
      return response.data['isReminded'] ?? false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      throw _handleError(e);
    }
  }

  /// Remind me for news
  Future<void> remindNews(String newsId) async {
    try {
      await _dioClient.dio.post('/news/$newsId/remind');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Remove remind for news
  Future<void> unremindNews(String newsId) async {
    try {
      await _dioClient.dio.delete('/news/$newsId/remind');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors
  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'Unable to connect to server.';
      case DioExceptionType.badResponse:
        final message = e.response?.data?['message'];
        return message ?? 'An error occurred. Please try again.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}

