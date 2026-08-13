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
- **3 tema modu** (Profil → Görünüm): **Sistem** (cihazın açık/koyu ayarını takip
  eder), **Açık** (kendi light temamız) ve **Koyu** (kendi dark temamız) —
  `lib/core/theme` içinde `AppTheme.light` / `AppTheme.dark` olarak tanımlı,
  `lib/core/state/theme_controller.dart` ile yönetilir.
- **Bottom navigation (5 sekme):** Ana Sayfa · Harita · İstasyonlar · Favoriler · Profil
- Harici tasarım paketi (Figma vb.) kullanılmadı; tüm ekranlar doğrudan kod
  üzerinden, çalışan bir Flutter widget ağacı olarak tasarlandı.

### Ana Sayfa (Dashboard)

Uygulamanın kalbi. Karşılama + bildirim zili, kampanya/duyuru slider'ı, sık
kullanılan ekranlara tek dokunuşluk kısayollar (hızlı erişim grid'i), "Sana En
Yakın Noktalar" haritaya-git kartı + yakın istasyon önizlemeleri, anlaşmalı
**Firmalar** (ilk 10 + Tümünü Gör) ve son bildirimlerin özeti tek ekranda
bir araya gelir. Bkz. `lib/features/home/home_dashboard_screen.dart`.

### Ekranlar

| Akış | Ekranlar |
|---|---|
| Onboarding | Splash → Onboarding (3 sayfa) → Giriş (Test Girişi kısayolu ile) / Kayıt |
| Ana Sayfa | Karşılama, kampanya slider, hızlı erişim, yakın istasyonlar, firmalar, bildirim özeti |
| Keşif | Harita (mock pin'ler + şehir filtresi) · İstasyon Listesi · Şehir/İlçe Filtresi · İstasyon Detayı |
| Firmalar | Firma listesi (arama) · Firma Detayı (o firmaya ait istasyonlar) |
| Şarj | Konnektör Seçimi → Ödeme Yöntemi → Aktif Şarj (canlı sayaç) → Oturum Özeti |
| Hesap | Favoriler · Şarj Geçmişi · Bildirimler · Profil · Profil Düzenleme |

### Çalıştırma

```bash
flutter pub get
flutter run
```

Giriş ekranındaki **Test Girişi** banner'ına dokunarak kimlik doğrulama
olmadan doğrudan uygulamaya girebilirsin.

> Not: Bu ekranlar mock veriyle (`lib/data/mock`) çalışır; gerçek Firestore/backend
> bağlantısı ROADMAP.md § 2.2 ve § 2.6'da tanımlanmıştır.

## Admin & Firma Panelleri

Statik HTML/CSS/JS — bkz. `admin-panel/README.md` ve `company-panel/README.md`.

## Backend

Cloudflare Workers iskeleti — bkz. `backend/README.md`.

---

_Flutter starter şablonundan üretilmiştir._
