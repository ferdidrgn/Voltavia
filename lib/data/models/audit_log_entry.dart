/// Admin/firma panelindeki kritik değişiklik kayıtlarını temsil eder
/// (bkz. ROADMAP.md § 7 — Güvenlik ve Kritik Kurallar).
class AuditLogEntry {
  final String id;
  final DateTime time;
  final String actorEmail;
  final String action;

  const AuditLogEntry({
    required this.id,
    required this.time,
    required this.actorEmail,
    required this.action,
  });
}
