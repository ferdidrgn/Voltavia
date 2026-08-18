import 'package:flutter/material.dart';

import '../core/theme/app_palette.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Şarj başlatma gibi birincil çağrı-eylem (CTA) butonları için Indigo→Violet
/// gradyanı ve yumuşak glow gölgesiyle vurgulanan buton.
class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final List<Color> colors;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.colors = AppPalette.indigoGradient,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final text = context.text;
    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: disabled
              ? null
              : [
                  BoxShadow(
                    color: colors.first.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 19),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(label, style: text.bodyStrong.copyWith(color: Colors.white, fontSize: 15.5)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
