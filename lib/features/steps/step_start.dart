import 'dart:math' as math;

import 'package:clothess/features/steps/step_shell.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StepStart extends StatelessWidget {
  final VoidCallback onNext;

  const StepStart({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return StepShell(
      gradient: const [
        Color(0xFF0F172A), // deep navy
        Color(0xFF3B82F6), // blue
        Color(0xFFEC4899), // pink
      ],
      emojis: const ['👗', '🧥', '👟', '🧢', '🧵', '✨', '👜'],
      child: Column(
        children: [
          const _StepProgress(current: 1, total: 4),
          SizedBox(height: 3.h),

          Text(
            'Kombin Dünyası',
            textAlign: TextAlign.center,
            style: t.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.05,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 1.2.h),

          Text(
            'Stiline göre öneriler • Dolap • Favoriler',
            textAlign: TextAlign.center,
            style: t.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.90),
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 4.2.h),

          // 🔥 ORTADA “ATEŞ EDEN” HERO
          const _FireHero(),

          SizedBox(height: 3.2.h),

          // Badge’ler aşağıya alındı
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: const [
              _Badge('🧠 Akıllı öneri'),
              _Badge('🧾 KVKK & Güven'),
              _Badge('📸 Kamera ile ekle'),
              _Badge('⚡ Hızlı başlangıç'),
            ],
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('Başlayalım 🚀'),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}

class _FireHero extends StatelessWidget {
  const _FireHero();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // Ring + rozet + sparklar
          SizedBox(
            height: 24.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow ring (cam + neon)
                Container(
                  width: 26.w * 2.0,
                  height: 26.w * 2.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.18),
                        Colors.white.withValues(alpha: 0.06),
                      ],
                    ),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.10),
                        blurRadius: 30,
                        spreadRadius: 6,
                      ),
                      BoxShadow(
                        color: const Color(0xFFEC4899).withValues(alpha: 0.18),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.18),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),

                // İç çekirdek (daha koyu cam)
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.18),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  ),
                ),

                // Üçgen “rozet”
                Transform.rotate(
                  angle: -math.pi / 2,
                  child: CustomPaint(
                    size: Size(18.w, 18.w),
                    painter: _TrianglePainter(
                      fill: Colors.white.withValues(alpha: 0.14),
                      stroke: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                ),

                // Merkez metin
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '60 sn',
                      style: t.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 0.95,
                      ),
                    ),
                    SizedBox(height: 0.8.h),
                    Text(
                      'Profilini tamamla',
                      textAlign: TextAlign.center,
                      style: t.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 1.2.h),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                      ),
                      child: Text(
                        '🔥 Hızlı ve kişisel öneriler',
                        style: t.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                // Sparklar (ateş hissi)
                Positioned(
                  top: 10,
                  left: 24,
                  child: _Spark(text: '✦', size: 22),
                ),
                Positioned(
                  top: 28,
                  right: 20,
                  child: _Spark(text: '✺', size: 20),
                ),
                Positioned(
                  bottom: 14,
                  left: 30,
                  child: _Spark(text: '✧', size: 18),
                ),
                Positioned(
                  bottom: 26,
                  right: 32,
                  child: _Spark(text: '✦', size: 24),
                ),
              ],
            ),
          ),

          SizedBox(height: 1.4.h),

          // Açıklama (kart değil, temiz)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              'Bedenine ve stiline göre kombin önerileri, dolabın, favorilerin ve daha fazlası seni bekliyor.',
              textAlign: TextAlign.center,
              style: t.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.90),
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Spark extends StatelessWidget {
  const _Spark({required this.text, required this.size});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: Colors.white.withValues(alpha: 0.55),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  _TrianglePainter({required this.fill, required this.stroke});

  final Color fill;
  final Color stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.95),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int current;
  final int total;
  const _StepProgress({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i < current;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 8),
            height: 6,
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        );
      }),
    );
  }
}
