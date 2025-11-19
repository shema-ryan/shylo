import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shylo/models/loan.dart';
import 'package:shylo/models/usermodel.dart';
import './screens/screen.dart';
import 'models/client.dart';
import 'screens/clientdetailscreen.dart';

// Configuration for my app router
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const AuthenticationScreen()),
    ),
    GoRoute(
      path: '/homescreen',
      pageBuilder: (context, state) {
        final UserModel userModel =
            (state.extra! as Map<String, dynamic>)['userModel'] as UserModel;
        final selectedPrevious =
            (state.extra! as Map<String, dynamic>)['selected'] as int?;
        return MaterialPage(
          key: state.pageKey,
          child: HomeScreen(userModel: userModel, previous: selectedPrevious),
        );
      },
    ),
    GoRoute(
      path: '/loandetailscreen',
      pageBuilder: (context, state) {
        final Loan loan = state.extra! as Loan;
        return MaterialPage(
          key: state.pageKey,
          child: LoanDetailScreen(id: loan.id!),
        );
      },
    ),

    GoRoute(
      path: '/clientdetailscreen',
      pageBuilder: (context, state) {
        final Client client = state.extra! as Client;
        return MaterialPage(
          key: state.pageKey,
          child: ClientDetailScreen(id: client.id!),
        );
      },
    ),
  ],
);
