import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/geo.dart';
import '../../data/models/app_notification.dart';
import '../../data/stations/station_repository.dart';
import '../../domain/operators/partnership_steps.dart';
import '../../domain/stations/station_catalog.dart';
import '../../data/models/charging_session.dart';
import '../../data/models/saved_payment_method.dart';
import '../../data/models/operator.dart';
import '../../data/models/station.dart';
import '../../data/models/vehicle.dart';

/// Uygulama genelinde paylaşılan, çok basit durum yönetimi.
///
/// Harici bir paket (provider/riverpod) eklemeden, salt Flutter SDK ile
/// `InheritedNotifier` üzerinden dağıtılır. Gerçek backend bağlanınca bu
/// katman repository çağrılarıyla değiştirilebilir.
class AppState extends ChangeNotifier {
  AppState({StationCatalog? catalog}) : _stationsRepo = catalog ?? _resolveCatalog();

  static StationCatalog _resolveCatalog() {
    if (GetIt.instance.isRegistered<StationCatalog>()) {
      return GetIt.instance<StationCatalog>();
    }
    return StationRepository();
  }

  final Set<String> _favoriteStationIds = {};
  final StationCatalog _stationsRepo;
  List<Station> _stations = [];
  String _displayName = '';
  final List<AppNotification> _notifications = [];
  bool _stationsLoading = false;
  bool _usingLiveStations = false;
  bool _usingDeviceLocation = false;
  double? _deviceLatitude;
  double? _deviceLongitude;
  bool _disposed = false;

  List<Station> get stations => List.unmodifiable(_stations);
  bool get stationsLoading => _stationsLoading;
  bool get usingLiveStations => _usingLiveStations;
  bool get usingDeviceLocation => _usingDeviceLocation;
  double? get deviceLatitude => _deviceLatitude;
  double? get deviceLongitude => _deviceLongitude;
  String get displayName => _displayName;
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadNotificationCount => _notifications.where((item) => !item.isRead).length;

  List<({ChargeOperator operator, int stationCount})> get operatorCatalog {
    final grouped = <String, ({ChargeOperator operator, int stationCount})>{};
    for (final station in _stations) {
      final id = station.chargeOperator.id;
      final current = grouped[id];
      grouped[id] = (
        operator: station.chargeOperator,
        stationCount: (current?.stationCount ?? 0) + 1,
      );
    }
    final list = grouped.values.toList()..sort((a, b) => b.stationCount.compareTo(a.stationCount));
    return list;
  }

  List<Station> stationsForOperator(String operatorId) =>
      _stations.where((station) => station.chargeOperator.id == operatorId).toList();

  Future<void> refreshStations() async {
    _stationsLoading = true;
    _notify();
    if (_stations.isEmpty) {
      final cached = await _stationsRepo.cachedStations();
      if (!_disposed && _stations.isEmpty && cached.isNotEmpty) {
        _stations = cached;
        _usingLiveStations = true;
        _notify();
      }
    }
    try {
      final live = await _stationsRepo.fetchTurkeySample();
      if (_disposed) return;
      if (live.isNotEmpty) {
        _stations = live;
        _usingLiveStations = true;
      }
    } catch (_) {
      if (_disposed) return;
      _usingLiveStations = false;
    } finally {
      _stationsLoading = false;
      _notify();
    }
    await _refreshDistancesFromDevice();
  }

  Future<void> _refreshDistancesFromDevice() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled || _disposed) return;
      final permission = await Geolocator.checkPermission();
      if ((permission != LocationPermission.always && permission != LocationPermission.whileInUse) || _disposed) {
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      ).timeout(const Duration(seconds: 12));
      if (_disposed) return;
      _deviceLatitude = position.latitude;
      _deviceLongitude = position.longitude;
      _stations = [
        for (final station in _stations)
          station.withDistance(kmBetween(position.latitude, position.longitude, station.latitude, station.longitude)),
      ]..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      _usingDeviceLocation = true;
      _notify();
    } catch (_) {}
  }

  /// Konum, kullanıcı gerekçeyi gördükten sonra istenir. Kalıcı redde
  /// işletim sisteminin uygulama izin sayfası açılır.
  Future<void> requestDeviceLocation() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        await Geolocator.openLocationSettings();
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        await _refreshDistancesFromDevice();
      }
    } catch (_) {}
  }

  final List<ChargingSession> _completedSessions = [];
  ChargingSession? _activeSession;
  Station? _activeStation;

  final List<Vehicle> _vehicles = [];
  final List<SavedPaymentMethod> _paymentMethods = [];
  final Map<String, Set<String>> _partnershipSteps = {};

  Set<String> get favoriteStationIds => _favoriteStationIds;
  List<ChargingSession> get completedSessions => List.unmodifiable(_completedSessions);
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
    _persistGarage();
  }

  void removeVehicle(String id) {
    final wasDefault = _vehicles.any((v) => v.id == id && v.isDefault);
    _vehicles.removeWhere((v) => v.id == id);
    if (wasDefault && _vehicles.isNotEmpty) {
      _vehicles[0] = _vehicles[0].copyWith(isDefault: true);
    }
    notifyListeners();
    _persistGarage();
  }

  void setDefaultVehicle(String id) {
    for (var i = 0; i < _vehicles.length; i++) {
      _vehicles[i] = _vehicles[i].copyWith(isDefault: _vehicles[i].id == id);
    }
    notifyListeners();
    _persistGarage();
  }

  List<SavedPaymentMethod> get paymentMethods => List.unmodifiable(_paymentMethods);

  void addPaymentMethod(SavedPaymentMethod method) {
    if (_paymentMethods.isEmpty) {
      _paymentMethods.add(method.copyWith(isDefault: true));
    } else {
      _paymentMethods.add(method);
    }
    notifyListeners();
    _persistGarage();
  }

  void removePaymentMethod(String id) {
    final wasDefault = _paymentMethods.any((m) => m.id == id && m.isDefault);
    _paymentMethods.removeWhere((m) => m.id == id);
    if (wasDefault && _paymentMethods.isNotEmpty) {
      _paymentMethods[0] = _paymentMethods[0].copyWith(isDefault: true);
    }
    notifyListeners();
    _persistGarage();
  }

  void setDefaultPaymentMethod(String id) {
    for (var i = 0; i < _paymentMethods.length; i++) {
      _paymentMethods[i] = _paymentMethods[i].copyWith(isDefault: _paymentMethods[i].id == id);
    }
    notifyListeners();
    _persistGarage();
  }

  Set<String> partnershipStepsFor(String operatorId) =>
      Set.unmodifiable(_partnershipSteps[operatorId] ?? const {});

  void togglePartnershipStep(String operatorId, String stepId) {
    final known = partnershipSteps.any((step) => step.id == stepId);
    if (!known) return;
    final current = _partnershipSteps.putIfAbsent(operatorId, () => {});
    if (!current.add(stepId)) current.remove(stepId);
    notifyListeners();
    _persistGarage();
  }

  static const _favoritesKey = 'voltavia.favoriteStationIds';
  static const _vehiclesKey = 'voltavia.vehicles';
  static const _paymentsKey = 'voltavia.operatorCheckouts';
  static const _partnershipKey = 'voltavia.partnershipSteps';
  static const _displayNameKey = 'voltavia.displayName';

  Future<void> setDisplayName(String name) async {
    _displayName = name.trim();
    _notify();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_displayNameKey, _displayName);
    } catch (_) {}
  }

  Future<void> restoreProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed) return;
      _displayName = prefs.getString(_displayNameKey) ?? '';
      final vehicleRaw = prefs.getString(_vehiclesKey);
      if (vehicleRaw != null) {
        final decoded = jsonDecode(vehicleRaw);
        if (decoded is List) {
          _vehicles.clear();
          for (final item in decoded) {
            if (item is! Map) continue;
            final vehicle = Vehicle.tryParse(Map<String, dynamic>.from(item));
            if (vehicle != null) _vehicles.add(vehicle);
          }
        }
      }
      final paymentRaw = prefs.getString(_paymentsKey);
      if (paymentRaw != null) {
        final decoded = jsonDecode(paymentRaw);
        if (decoded is List) {
          _paymentMethods.clear();
          for (final item in decoded) {
            if (item is! Map) continue;
            final method = SavedPaymentMethod.tryParse(Map<String, dynamic>.from(item));
            if (method != null && method.operatorCheckout) _paymentMethods.add(method);
          }
        }
      }
      final partnershipRaw = prefs.getString(_partnershipKey);
      if (partnershipRaw != null) {
        final decoded = jsonDecode(partnershipRaw);
        if (decoded is Map) {
          _partnershipSteps.clear();
          for (final entry in decoded.entries) {
            final steps = entry.value;
            if (steps is! List) continue;
            _partnershipSteps[entry.key.toString()] = {for (final step in steps) step.toString()};
          }
        }
      }
      _notify();
    } catch (_) {}
  }

  Future<void> _persistGarage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_vehiclesKey, jsonEncode([for (final vehicle in _vehicles) vehicle.toJson()]));
      await prefs.setString(
        _paymentsKey,
        jsonEncode([for (final method in _paymentMethods) method.toJson()]),
      );
      await prefs.setString(
        _partnershipKey,
        jsonEncode({
          for (final entry in _partnershipSteps.entries) entry.key: entry.value.toList(),
        }),
      );
    } catch (_) {}
  }

  bool isFavorite(String stationId) => _favoriteStationIds.contains(stationId);

  Future<void> restoreFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList(_favoritesKey);
      if (saved == null || _disposed) return;
      _favoriteStationIds
        ..clear()
        ..addAll(saved);
      _notify();
    } catch (_) {}
  }

  void toggleFavorite(String stationId) {
    if (_favoriteStationIds.contains(stationId)) {
      _favoriteStationIds.remove(stationId);
    } else {
      _favoriteStationIds.add(stationId);
    }
    notifyListeners();
    _persistFavorites();
  }

  Future<void> _persistFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favoriteStationIds.toList());
    } catch (_) {}
  }

  List<Station> get favoriteStations =>
      _stations.where((s) => _favoriteStationIds.contains(s.id)).toList();

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

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
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
