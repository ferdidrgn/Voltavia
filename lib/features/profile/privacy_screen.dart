import 'package:flutter/material.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/bento_card.dart';

class _PolicySection {
  final IconData icon;
  final String title;
  final String body;

  const _PolicySection({required this.icon, required this.title, required this.body});
}

const _sections = [
  _PolicySection(
    icon: Icons.storage_rounded,
    title: 'Hangi verilerini topluyoruz?',
    body: 'Hesap bilgilerin (ad, e-posta, telefon), araç bilgilerin, şarj geçmişin ve konumun '
        '(yalnızca sana en yakın istasyonları göstermek için, arka planda değil). Kart numaranı ve '
        'CVV\'ni hiçbir zaman sunucularımızda tutmayız — ödeme, operatörün lisanslı altyapısı '
        'üzerinden geçer.',
  ),
  _PolicySection(
    icon: Icons.share_rounded,
    title: 'Verilerini kimlerle paylaşıyoruz?',
    body: 'Şarjı başlattığın operatörle yalnızca oturumu tamamlamak için gerekli bilgiler (araç '
        'konnektör tipi, ödeme onayı) paylaşılır. Verilerin reklam amacıyla üçüncü taraflara '
        'satılmaz.',
  ),
  _PolicySection(
    icon: Icons.lock_rounded,
    title: 'Verilerin nasıl korunuyor?',
    body: 'Tüm veri trafiği uçtan uca şifrelenir (TLS 1.3). Kart verileri PCI-DSS uyumlu operatör '
        'altyapılarında işlenir; Voltavia sunucularına hiç ulaşmaz.',
  ),
  _PolicySection(
    icon: Icons.fact_check_rounded,
    title: 'KVKK kapsamındaki hakların',
    body: '6698 sayılı Kişisel Verilerin Korunması Kanunu uyarınca verilerinin işlenip işlenmediğini '
        'öğrenme, düzeltilmesini/silinmesini talep etme ve işlemeye itiraz etme hakkına sahipsin. '
        'Talepler için Yardım ve Destek üzerinden bize ulaşabilirsin.',
  ),
  _PolicySection(
    icon: Icons.delete_outline_rounded,
    title: 'Hesabını silme',
    body: 'Hesabını ve ilişkili tüm kişisel verilerini istediğin zaman kalıcı olarak silebilirsin. '
        'Şarj geçmişin, yasal saklama yükümlülükleri dışında, silme talebinden sonra 30 gün içinde '
        'sistemlerimizden kaldırılır.',
  ),
];

/// Gizlilik ve KVKK politikası — gerçek, okunabilir bölümler halinde.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Scaffold(
      appBar: AppBar(title: const Text('Gizlilik ve KVKK')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Voltavia olarak verilerini nasıl topladığımızı, kullandığımızı ve koruduğumuzu '
            'burada açık şekilde anlatıyoruz.',
            style: text.bodyMuted,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final section in _sections) ...[
            BentoCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.accentPrimary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(section.icon, color: colors.accentPrimary, size: 18),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(section.title, style: text.bodyStrong),
                        const SizedBox(height: 4),
                        Text(section.body, style: text.bodyMuted),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
