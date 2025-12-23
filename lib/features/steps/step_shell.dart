import 'package:flutter/material.dart';

class StepShell extends StatelessWidget {
  final Widget child;
  final List<Color> gradient;
  final List<String> emojis; // dekor için
  final EdgeInsets padding;

  const StepShell({
    super.key,
    required this.child,
    required this.gradient,
    this.emojis = const [],
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const SizedBox.expand(),
        ),

        // Emoji pattern (çok hafif)
        if (emojis.isNotEmpty)
          IgnorePointer(
            child: Opacity(
              opacity: 0.10,
              child: _EmojiPattern(emojis: emojis),
            ),
          ),

        SafeArea(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _EmojiPattern extends StatelessWidget {
  final List<String> emojis;
  const _EmojiPattern({required this.emojis});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = (c.maxWidth / 120).clamp(3, 8).toInt();
        final rows = (c.maxHeight / 110).clamp(5, 12).toInt();

        return Column(
          children: List.generate(rows, (r) {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(cols, (i) {
                  final emoji = emojis[(r * cols + i) % emojis.length];
                  return Text(
                    emoji,
                    style: const TextStyle(fontSize: 42),
                  );
                }),
              ),
            );
          }),
        );
      },
    );
  }
}
