/// Derleme anında verilen adresler. Gizli anahtar burada tutulmaz.
/// Operatör API anahtarları uygulama ikilisine gömülmez; backend'de kalır.
///
/// Örnek: `flutter run --dart-define=EPDK_STATIONS_URL=https://...`
abstract final class AppConfig {
  static const epdkStationsUrl = String.fromEnvironment(
    'EPDK_STATIONS_URL',
    defaultValue: 'https://apigateway.epdk.gov.tr/sarjIstasyonlari',
  );

  static const overpassUrl = String.fromEnvironment(
    'OVERPASS_URL',
    defaultValue: 'https://overpass-api.de/api/interpreter',
  );
}
