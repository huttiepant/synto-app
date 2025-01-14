import 'package:dio/dio.dart';
import 'package:reading_app/api/models/reading_app_user.dart';

import '../../services/api_client.dart';

class AuthService {
  final dio = DioClient(baseUrl: 'https://staging-api.realizemusic.com/');
  final tgUrl = 'https://api-services-connect.tunedglobal.com/api/v3';

  // final tgService = GetIt.I<TunedGlobalService>();
  ReadingAppUser? user;

  // TgUserViewModel tgUserViewModel = TgUserViewModel();

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

//
//   Future<void> signOut() async {
//     await FirebaseAuth.instance.signOut();
//     await dio.signOut();
//     user = null;
//     tgUserViewModel.setUser(null);
//   }
//
//   Future<TGUser> getUserProfileById(int userId) async {
//     final Response response = await dio.client.get(
//         '$tgUrl/users/$userId/profile',
//         queryParameters: {'api_key': tgService.storeId},
//         options: Options(headers: {
//           'Authorization': 'Bearer ${user!.access_token}',
//           'StoreId': tgService.storeId
//         }));
//     final responseData = response.data;
//     if (responseData != null) {
//       return TGUser.fromJson(responseData);
//     }
//     return Future.error('');
//   }
//
//   Future<void> updateUserDetails(Map<String, dynamic> details) async {
//     final Response response = await dio.client.patch('$tgUrl/users/me/details',
//         data: details,
//         queryParameters: {'api_key': tgService.storeId},
//         options: Options(headers: {
//           'Authorization': 'Bearer ${user!.access_token}',
//           'StoreId': tgService.storeId
//         }));
//     final responseData = response.data;
//     if (responseData == null) {
//       return Future.error('Error updating user data');
//     }
//     await _updateTgUser();
//   }
//
//   Future<void> uploadProfilePicture(File file) async {
//     String fileName = file.path.split('/').last;
//     FormData data = FormData.fromMap({
//       "file": await MultipartFile.fromFile(
//         file.path,
//         filename: fileName,
//       ),
//     });
//     final Response response = await dio.client.put('$tgUrl/users/me/image',
//         queryParameters: {'api_key': tgService.storeId, 'type': 'Profile'},
//         data: data,
//         options: Options(headers: {
//           'Authorization': 'Bearer ${user!.access_token}',
//           'StoreId': tgService.storeId
//         }));
//     final responseData = response.data;
//     if (responseData != null) {
//       tgUserViewModel.updateUserImage(responseData['Value']);
//       return;
//     }
//   }
//
//   Future<void> followArtists(List<int> artistIds) async {
//     final Response response =
//         await dio.client.put('$tgUrl/collection/follow-artists',
//             data: artistIds,
//             queryParameters: {'api_key': tgService.storeId},
//             options: Options(headers: {
//               'Authorization': 'Bearer ${user!.access_token}',
//               'content-type': 'application/json',
//               'StoreId': tgService.storeId
//             }));
//     final responseData = response.data;
//     if (responseData == null) {
//       return Future.error('Error following artists');
//     }
//   }
//
//   Future<void> updateUserPreferredTags(List<TheneoGenre> genres) async {
//     final preferences = genres
//         .map((TheneoGenre genre) =>
//             {'name': genre.getDisplayName(), 'systemVersion': genre.Name})
//         .toList();
//     final Response response = await dio.client.put(
//         '$tgUrl/users/${user!.user_id}/preferred-tags',
//         data: jsonEncode({'Preferences': preferences}),
//         queryParameters: {'api_key': tgService.storeId},
//         options: Options(headers: {
//           'Authorization': 'Bearer ${user!.access_token}',
//           'StoreId': tgService.storeId
//         }));
//     final responseData = response.data;
//     if (responseData == null) {
//       return Future.error('Error following artists');
//     }
//   }
//
//   Future<void> getFollowedArtists() async {
//     final Response response = await dio.client.get(
//         '$tgUrl/collection/followedartists',
//         queryParameters: {'api_key': tgService.storeId},
//         options: Options(headers: {
//           'Authorization': 'Bearer ${user!.access_token}',
//           'StoreId': tgService.storeId
//         }));
//     final responseData = response.data;
//     if (responseData == null) {
//       return Future.error('Error getting artists');
//     }
//   }
//
//   Future<void> getUserPreferredTags() async {
//     final Response response = await dio.client.get(
//         '$tgUrl/users/${user!.user_id}/preferred-tags',
//         queryParameters: {'api_key': tgService.storeId},
//         options: Options(headers: {
//           'Authorization': 'Bearer ${user!.access_token}',
//           'StoreId': tgService.storeId
//         }));
//     final responseData = response.data;
//     if (responseData == null) {
//       return Future.error('Error getting artists');
//     }
//   }
//
  Future<void> _handleUserLogin(String token) async {
    try {
      user = await loginWithToken(token);
      // await _updateTgUser();
    } catch (e) {
      print(e);
    }
  }
//
//   Future<void> _updateTgUser() async {
//     final tgUser = await getUserProfileById(user!.user_id);
//     tgUserViewModel.setUser(tgUser);
//   }
}
