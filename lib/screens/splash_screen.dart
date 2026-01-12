import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    
    // Main controller for progress and fade out (slower - 4000ms instead of 3000ms)
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 4500),
      vsync: this,
    );

    // Circle animation controller - big to small (slower - 2200ms instead of 1500ms)
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    // Rotation controller - continuous rotation (slower - 1500ms instead of 1000ms)
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(); // Continuous rotation

    // Circle fade in animation
    _circleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
    ));

    // Circle scale animation (starts BIG and shrinks)
    _circleScaleAnimation = Tween<double>(
      begin: 3.5, // Start very big
      end: 1.0,   // End at normal size
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    // Circle rotation animation (stops when shrinking)
    _circleRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: const Interval(0.0, 0.5, curve: Curves.linear),
    ));

    // Text fade in animation (appears after circle shrinks)
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.55, 0.75, curve: Curves.easeIn),
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

    // Start animations
    _circleController.forward();
    _mainController.forward();

    // Stop rotation when circle starts shrinking (slower - 900ms instead of 600ms)
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

  @override
  void dispose() {
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

                  return Column(
                    children: [
                      // Main content area with logo centered
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Circle (play button) with animation
                              Opacity(
                                opacity: _circleFadeAnimation.value,
                                child: Transform.rotate(
                                  angle: rotationAngle,
                                  child: Transform.scale(
                                    scale: circleScale,
                                    child: const PlayButtonIcon(),
                                  ),
                                ),
                              ),
                              // Text with fade in animation
                              Opacity(
                                opacity: _textFadeAnimation.value,
                                child: const Text(
                                  'rientation',
                                  style: TextStyle(
                                    color: Color(0xFFE50914),
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
