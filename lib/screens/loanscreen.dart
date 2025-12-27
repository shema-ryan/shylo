import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' hide Center;
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/controllers/loancontroller.dart';
import 'package:shylo/controllers/loansearchcontroller.dart';
import 'package:shylo/models/exception.dart';
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
  late StreamSubscription _subscription;
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
  void didChangeDependencies() {
    _subscription = DbController.database.db!
        .collection('loanCollection')
        .watch(
          changeStreamOptions: ChangeStreamOptions(
            fullDocument: 'updateLookup',
          ),
          [
            {
              r'$match': {
                'operationType': {
                  r'$in': ['insert', 'delete', 'update'],
                },
              },
            },
          ],
        )
        .listen(
          (data) {
            // let's validate if it exist to avoid duplication
            final Loan obtainedLoan = Loan.fromJson(data.fullDocument!);
            if (!ref.read(loanProvider).contains(obtainedLoan)) {
              ref.read(loanProvider.notifier).registerLoan(obtainedLoan);
            }
          },
          onError: (error) {
            showErrorMessage(message: error.toString());
          },
        );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subscription.cancel();
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

class LoanItem extends ConsumerStatefulWidget {
  final List<Loan> loans;
  const LoanItem({super.key, required this.loans});
  @override
  ConsumerState createState() => _LoanItem();
}

class _LoanItem extends ConsumerState<LoanItem> {
  DateTime? firstDate;
  DateTime? lastDate;
  @override
  Widget build(BuildContext context) {
    final filteredLoans = ref.watch(filteredProvider((firstdate: firstDate , lastDate:lastDate ,allLoans: widget.loans)));
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
                      width: constraints.maxWidth * 0.25,
                      child: TextField(
                        style: TextStyle(fontSize: 15),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          if (firstDate != null && lastDate == null) {
                            showErrorMessage(
                              message: 'please select last date',
                            );
                          } else {
                            ref
                                .read(searchProvider.notifier)
                                .update((_) => value);
                          }
                        },
                        decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: 40),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          filled: true,

                          fillColor: Theme.of(
                            context,
                          ).primaryColor.withAlpha(10),
                          labelText: 'search. . . ',
                          prefixIcon: Icon(
                            IconsaxPlusBroken.search_normal,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.25,
                      child: TextFormField(
                        style: const TextStyle(fontSize: 15),

                        onTap: () async {
                          firstDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 7320),
                            ),
                            lastDate: DateTime.now(),
                          );
                          if (firstDate != null) {
                            setState(() {});
                          }
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: firstDate == null
                              ? ''
                              : DateFormat.yMd().format(firstDate!),
                          constraints: BoxConstraints(maxHeight: 40),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          filled: true,

                          fillColor: Theme.of(
                            context,
                          ).primaryColor.withAlpha(10),
                          labelText: firstDate == null ? 'first date' : null,
                          prefixIcon: Icon(
                            IconsaxPlusBroken.calendar_2,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.25,
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(fontSize: 15),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {},
                        onTap: () async {
                                try {
                                  if(firstDate == null) throw MyException(message: 'please select firstDate');
                                  lastDate = await showDatePicker(
                                    context: context,
                                    firstDate: firstDate!,
                                    lastDate: DateTime.now().add(const Duration(days: 2)),
                                  );
                                  if (lastDate != null) {
                                    setState(() {});

                                    // await ref
                                    //     .read(loanProvider.notifier)
                                    //     .selectBaseOnDate(
                                    //       firstDate: firstDate!,
                                    //       lastDate: lastDate!,
                                    //     );
                                  }
                                } catch (e) {
                                  showErrorMessage(message: e.toString());
                                }
                              }
                          ,
                        decoration: InputDecoration(
                          hintText: lastDate == null
                              ? ''
                              : DateFormat.yMd().format(lastDate!),
                          constraints: BoxConstraints(maxHeight: 40),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          filled: true,

                          fillColor: Theme.of(
                            context,
                          ).primaryColor.withAlpha(10),
                          labelText: 'last date',
                          prefixIcon: Icon(
                            IconsaxPlusBroken.calendar_2,
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
                                const TableHeaderRow(value: 'Client name'),
                                const TableHeaderRow(value: 'Amount'),
                                const TableHeaderRow(value: 'Full Payment'),
                                const TableHeaderRow(value: 'Purpose'),
                                const TableHeaderRow(value: 'Applied date'),
                                const TableHeaderRow(value: 'Due date'),
                              ],
                            ),
                            for (Loan loan in filteredLoans)
                              TableRow(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      GoRouter.of(
                                        context,
                                      ).push('/loandetailscreen', extra: loan);
                                    },
                                    child: TablesRow(
                                      value: 'SHY-LN-${loan.loanId}',
                                    ),
                                  ),
                                  TablesRow(
                                    value: ref
                                        .read(clientProvider.notifier)
                                        .getUserName(loan.client),
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
