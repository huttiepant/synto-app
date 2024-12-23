import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:toastification/toastification.dart';

import '../routes/router.dart';
import '../services/storage_service.dart';

class AuthInterceptor extends InterceptorsWrapper {
  StorageService storageService;
  final _appRouter = GetIt.I<AppRouter>();

  AuthInterceptor({required this.storageService});

  @override
  onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (err.response?.statusCode == 401) {
      storageService.saveString('token', '');
      _appRouter.replaceNamed('/auth');
    } else {
      print(err.response?.data);
      toastification.show(
        style: ToastificationStyle.flat,
        showProgressBar: false,
        closeOnClick: true,
        closeButtonShowType: CloseButtonShowType.none,
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
        title: Text(err.response?.data['message']),
      );
    }
  }
}

class DioClient {
  final Dio client = Dio();
  late final StorageService storageService;
  String? token;

  final String baseUrl;

  DioClient({required this.baseUrl}) {
    storageService = GetIt.instance<StorageService>();
    client.interceptors.add(AuthInterceptor(storageService: storageService));
    token = storageService.getString('token');
  }

  Future<void> signOut() async {
    await storageService.saveString('token', '');
    token = null;
  }

}
