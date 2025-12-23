import 'package:clothess/features/steps/step_shell.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:sizer/sizer.dart';


class StepCelebration extends StatefulWidget {
  final VoidCallback onNext;

  const StepCelebration({super.key, required this.onNext});

  @override
  State<StepCelebration> createState() => _StepCelebrationState();
}

class _StepCelebrationState extends State<StepCelebration> with SingleTickerProviderStateMixin {
  late final ConfettiController _confetti;
  late final AnimationController _pop;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    _pop = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _confetti.play();
    _pop.forward();
  }

  @override
  void dispose() {
    _confetti.dispose();
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return StepShell(
      gradient: const [
        Color(0xFF0B1020),
        Color(0xFF22C55E),
        Color(0xFF60A5FA),
        Color(0xFFF59E0B),
      ],
      emojis: const ['🎉', '👗', '👟', '🧥', '✨', '🧢', '👜'],
      child: Stack(
        children: [
          // FULL SCREEN CONFETTI (üstten ve alttan)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.08,
              numberOfParticles: 25,
              gravity: 0.35,
              minimumSize: const Size(10, 6),
              maximumSize: const Size(18, 10),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.06,
              numberOfParticles: 18,
              gravity: 0.6,
              minimumSize: const Size(8, 6),
              maximumSize: const Size(14, 10),
            ),
          ),

          // CONTENT
          Center(
            child: ScaleTransition(
              scale: CurvedAnimation(parent: _pop, curve: Curves.elasticOut),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.14),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withValues(alpha:0.22)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.18),
                      blurRadius: 26,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🎊 Harika!', style: t.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                    SizedBox(height: 1.h),
                    Text(
                      'Profilin hazır. Artık bedenine ve stiline göre kombin önerileri sunacağız.',
                      textAlign: TextAlign.center,
                      style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha:0.92)),
                    ),
                    SizedBox(height: 2.h),

                    // küçük “dönen” görsel hissi (emoji carousel gibi)
                    _EmojiSpinner(),
                    SizedBox(height: 2.2.h),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: widget.onNext,
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: const Text('Kombinlere geç ✨'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiSpinner extends StatefulWidget {
  @override
  State<_EmojiSpinner> createState() => _EmojiSpinnerState();
}

class _EmojiSpinnerState extends State<_EmojiSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: CurvedAnimation(parent: _c, curve: Curves.linear),
      child: Container(
        width: 86,
        height: 86,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha:0.14),
          border: Border.all(color: Colors.white.withValues(alpha:0.22)),
        ),
        child: const Text('👗', style: TextStyle(fontSize: 34)),
      ),
    );
  }
}
