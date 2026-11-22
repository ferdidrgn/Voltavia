# 07 - İstasyon keşfi devam işleri

**Durum:** 10 kullanılabilir filtre/list UX işi uygulandı. Gerçek veri ve harita bağlantısı bekliyor.

1. [x] Araç profili soketiyle uyumlu istasyonları filtrele.
2. [x] CCS2, Type 2, CHAdeMO ve GB/T soket filtresi ekle.
3. [x] Yakına göre sıralama ekle (şu an yalnızca örnek katalogdaki mesafe alanı).
4. [x] Güç değerine göre sıralama ekle.
5. [x] Filtre ve sıralama tercihini DataStore ile sakla.
6. [x] Soket karşılaştırmasını boşluk ve tire farklarından bağımsızlaştır.
7. [x] İstasyon detayında alan bazlı kaynak ve güven seviyesini göster.
8. [x] Örnek katalogda canlı istasyon/uygunluk kaynağının bağlı olmadığını görünür yap.
9. [x] Boş sonuçta aramayı, hızlı filtreyi ve soket filtresini temizleme aksiyonu ver.
10. [x] İstasyon kartlarını TalkBack için ad, güç, soket ve uygunluk açıklamasıyla etiketle.

## Açık kalanlar

- Operatör/şehir/fiyat/olanak filtreleri lisanslı veri modeli geldikten sonra eklenmeli.
- Sıralamadaki mesafe, gerçek cihaz konumu ve routing distance olmadan üretim mesafesi değildir.
- Bu ek değişiklikler için Gradle dağıtımı bulunmadığından derleme doğrulaması alınamadı.
