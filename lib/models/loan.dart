import 'package:mongo_dart/mongo_dart.dart';

enum LoanStatus { disbursed, partial, overDue, complete }

class Loan {
  final double loanId;
  ObjectId? id;
  final ObjectId client;
  final DateTime obtainDate;
  final DateTime dueDate;
  final double interestRate;
  final LoanStatus loanStatus;
  final double principleAmount;
  final Map<String, double> paymentTrack;
  final String reason;
  final String collateral;
  final String remarks;

  Loan({
    required this.remarks,
    required this.loanId,
    required this.reason,
    required this.client,
    required this.id,
    required this.dueDate,
    required this.interestRate,
    required this.loanStatus,
    required this.obtainDate,
    required this.principleAmount,
    required this.paymentTrack,
    required this.collateral,
  });
  Loan.fromJson(Map<String, dynamic> loanJson)
    : id = loanJson['_id'],
      collateral = loanJson['collateral'],
      remarks = loanJson['remarks'],
      loanId = loanJson['loanId'] ,
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
    'loanId': loanId,
    'clientId': client,
    'reason': reason,
    'remarks': remarks,
    'collateral': collateral,
    'dueDate': dueDate.toIso8601String(),
    'interestRate': interestRate,
    'loanStatus': loanStatus.name,
    'obtainDate': obtainDate.toIso8601String(),
    'principleAmount': principleAmount,
    'paymentTrack': paymentTrack,
  };
  double calculatePaidAmount() {
    double amount = 0;
    paymentTrack.forEach((_, price) {
      amount += price;
    });
    return amount;
  }

  // calculate balance .
  double calculateTotalAmount() {
    final days = dueDate.difference(obtainDate).inDays;
    return (principleAmount + (principleAmount * (days + 1) * interestRate / 3000)).roundToDouble();
  }

}
