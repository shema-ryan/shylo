import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/controllers/localnotification.dart';
import 'package:shylo/models/model.dart';
import 'package:shylo/routes.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowsNotification.initializeNotification();
  DbController();
  runApp(
    ProviderScope(child: const MyApp()));
}
 final scaffoldMessenger = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: goRouter.routeInformationParser,
      routerDelegate: goRouter.routerDelegate,
      routeInformationProvider: goRouter.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      title: 'Shylo',
      scaffoldMessengerKey: scaffoldMessenger,
      theme:lightTheme,
    );
  }
}


