import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/bento_card.dart';
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
    final colors = context.colors;
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);
    final operators =
        MockData.operators.where((o) => o.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: isDesktop ? null : AppBar(title: const Text('Firmalar')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: Column(
            children: [
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, 0),
                  child: Align(alignment: Alignment.centerLeft, child: Text('Firmalar', style: text.display)),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? AppSpacing.xxl : AppSpacing.md,
                  AppSpacing.md,
                  isDesktop ? AppSpacing.xxl : AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(hintText: 'Firma ara', prefixIcon: Icon(Icons.search_rounded, size: 18)),
                ),
              ),
              Expanded(
                child: operators.isEmpty
                    ? Center(
                        child: EmptyState(
                          icon: Icons.apartment_rounded,
                          title: 'Firma bulunamadı',
                          message: 'Farklı bir arama terimi dene.',
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.fromLTRB(
                          isDesktop ? AppSpacing.xxl : AppSpacing.md,
                          0,
                          isDesktop ? AppSpacing.xxl : AppSpacing.md,
                          AppSpacing.lg,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? Responsive.gridColumns(context) + 1 : 2,
                          mainAxisSpacing: AppSpacing.sm,
                          crossAxisSpacing: AppSpacing.sm,
                          childAspectRatio: 1.05,
                        ),
                        itemCount: operators.length,
                        itemBuilder: (context, i) {
                          final op = operators[i];
                          final stationCount = MockData.stationsFor(op.id).length;
                          return BentoCard(
                            onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => OperatorDetailScreen(chargeOperator: op))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: AppPalette.auroraGradient),
                                    borderRadius: BorderRadius.circular(AppRadius.sm),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    op.logoLetter,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                                  ),
                                ),
                                const Spacer(),
                                Text(op.name, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text('$stationCount istasyon', style: text.captionMuted),
                                if (op.hasAppIntegration) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.verified_rounded, size: 13, color: colors.success),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Uygulama içi şarj',
                                        style: text.captionMuted.copyWith(
                                          color: colors.success,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
