import 'package:flutter/material.dart';

import '../../data/mock/mock_data.dart';
import '../../data/models/charging_session.dart';
import '../../data/models/connector_type.dart';
import '../../data/models/saved_payment_method.dart';
import '../../data/models/station.dart';
import '../../data/models/vehicle.dart';

/// Uygulama genelinde paylaşılan, çok basit durum yönetimi.
///
/// Harici bir paket (provider/riverpod) eklemeden, salt Flutter SDK ile
/// `InheritedNotifier` üzerinden dağıtılır. Gerçek backend bağlanınca bu
/// katman repository çağrılarıyla değiştirilebilir.
class AppState extends ChangeNotifier {
  final Set<String> _favoriteStationIds = {};
  ChargingSession? _activeSession;
  Station? _activeStation;

  final List<Vehicle> _vehicles = [
    const Vehicle(
      id: 'v1',
      brand: 'Tesla',
      model: 'Model 3',
      plate: '34 VT 3453',
      connector: ConnectorType.ccs2,
      batteryCapacityKwh: 60,
      consumptionKwhPer100km: 15.5,
      isDefault: true,
    ),
  ];

  final List<SavedPaymentMethod> _paymentMethods = [
    const SavedPaymentMethod(
      id: 'pm1',
      brand: CardBrand.visa,
      last4: '4242',
      holderName: 'Ferdi Durgun',
      expiry: '08/29',
      isDefault: true,
    ),
  ];

  Set<String> get favoriteStationIds => _favoriteStationIds;
  ChargingSession? get activeSession => _activeSession;
  Station? get activeStation => _activeStation;
  bool get hasActiveSession => _activeSession != null;

  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);
  Vehicle? get defaultVehicle =>
      _vehicles.isEmpty ? null : _vehicles.firstWhere((v) => v.isDefault, orElse: () => _vehicles.first);

  void addVehicle(Vehicle vehicle) {
    if (_vehicles.isEmpty) {
      _vehicles.add(vehicle.copyWith(isDefault: true));
    } else {
      _vehicles.add(vehicle);
    }
    notifyListeners();
  }

  void removeVehicle(String id) {
    final wasDefault = _vehicles.any((v) => v.id == id && v.isDefault);
    _vehicles.removeWhere((v) => v.id == id);
    if (wasDefault && _vehicles.isNotEmpty) {
      _vehicles[0] = _vehicles[0].copyWith(isDefault: true);
    }
    notifyListeners();
  }

  void setDefaultVehicle(String id) {
    for (var i = 0; i < _vehicles.length; i++) {
      _vehicles[i] = _vehicles[i].copyWith(isDefault: _vehicles[i].id == id);
    }
    notifyListeners();
  }

  List<SavedPaymentMethod> get paymentMethods => List.unmodifiable(_paymentMethods);

  void addPaymentMethod(SavedPaymentMethod method) {
    if (_paymentMethods.isEmpty) {
      _paymentMethods.add(method.copyWith(isDefault: true));
    } else {
      _paymentMethods.add(method);
    }
    notifyListeners();
  }

  void removePaymentMethod(String id) {
    final wasDefault = _paymentMethods.any((m) => m.id == id && m.isDefault);
    _paymentMethods.removeWhere((m) => m.id == id);
    if (wasDefault && _paymentMethods.isNotEmpty) {
      _paymentMethods[0] = _paymentMethods[0].copyWith(isDefault: true);
    }
    notifyListeners();
  }

  void setDefaultPaymentMethod(String id) {
    for (var i = 0; i < _paymentMethods.length; i++) {
      _paymentMethods[i] = _paymentMethods[i].copyWith(isDefault: _paymentMethods[i].id == id);
    }
    notifyListeners();
  }

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
