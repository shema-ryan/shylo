import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:shylo/controllers/usergroupcontroller.dart';
import 'package:shylo/models/exception.dart';
import 'package:shylo/models/usermodel.dart';
import 'package:shylo/widgets/formfield.dart';
import 'package:shylo/widgets/success.dart';

class UserAccountForm extends ConsumerStatefulWidget {
  const UserAccountForm({super.key});

  @override
  ConsumerState<UserAccountForm> createState() => _InvestorFormState();
}

class _InvestorFormState extends ConsumerState<UserAccountForm> {
  final _key = GlobalKey<FormState>();
  String? ninNumber;
  String? name;
  String? email;
  double? phoneNumber;
  String? passWord;
  String? checkPassWord;
  bool isAdmin = false;
  bool isLoanOfficer = false;
  bool isInvestor = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              _key.currentState!.save();
              if (_key.currentState!.validate()) {
               
                try {
            if(!isAdmin && !isInvestor && !isLoanOfficer){
                  throw MyException(message: 'Please select a userRole');
                }
                  await ref
                      .read(userGroupProvider.notifier)
                      .registerUser(
                        userAccount: UserAccount(
                          objectId: null,
                          date: DateTime.now(),
                          email: email!,
                          ninNumber: ninNumber!,
                          passWord: passWord!,
                          phoneNumber: phoneNumber!,
                          userName: name!,
                          userRoles: [
                            if (isLoanOfficer) UserRoles.loanofficer,
                            if (isInvestor) UserRoles.investor,
                            if (isAdmin) UserRoles.administrator,
                          ],
                        ),
                      );
                             if (context.mounted) Navigator.of(context).pop();
                } catch (e) {
             showErrorMessage(message: e.toString());
                }
              }
            },
            child: const Text('Register'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
        title: Center(
          child: Text(
            'User Card',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        content: SizedBox(
          height: size.height * 0.6,
          width: size.width * 0.5,
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  ' Bio Data',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: FormField(
                        initialValue: '',
                        isNumber: false,
                        data: IconsaxPlusLinear.user_add,
                        fieldName: 'full name',
                        onSaved: (value) {
                          name = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FormField(
                        initialValue: '',
                        isNumber: false,
                        data: IconsaxPlusLinear.message,
                        onSaved: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          } else if (!value.contains('@')) {
                            return 'valid email required';
                          } else {
                            return null;
                          }
                        },
                        fieldName: 'email',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: FormField(
                        initialValue: '',
                        isNumber: true,
                        data: IconsaxPlusLinear.call,
                        onSaved: (value) {
                          phoneNumber = value == ''
                              ? null
                              : double.parse(value!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          } else if (value.length < 10) {
                            return 'invalid phone number';
                          } else {
                            return null;
                          }
                        },
                        fieldName: 'phone number',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FormField(
                        initialValue: '',
                        isNumber: false,
                        data: IconsaxPlusLinear.aquarius,
                        onSaved: (value) {
                          ninNumber = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          } else if (value.length < 14) {
                            return 'invalid nin';
                          } else {
                            return null;
                          }
                        },
                        fieldName: 'nin number',
                      ),
                    ),
                  ],
                ),
                AutoSizeText(
                  'PassWord Details',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          }
                          return null;
                        },

                        onSaved: (value) {
                          passWord = value;
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
                          label: const Text('password'),
                          prefixIcon: Icon(
                            IconsaxPlusLinear.lock,
                            color: Colors.black45,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          } else if (value != passWord) {
                            return 'passWord mismatch';
                          }
                          return null;
                        },

                        onSaved: (value) {
                          checkPassWord = value;
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
                          label: Text('Re-type password'),
                          prefixIcon: Icon(
                            IconsaxPlusLinear.lock,
                            color: Colors.black45,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AutoSizeText(
                  'User Rights',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Administrator'),
                        value: isAdmin,
                        onChanged: (value) {
                          setState(() {
                            isAdmin = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('LoanOfficer'),
                        value: isLoanOfficer,
                        onChanged: (value) {
                          setState(() {
                            isLoanOfficer = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Investor'),
                        value: isInvestor,
                        onChanged: (value) {
                          setState(() {
                            isInvestor = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
