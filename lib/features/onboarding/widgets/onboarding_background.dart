import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            cs.primaryContainer.withValues(alpha: 0.55),
            cs.surface,
          ],
        ),
      ),
      child: Stack(
        children: [
          // soft blobs
          Positioned(
            top: -80,
            left: -80,
            child: _Blob(color: cs.tertiaryContainer.withValues(alpha: 0.55), size: 220),
          ),
          Positioned(
            top: 60,
            right: -90,
            child: _Blob(color: cs.secondaryContainer.withValues(alpha: 0.55), size: 260),
          ),
          Positioned(
            bottom: -120,
            left: -60,
            child: _Blob(color: cs.primaryContainer.withValues(alpha: 0.40), size: 280),
          ),

          // light dots
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _DotsPainter(color: cs.onSurface.withValues(alpha: 0.05)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  _DotsPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const step = 26.0;
    for (double y = 10; y < size.height; y += step) {
      for (double x = 10; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
