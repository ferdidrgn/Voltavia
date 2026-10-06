import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/connector_type.dart';
import '../models/operator.dart';
import '../models/station.dart';

class _SocketSummary {
  double maxKw = 0;
  int count = 0;
  final List<ConnectorType> connectors = [];
}

/// OpenStreetMap karoları ve iki istasyon listesi: Overpass kayıtları ile
/// EPDK konumlarının İBB açık veri kopyası. Yakın noktalar tek pine indirilir.
class StationRepository {
  static const _istanbul = (lat: 41.015137, lon: 28.979530);

  static const _query = '''
[out:json][timeout:40];
(
  node["amenity"="charging_station"](40.90,28.55,41.25,29.30);
  node["amenity"="charging_station"](39.80,32.55,40.05,33.05);
  node["amenity"="charging_station"](38.30,26.90,38.55,27.25);
  node["amenity"="charging_station"](36.80,30.55,37.05,30.90);
  node["amenity"="charging_station"](40.10,28.90,40.30,29.20);
);
out body 180;
''';

  Future<List<Station>> fetchTurkeySample() async {
    final loaded = await Future.wait([
      _orEmpty(_fetchOsm()),
      _orEmpty(_fetchEpdk()),
    ]);
    final osm = loaded[0];
    final epdk = loaded[1];
    final merged = _merge(osm, epdk);
    if (merged.isEmpty) throw StateError('İstasyon bulunamadı');
    merged.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return merged;
  }

  Future<List<Station>> _orEmpty(Future<List<Station>> future) async {
    try {
      return await future;
    } catch (_) {
      return const [];
    }
  }

  Future<List<Station>> _fetchOsm() async {
    final response = await http
        .post(
          Uri.parse('https://overpass-api.de/api/interpreter'),
          headers: const {
            'User-Agent': 'Voltavia/1.0 (ev charging map)',
            'Content-Type': 'text/plain; charset=utf-8',
          },
          body: _query,
        )
        .timeout(const Duration(seconds: 35));

    if (response.statusCode != 200) {
      throw StateError('Overpass ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return const [];
    final elements = decoded['elements'];
    if (elements is! List) return const [];

    final stations = <Station>[];
    for (final raw in elements) {
      if (raw is! Map<String, dynamic>) continue;
      final station = _parse(raw);
      if (station != null) stations.add(station);
    }
    stations.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return stations;
  }

  Station? _parse(Map<String, dynamic> node) {
    final lat = (node['lat'] as num?)?.toDouble();
    final lon = (node['lon'] as num?)?.toDouble();
    if (lat == null || lon == null) return null;

    final tags = node['tags'];
    final map = tags is Map<String, dynamic> ? tags : const <String, dynamic>{};
    final operatorName = _text(map['operator']) ?? _text(map['brand']) ?? _text(map['network']) ?? 'Bağımsız';
    final name = _text(map['name']) ?? '$operatorName şarj noktası';
    final city = _text(map['addr:city']) ?? _text(map['addr:province']) ?? _guessCity(lat, lon);
    final district = _text(map['addr:suburb']) ?? _text(map['addr:district']) ?? '';
    final street = _text(map['addr:street']);
    final connectors = _connectors(map);
    final power = _powerKw(map, connectors);
    final sockets = _socketCount(map);

    return Station(
      id: 'osm-${node['id']}',
      name: name,
      city: city,
      district: district,
      address: street ?? 'OpenStreetMap kaydı',
      chargeOperator: ChargeOperator(
        id: 'osm-${_slug(operatorName)}',
        name: operatorName,
        logoLetter: operatorName.isEmpty ? '?' : operatorName[0].toUpperCase(),
        description: 'OpenStreetMap üzerinde kayıtlı işletmeci.',
      ),
      connectors: connectors,
      maxPowerKw: power,
      pricePerKwh: 0,
      status: StationStatus.available,
      distanceKm: _km(_istanbul.lat, _istanbul.lon, lat, lon),
      rating: 0,
      socketCount: sockets,
      latitude: lat,
      longitude: lon,
      origin: 'OpenStreetMap',
    );
  }

  static const _geoJsonUrl =
      'https://data.ibb.gov.tr/dataset/79b0e26e-e923-498b-a675-453382274178/resource/726e9d82-37f7-4142-8fa0-4f70a5530188/download/sarj_istasyonlari.geojson';
  static const _socketCsvUrl =
      'https://data.ibb.gov.tr/dataset/17f75354-1553-4a74-a90f-3a79680343c9/resource/ff424a4c-6478-455c-9bd5-b597a7df7df1/download/sarj_istasyon_soket.csv';

  Future<List<Station>> _fetchEpdk() async {
    try {
      final live = await _fetchEpdkLive();
      if (live.isNotEmpty) return live;
    } catch (_) {}
    final geo = await rootBundle.loadString('assets/stations/sarj_istasyonlari.geojson');
    final csv = await rootBundle.loadString('assets/stations/sarj_istasyon_soket.csv');
    return _decodeEpdk(geo, csv);
  }

  Future<List<Station>> _fetchEpdkLive() async {
    final responses = await Future.wait([
      http.get(Uri.parse(_geoJsonUrl), headers: const {'User-Agent': 'Voltavia/1.0'}).timeout(const Duration(seconds: 40)),
      http.get(Uri.parse(_socketCsvUrl), headers: const {'User-Agent': 'Voltavia/1.0'}).timeout(const Duration(seconds: 40)),
    ]);
    if (responses[0].statusCode != 200) throw StateError('EPDK geojson ${responses[0].statusCode}');
    final csv = responses[1].statusCode == 200 ? utf8.decode(responses[1].bodyBytes) : '';
    return _decodeEpdk(utf8.decode(responses[0].bodyBytes), csv);
  }

  List<Station> _decodeEpdk(String geoJson, String csv) {
    final sockets = csv.isEmpty ? const <String, _SocketSummary>{} : _parseSockets(csv);
    final decoded = jsonDecode(geoJson);
    if (decoded is! Map<String, dynamic>) return const [];
    final features = decoded['features'];
    if (features is! List) return const [];

    final stations = <Station>[];
    for (final raw in features) {
      if (raw is! Map<String, dynamic>) continue;
      final station = _parseEpdk(raw, sockets);
      if (station != null) stations.add(station);
    }
    return stations;
  }

  Map<String, _SocketSummary> _parseSockets(String csv) {
    final lines = const LineSplitter().convert(csv);
    final map = <String, _SocketSummary>{};
    for (var i = 1; i < lines.length; i++) {
      final parts = lines[i].split(',');
      if (parts.length < 5) continue;
      final id = parts[0].trim();
      if (id.isEmpty) continue;
      final summary = map.putIfAbsent(id, _SocketSummary.new);
      final kw = double.tryParse(parts[1].trim()) ?? 0;
      if (kw > summary.maxKw) summary.maxKw = kw;
      summary.count++;
      final type = _connectorFromTur(parts[4]);
      if (type != null && !summary.connectors.contains(type)) summary.connectors.add(type);
    }
    return map;
  }

  Station? _parseEpdk(Map<String, dynamic> feature, Map<String, _SocketSummary> sockets) {
    final props = feature['properties'];
    if (props is! Map<String, dynamic>) return null;
    final geometry = feature['geometry'];
    double? lon;
    double? lat;
    if (geometry is Map<String, dynamic>) {
      final coords = geometry['coordinates'];
      if (coords is List && coords.length >= 2) {
        lon = (coords[0] as num?)?.toDouble();
        lat = (coords[1] as num?)?.toDouble();
      }
    }
    lat ??= (props['LATITUDE'] as num?)?.toDouble();
    lon ??= (props['LONGITUDE'] as num?)?.toDouble();
    if (lat == null || lon == null || lat < 35 || lat > 43 || lon < 25 || lon > 46) return null;

    final stationNo = _text(props['ISTASYON_NO']) ?? '';
    final brand = _text(props['MARKA_TESCIL_BELGESI']) ?? _text(props['AGIL_ISLETMECISI_UNVAN']) ?? 'EPDK';
    final name = _text(props['AD']) ?? brand;
    final address = _text(props['ADRES']) ?? '';
    final place = _placeFromAddress(address);
    final summary = sockets[stationNo];
    final connectors = summary == null || summary.connectors.isEmpty ? const [ConnectorType.type2] : List<ConnectorType>.from(summary.connectors);

    return Station(
      id: 'epdk-$stationNo',
      name: name,
      city: place.$1,
      district: place.$2,
      address: address.isEmpty ? 'EPDK kaydı' : address,
      chargeOperator: ChargeOperator(
        id: 'epdk-${_slug(brand)}',
        name: brand,
        logoLetter: brand.isEmpty ? '?' : brand[0].toUpperCase(),
        description: _text(props['AGIL_ISLETMECISI_UNVAN']) ?? 'EPDK şarj ağı işletmecisi.',
      ),
      connectors: connectors,
      maxPowerKw: summary == null || summary.maxKw <= 0 ? 22 : summary.maxKw,
      pricePerKwh: 0,
      status: StationStatus.available,
      distanceKm: _km(_istanbul.lat, _istanbul.lon, lat, lon),
      rating: 0,
      socketCount: summary?.count ?? 1,
      latitude: lat,
      longitude: lon,
      origin: 'EPDK',
    );
  }

  (String, String) _placeFromAddress(String address) {
    final parts = address.split('/');
    if (parts.length < 2) return ('İstanbul', '');
    final city = parts.last.trim();
    final before = parts[parts.length - 2].trim();
    final words = before.split(RegExp(r'\s+'));
    final district = words.isEmpty ? '' : words.last;
    return (city.isEmpty ? 'İstanbul' : city, district);
  }

  ConnectorType? _connectorFromTur(String raw) {
    final tur = raw.trim().toUpperCase();
    if (tur.contains('CCS')) return ConnectorType.ccs2;
    if (tur.contains('CHADEMO')) return ConnectorType.chademo;
    if (tur.contains('TYPE2') || tur.contains('TYPE_2')) return ConnectorType.type2;
    if (tur.startsWith('AC')) return ConnectorType.ac;
    if (tur.startsWith('DC')) return ConnectorType.ccs2;
    return null;
  }

  List<Station> _merge(List<Station> osm, List<Station> epdk) {
    if (epdk.isEmpty) return osm;
    if (osm.isEmpty) return epdk;
    final buckets = <String, List<int>>{};
    for (var i = 0; i < epdk.length; i++) {
      buckets.putIfAbsent(_cell(epdk[i].latitude, epdk[i].longitude), () => []).add(i);
    }
    final used = <int>{};
    final keptOsm = <Station>[];
    for (final point in osm) {
      var best = -1;
      var bestKm = 0.12;
      final latCell = (point.latitude * 50).round();
      final lonCell = (point.longitude * 50).round();
      for (var dy = -1; dy <= 1; dy++) {
        for (var dx = -1; dx <= 1; dx++) {
          final hits = buckets['${latCell + dy}_${lonCell + dx}'];
          if (hits == null) continue;
          for (final index in hits) {
            if (used.contains(index)) continue;
            final km = _km(point.latitude, point.longitude, epdk[index].latitude, epdk[index].longitude);
            if (km < bestKm) {
              bestKm = km;
              best = index;
            }
          }
        }
      }
      if (best == -1) {
        keptOsm.add(point);
        continue;
      }
      used.add(best);
      final official = epdk[best];
      epdk[best] = Station(
        id: official.id,
        name: official.name,
        city: official.city,
        district: official.district.isEmpty ? point.district : official.district,
        address: official.address,
        chargeOperator: official.chargeOperator,
        connectors: official.connectors,
        maxPowerKw: official.maxPowerKw,
        pricePerKwh: official.pricePerKwh,
        status: official.status,
        distanceKm: official.distanceKm,
        rating: official.rating,
        socketCount: official.socketCount,
        latitude: official.latitude,
        longitude: official.longitude,
        origin: 'EPDK + OSM',
      );
    }
    return [...epdk, ...keptOsm];
  }

  String _cell(double lat, double lon) => '${(lat * 50).round()}_${(lon * 50).round()}';

  String? _text(Object? value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  String _slug(String value) => value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

  String _guessCity(double lat, double lon) {
    if (lat > 40.7 && lon < 29.6) return 'İstanbul';
    if (lat > 39.6 && lon > 32.2 && lon < 33.3) return 'Ankara';
    if (lat > 38.1 && lat < 38.7 && lon < 27.5) return 'İzmir';
    if (lat < 37.2 && lon > 30.4) return 'Antalya';
    if (lat > 40.0 && lon > 28.7 && lon < 29.4) return 'Bursa';
    return 'Türkiye';
  }

  List<ConnectorType> _connectors(Map<String, dynamic> tags) {
    final keys = tags.keys.map((k) => k.toString().toLowerCase()).toList();
    final found = <ConnectorType>[];
    bool has(String needle) => keys.any((k) => k.contains(needle));
    if (has('ccs') || has('type2_combo') || has('combo')) found.add(ConnectorType.ccs2);
    if (has('chademo')) found.add(ConnectorType.chademo);
    if (has('type2') || has('iec62196') || has('mennekes')) found.add(ConnectorType.type2);
    if (has('schuko') || has('socket:ac') || has(':ac')) found.add(ConnectorType.ac);
    if (found.isEmpty) found.add(ConnectorType.type2);
    return found;
  }

  double _powerKw(Map<String, dynamic> tags, List<ConnectorType> connectors) {
    for (final entry in tags.entries) {
      final key = entry.key.toString().toLowerCase();
      if (!key.contains('output') && key != 'maxpower') continue;
      final parsed = _kw(entry.value?.toString());
      if (parsed != null && parsed > 0) return parsed;
    }
    if (connectors.contains(ConnectorType.ccs2) || connectors.contains(ConnectorType.chademo)) return 50;
    return 22;
  }

  double? _kw(String? raw) {
    if (raw == null) return null;
    final match = RegExp(r'[\d.]+').firstMatch(raw);
    if (match == null) return null;
    final n = double.tryParse(match.group(0)!);
    if (n == null) return null;
    return n > 400 ? n / 1000 : n;
  }

  int _socketCount(Map<String, dynamic> tags) {
    final capacity = int.tryParse(tags['capacity']?.toString() ?? '');
    if (capacity != null && capacity > 0) return capacity;
    var sum = 0;
    for (final entry in tags.entries) {
      final key = entry.key.toString().toLowerCase();
      if (!key.startsWith('socket:') || key.contains('output')) continue;
      sum += int.tryParse(entry.value.toString()) ?? 1;
    }
    return sum == 0 ? 1 : sum;
  }

  double _km(double lat1, double lon1, double lat2, double lon2) {
    const earth = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat1)) * math.cos(_rad(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2);
    return earth * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  double _rad(double deg) => deg * math.pi / 180;
}
