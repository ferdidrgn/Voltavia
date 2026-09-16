import 'package:flutter/material.dart';

import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminTableColumn {
  final String label;
  final int flex;

  const AdminTableColumn(this.label, {this.flex = 1});
}

/// Admin Dashboard'daki zengin veri tabloları için ortak, bento-uyumlu
/// tablo kabuğu. Yatay taşmalarda kaydırılabilir bir şerit içine alınır.
class AdminDataTable extends StatelessWidget {
  final List<AdminTableColumn> columns;
  final List<List<Widget>> rows;
  final double minWidth;

  const AdminDataTable({super.key, required this.columns, required this.rows, this.minWidth = 720});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colors.surfaceHighlight,
                  border: Border(bottom: BorderSide(color: colors.border)),
                ),
                child: Row(
                  children: columns
                      .map((c) => Expanded(
                            flex: c.flex,
                            child: Text(
                              c.label.toUpperCase(),
                              style: text.overline,
                            ),
                          ))
                      .toList(),
                ),
              ),
              for (var i = 0; i < rows.length; i++)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
                  decoration: BoxDecoration(
                    border: i == rows.length - 1 ? null : Border(bottom: BorderSide(color: colors.border)),
                  ),
                  child: Row(
                    children: [
                      for (var c = 0; c < rows[i].length; c++)
                        Expanded(
                          flex: c < columns.length ? columns[c].flex : 1,
                          child: rows[i][c],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
