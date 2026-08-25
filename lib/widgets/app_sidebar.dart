import 'package:flutter/material.dart';

import '../core/theme/app_palette.dart';
import '../core/theme/app_semantic_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'nav_item.dart';

/// Masaüstü/Web (≥1024px) için sabit, cam yüzeyli sol navigasyon çubuğu.
/// Hem tüketici uygulamasında hem admin dashboard'unda kullanılır.
class AppSidebar extends StatelessWidget {
  final String brandLabel;
  final String brandSubLabel;
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Widget? footer;
  final Widget? trailingHeader;

  const AppSidebar({
    super.key,
    required this.brandLabel,
    required this.brandSubLabel,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    this.footer,
    this.trailingHeader,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    return Container(
      width: 264,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: colors.isDark ? 0.5 : 0.85),
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: AppPalette.indigoGradient),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(brandLabel, style: text.title),
                      Text(brandSubLabel, style: text.captionMuted),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (trailingHeader != null) ...[
            const SizedBox(height: AppSpacing.md),
            trailingHeader!,
          ],
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 2),
              itemBuilder: (context, i) {
                final item = items[i];
                final selected = i == selectedIndex;
                return _SidebarTile(
                  item: item,
                  selected: selected,
                  onTap: () => onSelect(i),
                );
              },
            ),
          ),
          ?footer,
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarTile({required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected ? colors.accentPrimary.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 18,
                  margin: const EdgeInsets.only(right: AppSpacing.xs),
                  decoration: BoxDecoration(
                    gradient: selected ? const LinearGradient(colors: AppPalette.indigoGradient) : null,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: selected ? const LinearGradient(colors: AppPalette.indigoGradient) : null,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    boxShadow: selected
                        ? [BoxShadow(color: AppPalette.violet.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))]
                        : null,
                  ),
                  child: Icon(
                    selected ? item.activeIcon : item.icon,
                    size: 18,
                    color: selected ? Colors.white : colors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.label,
                    style: text.body.copyWith(
                      color: selected ? colors.textPrimary : colors.textSecondary,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
