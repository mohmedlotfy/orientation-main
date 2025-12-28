import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../../models/news_model.dart';
import '../../data/mock_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsApi {
  final DioClient _dioClient = DioClient();

  NewsApi() {
    _dioClient.init();
  }

  // Dev mode flag - set to false when real API is ready
  static const bool _devMode = true;

  /// Get all news
  Future<List<NewsModel>> getAllNews() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.getAllNews();
    }

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
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final remindedIds = prefs.getStringList('reminded_news') ?? [];
      return remindedIds.contains(newsId);
    }

    // TODO: Real API call
    return false;
  }

  /// Remind me for news
  Future<void> remindNews(String newsId) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final remindedIds = prefs.getStringList('reminded_news') ?? [];
      if (!remindedIds.contains(newsId)) {
        remindedIds.add(newsId);
        await prefs.setStringList('reminded_news', remindedIds);
      }
      return;
    }

    // TODO: Real API call
    // await _dioClient.dio.post('/news/$newsId/remind');
  }

  /// Remove remind for news
  Future<void> unremindNews(String newsId) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final remindedIds = prefs.getStringList('reminded_news') ?? [];
      remindedIds.remove(newsId);
      await prefs.setStringList('reminded_news', remindedIds);
      return;
    }

    // TODO: Real API call
    // await _dioClient.dio.delete('/news/$newsId/remind');
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

