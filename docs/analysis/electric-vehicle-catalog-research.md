# Elektrikli araç katalog araştırması

**Araştırma tarihi:** 22 Kasım 2026

## Katalog kaynağı kararı

Elektrikli araç varyantı, batarya, WLTP menzili ve şarj bağlantısı verisi sağlayan hazır bir ürün olan EV Database mevcut. Ancak ücretsiz kullanım önceden yazılı izin gerektiriyor; API/veri dışa aktarımı ücretsiz plana dahil değil ve otomatik veri toplama yasak. Ücretli API/data service şirketlere sunuluyor ve ülke bazlı hazır yerel kümeler Almanya, Hollanda ve Birleşik Krallık olarak listeleniyor. Bu nedenle lisans anlaşması olmadan EV Database verisini uygulamaya kopyalamıyoruz.

İlk sürüm için üreticilerin Türkiye sayfalarından elle doğrulanmış, küçük bir araç kataloğu eklendi. Bu katalog kullanıcı seçimini hızlandıran bir başlangıçtır; araç yılı, paket, net/nominal kapasite ve şarj donanımı pazara göre değişebilir. Katalogdan gelen kapasite/tüketim profil içinde değiştirilebilir ve başlangıçta doğrulama uyarısı gösterilir. Fiyat veya canlı telemetri tutulmaz.

## KMP başlangıç kataloğu

| Marka/model-varyant | Katalog bataryası | WLTP menzili | Teknik kaynak |
|---|---:|---:|---|
| Togg T10X V1 RWD Standart | 52 kWh yaklaşık | 314 km referans | [Togg T10X](https://togg.com.tr/t10x) |
| Togg T10X V1 RWD Uzun | 89 kWh yaklaşık | 523 km'ye kadar | [Togg T10X](https://togg.com.tr/t10x) |
| Togg T10F RWD Standart | 52 kWh yaklaşık | 350 km'ye kadar | [Togg T10F ve teknik duyuru](https://togg.com.tr/t10f) |
| Togg T10F RWD Uzun | 89 kWh yaklaşık | 623 km'ye kadar | [Togg T10F](https://togg.com.tr/t10f) |
| BYD DOLPHIN Comfort | 60 kWh yaklaşık | 427 km'ye kadar | [BYD Türkiye DOLPHIN](https://www.bydauto.com.tr/dolphin) |
| BYD ATTO 3 Design | 60 kWh yaklaşık | 420 km'ye kadar | [BYD Türkiye ATTO 3](https://www.bydauto.com.tr/atto3) |
| Hyundai IONIQ 5 2WD | 84 kWh | 570 km'ye kadar | [Hyundai Türkiye IONIQ 5](https://www.hyundai.com/tr/tr/modeller/ioniq5.html) |
| Hyundai KONA Elektrik | 65 kWh yaklaşık | katalogda belirtilmiyor | [Hyundai Türkiye elektrikli modeller](https://www.hyundai.com/tr/tr/electrification/electrified-models/e-mobility.html) |
| Kia EV3 Standard Range | 58 kWh yaklaşık | katalogda belirtilmiyor | [Kia Türkiye EV3 teknik özellikleri](https://www.kia.com/tr/modeller/ev3/teknik-ozellikler.html) |
| Kia EV3 Long Range | 81 kWh yaklaşık | 604 km'ye kadar | [Kia Türkiye EV3 teknik özellikleri](https://www.kia.com/tr/modeller/ev3/teknik-ozellikler.html) |

Değerler kullanıcı deneyimindeki seçimi kolaylaştıran yaklaşık başlangıç değerleridir; hesaplanan tüketim `kWh / WLTP km` oranından türetilir. Bu oran üreticinin gerçek tüketim değeri yerine geçmez. Model seçildikten sonra kullanıcı kapasite, konnektör, tüketim, batarya yüzdesi ve rezervi araç ruhsatı/üretici dokümanına göre düzenleyebilir.

## Uygulama davranışı

- Katalog araması marka, model ve donanım varyantında çalışır.
- Araç seçilince profil alanları doldurulur; kullanıcı düzenleyip kaydeder.
- Seçili katalog kimliği, araç profili ve kullanıcı ayarları DataStore'a yazılır.
- Ana sayfa seçili aracı, mevcut batarya yüzdesini, profil tüketiminden türeyen yaklaşık menzili ve soket tipini gösterir.
- Profil/ayar ekranında aynı araç özeti ve araç değiştir aksiyonu vardır.
- Yol enerji hesabı seçilen aracın kapasite/tüketim/rezerv girdilerini kullanır.
- Birden fazla araç aynı anda kaydetme sonraki adım; ilk akış tek aktif araç üzerinedir.

## Kaynaklar

- [EV Database data services ve ücretsiz kullanım koşulları](https://ev-database.org/uk/data-services-api)
- [Togg T10X](https://togg.com.tr/t10x) ve [Togg T10F](https://togg.com.tr/t10f)
- [BYD Türkiye DOLPHIN](https://www.bydauto.com.tr/dolphin) ve [ATTO 3](https://www.bydauto.com.tr/atto3)
- [Hyundai Türkiye IONIQ 5](https://www.hyundai.com/tr/tr/modeller/ioniq5.html) ve [elektrikli modeller](https://www.hyundai.com/tr/tr/electrification/electrified-models/e-mobility.html)
- [Kia Türkiye EV3 teknik özellikleri](https://www.kia.com/tr/modeller/ev3/teknik-ozellikler.html)
