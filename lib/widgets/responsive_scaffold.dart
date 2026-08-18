import 'package:flutter/material.dart';

import '../core/theme/app_semantic_colors.dart';
import '../core/theme/responsive.dart';
import 'app_sidebar.dart';
import 'floating_bottom_nav.dart';
import 'nav_item.dart';

/// Ana adaptive kabuk: ≥1024px'de sabit cam sidebar + geniş içerik alanı,
/// altında ise havada asılı frosted-glass bottom nav ile IndexedStack
/// sayfaları arasında geçiş sağlar. Hem tüketici uygulaması hem admin
/// dashboard'u bu tek bileşen üzerine kurulur.
class ResponsiveScaffold extends StatelessWidget {
  final String brandLabel;
  final String brandSubLabel;
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final List<Widget> pages;
  final Widget? sidebarFooter;
  final Widget? sidebarHeader;
  final Widget? topBanner;

  const ResponsiveScaffold({
    super.key,
    required this.brandLabel,
    required this.brandSubLabel,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.pages,
    this.sidebarFooter,
    this.sidebarHeader,
    this.topBanner,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final stack = IndexedStack(index: selectedIndex, children: pages);

    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        bottom: isDesktop,
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSidebar(
                    brandLabel: brandLabel,
                    brandSubLabel: brandSubLabel,
                    items: items,
                    selectedIndex: selectedIndex,
                    onSelect: onSelect,
                    footer: sidebarFooter,
                    trailingHeader: sidebarHeader,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        if (topBanner != null) topBanner!,
                        Expanded(child: stack),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  if (topBanner != null) topBanner!,
                  Expanded(child: stack),
                ],
              ),
      ),
      bottomNavigationBar: isDesktop
          ? null
          : SafeArea(
              top: false,
              child: FloatingBottomNav(items: items, selectedIndex: selectedIndex, onSelect: onSelect),
            ),
    );
  }
}
