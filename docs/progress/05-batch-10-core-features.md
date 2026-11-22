# İlk 10 KMP işi — tamamlandı

**Kapsam:** Voltavia KMP prototipinde ilk ürün akışının modüler hale getirilmesi.  
**Tarih:** 22 Kasım 2026

1. [x] **Material 3 design system:** ortak `VoltaviaTheme` ve renk şeması/token tabanı.
2. [x] **Tema seçenekleri:** koyu yeşil, koyu pembe, koyu mor, koyu amber, açık cam, pembe cam, mor cam (7 hazır preset).
3. [x] **Glass yüzey bileşeni:** yarı saydam yüzey ve ince kontur; platformlar arasında eşit olmayan gerçek backdrop-blur iddiası yok.
4. [x] **Ana/harita ekranı:** şematik önizleme, kaynağı olmayan harita uyarısı ve örnek istasyon kartı.
5. [x] **İstasyon domain modeli ve katalog:** konnektör, güç, isteğe bağlı tarife, availability, kaynak/güncellik ve start capability.
6. [x] **Arama ve hızlı filtre:** istasyon adı/operatör/adres araması; güç, uygunluk ve favori filtresi; boş sonuç görünümü.
7. [x] **Favoriler:** liste ve detay ekranlarından ekle/çıkar, profil ekranında sayı özeti.
8. [x] **İstasyon detayı:** konnektör, güç, adres, kaynak, güncellik, bilinmeyen fiyat/durum ve şarj aksiyonu capability gate'i.
9. [x] **Araç profili:** araç adı, batarya kapasitesi, konnektör, mevcut batarya girişi ve ana state'e kayıt callback'i.
10. [x] **Yol planı ve beş sekme entegrasyonu:** başlangıç/hedef, batarya/rezerv girdileri ve yalnız demo durakları; harita, istasyon, yol, araç ve profil akışlarına bağlandı.

## Bu teslimattaki veri/işleyiş sınırları

- `DemoStations` içindeki dört kayıt sentetiktir; gerçek operatör, adres, fiyat ve uygunluk olarak kullanılmamalıdır.
- Fiyatlar null, availability `Unknown`, şarj başlatma yeteneği kapalıdır.
- Araç menzili ve route ETA hesaplanmıyor; rota girdisi yalnızca taslak callback'i üretir.
- Tema ve favori state'i uygulama oturumunda tutuluyor; kalıcı storage sonraki işler arasında.
- Android derlemesi bu ortamda Gradle dağıtım hostu DNS sorunu nedeniyle doğrulanamadı; Android cihaz yok. iOS build için macOS/Xcode gerekir.
- Rakip APK'ları REA'ya ulaşmadı; yalnızca yerel Voltavia APK'sı REA statik envanterinden geçti.

