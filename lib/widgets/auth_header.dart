import 'package:flutter/material.dart';
import 'orientation_logo.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        children: [
          // Background with geometric shapes
          const GeometricBackground(),
          // Logo centered
          const Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: OrientationLogo(),
            ),
          ),
        ],
      ),
    );
  }
}

class GeometricBackground extends StatelessWidget {
  const GeometricBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GeometricPainter(),
      size: Size.infinite,
    );
  }
}

class _GeometricPainter extends CustomPainter {
  static const Color darkRed = Color(0xFF8B0000);
  static const Color brandRed = Color(0xFFE50914);
  static const Color darkBg = Color(0xFF1a0a0a);

  @override
  void paint(Canvas canvas, Size size) {
    // Dark background base
    final bgPaint = Paint()
      ..color = darkBg
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Large dark red diamond (rotated square) - back layer
    final darkRedPaint = Paint()
      ..color = darkRed.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final largeDiamond = Path();
    largeDiamond.moveTo(size.width * 0.15, size.height * 0.1);
    largeDiamond.lineTo(size.width * 0.55, size.height * -0.2);
    largeDiamond.lineTo(size.width * 0.85, size.height * 0.3);
    largeDiamond.lineTo(size.width * 0.45, size.height * 0.6);
    largeDiamond.close();
    canvas.drawPath(largeDiamond, darkRedPaint);

    // Medium bright red diamond - middle layer
    final brightRedPaint = Paint()
      ..color = brandRed.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final mediumDiamond = Path();
    mediumDiamond.moveTo(size.width * 0.0, size.height * 0.25);
    mediumDiamond.lineTo(size.width * 0.25, size.height * -0.05);
    mediumDiamond.lineTo(size.width * 0.55, size.height * 0.25);
    mediumDiamond.lineTo(size.width * 0.30, size.height * 0.55);
    mediumDiamond.close();
    canvas.drawPath(mediumDiamond, brightRedPaint);

    // Small dark diamond - top layer accent
    final smallDiamond = Path();
    smallDiamond.moveTo(size.width * 0.35, size.height * 0.35);
    smallDiamond.lineTo(size.width * 0.50, size.height * 0.15);
    smallDiamond.lineTo(size.width * 0.65, size.height * 0.35);
    smallDiamond.lineTo(size.width * 0.50, size.height * 0.55);
    smallDiamond.close();
    canvas.drawPath(smallDiamond, darkRedPaint..color = darkRed.withOpacity(0.7));

    // Gradient overlay for smooth transition to black
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.3),
          Colors.black.withOpacity(0.8),
          Colors.black,
        ],
        stops: const [0.0, 0.5, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

