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
  final Map<DateTime , bool> paymentTracker;
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
      paymentTracker = investorJson['paymentTracker'];

  Map<String, dynamic> investorToJson() => {
    if (id != null) '_id': id,
    'name': name,
    'email': email,
    'ninNumber': ninNumber,
    'amount': amount,
    'telephoneNumber': telephoneNumber,
    'interestRate': interestRate,
    'date': date.toIso8601String(),
    'payment': paymentTracker,
  };
}
