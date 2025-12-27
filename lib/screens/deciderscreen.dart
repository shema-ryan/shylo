import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shylo/controllers/useraccountcontroller.dart';
import 'package:shylo/screens/screen.dart';

import '../controllers/databasecontroller.dart';
import '../controllers/localnotificationcontroller.dart';
import '../widgets/success.dart' show showSuccessMessage, showErrorMessage;

class DeciderScreen extends ConsumerStatefulWidget {
  const DeciderScreen({super.key});

  @override
  ConsumerState<DeciderScreen> createState() => _DeciderScreenState();
}

class _DeciderScreenState extends ConsumerState<DeciderScreen> {
  @override
  void initState() {
    super.initState();
    if (context.mounted) {
      DbController.database.db!
          .open()
          .then((_) async {
            await LocalNotificationController.showNotification(
              title: ' ',
              body: 'Welcome to shylo..',
            );
            showSuccessMessage(message: 'Db Connected successfully...');
          })
          .onError((error, _) {
            showErrorMessage(message: error.toString());
            Future.delayed(const Duration(seconds: 10), () {
              exit(-1);
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedUser = ref.watch(userAccountProvider);
    return loggedUser == null
        ? AuthenticationScreen()
        : HomeScreen(userAccount: loggedUser, previous: null);
  }
}
