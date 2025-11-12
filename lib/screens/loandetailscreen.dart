import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/widgets/tableheaderrow.dart';
import 'package:shylo/widgets/tablerow.dart';
import '../models/loan.dart';

class LoanDetailScreen extends ConsumerWidget {
  final Loan loan;
  const LoanDetailScreen({super.key, required this.loan});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final client =ref.read(clientProvider).firstWhere((element)=>element.id == loan.client);
    final clienPaymentDates = loan.paymentTrack.keys;
    final clientPaymentAmount = loan.paymentTrack.values;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
     
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text('Shyl-Ln-${loan.id.toString().substring(15, 30)}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              'LoanData',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5,),
            Row(
              spacing: 5,
              children: [
                LoanDetailField(
                  data: IconsaxPlusLinear.bank,
                  labelText: 'principle',
                  value: loan.principleAmount.toString(),
                ),
                LoanDetailField(
                  data: IconsaxPlusLinear.wifi,
                  labelText: 'Interest Rate',
                  value: loan.interestRate.toString(),
                ),
                LoanDetailField(
                  data: IconsaxPlusLinear.bank,
                  labelText: 'Amount',
                  value: '${loan.principleAmount * loan.interestRate}',
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
              ],
            ),
             Text(
              'ClientData',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5,),
            Row(
              spacing: 5,
              children: [
                LoanDetailField(
                  data: IconsaxPlusLinear.user,
                  labelText: 'clientName',
                  value: client.name,
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
                  value: '0${client.kinNumber}',
                ),
              ],
            ),
              Text(
              'Payment Tracker',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                SizedBox(  
                  height: 200,
                  width: 500,
                  child: Table(
                    border: TableBorder(
                      bottom: BorderSide(color: Colors.black45)
                    ),
                    children: [
                      TableRow(children: [
                        TableHeaderRow(value: 'Payment Date'),
                        TableHeaderRow(value: 'Amount'),
                      ]),
                    for(var i = 0 ; i <clientPaymentAmount.length ;i++) TableRow(
                      children: [
                        TablesRow(value: DateFormat.yMd().format(DateTime.parse(clienPaymentDates.toList()[i]))),
                        TablesRow(value: '${clientPaymentAmount.toList()[i]}')
                      ]
                    )
                    ],
                  ),
                )
              ],
            )

          ],
        ),
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
