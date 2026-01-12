import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import '../widgets/orientation_logo.dart';
import '../widgets/loading_indicator.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _circleController;
  late AnimationController _rotationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _circleScaleAnimation;
  late Animation<double> _circleRotationAnimation;
  late Animation<double> _circleFadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _loadingFadeAnimation;
  late Animation<double> _fadeOutAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration? _audioDuration;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _zoomController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _zoomAnimation;
  late Animation<double> _cinematicBarsAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize audio first to get duration
    _initializeAudio();
    
    // Main controller - will be set based on audio duration
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 4500),
      vsync: this,
    );

    // Circle animation controller - starts big, shrinks when "button pressed"
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 800), // Quick rotation and shrink
      vsync: this,
    );

    // Rotation controller - even slower rotation
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 4000), // Even slower rotation
      vsync: this,
    );

    // Pulse controller for rhythmic effects synced with audio
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Glow controller for cinematic light effects (no repeat - single pulse)
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Zoom controller - slow start from inside to sync with audio
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 3000), // Slower to sync with audio
      vsync: this,
    );

    // Pulse animation for rhythmic visual effects
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Glow animation for cinematic light rays - medium red (not too light, not too strong)
    _glowAnimation = Tween<double>(
      begin: 0.4, // Medium
      end: 0.6,   // Medium brightness
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Zoom animation - starts from very small (inside) and grows slowly
    _zoomAnimation = Tween<double>(
      begin: 0.05, // Start very small (from inside)
      end: 1.0,    // End at normal size
    ).animate(CurvedAnimation(
      parent: _zoomController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut), // Slow and smooth
    ));

    // Cinematic bars animation (letterbox effect)
    _cinematicBarsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));

    // Circle fade in animation - appears immediately (big)
    _circleFadeAnimation = Tween<double>(
      begin: 1.0, // Already visible (big)
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: const Interval(0.0, 1.0, curve: Curves.linear),
    ));

    // Circle scale animation - starts BIG, then shrinks when "button is pressed"
    _circleScaleAnimation = Tween<double>(
      begin: 2.5, // Start BIG
      end: 1.0,   // Shrink to normal size (like button press)
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut), // Shrink when "pressed"
    ));

    // Circle rotation animation - full rotation when "button is pressed"
    _circleRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0, // Full 360 rotation
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut), // Rotate while shrinking
    ));

    // Text fade in animation (appears AFTER circle shrinks - "Orientation" with O as circle)
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 0.75, curve: Curves.easeIn), // After circle animation
    ));

    // Progress bar animation (starts after text appears)
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.65, 0.95, curve: Curves.easeInOut),
    ));

    // Loading indicator fade in (starts after text appears)
    _loadingFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.6, 0.75, curve: Curves.easeIn),
    ));

    // Fade out animation at the end (starts very late to keep brightness)
    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.98, 1.0, curve: Curves.easeOut),
    ));

    // Start cinematic sequence automatically (audio + animation in sync)
    _startCinematicSequence();

    // Stop rotation when circle starts shrinking
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        _rotationController.stop();
      }
    });

    // Navigate to main screen before animation completes for smoother transition
    bool _hasNavigated = false;
    _mainController.addListener(() {
      // Start navigation slightly before completion (at 92%) for smoother transition
      if (!_hasNavigated && _mainController.value >= 0.92) {
        _hasNavigated = true;
        if (mounted) {
          // Use PageRouteBuilder for smooth fade transition
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
              transitionDuration: const Duration(milliseconds: 600),
              reverseTransitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                // Fade in the new screen smoothly
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeIn,
                  ),
                  child: child,
                );
              },
            ),
          );
        }
      }
    });
  }

  // Initialize audio and get duration
  Future<void> _initializeAudio() async {
    try {
      await _audioPlayer.setAsset('assets/audio/sound splash_sound.MP3');
      await _audioPlayer.setVolume(0.6); // Cinematic volume
      _audioDuration = _audioPlayer.duration;
      
      // Sync animation duration with audio duration for perfect sync
      if (_audioDuration != null && _audioDuration!.inMilliseconds > 0) {
        setState(() {
          _mainController.duration = _audioDuration;
          // Adjust circle controller to be proportional (about 50% of total)
          _circleController.duration = Duration(
            milliseconds: (_audioDuration!.inMilliseconds * 0.5).round(),
          );
        });
      }
    } catch (e) {
      print('Could not initialize audio: $e');
      _audioDuration = const Duration(milliseconds: 4500);
    }
  }

  // Start animation and sound together (cinematic sync with rhythm)
  Future<void> _startCinematicSequence() async {
    // Wait a bit for audio to initialize
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      // Start audio
      final playFuture = _audioPlayer.play();
      _mainController.forward();
      
      // Circle starts BIG and visible (initial state - scale 2.5)
      // Animation will start when button click sound plays
      
      // Wait for audio to start
      await playFuture;
      
      // Single pulse effect at the beginning (with button click sound)
      // This triggers the circle to rotate and shrink (like button press)
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          // Start circle animation (rotate and shrink)
          _circleController.forward();
          
          // Pulse effect with button click
          _pulseController.forward(from: 0.0).then((_) {
            if (mounted) {
              _pulseController.reverse();
            }
          });
          // Glow effect with pulse
          _glowController.forward(from: 0.0).then((_) {
            if (mounted) {
              _glowController.reverse();
            }
          });
        }
      });
      
      // Listen to audio position for sync
      _audioPlayer.positionStream.listen((position) {
        if (!mounted) return;
        
        // Sync main animation progress with audio
        if (_audioDuration != null && _audioDuration!.inMilliseconds > 0) {
          final audioProgress = position.inMilliseconds / _audioDuration!.inMilliseconds;
          // Smooth sync - don't force it, let it flow naturally
          if (audioProgress > 0.95 && _mainController.value < 0.95) {
            // Near end - ensure sync
            _mainController.value = audioProgress.clamp(0.0, 1.0);
          }
        }
      });
    } catch (e) {
      print('Could not play splash sound: $e');
      // Continue with animation even if audio fails
      _circleController.forward();
      _mainController.forward();
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    _zoomController.dispose();
    _mainController.dispose();
    _circleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _mainController,
            _circleController,
            _rotationController,
            _pulseController,
            _glowController,
            _zoomController,
          ]),
          builder: (context, child) {
            // Keep opacity at 1.0 until navigation starts (at 92%)
            final opacity = _mainController.value < 0.92 
                ? 1.0 
                : _fadeOutAnimation.value;
            
            return Opacity(
              opacity: opacity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = constraints.maxWidth < 400;
                  final baseScale = isSmallScreen ? 0.8 : 1.0;
                  final circleScale = baseScale * _circleScaleAnimation.value;
                  // Rotation: full rotation during first phase, then stops
                  final rotationAngle = _circleRotationAnimation.value * 2 * 3.14159;

                  return Stack(
                    children: [
                      // Cinematic bars (letterbox effect) - top and bottom
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(
                          height: constraints.maxHeight * 0.1 * _cinematicBarsAnimation.value,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: constraints.maxHeight * 0.1 * _cinematicBarsAnimation.value,
                          color: Colors.black,
                        ),
                      ),
                      // Main content area with logo centered
                      Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Glow effect (light rays) - cinematic - medium red
                                  if (_circleFadeAnimation.value > 0.3)
                                    Container(
                                      width: 200 * circleScale * _glowAnimation.value,
                                      height: 200 * circleScale * _glowAnimation.value,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFE50914).withOpacity(0.5 * _glowAnimation.value), // Medium
                                            blurRadius: 80 * _glowAnimation.value,
                                            spreadRadius: 30 * _glowAnimation.value,
                                          ),
                                          BoxShadow(
                                            color: const Color(0xFFE50914).withOpacity(0.4 * _glowAnimation.value), // Medium
                                            blurRadius: 120 * _glowAnimation.value,
                                            spreadRadius: 50 * _glowAnimation.value,
                                          ),
                                        ],
                                      ),
                                    ),
                                  // Outer glow ring - medium
                                  if (_circleFadeAnimation.value > 0.5)
                                    Container(
                                      width: 120 * circleScale,
                                      height: 120 * circleScale,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFE50914).withOpacity(0.5 * _glowAnimation.value), // Medium
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  // Main circle (O) - starts BIG, rotates and shrinks when "button pressed"
                                  Opacity(
                                    opacity: _circleFadeAnimation.value,
                                    child: Transform.rotate(
                                      angle: rotationAngle * 2 * 3.14159, // Full rotation
                                      child: Transform.scale(
                                        scale: circleScale * _pulseAnimation.value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFFE50914).withOpacity(0.5 * _glowAnimation.value), // Medium
                                                blurRadius: 30,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: const PlayButtonIcon(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Text "Orientation" appears below circle - full word with O as separate circle
                          Opacity(
                            opacity: _textFadeAnimation.value,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // O as same shape as main circle (with play button icon) - bigger and closer
                                Transform.scale(
                                  scale: 0.85, // Even bigger to match text size better
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFE50914).withOpacity(0.4 * _glowAnimation.value), // Medium
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const PlayButtonIcon(),
                                  ),
                                ),
                                const SizedBox(width: 2), // Even closer to the word
                                // Rest of the word "rientation"
                                Transform.scale(
                                  scale: 0.8 + (_textFadeAnimation.value * 0.2),
                                  child: Text(
                                    'rientation',
                                    style: TextStyle(
                                      color: const Color(0xFFE50914),
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      height: 1.0,
                                      shadows: [
                                        Shadow(
                                          color: const Color(0xFFE50914).withOpacity(0.5 * _glowAnimation.value), // Medium
                                          blurRadius: 20,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Loading section at bottom
                          Opacity(
                            opacity: _loadingFadeAnimation.value,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.15,
                                vertical: 40,
                              ),
                              child: LoadingIndicator(
                                progress: _progressAnimation.value,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
