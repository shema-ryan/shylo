import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:shylo/controllers/usergroupcontroller.dart';
import 'package:shylo/widgets/changepassword.dart';
import 'package:shylo/widgets/success.dart';
import 'package:shylo/widgets/tableheaderrow.dart';
import 'package:shylo/widgets/tablerow.dart';
import 'package:shylo/widgets/useraccountform.dart';
import '../models/usermodel.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        await ref.read(userGroupProvider.notifier).fetchAllUserAccount();
      } catch (e) {
        showErrorMessage(message: e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAccounts = ref.watch(filteredUserProvider);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
       
        children: [
          Text(
            'User Management.',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          AutoSizeText(
            'Manage your team members and their account permission here.',
          ),
          const SizedBox(height: 50),
          Row(
            textBaseline: TextBaseline.alphabetic,
            spacing: 10,
            children: [
              AutoSizeText(
                'All Users : ',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (value){
                    ref.read(searchProvider.notifier).state = value ;
                  },
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxHeight: 40),

                    contentPadding: EdgeInsets.zero,
                    prefixIcon: const Icon(
                      IconsaxPlusLinear.search_normal,
                      size: 17,
                    ),
                    labelText: 'search . . . .',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => UserAccountForm(),
                    );
                  },
                  label: const Text('Add User'),
                ),
              ),
            ],
          ),

       userAccounts.isEmpty ? Center(child: const Text('\n\n\n\nNo user found'),):   Expanded(
            child: Table(
              columnWidths: {
                0: FixedColumnWidth(150),
                5: FixedColumnWidth(100),
                2: FixedColumnWidth(120),
              },
              border: const TableBorder(
                horizontalInside: BorderSide(color: Colors.black12),
                bottom: BorderSide(color: Colors.black12),
              ),
              children: [
                TableRow(
                  children: [
                    TableHeaderRow(value: 'userName'),
                    TableHeaderRow(value: 'email'),
                    TableHeaderRow(value: 'Contact'),
                    TableHeaderRow(value: 'created At'),
                    TableHeaderRow(value: 'roles'),
                    TableHeaderRow(value: 'Actions'),
                  ],
                ),
                 ...userAccounts.map((account) {
                  bool isAdmin = account.userRoles.contains(
                    UserRoles.administrator,
                  );
                  bool isLoanOfficer = account.userRoles.contains(
                    UserRoles.loanofficer,
                  );
                  bool isInvestor = account.userRoles.contains(
                    UserRoles.investor,
                  );
                  return TableRow(
                    children: [
                      TablesRow(value: account.userName),
                      TablesRow(value: account.email),
                      TablesRow(value: '0${account.phoneNumber.ceil()}'),
                      TablesRow(value: DateFormat.yMEd().format(account.date)),
                      Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: Row(
                              children: [
                                Text('A'),
                                Checkbox(
                                  value: isAdmin,
                                  onChanged: (value) async {
                                    isAdmin = value!;
                                    await ref
                                        .read(userGroupProvider.notifier)
                                        .updateUserRights(
                                          id: account.objectId!,
                                          userRoles: [
                                            if (isAdmin)
                                              UserRoles.administrator,
                                            if (isLoanOfficer)
                                              UserRoles.loanofficer,
                                            if (isInvestor) UserRoles.investor,
                                          ],
                                        );
                                 
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: Row(
                              children: [
                                Text('L'),
                                Checkbox(
                                  value: isLoanOfficer,
                                  onChanged: (value) async {
                                    isLoanOfficer = value!;
                                    try {
                                      await ref
                                          .read(userGroupProvider.notifier)
                                          .updateUserRights(
                                            id: account.objectId!,
                                            userRoles: [
                                              if (isAdmin)
                                                UserRoles.administrator,
                                              if (isLoanOfficer)
                                                UserRoles.loanofficer,
                                              if (isInvestor)
                                                UserRoles.investor,
                                            ],
                                          );
                                  
                                    } catch (e) {
                                      showErrorMessage(message: e.toString());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: Row(
                              children: [
                                const Text('I'),
                                Checkbox(
                                  value: isInvestor,
                                  onChanged: (value) async {
                                    isInvestor = value!;
                                    try {
                                      await ref
                                          .read(userGroupProvider.notifier)
                                          .updateUserRights(
                                            id: account.objectId!,
                                            userRoles: [
                                              if (isAdmin)
                                                UserRoles.administrator,
                                              if (isLoanOfficer)
                                                UserRoles.loanofficer,
                                              if (isInvestor)
                                                UserRoles.investor,
                                            ],
                                          );
                                
                                    } catch (e) {
                                      showErrorMessage(message: e.toString());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      PopupMenuButton(
                        position: PopupMenuPosition.under,
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        initialValue: 0,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            onTap: () async {
                              try {
                                await ref
                                    .read(userGroupProvider.notifier)
                                    .deleteUserAccount(account.objectId!);
                                showSuccessMessage(
                                  message:
                                      '${account.userName} has been remove successfully.',
                                );
                              } catch (e) {
                                showErrorMessage(message: e.toString());
                              }
                            },
                            child: const Text('Delete'),
                          ),
                          PopupMenuItem(
                            value: 1,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => ChangePassWordForm(
                                  objectId: account.objectId!,
                                ),
                              );
                            },
                            child: const Text('Change passWord'),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
