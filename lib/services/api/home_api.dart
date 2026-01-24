import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../../models/project_model.dart';
import '../../models/developer_model.dart';
import '../../models/area_model.dart';
import 'project_api.dart';

class HomeApi {
  final DioClient _dioClient = DioClient();
  final ProjectApi _projectApi = ProjectApi();

  HomeApi() {
    _dioClient.init();
  }

  /// Get featured projects for carousel
  Future<List<ProjectModel>> getFeaturedProjects() async {
    try {
      // Get trending projects as featured
      final response = await _dioClient.dio.get('/projects/trending', queryParameters: {
        'limit': 10,
      });
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print('Error getting featured projects: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Get latest projects
  Future<List<ProjectModel>> getLatestProjects() async {
    try {
      // Get projects sorted by newest
      final response = await _dioClient.dio.get('/projects', queryParameters: {
        'sortBy': 'newest',
        'limit': 10,
      });
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print('Error getting latest projects: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Get continue watching projects
  Future<List<ProjectModel>> getContinueWatching() async {
    print('🔍 getContinueWatching() called. _devMode = $_devMode');
    
    // Always use ProjectApi method (uses SharedPreferences) since /projects/continue-watching endpoint doesn't exist
    // TODO: Implement /projects/continue-watching endpoint in backend, then uncomment API call below
    print('📱 Using getContinueWatchingProjects() (SharedPreferences)...');
    try {
      final result = await _projectApi.getContinueWatchingProjects();
      print('✅ getContinueWatchingProjects() returned ${result.length} projects');
      return result;
    } catch (e) {
      print('❌ Error in getContinueWatchingProjects: $e');
      // Return empty list instead of throwing exception
      return [];
    }
    
    /* 
    // Uncomment when backend endpoint is ready
    if (_devMode) {
      // Use ProjectApi to get dynamic continue watching projects
      print('📱 Using dev mode, calling getContinueWatchingProjects()...');
      final result = await _projectApi.getContinueWatchingProjects();
      print('✅ getContinueWatchingProjects() returned ${result.length} projects');
      return result;
    }

    try {
      print('🌐 Calling API: /projects/continue-watching');
      final response = await _dioClient.dio.get(
        '/projects/continue-watching',
        options: Options(
          receiveTimeout: const Duration(seconds: 5), // 5 second timeout
        ),
      );
      final projects = (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
      print('✅ API returned ${projects.length} projects');
      return projects;
    } on DioException catch (e) {
      print('❌ Error getting continue watching from API: ${e.message}');
      print('🔄 Falling back to getContinueWatchingProjects()...');
      // Fallback to ProjectApi method (uses SharedPreferences)
      try {
        final result = await _projectApi.getContinueWatchingProjects();
        print('✅ Fallback returned ${result.length} projects');
        return result;
      } catch (fallbackError) {
        print('❌ Error in fallback getContinueWatchingProjects: $fallbackError');
        // Return empty list instead of throwing exception
        return [];
      }
    } catch (e) {
      print('❌ Unexpected error getting continue watching: $e');
      // Return empty list instead of throwing exception
      return [];
    }
    */
  }

  /// Get top 10 projects
  Future<List<ProjectModel>> getTop10Projects() async {
    try {
      // Get trending projects (top 10)
      final response = await _dioClient.dio.get('/projects/trending', queryParameters: {
        'limit': 10,
      });
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print('Error getting top 10 projects: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Get projects by area
  Future<List<ProjectModel>> getProjectsByArea(String area) async {
    try {
      // Get projects filtered by location
      final response = await _dioClient.dio.get('/projects', queryParameters: {
        'location': area,
        'limit': 10,
      });
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print('Error getting projects by area: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Get upcoming projects
  Future<List<ProjectModel>> getUpcomingProjects() async {
    try {
      // Get projects with status PLANNING or CONSTRUCTION
      final response = await _dioClient.dio.get('/projects', queryParameters: {
        'status': 'PLANNING',
        'limit': 10,
      });
      final projects = (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
      return projects;
    } on DioException catch (e) {
      print('Error getting upcoming projects: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Get projects by category
  Future<List<ProjectModel>> getProjectsByCategory(String category) async {
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
    try {
      final response = await _dioClient.dio.get('/developer');
      return (response.data as List)
          .map((json) => DeveloperModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print('Error getting developers: ${e.message}');
      throw _handleError(e);
    }
  }

  /// Get all areas
  Future<List<AreaModel>> getAreas() async {
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

