import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/models/loan.dart';


class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final List<Loan> _loansList = [];
  late StreamSubscription subscription;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  subscription = DbController.database.db!.collection('loanCollection').watch([
      {
        r'$match': {
          'operationType': {
            r'$in': ['insert', 'update', 'delete'],
          },
        },
      },
    ], changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup')).listen((data){
      print('a loan has been added to the list');
   if(data.fullDocument != null)   _loansList.insert(0, Loan.fromJson(data.fullDocument!));
    });

  }
  @override
  void dispose(){
    subscription.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [for (Loan loan in _loansList) Text(loan.reason)],
    );
  }
}
