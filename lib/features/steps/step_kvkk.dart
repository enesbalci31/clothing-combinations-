import 'package:clothess/features/steps/step_shell.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StepLegal extends StatelessWidget {
  final bool acceptedTerms;
  final bool acceptedPrivacy;
  final bool acceptedKvkk;

  final ValueChanged<bool> onTermsChanged;
  final ValueChanged<bool> onPrivacyChanged;
  final ValueChanged<bool> onKvkkChanged;

  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepLegal({
    super.key,
    required this.acceptedTerms,
    required this.acceptedPrivacy,
    required this.acceptedKvkk,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
    required this.onKvkkChanged,
    required this.onNext,
    required this.onBack,
  });

  bool get canContinue => acceptedTerms && acceptedPrivacy && acceptedKvkk;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return StepShell(
      gradient: const [
        Color(0xFF111827),
        Color(0xFF8B5CF6),
        Color(0xFF22C55E),
      ],
      emojis: const ['🧾', '🔒', '✅', '🛡️', '📜', '✨'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepProgress(current: 3, total: 4),
          SizedBox(height: 2.0.h),

          // ✅ Üst başlık + açıklama da scroll içinde olursa küçük ekranda taşma riski sıfırlanır
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Güvenli Başlangıç 🔒',
                    style: t.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Uygulamayı güvenle kullanabilmen için kısa birkaç onay gerekiyor.\nMetinleri aşağıdan açıp okuyabilirsin.',
                    style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.92)),
                  ),
                  SizedBox(height: 2.0.h),

                  _LegalCard(
                    title: 'Kullanıcı Sözleşmesi',
                    subtitle: 'Uygulama kullanım koşulları, sorumluluklar',
                    emoji: '📜',
                    checked: acceptedTerms,
                    onChanged: onTermsChanged,
                    onOpen: () => _openLegalSheet(context, 'Kullanıcı Sözleşmesi', _termsText),
                  ),
                  SizedBox(height: 1.2.h),

                  _LegalCard(
                    title: 'Gizlilik Politikası',
                    subtitle: 'Veri işleme, saklama, üçüncü taraflar',
                    emoji: '🔐',
                    checked: acceptedPrivacy,
                    onChanged: onPrivacyChanged,
                    onOpen: () => _openLegalSheet(context, 'Gizlilik Politikası', _privacyText),
                  ),
                  SizedBox(height: 1.2.h),

                  _LegalCard(
                    title: 'KVKK Aydınlatma & Açık Rıza',
                    subtitle: 'KVKK bilgilendirme ve açık rıza metni',
                    emoji: '🛡️',
                    checked: acceptedKvkk,
                    onChanged: onKvkkChanged,
                    onOpen: () => _openLegalSheet(context, 'KVKK / Açık Rıza', _kvkkText),
                  ),

                  SizedBox(height: 2.0.h),
                ],
              ),
            ),
          ),

          // ✅ Alt butonlar sabit (overflow yok)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Geri'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: FilledButton.icon(
                  onPressed: canContinue ? onNext : null,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: Text(canContinue ? 'Devam' : 'Onay gerekli'),
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

  void _openLegalSheet(BuildContext context, String title, String body) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('Son güncelleme: [Tarih]', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Text(body, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Özet: Bu metinler; hizmet şartlarını, gizlilik ilkelerini ve KVKK kapsamındaki bilgilendirmeyi içerir.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Okudum, kapat'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _LegalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final VoidCallback onOpen;

  const _LegalCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.checked,
    required this.onChanged,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: onOpen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.88))),
                  const SizedBox(height: 8),
                  Text('Metni görüntüle', style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Checkbox(
            value: checked,
            onChanged: (v) => onChanged(v ?? false),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
            activeColor: Colors.white,
            checkColor: Colors.black,
          ),
        ],
      ),
    );
  }
}

// Uzun, “gerçek uygulama gibi” metinler:
const _termsText = '''
1) Hizmet Tanımı
Kombin Dünyası; kullanıcıların stil tercihleri ve beden bilgilerine göre kombin önerileri almasına, dolap öğelerini kaydetmesine ve içerik yönetmesine yardımcı olan bir uygulamadır.

2) Kullanım Koşulları
- Uygulamayı yürürlükteki mevzuata uygun biçimde kullanmayı kabul edersiniz.
- Uygulama içeriğinin izinsiz kopyalanması, tersine mühendislik vb. yasaktır.
- Kullanıcı, yüklediği içeriklerin (fotoğraf, metin) hukuka uygunluğundan sorumludur.

3) Sorumluluk Sınırları
Uygulama; öneri ve yardımcı içerikler sunar. Nihai karar kullanıcıya aittir. Teknik kesintiler veya üçüncü taraf servis kaynaklı sorunlarda doğrudan/ dolaylı zararlardan sorumluluk sınırlıdır.

4) Değişiklikler
Bu sözleşme gerektiğinde güncellenebilir. Güncel metin uygulama içinde yayınlanır.
''';

const _privacyText = '''
1) Toplanan Veriler
- Profil: ad, boy, kilo, beden, stil tercihleri
- İçerik: dolap fotoğrafları, kombin notları
- Teknik: cihaz bilgisi, hata logları (kişisel veri içermeyecek şekilde)

2) İşleme Amaçları
- Uygulama işlevlerini sağlamak (profil oluşturma, öneriler)
- Hizmet kalitesini iyileştirmek (analiz/hata düzeltme)
- Güvenlik ve dolandırıcılık önleme

3) Saklama
Veriler yalnızca gerekli süre boyunca saklanır ve güvenlik önlemleri uygulanır.

4) Paylaşım
Veriler; yalnızca hizmet sunumu için gerekli olan altyapı sağlayıcılarıyla paylaşılabilir. Reklam amacıyla satılmaz.

5) Haklarınız
KVKK kapsamında; erişim, düzeltme, silme, itiraz haklarınız vardır.
''';

const _kvkkText = '''
Aydınlatma
Kombin Dünyası; profil bilgilerinizi (ad, boy, kilo, beden, stil) hizmetin sunulması, kişiselleştirme ve kullanıcı deneyiminin iyileştirilmesi amacıyla işler.

Açık Rıza
Uygulamanın kişiselleştirilmiş öneriler sunabilmesi için profil verilerimin işlenmesine açık rıza veriyorum.

Güvenlik
Uygun teknik ve idari tedbirler uygulanır. Dilediğiniz an ayarlardan rızanızı gözden geçirebilirsiniz.
''';
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