# Voltavia Admin Paneli

HTML + CSS + Vanilla JavaScript ile hazırlanmış admin paneli arayüz iskeleti
(bkz. `ROADMAP.md` § 2.5). Şu an mock veriyle çalışır; backend API'ye bağlanana
kadar tüm veriler `assets/app.js` içinde sabittir.

## Çalıştırma

Herhangi bir statik dosya sunucusuyla açılabilir:

```bash
npx serve admin-panel
# veya
python3 -m http.server --directory admin-panel 8080
```

`index.html` içindeki "Giriş Yap" butonu mock dashboard'a geçiş yapar.

## Kapsam

- Genel bakış (istasyon/operatör/kullanıcı istatistikleri)
- İstasyon ekle/düzenle, haritadan koordinat seçme alanı
- Operatör yönetimi
- Firma/lisans yönetimi
- Audit log görüntüleme
