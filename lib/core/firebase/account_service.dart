import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_gate.dart';

/// Hesap işlemleri Firebase Auth üzerinden gider. Proje bağlı değilse
/// oturum açılmaz.
abstract final class AccountService {
  static Future<String?> signIn(String email, String password) async {
    if (!FirebaseGate.ready) {
      return 'Firebase projesi bağlı değil. Hesap açılmadı.';
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password);
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message ?? 'Giriş olmadı.';
    } catch (_) {
      return 'Giriş olmadı.';
    }
  }

  static Future<String?> register(String email, String password) async {
    if (!FirebaseGate.ready) {
      return 'Firebase projesi bağlı değil. Hesap açılmadı.';
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.trim(), password: password);
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message ?? 'Hesap açılmadı.';
    } catch (_) {
      return 'Hesap açılmadı.';
    }
  }

  static Future<String?> sendReset(String email) async {
    if (!FirebaseGate.ready) {
      return 'Firebase projesi bağlı değil.';
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message ?? 'Bağlantı gönderilmedi.';
    } catch (_) {
      return 'Bağlantı gönderilmedi.';
    }
  }
}
