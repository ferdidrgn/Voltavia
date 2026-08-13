import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/empty_state.dart';
import 'operator_detail_screen.dart';

/// Platformla anlaşmalı tüm operatörlerin/firmaların listelendiği ekran.
/// Ana sayfadaki "Firmalar" bölümünün "Tümünü Gör" hedefidir.
class OperatorsScreen extends StatefulWidget {
  const OperatorsScreen({super.key});

  @override
  State<OperatorsScreen> createState() => _OperatorsScreenState();
}

class _OperatorsScreenState extends State<OperatorsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    final operators = MockData.operators
        .where((o) => o.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Firmalar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.sm),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Firma ara',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: operators.isEmpty
                ? Center(
                    child: EmptyState(
                      icon: Icons.storefront_outlined,
                      title: 'Firma bulunamadı',
                      message: 'Farklı bir arama terimi dene.',
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.sm,
                      crossAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 1.05,
                    ),
                    itemCount: operators.length,
                    itemBuilder: (context, i) {
                      final op = operators[i];
                      final stationCount = MockData.stationsFor(op.id).length;
                      return InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => OperatorDetailScreen(chargeOperator: op)),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: context.voltaviaColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: context.voltaviaColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: AppColors.energyGradient),
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  op.logoLetter,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                op.name,
                                style: AppTextStyles.bodyStrong,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$stationCount istasyon',
                                style: AppTextStyles.caption.copyWith(color: muted),
                              ),
                              if (op.hasAppIntegration) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.verified_rounded,
                                        size: 13, color: context.voltaviaColors.success),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Uygulama içi şarj',
                                      style: AppTextStyles.caption.copyWith(
                                        color: context.voltaviaColors.success,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
