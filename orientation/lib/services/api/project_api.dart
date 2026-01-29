import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dio_client.dart';
import '../../models/project_model.dart';
import '../../models/episode_model.dart';
import '../../models/clip_model.dart';
import '../../models/pdf_file_model.dart';
import '../../models/watch_history_model.dart';
import 'watch_history_api.dart';

class ProjectApi {
  final DioClient _dioClient = DioClient();
  final WatchHistoryApi _watchHistoryApi = WatchHistoryApi();

  ProjectApi() {
    _dioClient.init();
  }

  /// GET /projects/:id
  Future<ProjectModel?> getProjectById(String id) async {
    try {
      final response = await _dioClient.dio.get('/projects/$id');
      return ProjectModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// GET /episode, then filter by projectId
  Future<List<EpisodeModel>> getEpisodes(String projectId) async {
    try {
      final response = await _dioClient.dio.get('/episode');
      final list = response.data is List ? response.data as List : <dynamic>[];
      final out = <EpisodeModel>[];
      for (final e in list) {
        final m = e as Map<String, dynamic>?;
        if (m == null) continue;
        final pid = _resolveId(m['projectId']);
        if (pid == projectId) out.add(EpisodeModel.fromJson(m));
      }
      out.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));
      return out;
    } on DioException catch (_) {
      return [];
    }
  }

  String? _resolveId(dynamic v) {
    if (v == null) return null;
    if (v is Map) return v['_id']?.toString() ?? v['id']?.toString();
    return v.toString();
  }

  static const String _episodeContentPrefix = 'episode__';

  /// Creates a stable, URL-safe contentId for Watch History that still encodes projectId + episodeId.
  /// Example: episode__<projectId>__<episodeId>
  static String makeEpisodeContentId(String projectId, String episodeId) {
    return '$_episodeContentPrefix$projectId\_\_$episodeId';
  }

  static ({String projectId, String episodeId})? parseEpisodeContentId(String contentId) {
    if (!contentId.startsWith(_episodeContentPrefix)) return null;
    final rest = contentId.substring(_episodeContentPrefix.length);
    final parts = rest.split('__');
    if (parts.length != 2) return null;
    return (projectId: parts[0], episodeId: parts[1]);
  }

  Future<bool> _hasAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  /// Uses local cache (updated on save/unsave). PATCH /projects/:id/save-project does not return savedProjects.
  Future<bool> isProjectSaved(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('saved_projects') ?? [];
    return ids.contains(projectId);
  }

  /// PATCH /projects/:id/save-project — no body. On success, add to local cache.
  Future<void> saveProject(String projectId) async {
    await _dioClient.dio.patch('/projects/$projectId/save-project');
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('saved_projects') ?? [];
    if (!ids.contains(projectId)) {
      ids.add(projectId);
      await prefs.setStringList('saved_projects', ids);
    }
  }

  /// PATCH /projects/:id/unsave-project — no body. On success, remove from local cache.
  Future<void> unsaveProject(String projectId) async {
    await _dioClient.dio.patch('/projects/$projectId/unsave-project');
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('saved_projects') ?? [];
    ids.remove(projectId);
    await prefs.setStringList('saved_projects', ids);
  }

  /// Get saved projects from user data (GET /users/:id or /auth/profile)
  /// Falls back to local cache if backend unavailable
  Future<List<ProjectModel>> getSavedProjects() async {
    try {
      // Try to get from backend user data first
      if (await _hasAuthToken()) {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('user_id');
        
        if (userId != null && userId.isNotEmpty) {
          print('📡 Fetching saved projects from user data (userId: $userId)...');
          try {
            // Try GET /users/:id first
            final response = await _dioClient.dio.get('/users/$userId');
            final userData = response.data as Map<String, dynamic>?;
            
            if (userData != null) {
              final savedProjectsIds = userData['savedProjects'];
              if (savedProjectsIds is List) {
                final ids = savedProjectsIds.map((e) => e.toString()).where((id) => id.isNotEmpty).toList();
                print('✅ Found ${ids.length} saved project IDs from user data');
                
                // Fetch each project
                final out = <ProjectModel>[];
                for (final id in ids) {
                  final p = await getProjectById(id);
                  if (p != null) out.add(p);
                }
                
                // Update local cache
                await prefs.setStringList('saved_projects', ids);
                
                print('✅ Loaded ${out.length} saved projects from backend');
                return out;
              }
            }
          } catch (e) {
            print('⚠️ Failed to get saved projects from /users/:id, trying /auth/profile...');
            // Try /auth/profile as fallback
            try {
              final response = await _dioClient.dio.get('/auth/profile');
              final userData = response.data as Map<String, dynamic>?;
              
              if (userData != null) {
                final savedProjectsIds = userData['savedProjects'];
                if (savedProjectsIds is List) {
                  final ids = savedProjectsIds.map((e) => e.toString()).where((id) => id.isNotEmpty).toList();
                  print('✅ Found ${ids.length} saved project IDs from /auth/profile');
                  
                  final out = <ProjectModel>[];
                  for (final id in ids) {
                    final p = await getProjectById(id);
                    if (p != null) out.add(p);
                  }
                  
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setStringList('saved_projects', ids);
                  
                  print('✅ Loaded ${out.length} saved projects from /auth/profile');
                  return out;
                }
              }
            } catch (e2) {
              print('⚠️ /auth/profile also failed: $e2');
            }
          }
        }
      }
    } catch (e) {
      print('⚠️ Error fetching saved projects from backend: $e');
    }
    
    // Fallback to local cache
    print('📦 Using local cache for saved projects...');
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('saved_projects') ?? [];
    final out = <ProjectModel>[];
    for (final id in ids) {
      final p = await getProjectById(id);
      if (p != null) out.add(p);
    }
    print('✅ Loaded ${out.length} saved projects from local cache');
    return out;
  }

  /// Progress stored locally; still used as offline fallback.
  Future<void> trackWatching(String projectId, String episodeId, double progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('watch_progress_${projectId}_$episodeId', progress);
  }

  Future<double> getWatchingProgress(String projectId, String episodeId) async {
    // Try backend watch-history first (if logged in), then fall back to local cache.
    try {
      if (await _hasAuthToken()) {
        final contentId = makeEpisodeContentId(projectId, episodeId);
        final w = await _watchHistoryApi.getContentProgress(contentId);
        if (w != null && w.duration > 0) {
          final frac = (w.currentTime / w.duration).clamp(0.0, 1.0);
          // Cache locally as well (for faster UI + offline fallback)
          await trackWatching(projectId, episodeId, frac);
          return frac;
        }
      }
    } catch (_) {
      // ignore, fallback to local
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('watch_progress_${projectId}_$episodeId') ?? 0.0;
  }

  /// Update watch progress on backend (Watch History) and keep local cache in sync.
  Future<void> updateEpisodeWatchProgress({
    required String projectId,
    required EpisodeModel episode,
    required String projectTitle,
    required double currentTimeSeconds,
    required double durationSeconds,
  }) async {
    final frac = durationSeconds > 0 ? (currentTimeSeconds / durationSeconds).clamp(0.0, 1.0) : 0.0;
    await trackWatching(projectId, episode.id, frac);

    try {
      if (!await _hasAuthToken()) return;
      final contentId = makeEpisodeContentId(projectId, episode.id);
      await _watchHistoryApi.upsertProgress(
        contentId: contentId,
        contentTitle: projectTitle.isNotEmpty ? projectTitle : (episode.title.isNotEmpty ? episode.title : 'Episode ${episode.episodeNumber}'),
        contentThumbnail: episode.thumbnail.isNotEmpty ? episode.thumbnail : null,
        currentTimeSeconds: currentTimeSeconds,
        durationSeconds: durationSeconds,
        contentType: 'episode',
        episode: episode.episodeNumber,
      );
    } catch (_) {
      // Ignore backend sync errors; local cache still works.
    }
  }

  /// Returns the last watched episodeId for a given project using backend watch-history if available.
  Future<String?> getLastWatchedEpisodeId(String projectId) async {
    try {
      if (!await _hasAuthToken()) return null;
      final items = await _watchHistoryApi.getContinueWatching(limit: 100);
      WatchHistoryModel? best;
      for (final w in items) {
        final parsed = parseEpisodeContentId(w.contentId);
        if (parsed == null) continue;
        if (parsed.projectId != projectId) continue;
        if (best == null || w.lastWatchedAt.isAfter(best.lastWatchedAt)) {
          best = w;
        }
      }
      return best == null ? null : parseEpisodeContentId(best.contentId)?.episodeId;
    } catch (_) {
      return null;
    }
  }

  /// Continue watching list:
  /// - If logged in: derived from /watch-history/continue-watching
  /// - Otherwise: derived from local progress cache
  Future<List<ProjectModel>> getContinueWatchingProjects() async {
    // Prefer backend watch history if logged in.
    try {
      if (await _hasAuthToken()) {
        print('📺 Fetching continue watching from backend...');
        final items = await _watchHistoryApi.getContinueWatching(limit: 100);
        print('📺 Got ${items.length} items from watch history API');
        
        final Map<String, ({double progress, DateTime lastWatchedAt})> byProject = {};

        for (final w in items) {
          final parsed = parseEpisodeContentId(w.contentId);
          if (parsed == null) {
            print('⚠️ Could not parse contentId: ${w.contentId}');
            continue;
          }
          final pid = parsed.projectId;
          final frac = (w.progressPercentage / 100.0).clamp(0.0, 1.0);
          if (frac <= 0 || frac >= 0.9) {
            print('⏭️ Skipping ${w.contentTitle}: progress=$frac (${w.progressPercentage}%)');
            continue;
          }

          final existing = byProject[pid];
          if (existing == null || w.lastWatchedAt.isAfter(existing.lastWatchedAt)) {
            byProject[pid] = (progress: frac, lastWatchedAt: w.lastWatchedAt);
            print('✅ Added project $pid: progress=${(frac * 100).toStringAsFixed(1)}%');
          }
        }

        print('📊 Found ${byProject.length} unique projects with progress');

        final out = <ProjectModel>[];
        for (final e in byProject.entries) {
          final p = await getProjectById(e.key);
          if (p != null) {
            // Debug: Print image fields for continue watching projects
            if (out.length < 3) {
              print('📸 Continue watching project ${out.length} image fields:');
              print('   projectThumbnailUrl: "${p.projectThumbnailUrl}"');
              print('   image: "${p.image}"');
              print('   logo: "${p.logo}"');
            }
            out.add(p.copyWith(watchProgress: e.value.progress));
          } else {
            print('⚠️ Project ${e.key} not found');
          }
        }

        out.sort((a, b) {
          final aT = byProject[a.id]?.lastWatchedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bT = byProject[b.id]?.lastWatchedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bT.compareTo(aT);
        });

        print('✅ Returning ${out.length} continue watching projects');
        return out;
      } else {
        print('ℹ️ User not logged in, using local cache for continue watching');
      }
    } catch (e) {
      print('❌ Error fetching continue watching from backend: $e');
      print('📦 Falling back to local cache...');
      // fallback below
    }

    // Local-only fallback (old behavior)
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('watch_progress_'));
    final Map<String, double> byProject = {};
    for (final k in keys) {
      final rest = k.replaceFirst('watch_progress_', '');
      final i = rest.lastIndexOf('_');
      if (i <= 0 || i >= rest.length - 1) continue;
      final pid = rest.substring(0, i);
      final prog = prefs.getDouble(k) ?? 0.0;
      if (prog > 0 && prog < 0.95) {
        if (!byProject.containsKey(pid) || (byProject[pid] ?? 0) < prog) {
          byProject[pid] = prog;
        }
      }
    }
    final out = <ProjectModel>[];
    for (final e in byProject.entries) {
      final p = await getProjectById(e.key);
      if (p != null) out.add(p.copyWith(watchProgress: e.value));
    }
    out.sort((a, b) => (b.watchProgress ?? 0).compareTo(a.watchProgress ?? 0));
    return out;
  }

  /// GET /reels, filter by projectId, map to ClipModel (reels used as clips)
  Future<List<ClipModel>> getClipsByProject(String projectId) async {
    try {
      final response = await _dioClient.dio.get('/reels');
      final list = response.data is List ? response.data as List : <dynamic>[];
      return list
          .map((e) => e as Map<String, dynamic>)
          .where((m) => _resolveId(m['projectId']) == projectId)
          .map(ClipModel.fromJson)
          .toList();
    } on DioException catch (_) {
      return [];
    }
  }

  /// GET /reels
  Future<List<ClipModel>> getAllClips() async {
    try {
      final response = await _dioClient.dio.get('/reels');
      final list = response.data is List ? response.data as List : <dynamic>[];
      return list.map((e) => ClipModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (_) {
      return [];
    }
  }

  /// POST /reels/:id/save — Save a reel to user's saved reels
  Future<bool> saveReel(String reelId) async {
    try {
      await _dioClient.dio.post('/reels/$reelId/save');
      return true;
    } on DioException catch (_) {
      return false;
    }
  }

  /// POST /reels/:id/unsave — Remove a reel from user's saved reels
  Future<bool> unsaveReel(String reelId) async {
    try {
      await _dioClient.dio.post('/reels/$reelId/unsave');
      return true;
    } on DioException catch (_) {
      return false;
    }
  }

  /// GET /reels/saved — Get all reels saved by the current user
  /// Falls back to user data (savedReels array) if endpoint unavailable
  Future<List<ClipModel>> getSavedReels() async {
    try {
      // Try GET /reels/saved endpoint first
      if (await _hasAuthToken()) {
        print('📡 Fetching saved reels from /reels/saved...');
        try {
          final response = await _dioClient.dio.get('/reels/saved');
          final list = response.data is List ? response.data as List : <dynamic>[];
          final reels = list.map((e) => ClipModel.fromJson(e as Map<String, dynamic>)).toList();
          print('✅ Loaded ${reels.length} saved reels from /reels/saved');
          return reels;
        } catch (e) {
          print('⚠️ /reels/saved failed, trying user data...');
        }
        
        // Fallback: Get from user data
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('user_id');
        
        if (userId != null && userId.isNotEmpty) {
          try {
            final response = await _dioClient.dio.get('/users/$userId');
            final userData = response.data as Map<String, dynamic>?;
            
            if (userData != null) {
              final savedReelsIds = userData['savedReels'];
              if (savedReelsIds is List) {
                final ids = savedReelsIds.map((e) => e.toString()).where((id) => id.isNotEmpty).toList();
                print('✅ Found ${ids.length} saved reel IDs from user data');
                
                // Fetch each reel via GET /reels/:id or GET /reels and filter
                final allReelsResponse = await _dioClient.dio.get('/reels');
                final allReelsList = allReelsResponse.data is List ? allReelsResponse.data as List : <dynamic>[];
                final allReels = allReelsList.map((e) => ClipModel.fromJson(e as Map<String, dynamic>)).toList();
                
                final savedReels = allReels.where((r) => ids.contains(r.id)).toList();
                print('✅ Loaded ${savedReels.length} saved reels from user data');
                return savedReels;
              }
            }
          } catch (e) {
            print('⚠️ Failed to get saved reels from user data: $e');
          }
        }
      }
      
      // Return empty list if not authenticated or all methods failed
      return [];
    } on DioException catch (e) {
      print('❌ Error getting saved reels: ${e.message}');
      return [];
    }
  }

  /// Backend reels have no like; always false.
  Future<bool> isClipLiked(String clipId) async => false;

  /// No backend for reel like; no-op.
  Future<void> likeClip(String clipId) async {}

  /// No backend for reel like; no-op.
  Future<void> unlikeClip(String clipId) async {}

  /// POST /reels — multipart: title, description?, projectId?, file (video), thumbnail (required by backend).
  /// thumbnailPath optional; if null, backend may 400.
  Future<bool> addReel({
    required String title,
    required String description,
    required String? videoPath,
    required String? projectId,
    required bool hasWhatsApp,
    String? developerId,
    String? developerName,
    String? developerLogo,
    String? thumbnailPath,
  }) async {
    if (videoPath == null || videoPath.isEmpty) return false;
    try {
      final form = <String, dynamic>{
        'title': title,
        'description': description,
        if (projectId != null && projectId.isNotEmpty) 'projectId': projectId,
        'file': await MultipartFile.fromFile(videoPath),
      };
      if (thumbnailPath != null && thumbnailPath.isNotEmpty) {
        form['thumbnail'] = await MultipartFile.fromFile(thumbnailPath);
      }
      final res = await _dioClient.dio.post('/reels', data: FormData.fromMap(form));
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  /// GET /projects/trending?limit= (backend doesn't have /projects?developerId=, use trending)
  Future<List<ProjectModel>> getDeveloperProjects(String developerId) async {
    try {
      // Backend doesn't have /projects?developerId=, use trending and filter client-side
      final response = await _dioClient.dio.get('/projects/trending', queryParameters: {'limit': '100'});
      final list = response.data is List ? response.data as List : <dynamic>[];
      final allProjects = list.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList();
      // Filter by developerId client-side
      return allProjects.where((p) => p.developerId == developerId).toList();
    } on DioException catch (e) {
      print('❌ Error getting developer projects: ${e.message}');
      return [];
    }
  }

  /// GET /projects/trending?limit= (backend doesn't have general /projects endpoint)
  Future<List<ProjectModel>> getProjects({int limit = 20, String? excludeId}) async {
    try {
      // Backend doesn't have /projects with query params, use trending instead
      final response = await _dioClient.dio.get('/projects/trending', queryParameters: {'limit': limit.toString()});
      final list = response.data is List ? response.data as List : <dynamic>[];
      var items = list.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList();
      if (excludeId != null) items = items.where((p) => p.id != excludeId).toList();
      return items;
    } on DioException catch (e) {
      print('❌ Error getting projects: ${e.message}');
      return [];
    }
  }

  /// GET /projects/location?location= — for "projects by area"
  Future<List<ProjectModel>> getProjectsByArea(String location) async {
    try {
      // Use correct endpoint: GET /projects/location?location=
      final response = await _dioClient.dio.get('/projects/location', queryParameters: {'location': location});
      final list = response.data is List ? response.data as List : <dynamic>[];
      return list.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      print('❌ Error getting projects by area ($location): ${e.message}');
      return [];
    }
  }

  /// No direct “set inventory URL” in backend; /files/upload/inventory requires a file. No-op.
  Future<bool> updateInventory(String projectId, String inventoryUrl) async => false;

  /// POST /files/upload/inventory — multipart: projectId, title, inventory (file). Backend requires title. Requires ADMIN.
  Future<bool> uploadInventoryFile(String projectId, String filePath, {String? title}) async {
    try {
      final form = FormData.fromMap({
        'projectId': projectId,
        'title': title?.trim().isNotEmpty == true ? title!.trim() : 'Inventory',
        'inventory': await MultipartFile.fromFile(filePath),
      });
      final res = await _dioClient.dio.post('/files/upload/inventory', data: form);
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  /// GET /files/get/inventory (auth) — returns { message, inventories }. Filter by projectId.
  /// Inventory has project (not projectId) and inventoryUrl (not fileUrl).
  Future<String?> getInventoryUrl(String projectId) async {
    try {
      // New route (docs): GET /files/inventory -> List
      Response response;
      try {
        response = await _dioClient.dio.get('/files/inventory');
      } on DioException catch (e) {
        // Backwards-compatible fallback
        if (e.response?.statusCode == 404) {
          response = await _dioClient.dio.get('/files/get/inventory');
        } else {
          rethrow;
        }
      }

      final dynamic raw = response.data;
      final List<dynamic> list = raw is List
          ? raw
          : (raw is Map<String, dynamic> ? ((raw['inventories'] as List?) ?? <dynamic>[]) : <dynamic>[]);

      for (final e in list) {
        final m = e as Map<String, dynamic>?;
        if (m == null) continue;
        final pid = _resolveId(m['project']) ?? _resolveId(m['projectId']);
        if (pid == projectId) {
          final url = m['inventoryUrl']?.toString() ?? m['fileUrl']?.toString();
          if (url != null && url.isNotEmpty) return url;
        }
      }
      return null;
    } on DioException catch (_) {
      return null;
    }
  }

  /// GET /files/get/pdf (auth) — returns { message, pdfs }. Filter by projectId.
  /// File has project (not projectId) and pdfUrl (not fileUrl).
  Future<List<PdfFileModel>> getPdfFiles(String projectId) async {
    try {
      // New route (docs): GET /files/pdf -> List
      Response response;
      try {
        response = await _dioClient.dio.get('/files/pdf');
      } on DioException catch (e) {
        // Backwards-compatible fallback
        if (e.response?.statusCode == 404) {
          response = await _dioClient.dio.get('/files/get/pdf');
        } else {
          rethrow;
        }
      }

      final dynamic raw = response.data;
      final List<dynamic> list = raw is List ? raw : ((raw as Map?)?['pdfs'] as List? ?? <dynamic>[]);
      return list
          .map((e) => e as Map<String, dynamic>)
          .where((m) => (_resolveId(m['project']) ?? _resolveId(m['projectId'])) == projectId)
          .map(PdfFileModel.fromJson)
          .toList();
    } on DioException catch (_) {
      return [];
    }
  }

  /// PATCH /files/update/inventory/:id — Update an inventory file
  Future<bool> updateInventoryFile(String inventoryId, {String? title, String? filePath}) async {
    try {
      final form = <String, dynamic>{};
      if (title != null && title.isNotEmpty) {
        form['title'] = title;
      }
      if (filePath != null && filePath.isNotEmpty) {
        form['inventory'] = await MultipartFile.fromFile(filePath);
      }
      Response res;
      try {
        res = await _dioClient.dio.patch('/files/inventory/$inventoryId', data: FormData.fromMap(form));
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          res = await _dioClient.dio.patch('/files/update/inventory/$inventoryId', data: FormData.fromMap(form));
        } else {
          rethrow;
        }
      }
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  /// PATCH /files/update/pdf/:id — Update a PDF file
  Future<bool> updatePdfFile(String pdfId, {String? title, String? filePath}) async {
    try {
      final form = <String, dynamic>{};
      if (title != null && title.isNotEmpty) {
        form['title'] = title;
      }
      if (filePath != null && filePath.isNotEmpty) {
        form['PDF'] = await MultipartFile.fromFile(filePath);
      }
      Response res;
      try {
        res = await _dioClient.dio.patch('/files/pdf/$pdfId', data: FormData.fromMap(form));
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          res = await _dioClient.dio.patch('/files/update/pdf/$pdfId', data: FormData.fromMap(form));
        } else {
          rethrow;
        }
      }
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  /// DELETE /files/delete/inventory/:id — Delete an inventory file
  Future<bool> deleteInventoryFile(String inventoryId) async {
    try {
      Response res;
      try {
        res = await _dioClient.dio.delete('/files/inventory/$inventoryId');
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          res = await _dioClient.dio.delete('/files/delete/inventory/$inventoryId');
        } else {
          rethrow;
        }
      }
      return res.statusCode == 200 || res.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  /// DELETE /files/delete/pdf/:id — Delete a PDF file
  Future<bool> deletePdfFile(String pdfId) async {
    try {
      Response res;
      try {
        res = await _dioClient.dio.delete('/files/pdf/$pdfId');
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          res = await _dioClient.dio.delete('/files/delete/pdf/$pdfId');
        } else {
          rethrow;
        }
      }
      return res.statusCode == 200 || res.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
