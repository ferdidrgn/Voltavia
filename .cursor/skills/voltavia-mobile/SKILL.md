---
name: voltavia-mobile
description: Voltavia Flutter iOS ve Android arayüzü için dokunma, başparmak alanı ve performans kuralları. creative-design/mobile-design skill'inin bu projeye uyarlanmış hali. Yeni ekran veya gezinme yazarken kullan.
---

# Voltavia mobil

Platform: iOS ve Android, tek Flutter kodu, web aynı kabuğu paylaşır.
Gezinme: telefonda alt sekme, 1024px ve üstünde sol ray.
Durum: mevcut `AppState` / `ThemeController`. Yeni global durum ekleme.
Çevrimdışı: veri şimdilik mock; liste ve durumlar ağ yokmuş gibi de çalışır.

## Dokunma

- Hedef en az 48dp. Komşu hedefler arasında en az 8dp.
- Birincil eylem ekranın alt üçte birinde, başparmak yayında.
- Yok etme eylemleri (şarjı durdur) birincil düğmeden ayrı ve daha az ulaşılır olsun.
- Yalnızca jest yok; her işin düğmesi var.
- Hover masaüstüne aittir. Telefonda basış, mürekkep veya ölçek ile cevap verir.

## Performans

- Uzun listeler `ListView.builder` / `GridView.builder`. Tüm listeyi bir Column'a yayma.
- `const` kurucular. Sık değişen sayaçlar tüm sayfayı değil ilgili yapıyı yeniler.
- Animasyon transform ve opacity ile kalır. Genişlik, yükseklik, margin animate edilmez.
- Ekran boyu bulanıklık yalnızca yüzen gezinme ve rayda. Kartlarda `BackdropFilter` yok.
- `AnimationController` dispose edilir. Azaltılmış hareket açıksa tekrarlayan animasyon başlamaz.

## Durumlar

- Yüklemede mevcut `Skeleton`.
- Boş ekran bir sonraki eylemi söyler.
- Hata, ne olduğunu ve nasıl deneneceğini söyler. Özür cümlesi yok.

## Platform

- iOS geri: kenar kaydırma (Cupertino geçişi).
- Android geri: sistem geri tuşu.
- Alt sekme etiketi her zaman görünür. Seçili sekme sodyum çizgi ile belli olur, dolu gradyan hap ile değil.
