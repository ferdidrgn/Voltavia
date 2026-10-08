import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/operator.dart';
import '../../domain/operators/partnership_steps.dart';
import '../../widgets/bento_card.dart';

/// Operatörle anlaşma dosyası. Tamamlanan adımlar bu cihazda durur.
class OperatorPartnershipScreen extends StatelessWidget {
  final ChargeOperator chargeOperator;

  const OperatorPartnershipScreen({super.key, required this.chargeOperator});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final text = context.text;
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text('${chargeOperator.name} dosyası')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final done = appState.partnershipStepsFor(chargeOperator.id);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(
                'Bu liste sözleşme takibidir. İşaretlemek şarj başlatmaz ve operatörü bağlı saymaz.',
                style: text.bodyMuted,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${done.length} / ${partnershipSteps.length} adım bu cihazda işaretli',
                style: text.captionMuted.copyWith(color: colors.accentPrimary, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.md),
              for (final step in partnershipSteps) ...[
                BentoCard(
                  onTap: () => appState.togglePartnershipStep(chargeOperator.id, step.id),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        done.contains(step.id) ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        color: done.contains(step.id) ? colors.accentPrimary : colors.textMuted,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(step.title, style: text.bodyStrong),
                            const SizedBox(height: 2),
                            Text(step.body, style: text.captionMuted),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          );
        },
      ),
    );
  }
}
