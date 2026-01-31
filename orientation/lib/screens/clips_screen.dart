import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/clip_model.dart';
import '../services/api/project_api.dart';
import '../services/reels_video_manager.dart';
import '../utils/auth_helper.dart';
import '../widgets/skeleton_loader.dart';
import 'project_details_screen.dart';

class ClipsScreen extends StatefulWidget {
  const ClipsScreen({super.key});

  @override
  State<ClipsScreen> createState() => ClipsScreenState();
}

class ClipsScreenState extends State<ClipsScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  final ProjectApi _projectApi = ProjectApi();
  final ReelsVideoManager _videoManager = ReelsVideoManager();
  
  List<ClipModel> _clips = [];
  final Map<String, bool> _savedReelIds = {}; // Store saved status by reel ID
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isVisible = false; // Track if screen is visible
  bool _isInitialized = false;

  static const Color brandRed = Color(0xFFE50914);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadClips();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || 
        state == AppLifecycleState.inactive) {
      pauseAllVideos();
    }
  }

  void pauseAllVideos() {
    _videoManager.pauseAll();
  }

  // Call this when tab becomes visible
  void setVisible(bool visible) {
    _isVisible = visible;
    if (visible) {
      // Resume current video if visible
      _videoManager.playCurrent();
    } else {
      // Pause all videos when not visible
      pauseAllVideos();
    }
  }

  Future<void> _loadClips({bool isRefresh = false}) async {
    try {
      if (!isRefresh) {
        setState(() {
          _isLoading = true;
        });
      }
      
      final clips = await _projectApi.getAllClips();
      if (mounted) {
        setState(() {
          _clips = clips;
          _isLoading = false;
        });
        if (clips.isNotEmpty) {
          // Initialize video manager with clips (starts preloading immediately)
          _videoManager.initialize(clips);
          
          // Mark as initialized immediately so UI can start building
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
          }
          
          // Initialize current video (non-blocking for UI)
          _initializeCurrentVideo().then((_) {
            if (mounted) {
              setState(() {}); // Refresh UI when video is ready
            }
          }).catchError((e) {
            debugPrint('⚠️ Error in _initializeCurrentVideo: $e');
          });
          
          // Load saved status in parallel (non-blocking)
          _loadSavedStatus();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadSavedStatus() async {
    try {
      // Load all saved reels once instead of checking each one individually
      final savedReels = await _projectApi.getSavedReels();
      
      if (mounted) {
        setState(() {
          _savedReelIds.clear();
          for (final reel in savedReels) {
            _savedReelIds[reel.id] = true;
          }
        });
      }
    } catch (e) {
      debugPrint('⚠️ Error loading saved status: $e');
      // If loading fails, set all to false
      if (mounted) {
        setState(() {
          _savedReelIds.clear();
        });
      }
    }
  }

  Future<void> _initializeCurrentVideo() async {
    if (_clips.isEmpty) {
      debugPrint('⚠️ ClipsScreen: Cannot initialize video - clips is empty');
      return;
    }
    
    if (_currentIndex < 0 || _currentIndex >= _clips.length) {
      debugPrint('⚠️ ClipsScreen: Cannot initialize video - invalid index $_currentIndex (clips length: ${_clips.length})');
      return;
    }
    
    try {
      debugPrint('🔄 ClipsScreen: Initializing current video at index $_currentIndex (visible: $_isVisible)');
      final controller = await _videoManager.getControllerForIndex(
        _currentIndex,
        shouldPlay: _isVisible,
      );
      
      if (controller != null && mounted) {
        debugPrint('✅ ClipsScreen: Current video initialized successfully');
        setState(() {});
      } else {
        debugPrint('⚠️ ClipsScreen: Controller is null after initialization');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error initializing current video: $e');
      debugPrint('Stack trace: $stackTrace');
      // Don't crash - just show placeholder
    }
  }

  void _onPageChanged(int index) {
    if (index == _currentIndex) return;
    if (index < 0 || index >= _clips.length) return;
    
    try {
      // Update video manager
      _videoManager.updateCurrentIndex(index);
      
      if (mounted) {
        setState(() {
          _currentIndex = index;
        });
      }
      
      // Play if visible
      if (_isVisible) {
        _videoManager.playCurrent();
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in _onPageChanged: $e');
      debugPrint('Stack trace: $stackTrace');
      // Don't crash - just update index
      if (mounted) {
        setState(() {
          _currentIndex = index;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoManager.pauseAll();
    _pageController.dispose();
    // Note: Don't dispose video manager here - it's a singleton
    super.dispose();
  }

  Future<void> _toggleSave(int index) async {
    if (!mounted) return;
    
    final isAuth = await AuthHelper.requireAuth(context);
    if (!isAuth || !mounted) return;
    
    final clip = _clips[index];
    final isCurrentlySaved = _savedReelIds[clip.id] ?? false;

    // Optimistic update
    if (mounted) {
      setState(() {
        _savedReelIds[clip.id] = !isCurrentlySaved;
      });
    }

    try {
      if (!isCurrentlySaved) {
        final success = await _projectApi.saveReel(clip.id);
        if (!mounted) return;
        
        if (success) {
          _showSnackBar('Saved!', isSuccess: true);
        } else {
          // Revert on failure
          if (mounted) {
            setState(() {
              _savedReelIds[clip.id] = isCurrentlySaved;
            });
          }
          _showSnackBar('Error saving reel', isSuccess: false);
        }
      } else {
        final success = await _projectApi.unsaveReel(clip.id);
        if (!mounted) return;
        
        if (success) {
          _showSnackBar('Removed from saved', isSuccess: true);
        } else {
          // Revert on failure
          if (mounted) {
            setState(() {
              _savedReelIds[clip.id] = isCurrentlySaved;
            });
          }
          _showSnackBar('Error removing reel', isSuccess: false);
        }
      }
    } catch (e) {
      if (!mounted) return;
      
      if (mounted) {
        setState(() {
          _savedReelIds[clip.id] = isCurrentlySaved;
        });
      }
      _showSnackBar('Error saving');
    }
  }

  Future<void> _openWhatsApp(ClipModel clip) async {
    const phone = '201205403733';
    final message = 'مهتم بمشروع ${clip.developerName}';
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      _showSnackBar('Could not open WhatsApp');
    }
  }

  Future<void> _shareClip(ClipModel clip) async {
    final shareText = '''
🎬 ${clip.title}
🏗️ ${clip.developerName}

${clip.description}

شاهد المزيد على تطبيق Orientation!
''';

    try {
      await Share.share(shareText, subject: clip.title);
    } catch (e) {
      _showSnackBar('Error sharing');
    }
  }

  void _openProjectDetails(ClipModel clip) async {
    final isAuth = await AuthHelper.requireAuth(context);
    if (!isAuth || !mounted) return;
    
    // Pause current video before navigating
    pauseAllVideos();
    
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailsScreen(projectId: clip.projectId),
      ),
    );
  }

  void _openEpisodes(ClipModel clip) async {
    final isAuth = await AuthHelper.requireAuth(context);
    if (!isAuth || !mounted) return;
    
    // Pause current video before navigating
    pauseAllVideos();
    
    if (!mounted) return;
    // Navigate to Project Details on Episodes tab
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailsScreen(
          projectId: clip.projectId,
          initialTabIndex: 1, // Episodes tab
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: isSuccess ? Colors.green : brandRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 3, // Show 3 skeleton items
          itemBuilder: (context, index) {
            return const SkeletonClipItem();
          },
        ),
      );
    }

    if (_clips.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.video_library_outlined,
                color: Colors.white.withOpacity(0.3),
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                'No Clips Available',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () => _loadClips(isRefresh: true),
        color: brandRed,
        backgroundColor: Colors.white,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _clips.length,
          onPageChanged: _onPageChanged,
          physics: const AlwaysScrollableScrollPhysics(), // Enable pull to refresh
          itemBuilder: (context, index) {
            return _buildClipItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildClipItem(int index) {
    // Safety checks
    if (index < 0 || index >= _clips.length) {
      return const SizedBox.shrink();
    }
    
    final clip = _clips[index];
    VideoPlayerController? controller;
    
    try {
      // Safely get controller
      controller = _videoManager.controllers[index];
    } catch (e) {
      debugPrint('⚠️ Error getting controller for index $index: $e');
      controller = null;
    }
    
    final isSaved = _savedReelIds[clip.id] ?? false;
    
    // Initialize video if not already loaded
    // Always try to initialize if controller is null and we have clips
    if (controller == null && _isInitialized && _clips.isNotEmpty) {
      // Trigger initialization immediately (don't wait)
      debugPrint('🔄 ClipsScreen: Starting initialization for video at index $index');
      _videoManager.getControllerForIndex(
        index,
        shouldPlay: index == _currentIndex && _isVisible,
      ).then((newController) {
        debugPrint('✅ ClipsScreen: Controller ready for index $index');
        // Update UI when controller is ready
        if (newController != null && mounted) {
          setState(() {});
        }
      }).catchError((e) {
        debugPrint('⚠️ Error initializing video at index $index: $e');
        // Video will show placeholder if initialization fails
      });
    } else if (controller == null && !_isInitialized) {
      debugPrint('⏳ ClipsScreen: Waiting for initialization (index $index)');
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Video or Placeholder
        GestureDetector(
          onTap: () async {
            try {
              if (controller != null && controller.value.isInitialized) {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
                if (mounted) {
                  setState(() {});
                }
              } else if (controller == null && _isInitialized) {
                // Try to initialize if not loaded
                try {
                  final newController = await _videoManager.getControllerForIndex(
                    index,
                    shouldPlay: index == _currentIndex && _isVisible,
                  );
                  if (newController != null && mounted) {
                    setState(() {});
                  }
                } catch (e) {
                  debugPrint('⚠️ Error initializing video on tap: $e');
                }
              }
            } catch (e) {
              debugPrint('⚠️ Error in video tap handler: $e');
            }
          },
          child: controller != null && controller.value.isInitialized
              ? Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                )
              : Container(
                  color: Colors.black,
                  child: clip.thumbnail.isNotEmpty
                      ? (clip.isAsset
                          ? Image.asset(
                              clip.thumbnail,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => _buildLoadingPlaceholder(),
                            )
                          : Image.network(
                              clip.thumbnail,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => _buildLoadingPlaceholder(),
                            ))
                      : _buildLoadingPlaceholder(),
                ),
        ),
        // Play/Pause indicator
        if (controller != null && !controller.value.isPlaying)
          const Center(
            child: Icon(
              Icons.play_arrow,
              color: Colors.white54,
              size: 80,
            ),
          ),
        // Gradient overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.95),
                ],
              ),
            ),
          ),
        ),
        // Action buttons - positioned higher
        Positioned(
          right: 16,
          bottom: 200,
          child: Column(
            children: [
              if (clip.hasWhatsApp) ...[
                _ActionButton(
                  imagePath: 'assets/icons_clips/whatsapp.png',
                  label: 'WhatsApp',
                  onTap: () => _openWhatsApp(clip),
                ),
                const SizedBox(height: 18),
              ],
              _ActionButton(
                imagePath: isSaved ? '' : 'assets/icons_clips/save.png',
                icon: isSaved ? Icons.bookmark : null,
                iconColor: isSaved ? brandRed : Colors.white,
                label: isSaved ? 'Saved' : 'Save',
                onTap: () => _toggleSave(index),
              ),
              const SizedBox(height: 18),
              _ActionButton(
                imagePath: 'assets/icons_clips/share.png',
                label: 'Share',
                onTap: () => _shareClip(clip),
              ),
            ],
          ),
        ),
        // Bottom content
        Positioned(
          left: 16,
          right: 80,
          bottom: 30,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Developer info row - tappable to go to project details
                Row(
                  children: [
                    // Developer avatar - tappable
                    GestureDetector(
                      onTap: () => _openProjectDetails(clip),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: clip.developerLogo.isNotEmpty
                              ? Image.asset(
                                  clip.developerLogo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.business,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                )
                              : const Icon(
                                  Icons.business,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Developer name - tappable, flexible width
                    Flexible(
                      child: GestureDetector(
                        onTap: () => _openProjectDetails(clip),
                        child: Text(
                          clip.developerName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Watch Orientation button
                    GestureDetector(
                      onTap: () => _openEpisodes(clip),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: brandRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle_filled,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Watch Orientation',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Title - tappable to go to project details
                GestureDetector(
                  onTap: () => _openProjectDetails(clip),
                  child: Text(
                    clip.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    clip.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFE50914),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color iconColor;

  const _ActionButton({
    required this.imagePath,
    required this.label,
    required this.onTap,
    this.icon,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          icon != null
              ? Icon(icon, color: iconColor, size: 32)
              : Image.asset(
                  imagePath,
                  width: 32,
                  height: 32,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.circle,
                    color: iconColor,
                    size: 32,
                  ),
                ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
