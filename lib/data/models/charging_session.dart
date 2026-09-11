enum SessionState { charging, completed, stopped }

class ChargingSession {
  final String id;
  final String stationName;
  final String operatorName;
  final DateTime startedAt;
  final DateTime? endedAt;
  final double energyKwh;
  final double costTry;
  final SessionState state;

  const ChargingSession({
    required this.id,
    required this.stationName,
    required this.operatorName,
    required this.startedAt,
    this.endedAt,
    required this.energyKwh,
    required this.costTry,
    required this.state,
  });
}
