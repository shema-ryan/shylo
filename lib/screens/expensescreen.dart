import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:shylo/controllers/expensecontroller.dart';
import 'package:shylo/controllers/useraccountcontroller.dart';
import 'package:shylo/models/moneyformat.dart';
import 'package:shylo/models/usermodel.dart';
import 'package:shylo/widgets/expenseform.dart';
import 'package:shylo/widgets/tableheaderrow.dart';
import 'package:shylo/widgets/tablerow.dart';

import '../models/expense.dart';

class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allExpenses = ref.watch(filteredExpenses);
    final loggedUser = ref.read(userAccountProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        return Padding(
          padding: EdgeInsets.only(
            top: height * 0.005,
            left: width * 0.005,
            right: width * 0.005,
          ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Expense Screen' , style: TextTheme.of(context).titleMedium!.copyWith(fontWeight: FontWeight.bold),),
              Text('Manage all expense in on place.' , style: Theme.of(context).textTheme.bodySmall,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: width * 0.3,
                    child: TextField(
                      onChanged: (value) {
                        ref.read(searchExpenseController.notifier).state =
                            value;
                      },
                      decoration: InputDecoration(
                        constraints: BoxConstraints(maxHeight: 40),
                        filled: true,
                        fillColor: Theme.of(context).primaryColor.withAlpha(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Icon(
                          IconsaxPlusLinear.search_favorite,
                          size: 15,
                        ),
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: 'search . . . . .',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(minimumSize: Size(200, 45)),
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => ExpenseForm(),
                      );
                    },
                    label: const AutoSizeText('Add Expense'),
                  ),
               
                ],
              ),
                SizedBox(height: height * 0.005,),
              allExpenses.isEmpty
                  ? const Center(child: Text('No Expense Recorded Today..'))
                  : Flexible(
                      fit: FlexFit.tight,
                      child: Table(
                        border: TableBorder(
                          horizontalInside: BorderSide(color: Colors.black12),
                          bottom: BorderSide(color: Colors.black12),
                        ),
                        children: [
                          TableRow(
                            children: [
                              TableHeaderRow(value: 'Name'),
                              TableHeaderRow(value: 'Type'),
                              TableHeaderRow(value: 'Reason'),
                              TableHeaderRow(value: 'Amount'),
                              TableHeaderRow(value: 'Date'),
                        if(loggedUser!.userRoles.contains(UserRoles.administrator))      TableHeaderRow(value: 'Action'),
                            ],
                          ),
                          for (Expense expense in allExpenses)
                            TableRow(
                              children: [
                                TablesRow(value: expense.name),
                                TablesRow(value: expense.type.name),
                                TablesRow(value: expense.reason),
                                TablesRow(
                                  value: '${expense.amount} Ugx'.toMoney(),
                                ),
                                TablesRow(
                                  value: DateFormat.yMd().format(
                                    expense.dateTime,
                                  ),
                                ),
                                     if(loggedUser.userRoles.contains(UserRoles.administrator))        Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      ref
                                          .read(expenseProvider.notifier)
                                          .deleteExpense(expense.id!);
                                    },
                                    child: const Icon(
                                      IconsaxPlusLinear.trash,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
