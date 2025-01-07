import 'package:auto_route/auto_route.dart';
import 'package:reading_app/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/auth',
          initial: true,
          page: AuthRoute.page,
        ),
      ];
}
