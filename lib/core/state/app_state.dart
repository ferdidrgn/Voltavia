import 'package:flutter/material.dart';

import '../../data/mock/mock_data.dart';
import '../../data/models/charging_session.dart';
import '../../data/models/station.dart';

/// Uygulama genelinde paylaşılan, çok basit durum yönetimi.
///
/// Harici bir paket (provider/riverpod) eklemeden, salt Flutter SDK ile
/// `InheritedNotifier` üzerinden dağıtılır. Gerçek backend bağlanınca bu
/// katman repository çağrılarıyla değiştirilebilir.
class AppState extends ChangeNotifier {
  final Set<String> _favoriteStationIds = {};
  ChargingSession? _activeSession;
  Station? _activeStation;

  Set<String> get favoriteStationIds => _favoriteStationIds;
  ChargingSession? get activeSession => _activeSession;
  Station? get activeStation => _activeStation;
  bool get hasActiveSession => _activeSession != null;

  bool isFavorite(String stationId) => _favoriteStationIds.contains(stationId);

  void toggleFavorite(String stationId) {
    if (_favoriteStationIds.contains(stationId)) {
      _favoriteStationIds.remove(stationId);
    } else {
      _favoriteStationIds.add(stationId);
    }
    notifyListeners();
  }

  List<Station> get favoriteStations =>
      MockData.stations.where((s) => _favoriteStationIds.contains(s.id)).toList();

  void startSession(Station station) {
    _activeStation = station;
    _activeSession = ChargingSession(
      id: 'live-${DateTime.now().millisecondsSinceEpoch}',
      stationName: station.name,
      operatorName: station.chargeOperator.name,
      startedAt: DateTime.now(),
      energyKwh: 0,
      costTry: 0,
      state: SessionState.charging,
    );
    notifyListeners();
  }

  void stopSession() {
    if (_activeSession == null) return;
    _activeSession = ChargingSession(
      id: _activeSession!.id,
      stationName: _activeSession!.stationName,
      operatorName: _activeSession!.operatorName,
      startedAt: _activeSession!.startedAt,
      endedAt: DateTime.now(),
      energyKwh: _activeSession!.energyKwh,
      costTry: _activeSession!.costTry,
      state: SessionState.completed,
    );
    notifyListeners();
  }

  void clearSession() {
    _activeSession = null;
    _activeStation = null;
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({super.key, required AppState super.notifier, required super.child});

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in widget tree');
    return scope!.notifier!;
  }
}
