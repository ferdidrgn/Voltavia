# ⚡ Voltavia

Türkiye'deki elektrikli araç şarj istasyonlarını tek uygulamada toplayan platform.
Kullanıcı istasyonu bulur, filtreler, navigasyona geçer; anlaşmalı operatörlerde
ayrı bir uygulama indirmeden doğrudan Voltavia üzerinden şarj başlatıp operatörün
kendi ödeme altyapısı üzerinden ödeme yapar.

Detaylı ürün/teknik yol haritası için **[ROADMAP.md](./ROADMAP.md)** dosyasına bakın.

## Proje Yapısı

```
Voltavia/
├── lib/                    # Flutter mobil uygulaması (iOS + Android)
│   ├── core/                theme, state, routing, utils
│   ├── data/                modeller + mock veri katmanı
│   ├── features/            her ekran kendi klasöründe
│   └── widgets/              paylaşılan UI bileşenleri
├── admin-panel/             Admin paneli (HTML + CSS + Vanilla JS)
├── company-panel/           Firma/operatör paneli (HTML + CSS + Vanilla JS)
├── backend/                  Cloudflare Workers API iskeleti
└── ROADMAP.md                fazlara bölünmüş yol haritası
```

## Mobil Uygulama (Flutter)

### Tasarım Sistemi

- **Marka rengi:** Voltaic Indigo `#4C5FFF` + Volt Lime `#C6FF6B` vurgu
- **Açık/koyu tema:** `lib/core/theme` — `AppTheme.light` / `AppTheme.dark`
- **Bottom navigation:** Harita · İstasyonlar · Favoriler · Profil
- Harici tasarım paketi (Figma vb.) kullanılmadı; tüm ekranlar doğrudan kod
  üzerinden, çalışan bir Flutter widget ağacı olarak tasarlandı.

### Ekranlar

| Akış | Ekranlar |
|---|---|
| Onboarding | Splash → Onboarding (3 sayfa) → Giriş / Kayıt |
| Keşif | Harita (mock pin'ler + şehir filtresi) · İstasyon Listesi · Şehir/İlçe Filtresi · İstasyon Detayı |
| Şarj | Konnektör Seçimi → Ödeme Yöntemi → Aktif Şarj (canlı sayaç) → Oturum Özeti |
| Hesap | Favoriler · Şarj Geçmişi · Bildirimler · Profil · Profil Düzenleme |

### Çalıştırma

```bash
flutter pub get
flutter run
```

> Not: Bu ekranlar mock veriyle (`lib/data/mock`) çalışır; gerçek Firestore/backend
> bağlantısı ROADMAP.md § 2.2 ve § 2.6'da tanımlanmıştır.

## Admin & Firma Panelleri

Statik HTML/CSS/JS — bkz. `admin-panel/README.md` ve `company-panel/README.md`.

## Backend

Cloudflare Workers iskeleti — bkz. `backend/README.md`.

---

_Flutter starter şablonundan üretilmiştir._
