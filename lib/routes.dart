import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './screens/screen.dart';

// Configuration for my app router
final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: AuthenticationScreen()),
    ),
  ],
);
