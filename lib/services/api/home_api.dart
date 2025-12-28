import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../../models/project_model.dart';
import '../../models/developer_model.dart';
import '../../models/area_model.dart';
import '../../data/mock_data.dart';
import 'project_api.dart';

class HomeApi {
  final DioClient _dioClient = DioClient();
  final ProjectApi _projectApi = ProjectApi();

  HomeApi() {
    _dioClient.init();
  }

  // TODO: Set to false when backend is ready
  static const bool _devMode = true;

  /// Get featured projects for carousel
  Future<List<ProjectModel>> getFeaturedProjects() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.featuredProjects;
    }

    try {
      final response = await _dioClient.dio.get('/projects/featured');
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get latest projects
  Future<List<ProjectModel>> getLatestProjects() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.latestProjects;
    }

    try {
      final response = await _dioClient.dio.get('/projects/latest');
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get continue watching projects
  Future<List<ProjectModel>> getContinueWatching() async {
    if (_devMode) {
      // Use ProjectApi to get dynamic continue watching projects
      return await _projectApi.getContinueWatchingProjects();
    }

    try {
      final response = await _dioClient.dio.get('/projects/continue-watching');
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get top 10 projects
  Future<List<ProjectModel>> getTop10Projects() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.top10Projects;
    }

    try {
      final response = await _dioClient.dio.get('/projects/top10');
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get projects by area
  Future<List<ProjectModel>> getProjectsByArea(String area) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.getProjectsByArea(area);
    }

    try {
      final response = await _dioClient.dio.get('/projects/area/$area');
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get upcoming projects
  Future<List<ProjectModel>> getUpcomingProjects() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.upcomingProjects;
    }

    try {
      final response = await _dioClient.dio.get('/projects/upcoming');
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get projects by category
  Future<List<ProjectModel>> getProjectsByCategory(String category) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.getProjectsByCategory(category);
    }

    try {
      final response = await _dioClient.dio.get('/projects/category/$category');
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all developers
  Future<List<DeveloperModel>> getDevelopers() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.developers;
    }

    try {
      final response = await _dioClient.dio.get('/developers');
      return (response.data as List)
          .map((json) => DeveloperModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all areas
  Future<List<AreaModel>> getAreas() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.areas;
    }

    try {
      final response = await _dioClient.dio.get('/areas');
      return (response.data as List)
          .map((json) => AreaModel.fromJson(json))
          .toList();
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

