import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:shylo/controllers/userauthenticationcontroller.dart';
import 'package:shylo/models/investor.dart';
import 'package:shylo/models/moneyformat.dart';
import 'package:shylo/routes.dart';
import 'package:shylo/screens/loandetailscreen.dart' show LoanDetailField;
import 'package:shylo/widgets/tableheaderrow.dart';
import 'package:shylo/widgets/tablerow.dart';

class InvestorDetailScreen extends ConsumerWidget {
  final Investor investor;
  const InvestorDetailScreen({super.key, required this.investor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userAuthenticationProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(IconsaxPlusLinear.arrow_left),
          onPressed: () {
            goRouter.go(
              '/homescreen',
              extra: {'userModel': user, 'selectedIndex': 3},
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

              for(var element in investor.paymentTracker.entries)   TableRow(
                        children: [
                          TablesRow(
                            value: DateFormat.yMd().format(DateTime.parse(element.key)),
                          ),
                          TablesRow(
                            value: '${element.value.ceil()} Ugx'
                                .toMoney(),
                          ),
                         const Icon(IconsaxPlusLinear.shield_tick)
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
