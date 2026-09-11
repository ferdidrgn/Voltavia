enum CardBrand { visa, mastercard, troy }

/// Kullanıcının kayıtlı ödeme yöntemi (kart) — gerçek kart numarası hiçbir
/// zaman istemcide tutulmaz, yalnızca operatörün lisanslı altyapısından
/// dönen son 4 hane ve marka bilgisi gösterilir.
class SavedPaymentMethod {
  final String id;
  final CardBrand brand;
  final String last4;
  final String holderName;
  final String expiry;
  final bool isDefault;

  const SavedPaymentMethod({
    required this.id,
    required this.brand,
    required this.last4,
    required this.holderName,
    required this.expiry,
    this.isDefault = false,
  });

  String get label => switch (brand) {
        CardBrand.visa => 'Visa',
        CardBrand.mastercard => 'Mastercard',
        CardBrand.troy => 'Troy',
      };

  SavedPaymentMethod copyWith({bool? isDefault}) => SavedPaymentMethod(
        id: id,
        brand: brand,
        last4: last4,
        holderName: holderName,
        expiry: expiry,
        isDefault: isDefault ?? this.isDefault,
      );
}
