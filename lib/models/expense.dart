import 'package:mongo_dart/mongo_dart.dart';

enum ExpenseType { salary, normal }

class Expense {
  final ObjectId? id;
  final String name;
  final String reason;
  final double amount;
  final ExpenseType type;
  final DateTime dateTime;
  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.type,
    required this.reason,
  });

  Expense.fromJson(Map<String, dynamic> expenseMap)
    : id = expenseMap['_id'],
      name = expenseMap['name'],
      amount = expenseMap['amount'],
      type = ExpenseType.values.firstWhere(
        (type) => type.name == expenseMap['type'],
      ),
      reason = expenseMap['reason'],
      dateTime = DateTime.parse(expenseMap['date']);

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'name': name,
    'amount': amount,
    'type': type.name,
    'date': dateTime.toIso8601String(),
    'reason': reason,
  };
}
