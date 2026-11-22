# Voltavia — Rakip, Ürün ve Teknik Analiz

**Araştırma tarihi:** 22 Kasım 2026  
**Kapsam:** Türkiye EV şarj istasyonu bulucu/roaming deneyimi; Compose Multiplatform ve Material 3 yönü.

## Ürün kararı

Voltavia; Türkiye'deki farklı operatörlerin istasyonlarını tek noktada keşfetme, kullanıcının aracına ve ihtiyacına uyan noktayı seçme, yolculuğa göre şarj durağı planlama ve entegrasyon bulunan ağlarda şarjı başlatma deneyimi sunar. İlk sürümde canlı doluluk, fiyat veya şarj başlatma kabiliyeti olmayan istasyonlarda bu durum açıkça gösterilir; mock veri gerçek veri gibi sunulmaz.

## Rakip araştırması

| Ürün | Gözlenen ürün güçlü yanları | Voltavia için çıkarım |
|---|---|---|
| [PlugShare](https://company.plugshare.com/plugshare.html) | Çok ülkeli ağ haritası, araç uyumlu filtreler, yorum/fotoğraf, PlugScore, navigasyon ve rota planı; katılımcı konumlarda uygulama içi ödeme | İstasyonun yalnızca varlığı değil, güvenilirliği ve kullanıcıya sağladığı bağlam gösterilmeli. |
| [Chargemap](https://play.google.com/store/apps/details?id=com.chargemap_beta.android) | Avrupa çapında kapsam, soket/güç/erişim/fiyat bilgisi, topluluk yorumları, araç profiline göre filtre, rota planı, RFID geçiş kartı ve desteklenen noktada uygulamadan şarj | Araca göre uyum ve rota üzerindeki hızlı şarj noktaları birincil karar girdileri olmalı. |
| [Electromaps](https://play.google.com/store/apps/details?id=com.enredats.electromaps) | Nokta/rota araması, konnektör ve güç filtresi, bağlı noktada canlı durum, topluluk içeriği, uyumlu ağda ödeme ve RFID; uyumsuz yerde hangi uygulamaya geçileceğini söyleme | Ağ entegrasyonu yoksa kullanıcıyı doğru operatör uygulamasına yönlendir; entegrasyon kapsamını istasyon seviyesinde belirt. |
| [ŞarjBul](https://play.google.com/store/apps/details?id=com.sarjbul.sarjbul) | Türkiye genelinde çok sayıda operatörü tek haritada toplama, EPDK verisi, desteklenen ağlarda canlı durum ve manuel doğrulanan fiyat iddiası | Yerel pazarın tek-harita ihtiyacı zaten karşılanıyor. Farkı veri tazeliği, kaynak/son güncelleme şeffaflığı, fiyat kıyaslama ve rota güveni oluşturmalı. |
| [Charz](https://play.google.com/store/apps/details?id=tr.com.charz) | Çok sayıda operatör, canlı harita/doluluk, rota planı ve fiyat karşılaştırma vaadi | Temel özellik listesi tek başına farklılaştırıcı değil. Verinin güven düzeyi ve bir sonraki doğru eylem açık olmalı. |
| [Şarj@TR / EPDK](https://sarjtr.epdk.gov.tr/) | Düzenleyici kurumun açık erişim platformu; kamuya açık açıklamalara göre lisanslı istasyon bilgisi ve durum/fiyat verisi için birincil kaynak | Lisanslı ağ ve istasyon envanterinde mümkün oldukça birincil/resmî veri tercih edilmeli; veri lisansı, API erişimi ve güncelleme koşulları ayrıca doğrulanmalı. |

### Pazar boşluğu / konumlandırma

Tek bir uygulamada ağları toplamak artık benzersiz bir öneri değildir. Voltavia'nın yönü şu dört niteliği birlikte sunmak olmalı:

1. **Karar desteği:** araç/soket uyumu, güç, fiyat, uygunluk, açık/kapalı durumu, olanak ve mesafeyi karşılaştırılabilir biçimde sun.
2. **Veri güveni:** her alanın kaynağını, son güncelleme zamanını ve canlı/mock/bilinmiyor durumunu ayır.
3. **Yolculuk bütünlüğü:** menzil ve hedefe varış rezerviyle rota üstünde şarj durağı öner; ağ entegrasyonu yoksa operatör uygulamasına güvenli geçiş sağla.
4. **Gerçek şarj akışı:** önce operatör sözleşmesi/API yetkisi; ardından OCPI/özel API üzerinden başlat/durdur, ücret ve makbuz. Yetki olmadan ödeme/şarj başlatma taklidi yapma.

## Açık kaynak proje incelemesi

Bu iki GitHub projesi kaynak/repository README düzeyinde incelendi; çalışma kopyası edinilip REA ile analiz edilmedi.

| Proje | Kamuya açık teknoloji/yapı | Alınan ders |
|---|---|---|
| [EVMap](https://github.com/ev-map/EVMap) | MIT lisanslı Android uygulaması; GoingElectric/Open Charge Map kaynakları, gelişmiş ve kaydedilebilir filtreler, favoriler, Google Maps/OSM backend seçenekleri, Android Auto ve Android Automotive varyantları. Repo README farklı FOSS/Google ve phone/automotive flavor'larını anlatıyor. | Kaynak sağlayıcılarını ve harita backend'ini adapter/feature flag arkasında tut. Araç içi deneyim telefon UI'sinden ayrı akış ve dağıtım hedefi olarak planlanmalı. |
| [EvoCharge-App](https://github.com/Aditya-gupta99/EvoCharge-App) | README; Kotlin Android uygulaması, Spring Boot backend, Google Maps, Ktor, Hilt, StateFlow/MVVM; harita/liste, yakın nokta önerisi, rezervasyon/ödeme ve profil akışları iddia ediyor. Repo örneği tek Android app olarak sunulmuş, KMP değil. | Ağ çağrısı ve ekran state'ini presentation'dan ayırmak için Ktor + StateFlow benzeri katmanları değerlendirebiliriz; rezervasyon/ödeme yalnız gerçek backend capability olduğunda açılmalı. |

Bu depolar, ürün içeriği ve yapı desenleri için referanstır; doğrudan kod/asset kopyalama veya güvenlik incelemesi yapılmamıştır. KMP hedefi için resmi Compose Multiplatform dokümantasyonu ayrıca esas alınır.

### EVMap APK erişim denemesi

F-Droid'in resmî ürün/sürüm sayfası EVMap `2.1.4 (280)` sürümünü 26 Ağustos 2026 tarihinde listeliyor; Android 6+, arm64/armeabi/x86/x86_64 ve F-Droid imzalı paket bildiriyor. APK sayfasındaki izin listesi foreground yaklaşık/kesin konum, ağ durumu ve erişimi, foreground location service, bildirim, boot completed ve wake lock içeriyor; ayrıca Android Auto/Automotive surface/template izinleri gösteriliyor. F-Droid sayfası Mapbox server bağımlılığını anti-feature olarak not ediyor. Bu, provider/permission ve otomotiv hedefleri için okunmuş mağaza metadatasıdır; APK binary analizi değildir. 137 MiB APK indirme bağlantısı bu browser ortamında `ERR_BLOCKED_BY_CLIENT` ile engellendi, dolayısıyla dosya alınmadı ve REA'ya verilemedi.

## Temel kullanıcı akışları

### İstasyondan şarja

`Konum/arama → araç uyumlu filtre → istasyon kartı → veri ve fiyat güveni → konnektör → operatör/uygulama içi başlatma → aktif oturum → özet/makbuz`

Şarj başlat düğmesi sadece operatör, istasyon ve soket için doğrulanmış entegrasyon varsa aktif olur. Aksi halde “Operatör uygulamasında aç” veya “Navigasyona git” sunulur.

### Yol planı

`Başlangıç/hedef + araç + mevcut batarya → menzil/rezerv ayarı → rota üzerindeki uyumlu noktalar → fiyat/süre/doluluk belirsizliğini dahil et → durak seç → harici navigasyon`

İlk dilimde rota optimizasyonu mock/plan olarak kalır. Gerçek ETA, batarya tahmini ve canlı trafik entegrasyonu daha sonraki iş kalemidir.

### Güvenli hata durumları

- Konum izni yok: şehir/ilçe aramasıyla devam et.
- Ağ yok: en son yerel istasyon paketini ve güncellik zamanını göster; şarj başlatmayı kapat.
- Durum/fiyat eski veya bilinmiyor: değeri tahmin edip kesinmiş gibi yazma; kaynak ve zamanla işaretle.
- İstasyon/operatör çelişkili veri gönderiyor: iki tarafı birleştirip yanıltıcı bir değer üretme; alanı doğrulanmamış işaretle.
- API erişimi yok: istasyon detayında operatör uygulamasına/navigasyona geçiş sun.

## KMP ve UI kararı

- Mevcut depo `lib/` Flutter uygulaması içeriyor. Bu talep KMP hedefini belirttiği için yeni `kmp/` Compose Multiplatform uygulama iskeleti ayrı tutulur; mevcut Flutter kaynaklarına müdahale etmez.
- Ortak iş mantığı ve UI `commonMain` içinde, Android giriş noktası `androidMain`, iOS host bağlantısı `iosMain` içinde yer alır.
- Android/iOS ortak UI için Compose Multiplatform + Material 3; istasyon, rota, araç, profil ve ayarlar birbirinden ayrılabilir feature modüllerine taşınabilir.
- Tema sistemi cinsiyete kilitli değildir. Kullanıcı açık/koyu görünüm ve vurgu rengi seçebilir: deniz yeşili, gül/pembe, mor/menekşe, amber ve açık cam yüzey. Koyu pembe, koyu mor, deniz yeşili, amber ve açık cam kombinasyonları hazır paletler olarak verilebilir; ilerleyen aşamada renk seçici, vurgu tonu ve yüzey saydamlığı kullanıcı tercihine açılır.
- Glassmorphism yardımcı yüzeylerde kullanılır; harita, fiyat, müsaitlik, başlat/durdur ve form kontrollerinde kontrast, okunabilirlik ve dokunma hedefi önceliklidir.
- Önerilen alan ayrımı: `core/designsystem`, `core/model`, `core/network`, `core/database`, `core/location`, `feature/home`, `feature/stations`, `feature/route`, `feature/charging`, `feature/vehicle`, `feature/profile`.

Compose Multiplatform, Android/iOS arasında UI ve kod paylaşımı sağlar; resmi dokümantasyon M3 bileşenlerini ve Android/iOS için kararlı platform durumunu açıklıyor. KMP projesi gerçek iOS derlemesi için macOS/Xcode gerektirir.

## REA ile yerel APK incelemesi

REA statik olarak depodaki `build/app/outputs/flutter-apk/app-debug.apk` dosyasını inceledi.

| Gözlem | Sonuç |
|---|---|
| SHA-256 | `069852e6b95a3e37a67a2ff54f996275771b8f76fff567af67e3c58b0f4cce69` |
| ZIP grafiği | 113 düğüm, 146 occurrence, 145 contains kenarı; kapsama envanter sınırında tam |
| Bileşenler | AndroidManifest, `classes.dex`–`classes5.dex`, `lib/x86_64/libflutter.so`, resources.arsc |
| Runtime ailesi | Flutter + Dalvik ART + native; APK mevcut Flutter projesiyle uyumlu |
| Kesin limit | REA grafiği DEX semantiğini çözmedi; JNI bağlantıları yalnızca yol temelli hipotez. APK çalıştırılmadı. Android bağlı cihaz listesi boştu. İmza bloğu ZIP merkezi dizin envanterinde görünmediğinden imza hakkında sonuç çıkarılamaz. |

### Benzer ürün APK sınırı

Bu çalışma oturumunda REA'ya girdi olarak yalnızca yerel Voltavia debug APK'sı sağlandı ve statik envanter/project projection yapıldı. Rakip APK'lardan yalnızca EVMap'in resmî F-Droid binary indirme sayfasına kadar erişildi; APK indirme engellendi. PlugShare, Chargemap, Electromaps, ŞarjBul ve Charz için binary elde edilmedi. Bu nedenle rakip özellik karşılaştırması yayımlanmış ürün açıklamalarına dayanır; rakip APK tersine mühendislik sonucu değildir. Mağaza açıklamalarındaki özellik iddiaları geliştirici tarafından doğrulanmalıdır. APK'lar yerel olarak edinilebilir olduğunda REA manifest/envanter, imza, izin ve runtime-projection incelemesi yapılabilir.

## Kaynaklar

- PlugShare ürün sayfası: https://company.plugshare.com/plugshare.html
- Chargemap Google Play: https://play.google.com/store/apps/details?id=com.chargemap_beta.android
- Electromaps Google Play: https://play.google.com/store/apps/details?id=com.enredats.electromaps
- ŞarjBul Google Play: https://play.google.com/store/apps/details?id=com.sarjbul.sarjbul
- Charz Google Play: https://play.google.com/store/apps/details?id=tr.com.charz
- EVMap (MIT, Android): https://github.com/ev-map/EVMap
- EVMap F-Droid sürüm/izin sayfası: https://f-droid.org/packages/net.vonforst.evmap/
- EvoCharge-App (Kotlin Android sample): https://github.com/Aditya-gupta99/EvoCharge-App
- Compose Multiplatform giriş: https://kotlinlang.org/docs/multiplatform/compose-multiplatform.html
- Compose Multiplatform uyumluluk/sürüm: https://kotlinlang.org/docs/multiplatform/compose-compatibility-and-versioning.html
- Compose Material 3 releases: https://developer.android.com/jetpack/androidx/releases/compose-material3
- Android Developers KMP: https://developer.android.com/kotlin/multiplatform
- Android Developers KMP setup: https://developer.android.com/kotlin/multiplatform/setup

KMP build başlangıcında Compose Multiplatform `1.11.1`, Kotlin `2.3.20`, AGP `9.0.1` ve ortak kaynakta Material 3 `1.5.0` seçildi. Material 3 Compose Multiplatform sürümünden bağımsız sürümlendiği için doğrudan belirtilir; yükseltmeler resmi uyumluluk tablosuna göre kontrol edilmelidir.

