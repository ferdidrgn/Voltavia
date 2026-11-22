# 06 - Kalıcı ayarlar, araç hesabı ve veri güveni

**Durum:** Kodlandı; Android/iOS derleme doğrulaması Gradle dağıtımı bulunamadığı için bekliyor.

## Tamamlanan işler

- Android ve iOS dosya depolaması kullanan KMP DataStore Preferences kuruldu.
- Seçilen palet, açık/koyu modu, özel HEX vurgu rengi, favori istasyon kimlikleri ve araç girdileri kalıcı kayda bağlandı.
- Açık/koyu modu tema paletinden bağımsız hale getirildi; renkli metin yerine vurgu rengine göre açık/koyu `onPrimary` seçiliyor.
- Araç profiline tüketim ve korunacak rezerv eklendi. Menzil hesabı bu kullanıcı girdileriyle yapılır ve kesin değer gibi sunulmaz.
- Kullanıcının verdiği yol mesafesine göre ihtiyaç duyulan enerji ve varış batarya yüzdesi gösterilir. Gerçek rota/navigasyon hesabı değildir.
- Rota durağı sıralayıcısı araç konnektör uyumsuzluğunu ve kalan menzil dışındaki noktayı eler; mevcut durum, sapma ve güç bilgilerine göre sıralar.
- İstasyonun her bir alanı kaynak, güncelleme zamanı ve güven düzeyi taşıyabilir. Eski bilgi `Stale`; eksik veya gelecek zaman damgası `Unknown` olarak değerlendirilir.
- OSM harita verisi ile tile sunucusu ayrıldı. Üretim için lisans ve kapasite incelemesi yapılmadan `tile.openstreetmap.org` varsayılan servis yapılmayacak.

## Açık kalanlar

- Derleme: `gradlew.bat --offline :composeApp:compileKotlinMetadata` çalıştırıldı; Gradle 9.1.0 dağıtımı önbellekte bulunmadığından build başlayamadı. Daha önce wrapper indirmesinde `services.gradle.org` DNS erişimi de başarısız olmuştu.
- Serbest renk girişinde canlı WCAG kontrast oranı ve uyarı görünümü.
- Gerçek istasyon verisi için EPDK/operatör kaynakları, kullanım şartları, güncelleme ritmi ve fiyat lisansı.
- Üretim haritası sağlayıcısı, OSM tile politikası uyumlu altyapı ve routing SDK'sı.
- Araç katalog servisi ve çoklu araç yönetimi.
- Android cihaz/tablet görünümü ve macOS/Xcode iOS Simulator build'i.

## Resmî kaynaklar

- [Android Developers - KMP DataStore kurulumu](https://developer.android.com/kotlin/multiplatform/datastore)
- [OpenStreetMap Foundation - tile kullanım politikası](https://operations.osmfoundation.org/policies/tiles/)
