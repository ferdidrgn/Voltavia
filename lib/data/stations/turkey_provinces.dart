import '../../core/utils/geo.dart';

/// İl merkezi. İstasyon kaydında il yoksa en yakın merkez atanır.
class TurkeyProvince {
  final String name;
  final double latitude;
  final double longitude;

  const TurkeyProvince(this.name, this.latitude, this.longitude);
}

const turkeyProvinces = <TurkeyProvince>[
  TurkeyProvince('Adana', 37.0000, 35.3213),
  TurkeyProvince('Adıyaman', 37.7648, 38.2786),
  TurkeyProvince('Afyonkarahisar', 38.7507, 30.5567),
  TurkeyProvince('Ağrı', 39.7191, 43.0503),
  TurkeyProvince('Aksaray', 38.3687, 34.0370),
  TurkeyProvince('Amasya', 40.6499, 35.8353),
  TurkeyProvince('Ankara', 39.9334, 32.8597),
  TurkeyProvince('Antalya', 36.8969, 30.7133),
  TurkeyProvince('Ardahan', 41.1105, 42.7022),
  TurkeyProvince('Artvin', 41.1828, 41.8183),
  TurkeyProvince('Aydın', 37.8560, 27.8416),
  TurkeyProvince('Balıkesir', 39.6484, 27.8826),
  TurkeyProvince('Bartın', 41.6344, 32.3375),
  TurkeyProvince('Batman', 37.8812, 41.1351),
  TurkeyProvince('Bayburt', 40.2552, 40.2249),
  TurkeyProvince('Bilecik', 40.1451, 29.9793),
  TurkeyProvince('Bingöl', 38.8854, 40.4983),
  TurkeyProvince('Bitlis', 38.4006, 42.1095),
  TurkeyProvince('Bolu', 40.7392, 31.6110),
  TurkeyProvince('Burdur', 37.7203, 30.2908),
  TurkeyProvince('Bursa', 40.1885, 29.0610),
  TurkeyProvince('Çanakkale', 40.1553, 26.4142),
  TurkeyProvince('Çankırı', 40.6013, 33.6134),
  TurkeyProvince('Çorum', 40.5506, 34.9556),
  TurkeyProvince('Denizli', 37.7765, 29.0864),
  TurkeyProvince('Diyarbakır', 37.9144, 40.2306),
  TurkeyProvince('Düzce', 40.8438, 31.1565),
  TurkeyProvince('Edirne', 41.6818, 26.5623),
  TurkeyProvince('Elazığ', 38.6810, 39.2264),
  TurkeyProvince('Erzincan', 39.7500, 39.5000),
  TurkeyProvince('Erzurum', 39.9055, 41.2658),
  TurkeyProvince('Eskişehir', 39.7767, 30.5206),
  TurkeyProvince('Gaziantep', 37.0662, 37.3833),
  TurkeyProvince('Giresun', 40.9128, 38.3895),
  TurkeyProvince('Gümüşhane', 40.4603, 39.4814),
  TurkeyProvince('Hakkari', 37.5744, 43.7408),
  TurkeyProvince('Hatay', 36.4018, 36.3498),
  TurkeyProvince('Iğdır', 39.9237, 44.0450),
  TurkeyProvince('Isparta', 37.7648, 30.5566),
  TurkeyProvince('İstanbul', 41.0082, 28.9784),
  TurkeyProvince('İzmir', 38.4237, 27.1428),
  TurkeyProvince('Kahramanmaraş', 37.5858, 36.9371),
  TurkeyProvince('Karabük', 41.2061, 32.6204),
  TurkeyProvince('Karaman', 37.1759, 33.2287),
  TurkeyProvince('Kars', 40.6013, 43.0975),
  TurkeyProvince('Kastamonu', 41.3887, 33.7827),
  TurkeyProvince('Kayseri', 38.7312, 35.4787),
  TurkeyProvince('Kilis', 36.7184, 37.1212),
  TurkeyProvince('Kırıkkale', 39.8468, 33.5153),
  TurkeyProvince('Kırklareli', 41.7333, 27.2167),
  TurkeyProvince('Kırşehir', 39.1425, 34.1709),
  TurkeyProvince('Kocaeli', 40.8533, 29.8815),
  TurkeyProvince('Konya', 37.8746, 32.4932),
  TurkeyProvince('Kütahya', 39.4242, 29.9833),
  TurkeyProvince('Malatya', 38.3552, 38.3095),
  TurkeyProvince('Manisa', 38.6191, 27.4289),
  TurkeyProvince('Mardin', 37.3212, 40.7245),
  TurkeyProvince('Mersin', 36.8121, 34.6415),
  TurkeyProvince('Muğla', 37.2153, 28.3636),
  TurkeyProvince('Muş', 38.7346, 41.4910),
  TurkeyProvince('Nevşehir', 38.6939, 34.6857),
  TurkeyProvince('Niğde', 37.9667, 34.6833),
  TurkeyProvince('Ordu', 40.9839, 37.8764),
  TurkeyProvince('Osmaniye', 37.0742, 36.2478),
  TurkeyProvince('Rize', 41.0201, 40.5234),
  TurkeyProvince('Sakarya', 40.7569, 30.3781),
  TurkeyProvince('Samsun', 41.2867, 36.3300),
  TurkeyProvince('Siirt', 37.9333, 41.9500),
  TurkeyProvince('Sinop', 42.0231, 35.1531),
  TurkeyProvince('Sivas', 39.7477, 37.0179),
  TurkeyProvince('Şanlıurfa', 37.1591, 38.7969),
  TurkeyProvince('Şırnak', 37.5164, 42.4611),
  TurkeyProvince('Tekirdağ', 40.9833, 27.5167),
  TurkeyProvince('Tokat', 40.3167, 36.5500),
  TurkeyProvince('Trabzon', 41.0027, 39.7168),
  TurkeyProvince('Tunceli', 39.1079, 39.5401),
  TurkeyProvince('Uşak', 38.6823, 29.4082),
  TurkeyProvince('Van', 38.4891, 43.4089),
  TurkeyProvince('Yalova', 40.6500, 29.2667),
  TurkeyProvince('Yozgat', 39.8181, 34.8147),
  TurkeyProvince('Zonguldak', 41.4564, 31.7987),
];

TurkeyProvince? provinceByName(String raw) {
  final key = foldTr(raw);
  if (key.isEmpty) return null;
  for (final province in turkeyProvinces) {
    if (foldTr(province.name) == key) return province;
  }
  return null;
}

String provinceNameAt(double latitude, double longitude) {
  var best = turkeyProvinces.first;
  var bestKm = double.infinity;
  for (final province in turkeyProvinces) {
    final km = kmBetween(latitude, longitude, province.latitude, province.longitude);
    if (km < bestKm) {
      bestKm = km;
      best = province;
    }
  }
  return best.name;
}

/// Kayıttaki il, adresin son parçası ya da koordinat. İlçe uydurulmaz.
({String city, String district}) resolvePlace({
  required double latitude,
  required double longitude,
  String? taggedCity,
  String? taggedDistrict,
  String? address,
}) {
  var district = taggedDistrict?.trim() ?? '';
  var city = provinceByName(taggedCity ?? '')?.name;

  if (address != null && address.contains('/')) {
    final parts = address.split('/');
    city ??= provinceByName(parts.last)?.name;
    if (district.isEmpty && parts.length >= 2) {
      final words = parts[parts.length - 2].trim().split(RegExp(r'\s+'));
      if (words.isNotEmpty) district = words.last;
    }
  }

  if (city == null) {
    final rawCity = taggedCity?.trim() ?? '';
    if (rawCity.isNotEmpty && district.isEmpty) district = rawCity;
    city = provinceNameAt(latitude, longitude);
  }

  if (foldTr(district) == foldTr(city)) district = '';
  return (city: city, district: district);
}

String foldTr(String value) {
  return value
      .trim()
      .replaceAll('İ', 'i')
      .replaceAll('I', 'ı')
      .replaceAll('Â', 'a')
      .replaceAll('â', 'a')
      .replaceAll('Î', 'i')
      .replaceAll('î', 'i')
      .replaceAll('Û', 'u')
      .replaceAll('û', 'u')
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('ş', 's')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c');
}
