import 'package:auto_route/auto_route.dart';
import 'package:synto_app/routes/guards/auth_guard.dart';
import 'package:synto_app/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: HomeRoute.page,
        ),
        AutoRoute(
          path: '/auth',
          page: AuthRoute.page,
        ),
        AutoRoute(
            path: '/choice', page: ChoiceRoute.page, guards: [AuthGuard()]),
      ];
}
