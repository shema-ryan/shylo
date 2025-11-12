import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/controllers/loancontroller.dart';
import 'package:shylo/routes.dart';
import 'package:shylo/widgets/loanform.dart';
import 'package:shylo/widgets/tableheaderrow.dart';
import 'package:shylo/widgets/tablerow.dart';

import '../models/loan.dart';

class LoanScreen extends ConsumerStatefulWidget {
  const LoanScreen({super.key});

  @override
  ConsumerState<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends ConsumerState<LoanScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    Future.delayed(Duration.zero, () async {
      await ref.read(loanProvider.notifier).fetchAllLoans();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allLoans = ref.watch(loanProvider);
    return Column(
      children: [
        const SizedBox(height: 5),
        Row(children: [const Spacer(), LoanForm()]),
        const SizedBox(height: 5),
        TabBar(
          labelPadding: const EdgeInsets.symmetric(vertical: 10),
          controller: _tabController,
          tabs: [
            const Text('All loans'),
            const Text('Active'),
            const Text('Partial'),
            const Text('Over due'),
            const Text('Complete'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              LoanItem(loans: allLoans),
              Text('SomeDATA'),
              Text('SomeDATA'),
              Text('SomeDATA'),
              Text('SomeDATA'),
            ],
          ),
        ),
      ],
    );
  }
}

class LoanItem extends StatelessWidget {
  final List<Loan> loans;
  const LoanItem({super.key, required this.loans});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.black12),
                bottom: BorderSide(color: Colors.black12),
              ),
              children: [
                TableRow(
                  children: [
                    TableHeaderRow(value: 'Id'),
                    TableHeaderRow(value: 'Amount'),
                    TableHeaderRow(value: 'Purpose'),
                    TableHeaderRow(value: 'Applied date'),
                    TableHeaderRow(value: 'Due date'),
                  ],
                ),
                for (Loan loan in loans)
                  TableRow(
                    children: [
                      GestureDetector(
                        onTap: () {
                      GoRouter.of(context).go('/loandetailscreen' , extra:loan);
                        },
                        child: TablesRow(
                          value:
                              'Shyl-Ln-${loan.id.toString().substring(15, 30)}',
                        ),
                      ),
                      TablesRow(value: loan.principleAmount.toString()),
                      TablesRow(value: loan.reason),
                      TablesRow(
                        value: DateFormat.yMd().format(loan.obtainDate),
                      ),
                      TablesRow(value: DateFormat.yMd().format(loan.dueDate)),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

