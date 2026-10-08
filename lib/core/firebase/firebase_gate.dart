import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Firebase, derleme parametreleri doluysa açılır. Anahtar yoksa uygulama
/// katalogla çalışır; sahte proje veya sahte kullanıcı üretilmez.
abstract final class FirebaseGate {
  static bool ready = false;
  static bool maintenance = false;

  static const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const messagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');

  static FirebaseFirestore? get firestore => ready ? FirebaseFirestore.instance : null;

  static bool get configured =>
      projectId.isNotEmpty && apiKey.isNotEmpty && appId.isNotEmpty && messagingSenderId.isNotEmpty;

  static Future<void> start() async {
    if (!configured) return;
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId,
        ),
      );
      ready = true;
    } catch (_) {
      ready = false;
      return;
    }

    if (!kIsWeb) {
      try {
        await FirebaseAppCheck.instance.activate();
      } catch (_) {}
    }

    try {
      await FirebaseAnalytics.instance.logAppOpen();
    } catch (_) {}

    try {
      final remote = FirebaseRemoteConfig.instance;
      await remote.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await remote.setDefaults(const {'maintenance_mode': false});
      await remote.fetchAndActivate();
      maintenance = remote.getBool('maintenance_mode');
    } catch (_) {}
  }
}
