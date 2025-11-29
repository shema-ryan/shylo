import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/widgets/clienteditform.dart';


import '../controllers/userauthenticationcontroller.dart';
import 'loandetailscreen.dart';

class ClientDetailScreen extends ConsumerWidget {
  final ObjectId id;
  const ClientDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedClient = ref
        .watch(clientProvider)
        .firstWhere((element) => element.id == id);
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ClientEditForm(client: selectedClient),
          );
        },
        child: const Icon(Icons.edit),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withAlpha(100),
        leading: GestureDetector(
          child: Icon(IconsaxPlusLinear.arrow_left),
          onTap: () {
            GoRouter.of(context).go(
              '/homescreen',
              extra: {
                'userModel': ref.read(userAuthenticationProvider),
                'selectedIndex': 1,
              },
            );
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,

        title: Text('SHYL/${selectedClient.uniqueId}'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  'Bio Data',
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
                      labelText: 'Name',
                      value:
                          '${selectedClient.surName} ${selectedClient.lastName}',
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.message,
                      labelText: 'email',
                      value: selectedClient.email,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.call,
                      labelText: 'phone Number',
                      value: '0${selectedClient.phoneNumber}',
                    ),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: [
                    LoanDetailField(
                      data: IconsaxPlusBold.location,
                      labelText: 'current location',
                      value: selectedClient.currentLocation,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusBold.aquarius,
                      labelText: 'gender',
                      value: selectedClient.gender ? 'Male' : 'Female',
                    ),
                    LoanDetailField(
                      data: IconsaxPlusBold.woman,
                      labelText: 'Martial Status',
                      value: selectedClient.status.name,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusBold.airdrop,
                      labelText: 'Nin number',
                      value: selectedClient.nin,
                    ),
                  ],
                ),
                Text(
                  'Next kin',
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
                      labelText: 'kin Name',
                      value: selectedClient.kinName,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.location_add,
                      labelText: 'phone Number',
                      value: '0${selectedClient.kinNumber.ceil()}',
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.shield_cross,
                      labelText: 'Relation',
                      value: selectedClient.kinRelation,
                    ),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: [
                    LoanDetailField(
                      data: IconsaxPlusLinear.user,
                      labelText: 'kin Nin',
                      value: selectedClient.kinNin,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.location,
                      labelText: 'kin-location',
                      value: selectedClient.kinLocation,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.call_calling,
                      labelText: 'kin-phoneNumber',
                      value: '0${selectedClient.kinNumber.ceil()}',
                    ),
                  ],
                ),
                Text(
                  'Guaranter',
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
                      labelText: 'guaranter Name',
                      value: selectedClient.guaranterName,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.card_add,
                      labelText: 'guaranter Nin',
                      value: selectedClient.guaranterNin,
                    ),
                    LoanDetailField(
                      data: IconsaxPlusLinear.call,
                      labelText: 'Phone number',
                      value: '0${selectedClient.guaranterPhoneNumber.ceil()}',
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
