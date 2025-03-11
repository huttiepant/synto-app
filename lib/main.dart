import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fquery/fquery.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:synto_app/routes/router.dart';
import 'package:toastification/toastification.dart';

import 'api/services/auth_service.dart';
import 'firebase_options.dart';
import 'services/storage_service.dart';

GetIt getIt = GetIt.instance;
final queryClient = QueryClient(
  defaultQueryOptions: DefaultQueryOptions(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  getIt.registerSingleton<StorageService>(StorageService());
  await getIt<StorageService>().init();
  getIt.registerSingleton<AppRouter>(AppRouter());
  getIt.registerSingleton<AuthService>(AuthService());
  GoogleFonts.pendingFonts([
    GoogleFonts.notoColorEmoji(),
  ]);

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
    var baseTheme = ThemeData(
        scaffoldBackgroundColor: Colors.black38,
        useMaterial3: true,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }));
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
        theme: baseTheme.copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme)),
      ),
    );
  }
}
