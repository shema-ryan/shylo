import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' hide Center;
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/controllers/loancontroller.dart';
import 'package:shylo/controllers/userauthenticationcontroller.dart';
import 'package:shylo/models/moneyformat.dart';
import 'package:shylo/widgets/success.dart';
import 'package:shylo/widgets/tableheaderrow.dart';
import 'package:shylo/widgets/tablerow.dart';
import '../models/loan.dart';

class LoanDetailScreen extends ConsumerWidget {
  final ObjectId id;
  LoanDetailScreen({super.key, required this.id});
  final TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allLoans = ref.watch(loanProvider);
    final loan = allLoans.firstWhere((element) => element.id == id);

    final allClient = ref
        .watch(clientProvider);

        final client = allClient.firstWhere((element) {
          print('element id ${element.id} isnt equal ${loan.client}'); 
          return element.id== loan.client;
        });
    var clienPaymentDates = loan.paymentTrack.keys;
    var clientPaymentAmount = loan.paymentTrack.values;

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        child: const Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha(100),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Make Payment',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: Colors.white),
                  ),
                ),
              ),
              content: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: 'amount'),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withAlpha(100),
                  ),
                  onPressed: () async {
                    if (amountController.value.text.isNotEmpty) {
                      if ((ref
                                  .read(loanProvider.notifier)
                                  .calculateBalance(loan: loan) -
                              double.parse(amountController.value.text))
                          .isNegative) {
                        Navigator.of(context).pop();
                        showErrorMessage(
                          message: 'amount must be less than balance',
                        );
                        return;
                      }
                      try {
                        await ref
                            .read(loanProvider.notifier)
                            .updatePayment(
                              Loan(
                                remarks: loan.remarks,
                                collateral: loan.collateral,
                                loanId: loan.loanId,
                                reason: loan.reason,
                                client: loan.client,
                                id: loan.id,
                                dueDate: loan.dueDate,
                                interestRate: loan.interestRate,
                                loanStatus: loan.loanStatus,
                                obtainDate: loan.obtainDate,
                                principleAmount: loan.principleAmount,
                                paymentTrack: {
                                  ...loan.paymentTrack,
                                  DateTime.now().toIso8601String():
                                      double.parse(amountController.text),
                                },
                              ),
                            );
                        amountController.clear();
                        if (context.mounted) Navigator.of(context).pop();
                      } catch (e) {
                        if (context.mounted) Navigator.of(context).pop();
                        showErrorMessage(message: e.toString());
                      }
                    }
                  },
                  child: const Text('Pay'),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withAlpha(100),
        leading: GestureDetector(
          child: Icon(IconsaxPlusLinear.arrow_left),
          onTap: () {
            GoRouter.of(context).go(
              '/homescreen',
              extra: {
                'userModel': ref.read(userAuthenticationProvider),
                'selectedIndex': 2,
              },
            );
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,

        title: Text('Shyl/LN/${loan.loanId}'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  'LoanData',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.0005),
                Row(
                  spacing: 5,
                  children: [
                    LoanDetailField(
                      data: IconsaxPlusLinear.bank,
                      labelText: 'principle',
                      value: '${loan.principleAmount} Ugx'.toMoney(),
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.wifi,
                      labelText: 'Interest Rate',
                      value: loan.interestRate.toString(),
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.bank,
                      labelText: 'Amount',
                      value:
                          '${ref.read(loanProvider.notifier).amountTopay(loan)} Ugx'
                              .toMoney(),
                    ),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: [
                    LoanDetailField(
                      data: IconsaxPlusBold.calendar,
                      labelText: 'Applied-Date',
                      value: DateFormat.yMd().format(loan.obtainDate),
                    ),
                    LoanDetailField(
                      data: IconsaxPlusBold.calendar,
                      labelText: 'Due-Date ',
                      value: DateFormat.yMd().format(loan.dueDate),
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          final pickedDate = await showDatePicker(
                            context: context,
                            firstDate: loan.dueDate,
                            lastDate: DateTime.now().add(
                              const Duration(days: 366),
                            ),
                          );
                          if (pickedDate == null) {
                          } else {
                            await ref
                                .read(loanProvider.notifier)
                                .updateLoanDate(id: id, dueDate: pickedDate);
                            showSuccessMessage(
                              message: 'Due Date updated Sucessfully.',
                            );
                          }
                        } catch (e) {
                          showErrorMessage(message: e.toString());
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  'ClientData',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.0005),
                Row(
                  spacing: 5,
                  children: [
                    LoanDetailField(
                      data: IconsaxPlusLinear.user,
                      labelText: 'clientName',
                      value: '${client.surName} ${client.lastName}',
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.location_add,
                      labelText: 'location',
                      value: client.currentLocation,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.call_calling,
                      labelText: 'phoneNumber',
                      value: '0${client.phoneNumber.ceil()}',
                    ),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: [
                    LoanDetailField(
                      data: IconsaxPlusLinear.user,
                      labelText: 'kinName',
                      value: client.kinName,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.location,
                      labelText: 'kin-location',
                      value: client.kinLocation,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.call_calling,
                      labelText: 'kin-phoneNumber',
                      value: '0${client.kinNumber.ceil()}',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Tracker',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Balance Tracker',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: height * 0.2,
                      width: width * 0.45,
                      child: Table(
                        border: TableBorder(
                          bottom: BorderSide(color: Colors.black45),
                        ),
                        children: [
                          TableRow(
                            children: [
                              TableHeaderRow(value: 'Payment Date'),
                              TableHeaderRow(value: 'Amount'),
                            ],
                          ),
                          for (var i = 0; i < clientPaymentAmount.length; i++)
                            TableRow(
                              children: [
                                TablesRow(
                                  value: DateFormat.yMd().format(
                                    DateTime.parse(
                                      clienPaymentDates.toList()[i],
                                    ),
                                  ),
                                ),
                                TablesRow(
                                  value:
                                      '${clientPaymentAmount.toList()[i]} Ugx'
                                          .toMoney(),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: height * 0.2,
                      width: width * 0.45,
                      child: Table(
                        border: TableBorder(
                          bottom: BorderSide(color: Colors.black45),
                        ),
                        children: [
                          TableRow(
                            children: [
                              TableHeaderRow(value: 'Balance'),
                              TableHeaderRow(value: 'OverDue'),
                            ],
                          ),

                          TableRow(
                            children: [
                              TablesRow(
                                value:
                                    '${ref.read(loanProvider.notifier).calculateBalance(loan: loan)} Ugx'
                                        .toMoney(),
                              ),
                              TablesRow(value: '0'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LoanDetailField extends StatelessWidget {
  final IconData data;
  final String labelText;
  final String value;
  const LoanDetailField({
    super.key,
    required this.data,
    required this.labelText,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        readOnly: true,
        initialValue: value,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          fillColor: Colors.greenAccent.withAlpha(10),
          label: Text(labelText),
          prefixIcon: Icon(data, color: Colors.black45, size: 15),
        ),
      ),
    );
  }
}
