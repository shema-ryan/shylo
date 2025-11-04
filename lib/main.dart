import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/models/model.dart';
import 'package:shylo/routes.dart';
void main() {
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
      scaffoldMessengerKey: scaffoldMessenger,
      routeInformationProvider: goRouter.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      title: 'Skylo',
      theme: lightTheme,
    );
  }
}


