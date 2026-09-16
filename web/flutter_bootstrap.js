{{flutter_js}}
{{flutter_build_config}}

// CanvasKit'i Google'ın CDN'i (gstatic.com) yerine build çıktısına gömülü
// yerel dosyalardan yükle. Bazı kurumsal ağlarda/ülkelerde Google CDN'i
// engellenebiliyor; yerel servis hem daha güvenilir hem de tamamen
// self-contained bir dağıtım sağlıyor.
_flutter.loader.load({
  config: {
    canvasKitBaseUrl: 'canvaskit/',
  },
});
