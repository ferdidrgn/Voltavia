import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius_extension.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/operator.dart';
import '../../operators/operator_detail_screen.dart';

/// Ana sayfada anlaşmalı firmaları (operatörleri) yatay kartlar halinde,
/// ilk 10 kayıtla gösteren bölüm.
class OperatorsSection extends StatelessWidget {
  const OperatorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final preview = MockData.operators.take(10).toList();
    final muted = context.voltaviaColors.textMuted;

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: preview.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final op = preview[i];
          final stationCount = MockData.stationsFor(op.id).length;
          return SizedBox(
            width: 84,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.md),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => OperatorDetailScreen(chargeOperator: op)),
              ),
              child: Column(
                children: [
                  _OperatorLogo(operatorEntry: op),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    op.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '$stationCount istasyon',
                    style: AppTextStyles.caption.copyWith(color: muted, fontSize: 10.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OperatorLogo extends StatelessWidget {
  final ChargeOperator operatorEntry;

  const _OperatorLogo({required this.operatorEntry});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.energyGradient),
            shape: BoxShape.circle,
            border: Border.all(color: context.voltaviaColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            operatorEntry.logoLetter,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
          ),
        ),
        if (operatorEntry.hasAppIntegration)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: context.voltaviaColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: context.voltaviaColors.surfaceElevated, width: 2),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 11),
            ),
          ),
      ],
    );
  }
}
