import 'package:mongo_dart/mongo_dart.dart';
enum LoanStatus { disbursed, partial, overDue, complete }
class Loan {
  ObjectId? id;
  final ObjectId client;
  final DateTime obtainDate;
  final DateTime dueDate;
  final double interestRate;
  final LoanStatus loanStatus;
  final double principleAmount;
  final Map<String, double> paymentTrack;
  final String reason;

  Loan({
    required this.reason,
    required this.client,
    required this.id,
    required this.dueDate,
    required this.interestRate,
    required this.loanStatus,
    required this.obtainDate,
    required this.principleAmount,
    required this.paymentTrack,
  });
  Loan.fromJson(Map<String, dynamic> loanJson)
    : id = loanJson['_id'],
      obtainDate = DateTime.parse(loanJson['obtainDate']),
      dueDate = DateTime.parse(loanJson['dueDate']),
      interestRate = loanJson['interestRate'],
      principleAmount = loanJson['principleAmount'],
      loanStatus = LoanStatus.values.toList().firstWhere(
        (status) => status.name == loanJson['loanStatus'],
      ),
      client = loanJson['clientId'],
      paymentTrack = (loanJson['paymentTrack'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, double.parse(value.toString())),
      ),
      reason = loanJson['reason'];

  Map<String, dynamic> loanToJson() => {
    if (id != null) 'id': id,
    'clientId': client,
    'reason': reason,
    'dueDate': dueDate.toIso8601String(),
    'interestRate': interestRate,
    'loanStatus': loanStatus.name,
    'obtainDate': obtainDate.toIso8601String(),
    'principleAmount': principleAmount,
    'paymentTrack': paymentTrack,
  };
}
