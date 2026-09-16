import 'package:flutter/material.dart';

/// [AppSidebar] ve [FloatingBottomNav] arasında paylaşılan gezinme öğesi.
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItem({required this.icon, required this.activeIcon, required this.label});
}
