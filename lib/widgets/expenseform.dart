import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shylo/controllers/expensecontroller.dart';
import 'package:shylo/models/exception.dart';
import 'package:shylo/models/expense.dart';
import 'package:shylo/widgets/formfield.dart';
import 'package:shylo/widgets/success.dart';

class ExpenseForm extends ConsumerStatefulWidget {
  const ExpenseForm({super.key});

  @override
  ConsumerState<ExpenseForm> createState() => _InvestorFormState();
}

class _InvestorFormState extends ConsumerState<ExpenseForm> {
  final _key = GlobalKey<FormState>();

  String? name;
  double? amount;
  String? reason;
  ExpenseType? type;

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
              if (_key.currentState!.validate()) {
                _key.currentState!.save();
                try {
                  await ref
                      .read(expenseProvider.notifier)
                      .addExpense(
                        Expense(
                          id: null,
                          name: name!,
                          amount: amount!,
                          dateTime: DateTime.now(),
                          type: type!,
                          reason: reason!,
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
            'Expense Card',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        content: SizedBox(
          height: size.height * 0.4,
          width: size.width * 0.5,
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  ' Information Details',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  spacing: 10,
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

                    Expanded(
                      child: FormField(
                        initialValue: '',
                        isNumber: true,
                        data: IconsaxPlusLinear.money_recive,
                        onSaved: (value) {
                          amount = double.parse(value!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          } else if (value.length < 2) {
                            return 'valid amount';
                          } else {
                            return null;
                          }
                        },
                        fieldName: 'amount',
                      ),
                    ),
                    Expanded(
                      child: DropdownMenuFormField<ExpenseType>(
                        width: size.width * 0.18,
                        alignmentOffset: Offset(0, 5),
                        inputDecorationTheme: InputDecorationTheme(
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
                        ),
                        validator: (value) {
                          type = value!;
                          return null;
                        },
                        onSaved: (value) {
                          type = value!;
                        },
                        onSelected: (value) {
                          type = value!;
                        },
                        enableSearch: true,
                        initialSelection: ExpenseType.normal,
                        dropdownMenuEntries: ExpenseType.values
                            .map(
                              (element) => DropdownMenuEntry(
                                leadingIcon: Icon(
                                  IconsaxPlusLinear.play,
                                  size: 15,
                                ),
                                value: element,
                                label: element.name,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),

                AutoSizeText(
                  'Comment Details',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  maxLines: 4,
                  initialValue: '',

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required';
                    }
                    return null;
                  },

                  onSaved: (value) {
                    reason = value!;
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
                    label: Text('Reason'),

                    suffixIcon: Icon(
                      IconsaxPlusLinear.note,
                      color: Colors.black45,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
