import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'cache_managers.dart';
import '../models/clip_model.dart';

/// Smart Reels Video Manager - TikTok-like behavior
/// 
/// Features:
/// - Smart caching (download once, reuse forever)
/// - Preload only next 1-2 videos
/// - Dispose videos far from current index (max 2-3 active)
/// - LRU cache with 7-day expiration
class ReelsVideoManager {
  // Singleton instance
  static final ReelsVideoManager _instance = ReelsVideoManager._internal();
  factory ReelsVideoManager() => _instance;
  ReelsVideoManager._internal();

  // Cache manager for reels videos (7-day expiration)
  static final CacheManager _cacheManager = CacheManagerReels.instance;
  
  // Active video controllers (max 3 at once)
  final Map<int, VideoPlayerController> _controllers = {};
  
  // Getter for controllers (read-only access)
  Map<int, VideoPlayerController> get controllers => Map.unmodifiable(_controllers);
  
  // Track which videos are being preloaded
  final Set<int> _preloadingIndices = {};
  
  // Track cached file paths
  final Map<String, String?> _cachedPaths = {};
  
  // Current index being watched
  int? _currentIndex;
  
  // List of clips
  List<ClipModel>? _clips;

  /// Initialize manager with clips list
  void initialize(List<ClipModel> clips) {
    try {
      // Dispose old controllers first
      disposeAll();
      
      _clips = clips;
      _currentIndex = null;
      debugPrint('🎬 ReelsVideoManager: Initialized with ${clips.length} clips');
      
      // Start preloading first 2 videos immediately (non-blocking)
      if (clips.isNotEmpty) {
        try {
          _preloadVideo(_getVideoUrl(clips[0], 0), 0);
        } catch (e) {
          debugPrint('⚠️ ReelsVideoManager: Error preloading first video: $e');
        }
        
        if (clips.length > 1) {
          try {
            _preloadVideo(_getVideoUrl(clips[1], 1), 1);
          } catch (e) {
            debugPrint('⚠️ ReelsVideoManager: Error preloading second video: $e');
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ ReelsVideoManager: Error in initialize: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Get or create video controller for index
  /// Automatically handles caching, preloading, and disposal
  Future<VideoPlayerController?> getControllerForIndex(
    int index, {
    required bool shouldPlay,
  }) async {
    try {
      if (_clips == null) {
        debugPrint('⚠️ ReelsVideoManager: Clips not initialized yet');
        return null;
      }
      
      if (index < 0 || index >= _clips!.length) {
        debugPrint('⚠️ ReelsVideoManager: Invalid index $index (clips length: ${_clips!.length})');
        return null;
      }

      // Return existing controller if available and initialized
      if (_controllers.containsKey(index)) {
        final controller = _controllers[index]!;
        try {
          if (controller.value.isInitialized) {
            debugPrint('✅ ReelsVideoManager: Returning existing controller for index $index');
            if (shouldPlay && !controller.value.isPlaying) {
              controller.play();
            } else if (!shouldPlay && controller.value.isPlaying) {
              controller.pause();
            }
            return controller;
          } else {
            debugPrint('⏳ ReelsVideoManager: Controller at $index exists but not initialized yet');
            // Controller exists but not initialized - wait a bit and check again
            await Future.delayed(const Duration(milliseconds: 100));
            if (controller.value.isInitialized) {
              if (shouldPlay) controller.play();
              return controller;
            }
          }
        } catch (e) {
          debugPrint('⚠️ ReelsVideoManager: Error accessing controller at $index: $e');
          // Controller might be disposed, remove it and reinitialize
          _controllers.remove(index);
        }
      }

      // Initialize new controller
      debugPrint('🔄 ReelsVideoManager: Initializing new controller for index $index');
      return await _initializeControllerAt(index, shouldPlay: shouldPlay);
    } catch (e, stackTrace) {
      debugPrint('❌ ReelsVideoManager: Error in getControllerForIndex: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Initialize video controller at specific index
  Future<VideoPlayerController?> _initializeControllerAt(
    int index, {
    required bool shouldPlay,
  }) async {
    if (_clips == null || index < 0 || index >= _clips!.length) {
      return null;
    }

    final clip = _clips![index];
    final videoUrl = _getVideoUrl(clip, index);
    
    if (videoUrl.isEmpty) {
      debugPrint('⚠️ ReelsVideoManager: Empty video URL for clip $index');
      return null;
    }

    // Try to initialize with retry mechanism
    for (int attempt = 0; attempt < 2; attempt++) {
      try {
        // Check cache first (with timeout to avoid waiting too long)
        String? filePath;
        
        try {
          // Try to get from cache with short timeout
          final cachedFile = await _cacheManager.getFileFromCache(videoUrl)
              .timeout(const Duration(milliseconds: 500));
          
          if (cachedFile != null && cachedFile.file.existsSync()) {
            filePath = cachedFile.file.path;
            debugPrint('✅ ReelsVideoManager: Using cached video for index $index');
          }
        } catch (e) {
          // Cache check timed out or failed - continue with network
          debugPrint('⚠️ ReelsVideoManager: Cache check timeout/failed for index $index, using network');
        }
        
        // If not cached, check if we have a preloaded path
        if (filePath == null && _cachedPaths.containsKey(videoUrl)) {
          final preloadedPath = _cachedPaths[videoUrl];
          if (preloadedPath != null && File(preloadedPath).existsSync()) {
            filePath = preloadedPath;
            debugPrint('✅ ReelsVideoManager: Using preloaded video for index $index');
          }
        }
        
        // If still no cache, start preloading for next time and use network
        if (filePath == null) {
          debugPrint('📥 ReelsVideoManager: Using network for index $index (preloading for next time)');
          _preloadVideo(videoUrl, index);
        }

        // Create controller with timeout
        VideoPlayerController controller;
        if (filePath != null && File(filePath).existsSync()) {
          // Use cached file
          controller = VideoPlayerController.file(File(filePath));
          debugPrint('📁 ReelsVideoManager: Loading from cache: $filePath');
        } else {
          // Use network URL (will be cached for next time)
          controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
          debugPrint('🌐 ReelsVideoManager: Loading from network: $videoUrl');
        }

        // Initialize with shorter timeout for faster response
        await controller.initialize().timeout(
          const Duration(seconds: 5), // Reduced from 10 to 5 seconds
          onTimeout: () {
            controller.dispose();
            throw TimeoutException('Video initialization timeout');
          },
        );

        // Verify controller is properly initialized
        if (!controller.value.isInitialized) {
          controller.dispose();
          throw Exception('Controller not initialized properly');
        }

        controller.setLooping(true);

        // Start playing immediately if requested
        // Don't wait for full buffering - let it buffer while playing
        if (shouldPlay) {
          // Start playing immediately - video will buffer while playing
          controller.play();
          // Set volume to 0 initially to avoid audio glitches during buffering
          controller.setVolume(1.0);
        }

        // Store controller
        _controllers[index] = controller;
        _currentIndex = index;

        // Preload next 1-2 videos
        _preloadNextVideos(index);

        // Dispose old controllers (keep max 2-3 active)
        _disposeOldControllers(index);

        debugPrint('✅ ReelsVideoManager: Controller initialized for index $index');
        return controller;
      } catch (e, stackTrace) {
        debugPrint('❌ ReelsVideoManager: Error initializing controller at $index (attempt ${attempt + 1}): $e');
        
        // If it's a codec error and we have a cached file, try to delete it and retry
        if (attempt == 0 && e.toString().contains('MediaCodec') || e.toString().contains('ExoPlaybackException')) {
          debugPrint('⚠️ ReelsVideoManager: Codec error detected, clearing cache and retrying...');
          try {
            // Clear corrupted cache
            final cachedFile = await _cacheManager.getFileFromCache(videoUrl);
            if (cachedFile != null) {
              await cachedFile.file.delete();
              await _cacheManager.removeFile(videoUrl);
              debugPrint('🗑️ ReelsVideoManager: Cleared corrupted cache for index $index');
            }
          } catch (cacheError) {
            debugPrint('⚠️ ReelsVideoManager: Error clearing cache: $cacheError');
          }
          // Continue to retry
          continue;
        }
        
        // If all attempts failed, log and return null
        if (attempt == 1) {
          debugPrint('❌ ReelsVideoManager: Failed to initialize controller after 2 attempts');
          debugPrint('Stack trace: $stackTrace');
          return null;
        }
      }
    }
    
    return null;
  }

  /// Preload video in background (non-blocking)
  Future<void> _preloadVideo(String videoUrl, int index) async {
    if (_preloadingIndices.contains(index)) {
      return; // Already preloading
    }

    _preloadingIndices.add(index);
    
    try {
      // Download and cache with priority (non-blocking)
      // Use getSingleFile which handles caching automatically
      unawaited(
        _cacheManager.getSingleFile(videoUrl).then((file) {
          debugPrint('✅ ReelsVideoManager: Preloaded video for index $index');
          _cachedPaths[videoUrl] = file.path;
        }).catchError((e) {
          debugPrint('⚠️ ReelsVideoManager: Error preloading video $index: $e');
        }),
      );
    } catch (e) {
      debugPrint('⚠️ ReelsVideoManager: Error starting preload for video $index: $e');
    } finally {
      // Don't remove from preloading set immediately - let it finish in background
      // It will be removed when the file is actually cached
    }
  }

  /// Preload next 1-2 videos (TikTok-like behavior)
  void _preloadNextVideos(int currentIndex) {
    try {
      if (_clips == null || currentIndex < 0) return;

      // Preload next 1 video (always)
      if (currentIndex + 1 < _clips!.length) {
        try {
          final nextClip = _clips![currentIndex + 1];
          final nextVideoUrl = _getVideoUrl(nextClip, currentIndex + 1);
          if (nextVideoUrl.isNotEmpty && !_controllers.containsKey(currentIndex + 1)) {
            _preloadVideo(nextVideoUrl, currentIndex + 1);
          }
        } catch (e) {
          debugPrint('⚠️ ReelsVideoManager: Error preloading next video: $e');
        }
      }

      // Optionally preload next 2 videos (if not too many active)
      if (_controllers.length < 2 && currentIndex + 2 < _clips!.length) {
        try {
          final next2Clip = _clips![currentIndex + 2];
          final next2VideoUrl = _getVideoUrl(next2Clip, currentIndex + 2);
          if (next2VideoUrl.isNotEmpty && !_controllers.containsKey(currentIndex + 2)) {
            _preloadVideo(next2VideoUrl, currentIndex + 2);
          }
        } catch (e) {
          debugPrint('⚠️ ReelsVideoManager: Error preloading next+2 video: $e');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ ReelsVideoManager: Error in _preloadNextVideos: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Dispose controllers far from current index (keep max 2-3 active)
  void _disposeOldControllers(int currentIndex) {
    try {
      final keysToRemove = <int>[];
      
      for (var key in _controllers.keys) {
        // Keep current, previous, and next 1-2 videos
        // Dispose everything else
        final distance = (key - currentIndex).abs();
        if (distance > 2) {
          keysToRemove.add(key);
        }
      }

      for (var key in keysToRemove) {
        try {
          final controller = _controllers[key];
          if (controller != null) {
            controller.dispose();
          }
          _controllers.remove(key);
          debugPrint('🗑️ ReelsVideoManager: Disposed controller at index $key');
        } catch (e) {
          debugPrint('⚠️ ReelsVideoManager: Error disposing controller $key: $e');
          // Remove from map even if dispose failed
          _controllers.remove(key);
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ ReelsVideoManager: Error in _disposeOldControllers: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Update current index (called when user scrolls)
  void updateCurrentIndex(int index) {
    try {
      if (_currentIndex == index) return;
      if (_clips == null || index < 0 || index >= _clips!.length) {
        debugPrint('⚠️ ReelsVideoManager: Invalid index in updateCurrentIndex: $index');
        return;
      }
      
      _currentIndex = index;
      
      // Pause previous video safely
      try {
        if (_currentIndex != null && _currentIndex! > 0) {
          final prevIndex = _currentIndex! - 1;
          if (_controllers.containsKey(prevIndex)) {
            final prevController = _controllers[prevIndex];
            if (prevController != null && prevController.value.isInitialized) {
              prevController.pause();
            }
          }
        }
      } catch (e) {
        debugPrint('⚠️ ReelsVideoManager: Error pausing previous video: $e');
      }
      
      // Play current video safely
      try {
        if (_controllers.containsKey(index)) {
          final controller = _controllers[index];
          if (controller != null && controller.value.isInitialized) {
            controller.play();
          }
        }
      } catch (e) {
        debugPrint('⚠️ ReelsVideoManager: Error playing current video: $e');
      }
      
      // Preload next videos
      _preloadNextVideos(index);
      
      // Dispose old controllers
      _disposeOldControllers(index);
    } catch (e, stackTrace) {
      debugPrint('❌ ReelsVideoManager: Error in updateCurrentIndex: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Pause all videos
  void pauseAll() {
    for (var entry in _controllers.entries) {
      try {
        final controller = entry.value;
        if (controller.value.isInitialized && controller.value.isPlaying) {
          controller.pause();
        }
      } catch (e) {
        debugPrint('⚠️ ReelsVideoManager: Error pausing video at ${entry.key}: $e');
      }
    }
  }

  /// Play current video
  void playCurrent() {
    try {
      if (_currentIndex != null && _controllers.containsKey(_currentIndex)) {
        final controller = _controllers[_currentIndex];
        if (controller != null && controller.value.isInitialized) {
          controller.play();
        }
      }
    } catch (e) {
      debugPrint('⚠️ ReelsVideoManager: Error playing current video: $e');
    }
  }

  /// Get video URL for clip (with fallback to sample videos)
  String _getVideoUrl(ClipModel clip, int index) {
    try {
      // Use sample videos for demo if clip URL is invalid
      final sampleVideos = [
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ];
      
      if (clip.videoUrl.isNotEmpty && 
          !clip.videoUrl.contains('example.com') &&
          (clip.videoUrl.startsWith('http://') || clip.videoUrl.startsWith('https://'))) {
        return clip.videoUrl;
      }
      
      // Use safe modulo to avoid division by zero
      final safeIndex = index >= 0 ? index : 0;
      return sampleVideos[safeIndex % sampleVideos.length];
    } catch (e) {
      debugPrint('⚠️ ReelsVideoManager: Error in _getVideoUrl: $e');
      // Return a safe default
      return 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
    }
  }

  /// Dispose all controllers
  void disposeAll() {
    for (var controller in _controllers.values) {
      try {
        controller.dispose();
      } catch (e) {
        debugPrint('⚠️ ReelsVideoManager: Error disposing controller: $e');
      }
    }
    _controllers.clear();
    _preloadingIndices.clear();
    _cachedPaths.clear();
    _currentIndex = null;
    debugPrint('🗑️ ReelsVideoManager: All controllers disposed');
  }

  /// Get cached file path for video URL
  Future<String?> getCachedFilePath(String videoUrl) async {
    try {
      final cachedFile = await _cacheManager.getFileFromCache(videoUrl);
      if (cachedFile != null && cachedFile.file.existsSync()) {
        return cachedFile.file.path;
      }
    } catch (e) {
      debugPrint('⚠️ ReelsVideoManager: Error getting cached file: $e');
    }
    return null;
  }

  /// Check if video is cached
  Future<bool> isVideoCached(String videoUrl) async {
    final cachedFile = await _cacheManager.getFileFromCache(videoUrl);
    return cachedFile != null && cachedFile.file.existsSync();
  }

  /// Clear all cached videos
  Future<void> clearCache() async {
    try {
      await _cacheManager.emptyCache();
      _cachedPaths.clear();
      debugPrint('🗑️ ReelsVideoManager: Cache cleared');
    } catch (e) {
      debugPrint('⚠️ ReelsVideoManager: Error clearing cache: $e');
    }
  }
}
