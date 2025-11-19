import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormField extends StatelessWidget {
  final String initialValue ;
  final bool isNumber;
  final IconData data;
  final Function(String? value) onSaved;
  final Function(String? value) validator;
  final String fieldName;
  const FormField({
    super.key,
    required this.initialValue,
    required this.data,
    required this.onSaved,
    required this.validator,
    required this.fieldName,
    required this.isNumber,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
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
        prefixIcon: Icon(data, color: Colors.black45 , size: 20,),
      ),
    );
  }
}











