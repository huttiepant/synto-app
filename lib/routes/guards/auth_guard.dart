import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synto_app/services/storage_service.dart';

class AuthGuard extends AutoRouteGuard {
  final StorageService storageService = StorageService();

  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    if (FirebaseAuth.instance.currentUser == null) {
      router.pushNamed('/auth');
    } else {
      resolver.next(true);
    }
  }
}
