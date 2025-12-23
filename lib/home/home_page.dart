import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../features/onboarding/onboarding_controller.dart';
import '../ui/responsive_scaffold_body.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(appPrefsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Merhaba, ${prefs.displayName.isEmpty ? '👋' : prefs.displayName}'),
        actions: [
          IconButton(
            tooltip: 'Onboarding’i sıfırla',
            onPressed: () async {
              await prefs.setOnboardingComplete(false);
            },
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
      body: ResponsiveBody(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchBar(),
            SizedBox(height: 2.h),

            Text('Hızlı Kategoriler', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 1.h),

            SizedBox(
              height: 120,
              child: LayoutBuilder(
                builder: (context, c) {
                  final crossAxisCount = c.maxWidth >= 520 ? 5 : 3;
                  return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.6,
                    children: const [
                      _Chip(icon: '👕', label: 'Üst'),
                      _Chip(icon: '👖', label: 'Alt'),
                      _Chip(icon: '👟', label: 'Ayakkabı'),
                      _Chip(icon: '🧥', label: 'Dış Giyim'),
                      _Chip(icon: '🧢', label: 'Aksesuar'),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 2.5.h),
            Text('Sana Önerilen Kombinler', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 1.h),

            Expanded(
              child: ListView(
                children: [
                  _OutfitCard(
                    title: 'Street • Rahat',
                    subtitle:
                    'Beden: ${prefs.size.isEmpty ? '—' : prefs.size} • Stil: ${prefs.style.isEmpty ? '—' : prefs.style}',
                    emojis: const ['🧢', '👕', '👖', '👟'],
                  ),
                  const _OutfitCard(
                    title: 'Classic • Şık',
                    subtitle: 'Ofis / günlük kullanım',
                    emojis: ['🧥', '👔', '👖', '👞'],
                  ),
                  const _OutfitCard(
                    title: 'Sport • Enerjik',
                    subtitle: 'Günlük yürüyüş',
                    emojis: ['🏃‍♂️', '👕', '🩳', '👟'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Kıyafet, kombin, renk ara...',
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String icon;
  final String label;

  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$icon  $label'),
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    );
  }
}

class _OutfitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> emojis;

  const _OutfitCard({
    required this.title,
    required this.subtitle,
    required this.emojis,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: emojis.map((e) => Text(' $e')).toList(),
        ),
      ),
    );
  }
}
