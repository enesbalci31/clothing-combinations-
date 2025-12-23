import 'package:flutter/material.dart';

class ObField extends StatelessWidget {
  const ObField({
    super.key,
    required this.label,
    required this.child,
    this.emoji,
    this.helper,
  });

  final String label;
  final Widget child;
  final String? emoji;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  style: t.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          if (helper != null) ...[
            const SizedBox(height: 6),
            Text(helper!, style: t.textTheme.bodySmall),
          ],
          const SizedBox(height: 10),

          // Input görünümünü yumuşat
          Theme(
            data: t.copyWith(
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.55),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.primary, width: 1.5),
                ),
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
