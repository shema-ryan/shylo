import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:shylo/widgets/success.dart';
import '../controllers/loancontroller.dart';
import 'package:shylo/models/loan.dart';
import '../controllers/clientcontroller.dart';
import '../models/client.dart';
import './clientform.dart';

class LoanForm extends ConsumerStatefulWidget {
  const LoanForm({super.key});
  @override
  ConsumerState<LoanForm> createState() => _LoanFormState();
}

class _LoanFormState extends ConsumerState<LoanForm> {
  final _key = GlobalKey<FormState>();
  DateTime? dueDate;
  double? interestRate;
  LoanStatus? loanStatus;
  double? principleAmount;
  Client? clientName;
  String? reason;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final clientList = ref.read(clientProvider);
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _key,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  title: Center(
                    child: Text(
                      'Register Loan',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  content: SizedBox(
                    height: size.height * 0.35,
                    width: size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        AutoSizeText(
                          ' Loan Data',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FormField(
                                isNumber: true,
                                data: IconsaxPlusLinear.money,
                                fieldName: 'principal',
                                onSaved: (value) {
                                  principleAmount = double.parse(value!);
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
                                isNumber: true,
                                data: IconsaxPlusLinear.percentage_square,
                                onSaved: (value) {
                                  interestRate = double.parse(value!);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'required';
                                  }  else {
                                    return null;
                                  }
                                },
                                fieldName: 'interestRate',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FormField(
                                isNumber: false,
                                data: IconsaxPlusLinear.message,
                                onSaved: (value) {
                                  reason = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'required';
                                  } else if (value.length < 5) {
                                    return 'valid reason required';
                                  } else {
                                    return null;
                                  }
                                },
                                fieldName: 'Reason',
                              ),
                            ),
                          ],
                        ),
                        AutoSizeText(
                          'Client Detail',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<Client>(
                                borderRadius: BorderRadius.circular(5),
                                validator: (value) {
                                  if (value == null) {
                                    return 'select client';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {},
                                decoration: InputDecoration(
                                  hintText: 'select client',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  fillColor: Colors.greenAccent.withAlpha(10),
                                ),
                                items: [
                                  for (Client client in clientList)
                                    DropdownMenuItem(
                                      value: client,
                                      child: Text(client.name),
                                    ),
                                ],
                                onChanged: (value) {
                                  clientName = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 735),
                                    ),
                                  );
                                  if (pickedDate.runtimeType == DateTime) {
                                    setState(() {
                                      dueDate = pickedDate;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  fillColor: Colors.greenAccent.withAlpha(10),
                                  hintText: dueDate == null
                                      ? 'due date'
                                      : DateFormat.yMd().format(dueDate!),
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    OutlinedButton.icon(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: const Text('cancel'),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          _key.currentState!.save();
                          try {
                           await ref
                                .read(loanProvider.notifier)
                                .registerLoan(
                                  Loan(
                                    reason: reason!,
                                    client: clientName!.id!,
                                    id: null,
                                    dueDate: dueDate!,
                                    interestRate: interestRate!,
                                    loanStatus: LoanStatus.disbursed,
                                    obtainDate: DateTime.now(),
                                    principleAmount: principleAmount!,
                                    paymentTrack: {
                                      DateTime.now().toIso8601String() : 0,
                                    },
                                  ),
                                );
                          } catch (e) {
                          if(context.mounted)  Navigator.of(context).pop();
                            showErrorMessage(message: e.toString());
                          }
                        }
                      },
                      label: const Text('Apply'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      child: const Text('Apply For Loan'),
    );
  }
}
