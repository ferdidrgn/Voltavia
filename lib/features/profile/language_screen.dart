import 'package:flutter/material.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/bento_card.dart';

class _AppLanguage {
  final String code;
  final String name;
  final String nativeName;

  const _AppLanguage({required this.code, required this.name, required this.nativeName});
}

const _languages = [
  _AppLanguage(code: 'tr', name: 'Türkçe', nativeName: 'Türkçe'),
  _AppLanguage(code: 'en', name: 'İngilizce', nativeName: 'English'),
  _AppLanguage(code: 'de', name: 'Almanca', nativeName: 'Deutsch'),
  _AppLanguage(code: 'ar', name: 'Arapça', nativeName: 'العربية'),
];

/// Dil seçim ekranı — şu an yalnızca Türkçe aktif, diğerleri yol haritasında.
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = 'tr';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Scaffold(
      appBar: AppBar(title: const Text('Dil')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          for (final lang in _languages) ...[
            BentoCard(
              onTap: lang.code == 'tr' ? () => setState(() => _selected = lang.code) : null,
              child: Opacity(
                opacity: lang.code == 'tr' ? 1 : 0.5,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lang.nativeName, style: text.bodyStrong),
                          Text(lang.name, style: text.captionMuted),
                        ],
                      ),
                    ),
                    if (lang.code != 'tr')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.surfaceHighlight,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text('Yakında', style: text.captionMuted.copyWith(fontSize: 10.5)),
                      )
                    else
                      Icon(
                        _selected == lang.code ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: _selected == lang.code ? colors.accentPrimary : colors.textMuted,
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
