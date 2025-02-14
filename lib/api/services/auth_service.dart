import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> loginWithCredentials(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
