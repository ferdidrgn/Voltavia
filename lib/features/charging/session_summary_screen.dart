import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/gradient_button.dart';
import '../home/home_shell.dart';

/// Şarj oturumu tamamlandığında gösterilen özet / makbuz ekranı.
class SessionSummaryScreen extends StatelessWidget {
  final String stationName;
  final String operatorName;
  final double energyKwh;
  final double costTry;
  final Duration duration;

  const SessionSummaryScreen({
    super.key,
    required this.stationName,
    required this.operatorName,
    required this.energyKwh,
    required this.costTry,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppPalette.emeraldGradient),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: colors.success.withValues(alpha: 0.45), blurRadius: 36, spreadRadius: 2)],
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 42),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Şarj Tamamlandı', style: text.display),
              const SizedBox(height: AppSpacing.xxs),
              Text('Ödeme $operatorName tarafından tahsil edildi.', style: text.bodyMuted, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xl),
              BentoCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                glowColor: colors.accentPrimary,
                child: Column(
                  children: [
                    _ReceiptRow(label: 'İstasyon', value: stationName),
                    _ReceiptRow(label: 'Operatör', value: operatorName),
                    _ReceiptRow(label: 'Süre', value: Formatters.duration(duration)),
                    _ReceiptRow(label: 'Enerji', value: Formatters.kwh(energyKwh)),
                    Divider(height: AppSpacing.lg, color: colors.border),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Toplam Tutar', style: text.title),
                        Text(Formatters.tryPrice(costTry), style: text.headline.copyWith(color: colors.accentPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GradientButton(
                label: 'Tamam',
                colors: AppPalette.emeraldGradient,
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeShell()),
                  (route) => false,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.ios_share_rounded, size: 17),
                label: const Text('Makbuzu Paylaş'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: text.bodyMuted),
          Text(value, style: text.bodyStrong),
        ],
      ),
    );
  }
}
