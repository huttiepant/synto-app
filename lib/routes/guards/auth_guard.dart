import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:reading_app/api/services/auth_service.dart';
import 'package:reading_app/services/storage_service.dart';

class AuthGuard extends AutoRouteGuard {
  final StorageService storageService = StorageService();

  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    final authService = GetIt.instance<AuthService>();
    try {
      await authService.silentLogin();
    } catch (e) {
      router.replaceNamed('/auth');
      return;
    }
    if (authService.user == null ||
        authService.tgUserViewModel.tgUser == null) {
      router.replaceNamed('/auth');
    } else {
      resolver.next(true);
    }
  }
}
