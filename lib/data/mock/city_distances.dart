/// Rota planlayıcı için kullanılan, büyük şehirler arası kabaca kara yolu
/// mesafeleri (km) — gerçek bir yönlendirme (routing) motoru bağlanana kadar
/// kullanılan sabit bir referans tablosudur, hassas navigasyon verisi değildir.
abstract final class CityDistances {
  static const cities = [
    'İstanbul',
    'Ankara',
    'İzmir',
    'Bursa',
    'Antalya',
    'Adana',
    'Konya',
    'Gaziantep',
    'Kayseri',
    'Trabzon',
  ];

  static const Map<String, int> _distances = {
    'İstanbul-Ankara': 450,
    'İstanbul-İzmir': 480,
    'İstanbul-Bursa': 155,
    'İstanbul-Antalya': 725,
    'İstanbul-Adana': 915,
    'İstanbul-Konya': 660,
    'İstanbul-Gaziantep': 1085,
    'İstanbul-Kayseri': 740,
    'İstanbul-Trabzon': 1085,
    'Ankara-İzmir': 585,
    'Ankara-Bursa': 385,
    'Ankara-Antalya': 480,
    'Ankara-Adana': 490,
    'Ankara-Konya': 260,
    'Ankara-Gaziantep': 655,
    'Ankara-Kayseri': 320,
    'Ankara-Trabzon': 780,
    'İzmir-Bursa': 325,
    'İzmir-Antalya': 480,
    'İzmir-Adana': 800,
    'İzmir-Konya': 465,
    'İzmir-Gaziantep': 1055,
    'İzmir-Kayseri': 700,
    'İzmir-Trabzon': 1235,
    'Bursa-Antalya': 545,
    'Bursa-Adana': 940,
    'Bursa-Konya': 500,
    'Bursa-Gaziantep': 1110,
    'Bursa-Kayseri': 665,
    'Bursa-Trabzon': 1155,
    'Antalya-Adana': 480,
    'Antalya-Konya': 300,
    'Antalya-Gaziantep': 745,
    'Antalya-Kayseri': 495,
    'Antalya-Trabzon': 1200,
    'Adana-Konya': 335,
    'Adana-Gaziantep': 220,
    'Adana-Kayseri': 335,
    'Adana-Trabzon': 745,
    'Konya-Gaziantep': 500,
    'Konya-Kayseri': 320,
    'Konya-Trabzon': 905,
    'Gaziantep-Kayseri': 390,
    'Gaziantep-Trabzon': 745,
    'Kayseri-Trabzon': 560,
  };

  static int distanceKm(String from, String to) {
    if (from == to) return 0;
    final key1 = '$from-$to';
    final key2 = '$to-$from';
    return _distances[key1] ?? _distances[key2] ?? 500;
  }

  const CityDistances._();
}
