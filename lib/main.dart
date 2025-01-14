import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fquery/fquery.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:reading_app/routes/router.dart';
import 'package:toastification/toastification.dart';
import 'services/storage_service.dart';

GetIt getIt = GetIt.instance;
final queryClient = QueryClient(
  defaultQueryOptions: DefaultQueryOptions(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  getIt.registerSingleton<StorageService>(StorageService());
  await getIt<StorageService>().init();
  getIt.registerSingleton<AppRouter>(AppRouter());
  // getIt.registerSingleton<AuthService>(AuthService());

  runApp(QueryClientProvider(
      queryClient: queryClient,
      child:
          ToastificationWrapper(child: GlobalLoaderOverlay(child: MyApp()))));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = getIt<AppRouter>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp.router(
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate: _appRouter.delegate(),
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.black38, useMaterial3: true),
      ),
    );
  }
}
