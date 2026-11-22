# 04 — Operatör entegrasyonu ve şarj akışı

**Durum:** Bloke. Operatör sözleşmesi, API kimliği ve production sunucu bağlantısı bulunmuyor.

## İşler

- [ ] Operatör bazlı capability matrisi: katalog, fiyat, live status, reserve, start/stop, receipt.
- [ ] Her operatörden API/OCPI dokümanı, sandbox, erişim şartı ve sözleşme al.
- [ ] Credential/secret'ları istemci içine koyma; backend secret store ve erişim sınırları belirle.
- [ ] OCPI eMSP/roaming ya da özel API için adapter arayüzü seç.
- [ ] İstasyon/soket/EVSE kimliklerini normalize et; tekrar denemede idempotency uygula.
- [ ] Başlatma öncesi kullanıcı, soket, operatör ve araç uyum kontrollerini yap.
- [ ] Session polling/webhook ve fiyat doğrulama akışını kur.
- [ ] Stop timeout, bağlantı kaybı, oturum uzlaştırma ve iki kez başlatma koruması.
- [ ] Operatörün kendi hosted ödeme deneyimine güvenli devir; ödeme kart verisini Voltavia'da tutma.
- [ ] Makbuz, ücret ayrışması ve destek talebi akışını kur.
- [ ] Entegrasyon yoksa operatör uygulaması/navigasyon fallback'ini her noktada göster.

## Tamamlanma ölçütleri

- UI yalnızca doğrulanmış capability olan istasyonda “Şarjı başlat” eylemini açar.
- Ücret ve oturum durumu operatör cevabından gelir; mock değer kullanıcı işlemine dönüşmez.
- Başlat/durdur tekrarları çift ücretli/çift oturumlu işlem yaratmaz.
- API kesintisinde durum ve kullanıcıya yapılacak sonraki adım açıkça gösterilir.

