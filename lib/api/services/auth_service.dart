import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> loginWithCredentials(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? e.code);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? e.code);
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? e.code);
    }
  }

  Future<void> signUpWithCredentials(
      String email, String password, String name) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      await _sendAnalyticsEvent('sign_up_complete', {name: name, email: email});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return Future.error('The account already exists for that email.');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> _sendAnalyticsEvent(String name, parameters) async {
    await analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
