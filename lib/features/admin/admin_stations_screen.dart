import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../data/models/station.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/status_badge.dart';
import 'widgets/admin_data_table.dart';

class AdminStationsScreen extends StatefulWidget {
  const AdminStationsScreen({super.key});

  @override
  State<AdminStationsScreen> createState() => _AdminStationsScreenState();
}

class _AdminStationsScreenState extends State<AdminStationsScreen> {
  static const _rowLimit = 80;

  bool _showForm = false;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);
    final appState = AppStateScope.of(context);
    final query = _query.trim().toLowerCase();
    final matches = <Station>[];
    var matchCount = 0;
    for (final station in appState.stations) {
      if (query.isNotEmpty && !_matches(station, query)) continue;
      matchCount++;
      if (matches.length < _rowLimit) matches.add(station);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isDesktop ? null : AppBar(title: const Text('İstasyonlar')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isDesktop ? AppSpacing.xxl : AppSpacing.md,
          isDesktop ? AppSpacing.lg : AppSpacing.md,
          isDesktop ? AppSpacing.xxl : AppSpacing.md,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isDesktop)
                  Text('İstasyonlar', style: text.display)
                else
                  Text('Ekle, düzenle, pasife al', style: text.bodyMuted),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _showForm = !_showForm),
                  icon: Icon(_showForm ? Icons.close_rounded : Icons.add_rounded, size: 16),
                  label: Text(_showForm ? 'Kapat' : 'Yeni İstasyon'),
                ),
              ],
            ),
            const Gap(AppSpacing.md),
            if (appState.stationsLoading) ...[
              Text('Katalog yükleniyor', style: text.captionMuted),
              const Gap(AppSpacing.sm),
            ],
            if (_showForm) ...[
              const _NewStationForm(),
              const Gap(AppSpacing.lg),
            ],
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'İstasyon, şehir veya operatör ara',
                prefixIcon: Icon(Icons.search_rounded, size: 18),
              ),
            ),
            const Gap(AppSpacing.sm),
            Text('$matchCount kayıttan ${matches.length} gösteriliyor', style: text.captionMuted),
            const Gap(AppSpacing.sm),
            if (matches.isEmpty)
              Text('Eşleşen istasyon yok.', style: text.bodyMuted)
            else
              AdminDataTable(
                minWidth: isDesktop ? 0 : 760,
                columns: const [
                  AdminTableColumn('İstasyon', flex: 3),
                  AdminTableColumn('Şehir/İlçe', flex: 2),
                  AdminTableColumn('Operatör', flex: 2),
                  AdminTableColumn('Güç', flex: 1),
                  AdminTableColumn('Durum', flex: 2),
                  AdminTableColumn('', flex: 1),
                ],
                rows: [
                  for (final station in matches)
                    [
                      Text(station.name, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(_place(station), style: text.bodyMuted, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(station.chargeOperator.name, style: text.bodyMuted, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('${station.maxPowerKw.toStringAsFixed(0)} kW', style: text.bodyMuted),
                      StatusBadge(status: station.status, compact: true),
                      IconButton(
                        onPressed: () => _showCatalogPending(context),
                        icon: Icon(Icons.edit_rounded, size: 15, color: colors.textMuted),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  bool _matches(Station station, String query) {
    return station.name.toLowerCase().contains(query) ||
        station.city.toLowerCase().contains(query) ||
        station.chargeOperator.name.toLowerCase().contains(query);
  }

  String _place(Station station) {
    if (station.district.isEmpty) return station.city;
    return '${station.district}, ${station.city}';
  }
}

void _showCatalogPending(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Katalog düzenlemeleri yönetici arka ucunu bekliyor.')),
  );
}

class _NewStationForm extends StatelessWidget {
  const _NewStationForm();

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);

    return BentoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Yeni İstasyon Ekle', style: text.title),
          const Gap(AppSpacing.xs),
          Text(
            'Bu form EPDK kataloğuna yazmaz. Gönderim yalnızca yerel bir taslaktır.',
            style: text.bodyMuted,
          ),
          const Gap(AppSpacing.md),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 2 : 1,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: isDesktop ? 5.4 : 5.0,
            children: const [
              TextField(decoration: InputDecoration(labelText: 'İstasyon Adı', hintText: 'Örn. Zorlu Center Şarj Noktası')),
              TextField(decoration: InputDecoration(labelText: 'Operatör', hintText: 'Operatör adı')),
              TextField(decoration: InputDecoration(labelText: 'Şehir', hintText: 'İstanbul')),
              TextField(decoration: InputDecoration(labelText: 'İlçe', hintText: 'Beşiktaş')),
              TextField(decoration: InputDecoration(labelText: 'Koordinat', hintText: '41.0766, 29.0180')),
              TextField(decoration: InputDecoration(labelText: 'Bağlantı Tipi / Güç', hintText: 'CCS2, 150 kW')),
            ],
          ),
          const Gap(AppSpacing.lg),
          ElevatedButton(
            onPressed: () => _showCatalogPending(context),
            child: const Text('Yerel taslak kaydet'),
          ),
        ],
      ),
    );
  }
}
