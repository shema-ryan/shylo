import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/controllers/userauthenticationcontroller.dart';
import 'package:shylo/models/client.dart';
import 'package:shylo/models/usermodel.dart';
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
    final loggedUser = ref.read(userAuthenticationProvider);
    final clientList = ref.watch(filteredClientProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          spacing: 5,
          children: [
            SizedBox(height: constraints.maxHeight * 0.005),
            Row(
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.3,
                  child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value){
                        ref.read(searchText.notifier).update((state)=> state = value);
                      },
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      fillColor: Theme.of(context).primaryColor.withAlpha(10),
                      prefixIcon: const Icon(
                        IconsaxPlusLinear.search_status,
                        size: 15,
                        color: Colors.grey,
                      ),
                      hintStyle: TextStyle(fontSize: 15),
                      labelText: 'search using customer Id . . . . ',
                    ),
                  ),
                ),
                const Spacer(),
                ClientForm(),
              ],
            ),
            SizedBox(
              height: constraints.maxHeight * 0.9,
              child: clientList.isEmpty
                  ? const Center(child: Text('Client Not Available..'))
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
                            TableHeaderRow(value: 'Nin'),
                            TableHeaderRow(value: 'Address'),
                            TableHeaderRow(value: 'Next of Kin'),
                            if (loggedUser!.roles.contains(
                              UserRoles.administrator,
                            ))
                              TableHeaderRow(value: 'Action'),
                          ],
                        ),
                        for (Client client in clientList)
                          TableRow(
                            children: [
                              GestureDetector(
                                onTap: () => goRouter.go(
                                  '/clientdetailscreen',
                                  extra: client,
                                ),
                                child: TablesRow(
                                  value: 'SHYL/${client.uniqueId}',
                                ),
                              ),

                              TablesRow(
                                value: '${client.surName} ${client.lastName}',
                              ),
                              TablesRow(value: client.nin),
                              TablesRow(value: '0${client.phoneNumber.ceil()}'),
                              TablesRow(value: client.kinName),
                              if (loggedUser.roles.contains(
                                UserRoles.administrator,
                              ))
                                TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    foregroundColor: Colors.redAccent,
                                  ),
                                  onPressed: () async {
                                    ref.read(clientProvider.notifier).deleteClient(id: client.id!);
                                  },
                                  child: const Text('Delete'),
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
