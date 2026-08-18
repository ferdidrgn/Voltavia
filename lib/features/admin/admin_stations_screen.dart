import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/status_badge.dart';
import 'widgets/admin_data_table.dart';

class AdminStationsScreen extends StatefulWidget {
  const AdminStationsScreen({super.key});

  @override
  State<AdminStationsScreen> createState() => _AdminStationsScreenState();
}

class _AdminStationsScreenState extends State<AdminStationsScreen> {
  bool _showForm = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);
    final stations = MockData.stations;

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
                  icon: Icon(_showForm ? LucideIcons.x : LucideIcons.plus, size: 16),
                  label: Text(_showForm ? 'Kapat' : 'Yeni İstasyon'),
                ),
              ],
            ),
            const Gap(AppSpacing.md),
            if (_showForm) ...[
              const _NewStationForm(),
              const Gap(AppSpacing.lg),
            ],
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
                for (final station in stations)
                  [
                    Text(station.name, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${station.district}, ${station.city}', style: text.bodyMuted),
                    Text(station.chargeOperator.name, style: text.bodyMuted),
                    Text('${station.maxPowerKw.toStringAsFixed(0)} kW', style: text.bodyMuted),
                    StatusBadge(status: station.status, compact: true),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(LucideIcons.pencil, size: 15, color: colors.textMuted),
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
              TextField(decoration: InputDecoration(labelText: 'Operatör', hintText: 'Örn. VoltCharge')),
              TextField(decoration: InputDecoration(labelText: 'Şehir', hintText: 'İstanbul')),
              TextField(decoration: InputDecoration(labelText: 'İlçe', hintText: 'Beşiktaş')),
              TextField(decoration: InputDecoration(labelText: 'Koordinat', hintText: '41.0766, 29.0180')),
              TextField(decoration: InputDecoration(labelText: 'Bağlantı Tipi / Güç', hintText: 'CCS2, 150 kW')),
            ],
          ),
          const Gap(AppSpacing.lg),
          ElevatedButton(onPressed: () {}, child: const Text('Kaydet ve Veri Sürümünü Artır')),
        ],
      ),
    );
  }
}
