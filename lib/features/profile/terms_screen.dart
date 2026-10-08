import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/bento_card.dart';

/// Kullanım şartlarının taslağı. Yürürlük metni avukat onayından sonra gelir.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanım şartları')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          BentoCard(
            child: Text(
              'Bu metin taslaktır ve henüz bir sözleşme değildir. Voltavia şarj noktası bulmana ve yol tarifi almana yarar. Şarjı başlatmak ve ödemek, anlaşma yapılmış operatörün kendi sistemi üzerinden olur. Kart bilgisi Voltavia sunucularına yazılmaz.',
              style: text.body,
            ),
          ),
        ],
      ),
    );
  }
}
