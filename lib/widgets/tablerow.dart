import'package:flutter/material.dart';
class TablesRow extends StatelessWidget {
  final String value;
  const TablesRow({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Center(child: Text(value)),
    );
  }
}