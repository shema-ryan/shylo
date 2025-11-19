import 'package:flutter/material.dart';
class TableHeaderRow extends StatelessWidget {
  final String value;
  const TableHeaderRow({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      color: Theme.of(context).primaryColor.withAlpha(50),
      child: Text(value),
    );
  }
}