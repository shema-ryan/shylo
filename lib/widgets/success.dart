import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shylo/main.dart';

void showSuccessMessage({required String message}) =>
    scaffoldMessenger.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5)),
        content: AutoSizeText(message ,  style: const TextStyle(color: Colors.white),)));
        
void showErrorMessage({required String message})=>  scaffoldMessenger.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5)),
        content: Center(child: AutoSizeText(message , style: const TextStyle(color: Colors.white),))));


