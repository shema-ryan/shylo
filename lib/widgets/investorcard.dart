import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:shylo/controllers/investorcontroller.dart';
import 'package:shylo/widgets/success.dart';

import '../models/investor.dart';
import '../models/moneyformat.dart';

class InvestorCard extends ConsumerWidget {
  const InvestorCard({super.key, required this.investor, required this.height});

  final Investor investor;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: Color.fromARGB(255, 243, 251, 246),
      // shadowColor: Colors.black,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

      // elevation: 1,
      child: Row(
        children: [
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 2,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(IconsaxPlusLinear.user),
                  ),
                  title: Text(
                    investor.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      try {
                        await ref
                            .read(investorProvider.notifier)
                            .deleteInvestor(id: investor.id!);
                      } catch (e) {
                        showErrorMessage(message: e.toString());
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                    child: Text('Delete'),
                  ),
                  subtitle: Text('Full Name'),
                ),
                Divider(indent: 10, endIndent: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Contract Date'),
                        Text(
                          DateFormat.yMEd().format(investor.date),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.01),
                        const Text('Contact'),
                        Text(
                          '+256${investor.telephoneNumber.ceil()}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Nin Number'),
                        Text(
                          investor.ninNumber,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.01),
                        const Text('Email'),
                        Text(
                          investor.email,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                Divider(color: Colors.black12, indent: 10, endIndent: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(' Investement'),
                        Text(
                          ' ${investor.amount} Ugx'.toMoney(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Available balance'),
                        Text(
                          ' ${investor.calculatePayout()} Ugx'.toMoney(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(' Earnings'),
                        Text(
                          ' ${investor.amount * investor.interestRate / 100 * (investor.totalMonth())} Ugx '
                              .toMoney(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
