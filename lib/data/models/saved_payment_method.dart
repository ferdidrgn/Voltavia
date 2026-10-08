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

  /// Kart numarası yok. Kullanıcı, tutarın operatör tarafından tahsil edileceğini onaylar.
  final bool operatorCheckout;

  const SavedPaymentMethod({
    required this.id,
    required this.brand,
    required this.last4,
    required this.holderName,
    required this.expiry,
    this.isDefault = false,
    this.operatorCheckout = false,
  });

  String get label => switch (brand) {
        CardBrand.visa => 'Visa',
        CardBrand.mastercard => 'Mastercard',
        CardBrand.troy => 'Troy',
      };

  String get title => operatorCheckout ? 'Operatör tahsilatı' : '$label •••• $last4';

  SavedPaymentMethod copyWith({bool? isDefault}) => SavedPaymentMethod(
        id: id,
        brand: brand,
        last4: last4,
        holderName: holderName,
        expiry: expiry,
        isDefault: isDefault ?? this.isDefault,
        operatorCheckout: operatorCheckout,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand.name,
        'last4': last4,
        'holderName': holderName,
        'expiry': expiry,
        'isDefault': isDefault,
        'operatorCheckout': operatorCheckout,
      };

  static SavedPaymentMethod? tryParse(Map<String, dynamic> json) {
    try {
      CardBrand? brand;
      for (final value in CardBrand.values) {
        if (value.name == json['brand']) brand = value;
      }
      if (brand == null) return null;
      return SavedPaymentMethod(
        id: json['id'] as String,
        brand: brand,
        last4: json['last4'] as String? ?? '',
        holderName: json['holderName'] as String? ?? '',
        expiry: json['expiry'] as String? ?? '',
        isDefault: json['isDefault'] == true,
        operatorCheckout: json['operatorCheckout'] == true,
      );
    } catch (_) {
      return null;
    }
  }
}
