import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:shylo/controllers/investorcontroller.dart';
import 'package:shylo/models/investor.dart';
import 'package:shylo/models/moneyformat.dart';
import 'package:shylo/routes.dart';
import 'package:shylo/screens/loandetailscreen.dart' show LoanDetailField;
import 'package:shylo/widgets/success.dart';
import 'package:shylo/widgets/tableheaderrow.dart';
import 'package:shylo/widgets/tablerow.dart';

class InvestorDetailScreen extends ConsumerWidget {
  final ObjectId id;
  InvestorDetailScreen({super.key, required this.id});
  final amountController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
     final investor = ref.watch(investorProvider).firstWhere((investor)=> investor.id == id);
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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
                    'Cash out',
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
                      try {
                        if ((investor.totalIncome() -
                                investor.calculatePayout()) <
                            double.parse(amountController.text)) {
                          showErrorMessage(
                            message:
                                'amount can\'t be greater than available balance',
                          );
                        } else {
                          await ref
                              .read(investorProvider.notifier)
                              .updateInvestor(
                                investor: Investor(
                                  paymentTracker: {
                                    ...investor.paymentTracker,
                                    DateTime.now().toIso8601String():
                                        double.parse(amountController.text),
                                  },
                                  id: investor.id,
                                  telephoneNumber: investor.telephoneNumber,
                                  email: investor.email,
                                  interestRate: investor.interestRate,
                                  ninNumber: investor.ninNumber,
                                  name: investor.name,
                                  amount: investor.amount,
                                  date: investor.date,
                                ),
                              );
                        }
                        amountController.clear();
                        if (context.mounted) Navigator.of(context).pop();
                      } catch (e) {
                        //if (context.mounted) Navigator.of(context).pop();
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
        child: Icon(Icons.payment),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(IconsaxPlusLinear.arrow_left),
          onPressed: () {
            goRouter.go(
              '/',
            );
          },
        ),
        title: AutoSizeText(investor.name),
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
                  'InvestorDetails',
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
                      value: '${investor.amount.ceil()} Ugx'.toMoney(),
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.wifi,
                      labelText: 'Interest Rate',
                      value: '${investor.interestRate}',
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.bank,
                      labelText: 'interest per month.',
                      value:
                          '${(investor.amount * investor.interestRate / 100).ceil()} Ugx'
                              .toMoney(),
                    ),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: [
                    LoanDetailField(
                      data: IconsaxPlusBold.calendar,
                      labelText: 'Contract-Date',
                      value: DateFormat.yMd().format(investor.date),
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.activity,
                      labelText: 'Nin number',
                      value: investor.ninNumber,
                    ),
                  ],
                ),

                Text(
                  'Payment Tracker',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
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
                          TableHeaderRow(value: 'Payment Date'),
                          TableHeaderRow(value: 'Amount'),
                          TableHeaderRow(value: 'Received'),
                        ],
                      ),

                      for (var element in investor.paymentTracker.entries)
                        TableRow(
                          children: [
                            TablesRow(
                              value: DateFormat.yMd().format(
                                DateTime.parse(element.key),
                              ),
                            ),
                            TablesRow(
                              value: '${element.value.ceil()} Ugx'.toMoney(),
                            ),
                            const Icon(Icons.check),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
