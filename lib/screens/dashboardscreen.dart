import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:shylo/models/loan.dart';
import 'package:shylo/widgets/tableheaderrow.dart';
import 'package:shylo/widgets/tablerow.dart';

import '../controllers/clientcontroller.dart';
import '../controllers/investorcontroller.dart';
import '../controllers/loancontroller.dart';
import '../models/moneyformat.dart';
import '../widgets/dashboardcard.dart';

class DashBoardScreen extends ConsumerWidget {
  const DashBoardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    final allClient = ref.watch(clientProvider);
    ref.watch(investorProvider);
    final allLoans = ref.watch(loanProvider);
    final results = allLoans.where(
      (element) =>
          element.loanStatus == LoanStatus.partial ||
          element.loanStatus == LoanStatus.disbursed,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            SizedBox(
              height: height * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DashBoardCard(
                    color: Colors.green,
                    data: IconsaxPlusBroken.dollar_square,
                    title: 'Total Outstandings',
                    subtitle:
                        '${ref.read(loanProvider.notifier).outStandingbalance()} Ugx'
                            .toMoney(),
                  ),
                  DashBoardCard(
                    color: Colors.orange,
                    data: IconsaxPlusBroken.people,
                    title: 'Total Borrowers',
                    subtitle: '${allClient.length}',
                  ),
                  DashBoardCard(
                    color: Colors.blue,
                    data: IconsaxPlusBroken.wallet_minus,
                    title: 'Active Loans',
                    subtitle: '${results.length}',
                  ),
                  DashBoardCard(
                    color: Colors.teal,
                    data: IconsaxPlusBroken.trend_up,
                    title: 'Total Investement',
                    subtitle:
                        '${ref.read(investorProvider.notifier).calculateInvestement()}'
                            .toMoney(),
                  ),
                ],
              ),
            ),
            AutoSizeText(
              'Recent Loans',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: height * 0.65,
              child: Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey),

                  bottom: BorderSide(color: Colors.grey),
                ),
                children: [
                  TableRow(
                    children: [
                      TableHeaderRow(value: 'Name'),
                      TableHeaderRow(value: 'Amount'),
                      TableHeaderRow(value: 'Rate'),
                      TableHeaderRow(value: 'Due date'),
                      TableHeaderRow(value: 'E Amount'),
                    ],
                  ),
                  for (var loan in results)
                    TableRow(
                      children: [
                        TablesRow(
                          value:
                              '${allClient.firstWhere((element) => element.id == loan.client).surName} ${allClient.firstWhere((element) => element.id == loan.client).lastName}',
                        ),
                        TablesRow(
                          value: '${loan.principleAmount} Ugx'.toMoney(),
                        ),
                        TablesRow(value: '${loan.interestRate}'),
                        TablesRow(
                          value: DateFormat.yMd().format(loan.obtainDate),
                        ),
                        TablesRow(
                          value:
                              '${ref.read(loanProvider.notifier).amountTopay(loan)} Ugx'
                                  .toMoney(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
