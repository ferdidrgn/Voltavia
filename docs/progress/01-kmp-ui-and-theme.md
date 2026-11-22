# 01 — KMP kabuğu ve tema sistemi

**Durum:** UI iskeleti hazır; build ve cihaz doğrulaması ortam erişimini bekliyor.

## İşler

- [x] KMP Android/iOS ortak kaynak setini kur.
- [x] Material 3 kullanan ortak başlangıç ekranı ve bottom navigation oluştur.
- [x] Harita/istasyon/yol planı/profil ekranları arasında temel gezinmeyi ekle.
- [x] Yeşil, koyu gül/pembe, koyu mor, amber, açık cam, gül cam ve mor cam hazır paletleri ekle.
- [x] Koyu/açık görünümü palet renginden bağımsız seç.
- [x] Özel vurgu rengini HEX ile gir; geçersiz/eksik girişte hazır palet korunur.
- [x] Android ve iOS için DataStore Preferences katmanı ekle; tema, vurgu, araç ve favorileri sakla.
- [x] Ekran okuyucu için tema renklerini etiketle; Material bileşenlerinin erişilebilir dokunma hedeflerini kullan.
- [x] Harita/list/detail/rota/profil ekranlarını ayrı commonMain feature kaynak dosyalarına ayır.
- [x] İstasyon örneğini mock olarak açıkça etiketle; doğrulanmamış fiyat/doluluk göstermesin.
- [ ] Serbest vurgu rengi için WCAG kontrast oranını hesapla ve canlı önizlemede göster.
- [x] Tema, araç ve favori tercihlerini DataStore ile kalıcılaştır. **Build doğrulaması bekliyor.**
- [ ] Feature'ları ayrı Gradle modüllerine böl. **Şimdilik ayrı commonMain dosyaları; modül sınırı sonraki refactor.**
- [ ] Bileşen durumları: loading, empty, stale, offline, error, permission denied.
- [ ] Erişilebilirlik: 48dp hedef, büyük metin, ekran okuyucu açıklaması ve kontrast.
- [ ] Android Studio'da debug build ve telefon/tablet ekran doğrulaması.
- [ ] iOS host uygulaması ve Simulator doğrulaması (macOS/Xcode gerekir).

## Tamamlanma ölçütleri

- Kullanıcı 7 tema paletinden seçim yapar, açık/koyu ve renk seçimini ayrı yönetir.
- Ekranlar küçük ve büyük pencerede düzenini korur; interaktif kontroller minimum 48dp olur.
- Görsel mock alanlar canlı veri gibi görünmez.
- Android build ve seçilen iOS host build'i başarıyla alınır.

