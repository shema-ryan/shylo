import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:shylo/widgets/success.dart';
import '../controllers/investorcontroller.dart';
import '../models/investor.dart';
import '../widgets/formfield.dart';

class InvestorForm extends ConsumerStatefulWidget {
  const InvestorForm({super.key});

  @override
  ConsumerState<InvestorForm> createState() => _InvestorFormState();
}

class _InvestorFormState extends ConsumerState<InvestorForm> {
  final _key = GlobalKey<FormState>();
  String? ninNumber;
  String? name;
  String? email;
  double? phoneNumber;
  double? interestRate;
  double? amount;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
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
            if (_key.currentState!.validate()) {
              _key.currentState!.save();
              try {
                await ref
                    .read(investorProvider.notifier)
                    .addInvestor(
                      investor: Investor(
                        id: null,
                        telephoneNumber: phoneNumber!,
                        email: email!,
                        interestRate: interestRate!,
                        ninNumber: ninNumber!,
                        name: name!,
                        amount: amount!,
                        date: DateTime.now(),
                        paymentTracker: {DateTime.now() : false}
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
          'Investor Card',
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      content: SizedBox(
        height: size.height * 0.5,
        width: size.width * 0.8,
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
                      data: IconsaxPlusLinear.people,
                      fieldName: 'full name',
                      onSaved: (value) {
                        name = value!;
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
                        email = value!;
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
                        phoneNumber = double.parse(value!);
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
                      data: IconsaxPlusLinear.tag_user,
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
                'Investement Details',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: FormField(
                      initialValue: '',
                      isNumber: true,
                      data: IconsaxPlusLinear.cpu,
                      fieldName: 'Amount',
                      onSaved: (value) {
                        amount = double.parse(value!);
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
                      isNumber: true,
                      data: IconsaxPlusLinear.wifi,
                      onSaved: (value) {
                        interestRate = double.parse(value!);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'required';
                        } else {
                          return null;
                        }
                      },
                      fieldName: 'interest Rate',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
