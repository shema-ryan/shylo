import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/models/client.dart';
import 'package:shylo/routes.dart';
import 'package:shylo/widgets/success.dart';
import '../widgets/clientform.dart';
import '../widgets/tableheaderrow.dart';
import '../widgets/tablerow.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        await ref.read(clientProvider.notifier).fetchAllClient();
      } catch (e) {
        showErrorMessage(message: e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final clientList = ref.watch(clientProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          spacing: 10,
          children: [
            SizedBox(height: constraints.maxHeight * 0.005),
            Row(children: [const Spacer(), ClientForm()]),
            SizedBox(
              height: constraints.maxHeight * 0.915,
              child: clientList.isEmpty
                  ? const Center(child: Text('No Client Received Today.'))
                  : Table(
                      border: TableBorder(
                        borderRadius: BorderRadius.circular(5),
                        top: BorderSide(color: Colors.black12),
                        right: BorderSide(color: Colors.black12),
                        left: BorderSide(color: Colors.black12),
                        bottom: BorderSide(color: Colors.black12),
                        horizontalInside: BorderSide(color: Colors.black12),
                        verticalInside: BorderSide(color: Colors.black12),
                      ),
                      children: [
                        TableRow(
                          children: [
                            TableHeaderRow(value: 'Customer ID'),
                            TableHeaderRow(value: 'CustomerName'),
                            TableHeaderRow(value: 'Email'),
                            TableHeaderRow(value: 'Address'),
                            TableHeaderRow(value: 'Next of Kin'),
                          ],
                        ),
                        for (Client client in clientList)
                          TableRow(
                            children: [
                              GestureDetector(
                                onTap: ()=> goRouter.go('/clientdetailscreen', extra: client),
                                child: TablesRow(value: 'SHYL/${client.uniqueId}')),

                              TablesRow(value: '${client.surName} ${client.lastName}'),
                              TablesRow(value: client.email),
                              TablesRow(value: '0${client.phoneNumber.ceil()}'),
                              TablesRow(value: client.kinName),
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
