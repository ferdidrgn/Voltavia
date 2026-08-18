# ⚡ Voltavia

Türkiye'deki elektrikli araç şarj istasyonlarını tek uygulamada toplayan platform.
Kullanıcı istasyonu bulur, filtreler, navigasyona geçer; anlaşmalı operatörlerde
ayrı bir uygulama indirmeden doğrudan Voltavia üzerinden şarj başlatıp operatörün
kendi ödeme altyapısı üzerinden ödeme yapar. Aynı Flutter kod tabanı, adaptive
düzeniyle hem mobil (floating bottom nav) hem web/masaüstü (sabit sidebar +
bento-grid) ortamında çalışır.

Detaylı ürün/teknik yol haritası için **[ROADMAP.md](./ROADMAP.md)** dosyasına bakın.

## Proje Yapısı

```
Voltavia/
├── lib/                      # Flutter uygulaması (iOS + Android + Web + Masaüstü)
│   ├── core/                  theme (tasarım sistemi), state, utils
│   ├── data/                  modeller + mock veri katmanı
│   ├── features/              her ekran kendi klasöründe (admin/ dahil)
│   └── widgets/                paylaşılan bento/glass UI bileşenleri
├── admin-panel/               Statik HTML/JS admin paneli (önceki iterasyon)
├── company-panel/             Statik HTML/JS firma paneli (önceki iterasyon)
├── backend/                    Cloudflare Workers API iskeleti
└── ROADMAP.md                  fazlara bölünmüş yol haritası
```

> Not: `admin-panel/` ve `company-panel/` altındaki statik HTML/JS sürüm hâlâ
> depoda duruyor, fakat admin deneyimi artık `lib/features/admin/` altında
> tam bir Flutter uygulaması olarak yeniden inşa edildi (bkz. aşağı).

## Tasarım Sistemi

Linear/Vercel standardında, Slate/Zinc tabanlı derin bir SaaS estetiği:

- **Palet:** Koyu tema (bayrak taşıyan/flagship) — Canvas `#09090B`, Kart `#18181B`,
  Vurgulu yüzey `#27272A`, mikro kenarlıklar (`%8` beyaz alfa). Aksan: Elektrik
  İndigo `#6366F1` + Zümrüt Nane `#10B981`. Açık tema aynı dilin aydınlık
  karşılığıdır (Zinc-50 yüzeyler). Bkz. `lib/core/theme/app_palette.dart`,
  `app_semantic_colors.dart`.
- **3 tema modu** (Profil → Görünüm): **Sistem**, **Açık**, **Koyu** — segmented
  control ile seçilir, `lib/core/state/theme_controller.dart` yönetir.
- **Tipografi:** Google Fonts *Plus Jakarta Sans*, `AppTextStyles` ThemeExtension'ı
  üzerinden (`context.text.headline` vb.) — bkz. `app_text_styles.dart`.
- **Bento-grid mimarisi:** `BentoCard` (mikro kenarlıklı, cam yüzeyli, masaüstünde
  hover'da hafif yükselen kart) tüm dashboard bölümlerinin temel yapı taşı.
- **Adaptive kabuk:** `ResponsiveScaffold` — ≥1024px'de sabit `AppSidebar`,
  altında havada asılı buzlu-cam `FloatingBottomNav`. Hem tüketici uygulaması
  hem Admin Dashboard aynı bileşeni paylaşır.
- **Mikro etkileşimler:** `flutter_animate` ile kademeli `fadeIn`/`slideY`/`scale`
  giriş animasyonları (`lib/core/theme/app_motion.dart`), `gap` paketiyle
  boşluklar, `lucide_icons` (+ gerekli yerlerde Material ikonlar) modern ikon
  seti, `fl_chart` ile interaktif trend grafikleri.
- **Durumlar:** Yükleme için shimmer `Skeleton`, `EmptyState`, `ErrorState` —
  bkz. `lib/widgets/skeleton.dart`, `empty_state.dart`, `error_state.dart`.

## Tüketici Uygulaması

### Ana Sayfa (Dashboard)

Karşılama + bildirim zili, KPI özet kartları, kampanya/duyuru slider'ı, hızlı
erişim kısayolları, "Sana En Yakın Noktalar" haritaya-git kartı + yakın istasyon
önizlemeleri, anlaşmalı **Firmalar** şeridi (ilk 10 + Tümünü Gör) ve son
bildirim özeti tek ekranda. Bkz. `lib/features/home/home_dashboard_screen.dart`.

### Ekranlar

| Akış | Ekranlar |
|---|---|
| Onboarding | Splash → Onboarding (3 sayfa) → Giriş (Test Girişi kısayolu ile) / Kayıt |
| Ana Sayfa | Karşılama, KPI özet, kampanya slider, hızlı erişim, yakın istasyonlar, firmalar, bildirim özeti |
| Keşif | Harita (mock pin'ler + şehir filtresi) · İstasyon Listesi (mobilde liste, masaüstünde grid) · İstasyon Detayı |
| Firmalar | Firma listesi (arama, grid) · Firma Detayı (o firmaya ait istasyonlar) |
| Şarj | Konnektör Seçimi → Ödeme Yöntemi → Aktif Şarj (canlı sayaç) → Oturum Özeti |
| Hesap | Favoriler · Şarj Geçmişi (KPI özetli) · Bildirimler · Profil (3 tema seçici) · Profil Düzenleme |

## Admin Dashboard (Flutter, adaptive)

`lib/features/admin/` — Profil → "Firma Paneline Git" üzerinden erişilir.
Masaüstünde sabit sidebar + KPI bento kartları + `fl_chart` haftalık büyüme
trendi + veri tabloları; mobilde aynı ekranlar tek sütun + floating bottom nav
olarak yeniden düzenlenir.

| Ekran | İçerik |
|---|---|
| Genel Bakış | KPI kartları (istasyon/operatör/kullanıcı/veri sürümü), trend grafiği, son istasyonlar tablosu |
| İstasyonlar | Tam veri tablosu + "Yeni İstasyon" formu (aç/kapa) |
| Operatörler | Operatör listesi, istasyon sayısı, entegrasyon durumu |
| Firma/Lisans | Lisans paketi, aylık bedel, yenileme tarihi, durum (ROADMAP.md § 3) |
| Audit Log | Kritik değişiklik kayıtları |

## Çalıştırma

```bash
flutter pub get
flutter run            # mobil/masaüstü
flutter run -d chrome   # web (adaptive sidebar düzenini görmek için pencereyi genişletin)
```

Giriş ekranındaki **Test Girişi** banner'ına dokunarak kimlik doğrulama
olmadan doğrudan tüketici uygulamasına girebilirsin.

> Not: Tüm ekranlar mock veriyle (`lib/data/mock`) çalışır; gerçek
> Firestore/backend bağlantısı ROADMAP.md § 2.2 ve § 2.6'da tanımlanmıştır.

## Backend

Cloudflare Workers iskeleti — bkz. `backend/README.md`.

---

_Flutter starter şablonundan üretilmiştir._
