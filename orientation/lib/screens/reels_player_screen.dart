import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/clip_model.dart';
import '../services/api/project_api.dart';
import '../services/reels_video_manager.dart';
import '../utils/auth_helper.dart';
import 'project_details_screen.dart';

class ReelsPlayerScreen extends StatefulWidget {
  final List<ClipModel> clips;
  final int initialIndex;

  const ReelsPlayerScreen({
    super.key,
    required this.clips,
    this.initialIndex = 0,
  });

  @override
  State<ReelsPlayerScreen> createState() => _ReelsPlayerScreenState();
}

class _ReelsPlayerScreenState extends State<ReelsPlayerScreen> with WidgetsBindingObserver {
  late PageController _pageController;
  final ProjectApi _projectApi = ProjectApi();
  final ReelsVideoManager _videoManager = ReelsVideoManager();
  final Map<int, bool> _likedClips = {};
  final Map<String, bool> _savedReelIds = {}; // Store saved status by reel ID
  int _currentIndex = 0;
  bool _isInitialized = false;

  static const Color brandRed = Color(0xFFE50914);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _initialize();
  }

  Future<void> _initialize() async {
    // Initialize video manager with clips (starts preloading immediately)
    _videoManager.initialize(widget.clips);
    
    // Mark as initialized immediately so UI can show placeholders
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
    
    // Load initial video (non-blocking for UI)
    _initializeCurrentVideo();
    
    // Load liked and saved status in parallel (non-blocking)
    _loadLikedStatus();
    _loadSavedStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || 
        state == AppLifecycleState.inactive) {
      _videoManager.pauseAll();
    } else if (state == AppLifecycleState.resumed) {
      _videoManager.playCurrent();
    }
  }

  Future<void> _loadLikedStatus() async {
    for (int i = 0; i < widget.clips.length; i++) {
      final isLiked = await _projectApi.isClipLiked(widget.clips[i].id);
      if (mounted) {
        setState(() {
          _likedClips[i] = isLiked;
        });
      }
    }
  }

  Future<void> _loadSavedStatus() async {
    if (!mounted) return;
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
      print('❌ Error loading saved reels status: $e');
    }
  }

  Future<void> _initializeCurrentVideo() async {
    final controller = await _videoManager.getControllerForIndex(
      _currentIndex,
      shouldPlay: true,
    );
    
    if (controller != null && mounted) {
      setState(() {});
    }
  }

  void _onPageChanged(int index) {
    if (index == _currentIndex) return;
    
    // Update video manager
    _videoManager.updateCurrentIndex(index);
    
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoManager.pauseAll();
    _pageController.dispose();
    // Note: Don't dispose video manager here - it's a singleton
    // It will manage its own lifecycle
    super.dispose();
  }

  Future<void> _toggleLike(int index) async {
    final clip = widget.clips[index];
    final isCurrentlyLiked = _likedClips[index] ?? false;

    setState(() {
      _likedClips[index] = !isCurrentlyLiked;
    });

    try {
      if (!isCurrentlyLiked) {
        await _projectApi.likeClip(clip.id);
      } else {
        await _projectApi.unlikeClip(clip.id);
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          _likedClips[index] = isCurrentlyLiked;
        });
      }
    }
  }

  Future<void> _toggleSave(int index) async {
    if (!mounted) return;
    
    final isAuth = await AuthHelper.requireAuth(context);
    if (!isAuth || !mounted) return;
    
    final clip = widget.clips[index];
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
        if (success) {
          if (mounted) _showSnackBar('Saved!', isSuccess: true);
        } else {
          // Revert on failure
          if (mounted) {
            setState(() {
              _savedReelIds[clip.id] = isCurrentlySaved;
            });
            _showSnackBar('Error saving reel', isSuccess: false);
          }
        }
      } else {
        final success = await _projectApi.unsaveReel(clip.id);
        if (success) {
          if (mounted) _showSnackBar('Removed from saved', isSuccess: true);
        } else {
          // Revert on failure
          if (mounted) {
            setState(() {
              _savedReelIds[clip.id] = isCurrentlySaved;
            });
            _showSnackBar('Error removing reel', isSuccess: false);
          }
        }
      }
    } catch (e) {
      print('❌ Error in _toggleSave: $e');
      // Revert on error
      if (mounted) {
        setState(() {
          _savedReelIds[clip.id] = isCurrentlySaved;
        });
        _showSnackBar('Error saving/removing reel', isSuccess: false);
      }
    }
  }

  Future<void> _openWhatsApp(ClipModel clip) async {
    const phone = '201205403733'; // Default number
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
    if (!isAuth) return;
    
    _videoManager.pauseAll();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailsScreen(projectId: clip.projectId),
      ),
    );
  }

  void _openEpisodes(ClipModel clip) async {
    final isAuth = await AuthHelper.requireAuth(context);
    if (!isAuth) return;
    
    _videoManager.pauseAll();
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
    if (!mounted) return;
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video PageView
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: widget.clips.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return _buildReelItem(index);
            },
          ),
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: () {
                _videoManager.pauseAll();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReelItem(int index) {
    final clip = widget.clips[index];
    final controller = _videoManager.controllers[index]; // Access through manager
    final isLiked = _likedClips[index] ?? false;
    final isSaved = _savedReelIds[clip.id] ?? false;
    
    // Initialize video if not already loaded
    if (controller == null && _isInitialized) {
      // Trigger initialization in background
      _videoManager.getControllerForIndex(
        index,
        shouldPlay: index == _currentIndex,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Video or Placeholder
        GestureDetector(
          onTap: () async {
            if (controller != null && controller.value.isInitialized) {
              if (controller.value.isPlaying) {
                controller.pause();
              } else {
                controller.play();
              }
              setState(() {});
            } else {
              // Initialize if not ready
              await _videoManager.getControllerForIndex(
                index,
                shouldPlay: true,
              );
              if (mounted) setState(() {});
            }
          },
          child: controller != null && controller.value.isInitialized
              ? Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                )
              : _buildLoadingState(clip, index),
        ),
        // Play/Pause indicator
        if (controller != null && controller.value.isInitialized && !controller.value.isPlaying)
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        // Gradient overlay at bottom
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
        // Action buttons (right side) - positioned higher
        Positioned(
          right: 16,
          bottom: 200,
          child: Column(
            children: [
              if (clip.hasWhatsApp) ...[
                _ActionButton(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  onTap: () => _openWhatsApp(clip),
                  useImage: true,
                  imagePath: 'assets/icons_clips/whatsapp.png',
                ),
                const SizedBox(height: 18),
              ],
              _ActionButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                label: '${clip.likes + (isLiked ? 1 : 0)}',
                onTap: () => _toggleLike(index),
                iconColor: isLiked ? brandRed : Colors.white,
                useImage: !isLiked,
                imagePath: 'assets/icons_clips/like.png',
              ),
              const SizedBox(height: 18),
              _ActionButton(
                icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                label: isSaved ? 'Saved' : 'Save',
                onTap: () => _toggleSave(index),
                iconColor: isSaved ? brandRed : Colors.white,
                useImage: !isSaved,
                imagePath: 'assets/icons_clips/save.png',
              ),
              const SizedBox(height: 18),
              _ActionButton(
                icon: Icons.share,
                label: 'Share',
                onTap: () => _shareClip(clip),
                useImage: true,
                imagePath: 'assets/icons_clips/share.png',
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
                // Developer info row
                Row(
                  children: [
                    // Avatar - tappable
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
                    // Name - tappable, flexible width
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
                    // Watch button - opens Episodes tab
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
                // Title - tappable
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
                // Description
                Text(
                  clip.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(ClipModel clip, int index) {
    // Show shimmer loader while video is loading
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Thumbnail as placeholder
          if (clip.thumbnail.isNotEmpty)
            clip.isAsset
                ? Image.asset(
                    clip.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildShimmerLoader(),
                  )
                : Image.network(
                    clip.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildShimmerLoader(),
                  )
          else
            _buildShimmerLoader(),
          // Loading indicator overlay
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const CircularProgressIndicator(
                color: brandRed,
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: CircularProgressIndicator(
          color: brandRed,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final bool useImage;
  final String imagePath;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor = Colors.white,
    this.useImage = false,
    this.imagePath = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          useImage && imagePath.isNotEmpty
              ? Image.asset(
                  imagePath,
                  width: 32,
                  height: 32,
                  errorBuilder: (_, __, ___) => Icon(
                    icon,
                    color: iconColor,
                    size: 32,
                  ),
                )
              : Icon(
                  icon,
                  color: iconColor,
                  size: 32,
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
