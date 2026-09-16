/// `intl` paketine bağımlı olmadan, uygulama genelinde kullanılan basit
/// biçimlendirme yardımcıları.
abstract final class Formatters {
  static String tryPrice(double value) => '${value.toStringAsFixed(2).replaceAll('.', ',')} ₺';

  static String kwh(double value) => '${value.toStringAsFixed(1)} kWh';

  static String km(double value) => '${value.toStringAsFixed(1)} km';

  static const _months = [
    'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
  ];

  static String date(DateTime dt) => '${dt.day} ${_months[dt.month - 1]} ${dt.year}';

  static String time(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  static String dateTime(DateTime dt) => '${date(dt)} · ${time(dt)}';

  static String relative(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'şimdi';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} sa önce';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    return date(dt);
  }

  static String duration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '$h sa $m dk';
    return '$m dk';
  }

  const Formatters._();
}
