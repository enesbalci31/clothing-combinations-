import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../onboarding/onboarding_controller.dart';
import '../../home/ui/app_background.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.read(appPrefsProvider);

    final name = prefs.displayName.isNotEmpty ? prefs.displayName : 'İsimsiz';
    final height = prefs.heightCm > 0 ? '${prefs.heightCm} cm' : '—';
    final weight = prefs.weightKg > 0 ? '${prefs.weightKg} kg' : '—';
    final size = prefs.size.isNotEmpty ? prefs.size : '—';
    final style = prefs.style.isNotEmpty ? prefs.style : '—';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            final nav = Navigator.of(context);
            if (nav.canPop()) {
              nav.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),

      body: AppBackground.onboarding(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Beden: $size • Stil: $style',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              _GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _InfoRow(label: 'Boy', value: height, icon: Icons.straighten),
                      const SizedBox(height: 10),
                      _InfoRow(label: 'Kilo', value: weight, icon: Icons.monitor_weight_outlined),
                      const SizedBox(height: 10),
                      _InfoRow(label: 'Beden', value: size, icon: Icons.checkroom_outlined),
                      const SizedBox(height: 10),
                      _InfoRow(label: 'Stil', value: style, icon: Icons.style_outlined),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              _GlassCard(
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'KVKK & Gizlilik',
                      onTap: () {
                        // TODO: context.push('/privacy') veya bottom sheet
                      },
                    ),
                    const Divider(height: 1, color: Colors.white12),
                    _MenuTile(
                      icon: Icons.settings_outlined,
                      title: 'Ayarlar',
                      onTap: () {
                        // TODO: context.push('/settings')
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              _GlassCard(
                child: _MenuTile(
                  icon: Icons.restart_alt,
                  title: 'Onboarding’i yeniden başlat',
                  subtitle: 'Test için profil akışını tekrar açar.',
                  onTap: () async {
                    // DİKKAT: test amaçlı — istersen kaldırırız
                    await prefs.setOnboardingComplete(false);
                    // Router redirect otomatik onboarding’e atar
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white70)),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: child,
    );
  }
}
