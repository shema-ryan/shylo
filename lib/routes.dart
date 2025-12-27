import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shylo/models/investor.dart';
import 'package:shylo/models/loan.dart';
import 'package:shylo/models/usermodel.dart';
import 'package:shylo/screens/deciderscreen.dart';
import 'package:shylo/screens/investordetailscreen.dart';
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
          MaterialPage(key: state.pageKey, child: const DeciderScreen()),
    ),
    GoRoute(
      path: '/homescreen',
      pageBuilder: (context, state) {
        final UserAccount userAccount =
            (state.extra! as Map<String, dynamic>)['userModel'] as UserAccount;
        final selectedPrevious =
            (state.extra! as Map<String, dynamic>)['selected'] as int?;
        return MaterialPage(
          key: state.pageKey,
          child: HomeScreen(userAccount: userAccount, previous: selectedPrevious),
        );
      },
    ),
      GoRoute(
      path: '/investordetailscreen',
      pageBuilder: (context, state) {
        final Investor investor = state.extra! as Investor;
        return MaterialPage(
          key: state.pageKey,
          child: InvestorDetailScreen(id: investor.id!),
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
