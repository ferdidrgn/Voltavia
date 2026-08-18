import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
                  child: const Icon(LucideIcons.zap, color: Colors.white, size: 18),
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
              separatorBuilder: (_, __) => const SizedBox(height: 2),
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
          if (footer != null) footer!,
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
      color: selected ? colors.accentPrimary.withValues(alpha: 0.12) : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 11),
          child: Row(
            children: [
              Icon(
                selected ? item.activeIcon : item.icon,
                size: 19,
                color: selected ? colors.accentPrimary : colors.textSecondary,
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
              if (selected)
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(color: colors.accentPrimary, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
