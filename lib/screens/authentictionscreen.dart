import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/widgets/success.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // initialize Database
    if (context.mounted) {
      DbController.database.db!
          .open()
          .then((_) {
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
    return Form(
      key: _formkey,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final appHeight = constraints.maxHeight;
            final appwidth = constraints.maxWidth;
            return Center(
              child: SizedBox(
                height: appHeight * 0.7,
                width: appwidth * 0.4,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/skylo.png',
                      height: appHeight * 0.3,
                      width: appwidth * 0.3,
                    ),
                    const AutoSizeText('Skylo investement limited..'),
                    SizedBox(height: appHeight * 0.02),
                    TextFormField(
                      validator: (value) {
                        return null;
                      },

                      onSaved: (value) {},
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        fillColor: Colors.greenAccent.withAlpha(10),
                        label: const Text('username'),
                        prefixIcon: const Icon(
                          IconsaxPlusLinear.user,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                    SizedBox(height: appHeight * 0.02),
                    TextFormField(
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {},
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        label: const Text('password'),
                        fillColor: Colors.greenAccent.withAlpha(10),
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        prefixIcon: const Icon(
                          IconsaxPlusLinear.lock_1,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: appHeight * 0.02),
                    SizedBox(
                      height: appHeight * 0.06,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const AutoSizeText('Login'),
                      ),
                    ),
                    SizedBox(height: appHeight * 0.01),
                    AutoSizeText(
                      'Live like they dream.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
