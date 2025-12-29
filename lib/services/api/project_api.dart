import 'package:shared_preferences/shared_preferences.dart';
import '../dio_client.dart';
import '../../models/project_model.dart';
import '../../models/episode_model.dart';
import '../../models/clip_model.dart';
import '../../models/pdf_file_model.dart';
import '../../data/mock_data.dart';

class ProjectApi {
  final DioClient _dioClient = DioClient();

  ProjectApi() {
    _dioClient.init();
  }

  // Dev mode flag - set to false when real API is ready
  static const bool _devMode = true;

  // Get project by ID
  Future<ProjectModel?> getProjectById(String id) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.getProjectById(id);
    }

    // TODO: Real API call
    // final response = await _dioClient.dio.get('/projects/$id');
    // return ProjectModel.fromJson(response.data);
    return null;
  }

  // Get episodes for a project
  Future<List<EpisodeModel>> getEpisodes(String projectId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.getEpisodesByProjectId(projectId);
    }

    // TODO: Real API call
    // final response = await _dioClient.dio.get('/projects/$projectId/episodes');
    // return (response.data as List).map((e) => EpisodeModel.fromJson(e)).toList();
    return [];
  }

  // Check if project is saved
  Future<bool> isProjectSaved(String projectId) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final savedIds = prefs.getStringList('saved_projects') ?? [];
      return savedIds.contains(projectId);
    }

    // TODO: Real API call
    return false;
  }

  // Save project to favorites
  Future<void> saveProject(String projectId) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final savedIds = prefs.getStringList('saved_projects') ?? [];
      if (!savedIds.contains(projectId)) {
        savedIds.add(projectId);
        await prefs.setStringList('saved_projects', savedIds);
      }
      MockData.saveProject(projectId);
      return;
    }

    // TODO: Real API call
    // await _dioClient.dio.post('/projects/$projectId/save');
  }

  // Remove project from favorites
  Future<void> unsaveProject(String projectId) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final savedIds = prefs.getStringList('saved_projects') ?? [];
      savedIds.remove(projectId);
      await prefs.setStringList('saved_projects', savedIds);
      MockData.unsaveProject(projectId);
      return;
    }

    // TODO: Real API call
    // await _dioClient.dio.delete('/projects/$projectId/save');
  }

  // Get all saved projects
  Future<List<ProjectModel>> getSavedProjects() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      final prefs = await SharedPreferences.getInstance();
      final savedIds = prefs.getStringList('saved_projects') ?? [];
      
      return savedIds
          .map((id) => MockData.getProjectById(id))
          .where((p) => p != null)
          .cast<ProjectModel>()
          .toList();
    }

    // TODO: Real API call
    // final response = await _dioClient.dio.get('/projects/saved');
    // return (response.data as List).map((e) => ProjectModel.fromJson(e)).toList();
    return [];
  }

  // Track watching progress
  Future<void> trackWatching(String projectId, String episodeId, double progress) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final key = 'watch_progress_${projectId}_$episodeId';
      await prefs.setDouble(key, progress);
      // Debug: print to verify saving
      print('✅ Saved progress: $key = $progress');
      return;
    }

    // TODO: Real API call
    // await _dioClient.dio.post('/projects/$projectId/episodes/$episodeId/progress', data: {'progress': progress});
  }

  // Get watching progress
  Future<double> getWatchingProgress(String projectId, String episodeId) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble('watch_progress_${projectId}_$episodeId') ?? 0.0;
    }

    // TODO: Real API call
    return 0.0;
  }

  // Get continue watching projects (projects with watch progress > 0)
  Future<List<ProjectModel>> getContinueWatchingProjects() async {
    if (_devMode) {
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
        final project = MockData.getProjectById(entry.key);
        if (project != null) {
          continueWatchingProjects.add(
            project.copyWith(watchProgress: entry.value),
          );
          print('✅ Added project: ${project.title} (${entry.value * 100}%)');
        } else {
          print('❌ Project not found: ${entry.key}');
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

    // TODO: Real API call
    // final response = await _dioClient.dio.get('/projects/continue-watching');
    // return (response.data as List).map((e) => ProjectModel.fromJson(e)).toList();
    return [];
  }

  // Get clips for a project
  Future<List<ClipModel>> getClipsByProject(String projectId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.getClipsByProjectId(projectId);
    }

    // TODO: Real API call
    // final response = await _dioClient.dio.get('/projects/$projectId/clips');
    // return (response.data as List).map((e) => ClipModel.fromJson(e)).toList();
    return [];
  }

  // Get all clips
  Future<List<ClipModel>> getAllClips() async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.getAllClips();
    }

    // TODO: Real API call
    return [];
  }

  // Check if clip is liked
  Future<bool> isClipLiked(String clipId) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final likedIds = prefs.getStringList('liked_clips') ?? [];
      return likedIds.contains(clipId);
    }

    // TODO: Real API call
    return false;
  }

  // Like a clip
  Future<void> likeClip(String clipId) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final likedIds = prefs.getStringList('liked_clips') ?? [];
      if (!likedIds.contains(clipId)) {
        likedIds.add(clipId);
        await prefs.setStringList('liked_clips', likedIds);
      }
      MockData.likeClip(clipId);
      return;
    }

    // TODO: Real API call
  }

  // Unlike a clip
  Future<void> unlikeClip(String clipId) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final likedIds = prefs.getStringList('liked_clips') ?? [];
      likedIds.remove(clipId);
      await prefs.setStringList('liked_clips', likedIds);
      MockData.unlikeClip(clipId);
      return;
    }

    // TODO: Real API call
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
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Generate a new clip ID
      final clipId = 'clip-${DateTime.now().millisecondsSinceEpoch}';
      
      // Create the clip (in dev mode, we'll use a placeholder video URL)
      final clip = ClipModel(
        id: clipId,
        projectId: projectId ?? '',
        title: title,
        description: description,
        videoUrl: videoPath ?? 'https://example.com/uploaded_reel_$clipId.mp4',
        thumbnail: '', // Will be generated from video
        isAsset: false,
        developerName: developerName ?? '',
        developerLogo: developerLogo ?? '',
        likes: 0,
        isLiked: false,
        createdAt: DateTime.now(),
      );
      
      MockData.addClip(clip);
      
      // Store in SharedPreferences for persistence
      final prefs = await SharedPreferences.getInstance();
      final clipsJson = prefs.getStringList('user_clips') ?? [];
      clipsJson.add(clipId);
      await prefs.setStringList('user_clips', clipsJson);
      
      return true;
    }

    // TODO: Real API call
    // final formData = FormData.fromMap({
    //   'title': title,
    //   'description': description,
    //   'video': await MultipartFile.fromFile(videoPath),
    //   'projectId': projectId,
    //   'hasWhatsApp': hasWhatsApp,
    // });
    // final response = await _dioClient.dio.post('/clips', data: formData);
    // return response.statusCode == 200;
    return false;
  }

  // Get projects for a developer
  Future<List<ProjectModel>> getDeveloperProjects(String developerId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.getProjectsByDeveloperId(developerId);
    }

    // TODO: Real API call
    // final response = await _dioClient.dio.get('/developers/$developerId/projects');
    // return (response.data as List).map((e) => ProjectModel.fromJson(e)).toList();
    return [];
  }

  // Update project inventory URL
  Future<bool> updateInventory(String projectId, String inventoryUrl) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Store in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('inventory_$projectId', inventoryUrl);
      
      MockData.updateProjectInventory(projectId, inventoryUrl);
      return true;
    }

    // TODO: Real API call
    // final response = await _dioClient.dio.put('/projects/$projectId/inventory', data: {
    //   'inventoryUrl': inventoryUrl,
    // });
    // return response.statusCode == 200;
    return false;
  }

  // Get inventory URL for a project
  Future<String?> getInventoryUrl(String projectId) async {
    if (_devMode) {
      final prefs = await SharedPreferences.getInstance();
      final customUrl = prefs.getString('inventory_$projectId');
      if (customUrl != null) return customUrl;
      
      // Fallback to project's default inventory URL
      final project = await getProjectById(projectId);
      return project?.inventoryUrl;
    }

    // TODO: Real API call
    return null;
  }

  // Get PDF files for a project
  Future<List<PdfFileModel>> getPdfFiles(String projectId) async {
    if (_devMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.getPdfFilesByProjectId(projectId);
    }

    // TODO: Real API call
    // final response = await _dioClient.dio.get('/projects/$projectId/pdf-files');
    // return (response.data as List)
    //     .map((json) => PdfFileModel.fromJson(json))
    //     .toList();
    return [];
  }
}

