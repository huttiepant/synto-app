import 'package:dio/dio.dart';
import 'package:synto_app/api/models/reading_app_user.dart';

import '../../services/api_client.dart';

class AuthService {
  final dio = DioClient(baseUrl: '');
  ReadingAppUser? user;

  Future<void> loginWithCredentials(String email, String password) async {
    // try {
    //   final credential = await FirebaseAuth.instance
    //       .signInWithEmailAndPassword(email: email, password: password);
    //   final token = await credential.user?.getIdToken();
    //   if (token != null) {
    //     await _handleUserLogin(token);
    //   }
    //   return;
    // } on FirebaseAuthException catch (e) {
    //   return Future.error(e.message ?? e.code);
    // }
  }

  Future<void> signUpWithCredentials(String email, String password) async {
    // try {
    //   final credential =
    //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   final token = await credential.user?.getIdToken();
    //   if (token != null) {
    //     await _handleUserLogin(token);
    //   }
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     return Future.error('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     return Future.error('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   return Future.error(e.toString());
    // }
  }

  Future<ReadingAppUser> loginWithToken(String token) async {
    dio.token = token;
    final Response response = await dio.client.post('${dio.baseUrl}/auth/login',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    final responseData = response.data;
    if (responseData != null) {
      dio.storageService.saveString('token', token);
      return ReadingAppUser.fromJson(responseData);
    }
    return Future.error(responseData);
  }

  Future<void> silentLogin() async {
    if (user != null) {
      return;
    }
    final token = dio.storageService.getString('token');
    if (token.isNotEmpty) {
      await _handleUserLogin(token);
    } else {
      return Future.error('');
    }
  }

  Future<void> _handleUserLogin(String token) async {
    try {
      user = await loginWithToken(token);
    } catch (e) {
      print(e);
    }
  }
}
