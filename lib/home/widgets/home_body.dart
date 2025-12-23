import 'package:flutter/material.dart';
import 'home_widgets.dart';

class HomeBody extends StatelessWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onNewRecord;
  final VoidCallback onGoRecords;

  const HomeBody({
    super.key,
    required this.onTakePhoto,
    required this.onNewRecord,
    required this.onGoRecords,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        Text(
          'Bugün ne yapmak istersin?',
          style: t.bodyLarge?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 16),

        QuickActionsCard(
          title: 'Hızlı Başla',
          subtitle: 'Ürün ve müşteri fotoğrafı ile kayıt oluştur.',
          actions: [
            ActionButton(
              icon: Icons.photo_camera_outlined,
              label: 'Foto Çek',
              onTap: onTakePhoto,
            ),
            ActionButton(
              icon: Icons.add_box_outlined,
              label: 'Yeni Kayıt',
              onTap: onNewRecord,
            ),
            ActionButton(
              icon: Icons.list_alt_outlined,
              label: 'Kayıtlar',
              onTap: onGoRecords,
            ),
          ],
        ),

        const SizedBox(height: 16),

        const SectionTitle(title: 'Özet'),
        const SizedBox(height: 10),

        const Row(
          children: [
            Expanded(
              child: StatTile(
                title: 'Bugün',
                value: '0',
                subtitle: 'Yeni kayıt',
                icon: Icons.today_outlined,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatTile(
                title: 'Toplam',
                value: '0',
                subtitle: 'Kayıt',
                icon: Icons.inventory_2_outlined,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        const SectionTitle(title: 'Son İşlemler'),
        const SizedBox(height: 10),

        const EmptyState(
          title: 'Henüz kayıt yok',
          subtitle: 'İlk kaydı oluşturmak için “Foto Çek” ile başlayabilirsin.',
        ),
      ],
    );
  }
}
