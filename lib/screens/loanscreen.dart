import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/controllers/loancontroller.dart';
import 'package:shylo/controllers/loansearchcontroller.dart';
import 'package:shylo/models/moneyformat.dart';
import 'package:shylo/models/pdfgenerator.dart';
import 'package:shylo/widgets/loanform.dart';
import 'package:shylo/widgets/success.dart';
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
      await ref.read(clientProvider.notifier).fetchAllClient();
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
              LoanItem(
                loans: allLoans
                    .where((test) => test.loanStatus == LoanStatus.disbursed)
                    .toList(),
              ),
              LoanItem(
                loans: allLoans
                    .where(
                      (element) => element.loanStatus == LoanStatus.partial,
                    )
                    .toList(),
              ),
              LoanItem(
                loans: allLoans
                    .where(
                      (element) => element.loanStatus == LoanStatus.overDue,
                    )
                    .toList(),
              ),
              LoanItem(
                loans: allLoans
                    .where(
                      (element) => element.loanStatus == LoanStatus.complete,
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoanItem extends ConsumerWidget {
  final List<Loan> loans;
  const LoanItem({super.key, required this.loans});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredLoans = ref.watch(filteredProvider(loans));
    final allClients = ref.read(clientProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 5,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        onChanged: (value) {
                          ref
                              .read(searchProvider.notifier)
                              .update((_) => value);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).primaryColor.withAlpha(10),
                          labelText: 'search with name .  .  .  .  .  .  ',

                          prefixIcon: Icon(
                            IconsaxPlusBroken.search_normal,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        try {
                          await PdfCreator.generateLoansReport(
                            loans: filteredLoans,
                            identifier: filteredLoans[0].loanStatus.name,
                            clients: allClients,
                          );
                          showSuccessMessage(
                            message: 'Report generated Successfully..',
                          );
                        } catch (e) {
                          showErrorMessage(message: e.toString());
                        }
                      },
                      label: const Text('Generate report'),
                      icon: const Icon(Icons.file_upload),
                    ),
                  ],
                ),
                Expanded(
                  child: filteredLoans.isEmpty
                      ? const Center(child: Text('No Loan Available.'))
                      : Table(
                          border: TableBorder(
                            horizontalInside: BorderSide(color: Colors.black12),
                            bottom: BorderSide(color: Colors.black12),
                          ),
                          children: [
                            TableRow(
                              children: [
                                const TableHeaderRow(value: 'Id'),
                                TableHeaderRow(value: 'Amount'),
                                TableHeaderRow(value: 'Full Payment'),
                                TableHeaderRow(value: 'Purpose'),
                                TableHeaderRow(value: 'Applied date'),
                                TableHeaderRow(value: 'Due date'),
                              ],
                            ),
                            for (Loan loan in filteredLoans)
                              TableRow(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      GoRouter.of(
                                        context,
                                      ).go('/loandetailscreen', extra: loan);
                                    },
                                    child: TablesRow(
                                      value: 'SHY-LN-${loan.loanId}',
                                    ),
                                  ),
                                  TablesRow(
                                    value: '${loan.principleAmount} Ugx'
                                        .toMoney(),
                                  ),
                                  TablesRow(
                                    value:
                                        '${ref.read(loanProvider.notifier).amountTopay(loan)} Ugx'
                                            .toMoney(),
                                  ),
                                  TablesRow(value: loan.reason),
                                  TablesRow(
                                    value: DateFormat.yMd().format(
                                      loan.obtainDate,
                                    ),
                                  ),
                                  TablesRow(
                                    value: DateFormat.yMd().format(
                                      loan.dueDate,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
