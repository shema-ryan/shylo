import 'package:mongo_dart/mongo_dart.dart';

class Investor {
  final ObjectId? id;
  final double telephoneNumber;
  final String name;
  final String ninNumber;
  final double amount;
  final String email;
  final DateTime date;
  final double interestRate;
  final Map<String, double> paymentTracker;
  const Investor({
    required this.paymentTracker,
    required this.id,
    required this.telephoneNumber,
    required this.email,
    required this.interestRate,
    required this.ninNumber,
    required this.name,
    required this.amount,
    required this.date,
  });

  Investor.fromJson(Map<String, dynamic> investorJson)
    : name = investorJson['name'],
      id = investorJson['_id'],
      telephoneNumber = investorJson['telephoneNumber'],
      email = investorJson['email'],
      interestRate = investorJson['interestRate'],
      amount = investorJson['amount'],
      ninNumber = investorJson['ninNumber'],
      date = DateTime.parse(investorJson['date']),
      paymentTracker = (investorJson['paymentTracker'] as Map<String, dynamic>)
          .map((date, amount) => MapEntry(date, amount));
  Map<String, dynamic> investorToJson() => {
    if (id != null) '_id': id,
    'name': name,
    'email': email,
    'ninNumber': ninNumber,
    'amount': amount,
    'telephoneNumber': telephoneNumber,
    'interestRate': interestRate,
    'date': date.toIso8601String(),
    'paymentTracker': paymentTracker,
  };

  double calculatePayout(){
     double amount = 0 ;
     paymentTracker.forEach((date , payment){
      amount += payment;
     });
    return amount ;
  }

  int totalMonth(){
   final results = DateTime.now().difference(date);
     return (results.inDays / 30).floor() ;
  }
}
