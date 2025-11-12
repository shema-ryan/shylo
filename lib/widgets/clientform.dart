import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/clientcontroller.dart';
import '../models/client.dart';
import 'success.dart';
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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Material(
            color: Colors.transparent,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              title: Center(
                child: Text(
                  'Register Client',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: SizedBox(
                height: 600,
                width: 800,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      AutoSizeText(
                        'Bio Data',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormField(
                              isNumber: false,
                              data: IconsaxPlusLinear.user_add,
                              fieldName: 'name',
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
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormField(
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
                          Expanded(
                            child: FormField(
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
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormField(
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormField(
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormField(
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
                              isNumber: false,
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
                    ],
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
                      try {
                        await ref
                            .read(clientProvider.notifier)
                            .addClient(
                              Client(
                                id: null,
                                name: name!,
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
          ),
        );
      },
      child: const Text('Add client'),
    );
  }
}

class FormField extends StatelessWidget {
  final bool isNumber;
  final IconData data;
  final Function(String? value) onSaved;
  final Function(String? value) validator;
  final String fieldName;
  const FormField({
    super.key,
    required this.data,
    required this.onSaved,
    required this.validator,
    required this.fieldName,
    required this.isNumber,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : null,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      validator: (value) {
        return validator(value);
      },

      onSaved: (value) {
        onSaved(value);
      },
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
        label: Text(fieldName),
        prefixIcon: Icon(data, color: Colors.black45),
      ),
    );
  }
}