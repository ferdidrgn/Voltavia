# 03 — Araç profili ve yol planı

**Durum:** Ürün mantığı tanımlandı; araç katalog/veri kaynağı ve rota SDK'sı seçilmedi.

### Uygulanan mantık

- Araç profiline tüketim (Wh/km) ve kullanıcı rezerv yüzdesi eklendi.
- Tahmini kullanılabilir menzil yalnızca araç profili girdilerinden hesaplanıyor ve varsayımları UI'da açıklanıyor.
- Kullanıcı yol mesafesini girerse enerji ihtiyacı ve varış bataryası hesaplanıyor; rezerv tutmuyorsa açık uyarı gösteriliyor.
- Rota istasyonu sıralayıcı uyumsuz konnektörü ve ulaşılabilir menzil dışında kalan adayı eliyor; kalanları bilinen durum, sapma ve güç ile sıralıyor.
- Yol geometri/mesafesi için routing sağlayıcısı gerekli; demo adayı gerçek istasyon veya rota tavsiyesi değildir.

## İşler

- [ ] Marka/model/yıl/batarya kapasitesi/azami AC-DC güç/konnektör katalog modeli.
- [ ] Kullanıcı araç profili ekle, düzenle ve birden fazla araç arasında seç.
- [x] Mevcut batarya yüzdesi ve hedef şarj rezervini kullanıcıdan al.
- [x] Tüketim varsayımını kullanıcıya düzenlenebilir gir ve menzil tahmini uyarısını göster.
- [ ] Rota üstü şarj duraklarını uyum, mesafe, fiyat, güç ve durum güveniyle sırala.
- [ ] Ulaşılabilirlik ve varış rezervi hesabı; tahmin aralığını ve belirsizliği göster.
- [ ] Kullanıcı rota durağını ekle/sil/yeniden sırala; harici navigasyona aktar.
- [ ] Düşük menzil, kapalı/bozuk istasyon ve eski durum için alternatif durak öner.
- [ ] Şarj süresi ve toplam rota ETA tahmini için araç/operatör telemetri sınırlarını belirle.

## Tamamlanma ölçütleri

- Rota yalnızca konnektör olarak uyumlu istasyonları aday yapar.
- Kaynağı olmayan hız/menzil tahmini kesin süre gibi gösterilmez.
- Canlı olmayan istasyon “kesin müsait” olarak işaretlenmez; yedek durak sunulur.

