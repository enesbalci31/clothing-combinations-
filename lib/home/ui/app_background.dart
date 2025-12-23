import 'dart:math' as math;
import 'package:flutter/material.dart';

class AppBackground extends StatefulWidget {
  final Widget child;

  const AppBackground.onboarding({
    super.key,
    required this.child,
  });

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFF071B3A),
      Color(0xFF1F6FEB),
      Color(0xFF7C3AED),
      Color(0xFFFF2D9A),
    ];

    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_c.value);

        return Stack(
          children: [
            // Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors,
                  stops: [0.0, 0.42, 0.74, 1.0],
                ),
              ),
            ),

            // Sarı/pembe glow
            IgnorePointer(
              child: CustomPaint(
                painter: _GlowPainter(progress: t),
                size: Size.infinite,
              ),
            ),

            // İkon + yıldız katmanı
            IgnorePointer(
              child: CustomPaint(
                painter: _IconPatternPainter(progress: t),
                size: Size.infinite,
              ),
            ),

            widget.child,
          ],
        );
      },
    );
  }
}

class _GlowPainter extends CustomPainter {
  final double progress;
  const _GlowPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress;

    final glow1 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFD54F).withValues(alpha: 0.26 + 0.10 * p),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * (0.84 + 0.02 * p), size.height * (0.16 - 0.02 * p)),
        radius: size.shortestSide * (0.60 + 0.06 * p),
      ));

    final glow2 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF5DB1).withValues(alpha: 0.12 + 0.07 * p),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.20, size.height * 0.92),
        radius: size.shortestSide * 0.70,
      ));

    canvas.drawRect(Offset.zero & size, glow1);
    canvas.drawRect(Offset.zero & size, glow2);
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
class _IconPatternPainter extends CustomPainter {
  final double progress;
  const _IconPatternPainter({required this.progress});

  // Kıyafet/Moda temalı ikonlar
  static const _fashionIcons = <IconData>[
    Icons.checkroom_outlined,        // kıyafet
    Icons.dry_cleaning_outlined,     // kuru temizleme/stil
    Icons.style_outlined,            // stil
    Icons.local_offer_outlined,      // etiket/indirim
    Icons.sell_outlined,             // etiket
    Icons.shopping_bag_outlined,     // çanta
    Icons.storefront_outlined,       // mağaza
    Icons.inventory_2_outlined,      // ürün
  ];

  // Paletten uyumlu “renkli” tonlar (çok canlı ama alpha düşük)
  static const _palette = <Color>[
    Color(0xFF7C3AED), // mor
    Color(0xFF1F6FEB), // mavi
    Color(0xFFFF2D9A), // pembe
    Color(0xFFFFD54F), // sarı
    Color(0xFF22C55E), // hafif yeşil vurgu (az kullanacağız)
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress;
    final phase = p * 2 * math.pi;

    // İkon yerleşimleri: daha fazla, kenarlarda yoğun
    final stamps = <_Stamp>[
      _Stamp(Offset(size.width * 0.12, size.height * 0.12), _fashionIcons[0], 52, -0.18, 1, 0),
      _Stamp(Offset(size.width * 0.86, size.height * 0.10), _fashionIcons[5], 50,  0.20, 2, 1),
      _Stamp(Offset(size.width * 0.88, size.height * 0.32), _fashionIcons[3], 46, -0.10, 3, 3),
      _Stamp(Offset(size.width * 0.10, size.height * 0.34), _fashionIcons[2], 48,  0.14, 4, 2),

      _Stamp(Offset(size.width * 0.84, size.height * 0.52), _fashionIcons[6], 54, -0.12, 5, 0),
      _Stamp(Offset(size.width * 0.18, size.height * 0.58), _fashionIcons[1], 56,  0.12, 6, 1),

      _Stamp(Offset(size.width * 0.74, size.height * 0.72), _fashionIcons[7], 58, -0.10, 7, 2),
      _Stamp(Offset(size.width * 0.22, size.height * 0.82), _fashionIcons[4], 52,  0.10, 8, 3),

      _Stamp(Offset(size.width * 0.52, size.height * 0.18), _fashionIcons[5], 60,  0.08, 9, 0),
      _Stamp(Offset(size.width * 0.50, size.height * 0.90), _fashionIcons[0], 56, -0.06, 10, 2),
    ];

    for (final s in stamps) {
      // hafif hareket
      final dx = math.sin(phase + s.seed) * 10;
      final dy = math.cos(phase + s.seed) * 8;

      // renk + opaklık (Renkli ama “bozmayacak” kadar düşük)
      final baseAlpha = 0.12; // güvenli seviye
      final pulse = 0.06 * (0.5 + 0.5 * math.sin(phase + s.seed));
      final alpha = (baseAlpha + pulse).clamp(0.10, 0.22);

      final color = _palette[s.paletteIndex % _palette.length].withValues(alpha: alpha);

      _stampIcon(
        canvas,
        at: Offset(s.at.dx + dx, s.at.dy + dy),
        icon: s.icon,
        size: s.size,
        color: color,
        rotation: s.rotation,
      );
    }

    // Yıldızlar (yanıp sönen)
    _sparkle(canvas, Offset(size.width * 0.70, size.height * 0.36), 18, p);
    _sparkle(canvas, Offset(size.width * 0.32, size.height * 0.52), 14, 1 - p);
    _sparkle(canvas, Offset(size.width * 0.50, size.height * 0.10), 12, (p * 0.7) + 0.2);
    _sparkle(canvas, Offset(size.width * 0.90, size.height * 0.86), 13, (1 - p) * 0.9);
  }

  void _sparkle(Canvas canvas, Offset c, double r, double phase01) {
    final alpha = (0.12 + 0.22 * phase01).clamp(0.0, 0.34);
    final rr = r * (0.85 + 0.30 * phase01);

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final path = Path();
    for (int i = 0; i < 10; i++) {
      final ang = (i * 36.0) * math.pi / 180.0;
      final rad = (i.isEven) ? rr : rr * 0.45;
      final x = c.dx + rad * math.cos(ang);
      final y = c.dy + rad * math.sin(ang);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    final glow = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.05 + 0.10 * phase01)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(c, rr * 0.55, glow);
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

    final tp = TextPainter(
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

    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _IconPatternPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Stamp {
  final Offset at;
  final IconData icon;
  final double size;
  final double rotation;
  final int seed;
  final int paletteIndex;

  const _Stamp(this.at, this.icon, this.size, this.rotation, this.seed, this.paletteIndex);
}
