import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shylo/models/loan.dart';
import 'package:shylo/models/usermodel.dart';
import './screens/screen.dart';

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
        final UserModel userModel = state.extra! as UserModel;
        return MaterialPage(
          key: state.pageKey,
          child: HomeScreen(userModel: userModel),
        );
      },
    ),
       GoRoute(
      path: '/loandetailscreen',
      pageBuilder: (context, state) {
        final Loan loan = state.extra! as Loan;
        return MaterialPage(
          key: state.pageKey,
          child: LoanDetailScreen(loan: loan ,),
        );
      },
    ),
  ],
);
