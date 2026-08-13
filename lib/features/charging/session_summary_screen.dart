import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
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
    final muted = context.voltaviaColors.textMuted;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: context.voltaviaColors.success.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_rounded, color: context.voltaviaColors.success, size: 44),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Şarj Tamamlandı', style: AppTextStyles.displayMd),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Ödeme $operatorName tarafından tahsil edildi.',
                style: AppTextStyles.body.copyWith(color: muted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: context.voltaviaColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: context.voltaviaColors.border),
                ),
                child: Column(
                  children: [
                    _ReceiptRow(label: 'İstasyon', value: stationName),
                    _ReceiptRow(label: 'Operatör', value: operatorName),
                    _ReceiptRow(label: 'Süre', value: Formatters.duration(duration)),
                    _ReceiptRow(label: 'Enerji', value: Formatters.kwh(energyKwh)),
                    const Divider(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Toplam Tutar', style: AppTextStyles.title),
                        Text(
                          Formatters.tryPrice(costTry),
                          style: AppTextStyles.headline.copyWith(color: AppColors.brandPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeShell()),
                    (route) => false,
                  ),
                  child: const Text('Tamam'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
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
    final muted = context.voltaviaColors.textMuted;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(color: muted)),
          Text(value, style: AppTextStyles.bodyStrong),
        ],
      ),
    );
  }
}
