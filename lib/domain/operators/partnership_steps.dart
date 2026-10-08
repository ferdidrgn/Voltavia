/// Operatör sözleşmesinde istenen dosya. İşaretler yereldir; şarj başlatmaz.
class PartnershipStep {
  final String id;
  final String title;
  final String body;

  const PartnershipStep({required this.id, required this.title, required this.body});
}

const partnershipSteps = [
  PartnershipStep(
    id: 'ticari',
    title: 'Ticari lisans',
    body: 'Aylık platform lisansı ve KVKK metni imzalanır. Voltavia şarj bedelini tahsil etmez.',
  ),
  PartnershipStep(
    id: 'credentials',
    title: 'OCPI kimlik değişimi',
    body: 'Versions ve Credentials modülleriyle token değişilir. Anahtar uygulama içine konmaz.',
  ),
  PartnershipStep(
    id: 'locations',
    title: 'İstasyon ve EVSE listesi',
    body: 'Her soketin location kimliği ve EVSE uid değeri operatörden gelir.',
  ),
  PartnershipStep(
    id: 'tariffs',
    title: 'Tarife',
    body: 'Birim fiyat operatörden okunur. Katalogda fiyat yoksa alan boş kalır.',
  ),
  PartnershipStep(
    id: 'tokens',
    title: 'Kullanıcı jetonu',
    body: 'Uygulama kullanıcısı APP_USER jetonuyla eşlenir.',
  ),
  PartnershipStep(
    id: 'commands',
    title: 'Başlat ve durdur',
    body: 'Commands modülüyle StartSession ve StopSession gider.',
  ),
  PartnershipStep(
    id: 'payment',
    title: 'Operatör tahsilatı',
    body: 'Kart, operatörün ödeme kuruluşunda kalır. Voltavia numara ve CVV istemez.',
  ),
];
