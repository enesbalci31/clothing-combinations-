import 'dart:math' as math;
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground.onboarding({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Daha canlı: mavi -> mor -> pembe + sarı “glow”
    const colors = [
      Color(0xFF0B2A5A), // deep navy
      Color(0xFF1F5FD1), // vivid blue
      Color(0xFF7B5CF0), // violet
      Color(0xFFFF4FA8), // pink
    ];

    return Stack(
      children: [
        // Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
              stops: [0.0, 0.42, 0.72, 1.0],
            ),
          ),
        ),

        // Sarı glow (yumuşak, dikkat çekici ama gözü yormaz)
        IgnorePointer(
          child: CustomPaint(
            painter: _GlowPainter(),
            size: Size.infinite,
          ),
        ),

        // Desen / ikonlar
        IgnorePointer(
          child: CustomPaint(
            painter: _FashionPatternPainter(),
            size: Size.infinite,
          ),
        ),

        child,
      ],
    );
  }
}

/// Sarı “enerji” glow katmanı
class _GlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // üst sağ glow
    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFD54F).withValues(alpha: 0.22), // amber
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.85, size.height * 0.18),
        radius: size.shortestSide * 0.55,
      ));

    canvas.drawRect(Offset.zero & size, paint1);

    // alt sol glow
    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF176).withValues(alpha: 0.16), // soft yellow
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.18, size.height * 0.86),
        radius: size.shortestSide * 0.60,
      ));

    canvas.drawRect(Offset.zero & size, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Uygulama temalı ikon/desen katmanı (👕👟📷✨💛)
class _FashionPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // İnce çizgisel şekiller (dairesel halkalar)
    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    void ring(Offset c, double r) => canvas.drawCircle(c, r, stroke);

    ring(Offset(size.width * 0.18, size.height * 0.18), 54);
    ring(Offset(size.width * 0.82, size.height * 0.22), 44);
    ring(Offset(size.width * 0.22, size.height * 0.74), 62);
    ring(Offset(size.width * 0.78, size.height * 0.78), 48);

    // Parıltı yıldızları
    _drawSparkle(canvas, Offset(size.width * 0.70, size.height * 0.40), 18);
    _drawSparkle(canvas, Offset(size.width * 0.32, size.height * 0.52), 14);

    // İnce çizgiler
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
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

    // Uygulama ile anlamlı “ikon” damgaları (çok hafif)
    _stampIcon(
      canvas,
      size: 46,
      at: Offset(size.width * 0.12, size.height * 0.12),
      icon: Icons.checkroom_outlined, // kıyafet
      color: Colors.white.withValues(alpha: 0.10),
      rotation: -0.18,
    );

    _stampIcon(
      canvas,
      size: 44,
      at: Offset(size.width * 0.86, size.height * 0.10),
      icon: Icons.dry_cleaning_outlined, // stil/temizlik hissi
      color: Colors.white.withValues(alpha: 0.085),
      rotation: 0.20,
    );

    _stampIcon(
      canvas,
      size: 46,
      at: Offset(size.width * 0.86, size.height * 0.46),
      icon: Icons.photo_camera_outlined, // foto/kamera
      color: Colors.white.withValues(alpha: 0.10),
      rotation: -0.12,
    );

    _stampIcon(
      canvas,
      size: 48,
      at: Offset(size.width * 0.18, size.height * 0.90),
      icon: Icons.star_outline, // öneri/parıltı
      color: const Color(0xFFFFD54F).withValues(alpha: 0.16), // sarı
      rotation: 0.18,
    );

    _stampIcon(
      canvas,
      size: 46,
      at: Offset(size.width * 0.78, size.height * 0.88),
      icon: Icons.favorite_border, // favori
      color: Colors.white.withValues(alpha: 0.10),
      rotation: -0.10,
    );

    _stampIcon(
      canvas,
      size: 54,
      at: Offset(size.width * 0.52, size.height * 0.20),
      icon: Icons.shopping_bag_outlined, // dolap/alışveriş
      color: Colors.white.withValues(alpha: 0.08),
      rotation: 0.10,
    );
  }

  void _drawSparkle(Canvas canvas, Offset c, double r) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    for (int i = 0; i < 10; i++) {
      final a = (i * 36.0) * math.pi / 180.0;
      final rr = (i.isEven) ? r : r * 0.45;
      final x = c.dx + rr * math.cos(a);
      final y = c.dy + rr * math.sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, p);
  }

  void _stampIcon(
      Canvas canvas, {
        required Offset at,
        required IconData icon,
        required double size,
        required Color color,
        double rotation = 0,
      }) {
    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.rotate(rotation);

    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
