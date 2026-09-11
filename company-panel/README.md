# Voltavia Firma Paneli

Şarj operatörlerinin kendi istasyonlarını, fiyatlarını ve entegrasyon durumunu
yönettiği panel (bkz. `ROADMAP.md` § 3). HTML + CSS + Vanilla JavaScript,
admin panelindeki tasarım sistemiyle tutarlıdır.

## Çalıştırma

```bash
npx serve company-panel
# veya
python3 -m http.server --directory company-panel 8080
```

## Kapsam

- Genel bakış
- İstasyonlarım (görüntüleme/düzenleme)
- Fiyatlandırma (konnektör tipine göre kWh birim fiyatı)
- Entegrasyon durumu (OCPI/API, ödeme sağlayıcısı sağlığı)
- Sözleşme / lisans bilgileri
