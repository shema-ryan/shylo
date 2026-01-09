import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/controllers/useraccountcontroller.dart';
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
    final loggedUser = ref.read(userAccountProvider);
    final clientList = ref.watch(filteredClientProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        
            children: [
            
              Text('Clients Screen.' , style: TextTheme.of(context).titleMedium!.copyWith(fontWeight: FontWeight.bold),),
              Text('Manage all clients in one place' , style: TextTheme.of(context).bodySmall,),
                   SizedBox(height:constraints. maxHeight * 0.005,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.3,
                    child: TextField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value){
                          ref.read(searchText.notifier).update((state)=> state = value);
                        },
                      decoration: InputDecoration(
                        constraints: BoxConstraints(maxHeight: 40),
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
                        labelStyle: TextTheme.of(context).bodyMedium,
                        labelText: 'search with Id . . . . ',
                      ),
                    ),
                  ),
                   const SizedBox(width: 10,),
                  ClientForm(),
                ],
              ),
              SizedBox(height:constraints. maxHeight * 0.005,),
              SizedBox(
                height: constraints.maxHeight * 0.8,
                child: clientList.isEmpty
                    ? const Center(child: Text('Client Not Available..'))
                    : Table(
                        border: TableBorder(     
                          bottom: BorderSide(color: Colors.black12),
                          horizontalInside: BorderSide(color: Colors.black12),
                         
                        ),
                        children: [
                          TableRow(
                            children: [
                              TableHeaderRow(value: 'Customer ID'),
                              TableHeaderRow(value: 'CustomerName'),
                              TableHeaderRow(value: 'Nin'),
                              TableHeaderRow(value: 'Address'),
                              TableHeaderRow(value: 'Next of Kin'),
                              if (loggedUser!.userRoles.contains(
                                UserRoles.administrator,
                              ))
                                TableHeaderRow(value: 'Action'),
                            ],
                          ),
                          for (Client client in clientList)
                            TableRow(
                              children: [
                                GestureDetector(
                                  onTap: () => goRouter.push(
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
                                if (loggedUser.userRoles.contains(
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
          ),
        );
      },
    );
  }
}
