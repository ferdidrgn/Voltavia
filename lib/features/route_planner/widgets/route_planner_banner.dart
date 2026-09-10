import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../route_planner_screen.dart';

/// Ana sayfada rota planlayıcıya götüren vurgulu, gradyanlı CTA kartı —
/// şehirler arası yolculuk öncesi şarj molası planlamayı öne çıkarır.
class RoutePlannerBanner extends StatelessWidget {
  const RoutePlannerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoutePlannerScreen())),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppPalette.voltGradient),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.route_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uzun yolculuk mu planlıyorsun?',
                      style: text.bodyStrong.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Şehirler arası şarj molalarını senin için hesaplayalım',
                      style: text.captionMuted.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
