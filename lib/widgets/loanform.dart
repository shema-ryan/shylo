import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:shylo/models/moneyformat.dart';
import 'package:shylo/widgets/success.dart';
import '../controllers/loancontroller.dart';
import 'package:shylo/models/loan.dart';
import '../controllers/clientcontroller.dart';
import '../models/client.dart';
import 'formfield.dart';

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
  String? collateral;
  String? remarks;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final clientList = ref.read(clientProvider);
    return ElevatedButton.icon(
      icon: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          barrierDismissible: false,
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
                      'Loan Card',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  content: SizedBox(
                    height: size.height * 0.5,
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
                                initialValue: '',
                                isNumber: true,
                                data: IconsaxPlusLinear.wallet_add,
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
                                initialValue: '',
                                isNumber: true,
                                data: IconsaxPlusLinear.bitcoin_card,
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
                                fieldName: 'interestRate',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FormField(
                                initialValue: '',
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
                                      child: Text(client.surName),
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
                                      _key.currentState!.save();
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
                                    size: 15,
                                    IconsaxPlusLinear.calendar,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: FormField(
                                initialValue: '',
                                isNumber: false,
                                data: IconsaxPlusLinear.user_tick,
                                fieldName: 'collateral',
                                onSaved: (value) {
                                  collateral = value!;
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
                                data: IconsaxPlusLinear.note_text,
                                onSaved: (value) {
                                  remarks = value!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'required';
                                  } else {
                                    return null;
                                  }
                                },
                                fieldName: 'remarks',
                              ),
                            ),
                          ],
                        ),

                        if (dueDate.runtimeType == DateTime) ...[
                          AutoSizeText(
                            'Estimated PayOut',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),

                          AnimatedContainer(
                            height: dueDate.runtimeType == DateTime ? 40 : 0,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withAlpha(50),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            curve: Curves.easeInBack,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 1),
                            child: AutoSizeText(
                              ' Amount : ${estimatedPayOut(principleAmount!, interestRate!, -DateTime.now().difference(dueDate!).inDays)} Ugx'
                                  .toMoney(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  actions: [
                    if (!isloading)
                      OutlinedButton.icon(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          dueDate = null;
                          Navigator.of(context).pop();
                        },
                        label: const Text('cancel'),
                      ),
                    isloading
                        ? CircularProgressIndicator(strokeWidth: 1)
                        : ElevatedButton.icon(
                            icon: Icon(Icons.save),
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                _key.currentState!.save();
                                try {
                                  setState(() {
                                    isloading = true;
                                  });
                                  final loanId = ref.read(loanProvider).isEmpty
                                      ? 0
                                      : ref.read(loanProvider).last.loanId;
                                  await ref
                                      .read(loanProvider.notifier)
                                      .registerLoan(
                                        Loan(
                                          remarks: remarks!,
                                          collateral: collateral!,
                                          loanId: loanId + 1,
                                          reason: reason!,
                                          client: clientName!.id!,
                                          id: null,
                                          dueDate: dueDate!,
                                          interestRate: interestRate!,
                                          loanStatus: LoanStatus.disbursed,
                                          obtainDate: DateTime.now(),
                                          principleAmount: principleAmount!,
                                          paymentTrack: {
                                            DateTime.now().toIso8601String(): 0,
                                          },
                                        ),
                                      );
                                  dueDate = null;
                                  isloading = false;
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  isloading = false;
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                  showErrorMessage(message: e.toString());
                                }
                              }
                            },
                            label: Text('Save'),
                          ),
                  ],
                ),
              );
            },
          ),
        );
      },
      label: const Text('Add Loan'),
    );
  }
}

double estimatedPayOut(double amount, double rate, int days) {
  return amount + (amount * rate / 3000 * (days + 1)).roundToDouble();
}
