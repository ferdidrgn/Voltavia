enum LicenseStatus { active, negotiating, expired }

/// Admin panelindeki "Firma / Lisans" görünümünü besleyen model.
/// ROADMAP.md § 3 — B2B lisans/entegrasyon gelir modeli.
class CompanyLicense {
  final String id;
  final String companyName;
  final String plan;
  final double monthlyFeeTry;
  final DateTime renewalDate;
  final LicenseStatus status;

  const CompanyLicense({
    required this.id,
    required this.companyName,
    required this.plan,
    required this.monthlyFeeTry,
    required this.renewalDate,
    required this.status,
  });
}
