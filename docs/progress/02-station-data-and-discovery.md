# 02 — İstasyon kataloğu ve veri güveni

**Durum:** Tasarım/karar aşaması. Kamuya açık rakip özellikleri incelendi; veri kaynağı/lisans/API kararı yok.

### Uygulanan veri güveni kuralları

- `StationFact<T>` alan kaynağı, güncelleme zamanı ve güven seviyesini birlikte taşır.
- Canlılık değerlendirmesi eski zaman damgasını `Stale`, gelecek/boş zaman damgasını `Unknown` sayar.
- Harita sağlayıcısı henüz seçilmedi. OSM verisi kullanılabilir olsa da üretimde kamuya açık `tile.openstreetmap.org` sunucusunu varsayılan karo servisi yapmak yerine lisans/kapasitesi belli sağlayıcı veya kendi karo servisi seçilecek.
- Resmî güncel KMP DataStore ve OSM karo ilkeleri kontrol edildi: [KMP DataStore](https://developer.android.com/kotlin/multiplatform/datastore), [OSM tile policy](https://operations.osmfoundation.org/policies/tiles/).

## İşler

- [ ] EPDK Şarj@TR ve operatörler için erişim, kullanım şartı ve güncelleme ritmini doğrula.
- [ ] Lisanslı ağ/istasyon/soket/konnektör alanları için ortak domain modeli.
- [x] Alan seviyesinde kaynağı, güncelleme zamanını, güven düzeyini ve canlılık durumunu sakla.
- [ ] Operatör, şehir/ilçe, soket, güç, fiyat, olanak ve araç uyumu filtreleri.
- [ ] Harita/list/grid durumlarını responsive şekilde sun.
- [ ] İstasyon detayında bağlantı tipi, ücret kuralı, erişim ve ödeme biçimi göster.
- [ ] Fiyat/soket/doluluk anlaşmazlığı için doğrulanmamış veri kuralları.
- [ ] Çevrimdışı yerel paket, diff güncelleme ve maksimum yaş bilgisi.
- [ ] Harita SDK'sı, OSM/MapLibre/Google seçimi ve fiyat/kota değerlendirmesi.
- [ ] İstasyon önerme/düzeltme topluluk akışı ve moderasyon ihtiyacı.

## Tamamlanma ölçütleri

- Her istasyonun kaynağı ve son güncellenme zamanı denetlenebilir.
- Filtreler aracı/soketi uyumsuz noktaları varsayılan olarak gizleyebilir.
- Offline durumda eski veri işaretlenir; canlı uygunluk ve şarj başlatma devre dışıdır.

