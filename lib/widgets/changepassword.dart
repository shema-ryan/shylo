import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mongo_dart/mongo_dart.dart' hide Center;
import 'package:shylo/controllers/usergroupcontroller.dart';
import 'package:shylo/widgets/success.dart';

class ChangePassWordForm extends ConsumerStatefulWidget {
  final ObjectId objectId;
  const ChangePassWordForm({super.key, required this.objectId});
  @override
  ConsumerState<ChangePassWordForm> createState() => _InvestorFormState();
}

class _InvestorFormState extends ConsumerState<ChangePassWordForm> {
  final _key = GlobalKey<FormState>();
  String? passWord;
  String? checkPassWord;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              _key.currentState!.save();
              if (_key.currentState!.validate()) {
                try {
                  await ref
                      .read(userGroupProvider.notifier)
                      .changePassWord(
                        objectId: widget.objectId,
                        passWord: passWord!,
                      );
                  if (context.mounted) Navigator.of(context).pop();
                  showSuccessMessage(message: 'PassWord updated Successfully.');
                } catch (e) {
                  showErrorMessage(message: e.toString());
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
        title: Center(
          child: Text(
            'Reset Password',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        content: SizedBox(
          height: size.height * 0.15,
          width: size.width * 0.5,
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                AutoSizeText(
                  'PassWord Details',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          }
                          return null;
                        },

                        onSaved: (value) {
                          passWord = value;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          fillColor: Colors.greenAccent.withAlpha(10),
                          label: const Text('password'),
                          prefixIcon: Icon(
                            IconsaxPlusLinear.lock,
                            color: Colors.black45,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          } else if (value != passWord) {
                            return 'passWord mismatch';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          checkPassWord = value;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          fillColor: Colors.greenAccent.withAlpha(10),
                          label: const Text('Re-type password'),
                          prefixIcon: const Icon(
                            IconsaxPlusLinear.lock,
                            color: Colors.black45,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
