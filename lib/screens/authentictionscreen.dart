import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/controllers/localnotification.dart';
import 'package:shylo/controllers/userauthenticationcontroller.dart';
import 'package:shylo/widgets/success.dart';

//
class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // initialize Database
    if (context.mounted) {
      DbController.database.db!
          .open()
          .then((_) {
              WindowsNotification.showNotification(body: 'Shylo' ,title: '  Welcome to shylo enterprise..');
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
  String? userName;
  String? passWord;
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    print('${Theme.of(context).primaryColor}');
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
                    const AutoSizeText('Shylo investement limited..'),
                    SizedBox(height: appHeight * 0.02),
                    TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'required';
                        } else if (value.length < 4) {
                          return '6 minimum characters';
                        }
                        return null;
                      },

                      onSaved: (value) {
                        userName = value!;
                      },
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
                      obscureText: isHidden,
                      validator: (value) {
                        if (value == null) {
                          return 'field required';
                        } else if (value.length < 4) {
                          return 'short password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        passWord = value!;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isHidden = !isHidden;
                            });
                          },
                          icon: isHidden
                              ? const Icon(IconsaxPlusLinear.eye, size: 15)
                              : const Icon(
                                  IconsaxPlusLinear.eye_slash,
                                  size: 15,
                                ),
                        ),
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
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save(); //
                            try {
                              await ref
                                  .read(userAuthenticationProvider.notifier)
                                  .login(name: userName!, passWord: passWord!);
                              // navigate to the second screen
                              if (context.mounted) {
                                GoRouter.of(context).go(
                                  '/homescreen',
                                  extra:{
                                    'userModel': ref.read(userAuthenticationProvider),
                                    'selectedIndex': null ,
                                  },
                                );
                              }
                            } catch (e) {
                              showErrorMessage(message: e.toString());
                            }                   
                            // try {
                            //   await ref
                            //       .read(userAuthenticationProvider.notifier)
                            //       .registerUser(
                            //         userName: userName!,
                            //         passWord: passWord!,
                            //       );
                            //   showSuccessMessage(
                            //     message: 'USER REGISTERED SUCCESFFULY',
                            //   );
                            //   _formkey.currentState!.reset();
                            // } catch (e) {
                            //   showErrorMessage(message: e.toString());
                            // }
                          }
                        },
                        child: const Text('Login'),
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
