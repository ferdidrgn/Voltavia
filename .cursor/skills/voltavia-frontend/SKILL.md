---
name: voltavia-frontend
description: Voltavia Flutter web ve masaüstü arayüzü için Liman Akımı görsel dili. Yeni ekran, kart veya sayfa çizerken kullan. creative-design/frontend-design skill'inin bu ürüne uyarlanmış hali.
---

# Voltavia frontend

Ürün, Türkiye'de elektrikli araç şarj istasyonu bulup şarj başlatan bir uygulamadır. Görsel dil gece otoyolu, feribot iskelesi ve fiziksel şarj soketinden gelir. Mor gradyan, eşit bento ızgarası ve her kartta fade-slide yasaktır.

## Tokenlar

- Gece `#07141C`, liman `#102833`, gelgit `#173444`
- Sis `#E4EEF2`, porselen `#F7FBFC`, mürekkep `#0C1C24`
- Sodyum `#E7A317` (imza), deniz `#127A86` (eylem), cam yeşili `#7DCEC4`, bakır `#C46A3A`
- Yazı: gömülü Plus Jakarta Sans. Başlıklar sıkı aralıklı, gövde 14.5 / 1.5. Satır 80 karakteri geçmesin.
- Sodyum dolgu üzerinde yazı mürekkep rengidir. Deniz dolgu üzerinde yazı beyazdır.

## Düzen

- Hizalama soldur. Web'de içerik `Responsive.maxContentWidth` içinde kalır.
- İlk bakışta soket veya kablo durur. Büyük sayı + küçük etiket kahraman değildir.
- Köşe yarıçapı hiyerarşiye göre değişir: sahne 28, liste 16, durum hapı yalnızca durum için.
- Bilet/fiş metaforu yalnızca şarj oturumu ve özette kullanılır.

## Hareket

- Ortak hareket, `HarborAtmosphere` içindeki tek kablo kıvılcımıdır.
- `MediaQuery.disableAnimations` açıksa kıvılcım durur, `PlugMark` nabız atmaz.
- Geçişler Android'de FadeForwards, iOS'ta Cupertino'dur.
- Her bölüme ayrı fade-slide ekleme.

## Yazı

Cümle düzeni. Tam büyük harf etiket yok. Düğme, yaptığı işi söyler: "Haritada aç", "Şarjı başlat".
