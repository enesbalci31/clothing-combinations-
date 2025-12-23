import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  /// Onboarding ekranlarındaki hissi veren preset
  const AppBackground.onboarding({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Görsellerine benzer: mavi -> mor -> pembe
    const colors = [
      Color(0xFF123B7A), // deep blue
      Color(0xFF2E5FB8), // blue
      Color(0xFF7B5CF0), // violet
      Color(0xFFFF5DB1), // pink
    ];

    return Stack(
      children: [
        // Gradient katmanı
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
              stops: [0.0, 0.45, 0.75, 1.0],
            ),
          ),
        ),

        // Çok hafif “desen/ikon” hissi
        IgnorePointer(
          child: CustomPaint(
            painter: _SubtlePatternPainter(),
            size: Size.infinite,
          ),
        ),

        // İçerik
        child,
      ],
    );
  }
}

class _SubtlePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Basit ikon hissi: daire + yıldız + küçük çizgiler
    void circle(Offset c, double r) => canvas.drawCircle(c, r, paint);

    void star(Offset c, double r) {
      final p = Path();
      for (int i = 0; i < 10; i++) {
        final a = (i * 36.0) * 3.1415926535 / 180.0;
        final rr = (i.isEven) ? r : r * 0.45;
        final x = c.dx + rr * Math.cos(a);
        final y = c.dy + rr * Math.sin(a);
        if (i == 0) {
          p.moveTo(x, y);
        } else {
          p.lineTo(x, y);
        }
      }
      p.close();
      canvas.drawPath(p, paint);
    }

    // Minimal math helper (dart:math kullanmadan)
    // Bu yüzden küçük bir “Math” sınıfı yazıyoruz:
    // -> aşağıda.

    // Yerleşimler
    circle(Offset(size.width * 0.18, size.height * 0.18), 56);
    circle(Offset(size.width * 0.82, size.height * 0.22), 44);
    circle(Offset(size.width * 0.25, size.height * 0.72), 60);
    circle(Offset(size.width * 0.78, size.height * 0.78), 48);

    star(Offset(size.width * 0.70, size.height * 0.40), 18);
    star(Offset(size.width * 0.32, size.height * 0.52), 14);

    // küçük çizgiler
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.10, size.height * 0.33),
      Offset(size.width * 0.28, size.height * 0.33),
      linePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.62, size.height * 0.62),
      Offset(size.width * 0.88, size.height * 0.62),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// dart:math import etmeden sin/cos için mini helper
class Math {
  static double sin(double x) => _sin(x);
  static double cos(double x) => _cos(x);

  // Basit yaklaşım: Taylor (küçük desen için yeterli)
  static double _sin(double x) {
    x = _normalize(x);
    final x2 = x * x;
    return x * (1 - x2 / 6 + (x2 * x2) / 120);
  }

  static double _cos(double x) {
    x = _normalize(x);
    final x2 = x * x;
    return 1 - x2 / 2 + (x2 * x2) / 24;
  }

  static double _normalize(double x) {
    const pi = 3.1415926535897932;
    while (x > pi) x -= 2 * pi;
    while (x < -pi) x += 2 * pi;
    return x;
  }
}
