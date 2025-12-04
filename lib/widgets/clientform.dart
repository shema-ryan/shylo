import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/clientcontroller.dart';
import '../models/client.dart';
import 'success.dart';
import '../widgets/formfield.dart' ;

class ClientForm extends ConsumerStatefulWidget {
  const ClientForm({super.key});
  @override
  ConsumerState<ClientForm> createState() => _ClientFormState();
}
class _ClientFormState extends ConsumerState<ClientForm> {
  final _key = GlobalKey<FormState>();
  String? name;
  String? email;
  double? phoneNumber;
  bool? isMale;
  String? currentLocation;
  double? privatePhoneNumber;
  String? kinName;
  double? kinPhoneNumber;
  String? kinLocation;
  String? relation;
  String? nin;
  String? kinNin;
  String? lastName;
  MartialStatus? status;
  String? guaranterName;
  String? guaranterNin;
  double? guaranterPhoneNumber;

  @override
  Widget build(BuildContext context) {
    final  listClient = ref.read(clientProvider);
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final width = constraints.maxWidth;
              return Material(
                color: Colors.transparent,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  title: Center(
                    child: Text(
                      'Client Card',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  content: SizedBox(
                    height: height * 0.9,
                    width: width * 0.7,
                    child: Form(
                      key: _key,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            AutoSizeText(
                              'Bio Data',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: FormField(
                                  
                                    isNumber: false,
                                    data: IconsaxPlusLinear.user_add,
                                    fieldName: 'surName',
                                    onSaved: (value) {
                                      name = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else if (value.length < 3) {
                                        return 'minimum 4 characters';
                                      } else {
                                        return null;
                                      }
                                    }, initialValue: '',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                  Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: false,
                                    data: IconsaxPlusLinear.user_add,
                                    fieldName: 'lastName',
                                    onSaved: (value) {
                                      lastName = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else if (value.length < 3) {
                                        return 'minimum 4 characters';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: true,
                                    data: IconsaxPlusLinear.call,
                                    onSaved: (value) {
                                      phoneNumber = double.parse(value!);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else if (value.length < 10) {
                                        return 'provide a valid number';
                                      } else {
                                        return null;
                                      }
                                    },
                                    fieldName: 'phoneNumber',
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                                    
                            Row(
                              children: [
                                Expanded(
                                  child: FormField(initialValue: '',

                                    isNumber: false,
                                    data: IconsaxPlusLinear.card,
                                    onSaved: (value) {
                                      nin = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else if (value.length < 14) {
                                        return 'provide a valid nin';
                                      } else {
                                        return null;
                                      }
                                    },
                                    fieldName: 'Nin number',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonFormField<MartialStatus>(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'martial status';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      status = value!;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'martial status',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      fillColor: Colors.greenAccent.withAlpha(10),
                                    ),
                                    items: List.generate(
                                      MartialStatus.values.length,
                                      (index) => DropdownMenuItem(
                                        value: MartialStatus.values
                                            .toList()[index],
                                        child: Text(
                                          MartialStatus.values
                                              .toList()[index]
                                              .name,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      status = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                                     
                            Row(
                              children: [
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: false,
                                    data: IconsaxPlusLinear.message,
                                    fieldName: 'email',
                                    onSaved: (value) {
                                      email = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else if (!value.contains('@')) {
                                        return 'valid email required';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonFormField<bool>(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'select Gender';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      isMale = value!;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'gender',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      fillColor: Colors.greenAccent.withAlpha(10),
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: true,
                                        child: const Text('Male'),
                                      ),
                                      DropdownMenuItem(
                                        value: false,
                                        child: const Text('Female'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      isMale = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            AutoSizeText(
                              'Address',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: false,
                                    data: IconsaxPlusLinear.location,
                                    fieldName: 'location',
                                    onSaved: (value) {
                                      currentLocation = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: true,
                                    data: IconsaxPlusLinear.call_received,
                                    fieldName: 'private phone',
                                    onSaved: (value) {
                                      privatePhoneNumber = (value == null)
                                          ? 0123
                                          : double.parse(value);
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            AutoSizeText(
                              'Next Of Kin',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: false,
                                    data: IconsaxPlusLinear.user_add,
                                    fieldName: 'name',
                                    onSaved: (value) {
                                      kinName = value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else if (value.length < 3) {
                                        return 'minimum 4 characters';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: true,
                                    data: IconsaxPlusLinear.call,
                                    onSaved: (value) {
                                      kinPhoneNumber = double.parse(value!);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else if (value.length < 10) {
                                        return 'provide a valid number';
                                      } else {
                                        return null;
                                      }
                                    },
                                    fieldName: 'phoneNumber',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: false,
                                    data: IconsaxPlusLinear.card,
                                    onSaved: (value) {
                                      kinNin = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else if (value.length < 14) {
                                        return 'provide a valid nin';
                                      } else {
                                        return null;
                                      }
                                    },
                                    fieldName: 'Nin number',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: false,
                                    data: IconsaxPlusLinear.location,
                                    onSaved: (value) {
                                      kinLocation = value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else {
                                        return null;
                                      }
                                    },
                                    fieldName: 'location',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: false,
                                    data: IconsaxPlusLinear.people,
                                    onSaved: (value) {
                                      relation = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else {
                                        return null;
                                      }
                                    },
                                    fieldName: 'relation',
                                  ),
                                ),
                              ],
                            ),
                                AutoSizeText(
                              'Guaranter',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                             Row(
                              children: [
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: false,
                                    data: IconsaxPlusLinear.user,
                                    onSaved: (value) {
                                      guaranterName= value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else {
                                        return null;
                                      }
                                    },
                                    fieldName: 'g-name',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: false,
                                    data: IconsaxPlusLinear.card_edit,
                                    onSaved: (value) {
                                      guaranterNin= value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else {
                                        return null;
                                      }
                                    },
                                    fieldName: 'guaranterNin',
                                  ),
                                ),
                                 const SizedBox(width: 10),
                                Expanded(
                                  child: FormField(
                                    initialValue: '',
                                    isNumber: true,
                                    data: IconsaxPlusLinear.call_outgoing,
                                    onSaved: (value) {
                                      guaranterPhoneNumber=  double.parse(value!);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      } else {
                                        return null;
                                      }
                                    },
                                    fieldName: 'phoneNumber',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    OutlinedButton.icon(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: const Text('cancel'),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          _key.currentState!.save();
                          final unique =  listClient.isEmpty ? 1.0 : listClient.last.uniqueId + 1;
                          try {
                            await ref
                                .read(clientProvider.notifier)
                                .addClient(
                                  Client(
                                    guaranterPhoneNumber: guaranterPhoneNumber!,
                                    guaranterNin: guaranterNin!,
                                    guaranterName: guaranterName!,
                                    uniqueId: unique,
                                    lastName: lastName!,
                                    status: status!,
                                    id: null,
                                    surName: name!,
                                    phoneNumber: phoneNumber!,
                                    currentLocation: currentLocation!,
                                    email: email!,
                                    gender: isMale!,
                                    kinLocation: kinLocation!,
                                    kinName: kinName!,
                                    kinNumber: kinPhoneNumber!,
                                    kinRelation: relation!,
                                    privatePhoneNumber: privatePhoneNumber!,
                                    nin: nin!,
                                    kinNin: kinNin!,
                                  ),
                                );
                            showSuccessMessage(
                              message: '$name has been added Sucessfully.',
                            );
                            _key.currentState!.reset();
                            if (context.mounted) Navigator.of(context).pop();
                          } catch (e) {
                            if (context.mounted) Navigator.of(context).pop();
                            showErrorMessage(message: e.toString());
                          }
                        }
                      },
                      label: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      child: const Text('Add client'),
    );
  }
}

