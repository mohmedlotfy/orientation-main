import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../../models/project_model.dart';
import '../../models/episode_model.dart';
import '../../models/clip_model.dart';
import '../../models/pdf_file_model.dart';

class ProjectApi {
  final DioClient _dioClient = DioClient();

  ProjectApi() {
    _dioClient.init();
  }

  // Get project by ID
  Future<ProjectModel?> getProjectById(String id) async {
    try {
      final response = await _dioClient.dio.get('/projects/$id');
      return ProjectModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error getting project: ${e.message}');
      rethrow;
    }
  }

  // Get episodes for a project
  Future<List<EpisodeModel>> getEpisodes(String projectId) async {
    try {
      final response = await _dioClient.dio.get('/projects/$projectId/episodes');
      return (response.data as List)
          .map((json) => EpisodeModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print('Error getting episodes: ${e.message}');
      rethrow;
    }
  }

  // Check if project is saved
  Future<bool> isProjectSaved(String projectId) async {
    try {
      final response = await _dioClient.dio.get('/projects/$projectId/saved');
      return response.data['isSaved'] ?? false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      print('Error checking if project is saved: ${e.message}');
      rethrow;
    }
  }

  // Save project to favorites
  Future<void> saveProject(String projectId) async {
    try {
      await _dioClient.dio.post('/projects/$projectId/save');
    } on DioException catch (e) {
      print('Error saving project: ${e.message}');
      rethrow;
    }
  }

  // Remove project from favorites
  Future<void> unsaveProject(String projectId) async {
    try {
      await _dioClient.dio.delete('/projects/$projectId/save');
    } on DioException catch (e) {
      print('Error unsaving project: ${e.message}');
      rethrow;
    }
  }

  // Get all saved projects
  Future<List<ProjectModel>> getSavedProjects() async {
    try {
      final response = await _dioClient.dio.get('/projects/saved');
      return (response.data as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      print('Error getting saved projects: ${e.message}');
      rethrow;
    }
  }

  // Track watching progress
  Future<void> trackWatching(String projectId, String episodeId, double progress) async {
    try {
      await _dioClient.dio.post(
        '/projects/$projectId/episodes/$episodeId/progress',
        data: {'progress': progress},
      );
    } on DioException catch (e) {
      print('Error tracking progress: ${e.message}');
      rethrow;
    }
  }

  // Get watching progress
  Future<double> getWatchingProgress(String projectId, String episodeId) async {
    try {
      final response = await _dioClient.dio.get(
        '/projects/$projectId/episodes/$episodeId/progress',
      );
      return (response.data['progress'] ?? 0.0).toDouble();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return 0.0;
      }
      print('Error getting progress: ${e.message}');
      rethrow;
    }
  }

  // Get continue watching projects (projects with watch progress > 0)
  Future<List<ProjectModel>> getContinueWatchingProjects() async {
    // Always use SharedPreferences for continue watching (works with both dev and prod)
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    
    // Find all project-episode combinations with progress
    final Map<String, double> projectProgress = {};
    
    print('🔍 Searching for watch progress keys...');
    for (final key in allKeys) {
      if (key.startsWith('watch_progress_')) {
        // Format: watch_progress_{projectId}_{episodeId}
        final withoutPrefix = key.replaceFirst('watch_progress_', '');
        final lastUnderscoreIndex = withoutPrefix.lastIndexOf('_');
        
        if (lastUnderscoreIndex > 0 && lastUnderscoreIndex < withoutPrefix.length - 1) {
          final projectId = withoutPrefix.substring(0, lastUnderscoreIndex);
          final progress = prefs.getDouble(key) ?? 0.0;
          
          print('📊 Found: projectId=$projectId, progress=$progress');
          
          // Keep the highest progress for each project
          // Show projects with progress > 0 and < 0.95 (not fully completed)
          // This allows showing "almost finished" videos but not 100% completed ones
          // IMPORTANT: Ignore progress = 1.0 (fully completed) to show in-progress videos
          if (progress > 0 && progress < 0.95) {
            if (!projectProgress.containsKey(projectId) || 
                projectProgress[projectId]! < progress) {
              projectProgress[projectId] = progress;
              print('✅ Updated progress for $projectId: ${(progress * 100).toStringAsFixed(1)}%');
            }
          } else if (progress >= 0.95) {
            print('⏭️ Skipping completed video: $projectId (${(progress * 100).toStringAsFixed(1)}%)');
          }
        }
      }
    }
    
    print('📋 Found ${projectProgress.length} projects with progress');
    
    // Get projects with progress > 0
    final continueWatchingProjects = <ProjectModel>[];
    for (final entry in projectProgress.entries) {
      try {
        final project = await getProjectById(entry.key);
        if (project != null) {
          continueWatchingProjects.add(
            project.copyWith(watchProgress: entry.value),
          );
          print('✅ Added project: ${project.title} (${(entry.value * 100).toStringAsFixed(1)}%)');
        }
      } catch (e) {
        print('⚠️ Could not fetch project ${entry.key} from API: $e');
      }
    }
    
    // Sort by progress (descending) - most watched first
    continueWatchingProjects.sort((a, b) {
      final aProgress = a.watchProgress ?? 0.0;
      final bProgress = b.watchProgress ?? 0.0;
      return bProgress.compareTo(aProgress);
    });
    
    print('🎬 Returning ${continueWatchingProjects.length} continue watching projects');
    return continueWatchingProjects;
  }

  // Get clips for a project
  Future<List<ClipModel>> getClipsByProject(String projectId) async {
    try {
      final response = await _dioClient.dio.get('/projects/$projectId/clips');
      return (response.data as List)
          .map((e) => ClipModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      print('Error getting clips: ${e.message}');
      rethrow;
    }
  }

  // Get all clips
  Future<List<ClipModel>> getAllClips() async {
    try {
      final response = await _dioClient.dio.get('/clips');
      return (response.data as List)
          .map((e) => ClipModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      print('Error getting all clips: ${e.message}');
      rethrow;
    }
  }

  // Check if clip is liked
  Future<bool> isClipLiked(String clipId) async {
    try {
      final response = await _dioClient.dio.get('/clips/$clipId/liked');
      return response.data['isLiked'] ?? false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      print('Error checking if clip is liked: ${e.message}');
      rethrow;
    }
  }

  // Like a clip
  Future<void> likeClip(String clipId) async {
    try {
      await _dioClient.dio.post('/clips/$clipId/like');
    } on DioException catch (e) {
      print('Error liking clip: ${e.message}');
      rethrow;
    }
  }

  // Unlike a clip
  Future<void> unlikeClip(String clipId) async {
    try {
      await _dioClient.dio.delete('/clips/$clipId/like');
    } on DioException catch (e) {
      print('Error unliking clip: ${e.message}');
      rethrow;
    }
  }

  // Add a new reel
  Future<bool> addReel({
    required String title,
    required String description,
    required String? videoPath,
    required String? projectId,
    required bool hasWhatsApp,
    required String? developerId,
    required String? developerName,
    required String? developerLogo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'hasWhatsApp': hasWhatsApp,
        if (projectId != null) 'projectId': projectId,
        if (developerId != null) 'developerId': developerId,
        if (developerName != null) 'developerName': developerName,
        if (developerLogo != null) 'developerLogo': developerLogo,
        if (videoPath != null) 'video': await MultipartFile.fromFile(videoPath),
      });

      final response = await _dioClient.dio.post(
        '/clips',
        data: formData,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      print('Error adding reel: ${e.message}');
      rethrow;
    }
  }

  // Get projects for a developer
  Future<List<ProjectModel>> getDeveloperProjects(String developerId) async {
    try {
      final response = await _dioClient.dio.get('/projects', queryParameters: {
        'developerId': developerId,
      });
      return (response.data as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      print('Error getting developer projects: ${e.message}');
      rethrow;
    }
  }

  // Update project inventory URL
  Future<bool> updateInventory(String projectId, String inventoryUrl) async {
    try {
      final response = await _dioClient.dio.put(
        '/projects/$projectId/inventory',
        data: {
          'inventoryUrl': inventoryUrl,
        },
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error updating inventory: ${e.message}');
      rethrow;
    }
  }

  // Get inventory URL for a project
  Future<String?> getInventoryUrl(String projectId) async {
    try {
      final response = await _dioClient.dio.get('/projects/$projectId/inventory');
      return response.data['inventoryUrl'];
    } on DioException catch (e) {
      // If endpoint doesn't exist, get from project
      if (e.response?.statusCode == 404) {
        try {
          final project = await getProjectById(projectId);
          return project?.inventoryUrl;
        } catch (_) {
          return null;
        }
      }
      print('Error getting inventory URL: ${e.message}');
      rethrow;
    }
  }

  // Get PDF files for a project
  Future<List<PdfFileModel>> getPdfFiles(String projectId) async {
    try {
      final response = await _dioClient.dio.get('/projects/$projectId/pdf-files');
      return (response.data as List)
          .map((json) => PdfFileModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print('Error getting PDF files: ${e.message}');
      rethrow;
    }
  }
}

