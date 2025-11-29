import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shylo/controllers/clientcontroller.dart';

import 'formfield.dart';
import '../models/client.dart';
import 'success.dart';

class ClientEditForm extends ConsumerStatefulWidget {
  final Client client;
  const ClientEditForm({super.key, required this.client});

  @override
  ConsumerState<ClientEditForm> createState() => _ClientEditFormState();
}

class _ClientEditFormState extends ConsumerState<ClientEditForm> {
  final _key = GlobalKey<FormState>();

  String? email;
  double? phoneNumber;

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
    return LayoutBuilder(
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
                'Client Editor Card',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            content: SizedBox(
              height: height * 0.5,
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormField(
                              initialValue: '0${widget.client.phoneNumber.ceil()}',
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
                            child: DropdownButtonFormField<MartialStatus>(
                              initialValue: widget.client.status,
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
                                  value: MartialStatus.values.toList()[index],
                                  child: Text(
                                    MartialStatus.values.toList()[index].name,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                status = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormField(
                              initialValue: widget.client.email,
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
                              initialValue: widget.client.currentLocation,
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
                              initialValue:
                                  '0${widget.client.privatePhoneNumber.ceil()}',
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
                              initialValue: widget.client.kinName,
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
                              initialValue: '0${widget.client.kinNumber.ceil()}',
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
                              initialValue: widget.client.kinNin,
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
                              initialValue: widget.client.kinLocation,
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
                              initialValue: widget.client.kinRelation,
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
                          .updateClient(
                            client: Client(
                              guaranterPhoneNumber:
                                  widget.client.guaranterPhoneNumber,
                              guaranterNin: widget.client.guaranterNin,
                              guaranterName: widget.client.guaranterName,
                              uniqueId: widget.client.uniqueId,
                              status: status!,
                              id: widget.client.id,
                              lastName: widget.client.lastName,
                              surName: widget.client.surName,
                              phoneNumber: phoneNumber!,
                              currentLocation: currentLocation!,
                              email: email!,
                              gender: widget.client.gender,
                              kinLocation: kinLocation!,
                              kinName: kinName!,
                              kinNumber: kinPhoneNumber!,
                              kinRelation: relation!,
                              privatePhoneNumber: privatePhoneNumber!,
                              nin: widget.client.nin,
                              kinNin: kinNin!,
                            ),
                          );
                      if (context.mounted) Navigator.of(context).pop();
                      showSuccessMessage(
                        message:
                            '${widget.client.surName} has been updated successfully.',
                      );
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
    );
  }
}
