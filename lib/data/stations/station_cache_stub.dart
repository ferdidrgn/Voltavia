import '../models/station.dart';

/// Web derlemesi dosya sistemine yazmaz. Açık veri paketi zaten uygulamadadır.
class StationCache {
  Future<void> save(List<Station> stations) async {}

  Future<List<Station>> load() async => const [];
}
