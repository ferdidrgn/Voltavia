# Voltavia KMP — Progress ve İş Planı

> Ürün araştırma ve ilk KMP prototip işi için izleme dosyası. Durumlar tamamlandıkça güncellenir.

## Durum

- [x] İlk 10 KMP arayüz/ürün işi teslim edildi; [iş dökümü](05-batch-10-core-features.md).

- [x] Mevcut Voltavia ürün belgeleri ve Flutter/Android host yapısı okundu.
- [x] Benzer ürünlerin kamuya açık özellikleri karşılaştırıldı.
- [x] REA ile yerel Voltavia APK envanteri çıkarıldı; Flutter runtime ailesi doğrulandı.
- [x] Rakip APK erişim sınırı ve REA kapsamı belgelendi.
- [x] KMP başlangıç uygulaması ve tema değiştirilebilir Material 3 UI iskeleti oluşturuldu.
- [x] KMP Gradle wrapper eklendi.
- [x] DataStore Preferences ile tema, vurgu, favori ve araç ayarları Android/iOS KMP katmanında saklanacak biçimde bağlandı.
- [x] Araç tüketim/rezerv hesabı ve kullanıcı mesafesiyle enerji tahmini eklendi.
- [x] İstasyon alanı için kaynak, güncelleme zamanı ve güven seviyesi modeli eklendi.
- [ ] Android build ve cihaz üzerinde görünüm/akış doğrulaması. **Bloke:** `services.gradle.org` DNS erişimi yok; bağlı ADB cihazı da bulunmadı.
- [ ] EVMap ve diğer rakip APK'larını REA ile analiz et. **Bloke:** F-Droid'in 137 MiB EVMap APK indirme bağlantısı browser ortamında `ERR_BLOCKED_BY_CLIENT`; binary çalışma alanına ulaşmadı.
- [ ] iOS host build'i macOS/Xcode ortamında doğrulama.
- [ ] Harita sağlayıcısı, şarj verisi kaynağı, fiyat lisansı ve operatör API anlaşmaları kararı.

## Uygulama işleri

Detaylı iş akışları:

- [01 · KMP kabuğu ve tema sistemi](01-kmp-ui-and-theme.md)
- [02 · İstasyon kataloğu ve veri güveni](02-station-data-and-discovery.md)
- [03 · Araç profili ve yol planı](03-vehicle-and-route.md)
- [04 · Operatör entegrasyonu ve şarj](04-operator-charging-integration.md)

- [06 - Kalici ayarlar, arac hesabi ve veri guveni](06-settings-vehicle-route-and-data-trust.md)
- [07 - Istasyon kesfi devam isleri](07-station-discovery-follow-up.md)

### A. KMP kabuğu ve tasarım sistemi

- [x] `commonMain` içinde Material 3 tema ve renk şemaları; tipografi/boşluk/şekil tokenlarının tamamı ayrı tasarım tokenı olarak henüz çıkarılmadı.
- [x] Tema seçimi: açık/koyu + yeşil, gül/pembe, mor, amber vurgu; isteğe bağlı glass yüzey görünümü.
- [x] Serbest vurgu rengi HEX seçici eklendi; kontrast oranı göstergesi henüz açık.
- [x] Tema, favori ve araç tercihlerini KMP DataStore ile kalıcı sakla.
- [ ] Büyük metin, kontrast, TalkBack/VoiceOver ve 48dp dokunma hedefleri.
- [ ] Android Activity ve iOS Compose host girişleri.

### B. MVP kullanıcı modülleri

- [ ] Ana sayfa: yakın istasyon özeti, arama, hızlı filtreler, görünür veri güncelliği.
- [ ] Harita/liste: istasyon kartları, ağ, güç, konnektör, tahmini fiyat, durum kaynağı.
- [ ] İstasyon detayı: adres, çalışma saatleri, olanak, soketler, erişim/ödeme biçimi, navigasyon.
- [x] Araç profili: marka/model, konnektör uyumu, tüketim tahmini ve menzil rezervi.
- [x] Yol planı: başlangıç/hedef/araç/batarya bilgisi ve mesafe bazlı enerji tahmini; gerçek rota durakları routing verisi bekliyor.
- [ ] Favori, geçmiş, bildirim ayarları ve profil.
- [ ] Şarj başlatma için uyumlu operatör/soket capability kontrolü ve açık fallback.

### C. Veri ve entegrasyon

- [ ] Lisans/şartları doğrulanmış EPDK ve operatör istasyon verisi envanteri.
- [x] Alan bazında `source`, `updatedAt`, `confidence`, `liveState` modeli.
- [ ] Çevrimdışı istasyon paketi, sürüm kontrolü ve eski veri uyarısı.
- [ ] Operatör capability matrisi: istasyon görüntüleme, canlı durum, fiyat, rezervasyon, başlat/durdur, ödeme.
- [ ] OCPI veya operatör özel API sözleşme/kimlik doğrulama ve secret yönetimi.
- [ ] Şarj oturumu makbuzu, hata/toparlanma ve idempotent başlat/durdur.

### D. Doğrulama ve teslim

- [ ] Android debug build'i derle.
- [ ] Android küçük telefon, büyük telefon ve tablet/landscape UI kontrolü.
- [ ] iOS Simulator build (Mac/Xcode gerektirir).
- [ ] Erişilebilirlik, çevrimdışı, boş, yükleniyor, hata ve eski veri durumları.
- [ ] Test istasyonlarından uygulama içi şarj iddiası/yanlış fiyat üretilmediğini doğrula.

## Öncelik sırası / karar kapıları

1. **P0 — Uygulama kabuğu:** KMP yapılandırması, ortak Material 3 UI, tema sistemi, etkileşimli mock ekranları.
2. **P1 — İstasyon keşfi:** veri kaynağı/lisans netleşince model ve offline katalog.
3. **P2 — Yol/araç deneyimi:** sürücü araç uyumu ve menzil rezerviyle rota adayları.
4. **P3 — Şarj ortaklıkları:** operatör bazında gerçek capability ve sözleşmeli bağlantı.
5. **P4 — Ölçek ve gelir:** analitik, filo, B2B lisans/panel ve destek akışları.

## Sınırlar ve varsayımlar

- Mevcut Flutter kodu taşınmıyor; KMP prototipi `kmp/` altında izole.
- Şu anki veriler UI prototipi için mock olabilir; hiçbir mock alan gerçek canlı veri olarak etiketlenmez.
- Rakip APK'lar mevcut değil; yalnızca public store/product descriptions incelendi.
- Açık kaynak repo incelemesi README/repository görünümüne dayalıdır. Çalışma kopyası indirme ve REA analizi henüz yapılmadı.
- Şarj başlatma/ödeme için operatör API erişimi ve sözleşmesi olmadan production logic yazılmaz.

