import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/station_card.dart';
import '../stations/station_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoriler')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          final favorites = appState.favoriteStations;
          if (favorites.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.favorite_border,
                title: 'Henüz favorin yok',
                message: 'İstasyon detayındaki kalp ikonuna dokunarak favorilerine ekleyebilirsin.',
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              final station = favorites[i];
              return StationCard(
                station: station,
                isFavorite: true,
                onFavoriteToggle: () => appState.toggleFavorite(station.id),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => StationDetailScreen(station: station)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
