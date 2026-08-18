import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/responsive.dart';
import '../../data/models/station.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/station_card.dart';
import '../stations/station_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDesktop = Responsive.isDesktop(context);
    final columns = Responsive.gridColumns(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isDesktop ? null : AppBar(title: const Text('Favoriler')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: AnimatedBuilder(
            animation: appState,
            builder: (context, _) {
              final favorites = appState.favoriteStations;
              if (favorites.isEmpty) {
                return Center(
                  child: EmptyState(
                    icon: Icons.favorite_border_rounded,
                    title: 'Henüz favorin yok',
                    message: 'İstasyon detayındaki kalp ikonuna dokunarak favorilerine ekleyebilirsin.',
                  ),
                );
              }
              final padding = EdgeInsets.fromLTRB(
                isDesktop ? AppSpacing.xxl : AppSpacing.md,
                isDesktop ? AppSpacing.lg : AppSpacing.md,
                isDesktop ? AppSpacing.xxl : AppSpacing.md,
                AppSpacing.lg,
              );

              if (isDesktop) {
                return GridView.builder(
                  padding: padding,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 1.7,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, i) => _card(context, favorites[i], appState, i),
                );
              }

              return ListView.separated(
                padding: padding,
                itemCount: favorites.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) => _card(context, favorites[i], appState, i),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, Station station, AppState appState, int index) {
    return StationCard(
      station: station,
      index: index,
      isFavorite: true,
      onFavoriteToggle: () => appState.toggleFavorite(station.id),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => StationDetailScreen(station: station)),
      ),
    );
  }
}
