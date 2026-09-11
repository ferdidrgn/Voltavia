import 'package:flutter/material.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/bento_card.dart';

class _Faq {
  final String question;
  final String answer;

  const _Faq({required this.question, required this.answer});
}

const _faqs = [
  _Faq(
    question: 'Şarj sırasında bağlantı koparsa ne olur?',
    answer: 'Şarj, istasyonun kendi donanımı üzerinden yürütülür; uygulama bağlantısı kopsa bile '
        'şarj devam eder. Uygulamayı yeniden açtığında oturumun otomatik senkronize olur.',
  ),
  _Faq(
    question: 'Hangi istasyonlarda uygulama içinden ödeme yapabilirim?',
    answer: 'Operatör listesindeki "Uygulama İçi Entegrasyon" rozetine sahip istasyonlarda şarjı '
        'doğrudan Voltavia üzerinden başlatıp ödeyebilirsin. Diğerlerinde operatörün kendi '
        'kartını/uygulamasını kullanman gerekir.',
  ),
  _Faq(
    question: 'Ücret nasıl hesaplanır?',
    answer: 'Ücret, tükettiğin kWh üzerinden, istasyonun listelenen birim fiyatıyla operatör '
        'tarafından hesaplanır. Bazı istasyonlarda ek olarak bağlantı/park ücreti uygulanabilir; bu '
        'istasyon detayında ayrıca belirtilir.',
  ),
  _Faq(
    question: 'Bir istasyon çalışmıyorsa ne yapmalıyım?',
    answer: 'İstasyon detayındaki "Sorun Bildir" seçeneğiyle durumu bize ve operatöre iletebilirsin. '
        'Bildirimler, istasyonun canlı durumunu diğer kullanıcılar için güncellememize yardımcı olur.',
  ),
  _Faq(
    question: 'Aracımı eklemek zorunlu mu?',
    answer: 'Hayır, ama aracını eklersen konnektör tipine uygun istasyonları önceliklendirir ve '
        'menzil tahminlerini gösterebiliriz.',
  ),
];

/// SSS + iletişim seçenekleri.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Scaffold(
      appBar: AppBar(title: const Text('Yardım ve Destek')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            children: [
              Expanded(
                child: _ContactTile(
                  icon: Icons.mail_outline_rounded,
                  label: 'E-posta',
                  value: 'destek@voltavia.app',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ContactTile(
                  icon: Icons.phone_outlined,
                  label: 'Telefon',
                  value: '0850 000 00 00',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Sıkça Sorulan Sorular', style: text.title),
          const SizedBox(height: AppSpacing.sm),
          for (final faq in _faqs) ...[
            BentoCard(
              padding: EdgeInsets.zero,
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(faq.question, style: text.bodyStrong),
                  iconColor: colors.accentPrimary,
                  collapsedIconColor: colors.textMuted,
                  childrenPadding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(faq.answer, style: text.bodyMuted),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.accentPrimary, size: 20),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: text.captionMuted),
          Text(value, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
