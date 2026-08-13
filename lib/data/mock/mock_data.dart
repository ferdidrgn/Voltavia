import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../models/app_notification.dart';
import '../models/campaign.dart';
import '../models/charging_session.dart';
import '../models/connector_type.dart';
import '../models/operator.dart';
import '../models/station.dart';

/// Gerçek Firestore/backend bağlanana kadar UI'ı besleyen sabit örnek veri.
/// Bkz. ROADMAP.md → "İstasyon Verisi Senkronizasyon Akışı".
abstract final class MockData {
  static const operators = <ChargeOperator>[
    ChargeOperator(
      id: 'op1',
      name: 'VoltCharge',
      logoLetter: 'V',
      hasAppIntegration: true,
      description:
          'Türkiye genelinde hızlı şarj ağı işleten VoltCharge, Voltavia ile tam entegre '
          'çalışır: şarjı doğrudan uygulama içinden başlatabilirsin.',
    ),
    ChargeOperator(
      id: 'op2',
      name: 'Şimşek Enerji',
      logoLetter: 'Ş',
      hasAppIntegration: true,
      description:
          'Şimşek Enerji, AVM ve liman bölgelerinde yoğunlaşan geniş bir şarj ağına sahiptir. '
          'Voltavia entegrasyonu sayesinde uygulama içi ödeme desteklenir.',
    ),
    ChargeOperator(
      id: 'op3',
      name: 'AkımNet',
      logoLetter: 'A',
      description: 'AkımNet, şehir içi kısa süreli park alanlarında AC şarj çözümleri sunar.',
    ),
    ChargeOperator(
      id: 'op4',
      name: 'ElektraPark',
      logoLetter: 'E',
      description: 'ElektraPark, şehir meydanları ve toplu otoparklarda yaygın bir ağ işletir.',
    ),
    ChargeOperator(
      id: 'op5',
      name: 'Eşarj',
      logoLetter: 'E',
      description: 'Eşarj, otoyol dinlenme tesislerinde hızlı şarj noktaları işletmektedir.',
    ),
    ChargeOperator(
      id: 'op6',
      name: 'Menzil Şarj',
      logoLetter: 'M',
      description: 'Menzil Şarj, şehirlerarası güzergahlarda menzil kaygısını azaltmayı hedefler.',
    ),
    ChargeOperator(
      id: 'op7',
      name: 'PlugTR',
      logoLetter: 'P',
      description: 'PlugTR, konut siteleri ve iş merkezlerine özel şarj çözümleri sunar.',
    ),
    ChargeOperator(
      id: 'op8',
      name: 'GreenVolt',
      logoLetter: 'G',
      description: 'GreenVolt, güneş enerjisiyle beslenen sürdürülebilir şarj istasyonları kurar.',
    ),
    ChargeOperator(
      id: 'op9',
      name: 'Ohm Enerji',
      logoLetter: 'O',
      description: 'Ohm Enerji, sanayi bölgelerinde filo şarjına odaklanan bir operatördür.',
    ),
    ChargeOperator(
      id: 'op10',
      name: 'CarjPlus',
      logoLetter: 'C',
      description: 'CarjPlus, otopark zincirleriyle iş birliği içinde hızlı şarj sunar.',
    ),
    ChargeOperator(
      id: 'op11',
      name: 'İyi Şarj',
      logoLetter: 'İ',
      description: 'İyi Şarj, uygun fiyatlı AC şarj noktalarıyla şehir içi kullanıcıları hedefler.',
    ),
    ChargeOperator(
      id: 'op12',
      name: 'Nova Volt',
      logoLetter: 'N',
      description: 'Nova Volt, yeni nesil ultra hızlı şarj teknolojisine yatırım yapmaktadır.',
    ),
  ];

  static List<Station> get stations => [
        Station(
          id: 's1',
          name: 'Zorlu Center Şarj Noktası',
          city: 'İstanbul',
          district: 'Beşiktaş',
          address: 'Zorlu Center AVM Otoparkı, Kat -2',
          chargeOperator: operators[0],
          connectors: const [ConnectorType.ccs2, ConnectorType.type2],
          maxPowerKw: 150,
          pricePerKwh: 8.9,
          status: StationStatus.available,
          distanceKm: 1.2,
          rating: 4.7,
          socketCount: 6,
        ),
        Station(
          id: 's2',
          name: 'İstinye Park Otopark',
          city: 'İstanbul',
          district: 'Sarıyer',
          address: 'İstinye Park AVM, B Blok Otopark',
          chargeOperator: operators[1],
          connectors: const [ConnectorType.ccs2, ConnectorType.chademo],
          maxPowerKw: 120,
          pricePerKwh: 9.4,
          status: StationStatus.busy,
          distanceKm: 3.8,
          rating: 4.5,
          socketCount: 4,
        ),
        Station(
          id: 's3',
          name: 'Akbatı AVM Şarj İstasyonu',
          city: 'İstanbul',
          district: 'Esenyurt',
          address: 'Akbatı AVM Açık Otopark',
          chargeOperator: operators[2],
          connectors: const [ConnectorType.type2, ConnectorType.ac],
          maxPowerKw: 22,
          pricePerKwh: 6.5,
          status: StationStatus.available,
          distanceKm: 7.1,
          rating: 4.2,
          socketCount: 8,
        ),
        Station(
          id: 's4',
          name: 'Kadıköy Sahil Otoparkı',
          city: 'İstanbul',
          district: 'Kadıköy',
          address: 'Kadıköy Sahil Otoparkı Girişi',
          chargeOperator: operators[0],
          connectors: const [ConnectorType.ccs2],
          maxPowerKw: 180,
          pricePerKwh: 9.9,
          status: StationStatus.maintenance,
          distanceKm: 5.4,
          rating: 4.0,
          socketCount: 2,
        ),
        Station(
          id: 's5',
          name: 'Kızılay Meydan Şarj Üniteleri',
          city: 'Ankara',
          district: 'Çankaya',
          address: 'Kızılay Meydanı Yeraltı Otoparkı',
          chargeOperator: operators[3],
          connectors: const [ConnectorType.type2, ConnectorType.ccs2],
          maxPowerKw: 90,
          pricePerKwh: 7.8,
          status: StationStatus.available,
          distanceKm: 0.6,
          rating: 4.6,
          socketCount: 5,
        ),
        Station(
          id: 's6',
          name: 'Alsancak Liman Otoparkı',
          city: 'İzmir',
          district: 'Konak',
          address: 'Alsancak Liman Sosyal Tesisleri',
          chargeOperator: operators[1],
          connectors: const [ConnectorType.ccs2, ConnectorType.type2, ConnectorType.chademo],
          maxPowerKw: 150,
          pricePerKwh: 8.2,
          status: StationStatus.offline,
          distanceKm: 2.9,
          rating: 3.9,
          socketCount: 4,
        ),
        Station(
          id: 's7',
          name: 'Bursa Kent Meydanı Şarj Ünitesi',
          city: 'Bursa',
          district: 'Osmangazi',
          address: 'Kent Meydanı Yeraltı Otoparkı',
          chargeOperator: operators[2],
          connectors: const [ConnectorType.type2, ConnectorType.ccs2],
          maxPowerKw: 60,
          pricePerKwh: 7.2,
          status: StationStatus.available,
          distanceKm: 12.4,
          rating: 4.3,
          socketCount: 4,
        ),
        Station(
          id: 's8',
          name: 'Antalya Lara Sahil Otoparkı',
          city: 'Antalya',
          district: 'Muratpaşa',
          address: 'Lara Sahil Yolu Otoparkı',
          chargeOperator: operators[7],
          connectors: const [ConnectorType.ccs2, ConnectorType.type2],
          maxPowerKw: 100,
          pricePerKwh: 8.1,
          status: StationStatus.available,
          distanceKm: 4.7,
          rating: 4.4,
          socketCount: 5,
        ),
        Station(
          id: 's9',
          name: 'Bursa Nilüfer AVM',
          city: 'Bursa',
          district: 'Nilüfer',
          address: 'Nilüfer AVM Otoparkı, Kat -1',
          chargeOperator: operators[0],
          connectors: const [ConnectorType.ccs2],
          maxPowerKw: 150,
          pricePerKwh: 9.2,
          status: StationStatus.busy,
          distanceKm: 8.9,
          rating: 4.6,
          socketCount: 3,
        ),
        Station(
          id: 's10',
          name: 'Antalya Havalimanı Otoparkı',
          city: 'Antalya',
          district: 'Aksu',
          address: 'Dış Hatlar Terminali Uzun Süreli Otopark',
          chargeOperator: operators[1],
          connectors: const [ConnectorType.ccs2, ConnectorType.chademo],
          maxPowerKw: 180,
          pricePerKwh: 9.9,
          status: StationStatus.maintenance,
          distanceKm: 15.2,
          rating: 4.0,
          socketCount: 6,
        ),
      ];

  static List<String> get cities => stations.map((s) => s.city).toSet().toList()..sort();

  static List<String> districtsFor(String city) => stations
      .where((s) => s.city == city)
      .map((s) => s.district)
      .toSet()
      .toList()
    ..sort();

  static List<Station> stationsFor(String operatorId) =>
      stations.where((s) => s.chargeOperator.id == operatorId).toList();

  static List<Station> get nearestStations {
    final list = List<Station>.from(stations);
    list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return list;
  }

  static List<Campaign> get campaigns => const [
        Campaign(
          id: 'c1',
          title: 'İlk Şarjın Bizden Sorulur',
          subtitle: 'Yeni üyelere özel kampanyaları kaçırma, hemen katıl.',
          ctaLabel: 'Kampanyayı İncele',
          icon: Icons.card_giftcard_rounded,
          colors: AppColors.heroGradient,
        ),
        Campaign(
          id: 'c2',
          title: 'VoltCharge ile Hızlı Şarj',
          subtitle: '150 kW\'a kadar güçle dakikalar içinde doldur.',
          ctaLabel: 'İstasyonları Gör',
          icon: Icons.bolt_rounded,
          colors: AppColors.energyGradient,
        ),
        Campaign(
          id: 'c3',
          title: 'Yeni Şehirler Eklendi',
          subtitle: 'Bursa ve Antalya artık Voltavia haritasında.',
          ctaLabel: 'Keşfet',
          icon: Icons.location_city_rounded,
          colors: AppColors.campaignGradient,
        ),
      ];

  static List<ChargingSession> get history => [
        ChargingSession(
          id: 'cs1',
          stationName: 'Zorlu Center Şarj Noktası',
          operatorName: 'VoltCharge',
          startedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          endedAt: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 25)),
          energyKwh: 32.4,
          costTry: 288.36,
          state: SessionState.completed,
        ),
        ChargingSession(
          id: 'cs2',
          stationName: 'İstinye Park Otopark',
          operatorName: 'Şimşek Enerji',
          startedAt: DateTime.now().subtract(const Duration(days: 4, hours: 5)),
          endedAt: DateTime.now().subtract(const Duration(days: 4, hours: 4, minutes: 40)),
          energyKwh: 18.1,
          costTry: 170.14,
          state: SessionState.completed,
        ),
        ChargingSession(
          id: 'cs3',
          stationName: 'Kızılay Meydan Şarj Üniteleri',
          operatorName: 'ElektraPark',
          startedAt: DateTime.now().subtract(const Duration(days: 9, hours: 3)),
          endedAt: DateTime.now().subtract(const Duration(days: 9, hours: 2, minutes: 10)),
          energyKwh: 41.0,
          costTry: 319.8,
          state: SessionState.stopped,
        ),
      ];

  static List<AppNotification> get notifications => [
        AppNotification(
          id: 'n1',
          title: 'Şarj tamamlandı',
          message: 'Zorlu Center Şarj Noktası oturumun 32.4 kWh ile tamamlandı.',
          time: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          kind: NotificationKind.session,
          isRead: false,
        ),
        AppNotification(
          id: 'n2',
          title: 'Yeni istasyon: Kadıköy',
          message: 'Kadıköy Sahil Otoparkı bölgene eklendi.',
          time: DateTime.now().subtract(const Duration(days: 2)),
          kind: NotificationKind.system,
          isRead: true,
        ),
        AppNotification(
          id: 'n3',
          title: 'Haftalık veri güncellendi',
          message: 'İstasyon listesi en güncel sürüme yükseltildi.',
          time: DateTime.now().subtract(const Duration(days: 6)),
          kind: NotificationKind.system,
          isRead: true,
        ),
      ];

  const MockData._();
}
