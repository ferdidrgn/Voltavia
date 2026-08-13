# Voltavia API (Cloudflare Workers)

Bu klasör, `ROADMAP.md` § 2.6'da tanımlanan backend altyapısının başlangıç iskeletidir.

## Kurulum

```bash
npm install
npm run dev      # yerel geliştirme (wrangler dev)
npm run deploy   # Cloudflare Workers'a yayınla
```

## Uç Noktalar (Faz 1)

| Uç Nokta | Açıklama |
|---|---|
| `GET /health` | Servis sağlık kontrolü |
| `GET /version` | İstasyon veri paketinin güncel sürüm bilgisi (mobil uygulama haftalık kontrol eder) |
| `GET /stations` | İstasyon listesi (ilk kullanımda indirilen tam paket) |

## Sıradaki Adımlar

- Firestore bağlantısı (Firebase Admin SDK ya da REST API üzerinden)
- `version.json` dosyasının R2/CDN üzerinden statik dağıtımı
- Operatör API/OCPI entegrasyon servisleri (Faz 3)
- Secret yönetimi (operatör API anahtarları)
- Rate limit ve bot koruması
