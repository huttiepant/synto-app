import 'package:auto_route/auto_route.dart';
import 'package:reading_app/routes/guards/auth_guard.dart';
import 'package:reading_app/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/auth',
          page: AuthRoute.page,
        ),
        AutoRoute(
          path: '/welcome',
          page: WelcomeRoute.page,
        ),
        AutoRoute(
          path: '/main',
          initial: true,
          guards: [AuthGuard()],
          page: MainRoute.page,
        ),
      ];
}
