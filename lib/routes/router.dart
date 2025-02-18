import 'package:auto_route/auto_route.dart';
import 'package:synto_app/routes/guards/auth_guard.dart';
import 'package:synto_app/routes/router.gr.dart';
import 'package:synto_app/services/books_service.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          fullMatch: true,
          initial: true,
          page: HomeRoute.page,
        ),
        AutoRoute(
          path: '/auth',
          page: AuthRoute.page,
        ),
        AutoRoute(
            path: '/ideas',
            page: IdeasTaggerRoute.page,
            guards: [AuthGuard()]),
        AutoRoute(
            path: '/${ReadingStep.preReading}',
            page: PreReadingRoute.page,
            guards: [AuthGuard()]),
        AutoRoute(
            path: '/${ReadingStep.whileReading}',
            page: WhileReadingRoute.page,
            guards: [AuthGuard()]),
        AutoRoute(
            path: '/${ReadingStep.postReading}',
            page: PostReadingRoute.page,
            guards: [AuthGuard()]),
      ];
}
