import 'package:clothess/features/steps/step_shell.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class StepPermissions extends StatelessWidget {
  final bool cameraAllowed;
  final bool notificationsAllowed;

  final ValueChanged<bool> onCameraChanged;
  final ValueChanged<bool> onNotificationsChanged;

  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepPermissions({
    super.key,
    required this.cameraAllowed,
    required this.notificationsAllowed,
    required this.onCameraChanged,
    required this.onNotificationsChanged,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return StepShell(
      gradient: const [
        Color(0xFF0B1020),
        Color(0xFFFB7185), // rose
        Color(0xFFF59E0B), // amber
      ],
      emojis: const ['📸', '🔔', '👗', '✨', '🧥', '👟'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepProgress(current: 4, total: 4),
          SizedBox(height: 2.5.h),

          Text('Son Dokunuşlar ✨', style: t.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
          SizedBox(height: 1.h),
          Text(
            'Kamera ile dolabını ekle, bildirimlerle yeni önerileri kaçırma.',
            style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha:0.92)),
          ),
          SizedBox(height: 2.2.h),

          _PermissionTile(
            emoji: '📸',
            title: 'Kamera İzni',
            subtitle: 'Kıyafet fotoğrafı çekmek ve dolabına eklemek için gerekli.',
            enabled: cameraAllowed,
            onToggle: () => onCameraChanged(!cameraAllowed),
            accent: const Color(0xFF22C55E),
          ),
          SizedBox(height: 1.4.h),
          _PermissionTile(
            emoji: '🔔',
            title: 'Bildirim İzni',
            subtitle: 'Yeni kombin önerileri ve hatırlatmalar için.',
            enabled: notificationsAllowed,
            onToggle: () => onNotificationsChanged(!notificationsAllowed),
            accent: const Color(0xFF60A5FA),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Geri'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha:0.4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onNext,
                  label: const Text('Devam'),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onToggle;
  final Color accent;

  const _PermissionTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onToggle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:enabled ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: enabled ? accent.withValues(alpha:0.55) : Colors.white.withValues(alpha:0.18),
          width: enabled ? 1.2 : 1,
        ),
        boxShadow: enabled
            ? [
          BoxShadow(
            color: accent.withValues(alpha:0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha:0.22),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha:0.90))),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (_) => onToggle(),
          ),
        ],
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
              color: active ? Colors.white : Colors.white.withValues(alpha:0.25),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        );
      }),
    );
  }
}
