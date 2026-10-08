import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/station.dart';

/// Son başarılı istasyon listesini diskte tutar. Ağ kopunca katalog boş kalmaz.
class StationCache {
  Future<void> save(List<Station> stations) async {
    try {
      final file = await _file();
      final payload = jsonEncode([for (final station in stations) station.toJson()]);
      await file.writeAsString(payload);
    } catch (_) {}
  }

  Future<List<Station>> load() async {
    try {
      final file = await _file();
      if (!await file.exists()) return const [];
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! List) return const [];
      final stations = <Station>[];
      for (final item in decoded) {
        if (item is! Map) continue;
        final station = Station.tryParse(Map<String, dynamic>.from(item));
        if (station != null) stations.add(station);
      }
      return stations;
    } catch (_) {
      return const [];
    }
  }

  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/voltavia-stations.json');
  }
}
