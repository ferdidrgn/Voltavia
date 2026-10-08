import '../../data/models/station.dart';

/// İstasyon kataloğunun uygulama katmanına bakan sözleşmesi.
/// Somut kaynaklar (EPDK, OpenStreetMap, disk önbelleği) data katmanındadır.
abstract interface class StationCatalog {
  Future<List<Station>> fetchTurkeySample();
  Future<List<Station>> cachedStations();
}
